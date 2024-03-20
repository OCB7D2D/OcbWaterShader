// Enable wind attenuations
#define EFFECT_WIND

// Enable foam texture sampling
#define EFFECT_ALBEDO1
#define EFFECT_ALBEDO2

// Enable normal texture sampling
#define EFFECT_NORMALMAP1
#define EFFECT_NORMALMAP2

// Enable distance resampling
#define EFFECT_RESAMPLING

// Enable normal effects
#define EFFECT_MICROWAVE
#define EFFECT_PARALLAX

// We only have reflection up to a certain distance
// Ensures we blend over to safe params before that
#define EFFECT_SMOOTH_TRANSITION

// Mirror effect done by surface shader
// #define EFFECT_REFLECTION
// #define EFFECT_MIRROR

// Foam effect seems broken
// #define EFFECT_FOAM

// Tessellate geometry
#define EFFECT_TESSELLATE
// Define tesselate mode
#define TESS_LENGTH_CULL

// Define normal blending
#define BLEND_NORMAL_RNM
