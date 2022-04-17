//
//  GeometryObject.swift
//  SceneKit RT
//
//  Created by Philipp Zay on 16.04.22.
//

import simd
import SceneKit

func object(colour:         simd_float3,
          transform:        matrix_float4x4,
          inwardNormals:    Bool,
          triangleMask:     uint,
          vertices:         inout [simd_float3],
          normals:          inout [simd_float3],
          colours:          inout [simd_float3],
          masks:            inout [uint])
{
    
    // Shift Data
    let rayBoxShift = simd_float3(objectShiftX,objectShiftY,objectShiftZ)
    let rayBoxOffset = simd_float3(0,1,0)
    
    // Temp Arrays for Matrix Transformation
    var cubeVertices : [simd_float3] = []
    var cubeNormals  : [simd_float3] = []
    
    // Fill in the Arrays
    for i in 0 ..< ii.count {
        
        let index = Int(ii[i])
        cubeVertices.append(simd_float3(vv[index]))
        cubeNormals.append(simd_float3(nn[index]))
        masks.append(contentsOf: [triangleMask])
        
        switch isGrayObject {
        case true:
            // colours.append(simd_float3(Float.random(in: 0.0...1.0), Float.random(in: 0.0...1.0), Float.random(in: 0.0...1.0))) // Random Colors
            colours.append(simd_float3([0.725, 0.710, 0.680]))
        case false:
            colours.append(colour)
        }
        
    }
    
    // Treat the Goemetry
    cubeVertices = cubeVertices.map { vertex in
        var transformed = simd_float4(vertex.x, vertex.y, vertex.z, 1)
        transformed = transform * transformed
        return simd_float3(x: transformed.x, y: transformed.y, z: transformed.z)
    }
    
    cubeNormals = cubeNormals.map { normal in
        var normaled = simd_float4(normal.x, normal.y, normal.z, 1)
        normaled = transform * normaled
        return simd_float3(x: normaled.x, y: normaled.y, z: normaled.z) // normalize this?
    }
    
    // Fill the Data for the Triangle Structure
    for i in 0..<ii.count {
        vertices.append(cubeVertices[i] + rayBoxOffset + rayBoxShift)
        normals.append(cubeNormals[i])
    }

}

// for Beta Ray Tracer
func object(colour:           simd_float3,
            transform:        matrix_float4x4,
            inwardNormals:    Bool,
            triangleMask:     uint,
            vertices:         inout [simd_float3],
            indices:          inout [UInt32],
            normals:          inout [simd_float3],
            uvCoords:         inout [simd_float2],
            colours:          inout [simd_float3],
            masks:            inout [uint])
{
    
    
    // Shift Data
    let rayBoxShift = simd_float3(objectShiftX,objectShiftY,objectShiftZ)
    let rayBoxOffset = simd_float3(0,1,0)
    
    // Temp Arrays for Matrix Transformation
    var cubeVertices : [simd_float3] = []
    var cubeNormals  : [simd_float3] = []
    
    for i in 0 ..< ii.count {
    
        let index = Int(ii[i])
        cubeVertices.append(simd_float3(vv[index]))
        cubeNormals.append(simd_float3(nn[index]))
        uvCoords.append(simd_float2(tt[index]))
         
        masks.append(contentsOf: [triangleMask])
        
        switch isGrayObject {
        case true:
            // colours.append(simd_float3(Float.random(in: 0.0...1.0), Float.random(in: 0.0...1.0), Float.random(in: 0.0...1.0))) // Random Colors
            colours.append(simd_float3([0.725, 0.710, 0.680]))
        case false:
            colours.append(colour)
        }
       
    }
    
    cubeVertices = cubeVertices.map { vertex in
        var transformed = simd_float4(vertex.x, vertex.y, vertex.z, 1)
        transformed = transform * transformed
        return simd_float3(x: transformed.x, y: transformed.y, z: transformed.z)
    }
    
    cubeNormals = cubeNormals.map { normal in
        var normaled = simd_float4(normal.x, normal.y, normal.z, 1)
        normaled = transform * normaled
        return simd_float3(x: normaled.x, y: normaled.y, z: normaled.z) // normalize this?
    }
    
    
    // Fill the Data for the Triangle Structure
    for i in 0..<ii.count {
        vertices.append(cubeVertices[i] + rayBoxOffset + rayBoxShift)
        normals.append(cubeNormals[i])
        indices.append(UInt32(ii[i]))
    }
    
    
}
