//
//  MatrixMath.swift
//  SceneKit RT
//
//  Extended/Modifyed by Philipp Zay on 16.04.22.
//
//  ORIGINAL
//  Created by Viktor Chernikov on 20/04/2019.
//  Copyright © 2019 Viktor Chernikov. All rights reserved.
//

import simd

struct Matrix4x4 {
    static func translation(_ x: Float, _ y: Float, _ z: Float) -> matrix_float4x4 {
        return matrix_float4x4(rows: [simd_float4([1, 0, 0, x]),
                                      simd_float4([0, 1, 0, y]),
                                      simd_float4([0, 0, 1, z]),
                                      simd_float4([0, 0, 0, 1])])
    }

    static func scale(_ x: Float, _ y: Float, _ z: Float) -> matrix_float4x4 {
        return matrix_float4x4(diagonal: simd_float4([x, y, z, 1]))
    }

    static func rotation(radians: Float, axis: simd_float3) -> matrix_float4x4 {
        let unitAxis = normalize(axis)
        let ct = cosf(radians)
        let st = sinf(radians)
        let ci = 1 - ct
        let x = unitAxis.x, y = unitAxis.y, z = unitAxis.z
        return matrix_float4x4(columns:(simd_float4(    ct + x * x * ci, y * x * ci + z * st, z * x * ci - y * st, 0),
                                        simd_float4(x * y * ci - z * st,     ct + y * y * ci, z * y * ci + x * st, 0),
                                        simd_float4(x * z * ci + y * st, y * z * ci - x * st,     ct + z * z * ci, 0),
                                        simd_float4(                  0,                   0,                   0, 1)))
    }
}
