//
//  BetaRenderer.swift
//  SceneKit RT
//
//  Created by Philipp Zay on 16.04.22.
//

import MetalKit
import MetalPerformanceShaders
import simd
import os
import GameplayKit

// NEW
private let MaxFrames = 3
private let kLastOpenedScene = "last.opened.scene"
private let kGeometry = "geometry"
// private let kReferenceImage = "reference-image"
private let kCamera = "camera"
private let kCameraOrigin = "origin"
private let kCameraTarget = "target"
private let kCameraUp = "up"
private let kCameraFOV = "fov"


//enum RendererInitError: Error {
//    case noDevice
//    case noLibrary
//    case noQueue
//    case errorCreatingBuffer
//}

class AdvancedRenderer: NSObject, MTKViewDelegate {

    var view: MTKView! = nil        // Harry
    // let device: MTLDevice
    // let queue: MTLCommandQueue
    // let library: MTLLibrary

    var frameSemaphore:DispatchSemaphore! = nil // Harry
    var device: MTLDevice? = nil
    var commandQueue: MTLCommandQueue? = nil
    var defaultLibrary: MTLLibrary? = nil
    var outputImage: MTLTexture? = nil
    // let environmentMap: MTLTexture? = nil
    // let referenceImage: MTLTexture? = nil
    var blitPipelineState: MTLRenderPipelineState? = nil
    var rayBuffer: MTLBuffer? = nil
    var lightSamplingRayBuffer: MTLBuffer? = nil
    var intersectionBuffer: MTLBuffer? = nil
    var lightSamplingIntersectionBuffer: MTLBuffer? = nil

    var rayGenerator: MTLComputePipelineState? = nil
    var intersectionHandler: MTLComputePipelineState? = nil
    var lightSamplingGenerator: MTLComputePipelineState? = nil
    var lightSamplingHandler: MTLComputePipelineState? = nil
    var accumulation: MTLComputePipelineState? = nil
    var noise = [MTLBuffer?](repeating: nil, count: MaxFrames)
    var appData = [MTLBuffer?](repeating: nil, count: MaxFrames)
    
    var accelerationStructure: MPSTriangleAccelerationStructure? = nil
    var rayIntersector: MPSRayIntersector? = nil
    var lightIntersector: MPSRayIntersector? = nil

    // let geometryProvider: GeometryProvider // replaced by new method
    // var camera: Camera! = nil // Harry
    var camera = AdvancedCamera() // Harry

    var outputImageSize = MTLSize() // Harry
    var rayCount = UInt32() // Harry
    var frameContinuousIndex = UInt32() // Harry
    // var comparisonMode = UInt32() // Harry
    var startupTime = CFTimeInterval()  // Harry
    var lastFrameTime = CFTimeInterval()  // Harry
    var lastFrameDuration = CFTimeInterval()  // Harry
    var raytracingPaused = Bool()  // Harry
    var restartTracing = Bool()  // Harry
    
    // NEW Phil Test
    var vertices = [simd_float3]()
    var indices  = [UInt32]()
    var normals  = [simd_float3]()
    var uvCoords = [simd_float2]()
    var colours  = [simd_float3]()
    var masks    = [uint]() // 0 = Light, 1 = Box, 2 = Object
    
    var vertexData              = [Vertex]() // vertices, normals, uvCoords // colors are not handled for the moment
    var indexData               = [UInt32]() // indices
    var triangleData            = [Triangle]() // to determine triangle of light, box or object (from masks array)
    var emitterTriangleData     = [EmitterTriangle]() // Light Source
    var materialData            = [Material]()
    
    var _triangleCount          = 0
    var _emitterTriangleCount:UInt32 = 0
    
    var vertexBuffer            : MTLBuffer? = nil
    var indexBuffer             : MTLBuffer? = nil
    var materialBuffer          : MTLBuffer? = nil
    var triangleBuffer          : MTLBuffer? = nil
    var emitterTriangleBuffer   : MTLBuffer? = nil
    

    // random obj-c - not used
    // static std::mt19937 randomGenerator;
    // static std::uniform_real_distribution<float> uniformFloatDistribution(0.0f, 1.0f);
    
