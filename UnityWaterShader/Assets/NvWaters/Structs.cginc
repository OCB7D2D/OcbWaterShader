//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct VertexData42 {
    half4 color: COLOR;
    half4 vertex : POSITION;
    half3 normal : NORMAL;
    half2 uv : TEXCOORD0;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct v2f42
{
    float4 color : COLOR;
    // Vertices have no input color
    float4 screenPos : SV_POSITION;
    float2 uv : TEXCOORD0;
    float3 normal : TEXCOORD1;
    float3 worldPos : TEXCOORD2;
    UNITY_FOG_COORDS(3)
};


struct Input {
    // Default Surface Shader Inputs
    float3 viewDir;
    float3 worldPos;
    float4 screenPos;
    // Custom input semantics
    float4 color : COLOR;
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
