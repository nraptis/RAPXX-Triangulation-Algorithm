//
//  GaussianBlur.metal
//  StereoScope
//
//  Created by Nick Raptis on 5/24/24.
//
//  Verified on 11/9/2024 by Nick Raptis
//

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

#define SpriteNodeIndexedVertexIndexData 0
#define SpriteNodeIndexedVertexIndexUniforms 1

#define SpriteNodeIndexedFragmentIndexTexture 0
#define SpriteNodeIndexedFragmentIndexSampler 1
#define SpriteNodeIndexedFragmentIndexUniforms 2

typedef struct {
    matrix_float4x4 projectionMatrix;
    matrix_float4x4 modelViewMatrix;
} SpriteVertexUniforms;

typedef struct {
    float r;
    float g;
    float b;
    float a;
} SpriteFragmentUniforms;

typedef struct {
    packed_float2 position [[]];
    packed_float2 textureCoord [[]];
} SpriteNodeIndexedVertex;

typedef struct {
    float4 position [[position]];
    float2 textureCoord;
} InOut;

vertex InOut gaussian_blur_vertex(constant SpriteNodeIndexedVertex *verts [[buffer(SpriteNodeIndexedVertexIndexData)]],
                                                uint vid [[vertex_id]],
                                                constant SpriteVertexUniforms & uniforms [[ buffer(SpriteNodeIndexedVertexIndexUniforms) ]]) {
    InOut out;
    float4 position = float4(verts[vid].position, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    return out;
}

fragment float4 gaussian_blur_horizontal_fragment(InOut in [[stage_in]],
                                                     constant SpriteFragmentUniforms & uniforms [[ buffer(SpriteNodeIndexedFragmentIndexUniforms) ]],
                                                     texture2d<half> colorMap [[ texture(SpriteNodeIndexedFragmentIndexTexture) ]],
                                                     sampler colorSampler [[ sampler(SpriteNodeIndexedFragmentIndexSampler) ]]) {
    float2 center = in.textureCoord;
    float width = colorMap.get_width();
    float stepX = (1.0 / width);
    half3 sum = half3(0.0, 0.0, 0.0);
    sum += colorMap.sample(colorSampler, float2(center.x - stepX * 3.0, center.y)).rgb * 0.07;
    sum += colorMap.sample(colorSampler, float2(center.x - stepX * 2.0, center.y)).rgb * 0.105;
    sum += colorMap.sample(colorSampler, float2(center.x - stepX, center.y)).rgb * 0.175;
    sum += colorMap.sample(colorSampler, float2(center.x, center.y)).rgb * 0.30;
    sum += colorMap.sample(colorSampler, float2(center.x + stepX, center.y)).rgb * 0.175;
    sum += colorMap.sample(colorSampler, float2(center.x + stepX * 2.0, center.y)).rgb * 0.105;
    sum += colorMap.sample(colorSampler, float2(center.x + stepX * 3.0, center.y)).rgb * 0.07;
    float r = clamp((float)sum[0], 0.0, 1.0);
    float g = clamp((float)sum[1], 0.0, 1.0);
    float b = clamp((float)sum[2], 0.0, 1.0);
    return float4(r, g, b, 1.0);
}

fragment float4 gaussian_blur_vertical_fragment(InOut in [[stage_in]],
                                                    constant SpriteFragmentUniforms & uniforms [[ buffer(SpriteNodeIndexedFragmentIndexUniforms) ]],
                                                    texture2d<half> colorMap [[ texture(SpriteNodeIndexedFragmentIndexTexture) ]],
                                                    sampler colorSampler [[ sampler(SpriteNodeIndexedFragmentIndexSampler) ]]) {
    float2 center = in.textureCoord;
    float aHeight = colorMap.get_height();
    float aStepY = (1.0 / aHeight);
    half3 sum = half3(0.0, 0.0, 0.0);
    sum += colorMap.sample(colorSampler, float2(center.x, center.y - aStepY * 3.0)).rgb * 0.07;
    sum += colorMap.sample(colorSampler, float2(center.x, center.y - aStepY * 2.0)).rgb * 0.105;
    sum += colorMap.sample(colorSampler, float2(center.x, center.y - aStepY)).rgb * 0.175;
    sum += colorMap.sample(colorSampler, float2(center.x, center.y)).rgb * 0.30;
    sum += colorMap.sample(colorSampler, float2(center.x, center.y + aStepY)).rgb * 0.175;
    sum += colorMap.sample(colorSampler, float2(center.x, center.y + aStepY * 2.0)).rgb * 0.105;
    sum += colorMap.sample(colorSampler, float2(center.x, center.y + aStepY * 3.0)).rgb * 0.07;
    float r = clamp((float)sum[0], 0.0, 1.0);
    float g = clamp((float)sum[1], 0.0, 1.0);
    float b = clamp((float)sum[2], 0.0, 1.0);
    return float4(r, g, b, 1.0);
}
