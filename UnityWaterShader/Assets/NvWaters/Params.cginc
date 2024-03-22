//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Required to sample depth texture
sampler2D_float _CameraDepthTexture;

//----------------------------------------------

// The dynamic movement vector
float4 _NvWatersMovement;

//----------------------------------------------

// Unfiforms by 7D2D
float2 _WorldDim;
float3 _OriginPos;
float _UnderWater;

// Basic configuration
float4 _Clarity;
float3 _ShoreColor;
float4 _SurfaceColor;
float _SurfaceIntensity;
float _SurfaceContrast;

//----------------------------------------------

#ifdef SPECULAR_WORKFLOW
    float _Shininess;
#else
    float2 _Metallic;
    float2 _Smoothness;
#endif

//----------------------------------------------

#ifdef EFFECT_ALBEDO1
    float4 _Albedo1Color;
    sampler2D _AlbedoTex1;
    float4 _AlbedoTex1_ST;
    float _Albedo1Flow;
#endif

#ifdef EFFECT_ALBEDO2
    float4 _Albedo2Color;
    sampler2D _AlbedoTex2;
    float4 _AlbedoTex2_ST;
    float _Albedo2Flow;
#endif

//----------------------------------------------

#ifdef EFFECT_NORMALMAP1
    sampler2D _NormalMap1;
    float4 _NormalMap1_ST;
    float _NormalMap1Strength;
    float _NormalMap1Flow;
#endif

#ifdef EFFECT_NORMALMAP2
    sampler2D _NormalMap2;
    float4 _NormalMap2_ST;
    float _NormalMap2Strength;
    float _NormalMap2Flow;
#endif

//----------------------------------------------

#ifdef EFFECT_DEPTH_FADE
    float4 _DepthFade;
#endif

#ifdef EFFECT_WAVE_FADE
    float4 _WaveFade;
#endif

//----------------------------------------------

#ifdef EFFECT_MICROWAVE
    float _MicrowaveStrength;
    float _MicrowaveScale;
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
    float4 _ReflectionColor;
    float _ReflectionStrength;
    float _ReflectionSaturation;
    float _ReflectionContrast;
#endif

//----------------------------------------------

#ifdef EFFECT_MIRROR
    sampler2D _GrabTexture : register(s0);
    sampler2D _MirrorReflectionTex : register(s3);
    float4 _MirrorColor;
    float4 _MirrorDepthColor;
    //float _WeirdScale;
    float _MirrorFPOW;
    float _MirrorR0;
    float _MirrorSaturation;
    float _MirrorStrength;
    float _MirrorContrast;
    float _MirrorWavePow;
    float _MirrorWaveScale;
    float _MirrorWaveFlow;
    float4 _GrabTexture_TexelSize;
#endif

//----------------------------------------------

#ifdef EFFECT_FOAM
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
    sampler2D _ClipChunks;
#endif

//----------------------------------------------

#ifdef EFFECT_TESSELLATE
    float4 _TessOptions;
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
    float _WindTime;
    float _Wind;
#endif

//----------------------------------------------

#ifdef EFFECT_SMOOTH_TRANSITION
    float3 _SmoothTransition;
#endif

//----------------------------------------------

#ifdef EFFECT_RESAMPLING
   float4  _DistantResample1Params;
   float4  _DistantResample2Params;
   #ifdef DISTANT_RESAMPLE_NOFADE
   #elif defined(DISTANT_RESAMPLE_NOISE)
      float2 _DistantResample1Noise;
      float2 _DistantResample2Noise;
   #endif
#endif

//----------------------------------------------

#ifdef DISTANT_SHADER
    float _DistantSurfaceOffset;
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
