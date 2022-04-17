//
//  Renderer.swift
//  SceneKit RT
//
//  Extended/Modifyed by Philipp Zay on 16.04.22.
//
//  ORIGINAL
//  Created by Viktor Chernikov on 17/04/2019.
//  Copyright © 2019 Viktor Chernikov. All rights reserved.
//

import MetalKit
import MetalPerformanceShaders
import simd
import os

// For Metal
let maxFramesInFlight   = 3
let alignedUniformsSize = (MemoryLayout<Uniforms>.stride + 255) & ~255

let rayStride = 48
let intersectionStride  = MemoryLayout<MPSIntersectionDistancePrimitiveIndexCoordinates>.size

// Control Definitions
var isGrayObject        : Bool  = false
var isColoredBox        : Bool  = false
var rayBounces          : Int   = 4    // default Apple is 3
var cameraDistanceZ     : Float = 3.38 // default Apple
var cameraShiftX        : Float = 0.00 // default Apple
var cameraShiftY        : Float = 1.00 // default Apple
var objectScaleFactor   : Float = 1.0
var objectShiftX        : Float = 0.0
var objectShiftY        : Float = 0.0
var objectShiftZ        : Float = 0.0
var objectRotationX     : Float = 0.0
var objectRotationY     : Float = 0.0
var objectRotationZ     : Float = 0.0
var isReflectiveObject  : Bool  = false // false = reflective, true = diffuse
var isReflectiveBox     : Bool  = false // false = reflective, true = diffuse
var isNoVisibleLight    : Bool  = false // true = hide visible Light Source / false = show visible Light Source
var isMaskLight         : Bool  = false // if true the intersections from MPSRayIntersector are and-ed instead of or-ed (false)
var isBlackBox          : Bool  = false // if true the Box is hidden
var shadowSharpness     : Float = 2.0 // default apple, higher value gives softer shadows, 0 = hard shadow

enum LightPosition {
    case left
    case right
    case top
    case bottom
    case front
    case back
}

var lightPosition : LightPosition = .top // Default

// ORIG
enum RendererInitError: Error {
    case noDevice
    case noLibrary
    case noQueue
    case errorCreatingBuffer
}

class Renderer: NSObject, MTKViewDelegate {

    let view: MTKView
    let device: MTLDevice
    let queue: MTLCommandQueue
    let library: MTLLibrary

    let accelerationStructure: MPSTriangleAccelerationStructure
    let intersector: MPSRayIntersector

    let vertexPositionBuffer: MTLBuffer
    let vertexNormalBuffer: MTLBuffer
    let vertexColourBuffer: MTLBuffer
    var rayBuffer: MTLBuffer!
    var shadowRayBuffer: MTLBuffer!
    var intersectionBuffer: MTLBuffer!
    let uniformBuffer: MTLBuffer
    let triangleMaskBuffer: MTLBuffer

    let rayPipeline: MTLComputePipelineState
    let shadePipeline: MTLComputePipelineState
    let shadowPipeline: MTLComputePipelineState
    let accumulatePipeline: MTLComputePipelineState
    let copyPipeline: MTLRenderPipelineState

    var renderTarget0: MTLTexture!
    var renderTarget1: MTLTexture!
    
    var accumulationTarget0: MTLTexture!
    var accumulationTarget1: MTLTexture!
    var randomTexture: MTLTexture!

    let semaphore: DispatchSemaphore
    var size: CGSize!
    var uniformBufferOffset: Int!
    var uniformBufferIndex: Int = 0

    var frameIndex: uint = 0
    
