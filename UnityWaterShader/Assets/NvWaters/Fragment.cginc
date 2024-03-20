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
        float distanceBlend = 1;
    #elif defined(DISTANT_RESAMPLE_NOISE)
        #if _TRIPLANAR
            float distanceBlend = 1 + FBM3D(worldPos * _DistantResampleNoise.x) * _DistantResampleNoise.y;
        #else
            float distanceBlend = 1 + FBM2D(config.uv * _DistantResampleNoise.x) * _DistantResampleNoise.y;
        #endif
    #else
        float distanceBlend = saturate((camDist - _DistantResampleParams.y) / (_DistantResampleParams.z - _DistantResampleParams.y));
    #endif
    float dblend0 = distanceBlend;
    float dblend1 = distanceBlend;
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Apply texture tiling scale and offset
float2 UVA1 = TRANSFORM_TEX(UV, _AlbedoTex1);
float2 UVN1 = TRANSFORM_TEX(UV, _NormalMap1);

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

#ifdef EFFECT_ALBEDO1
    float4 tex1 = tex2D(_AlbedoTex1, UVA1) * _Albedo1Color;
    #ifdef EFFECT_RESAMPLING
        float2 uv1 = UVA1 * _DistantResampleParams.x;
        float4 distant1 = tex2D(_AlbedoTex1, uv1);
        tex1 = lerp(tex1, distant1 * _Albedo1Color, dblend0);
    #endif
    albedo = lerp(albedo, tex1, saturate(IN.color.r * 0.35 + 0.12));
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef EFFECT_ALBEDO2
    float4 tex2 = tex2D(_AlbedoTex2, UVA2) * _Albedo2Color;
    #ifdef EFFECT_RESAMPLING
        float2 uv2 = UVA2 * _DistantResampleParams.x;
        float4 distant2 = tex2D(_AlbedoTex2, uv2);
        tex2 = lerp(tex2, distant2 * _Albedo2Color, dblend1);
    #endif
    albedo = lerp(albedo, tex2, saturate(IN.color.r * 0.5 + 0.09));
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

float3 normal = float3(0,0,1); //UnpackNormalScaled(float4(0,0,1,0), 1);

#ifdef EFFECT_NORMALMAP1
    float3 norm1 = UnpackNormalScaled(tex2D(_NormalMap1, UVN1), _NormalMap1Strength);
    #ifdef EFFECT_RESAMPLING
        float4 normd1 = tex2D(_NormalMap1, UVN1 * _DistantResampleParams.x);
        normd1.xyz = UnpackNormalScaled(normd1, _NormalMap1Strength);
        BlendNormal(norm1, normd1.xyz);
    #endif
    #ifdef EFFECT_MICROWAVE
        float4 mw1 = tex2D(_NormalMap1, UVN1 * _MicrowaveScale);
        mw1.xyz = UnpackNormalScaled(mw1, _MicrowaveStrength);
        BlendNormal(norm1, mw1.xyz);
    #endif
    BlendNormal(normal, norm1);
#endif

#ifdef EFFECT_NORMALMAP2
    float3 norm2 = UnpackNormalScaled(tex2D(_NormalMap2, UVN2), _NormalMap2Strength);
    #ifdef EFFECT_RESAMPLING
        float4 normd2 = tex2D(_NormalMap2, UVN2 * _DistantResampleParams.x);
        normd2.xyz = UnpackNormalScaled(normd2, _NormalMap2Strength);
        BlendNormal(norm2, normd2.xyz);
    #endif
    #ifdef EFFECT_MICROWAVE
        float4 mw2 = tex2D(_NormalMap2, (UVN1 + UVN2) * _MicrowaveScale);
        mw2.xyz = UnpackNormalScaled(mw2, _MicrowaveStrength);
        BlendNormal(norm2, mw2.xyz);
    #endif
    BlendNormal(normal, norm2);
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
o.Alpha = WaterClarity(depth);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef EFFECT_WIND
    // Make surface mono-color when weather is calm
    o.Albedo = lerp(_SurfaceColor, o.Albedo, (_Wind * 0.55 + 0.45) * _SurfaceIntensity);
    // Make normal less distorted when weather is calm
    o.Normal = normalize(lerp(float3(0,0,1), o.Normal, (_Wind * 0.75 + 0.25)) * _SurfaceIntensity);
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
