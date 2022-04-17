//
//  GeometryProvider.swift
//  SceneKit RT
//
//  Created by Philipp Zay on 16.04.22.
//

import MetalKit
import MetalPerformanceShaders
import simd
import os

extension AdvancedRenderer {
    
    // MARK: Buffer Providers
    func makeIndexBuffer() -> MTLBuffer { let indexStride = MemoryLayout<UInt32>.stride;
        let indexBuffer = device?.makeBuffer(bytes: &indexData, length: indexData.count * indexStride, options: .storageModeShared);                             return indexBuffer! }
    
    func makeVertexBuffer() -> MTLBuffer { let vertexStride = MemoryLayout<Vertex>.stride;
        let vertexBuffer = device?.makeBuffer(bytes: &vertexData, length: vertexData.count * vertexStride, options: .storageModeShared);                         return vertexBuffer! }
    
    func makeMaterialsBuffer() -> MTLBuffer { let materialStride = MemoryLayout<Material>.stride;
        let materialBuffer = device?.makeBuffer(bytes: &materialData, length: materialData.count * materialStride, options: .storageModeShared);                 return materialBuffer! }
    
    func makeTriangleBuffer() -> MTLBuffer { let triangleStride = MemoryLayout<Triangle>.stride;
        let triangleBuffer = device?.makeBuffer(bytes: &triangleData, length: triangleData.count * triangleStride, options: .storageModeShared);                 return triangleBuffer! }
    
    func makeEmitterTriangleBuffer() -> MTLBuffer { let eTriangleStride = MemoryLayout<EmitterTriangle>.stride;
        let eTriangleBuffer = device?.makeBuffer(bytes: &emitterTriangleData, length: emitterTriangleData.count * eTriangleStride, options: .storageModeShared); return eTriangleBuffer! }
    
    
    