    // new phil
    var rayCount            : Int!
    var bounce              : Int = 0 // internal ray bounces (adapted from obj-c code)
    var numberOfTriangles   : Int!
    
    
    init(withMetalKitView view: MTKView) throws {
        self.view = view
        guard let device = view.device else { throw RendererInitError.noDevice }
        self.device = device
        os_log("Metal device name is %s", device.name)

        semaphore = DispatchSemaphore(value: maxFramesInFlight)

        // Load Metal
        view.colorPixelFormat = .rgba16Float
        view.sampleCount = 1
        view.drawableSize = view.frame.size
        guard let library = device.makeDefaultLibrary() else { throw RendererInitError.noLibrary }
        self.library = library
        guard let queue = device.makeCommandQueue() else { throw RendererInitError.noQueue }
        self.queue = queue

        // Create pipelines
        let computeDescriptor = MTLComputePipelineDescriptor()
        computeDescriptor.threadGroupSizeIsMultipleOfThreadExecutionWidth = true
        computeDescriptor.computeFunction = library.makeFunction(name: "rayKernel")
        self.rayPipeline = try device.makeComputePipelineState(descriptor: computeDescriptor,
                                                               options: [],
                                                               reflection: nil)
        computeDescriptor.computeFunction = library.makeFunction(name: "shadeKernel")
        self.shadePipeline = try device.makeComputePipelineState(descriptor: computeDescriptor,
                                                                 options: [],
                                                                 reflection: nil)
        computeDescriptor.computeFunction = library.makeFunction(name: "shadowKernel")
        self.shadowPipeline = try device.makeComputePipelineState(descriptor: computeDescriptor,
                                                                  options: [],
                                                                  reflection: nil)
        computeDescriptor.computeFunction = library.makeFunction(name: "accumulateKernel")
        self.accumulatePipeline = try device.makeComputePipelineState(descriptor: computeDescriptor,
                                                                      options: [],
                                                                      reflection: nil)
        let renderDescriptor = MTLRenderPipelineDescriptor()
        renderDescriptor.sampleCount = view.sampleCount
        renderDescriptor.vertexFunction = library.makeFunction(name: "copyVertex")
        renderDescriptor.fragmentFunction = library.makeFunction(name: "copyFragment")
        renderDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat
        self.copyPipeline = try device.makeRenderPipelineState(descriptor: renderDescriptor)

        // MARK - Create scene
        var vertices = [simd_float3]()
        var normals  = [simd_float3]()
        var colours  = [simd_float3]()
        var masks    = [uint]()
        
        
        var transform = Matrix4x4.translation(0.0, 0.0, 0.0)
        
        
        // MARK: - Light sources
        
        // let lightSize = 1.0 / shadowSharpness
        let lightSize = shadowSharpness / 4
        
        if !isNoVisibleLight {
            switch lightPosition {
            
            case .right:
                transform = Matrix4x4.translation(0, 1, 0) * Matrix4x4.scale(1.98, lightSize, lightSize)
                cube(withFaceMask: .positiveX, colour: simd_float3([1.0, 1.0, 1.0]), transform: transform, inwardNormals: true, triangleMask: uint(TRIANGLE_MASK_LIGHT), vertices: &vertices, normals: &normals, colours: &colours, masks: &masks)
            
            case .left:
                transform = Matrix4x4.translation(0, 1, 0) * Matrix4x4.scale(1.98, lightSize, lightSize)
                cube(withFaceMask: .negativeX, colour: simd_float3([1.0, 1.0, 1.0]), transform: transform, inwardNormals: true, triangleMask: uint(TRIANGLE_MASK_LIGHT), vertices: &vertices, normals: &normals, colours: &colours, masks: &masks)
            
            case .top:
                transform = Matrix4x4.translation(0, 1, 0) * Matrix4x4.scale(lightSize, 1.98, lightSize)
                cube(withFaceMask: .positiveY, colour: simd_float3([1.0, 1.0, 1.0]), transform: transform, inwardNormals: true, triangleMask: uint(TRIANGLE_MASK_LIGHT), vertices: &vertices, normals: &normals, colours: &colours, masks: &masks)
            
            case .bottom:
                transform = Matrix4x4.translation(0, 1, 0) * Matrix4x4.scale(lightSize, 1.98, lightSize)
                cube(withFaceMask: .negativeY, colour: simd_float3([1.0, 1.0, 1.0]), transform: transform, inwardNormals: true, triangleMask: uint(TRIANGLE_MASK_LIGHT), vertices: &vertices, normals: &normals, colours: &colours, masks: &masks)
                
            case .front:
                break
                // no visible light in front position!
                // transform = Matrix4x4.translation(0, 1, 0) * Matrix4x4.scale(0.5, 0.5, 1.98)
                // cube(withFaceMask: .positiveZ, colour: simd_float3([lightColor.redValue, lightColor.greenValue, lightColor.blueValue]), transform: transform, inwardNormals: true, triangleMask: uint(TRIANGLE_MASK_LIGHT), vertices: &vertices, normals: &normals, colours: &colours, masks: &masks)
                
            case .back:
                transform = Matrix4x4.translation(0, 1, 0) * Matrix4x4.scale(lightSize, lightSize, 1.98)
                cube(withFaceMask: .negativeZ, colour: simd_float3([1.0, 1.0, 1.0]), transform: transform, inwardNormals: true, triangleMask: uint(TRIANGLE_MASK_LIGHT), vertices: &vertices, normals: &normals, colours: &colours, masks: &masks)
                
            }
        }
        
        var mask:Int32 = 1
        
        var grayTone = simd_float3()
        if isBlackBox {
            grayTone = simd_float3([0.0725, 0.0710, 0.0680]) // darker
        } else {
            grayTone = simd_float3([0.725, 0.710, 0.680]) // default gray!
        }
        
        if isReflectiveBox { mask = TRIANGLE_MASK_REFLECT } else { mask = TRIANGLE_MASK_GEOMETRY }
        
            switch isColoredBox {
            case true:
                // MARK: - Cube Faces
                // Top, bottom, back
                transform = Matrix4x4.translation(0, 1, 0) * Matrix4x4.scale(2, 2, 2)
                

                // Left wall - RED
                cube(withFaceMask: .negativeX, colour: simd_float3([0.630, 0.065, 0.050]), transform: transform, inwardNormals: true, triangleMask: uint(mask), vertices: &vertices, normals: &normals, colours: &colours, masks: &masks)

                // Right wall - GREEN
                cube(withFaceMask: .positiveX, colour: simd_float3([0.140, 0.450, 0.091]), transform: transform, inwardNormals: true, triangleMask: uint(mask), vertices: &vertices, normals: &normals, colours: &colours, masks: &masks)
                
                // Bottom - BLUE
                cube(withFaceMask: .negativeY, colour: simd_float3([0.050, 0.082, 0.631]), transform: transform, inwardNormals: true, triangleMask: uint(mask), vertices: &vertices, normals: &normals, colours: &colours, masks: &masks)
                
                // Top - YELLOW
                cube(withFaceMask: .positiveY, colour: simd_float3([0.631, 0.603, 0.050]), transform: transform, inwardNormals: true, triangleMask: uint(mask), vertices: &vertices, normals: &normals, colours: &colours, masks: &masks)
                
                // Back wall - DEFAULT GRAY
                cube(withFaceMask: .negativeZ, colour: grayTone, transform: transform, inwardNormals: true, triangleMask: uint(mask), vertices: &vertices, normals: &normals, colours: &colours, masks: &masks)
                
                
                
            case false:
                // MARK: - Cube Faces
                // top, bottom, back, left, right
                transform = Matrix4x4.translation(0, 1, 0) * Matrix4x4.scale(2, 2, 2)
                
                cube(withFaceMask: [.negativeX, .positiveX, .negativeY, .positiveY, .negativeZ], colour: grayTone, transform: transform, inwardNormals: true, triangleMask: uint(mask), vertices: &vertices, normals: &normals, colours: &colours, masks: &masks)
                
            }
            
        
        // MARK: - Place Object
        
        if isReflectiveObject { mask = TRIANGLE_MASK_REFLECT } else { mask = TRIANGLE_MASK_GEOMETRY }
        
        transform = Matrix4x4.translation(0, 0, 0) *
                    Matrix4x4.rotation(radians: objectRotationX.degreesToRadians, axis: simd_float3(1, 0, 0)) *
                    Matrix4x4.rotation(radians: objectRotationY.degreesToRadians, axis: simd_float3(0, 1, 0)) *
                    Matrix4x4.rotation(radians: objectRotationZ.degreesToRadians, axis: simd_float3(0, 0, 1)) *
                    Matrix4x4.scale(objectScaleFactor, objectScaleFactor, objectScaleFactor)
        
        object(colour: globalObjectColor,
               transform: transform,
               inwardNormals: false,
               triangleMask: uint(mask),
               vertices: &vertices,
               normals: &normals,
               colours: &colours,
               masks: &masks)
        
        // MARK: - Create buffers
        // Uniform buffer contains a few small values which change from frame to frame. We will have up to 3
        // frames in flight at once, so allocate a range of the buffer for each frame. The GPU will read from
        // one chunk while the CPU writes to the next chunk. Each chunk must be aligned to 256 bytes on macOS
        // and 16 bytes on iOS.
        let uniformBufferSize = alignedUniformsSize * maxFramesInFlight

        // Vertex data should be stored in private or managed buffers on discrete GPU systems (AMD, NVIDIA).
        // Private buffers are stored entirely in GPU memory and cannot be accessed by the CPU. Managed
        // buffers maintain a copy in CPU memory and a copy in GPU memory.
        let storageOptions: MTLResourceOptions

        #if os(macOS)
        storageOptions = .storageModeManaged
        #else // iOS, tvOS
        storageOptions = .storageModeShared
        #endif

        // Allocate buffers for vertex positions, colors, and normals. Note that each vertex position is a
        // float3, which is a 16 byte aligned type.
        guard let uniformBuffer = device.makeBuffer(length: uniformBufferSize, options: storageOptions) else {
            throw RendererInitError.errorCreatingBuffer
        }
        self.uniformBuffer = uniformBuffer

        let float3Size = MemoryLayout<simd_float3>.stride
        guard let vertexPositionBuffer = device.makeBuffer(bytes: &vertices, length: vertices.count * float3Size, options: storageOptions) else {
            throw RendererInitError.errorCreatingBuffer
        }
        self.vertexPositionBuffer = vertexPositionBuffer

        guard let vertexColourBuffer = device.makeBuffer(bytes: &colours, length: colours.count * float3Size, options: storageOptions) else {
            throw RendererInitError.errorCreatingBuffer
        }
        self.vertexColourBuffer = vertexColourBuffer

        guard let vertexNormalBuffer = device.makeBuffer(bytes: &normals, length: normals.count * float3Size, options: storageOptions) else {
            throw RendererInitError.errorCreatingBuffer
        }
        self.vertexNormalBuffer = vertexNormalBuffer

        let uintSize = MemoryLayout<uint>.stride
        guard let triangleMaskBuffer = device.makeBuffer(bytes: &masks, length: masks.count * uintSize, options: storageOptions) else {
            throw RendererInitError.errorCreatingBuffer
        }
        self.triangleMaskBuffer = triangleMaskBuffer

        // When using managed buffers, we need to indicate that we modified the buffer so that the GPU
        // copy can be updated
        #if os(macOS)
        if storageOptions.contains(.storageModeManaged) {
            vertexPositionBuffer.didModifyRange(0..<vertexPositionBuffer.length)
            vertexColourBuffer.didModifyRange(0..<vertexColourBuffer.length)
            vertexNormalBuffer.didModifyRange(0..<vertexNormalBuffer.length)
            triangleMaskBuffer.didModifyRange(0..<triangleMaskBuffer.length)
        }
        #endif

        // MARK: - Create a raytracer for Metal device
        intersector = MPSRayIntersector(device: device)
        intersector.rayDataType = .originMaskDirectionMaxDistance // .originMinDistanceDirectionMaxDistance // .originMaskDirectionMaxDistance
        intersector.rayStride = rayStride
        intersector.rayMaskOptions = .primitive // .primitive
        
        if isMaskLight {
            intersector.rayMaskOperator = .and // filter out light source reflections
        } else {
            intersector.rayMaskOperator = .or // no filtering
        }
        
        // Create an acceleration structure from our vertex position data
        accelerationStructure = MPSTriangleAccelerationStructure(device: device)
        accelerationStructure.vertexBuffer = vertexPositionBuffer
        accelerationStructure.maskBuffer = triangleMaskBuffer
        numberOfTriangles = vertices.count / 3 // print(numberOfTriangles)
        accelerationStructure.triangleCount = numberOfTriangles

        accelerationStructure.rebuild()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.size = size
        // Handle window size changes by allocating a buffer large enough to contain one standard ray,
        // one shadow ray, and one ray/triangle intersection result per pixel
        rayCount = Int(size.width * size.height)
        // We use private buffers here because rays and intersection results will be entirely produced
        // and consumed on the GPU
        rayBuffer = device.makeBuffer(length: rayStride * rayCount, options: .storageModePrivate)
        shadowRayBuffer = device.makeBuffer(length: rayStride * rayCount, options: .storageModePrivate)
        intersectionBuffer = device.makeBuffer(length: intersectionStride * rayCount,
                                               options: .storageModePrivate)

        // Create a render target which the shading kernel can write to
        let renderTargetDescriptor = MTLTextureDescriptor()
        renderTargetDescriptor.pixelFormat = .rgba32Float
        renderTargetDescriptor.textureType = .type2D
        renderTargetDescriptor.width = Int(size.width)
        renderTargetDescriptor.height = Int(size.height)
        // Stored in private memory because it will only be read and written from the GPU
        renderTargetDescriptor.storageMode = .private
        // Indicate that we will read and write the texture from the GPU
        renderTargetDescriptor.usage = [.shaderRead, .shaderWrite]

        renderTarget0 = device.makeTexture(descriptor: renderTargetDescriptor)
        renderTarget1 = device.makeTexture(descriptor: renderTargetDescriptor)
        
        accumulationTarget0 = device.makeTexture(descriptor: renderTargetDescriptor)
        accumulationTarget1 = device.makeTexture(descriptor: renderTargetDescriptor)
        
        
        renderTargetDescriptor.pixelFormat = .r32Uint
        renderTargetDescriptor.usage = .shaderRead
        renderTargetDescriptor.storageMode = .shared
            
        // Generate a texture containing a random integer value for each pixel. This value
        // will be used to decorrelate pixels while drawing pseudorandom numbers from the
        // Halton sequence.
        
        randomTexture = device.makeTexture(descriptor: renderTargetDescriptor)
        
        // uint32_t *randomValues = (uint32_t *)malloc(sizeof(uint32_t) * size.width * size.height);
        let tempSize = Int(size.width * size.height)
        let randomValues = UnsafeMutablePointer<UInt32>.allocate(capacity: tempSize)
        randomValues.initialize(repeating: 0, count: tempSize)
        
        // for (NSUInteger i = 0; i < size.width * size.height; i++)
        // randomValues[i] = rand() % (1024 * 1024);
        for i in 0 ..< tempSize {
            randomValues[i] = arc4random() % (1024 * 1024)
            // randomValues[i] = rand() % (1024 * 1024);
        }
        
        randomTexture.replace(region: MTLRegionMake2D(0, 0, Int(size.width), Int(size.height)),
                              mipmapLevel: 0,
                              withBytes: randomValues,
                              bytesPerRow: MemoryLayout<UInt32>.size * Int(size.width))
        
        randomValues.deinitialize(count: tempSize)
        randomValues.deallocate()
        
        // Reset Stuff
        frameIndex = 0
        GameViewController.secondsCounter = 0
        GameViewController.isRenderingProgressCompleted = false
        
        
    }

