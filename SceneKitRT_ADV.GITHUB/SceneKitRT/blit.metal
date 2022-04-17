//
//  blit.metal
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

struct BlitVertexOut
{
    float4 pos [[position]];
    float2 coords;
};

constant constexpr static const float4 fullscreenTrianglePositions[3]
{
    {-1.0, -1.0, 0.0, 1.0},
    { 3.0, -1.0, 0.0, 1.0},
    {-1.0,  3.0, 0.0, 1.0}
};

vertex BlitVertexOut blitVertex(uint vertexIndex [[vertex_id]])
{
    BlitVertexOut out;
    out.pos = fullscreenTrianglePositions[vertexIndex];
    out.coords = out.pos.xy * 0.5 + 0.5;
    return out;
}

fragment float4 blitFragment(BlitVertexOut in [[stage_in]],
                             constant ApplicationData& appData [[buffer(0)]],
                             texture2d<float> image [[texture(0)]]
                             // texture2d<float> reference [[texture(1)]]
                             )
{
    
    // Original Code
//    constexpr sampler defaultSampler(coord::normalized, filter::nearest);
//    float4 color = image.sample(defaultSampler, in.coords);
//
//    return color;
    
    
    // New Code - Taken from other Ray Tracer - makes better images
    constexpr sampler sam(min_filter::nearest, mag_filter::nearest, mip_filter::none);
    
    float3 color = image.sample(sam, in.coords).xyz;
    
    // Apply a very simple tonemapping function to reduce the dynamic range of the
    // input image into a range which can be displayed on screen.
    color = color / (1.0f + color);
    
    return float4(color, 1.0f);
    
    
    
    
    
}