    // MARK: - Create Scene
    func createScene() {
        
        var transform = Matrix4x4.translation(0.0, 0.0, 0.0)
        
        // MARK: - Light sources
        let lightSize = shadowSharpness / 4
        
        
        if isLightTop {
            transform = Matrix4x4.translation(0, 1, 0) * Matrix4x4.scale(lightSize, 1.98, lightSize)
            cube(withFaceMask: .positiveY, colour: simd_float3([lightColor.redValue, lightColor.greenValue, lightColor.blueValue]), transform: transform, inwardNormals: true, triangleMask: uint(TRIANGLE_MASK_ADV_LIGHT), vertices: &vertices, indices: &indices, normals: &normals, uvCoords: &uvCoords, colours: &colours, masks: &masks)
        }
        
        if isLightBottom {
            transform = Matrix4x4.translation(0, 1, 0) * Matrix4x4.scale(lightSize, 1.98, lightSize)
            cube(withFaceMask: .negativeY, colour: simd_float3([lightColor.redValue, lightColor.greenValue, lightColor.blueValue]), transform: transform, inwardNormals: true, triangleMask: uint(TRIANGLE_MASK_ADV_LIGHT), vertices: &vertices, indices: &indices, normals: &normals, uvCoords: &uvCoords, colours: &colours, masks: &masks)
        }
        
        if isLightLeft {
            transform = Matrix4x4.translation(0, 1, 0) * Matrix4x4.scale(1.98, lightSize, lightSize)
            cube(withFaceMask: .negativeX, colour: simd_float3([lightColor.redValue, lightColor.greenValue, lightColor.blueValue]), transform: transform, inwardNormals: true, triangleMask: uint(TRIANGLE_MASK_ADV_LIGHT), vertices: &vertices, indices: &indices, normals: &normals, uvCoords: &uvCoords, colours: &colours, masks: &masks)
        }
        
        if isLightRight {
            transform = Matrix4x4.translation(0, 1, 0) * Matrix4x4.scale(1.98, lightSize, lightSize)
            cube(withFaceMask: .positiveX, colour: simd_float3([lightColor.redValue, lightColor.greenValue, lightColor.blueValue]), transform: transform, inwardNormals: true, triangleMask: uint(TRIANGLE_MASK_ADV_LIGHT), vertices: &vertices, indices: &indices, normals: &normals, uvCoords: &uvCoords, colours: &colours, masks: &masks)
        }
        
        if isLightBack {
            transform = Matrix4x4.translation(0, 1, 0) * Matrix4x4.scale(lightSize, lightSize, 1.98)
            cube(withFaceMask: .negativeZ, colour: simd_float3([lightColor.redValue, lightColor.greenValue, lightColor.blueValue]), transform: transform, inwardNormals: true, triangleMask: uint(TRIANGLE_MASK_ADV_LIGHT), vertices: &vertices, indices: &indices, normals: &normals, uvCoords: &uvCoords, colours: &colours, masks: &masks)
        }
        
        

//        if !isNoVisibleLight {
//            switch lightPosition {
//
//            case .right:
//                transform = Matrix4x4.translation(0, 1, 0) * Matrix4x4.scale(1.98, lightSize, lightSize)
//                cube(withFaceMask: .positiveX, colour: simd_float3([lightColor.redValue, lightColor.greenValue, lightColor.blueValue]), transform: transform, inwardNormals: true, triangleMask: uint(TRIANGLE_MASK_ADV_LIGHT), vertices: &vertices, indices: &indices, normals: &normals, uvCoords: &uvCoords, colours: &colours, masks: &masks)
//
//            case .left:
//                transform = Matrix4x4.translation(0, 1, 0) * Matrix4x4.scale(1.98, lightSize, lightSize)
//                cube(withFaceMask: .negativeX, colour: simd_float3([lightColor.redValue, lightColor.greenValue, lightColor.blueValue]), transform: transform, inwardNormals: true, triangleMask: uint(TRIANGLE_MASK_ADV_LIGHT), vertices: &vertices, indices: &indices, normals: &normals, uvCoords: &uvCoords, colours: &colours, masks: &masks)
//
//            case .top:
//                transform = Matrix4x4.translation(0, 1, 0) * Matrix4x4.scale(lightSize, 1.98, lightSize)
//                cube(withFaceMask: .positiveY, colour: simd_float3([lightColor.redValue, lightColor.greenValue, lightColor.blueValue]), transform: transform, inwardNormals: true, triangleMask: uint(TRIANGLE_MASK_ADV_LIGHT), vertices: &vertices, indices: &indices, normals: &normals, uvCoords: &uvCoords, colours: &colours, masks: &masks)
//
//            case .bottom:
//                transform = Matrix4x4.translation(0, 1, 0) * Matrix4x4.scale(lightSize, 1.98, lightSize)
//                cube(withFaceMask: .negativeY, colour: simd_float3([lightColor.redValue, lightColor.greenValue, lightColor.blueValue]), transform: transform, inwardNormals: true, triangleMask: uint(TRIANGLE_MASK_ADV_LIGHT), vertices: &vertices, indices: &indices, normals: &normals, uvCoords: &uvCoords, colours: &colours, masks: &masks)
//
//            case .front:
//                print("no visible light in front position")
//                // transform = Matrix4x4.translation(0, 1, 0) * Matrix4x4.scale(lightSize, lightSize, 1.98)
//                // cube(withFaceMask: .positiveZ, colour: simd_float3([lightColor.redValue, lightColor.greenValue, lightColor.blueValue]), transform: transform, inwardNormals: true, triangleMask: uint(TRIANGLE_MASK_ADV_LIGHT), vertices: &vertices, indices: &indices, normals: &normals, uvCoords: &uvCoords, colours: &colours, masks: &masks)
//
//            case .back:
//                transform = Matrix4x4.translation(0, 1, 0) * Matrix4x4.scale(lightSize, lightSize, 1.98)
//                cube(withFaceMask: .negativeZ, colour: simd_float3([lightColor.redValue, lightColor.greenValue, lightColor.blueValue]), transform: transform, inwardNormals: true, triangleMask: uint(TRIANGLE_MASK_ADV_LIGHT), vertices: &vertices, indices: &indices, normals: &normals, uvCoords: &uvCoords, colours: &colours, masks: &masks)
//
//            }
//        }
        
        let grayTone = simd_float3([0.725, 0.710, 0.680])
        
        // MARK: - Cube Faces
        // top, bottom, back, left, right
        transform = Matrix4x4.translation(0, 1, 0) * Matrix4x4.scale(2, 2, 2)
        
        cube(withFaceMask: [.negativeX], colour: grayTone, transform: transform, inwardNormals: true, triangleMask: uint(TRIANGLE_MASK_BOX_NEGX),vertices: &vertices, indices: &indices, normals: &normals, uvCoords: &uvCoords, colours: &colours, masks: &masks)
        
        cube(withFaceMask: [.positiveX], colour: grayTone, transform: transform, inwardNormals: true, triangleMask: uint(TRIANGLE_MASK_BOX_POSX),vertices: &vertices, indices: &indices, normals: &normals, uvCoords: &uvCoords, colours: &colours, masks: &masks)
        
        cube(withFaceMask: [.negativeY], colour: grayTone, transform: transform, inwardNormals: true, triangleMask: uint(TRIANGLE_MASK_BOX_NEGY),vertices: &vertices, indices: &indices, normals: &normals, uvCoords: &uvCoords, colours: &colours, masks: &masks)
        
        cube(withFaceMask: [.positiveY], colour: grayTone, transform: transform, inwardNormals: true, triangleMask: uint(TRIANGLE_MASK_BOX_POSY),vertices: &vertices, indices: &indices, normals: &normals, uvCoords: &uvCoords, colours: &colours, masks: &masks)
        
        cube(withFaceMask: [.negativeZ], colour: grayTone, transform: transform, inwardNormals: true, triangleMask: uint(TRIANGLE_MASK_BOX_NEGZ),vertices: &vertices, indices: &indices, normals: &normals, uvCoords: &uvCoords, colours: &colours, masks: &masks)
        
        // All 5 Faces (not used at the moment)
        // cube(withFaceMask: [.negativeX, .positiveX, .negativeY, .positiveY, .negativeZ], colour: grayTone, transform: transform, inwardNormals: true, triangleMask: uint(TRIANGLE_MASK_BOX_NEGZ),vertices: &vertices, indices: &indices, normals: &normals, uvCoords: &uvCoords, colours: &colours, masks: &masks)
        
        
        // MARK: - Place Object
        transform = Matrix4x4.translation(0, 0, 0) *
                    Matrix4x4.rotation(radians: objectRotationX.degreesToRadians, axis: simd_float3(1, 0, 0)) *
                    Matrix4x4.rotation(radians: objectRotationY.degreesToRadians, axis: simd_float3(0, 1, 0)) *
                    Matrix4x4.rotation(radians: objectRotationZ.degreesToRadians, axis: simd_float3(0, 0, 1)) *
                    Matrix4x4.scale(objectScaleFactor, objectScaleFactor, objectScaleFactor)
        
        object(colour: simd_float3([0.725, 0.710, 0.680]), // default gray, is overwritten
                transform: transform,
                inwardNormals: false,
                triangleMask: uint(TRIANGLE_MASK_OBJECT),
                vertices: &vertices,
                indices: &indices,
                normals: &normals,
                uvCoords: &uvCoords,
                colours: &colours,
                masks: &masks)
        }
    
