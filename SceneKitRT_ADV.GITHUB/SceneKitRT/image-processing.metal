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

using namespace metal;

kernel void accumulateImage(texture2d<float, access::read_write> image [[texture(0)]],
                            device const AdvancedRay* rays [[buffer(0)]],
                            constant ApplicationData& appData [[buffer(1)]],
                            uint2 coordinates [[thread_position_in_grid]],
                            uint2 size [[threads_per_grid]])
{
    if (appData.frameIndex == 0)
        image.write(0.0f, coordinates);

    uint rayIndex = coordinates.x + coordinates.y * size.x;
    device const AdvancedRay& currentRay = rays[rayIndex];
    if (currentRay.completed && (currentRay.generation < MAX_SAMPLES))
    {
        
        // ORIG
        float4 outputColor = float4(rays[rayIndex].radiance, 1.0);

        if (any(isnan(outputColor)))
            outputColor = float4(1000.0f, 0.0f, 1000.0, 1.0f);

        if (any(isinf(outputColor)))
            outputColor = float4(1000.0f, 0.0f, 0.0f, 1.0f);

        //*
        if (any(outputColor < 0.0f))
            outputColor = float4(0.0f, 1000.0f, 1000.0, 1.0f);
        // */
        
        
        
        // Test
//        float4 outputColor = float4(rays[rayIndex].radiance, 1.0);
//
//        if (any(isnan(outputColor)))
//            outputColor = normalize(float4(rays[rayIndex].radiance, 1.0));
//
//        if (any(isinf(outputColor)))
//            outputColor = normalize(float4(rays[rayIndex].radiance, 1.0));
//
//        //*
//        if (any(outputColor < 0.0f))
//            //outputColor = float4(0.0f, 1000.0f, 1000.0, 1.0f);
//            outputColor = float4(0.0f, 0.0f, 0.0, 1.0f);
//        // */
        
        // Test
        // float4 outputColor = normalize(float4(rays[rayIndex].radiance, 1.0));


#if (ENABLE_IMAGE_ACCUMULATION)
        uint index = currentRay.generation;
        
        // orig
//        if (index > 0)
//        {
//            float t = 1.0f / float(index + 1.0f);
//            float4 storedColor = image.read(coordinates);
//            outputColor = mix(storedColor, outputColor, t);
//        }
        
        // test (adaptation from Apple Ray Tracer)
        if (index > 0)
        {
            float4 storedColor = image.read(coordinates);
            storedColor *= index;
            
            outputColor += storedColor;
            outputColor /= (index + 1);
        }
        
        
#endif

        image.write(outputColor, coordinates);
    }
}