    func draw(in view: MTKView) {
        // We are using the uniform buffer to stream uniform data to the GPU, so we need to wait until the
        // oldest GPU frame has completed before we can reuse that space in the buffer.
        semaphore.wait()
        // Create a command buffer which will contain our GPU commands
        guard let commandBuffer = queue.makeCommandBuffer() else { return }
        // When the frame has finished, signal that we can reuse the uniform buffer space from this frame.
        // Note that the contents of completion handlers should be as fast as possible as the GPU driver may
        // have other work scheduled on the underlying dispatch queue.
        commandBuffer.addCompletedHandler {
            _ in self.semaphore.signal()
        }

        updateUniforms()

        let width = Int(size.width)
        let height = Int(size.height)
        // We will launch a rectangular grid of threads on the GPU to generate the rays. Threads are
        // launched in groups called "threadgroups". We need to align the number of threads to be a multiple
        // of the threadgroup size. We indicated when compiling the pipeline that the threadgroup size would
        // be a multiple of the thread execution width (SIMD group size) which is typically 32 or 64 so 8x8
        // is a safe threadgroup size which should be small to be supported on most devices. A more advanced
        // application would choose the threadgroup size dynamically.
        let threadsPerThreadgroup = MTLSizeMake(8, 8, 1)
        let threadsHeight = threadsPerThreadgroup.height
        let threadsWidth = threadsPerThreadgroup.width
        let threadgroups = MTLSizeMake((width + threadsWidth  - 1) / threadsWidth, (height + threadsHeight - 1) / threadsHeight, 1)
        // First, we will generate rays on the GPU. We create a compute command encoder which will be used
        // to add commands to the command buffer.
        guard let computeEncoder = commandBuffer.makeComputeCommandEncoder() else { return }
        // Bind buffers needed by the compute pipeline
        computeEncoder.setBuffer(uniformBuffer, offset: uniformBufferOffset, index: 0)
        computeEncoder.setBuffer(rayBuffer, offset: 0, index: 1)
        
        computeEncoder.setTexture(randomTexture, index: 0) // [computeEncoder setTexture:_randomTexture    atIndex:0];
        computeEncoder.setTexture(renderTarget0, index: 1)
        // Bind the ray generation compute pipeline
        computeEncoder.setComputePipelineState(rayPipeline)
        // Launch threads
        computeEncoder.dispatchThreadgroups(threadgroups, threadsPerThreadgroup: threadsPerThreadgroup)
        // End the encoder
        computeEncoder.endEncoding()
        
        bounce = 0 // zero the bounce
        
        // We will iterate over the next few kernels several times to allow light to bounce around the scene
        for _ in 0..<rayBounces {
            intersector.intersectionDataType = .distancePrimitiveIndexCoordinates
            // We can then pass the rays to the MPSRayIntersector to compute the intersections with our
            // acceleration structure
            intersector.encodeIntersection(commandBuffer: commandBuffer,
                                           intersectionType: .nearest,
                                           rayBuffer: rayBuffer,
                                           rayBufferOffset: 0,
                                           intersectionBuffer: intersectionBuffer,
                                           intersectionBufferOffset: 0,
                                           rayCount: width * height,
                                           accelerationStructure: accelerationStructure)
            // We launch another pipeline to consume the intersection results and shade the scene
            guard let shadeEncoder = commandBuffer.makeComputeCommandEncoder() else { return }
            
            shadeEncoder.setBuffer(uniformBuffer,       offset: uniformBufferOffset,     index: 0)
            shadeEncoder.setBuffer(rayBuffer,           offset: 0,                       index: 1)
            shadeEncoder.setBuffer(shadowRayBuffer,     offset: 0,                       index: 2)
            shadeEncoder.setBuffer(intersectionBuffer,  offset: 0,                       index: 3)
            shadeEncoder.setBuffer(vertexColourBuffer,  offset: 0,                       index: 4)
            shadeEncoder.setBuffer(vertexNormalBuffer,  offset: 0,                       index: 5)
            shadeEncoder.setBuffer(triangleMaskBuffer,  offset: 0,                       index: 6)
            
            shadeEncoder.setBytes(&bounce,              length: MemoryLayout<Int>.size,  index: 7); bounce += 1; if bounce >= 2 { bounce = 2 } // increment the bounce count, but max 2!

            shadeEncoder.setTexture(randomTexture, index: 0) // [computeEncoder setTexture:_randomTexture    atIndex:0];
            shadeEncoder.setTexture(renderTarget0, index: 1)
            
            shadeEncoder.setComputePipelineState(shadePipeline)
            shadeEncoder.dispatchThreadgroups(threadgroups, threadsPerThreadgroup: threadsPerThreadgroup)
            shadeEncoder.endEncoding()

            // We intersect rays with the scene, except this time we are intersecting shadow rays. We only
            // need to know whether the shadows rays hit anything on the way to the light source, not which
            // triangle was intersected. Therefore, we can use the "any" intersection type to end the
            // intersection search as soon as any intersection is found. This is typically much faster than
            // finding the nearest intersection. We can also use MPSIntersectionDataTypeDistance, because we
            // don't need the triangle index and barycentric coordinates.
            intersector.intersectionDataType = .distance
            intersector.encodeIntersection(commandBuffer: commandBuffer,
                                           intersectionType: .any,
                                           rayBuffer: shadowRayBuffer,
                                           rayBufferOffset: 0,
                                           intersectionBuffer: intersectionBuffer,
                                           intersectionBufferOffset: 0,
                                           rayCount: width * height,
                                           accelerationStructure: accelerationStructure)
            // Finally, we launch a kernel which writes the color computed by the shading kernel into the
            // output image, but only if the corresponding shadow ray does not intersect anything on the way
            // to the light. If the shadow ray intersects a triangle before reaching the light source, the
            // original intersection point was in shadow.
            guard let colourEncoder = commandBuffer.makeComputeCommandEncoder() else { return }
            colourEncoder.setBuffer(uniformBuffer, offset: uniformBufferOffset, index: 0)
            colourEncoder.setBuffer(shadowRayBuffer, offset: 0, index: 1)
            colourEncoder.setBuffer(intersectionBuffer, offset: 0, index: 2)
            
            colourEncoder.setTexture(renderTarget0, index: 0)
            colourEncoder.setTexture(renderTarget1, index: 1)
            colourEncoder.setComputePipelineState(shadowPipeline)
            colourEncoder.dispatchThreadgroups(threadgroups, threadsPerThreadgroup: threadsPerThreadgroup)
            colourEncoder.endEncoding()
            
            swap(&renderTarget0, &renderTarget1)
            
        }
        // The final kernel averages the current frame's image with all previous frames to reduce noise due
        // random sampling of the scene.
        guard let denoiseEncoder = commandBuffer.makeComputeCommandEncoder() else { return }
        denoiseEncoder.setBuffer(uniformBuffer, offset: uniformBufferOffset, index: 0)

        denoiseEncoder.setTexture(renderTarget0, index: 0)
        denoiseEncoder.setTexture(accumulationTarget0, index: 1)
        denoiseEncoder.setTexture(accumulationTarget1, index: 2)

        denoiseEncoder.setComputePipelineState(accumulatePipeline)
        denoiseEncoder.dispatchThreadgroups(threadgroups, threadsPerThreadgroup: threadsPerThreadgroup)
        denoiseEncoder.endEncoding()
        
        swap(&accumulationTarget0, &accumulationTarget1)// std::swap(_accumulationTargets[0], _accumulationTargets[1]);

        // Copy the resulting image into our view using the graphics pipeline since we can't write directly
        // to it with a compute kernel. We need to delay getting the current render pass descriptor as long
        // as possible to avoid stalling until the GPU/compositor release a drawable. The render pass
        // descriptor may be nil if the window has moved off screen.
        if let renderPassDescriptor = view.currentRenderPassDescriptor {
            guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
            renderEncoder.setRenderPipelineState(copyPipeline)
            renderEncoder.setFragmentTexture(accumulationTarget0, index: 0)
            // Draw a quad which fills the screen
            renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
            renderEncoder.endEncoding()
            // Present the drawable to the screen
            guard let drawable = view.currentDrawable else { return }
            commandBuffer.present(drawable)
        }
        // Finally, commit the command buffer so that the GPU can start executing
        commandBuffer.commit()
    }