    init(withMetalKitView view: MTKView) throws {
        super.init()
        
        self.view = view
        guard let device = view.device else { throw RendererInitError.noDevice }
        self.device = device
        os_log("Metal device name is %s", device.name)
        
        // device = view.device
        frameSemaphore = DispatchSemaphore(value: MaxFrames)
        commandQueue = device.makeCommandQueue()
        defaultLibrary = device.makeDefaultLibrary()
        
        /*
                 * Create blit render pipeline state
                 * which outputs ray-tracing result to the screen
                 */
        do {
            // let error: Error? = nil
            let blitPipelineDescriptor = MTLRenderPipelineDescriptor()
            blitPipelineDescriptor.vertexFunction = defaultLibrary?.makeFunction(name: "blitVertex")
            blitPipelineDescriptor.fragmentFunction = defaultLibrary?.makeFunction(name: "blitFragment")
            blitPipelineDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat
            blitPipelineDescriptor.depthAttachmentPixelFormat = view.depthStencilPixelFormat
            do {
                blitPipelineState = try device.makeRenderPipelineState(descriptor: blitPipelineDescriptor)
            } catch {
                // print("\(error)"), by Phil, not used
            }
        }
        
        //  Converted to Swift 5.1 by Swiftify v5.1.33805 - https://objectivec2swift.com/
        rayGenerator = newComputePipeline(withFunctionName: "generateRays")
        intersectionHandler = newComputePipeline(withFunctionName: "handleIntersections")
        lightSamplingGenerator = newComputePipeline(withFunctionName: "generateLightSamplingRays")
        lightSamplingHandler = newComputePipeline(withFunctionName: "lightSamplingHandler")
        accumulation = newComputePipeline(withFunctionName: "accumulateImage")

        let noiseBufferLength = Int(NOISE_BLOCK_SIZE * NOISE_BLOCK_SIZE) * MemoryLayout<RandomSample>.size
        for i in 0..<Int(MaxFrames) {
            noise[i] = device.makeBuffer(length: noiseBufferLength, options: .storageModeShared)
            appData[i] = device.makeBuffer(length: MemoryLayout<ApplicationData>.size, options: .storageModeShared)
        }

        initializeRayTracingWithRecent()
        
        
    }
    
    func frameIndex() -> UInt32 {
        return UInt32(frameContinuousIndex % UInt32(MaxFrames))
    }
    
    func initializeRayTracingWithRecent() {
        var lastOpenedScene = UserDefaults.standard.string(forKey: kLastOpenedScene)

        lastOpenedScene = nil

        if lastOpenedScene == nil {
            // lastOpenedScene = Bundle.main.path(forResource: "media/cornellbox-water-spheres", ofType: "json")
            lastOpenedScene = Bundle.main.path(forResource: "media/cornellbox-water-spheres", ofType: "obj")
        }

        initializeRayTracing(withFile: lastOpenedScene)
    }
    