    // MARK: Geometry Provider for the Advanced Ray Tracer
    func geometryProvider() {
        
        // Fill Materials Array (0 = Light, 1 = Box, 2 = Object)
        materialData.append(rtMaterialLightSource())
        
        // materialData.append(rtMaterialCornellBox())
        materialData.append(rtMaterialCornellBoxNegX())
        materialData.append(rtMaterialCornellBoxPosX())
        materialData.append(rtMaterialCornellBoxNegY())
        materialData.append(rtMaterialCornellBoxPosY())
        materialData.append(rtMaterialCornellBoxNegZ())
        
        materialData.append(rtMaterialMetaballObject())
        
        
        // Treat GEOMETRY
        let globalTriangleIndex: UInt32 = 0
        var totalLightArea: Float = 0.0
        var totalLightScaledArea: Float = 0.0
        
        let triangleCount = vertices.count / 3
        _triangleCount = triangleCount
        
        print("Vertices Count: \(vertices.count)")
        print("Indices Count: \(indices.count)")
        print("Normals Count: \(normals.count)")
        print("UVCoords Count: \(uvCoords.count)")
        print("Colors Count: \(colours.count)")
        print("Masks Count: \(masks.count)")
        
        for i in 0..<vertices.count {
            
            var vertex = Vertex()
            vertex.v = vertices[i]
            vertex.n = normals[i]
            vertex.t = uvCoords[i]
            // colors ignored for now
            
            vertexData.append(vertex)
        }
        
        
        for i in 0..<triangleCount {
            
            let v0:Vertex = vertexData[i * 3 + 0]
            let v1:Vertex = vertexData[i * 3 + 1]
            let v2:Vertex = vertexData[i * 3 + 2]
            
            let material:Material = materialData[Int(masks[i])]
            
            let emissiveScale = simd_dot(material.emissive, simd_float3(0.2126, 0.7152, 0.0722))
            let area = 0.5 * simd_length(simd_cross(v2.v - v0.v, v1.v - v0.v))
            let scaledArea = area * emissiveScale
            
            
            var triangle = Triangle()
            triangle.area = area
            triangle.discretePdf = 0.0
            triangle.materialIndex = masks[i]
            
            triangleData.append(triangle)
            
            // for Light Sources
            if simd_length(material.emissive) > 0.0 {
                
                var emitterTriangle = EmitterTriangle()
                
                emitterTriangle.area = area
                emitterTriangle.scaledArea = scaledArea
                emitterTriangle.globalIndex = globalTriangleIndex
                emitterTriangle.v0 = v0
                emitterTriangle.v1 = v1
                emitterTriangle.v2 = v2
                emitterTriangle.emissive = material.emissive
                totalLightArea += emitterTriangle.area
                totalLightScaledArea += emitterTriangle.scaledArea
                
                emitterTriangleData.append(emitterTriangle)
            }
            
        }
        
        _emitterTriangleCount = UInt32(emitterTriangleData.count)
        var emittersCDFIntegral: Float = 0.0
        
        for i in 0..<emitterTriangleData.count {
            
            emitterTriangleData[i].cdf = emittersCDFIntegral
            emitterTriangleData[i].discretePdf = emitterTriangleData[i].scaledArea / totalLightScaledArea

            triangleData[Int(emitterTriangleData[i].globalIndex)].discretePdf = emitterTriangleData[i].discretePdf
            emittersCDFIntegral += emitterTriangleData[i].scaledArea
        }
        
        // why?? reset other values??
        // emitterTriangleBuffer.emplace_back();
        // emitterTriangleBuffer.back().cdf = emittersCDFIntegral;
        
        for i in 0..<emitterTriangleData.count { emitterTriangleData[i].cdf /= emittersCDFIntegral }
        
        // INDICES... ?? should this be performed?
        for i in 0..<indices.count {
            
            // method1
//            var indicie = UInt32()
//            indicie = indices[i]
//            indexData.append(indicie)
            
            // method2 (like in objc)
            indices[i] = UInt32(i)
            indexData.append(indices[i])
        }
        
    }
    
}
