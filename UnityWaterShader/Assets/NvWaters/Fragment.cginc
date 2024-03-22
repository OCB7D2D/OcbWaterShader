//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Break out early if under water
clip(0 - _UnderWater);

// Get camera distance before shifting the origin
float camDist = distance(_WorldSpaceCameraPos, IN.worldPos.xyz);

// Apply world origin shift
IN.worldPos.xyz += _OriginPos.xyz;

// Always get uv coordinates according to world position
float2 UV = (IN.worldPos.xz + _WorldDim.xy * 0.5) / _WorldDim.xy;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef DEBUG_CLIPCHUNKS
    #ifdef DISTANT_SHADER
        o.Albedo = tex2D(_ClipChunks, UV);
        o.Alpha = 1; // show the clip texture
        return;
    #else
        discard;
    #endif
#endif

#ifdef DISTANT_SHADER
    clip(0.5 - tex2D(_ClipChunks, UV).y);
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Get depth from surface to terrain by sampling depth/z buffer
float depth = WaterViewDepth(IN) + _Clarity.w;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef EFFECT_RESAMPLING
    #ifdef _DISTANCERESAMPLENOFADE
        float dblend1 = 0.618;
        float dblend2 = 0.618;
    #elif defined(DISTANT_RESAMPLE_NOISE)
        #if _TRIPLANAR
            float dblend1 = 1 + FBM3D(worldPos * _DistantResample1Noise.x) * _DistantResample1Noise.y;
            float dblend2 = 1 + FBM3D(worldPos * _DistantResample2Noise.x) * _DistantResample2Noise.y;
        #else
            float dblend1 = 1 + FBM2D(config.uv * _DistantResample1Noise.x) * _DistantResample1Noise.y;
            float dblend2 = 1 + FBM2D(config.uv * _DistantResample2Noise.x) * _DistantResample2Noise.y;
        #endif
    #else
        float dblend1 = saturate((camDist - _DistantResample1Params.y) / (_DistantResample1Params.z - _DistantResample1Params.y));
        float dblend2 = saturate((camDist - _DistantResample2Params.y) / (_DistantResample2Params.z - _DistantResample2Params.y));
    #endif
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Apply texture tiling scale and offset
#ifdef EFFECT_ALBEDO1
    float2 UVA1 = TRANSFORM_TEX(UV, _AlbedoTex1);
#endif
#ifdef EFFECT_NORMALMAP1
    float2 UVN1 = TRANSFORM_TEX(UV, _NormalMap1);
#endif
#ifdef EFFECT_ALBEDO2
    float2 UVA2 = TRANSFORM_TEX(UV, _AlbedoTex2);
#endif
#ifdef EFFECT_NORMALMAP2
    float2 UVN2 = TRANSFORM_TEX(UV, _NormalMap2);
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

float2 albedo_move = float2(_NvWatersMovement.x, _NvWatersMovement.y);
float2 normal_move = float2(_NvWatersMovement.z, _NvWatersMovement.w);

#ifdef EFFECT_ALBEDO1
    UVA1.xy += albedo_move * _Albedo1Flow;
#endif
#ifdef EFFECT_ALBEDO2
    UVA2.xy += albedo_move * _Albedo2Flow;
#endif
#ifdef EFFECT_NORMALMAP1
    UVN1.xy += normal_move * _NormalMap1Flow;
#endif
#ifdef EFFECT_NORMALMAP2
    UVN2.xy += normal_move * _NormalMap2Flow;
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef EFFECT_PARALLAX
    float2 parallax = OffsetParallax(IN);
    #ifdef EFFECT_ALBEDO1
        UVA1 += parallax * _ParallaxAlbedo1Factor;
    #endif
    #ifdef EFFECT_NORMALMAP1
        UVN1 += parallax * _ParallaxNormal1Factor;
    #endif
    #ifdef EFFECT_ALBEDO2
        UVA2 += parallax * _ParallaxAlbedo2Factor;
    #endif
    #ifdef EFFECT_NORMALMAP2
        UVN2 += parallax * _ParallaxNormal2Factor;
    #endif
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

