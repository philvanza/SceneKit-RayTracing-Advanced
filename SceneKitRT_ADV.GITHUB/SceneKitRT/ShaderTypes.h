//
//  ShaderTypes.h
//  SceneKit RT
//
//  Extended/Modifyed by Philipp Zay on 16.04.22.
//
//  ORIGINAL
//  Created by Viktor Chernikov on 16/04/2019.
//  Copyright © 2019 Viktor Chernikov. All rights reserved.
//

//
//  Header containing types and enum constants shared between Metal shaders and Swift/ObjC source
//

/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Header containing types and enum constants shared between Metal shaders and Swift/ObjC source
*/

#ifndef ShaderTypes_h
#define ShaderTypes_h

#include <MetalPerformanceShaders/MetalPerformanceShaders.h>
#include <simd/simd.h>

// MARK: - Common Renderer
#define TRIANGLE_MASK_GEOMETRY 1
#define TRIANGLE_MASK_LIGHT    2
#define TRIANGLE_MASK_REFLECT  3 // Added by Phil

#define RAY_MASK_PRIMARY   3
#define RAY_MASK_SHADOW    1
#define RAY_MASK_SECONDARY 1

// ORIG
//#define TRIANGLE_MASK_GEOMETRY 1
//#define TRIANGLE_MASK_LIGHT    2
//
//#define RAY_MASK_PRIMARY   3
//#define RAY_MASK_SHADOW    1
//#define RAY_MASK_SECONDARY 1

// MARK: Structs

struct Camera {
    vector_float3 position;
    vector_float3 right;
    vector_float3 up;
    vector_float3 forward;
};

struct AreaLight {
    vector_float3 position;
    vector_float3 forward;
    vector_float3 right;
    vector_float3 up;
    vector_float3 color;
    float factor;
};

struct Uniforms
{
    unsigned int width;
    unsigned int height;
    unsigned int frameIndex;
    struct Camera camera;
    struct AreaLight light;
};


// MARK: - for Advanced Renderer
#define TRIANGLE_MASK_ADV_LIGHT         0
        
#define TRIANGLE_MASK_BOX_NEGX          1
#define TRIANGLE_MASK_BOX_POSX          2
#define TRIANGLE_MASK_BOX_NEGY          3
#define TRIANGLE_MASK_BOX_POSY          4
#define TRIANGLE_MASK_BOX_NEGZ          5
// We have no front face!
        
// for the Object
#define TRIANGLE_MASK_OBJECT            6

// Constants
#define PI                              3.1415926536
#define DOUBLE_PI                       6.2831853072
#define INVERSE_PI                      0.3183098862

#define DISTANCE_EPSILON                0.0001111111
#define ANGLE_EPSILON                   0.0001523048

#define ENABLE_IMAGE_ACCUMULATION       1

#define MATERIAL_DIFFUSE                0
#define MATERIAL_CONDUCTOR              1
#define MATERIAL_PLASTIC                2
#define MATERIAL_DIELECTRIC             3

#define NOISE_BLOCK_SIZE                64 // is optimal size, bigger = slower

#define MAX_RUN_TIME_IN_SECONDS         86400 // (60 * 60 * 24) // one day
#define MAX_SAMPLES                     (0x7fffffff)
#define MAX_PATH_LENGTH                 (0x7fffffff)

#define CONTENT_SCALE                   2

// MARK: Structs
struct Vertex
{
    simd_float3 v;
    simd_float3 n;
    simd_float2 t;
};

struct Triangle
{
    uint materialIndex;
    float area;
    float discretePdf;
};

struct EmitterTriangle
{
    float area;
    float discretePdf;
    float scaledArea;
    float cdf;
    uint globalIndex;
    struct Vertex v0;
    struct Vertex v1;
    struct Vertex v2;
    simd_float3 emissive;
};

struct Material
{
    simd_float3 diffuse;
    uint type;
    simd_float3 specular;
    float roughness;
    simd_float3 transmittance;
    float extIOR;
    simd_float3 emissive;
    float intIOR;
};

struct AdvancedRay
{
    MPSRayOriginMinDistanceDirectionMaxDistance base;
    simd_float3 radiance;
    uint bounces;
    simd_float3 throughput;
    float misPdf;
    float eta;
    uint completed;
    uint generation;
};

struct LightSamplingRay
{
    MPSRayOriginMinDistanceDirectionMaxDistance base;
    uint targetPrimitiveIndex;
    simd_float3 throughput;
    simd_float3 n;
};

struct AdvancedCamera
{
    simd_float3 origin;
    float fov; // float fov = 90.0f;
    simd_float3 target;
    simd_float3 up;
};

struct ApplicationData
{
    simd_float3 environmentColor;
    float time;
    uint frameIndex;
    uint emitterTrianglesCount;
    bool enableLightSampling;
    bool enableBSDFSampling;
    bool enableRussianRoulette;
    // uint comparisonMode; // COMPARE_DISABLED
    struct AdvancedCamera camera;
};

struct SampledMaterial
{
    simd_float3 direction;
    float pdf;
    simd_float3 bsdf;
    uint valid;
    simd_float3 weight;
    float eta;
};

struct RandomSample
{
    simd_float2 pixelSample;
    simd_float2 barycentricSample;
    simd_float2 bsdfSample;
    simd_float2 emitterBsdfSample;
    float componentSample;
    float emitterSample;
    float rrSample;
};

struct LightSample
{
    simd_float3 value;
    float samplePdf;
    simd_float3 direction;
    float emitterPdf;
    uint primitiveIndex;
    uint valid;
};

//using Intersection = MPSIntersectionDistancePrimitiveIndexCoordinates;
//using LightSamplingIntersection = MPSIntersectionDistancePrimitiveIndex;



#endif /* ShaderTypes_h */
