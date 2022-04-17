//
//  GeometryBox.swift
//  SceneKit RT
//
//  Extended/Modifyed by Philipp Zay on 16.04.22.
//
//  ORIGINAL
//  Created by Viktor Chernikov on 19/04/2019.
//  Copyright © 2019 Viktor Chernikov. All rights reserved.
//

import simd

struct FaceMask : OptionSet {
    let rawValue: UInt32

    static let negativeX = FaceMask(rawValue: 1 << 0)
    static let positiveX = FaceMask(rawValue: 1 << 1)
    static let negativeY = FaceMask(rawValue: 1 << 2)
    static let positiveY = FaceMask(rawValue: 1 << 3)
    static let negativeZ = FaceMask(rawValue: 1 << 4)
    static let positiveZ = FaceMask(rawValue: 1 << 5)
    static let all: FaceMask = [.negativeX, .negativeY, .negativeZ,
                                .positiveX, .positiveY, .positiveZ]
}

fileprivate func triangleNormal(v0: simd_float3, v1: simd_float3, v2: simd_float3) -> simd_float3 {
    return simd_cross( simd_normalize(v1 - v0), simd_normalize(v2 - v0) )
}

fileprivate func cubeFace(withCubeVertices cubeVertices:[simd_float3],
                          colour: simd_float3,
                          index0: Int,
                          index1: Int,
                          index2: Int,
                          index3: Int,
                          inwardNormals: Bool,
                          triangleMask: uint,
                          vertices: inout [simd_float3],
                          normals: inout [simd_float3],
                          colours: inout [simd_float3],
                          masks: inout [uint]) {

    let v0 = cubeVertices[index0]
    let v1 = cubeVertices[index1]
    let v2 = cubeVertices[index2]
    let v3 = cubeVertices[index3]

    var n0 = triangleNormal(v0: v0, v1: v1, v2: v2)
    var n1 = triangleNormal(v0: v0, v1: v2, v2: v3)
    if inwardNormals {
        n0 = -n0
        n1 = -n1
    }

    vertices.append(contentsOf: [v0, v1, v2, v0, v2, v3])
    normals.append(contentsOf: [n0, n0, n0, n1, n1, n1])
    colours.append(contentsOf: [simd_float3](repeating: colour, count: 6))
    masks.append(contentsOf: [triangleMask, triangleMask])
}

func cube(withFaceMask faceMask: FaceMask,
          colour: simd_float3,
          transform: matrix_float4x4,
          inwardNormals: Bool,
          triangleMask: uint,
          vertices: inout [simd_float3],
          normals: inout [simd_float3],
          colours: inout [simd_float3],
          masks: inout [uint])
{
    var cubeVertices = [
        simd_float3(-0.5, -0.5, -0.5),
        simd_float3( 0.5, -0.5, -0.5),
        simd_float3(-0.5,  0.5, -0.5),
        simd_float3( 0.5,  0.5, -0.5),
        simd_float3(-0.5, -0.5,  0.5),
        simd_float3( 0.5, -0.5,  0.5),
        simd_float3(-0.5,  0.5,  0.5),
        simd_float3( 0.5,  0.5,  0.5),
    ]

    cubeVertices = cubeVertices.map { vertex in
        var transformed = simd_float4(vertex.x, vertex.y, vertex.z, 1)
        transformed = transform * transformed
        return simd_float3(x: transformed.x, y: transformed.y, z: transformed.z)
    }

    if faceMask.contains(.negativeX) {
        cubeFace(withCubeVertices: cubeVertices, colour: colour,
                 index0: 0, index1: 4, index2: 6, index3: 2,
                 inwardNormals: inwardNormals, triangleMask: triangleMask,
                 vertices: &vertices, normals: &normals, colours: &colours, masks: &masks)
    }

    if faceMask.contains(.positiveX) {
        cubeFace(withCubeVertices: cubeVertices, colour: colour,
                 index0: 1, index1: 3, index2: 7, index3: 5,
                 inwardNormals: inwardNormals, triangleMask: triangleMask,
                 vertices: &vertices, normals: &normals, colours: &colours, masks: &masks)
    }

    if faceMask.contains(.negativeY) {
        cubeFace(withCubeVertices: cubeVertices, colour: colour,
                 index0: 0, index1: 1, index2: 5, index3: 4,
                 inwardNormals: inwardNormals, triangleMask: triangleMask,
                 vertices: &vertices, normals: &normals, colours: &colours, masks: &masks)
    }

    if faceMask.contains(.positiveY) {
        cubeFace(withCubeVertices: cubeVertices, colour: colour,
                 index0: 2, index1: 6, index2: 7, index3: 3,
                 inwardNormals: inwardNormals, triangleMask: triangleMask,
                 vertices: &vertices, normals: &normals, colours: &colours, masks: &masks)
    }

    if faceMask.contains(.negativeZ) {
        cubeFace(withCubeVertices: cubeVertices, colour: colour,
                 index0: 0, index1: 2, index2: 3, index3: 1,
                 inwardNormals: inwardNormals, triangleMask: triangleMask,
                 vertices: &vertices, normals: &normals, colours: &colours, masks: &masks)
    }

    if faceMask.contains(.positiveZ) {
        cubeFace(withCubeVertices: cubeVertices, colour: colour,
                 index0: 4, index1: 5, index2: 7, index3: 6,
                 inwardNormals: inwardNormals, triangleMask: triangleMask,
                 vertices: &vertices, normals: &normals, colours: &colours, masks: &masks)
    }
}

