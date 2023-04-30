//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Break out early if under water
clip(0 - _UnderWater);

// Apply world origin shift
IN.worldPos.xyz += _OriginPos.xyz;

// Always get uv coordinates according to world position
float2 UV = (IN.worldPos.xz + _WorldDim.xy * 0.5) / _WorldDim.xy;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef DEBUG_CLIPCHUNKS
    #ifdef DISTANT_SHADER
        o.Albedo.rgb = tex2D(_ClipChunks, UV);
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

UVA1.xy += albedo_move * _Albedo1Flow;
#ifdef EFFECT_ALBEDO2
    UVA2.xy += albedo_move * _Albedo2Flow;
#endif
UVN1.xy += normal_move * _NormalMap1Flow;
#ifdef EFFECT_NORMALMAP2
    UVN2.xy += normal_move * _NormalMap2Flow;
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef EFFECT_PARALLAX
    float2 parallax = OffsetParallax(IN);
    UVA1 += parallax * _ParallaxAlbedo1Factor;
    UVN1 += parallax * _ParallaxNormal1Factor;
    #ifdef EFFECT_ALBEDO2
        UVA2 += parallax * _ParallaxAlbedo2Factor;
    #endif
    #ifdef EFFECT_NORMALMAP2
        UVN2 += parallax * _ParallaxNormal2Factor;
    #endif
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

float4 tex = tex2D(_AlbedoTex1, UVA1) * _Albedo1Color;
#ifdef EFFECT_ALBEDO2
    // ToDo: should we really multiply the colors!?
    tex *= tex2D(_AlbedoTex2, UVA2) * _Albedo2Color;
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

tex *= _SurfaceIntensity;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

float3 albedo = lerp(_SurfaceColor, tex, _SurfaceContrast).rgb;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

float3 normal = UnpackNormalScaled(tex2D(_NormalMap1, UVN1), _NormalMap1Strength);
#ifdef EFFECT_NORMALMAP2
    BlendNormal(normal, UnpackNormalScaled(tex2D(_NormalMap2, UVN2), _NormalMap2Strength));
    #ifdef EFFECT_MICROWAVE
        BlendNormal(normal, UnpackNormalScaled(tex2D(_NormalMap2, (UVN1 + UVN2) * 2 * _MicrowaveScale), _MicrowaveStrength));
    #endif
#elif defined(EFFECT_MICROWAVE)
    BlendNormal(normal, UnpackNormalScaled(tex2D(_NormalMap2, (UVN1) * _MicrowaveScale), _MicrowaveStrength));
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

o.Normal = normalize(normal);
o.Albedo.rgb = saturate(albedo);
o.Alpha = WaterClarity(depth, IN);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
