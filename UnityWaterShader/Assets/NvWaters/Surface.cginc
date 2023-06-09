// Copyright (c) 2016 Unity Technologies. MIT license - license_unity.txt
// #NVJOB Water Shaders. MIT license - license_nvjob.txt
// #NVJOB Water Shaders v2.0 - https://nvjob.github.io/unity/nvjob-water-shaders-v2
// #NVJOB Nicholas Veselov - https://nvjob.github.io
// Support this asset - https://nvjob.github.io/donate

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void vert(inout appdata_full v, out Input o) {
    #ifdef DISTANT_SHADER
        // move distant down
        v.vertex.y -= 0.075;
    #endif
    UNITY_INITIALIZE_OUTPUT(Input, o);
    /// UNITY_TRANSFER_FOG(o, o.position);
    COMPUTE_EYEDEPTH(o.eyeDepth);
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
        o.Smoothness = _Glossiness;
    #endif

    #ifdef SMOOTH_TRANSITION
        float smooth = pow(smoothstep(SMOOTH_TRANSITION, 25, IN.eyeDepth), 1.5);
        o.Smoothness *= smooth;
        o.Metallic *= smooth;
    #endif

}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////