float3 albedo = _SurfaceColor;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef EFFECT_ALBEDO2
    float4 albedo2 = tex2D(_AlbedoTex2, UVA2) * _Albedo2Color;
    #ifdef EFFECT_RESAMPLING
        float2 uv2 = UVA2 * _DistantResample2Params.x;
        float4 distant2 = tex2D(_AlbedoTex2, uv2);
        albedo2 = lerp(albedo2, distant2 * _Albedo2Color, dblend2);
    #endif
    albedo = lerp(albedo, albedo2, _SurfaceIntensity);
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef EFFECT_ALBEDO1
    float4 albedo1 = tex2D(_AlbedoTex1, UVA1) * _Albedo1Color;
    #ifdef EFFECT_RESAMPLING
        float2 uv1 = UVA1 * _DistantResample1Params.x;
        float4 distant1 = tex2D(_AlbedoTex1, uv1);
        albedo1 = lerp(albedo1, distant1 * _Albedo1Color, dblend1);
    #endif
    albedo = lerp(albedo, albedo1, _SurfaceIntensity);
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef EFFECT_DEPTH_FADE
    albedo = lerp(albedo, _SurfaceColor, smoothstep(
        _DepthFade[1], _DepthFade[2], depth));
#endif
#ifdef EFFECT_WAVE_FADE
    albedo = lerp(albedo, _SurfaceColor, smoothstep(
        _WaveFade[0], _WaveFade[1], IN.color.r));
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Init default screen normal
float3 normal = float3(0,0,1);

#ifdef EFFECT_NORMALMAP1
    float3 normal1 = UnpackNormalScaled(tex2D(_NormalMap1, UVN1), _NormalMap1Strength);
    #ifdef EFFECT_RESAMPLING
        float4 normd1 = tex2D(_NormalMap1, UVN1 * _DistantResample1Params.x);
        normd1.xyz = UnpackNormalScaled(normd1, _NormalMap1Strength);
        normd1.xyz = lerp(normal1, normd1.xyz, dblend1);
        BlendNormal(normal1, normd1.xyz);
    #endif
    #ifdef EFFECT_MICROWAVE
        float4 mw1 = tex2D(_NormalMap1, UVN1 * _MicrowaveScale);
        mw1.xyz = UnpackNormalScaled(mw1, _MicrowaveStrength);
        mw1.xyz = lerp(normal1, mw1.xyz, dblend1);
        BlendNormal(normal1, mw1.xyz);
    #endif
    normal1 = lerp(normal, normal1, _SurfaceContrast);
    BlendNormal(normal, normal1);
#endif

#ifdef EFFECT_NORMALMAP2
    float3 normal2 = UnpackNormalScaled(tex2D(_NormalMap2, UVN2), _NormalMap2Strength);
    #ifdef EFFECT_RESAMPLING
        float4 normd2 = tex2D(_NormalMap2, UVN2 * _DistantResample2Params.x);
        normd2.xyz = UnpackNormalScaled(normd2, _NormalMap2Strength);
        normd2.xyz = lerp(normal2, normd2.xyz, dblend2);
        BlendNormal(normal2, normd2.xyz);
    #endif
    #ifdef EFFECT_MICROWAVE
        float4 mw2 = tex2D(_NormalMap2, (UVN1 + UVN2) * _MicrowaveScale);
        mw2.xyz = UnpackNormalScaled(mw2, _MicrowaveStrength);
        mw2.xyz = lerp(normal2, mw2.xyz, dblend2);
        BlendNormal(normal2, mw2.xyz);
    #endif
    normal2 = lerp(normal, normal2, _SurfaceContrast);
    BlendNormal(normal, normal2);
#endif

#ifdef EFFECT_DEPTH_FADE
    normal = lerp(normal, float3(0,0,1), smoothstep(
        _DepthFade[2], _DepthFade[3], depth));
#endif
#ifdef EFFECT_WAVE_FADE
    normal = lerp(normal, float3(0,0,1), smoothstep(
        _WaveFade[2], _WaveFade[3], IN.color.r));
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef EFFECT_REFLECTION
    o.Emission = SpecularReflection(IN, tex, normal);
#endif

#ifdef EFFECT_MIRROR
    o.Emission = (o.Emission + MirrorReflection(IN, normal)) * 0.6;
#endif

#ifdef EFFECT_FOAM
    albedo = FoamFactor(IN, depth, albedo, UVN1);
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

o.Albedo = saturate(albedo);
o.Normal = normalize(normal);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

float fadeAlbedo = 0;
float fadeNormal = 0;

#if defined(EFFECT_WIND) && defined(EFFECT_WIND_FADE)
    // Make surface mono-color when weather is calm
    fadeAlbedo = smoothstep(_WindFade[0], _WindFade[1], _Wind);
    // Make normal less distorted when weather is calm
    fadeNormal = smoothstep(_WindFade[2], _WindFade[3], _Wind);
#endif

o.Albedo = saturate(lerp(o.Albedo, _SurfaceColor, fadeAlbedo));
o.Normal = normalize(lerp(o.Normal, float3(0,0,1), fadeNormal));

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef EFFECT_DEPTH_ALPHA
    o.Alpha = WaterClarity(depth);
#else
    o.Alpha = 1;
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
