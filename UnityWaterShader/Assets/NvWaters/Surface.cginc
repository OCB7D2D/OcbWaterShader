// Copyright (c) 2016 Unity Technologies. MIT license - license_unity.txt
// #NVJOB Water Shaders. MIT license - license_nvjob.txt
// #NVJOB Water Shaders v2.0 - https://nvjob.github.io/unity/nvjob-water-shaders-v2
// #NVJOB Nicholas Veselov - https://nvjob.github.io
// Support this asset - https://nvjob.github.io/donate

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#include "Tessellation.cginc"

float4 tess (appdata_full v0, appdata_full v1, appdata_full v2)
{
    #ifdef EFFECT_TESSELLATE
        #if defined(TESS_LENGTH_ALL)
            return UnityEdgeLengthBasedTess(v0.vertex, v1.vertex, v2.vertex,
                    _TessEdgeLength);
        #elif defined(TESS_LENGTH_CULL)
            return UnityEdgeLengthBasedTessCull(v0.vertex, v1.vertex, v2.vertex,
                    _TessEdgeLength, _TessMaxDisp);
        #else // default mode is to tesselate based on distance
            return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex,
                    _TessMinDist, _TessMaxDist, _TessSubdivide);
        #endif
    #else
        return float4(1,1,1,0);
    #endif
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void vert (inout appdata_full v)
{
    #ifdef DISTANT_SHADER
        // move distant down
        v.vertex.y -= 0.075;
    #endif
    #ifdef EFFECT_TESSELLATE
        // Calculate world position to use for noise sampling
        float3 wp = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1));
        // UV coordinates to sample wave noise
        float2 uv = wp.xz * 0.5;
        // Move uv with wind
        #ifdef EFFECT_WIND
            uv += _WindTime;
        #endif
        // Sample noise algorithm
        float noise = Noise2D(uv);
        // Muliply with wind speed
        #ifdef EFFECT_WIND
            noise *= _Wind;
        #endif
        // Modify the vertex to form waves
        v.vertex.y += (noise * 0.5) - 0.25;
        // Store noise value for fragment shader
        v.color.r = noise;
    #endif
    // Transfer eye-depth to fragment shader
    COMPUTE_EYEDEPTH(v.color.a);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef SPECULAR_WORKFLOW
    void surf(Input IN, inout SurfaceOutput o)
#else
    void surf(Input IN, inout SurfaceOutputStandard o)
#endif
{

    #include "Fragment.cginc"

    #ifdef SPECULAR_WORKFLOW
        o.Specular = _Shininess;
        o.Gloss = tex.a;
    #else
        o.Metallic = _Metallic;
        o.Smoothness = _Smoothness;
    #endif

    #ifdef EFFECT_WIND
        // Accentuate smoothness if it is windy
        // More reflective when weather is calm
        o.Smoothness *= 1 - _Wind * 0.425;
    #endif

    // Transition smoothness to avoid distant shader to look odd
    // Seems reflection is only done for the close/detail terrain
    #ifdef EFFECT_SMOOTH_TRANSITION
        float smooth = pow(smoothstep(_SmoothTransition.y,  _SmoothTransition.x, IN.color.a), _SmoothTransition.z);
        o.Smoothness *= smooth;
        o.Metallic *= smooth;
    #endif

}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////