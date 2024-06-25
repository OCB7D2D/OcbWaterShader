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

fixed2 GetWindUvOffset()
{
    return _NvWatersMovement.xy * _WavesFlow;
}

#ifdef EFFECT_WAVE_NOISE
fixed VertexNoise(fixed2 uv)
{
    // uv = uv / 8;
    // UV coordinates to sample wave noise
    uv *= _WaveOptions[0];
    // Move uv with wind
    #ifdef EFFECT_WIND
        // uv += _WindTime * _WaveOptions[3];
        uv += _NvWatersMovement.xy * _WaveOptions[3]; // * _Wind + 0.025;
    #endif
    // Sample noise algorithm
    float noise = Noise2D(uv);
    // Muliply with wind speed
    #ifdef EFFECT_WIND
        noise = noise * _Wind; // - 0.35 * _Wind;
    #endif
    return noise;
}
#endif


fixed WavesNoise2(fixed2 uv, fixed2 offset)
{
    return VertexNoise(uv + offset);
}

void vert (inout appdata_full v)
{
    float4 v0 = v.vertex;
    // Base wave noise for effects
    #ifdef EFFECT_WAVE_NOISE
        float4 wp = mul(unity_ObjectToWorld, v0);
        wp.xyz += _OriginPos;
        // Get the base noise for y disposition (vertex up and down)
        float noiseY = WavesNoise2(wp.xz, float2(0, 0));
        // Displace the vertex vertical (up/down) to form waves
        #if defined(EFFECT_DISPLACE_VERTEX) || defined(EFFECT_DISPLACE_NORMAL)
            v0.y += (noiseY * _WaveOptions[1]) + _WaveOptions[2] * _Wind;
        #endif
        // Update vertex position (if not disabled)
        // Normals without displayment look weird!
        #ifdef EFFECT_DISPLACE_VERTEX
            v.vertex = v0;
        #endif
        // Store noise value for fragment shader
        // Other effects may want this info too
        v.color.r = noiseY;
    #endif
    // Special option for distant shader
    // In order to make seamless visual
    #ifdef DISTANT_SHADER
        // move surface down to avoid bad seams
        v.vertex.y += _DistantSurfaceOffset;
    #endif
    /*
    #if defined(EFFECT_WAVE_NOISE) 
        // && defined(DETAIL_SHADER)
        // Update normal by calculating derivates
        // Computes neighbouring noise to get slope
        #ifdef EFFECT_DISPLACE_NORMAL
            // float camDist = distance(_WorldSpaceCameraPos, wp.xyz);
            float4 vx = v.vertex + float4(_RenormStepDelta, 0.0, 0.0, 0.0);
            float4 vz = v.vertex + float4(0.0, 0.0, _RenormStepDelta, 0.0);
            float noiseX = VertexNoise(mul(unity_ObjectToWorld, vx).xz);
            float noiseZ = VertexNoise(mul(unity_ObjectToWorld, vz).xz);
            // Now compute displacement noise for neighbours in x and z
            vx.y += (noiseX * _WaveOptions[1]) + _WaveOptions[2] * _Wind;
            vz.y += (noiseZ * _WaveOptions[1]) + _WaveOptions[2] * _Wind;
            // Recalculate normal from positions of displaced neighbours
            float3 vn = normalize(cross(vz.xyz - v0.xyz, vx.xyz - v0.xyz));
            v.normal.xyz = vn;
            v.normal.xyz = float3(0,1,0);
        #elif EFFECT_DISPLACE_NORMAL_WORLD
            // float camDist = distance(_WorldSpaceCameraPos, wp.xyz);
            // float4 wpx = mul(unity_ObjectToWorld, vx);
            // float4 wpz = mul(unity_ObjectToWorld, vx);
            wp = mul(unity_ObjectToWorld, v.vertex);
            float4 wpx = wp + float4(_RenormStepDelta, 0.0, 0.0, 0.0);
            float4 wpz = wp + float4(0.0, 0.0, _RenormStepDelta, 0.0);
            float noiseX = VertexNoise(wpx.xz);
            float noiseZ = VertexNoise(wpz.xz);
            // Now compute displacement noise for neighbours in x and z
            wpx.y += (noiseX * _WaveOptions[1]) + _WaveOptions[2] * _Wind;
            wpz.y += (noiseZ * _WaveOptions[1]) + _WaveOptions[2] * _Wind;
            // Recalculate normal from positions of displaced neighbours
            float3 vn = normalize(cross(wpz.xyz - wp.xyz, wpx.xyz - wp.xyz));
            v.normal = mul(unity_WorldToObject, vn);
        #endif
    #endif
    */
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
        #ifdef EFFECT_WIND
            o.Metallic = lerp(_Metallic[0], _Metallic[1], _Wind);
            o.Smoothness = lerp(_Smoothness[0], _Smoothness[1], _Wind);
        #else
            o.Metallic = lerp(_Metallic[0], _Metallic[1], 0.25);
            o.Smoothness = lerp(_Smoothness[0], _Smoothness[1], 0.25);
        #endif
    #endif

    // Transition smoothness to avoid distant shader to look odd
    // Seems reflection is only done for the close/detail terrain
    #ifdef EFFECT_SMOOTH_TRANSITION
        float smooth = pow(smoothstep(_SmoothTransition.y,  _SmoothTransition.x, IN.color.a), _SmoothTransition.z);
        o.Smoothness *= smooth;
        o.Metallic *= smooth;
    #endif

    o.Albedo = saturate(o.Albedo);

    o.Occlusion = 0.25 + 0.5 * o.Smoothness;

}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////