    func updateUniforms() {
        uniformBufferOffset = alignedUniformsSize * uniformBufferIndex
        let uniformsPointer = uniformBuffer.contents().advanced(by: uniformBufferOffset)
        let uniforms = uniformsPointer.bindMemory(to: Uniforms.self, capacity: 1)
        
        uniforms.pointee.camera.position = simd_float3(cameraShiftX, cameraShiftY, cameraDistanceZ)
        uniforms.pointee.camera.forward = simd_float3(0, 0, -1)
        uniforms.pointee.camera.right = simd_float3(1, 0, 0)
        uniforms.pointee.camera.up = simd_float3(0, 1, 0)
        
        switch lightPosition {
            
        case .right:
            uniforms.pointee.light.position = simd_float3(0.98, 1.0, 0)
            uniforms.pointee.light.forward = simd_float3(-1, 0, 0)
            uniforms.pointee.light.right = simd_float3(0, 0, 0.25)
            uniforms.pointee.light.up = simd_float3(0, 0.25, 0)
            
        case .left:
            uniforms.pointee.light.position = simd_float3(-0.98, 1.0, 0)
            uniforms.pointee.light.forward = simd_float3(+1, 0, 0)
            uniforms.pointee.light.right = simd_float3(0, 0, 0.25)
            uniforms.pointee.light.up = simd_float3(0, 0.25, 0)
            
        case .top: // orig
            uniforms.pointee.light.position = simd_float3(0, 1.98, 0)
            uniforms.pointee.light.forward = simd_float3(0, -1, 0)
            uniforms.pointee.light.right = simd_float3(0.25, 0, 0)
            uniforms.pointee.light.up = simd_float3(0, 0, 0.25)
            
        case .bottom:
            uniforms.pointee.light.position = simd_float3(0, 0.02, 0)
            uniforms.pointee.light.forward = simd_float3(0, 1, 0)
            uniforms.pointee.light.right = simd_float3(0.25, 0, 0)
            uniforms.pointee.light.up = simd_float3(0, 0, 0.25)
            
        case .front:
            uniforms.pointee.light.position = simd_float3(0, 1.0, 0.98)
            uniforms.pointee.light.forward = simd_float3(0, 0, -1)
            uniforms.pointee.light.right = simd_float3(0.25, 0, 0)
            uniforms.pointee.light.up = simd_float3(0, 0.25, 0)
            
        case .back:
            uniforms.pointee.light.position = simd_float3(0, 1.0, -0.98)
            uniforms.pointee.light.forward = simd_float3(0, 0, 1)
            uniforms.pointee.light.right = simd_float3(0.25, 0, 0)
            uniforms.pointee.light.up = simd_float3(0, 0.25, 0)
            
        }
        
        uniforms.pointee.light.color = simd_float3(lightColor.redValue * 4, lightColor.greenValue * 4, lightColor.blueValue * 4) // simd_float3(4, 4, 4);
        // uniforms.pointee.light.color = simd_float3(4, 4, 4) // simd_float3(4, 4, 4);
        uniforms.pointee.light.factor = shadowSharpness
        

        let fieldOfView = 45.0 * (Float.pi / 180.0)
        let aspectRatio = Float(size.width) / Float(size.height)
        let imagePlaneHeight = tanf(fieldOfView / 2.0)
        let imagePlaneWidth = aspectRatio * imagePlaneHeight

        uniforms.pointee.camera.right *= imagePlaneWidth
        uniforms.pointee.camera.up *= imagePlaneHeight

        uniforms.pointee.width = UInt32(size.width)
        uniforms.pointee.height = UInt32(size.height)

        // uniforms.pointee.blocksWide = (uniforms.pointee.width + 15) / 16
        uniforms.pointee.frameIndex = frameIndex
        frameIndex += 1

        // For managed storage mode
        #if os(macOS)
        uniformBuffer.didModifyRange(uniformBufferOffset..<uniformBufferOffset + alignedUniformsSize)
        #endif
        
        uniformBufferIndex = (uniformBufferIndex + 1) % maxFramesInFlight
    }
}