    func initializeRayTracing(withFile fileName: String?) {
        raytracingPaused = true
        restartTracing = true

        let hasCustomCamera = false // required? fix!
        // var geometryFile = fileName
        // let referenceFile: String? = nil
        
        // referenceImage = TextureProvider
        // loadFile(referenceFile.fileSystemRepresentation, device)
        
//        environmentMap = nil
//        if geometryProvider.environment().textureName().empty() == false {
//            var textureName = "\(geometryProvider.environment().textureName().c_str())"
//            textureName = URL(fileURLWithPath: URL(fileURLWithPath: geometryFile).deletingLastPathComponent().absoluteString).appendingPathComponent(textureName).absoluteString
//            environmentMap = TextureProvider
//            loadFile((textureName as NSString).fileSystemRepresentation, device)
//        }
        
        // HERE Stich together the whole geometry
        vertices.removeAll()
        indices.removeAll()
        normals.removeAll()
        uvCoords.removeAll()
        colours.removeAll()
        masks.removeAll() // 0 = Light, 1 = Box, 2 = Object
        
        // Make Light // Make Box // Make Object
        createScene() // in GeometryProvider.swift
        
        // fill new Buffers
        geometryProvider()
        
        // Make Buffers
        indexBuffer             = makeIndexBuffer()
        vertexBuffer            = makeVertexBuffer()
        materialBuffer          = makeMaterialsBuffer()
        triangleBuffer          = makeTriangleBuffer()
        emitterTriangleBuffer   = makeEmitterTriangleBuffer()
        
        
        // ************
        
        
        accelerationStructure = MPSTriangleAccelerationStructure(device: device!)
        accelerationStructure?.vertexBuffer = vertexBuffer
        accelerationStructure?.vertexStride = MemoryLayout<Vertex>.size
        accelerationStructure?.indexBuffer = indexBuffer
        accelerationStructure?.indexType = .uInt32
        accelerationStructure?.triangleCount = vertices.count / 3 //  geometryProvider.triangleCount()
        accelerationStructure?.rebuild()
        
        rayIntersector = MPSRayIntersector(device: device!)
        rayIntersector?.rayDataType = .originMinDistanceDirectionMaxDistance
        rayIntersector?.rayStride = MemoryLayout<AdvancedRay>.size
        rayIntersector?.intersectionDataType = .distancePrimitiveIndexCoordinates
        rayIntersector?.intersectionStride = MemoryLayout<MPSIntersectionDistancePrimitiveIndexCoordinates>.size // MemoryLayout<Intersection>.size
        rayIntersector?.cullMode = .none
        //using Intersection = MPSIntersectionDistancePrimitiveIndexCoordinates;
        
        lightIntersector = MPSRayIntersector(device: device!)
        lightIntersector?.rayDataType = .originMinDistanceDirectionMaxDistance
        lightIntersector?.rayStride = MemoryLayout<LightSamplingRay>.size
        lightIntersector?.intersectionDataType = .distancePrimitiveIndex
        lightIntersector?.intersectionStride = MemoryLayout<MPSIntersectionDistancePrimitiveIndex>.size // MemoryLayout<LightSamplingIntersection>.size
        lightIntersector?.cullMode = .none
        //using LightSamplingIntersection = MPSIntersectionDistancePrimitiveIndex;
        
        UserDefaults.standard.set(fileName, forKey: kLastOpenedScene)
        UserDefaults.standard.synchronize()

        if hasCustomCamera == false {
//            let bmin = geometryProvider.boundsMin()
//            let bmax = geometryProvider.boundsMax()
//            let maxv = simd_max(simd_abs(bmin), simd_abs(bmax)) as? packed_float3
//            camera.target = Double((bmin + bmax)) * 0.5
//            camera.origin = simd_float3(camera.target.x, camera.target.y, 2.0 * maxv?.z) ?? 0.0
            
            camera.target  = simd_float3(0.0, 1.0, 0.0)
            // camera.origin  = simd_float3(0.0, 1.0, 1.99) // simd_float3(0.0, 1.0, 2.35)
            camera.origin  = simd_float3(cameraShiftX, cameraShiftY, cameraDistanceZ)
            camera.fov     = Float(45 * Float.pi / 180.0) // Float(90 * Float.pi / 180.0)
            camera.up      = simd_float3(0.0, 1.0, 0.0)
        }
        
        raytracingPaused = false
        
        print("leaving renderer initialization")
        
    }
    
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
        print("entering drawable size will change")
        
        outputImageSize.width = Int(size.width / CGFloat(CONTENT_SCALE))
        outputImageSize.height = Int(size.height / CGFloat(CONTENT_SCALE))
        outputImageSize.depth = 1 // 1.0
        
        let outputImageDescriptor = MTLTextureDescriptor()
        outputImageDescriptor.pixelFormat = .rgba32Float
        outputImageDescriptor.width = outputImageSize.width
        outputImageDescriptor.height = outputImageSize.height
        outputImageDescriptor.usage.insert(.shaderWrite)
        outputImageDescriptor.storageMode = .private
        outputImage = device?.makeTexture(descriptor: outputImageDescriptor)
        
        rayCount = UInt32(outputImageSize.width * outputImageSize.height) // uint32_t(outputImageSize.width) * uint32_t(outputImageSize.height)
        
        rayBuffer = device?.makeBuffer(length: MemoryLayout<AdvancedRay>.size * Int(rayCount), options: .storageModePrivate)
        lightSamplingRayBuffer = device?.makeBuffer(length: MemoryLayout<LightSamplingRay>.size * Int(rayCount), options: .storageModePrivate)
        
        
        // changed Phil
        // intersectionBuffer = device.makeBuffer(length: MemoryLayout<Intersection>.size * rayCount, options: .storageModePrivate)
        // lightSamplingIntersectionBuffer = device.makeBuffer(length: MemoryLayout<LightSamplingIntersection>.size * rayCount, options: .storageModePrivate)
        
