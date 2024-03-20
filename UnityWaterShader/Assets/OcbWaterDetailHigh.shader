// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Copyright (c) 2016 Unity Technologies. MIT license - license_unity.txt
// #NVJOB Water Shaders. MIT license - license_nvjob.txt
// #NVJOB Water Shaders v2.0 - https://nvjob.github.io/unity/nvjob-water-shaders-v2
// #NVJOB Nicholas Veselov - https://nvjob.github.io
// Support this asset - https://nvjob.github.io/donate
// Modifed for 7D2D by https://github.com/OCB7D2D/

Shader "OcbWaterDetailHigh" {

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    Properties {

        [HDR] _ShoreColor("Shore Color", Color) = (0.5, 0.5, 0.5, 1)
        [HDR] _SurfaceColor("Surface Color", Color) = (0.5, 0.5, 0.5, 1)

        _Metallic("Metallic", Range(-1, 2)) = 0.0
        _Smoothness("Smoothness", Range(0, 1)) = 0.5
        // _Shininess("Shininess", Range(0.01, 1)) = 0.15

        _SurfaceIntensity("Brightness", Range(0.1, 5)) = 1
        _SurfaceContrast("Contrast", Range(-0.5, 3)) = 1

        //----------------------------------------------
        //----------------------------------------------
        [HDR] _Albedo1Color("Albedo 1 Color", Color) = (1,1,1,1)
        _AlbedoTex1("Albedo Texture 1", 2D) = "gray" {}
        _Albedo1Flow("Albedo 1 Flow", float) = 1

        //----------------------------------------------
        // #ifdef EFFECT_ALBEDO2
        //----------------------------------------------
        [HDR] _Albedo2Color("Albedo 2 Color", Color) = (1,1,1,1)
        _AlbedoTex2("Albedo Texture 2", 2D) = "gray" {}
        _Albedo2Flow("Albedo 2 Flow", float) = 1

        //----------------------------------------------
        //----------------------------------------------
        _NormalMap1("Normal Map 1", 2D) = "bump" {}
        _NormalMap1Strength("Normal Map 1 Strength", Range(-3, 3)) = 0
        _NormalMap1Flow("Normal Map 1 Flow", float) = 0.5

        //----------------------------------------------
        // #ifdef EFFECT_NORMALMAP2
        //----------------------------------------------
        _NormalMap2("Normal Map 2", 2D) = "bump" {}
        _NormalMap2Strength("Normal Map 2 Strength", Range(-3, 3)) = 0
        _NormalMap2Flow("Normal Map 2 Flow", float) = 0.5

        //----------------------------------------------
        // #ifdef EFFECT_MICROWAVE
        //----------------------------------------------
        _MicrowaveScale("Micro Waves Scale", Range(0.5, 10)) = 1
        _MicrowaveStrength("Micro Waves Strength", Range(-1.5, 1.5)) = 0

        //----------------------------------------------
        // #ifdef EFFECT_PARALLAX
        //----------------------------------------------
        _ParallaxStrength("Parallax Strength", float) = 0.02
        _ParallaxFlow("Parallax Flow", float) = 40
        _ParallaxAlbedo1Factor("Parallax Albedo 1 Factor", float) = 1
        _ParallaxAlbedo2Factor("Parallax Albedo 2 Factor", float) = 1
        _ParallaxNormal1Factor("Parallax Normal Map 1 Factor", float) = 1
        _ParallaxNormal2Factor("Parallax Normal Map 2 Factor", float) = 1
        _ParallaxNoiseGain("Parallax Noise Gain", Range(0.0 , 1.0)) = 0.3
        _ParallaxNoiseAmplitude("Parallax Noise Amplitude", Range(0.0 , 5.0)) = 3
        _ParallaxNoiseFrequency("Parallax Noise Frequency", Range(0.0 , 6.0)) = 1
        _ParallaxNoiseScale("Parallax Noise Scale", Float) = 1
        _ParallaxNoiseLacunary("Parallax Noise Lacunary", Range(1 , 6)) = 4

        //----------------------------------------------
        // #ifdef EFFECT_REFLECTION
        //----------------------------------------------
        // _ReflectionCube("Reflection Cubemap", Cube) = "" {}
        // [HDR]_ReflectionColor("Reflection Color", Color) = (0.28,0.29,0.25,0.5)
        // _ReflectionStrength("Reflection Strength", Range(0, 10)) = 0.15
        // _ReflectionSaturation("Reflection Saturation", Range(0, 5)) = 1
        // _ReflectionContrast("Reflection Contrast", Range(0, 5)) = 1

        //----------------------------------------------
        // #ifdef EFFECT_MIRROR
        //----------------------------------------------
        [HDR]_MirrorColor("Mirror Reflection Color", Color) = (1,1,1,0.5)
        _MirrorDepthColor("Mirror Reflection Depth Color", Color) = (0,0,0,0.5)
        _MirrorFPOW("Mirror FPOW", Float) = 5.0
        _MirrorR0("Mirror R0", Float) = 0.01
        _MirrorSaturation("Reflection Saturation", Range(0, 5)) = 1
        _MirrorStrength("Reflection Strength", Range(0, 5)) = 1
        _MirrorContrast("Reflection Contrast", Range(0, 5)) = 1
        _MirrorWavePow("Reflections Wave Strength", Float) = 1
        _MirrorWaveScale("Reflections Wave Scale", Float) = 1
        _MirrorWaveFlow("Reflections Wave Flow", Float) = 5
        _MirrorReflectionTex("_MirrorReflectionTex", 2D) = "gray" {}

        //----------------------------------------------
        // #ifdef EFFECT_FOAM
        //----------------------------------------------
        [HDR]_FoamColor("Foam Color", Color) = (1, 1, 1, 1)
        _FoamFlow("Foam Flow", Float) = 10
        _FoamGain("Foam Gain", Float) = 0.6
        _FoamAmplitude("Foam Amplitude", Float) = 15
        _FoamFrequency("Foam Frequency", Float) = 4
        _FoamScale("Foam Scale", Float) = 0.1
        _FoamLacunary("Foam Lacunary", Float) = 5
        _FoamSoft("Foam Soft", Vector) = (0.25, 0.6, 1, 0)

        //----------------------------------------------
        // Distant Resampling
        //----------------------------------------------
        _DistantResampleParams("Distant Resample Params", Vector) = (0.25, 20, 40)
        _DistantResampleNoise("Distant Resample Noise", Vector) = (0.5, 0.5, 0, 0)
        _SmoothTransition("Smooth Transition", Vector) = (25, 250, 0.75, 0)

        //----------------------------------------------
        // Tessellation options
        //----------------------------------------------
        _TessMinDist("Tessellation Max Distance", Range(0,250)) = 15 // for default mode
        _TessMaxDist("Tessellation Min Distance", Range(0,500)) = 80 // for default mode
        _TessSubdivide("Tessellation Subdivision", Range(1,32)) = 4 // for default mode
        _TessEdgeLength("Tessellation Edge Length", Range(1,256)) = 64 // for edge mode
        _TessMaxDisp("Tessellation Max Displacement", Range(1,256)) = 0.5 // edge cull mode

        //----------------------------------------------
        // 7D2D specific uniforms
        //----------------------------------------------
        _Clarity("Water Clarity", Vector) = (0, 5, 2, 0)
        _WorldDim("World Dimensions", Vector) = (4096, 4096, 0, 0)
        // Never activate this, as it will overwrite global uniform!
        // _OriginPos("World Origin Shift", Vector) = (0, 0, 0, 0)

        //----------------------------------------------
        // Options only for distant shader
        //----------------------------------------------
        // For distant shader to clip loaded chunks
        // _ClipChunks("ClipChunks", 2D) = "black" { }

        // _WindTime("Wind Time", Range(-9999,9999)) = 0
        // _Wind("Wind Speed", Range(1,32)) = 4
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    SubShader{
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

        // Transparent-1 -> weird artifacts with biome particles
        // "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True"
        Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" }
        //Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
        LOD 200
        // Cull Off
        // ZWrite Off

        CGPROGRAM

        #pragma surface surf Standard vertex:vert tessellate:tess tessphong:_Phong alpha:fade
        // #pragma surface surf Standard addshadow fullforwardshadows vertex:vert tessellate:tess alpha:fade nolightmap
        // #pragma surface surf Standard vertex:vert alpha:fade
        // exclude_path:prepass noshadowmask noshadow

        float _Phong;
        #pragma target 4.6

        //----------------------------------------------
        #define QUALITY_HIGH
        #define DETAIL_SHADER
        #include "NvWaters/Config.cginc"
        #include "NvWaters/Structs.cginc"
        #include "NvWaters/Params.cginc"
        #include "NvWaters/Noise.cginc"
        #include "NvWaters/Functions.cginc"
        #include "NvWaters/Surface.cginc"
        #include "NvWaters/Tessellate.cginc"
        //----------------------------------------------

        ENDCG

        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    }

    FallBack "Legacy Shaders/Reflective/Bumped Diffuse"

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
