//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

float WaterViewDepth(Input IN) {
    float rawZ = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(IN.screenPos));
    return DECODE_EYEDEPTH(rawZ) - IN.color.a; // delta between ground (z-buffer) and surface
}

float WaterClarity(float depth) {
    depth = smoothstep(_Clarity.x, _Clarity.y, depth);
    depth = pow(depth, _Clarity.z);
    return depth;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

float Noise(float2 uv, float gain, float amplitude, float frequency, float scale, float lacunary, float octaves) {
    float result;
    float frequencyL = frequency;
    float amplitudeL = amplitude;
    uv = uv * scale;
    for (int i = 0; i < octaves; i++) {
        float2 i = floor(uv * frequencyL);
        float2 f = frac(uv * frequencyL);
        float2 t = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
        float2 a = i + float2(0.0, 0.0);
        float2 b = i + float2(1.0, 0.0);
        float2 c = i + float2(0.0, 1.0);
        float2 d = i + float2(1.0, 1.0);
        a = -1.0 + 2.0 * frac(sin(float2(dot(a, float2(127.1, 311.7)), dot(a, float2(269.5, 183.3)))) * 43758.5453123);
        b = -1.0 + 2.0 * frac(sin(float2(dot(b, float2(127.1, 311.7)), dot(b, float2(269.5, 183.3)))) * 43758.5453123);
        c = -1.0 + 2.0 * frac(sin(float2(dot(c, float2(127.1, 311.7)), dot(c, float2(269.5, 183.3)))) * 43758.5453123);
        d = -1.0 + 2.0 * frac(sin(float2(dot(d, float2(127.1, 311.7)), dot(d, float2(269.5, 183.3)))) * 43758.5453123);
        float A = dot(a, f - float2(0.0, 0.0));
        float B = dot(b, f - float2(1.0, 0.0));
        float C = dot(c, f - float2(0.0, 1.0));
        float D = dot(d, f - float2(1.0, 1.0));
        float noise = (lerp(lerp(A, B, t.x), lerp(C, D, t.x), t.y));
        result = amplitudeL * noise;
        frequencyL *= lacunary;
        amplitudeL *= gain;
    }
    return result * 0.5 + 0.5;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef EFFECT_PARALLAX
    float2 OffsetParallax(Input IN) {
        float2 uvnh = IN.worldPos.xz + float2(_NvWatersMovement.z, _NvWatersMovement.w) * _ParallaxFlow;
        // ToDo: replace by sampling a noise texture instead as it might be faster?
        float nh = Noise(uvnh, _ParallaxNoiseGain, _ParallaxNoiseAmplitude, _ParallaxNoiseFrequency, _ParallaxNoiseScale, _ParallaxNoiseLacunary, 3);
        return ParallaxOffset(nh, _ParallaxStrength, IN.viewDir);
    }
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef EFFECT_REFLECTION
    float3 SpecularReflection(Input IN, float4 albedo, float3 normal) {
        float4 reflcol = texCUBE(_Cube, WorldReflectionVector(IN, normal));
        reflcol *= albedo.a;
        reflcol *= _ReflectionStrength;
        float LumRef = dot(reflcol, float3(0.2126, 0.7152, 0.0722));
        float3 reflcolL = lerp(LumRef.xxx, reflcol, _ReflectionSaturation);
        reflcolL = ((reflcolL - 0.5) * _ReflectionContrast + 0.5);
        return reflcolL * _ReflectionColor.rgb;
    }
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef EFFECT_MIRROR
    float4 MirrorReflection(Input IN, float3 normal) {
        IN.screenPos.xy = normal * _GrabTexture_TexelSize.xy * IN.screenPos.z + IN.screenPos.xy;
        float nvwxz = _NvWatersMovement.z * _MirrorWaveFlow * 10;
        IN.screenPos.x += sin((nvwxz + IN.screenPos.y) * _MirrorWaveScale) * _MirrorWavePow * 0.1;
        half4 reflcol = tex2Dproj(_MirrorReflectionTex, IN.screenPos);
        reflcol *= _MirrorStrength;
        float LumRef = dot(reflcol, float3(0.2126, 0.7152, 0.0722));
        reflcol.rgb = lerp(LumRef.xxx, reflcol, _MirrorSaturation);
        reflcol.rgb = ((reflcol.rgb - 0.5) * _MirrorContrast + 0.5);
        reflcol *= _MirrorColor;
        float3 refrColor = tex2Dproj(_GrabTexture, IN.screenPos);
        refrColor = _MirrorDepthColor * refrColor;
        half fresnel = saturate(1.0 - dot(normal, normalize(IN.viewDir)));
        fresnel = pow(fresnel, _MirrorFPOW);
        fresnel = _MirrorR0 + (1.0 - _MirrorR0) * fresnel;
        return reflcol * fresnel + half4(refrColor.xyz, 1.0) * (1.0 - fresnel);
    }
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef EFFECT_FOAM
    float3 FoamFactor(Input IN, float depth, float3 albedo, float2 uv) {
        uv -= float2(_NvWatersMovement.z, _NvWatersMovement.w) * _FoamFlow;
        float2 foamuv = (IN.worldPos.xz + _WorldDim.xy * 0.5) / _WorldDim.xy;
        uv += Noise(foamuv, _FoamGain, _FoamAmplitude, _FoamFrequency, _FoamScale, _FoamLacunary, 3);
        depth = smoothstep(_FoamSoft.x, _FoamSoft.y, depth);
        float3 foam = pow(tex2D(_AlbedoTex1, uv * _FoamSoft.z) * _FoamColor, _FoamSoft.w);
        foam = saturate(foam + _ShoreColor * (1 - depth));
        return lerp(foam, albedo, saturate(depth));
    }
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// https://forum.unity.com/threads/how-to-control-normal-map-strength-by-a-variable.366174/#post-2373555
// Optimized version that will only lerp the xy parts of the normal vector
// Copied unity `UnpackNormal` macro to optimize the math further
// This ensures a uniform vector result and does it only once
// Note: lerp is not called anymore as we lerp toward (0,0,1)
inline fixed3 UnpackNormalScaled(fixed4 packed, fixed strength)
{
    fixed3 normal;
    #if defined(UNITY_NO_DXT5nm)
        normal.xy = packed.xy;
    #elif defined(UNITY_ASTC_NORMALMAP_ENCODING)
        normal.xy = packed.wy;
    #else
        packed.x *= packed.w;
        normal.xy = packed.xy;
    #endif
    normal.xy = (normal.xy * 2 - 1) * strength;
    normal.z = sqrt(1 - saturate(dot(normal.xy, normal.xy)));
    return normal;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void BlendNormal(inout fixed3 n1, fixed3 n2) {
    // https://blog.selfshadow.com/publications/blending-in-detail/

    #if defined(BLEND_NORMAL_RNM)
        n1.z += 1; n2.xy *= -1;
        n1 = normalize(n1 * dot(n1, n2) - n2 * n1.z);
    #elif defined(BLEND_NORMAL_PDN)
        n1 = normalize(fixed3(n1.xy / n1.z + n2.xy / n2.z, 1));
    #elif defined(BLEND_NORMAL_WHITEOUT)
        n1 = normalize(fixed3(n1.xy + n2.xy, n1.z * n2.z));
    #else // defined(BLEND_NORMAL_UDM)
        n1 = normalize(fixed3(n1.xy + n2.xy, n1.z));
    #endif
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
