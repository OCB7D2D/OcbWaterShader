//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Required to sample depth texture
sampler2D_float _CameraDepthTexture;

//----------------------------------------------

// The dynamic movement vector
float4 _NvWatersMovement;//na

//----------------------------------------------

// Unfiforms by 7D2D
float2 _WorldDim;//na
float3 _OriginPos;//na
float _UnderWater;//na

// Base surface color
float4 _SurfaceColor;//ok

// Basic configuration
#ifdef EFFECT_DEPTH_ALPHA
    float4 _WaterClarity;//ok
#endif

// float _SurfaceIntensity;
// float _SurfaceContrast;

//----------------------------------------------

#ifdef SPECULAR_WORKFLOW
    float _Shininess;
#else
    float2 _Metallic;//ok
    float2 _Smoothness;//ok
#endif

//----------------------------------------------

#ifdef EFFECT_ALBEDO1
    float _Albedo1Strength;//ok
    float4 _Albedo1Color;//ok
    sampler2D _AlbedoTex1;//ok
    float4 _AlbedoTex1_ST;//ok
    float _Albedo1Flow;//ok
#endif

#ifdef EFFECT_ALBEDO2
    float _Albedo2Strength;//ok
    float4 _Albedo2Color;//ok
    sampler2D _AlbedoTex2;//ok
    float4 _AlbedoTex2_ST;//ok
    float _Albedo2Flow;//ok
#endif

//----------------------------------------------

sampler2D _WavesNormal;
sampler2D _WavesNoise;
float4 _WavesNoise_ST;
float _WavesStrength;
float _WavesFlow;

#ifdef EFFECT_NORMALMAP1
    sampler2D _NormalMap1;//ok
    float4 _NormalMap1_ST;//ok
    float _NormalMap1Strength;//ok
    float _NormalMap1Flow;//ok
#endif

#ifdef EFFECT_NORMALMAP2
    sampler2D _NormalMap2;//ok
    float4 _NormalMap2_ST;//ok
    float _NormalMap2Strength;//ok
    float _NormalMap2Flow;//ok
#endif

//----------------------------------------------

#ifdef EFFECT_DEPTH_FADE
    float4 _DepthFade;//na
#endif

#ifdef EFFECT_WAVE_FADE
    float4 _WaveFade;//ok
#endif

//----------------------------------------------

#ifdef EFFECT_MICROWAVE
    float _MicrowaveStrength;//ok
    float _MicrowaveScale;//ok
#endif

//----------------------------------------------

#ifdef EFFECT_PARALLAX
    float _ParallaxStrength;
    float _ParallaxFlow;
    float _ParallaxAlbedo1Factor;
    float _ParallaxAlbedo2Factor;
    float _ParallaxNormal1Factor;
    float _ParallaxNormal2Factor;
    // Noise function params
    float _ParallaxNoiseGain;
    float _ParallaxNoiseAmplitude;
    float _ParallaxNoiseFrequency;
    float _ParallaxNoiseScale;
    float _ParallaxNoiseLacunary;
#endif

//----------------------------------------------

// Only for specular setup?
#ifdef EFFECT_REFLECTION
    samplerCUBE _Cube;
    float4 _ReflectionColor;//na
    float _ReflectionStrength;//na
    float _ReflectionSaturation;//na
    float _ReflectionContrast;//na
#endif

//----------------------------------------------

#ifdef EFFECT_MIRROR
    sampler2D _GrabTexture : register(s0);
    sampler2D _MirrorReflectionTex : register(s3);
    float4 _MirrorColor;//na
    float4 _MirrorDepthColor;//na
    //float _WeirdScale;//na
    float _MirrorFPOW;//na
    float _MirrorR0;//na
    float _MirrorSaturation;//na
    float _MirrorStrength;//na
    float _MirrorContrast;//na
    float _MirrorWavePow;//na
    float _MirrorWaveScale;//na
    float _MirrorWaveFlow;//na
    float4 _GrabTexture_TexelSize;//na
#endif

//----------------------------------------------

#ifdef EFFECT_FOAM
    float3 _ShoreColor;
    float4 _FoamSoft;
    float4 _FoamColor;
    float _FoamFlow;
    // For procedural noise
    float _FoamGain;
    float _FoamAmplitude;
    float _FoamFrequency;
    float _FoamScale;
    float _FoamLacunary;
#endif

//----------------------------------------------

#ifdef DISTANT_SHADER
    sampler2D _ClipChunks;//na
#endif

//----------------------------------------------

float4 _WaveOptions;
#if defined(EFFECT_DISPLACE_NORMAL)
    float _RenormStepDelta;
#elif defined(EFFECT_DISPLACE_VERTEX)
//    float4 _WaveOptions;
#endif

//----------------------------------------------

#ifdef EFFECT_TESSELLATE
    #if defined(TESS_LENGTH_ALL)
        float _TessEdgeLength;
    #elif defined(TESS_LENGTH_CULL)
        float _TessEdgeLength;
        float _TessMaxDisp;
    #else 
        float _TessMinDist;
        float _TessMaxDist;
        float _TessSubdivide;
    #endif
#endif

//----------------------------------------------

#ifdef EFFECT_WIND
    // Custom settings
    #ifdef EFFECT_WIND_FADE
        float4 _WindFade;
    #endif
    // Provided by vanilla
    // float _WindTime;
    float _Wind;
#endif

float _WindTime;

//----------------------------------------------

#ifdef EFFECT_SMOOTH_TRANSITION
    float3 _SmoothTransition;//ok
#endif

//----------------------------------------------

#ifdef EFFECT_RESAMPLING
   float3 _DistantResample1Params;//ok
   float3 _DistantResample2Params;//ok
   #ifdef DISTANT_RESAMPLE_NOFADE
   #elif defined(DISTANT_RESAMPLE_NOISE)
      float2 _DistantResample1Noise;//na
      float2 _DistantResample2Noise;//na
   #endif
#endif

//----------------------------------------------

#ifdef DISTANT_SHADER
    float _DistantSurfaceOffset;//ok
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
