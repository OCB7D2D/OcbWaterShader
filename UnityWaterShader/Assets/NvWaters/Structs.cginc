//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct Input {
    // Default Surface Shader Inputs
    float3 viewDir;
    float3 worldPos;
    float4 screenPos;
    // Custom input semantics
    float4 color : COLOR;
    //float3 worldNormal;
    //INTERNAL_DATA
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