        intersectionBuffer = device?.makeBuffer(length: MemoryLayout<MPSIntersectionDistancePrimitiveIndexCoordinates>.size * Int(rayCount), options: .storageModePrivate)
        lightSamplingIntersectionBuffer = device?.makeBuffer(length: MemoryLayout<MPSIntersectionDistancePrimitiveIndex>.size * Int(rayCount), options: .storageModePrivate)
        
        //using Intersection = MPSIntersectionDistancePrimitiveIndexCoordinates;
        //using LightSamplingIntersection = MPSIntersectionDistancePrimitiveIndex;
        
        restartTracing = true
        
        print("leaving drawable size will change")
        
        
    }

    func draw(in view: MTKView) {
        
        let timeout = DispatchTime.now() + Double(1e+9)
        if raytracingPaused || ((frameSemaphore.wait(timeout: timeout) == .success ? 0 : -1) != 0) {
            return
        }

        let commandBuffer = commandQueue?.makeCommandBuffer()
        commandBuffer?.addCompletedHandler({ buffer in
            self.frameSemaphore.signal()
        })
        
        
        if restartTracing {
            startupTime = CACurrentMediaTime()
            
            // Reset Stuff
            // frameIndex = 0 // Added Phil
            AdvancedGameViewController.secondsCounter = 0 // Added Phil
            AdvancedGameViewController.isRenderingProgressCompleted = false // Added Phil
            frameContinuousIndex = 0 // ORIG

            for _ in 0..<Int(MaxFrames) {
                updateBuffers()
            }

            restartTracing = false
        } else if lastFrameTime < CFTimeInterval(MAX_RUN_TIME_IN_SECONDS) {
            updateBuffers()

            /*
                     * Generate rays
                     */
            dispatchComputeShader(rayGenerator, withBuffer: commandBuffer, setupBlock: { commandEncoder in
                commandEncoder?.setBuffer(self.rayBuffer, offset: 0, index: 0)
                commandEncoder?.setBuffer(self.noise[Int(self.frameIndex())], offset: 0, index: 1)
                commandEncoder?.setBuffer(self.appData[Int(self.frameIndex())], offset: 0, index: 2)
            })
            
            // Intersect rays with triangles inside acceleration structure
            rayIntersector?.encodeIntersection(commandBuffer: commandBuffer!,
                                               intersectionType: .nearest,
                                               rayBuffer: rayBuffer!,
                                               rayBufferOffset: 0,
                                               intersectionBuffer: intersectionBuffer!,
                                               intersectionBufferOffset: 0,
                                               rayCount: Int(rayCount),
                                               accelerationStructure: accelerationStructure!)
            
            
            
            if (MAX_PATH_LENGTH > 1) {
                if _emitterTriangleCount > 0 {

                    // Generate light sampling rays
                    dispatchComputeShader(lightSamplingGenerator, withBuffer: commandBuffer, setupBlock: { commandEncoder in
                        // commandEncoder?.setTexture(self.environmentMap, index: 0)
                        commandEncoder?.setBuffer(self.intersectionBuffer, offset: 0, index: 0)
                        commandEncoder?.setBuffer(self.materialBuffer, offset: 0, index: 1)
                        commandEncoder?.setBuffer(self.triangleBuffer, offset: 0, index: 2)
                        commandEncoder?.setBuffer(self.emitterTriangleBuffer, offset: 0, index: 3)
                        commandEncoder?.setBuffer(self.vertexBuffer, offset: 0, index: 4)
                        commandEncoder?.setBuffer(self.indexBuffer, offset: 0, index: 5)
                        commandEncoder?.setBuffer(self.noise[Int(self.frameIndex())], offset: 0, index: 6)
                        commandEncoder?.setBuffer(self.rayBuffer, offset: 0, index: 7)
                        commandEncoder?.setBuffer(self.lightSamplingRayBuffer, offset: 0, index: 8)
                        commandEncoder?.setBuffer(self.appData[Int(self.frameIndex())], offset: 0, index: 9)

                    })
                    
                    // Intersect light sampling rays with geometry
                    lightIntersector?.encodeIntersection(commandBuffer: commandBuffer!,
                                                        intersectionType: .nearest,
                                                        rayBuffer: lightSamplingRayBuffer!,
                                                        rayBufferOffset: 0,
                                                        intersectionBuffer: lightSamplingIntersectionBuffer!,
                                                        intersectionBufferOffset: 0,
                                                        rayCount: Int(rayCount),
                                                        accelerationStructure: accelerationStructure!)
                    
                    // Handle light sampling intersections
                    dispatchComputeShader(lightSamplingHandler, withBuffer: commandBuffer, setupBlock: { commandEncoder in
                        commandEncoder?.setBuffer(self.lightSamplingIntersectionBuffer, offset: 0, index: 0)
                        commandEncoder?.setBuffer(self.lightSamplingRayBuffer, offset: 0, index: 1)
                        commandEncoder?.setBuffer(self.rayBuffer, offset: 0, index: 2)
                        commandEncoder?.setBuffer(self.appData[Int(self.frameIndex())], offset: 0, index: 3)
                    })
                    
                    
                
                }
            }
            

            
            // Handle intersections generate next bounce
            dispatchComputeShader(intersectionHandler, withBuffer: commandBuffer, setupBlock: { commandEncoder in
                // commandEncoder?.setTexture(self.environmentMap, index: 0)
                commandEncoder?.setBuffer(self.intersectionBuffer, offset: 0, index: 0)
                commandEncoder?.setBuffer(self.materialBuffer, offset: 0, index: 1)
                commandEncoder?.setBuffer(self.triangleBuffer, offset: 0, index: 2)
                commandEncoder?.setBuffer(self.emitterTriangleBuffer, offset: 0, index: 3)
                commandEncoder?.setBuffer(self.vertexBuffer, offset: 0, index: 4)
                commandEncoder?.setBuffer(self.indexBuffer, offset: 0, index: 5)
                commandEncoder?.setBuffer(self.noise[Int(self.frameIndex())], offset: 0, index: 6)
                commandEncoder?.setBuffer(self.rayBuffer, offset: 0, index: 7)
                commandEncoder?.setBuffer(self.appData[Int(self.frameIndex())], offset: 0, index: 8)


            })
            
            // Accumulate image
            dispatchComputeShader(accumulation, withBuffer: commandBuffer, setupBlock: { commandEncoder in
                commandEncoder?.setBuffer(self.rayBuffer, offset: 0, index: 0)
                commandEncoder?.setBuffer(self.appData[Int(self.frameIndex())], offset: 0, index: 1)
                commandEncoder?.setTexture(self.outputImage, index: 0)
            })
            
            if Int(Int(frameContinuousIndex) % MaxFrames) == 0 {
                var blitEncoder: MTLRenderCommandEncoder? = nil
                if let currentRenderPassDescriptor = view.currentRenderPassDescriptor {
                    blitEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: currentRenderPassDescriptor)
                }
                blitEncoder?.setFragmentBuffer(appData[Int(self.frameIndex())], offset: 0, index: 0)
                blitEncoder?.setRenderPipelineState(blitPipelineState!)
                blitEncoder?.setFragmentTexture(outputImage, index: 0)
                // blitEncoder?.setFragmentTexture(referenceImage, index: 1)
                blitEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
                blitEncoder?.endEncoding()

                if let currentDrawable = view.currentDrawable {
                    commandBuffer?.present(currentDrawable)
                }

                // NSApp.mainWindow?.title = String(format: "Frame: %u (%.2fms. last frame, %.2fs. elapsed)", frameContinuousIndex, lastFrameDuration * 1000.0, lastFrameTime)
            }
            
            frameContinuousIndex += 1
            
        }
        
        // print("just before command buffer commit")
        commandBuffer?.commit()
        
    }
    
    func newComputePipeline(withFunctionName functionName: String?) -> MTLComputePipelineState? {
        let error: Error? = nil
        let function = defaultLibrary?.makeFunction(name: functionName ?? "")
        var result: MTLComputePipelineState? = nil
        do {
            if let function = function {
                result = try device?.makeComputePipelineState(function: function)
            }
        } catch {
        }
        if error != nil {
            print("Failed to create compute pipeline state with function \(functionName ?? "")")
            if let error = error {
                print("\(error)")
            }
        }
        return result
    }
    
    func dispatchComputeShader(_ pipelineState: MTLComputePipelineState?, withBuffer commandBuffer: MTLCommandBuffer?, setupBlock: @escaping (MTLComputeCommandEncoder?) -> Void) {
        let commandEncoder = commandBuffer?.makeComputeCommandEncoder()
        setupBlock(commandEncoder)
        if let pipelineState = pipelineState {
            commandEncoder?.setComputePipelineState(pipelineState)
        }
        commandEncoder?.dispatchThreads(outputImageSize, threadsPerThreadgroup: MTLSizeMake(16, 4, 1))
        commandEncoder?.endEncoding()
    }
    
    func updateBuffers() {
        
        let numSamples = Int(NOISE_BLOCK_SIZE * NOISE_BLOCK_SIZE)
        let noiseRaw = noise[Int(frameIndex())]?.contents()
        let samples = noiseRaw?.bindMemory(to: RandomSample.self, capacity: numSamples)
        
        let randomness = GKRandomSource.sharedRandom()
        for i in 0..<numSamples {
            let sample = samples! + i // must be at the top
            
            sample.pointee.pixelSample.x          = randomness.nextUniform()
            sample.pointee.pixelSample.y          = randomness.nextUniform()
            sample.pointee.barycentricSample.x    = randomness.nextUniform()
            sample.pointee.barycentricSample.y    = randomness.nextUniform()
            sample.pointee.emitterBsdfSample.x    = randomness.nextUniform()
            sample.pointee.emitterBsdfSample.y    = randomness.nextUniform()
            sample.pointee.bsdfSample.x           = randomness.nextUniform()
            sample.pointee.bsdfSample.y           = randomness.nextUniform()
            sample.pointee.componentSample        = randomness.nextUniform()
            sample.pointee.emitterSample          = randomness.nextUniform()
            sample.pointee.rrSample               = randomness.nextUniform()
            
        }
        
        
//        for i in 0..<numSamples {
//            let sample = samples! + i // must be at the top
//
//            sample.pointee.pixelSample.x          = Float.random(in: 0..<1)
//            sample.pointee.pixelSample.y          = Float.random(in: 0..<1)
//            sample.pointee.barycentricSample.x    = Float.random(in: 0..<1)
//            sample.pointee.barycentricSample.y    = Float.random(in: 0..<1)
//            sample.pointee.emitterBsdfSample.x    = Float.random(in: 0..<1)
//            sample.pointee.emitterBsdfSample.y    = Float.random(in: 0..<1)
//            sample.pointee.bsdfSample.x           = Float.random(in: 0..<1)
//            sample.pointee.bsdfSample.y           = Float.random(in: 0..<1)
//            sample.pointee.componentSample        = Float.random(in: 0..<1)
//            sample.pointee.emitterSample          = Float.random(in: 0..<1)
//            sample.pointee.rrSample               = Float.random(in: 0..<1)
//
//        }
        
        let frameTime = CACurrentMediaTime() - startupTime
        lastFrameDuration = frameTime - lastFrameTime
        lastFrameTime = frameTime
        
        let bufferRaw = appData[Int(frameIndex())]?.contents()
        let appData = bufferRaw?.bindMemory(to: ApplicationData.self, capacity: 1)
        appData?.pointee.environmentColor       = simd_float3(0.0, 0.0, 0.0) // simd_float3(0.5, 0.5, 0.5) // simd_float3(0.3, 0.4, 0.5) // geometryProvider.environment().uniformColor;
        appData?.pointee.emitterTrianglesCount  = _emitterTriangleCount;
        appData?.pointee.frameIndex             = frameContinuousIndex
        appData?.pointee.time                   = Float(frameTime)
        appData?.pointee.enableLightSampling    = isLightSamplingEnabled
        appData?.pointee.enableBSDFSampling     = isBSDFSamplingEnabled
        appData?.pointee.enableRussianRoulette  = isRussianRoulette
        appData?.pointee.camera                 = camera
        
    }
    
//    func setComparisonMode(_ mode: UInt32) {
//        comparisonMode = mode
//    }
    
}
