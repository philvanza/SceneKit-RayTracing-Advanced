//
//  base-ray-tracing.metal
//  SceneKit RT
//
//  Extended/Modifyed by Philipp Zay on 16.04.22.
//
//  ORIGINAL
//  Metal ray-tracer
//
//  Created by Sergey Reznik on 9/15/18.
//  Copyright © 2018 Serhii Rieznik. All rights reserved.
//

#include <metal_stdlib>
#include "ShaderTypes.h"
#include "raytracing.h"
#include "materials.h"

using namespace metal;

using Intersection = MPSIntersectionDistancePrimitiveIndexCoordinates;
using LightSamplingIntersection = MPSIntersectionDistancePrimitiveIndex;

kernel void generateLightSamplingRays(device const Intersection* intersections [[buffer(0)]],
                                      device const Material* materials [[buffer(1)]],
                                      device const Triangle* triangles [[buffer(2)]],
                                      device const EmitterTriangle* emitterTriangles [[buffer(3)]],
                                      device const Vertex* vertices [[buffer(4)]],
                                      device packed_uint3* indices [[buffer(5)]],
                                      device const RandomSample* noise [[buffer(6)]],
                                      device AdvancedRay* rays [[buffer(7)]],
                                      device LightSamplingRay* lightSamplingRays [[buffer(8)]],
                                      constant ApplicationData& appData [[buffer(9)]],
                                      uint2 coordinates [[thread_position_in_grid]],
                                      uint2 size [[threads_per_grid]])
{
    uint rayIndex = coordinates.x + coordinates.y * size.x;
    device const Intersection& i = intersections[rayIndex];
    device const Triangle& triangle = triangles[i.primitiveIndex];
    device const Material& material = materials[triangle.materialIndex];
    device const packed_uint3& triangleIndices = indices[i.primitiveIndex];
    device const Vertex& a = vertices[triangleIndices.x];
    device const Vertex& b = vertices[triangleIndices.y];
    device const Vertex& c = vertices[triangleIndices.z];

    device LightSamplingRay& lightSamplingRay = lightSamplingRays[rayIndex];
    
    if ((i.distance < 0) || rays[rayIndex].completed)
    {
        lightSamplingRay.base.maxDistance = -1.0f;
        lightSamplingRay.targetPrimitiveIndex = uint(-2);
        return;
    }

    Vertex currentVertex = interpolate(a, b, c, i.coordinates);

    uint randomSampleIndex = (coordinates.x % NOISE_BLOCK_SIZE) + (coordinates.y % NOISE_BLOCK_SIZE) * NOISE_BLOCK_SIZE;
    device const RandomSample& randomSample = noise[randomSampleIndex];

    LightSample lightSample = sampleLight(currentVertex.v, currentVertex.n, emitterTriangles,
        appData.emitterTrianglesCount, randomSample);

    //*
    if (lightSample.valid == 0)
    {
        lightSamplingRay.base.maxDistance = -1.0f;
        lightSamplingRay.targetPrimitiveIndex = uint(-2);
        return;
    }
    // */

    SampledMaterial materialSample = evaluateMaterial(material, currentVertex.n,
        rays[rayIndex].base.direction, lightSample.direction);

    //*
    if ((materialSample.valid == 0) || (dot(currentVertex.n, lightSample.direction) <= 0.0f))
    {
        lightSamplingRay.base.maxDistance = -1.0f;
        lightSamplingRay.targetPrimitiveIndex = uint(-2);
        return;
    }
    // */


    float weights = { powerHeuristic(lightSample.samplePdf, materialSample.pdf) };

    lightSamplingRay.base.origin = currentVertex.v + lightSample.direction * DISTANCE_EPSILON;
    lightSamplingRay.base.direction = lightSample.direction;
    lightSamplingRay.base.minDistance = DISTANCE_EPSILON;
    lightSamplingRay.base.maxDistance = INFINITY;
    lightSamplingRay.targetPrimitiveIndex = lightSample.primitiveIndex;
    lightSamplingRay.throughput = (materialSample.bsdf * lightSample.value * weights);
    lightSamplingRay.n = currentVertex.n;
}

kernel void lightSamplingHandler(device const LightSamplingIntersection* intersections [[buffer(0)]],
                                 device const LightSamplingRay* lightSamplingRays [[buffer(1)]],
                                 device AdvancedRay* rays [[buffer(2)]],
                                 constant ApplicationData& appData [[buffer(3)]],
                                 uint2 coordinates [[thread_position_in_grid]],
                                 uint2 size [[threads_per_grid]])
{
    
    if (appData.enableLightSampling)
    {
        uint rayIndex = coordinates.x + coordinates.y * size.x;
        if (intersections[rayIndex].primitiveIndex == lightSamplingRays[rayIndex].targetPrimitiveIndex)
        {
            if (rays[rayIndex].bounces + 1 < MAX_PATH_LENGTH)
            {
                rays[rayIndex].radiance += rays[rayIndex].throughput * lightSamplingRays[rayIndex].throughput;
            }
        }
    }
    
    
}