// for Advanced Ray Tracer
fileprivate func cubeFace(withCubeVertices cubeVertices:[simd_float3],
                          colour: simd_float3,
                          index0: Int,
                          index1: Int,
                          index2: Int,
                          index3: Int,
                          inwardNormals: Bool,
                          triangleMask: uint,
                          vertices: inout [simd_float3],
                          indices: inout [UInt32],
                          normals: inout [simd_float3],
                          uvCoords: inout [simd_float2],
                          colours: inout [simd_float3],
                          masks: inout [uint]) {

    let v0 = cubeVertices[index0]
    let v1 = cubeVertices[index1]
    let v2 = cubeVertices[index2]
    let v3 = cubeVertices[index3]

    var n0 = triangleNormal(v0: v0, v1: v1, v2: v2)
    var n1 = triangleNormal(v0: v0, v1: v2, v2: v3)
    if inwardNormals {
        n0 = -n0
        n1 = -n1
    }

    // Texture Coordinates
    let uv0 = simd_float2(n0.x, n0.y)
    let uv1 = simd_float2(n1.x, n1.y)
    
    vertices.append(contentsOf: [v0, v1, v2, v0, v2, v3])
    normals.append(contentsOf: [n0, n0, n0, n1, n1, n1])
    uvCoords.append(contentsOf: [uv0, uv0, uv0, uv1, uv1, uv1])
    indices.append(contentsOf: [UInt32(index0), UInt32(index1), UInt32(index2), UInt32(index0), UInt32(index2), UInt32(index3)])
    colours.append(contentsOf: [simd_float3](repeating: colour, count: 6))
    masks.append(contentsOf: [triangleMask, triangleMask])
    
}

func cube(withFaceMask faceMask: FaceMask,
          colour: simd_float3,
          transform: matrix_float4x4,
          inwardNormals: Bool,
          triangleMask: uint,
          vertices: inout [simd_float3],
          indices: inout [UInt32],
          normals: inout [simd_float3],
          uvCoords: inout [simd_float2],
          colours: inout [simd_float3],
          masks: inout [uint])
{
    var cubeVertices = [
        simd_float3(-0.5, -0.5, -0.5),
        simd_float3( 0.5, -0.5, -0.5),
        simd_float3(-0.5,  0.5, -0.5),
        simd_float3( 0.5,  0.5, -0.5),
        simd_float3(-0.5, -0.5,  0.5),
        simd_float3( 0.5, -0.5,  0.5),
        simd_float3(-0.5,  0.5,  0.5),
        simd_float3( 0.5,  0.5,  0.5),
    ]

    cubeVertices = cubeVertices.map { vertex in
        var transformed = simd_float4(vertex.x, vertex.y, vertex.z, 1)
        transformed = transform * transformed
        return simd_float3(x: transformed.x, y: transformed.y, z: transformed.z)
    }

    if faceMask.contains(.negativeX) {
        cubeFace(withCubeVertices: cubeVertices, colour: colour,
                 index0: 0, index1: 4, index2: 6, index3: 2,
                 inwardNormals: inwardNormals, triangleMask: triangleMask,
                 vertices: &vertices, indices: &indices, normals: &normals, uvCoords: &uvCoords, colours: &colours, masks: &masks)
    }

    if faceMask.contains(.positiveX) {
        cubeFace(withCubeVertices: cubeVertices, colour: colour,
                 index0: 1, index1: 3, index2: 7, index3: 5,
                 inwardNormals: inwardNormals, triangleMask: triangleMask,
                 vertices: &vertices, indices: &indices, normals: &normals, uvCoords: &uvCoords, colours: &colours, masks: &masks)
    }

    if faceMask.contains(.negativeY) {
        cubeFace(withCubeVertices: cubeVertices, colour: colour,
                 index0: 0, index1: 1, index2: 5, index3: 4,
                 inwardNormals: inwardNormals, triangleMask: triangleMask,
                 vertices: &vertices, indices: &indices, normals: &normals, uvCoords: &uvCoords, colours: &colours, masks: &masks)
    }

    if faceMask.contains(.positiveY) {
        cubeFace(withCubeVertices: cubeVertices, colour: colour,
                 index0: 2, index1: 6, index2: 7, index3: 3,
                 inwardNormals: inwardNormals, triangleMask: triangleMask,
                 vertices: &vertices, indices: &indices, normals: &normals, uvCoords: &uvCoords, colours: &colours, masks: &masks)
    }

    if faceMask.contains(.negativeZ) {
        cubeFace(withCubeVertices: cubeVertices, colour: colour,
                 index0: 0, index1: 2, index2: 3, index3: 1,
                 inwardNormals: inwardNormals, triangleMask: triangleMask,
                 vertices: &vertices, indices: &indices, normals: &normals, uvCoords: &uvCoords, colours: &colours, masks: &masks)
    }

    if faceMask.contains(.positiveZ) {
        cubeFace(withCubeVertices: cubeVertices, colour: colour,
                 index0: 4, index1: 5, index2: 7, index3: 6,
                 inwardNormals: inwardNormals, triangleMask: triangleMask,
                 vertices: &vertices, indices: &indices, normals: &normals, uvCoords: &uvCoords, colours: &colours, masks: &masks)
    }
}
