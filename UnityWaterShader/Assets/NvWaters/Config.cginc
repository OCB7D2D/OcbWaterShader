// Enable wind attenuations
// #define EFFECT_WIND

// Enable foam texture sampling
#define EFFECT_ALBEDO1
// #define EFFECT_ALBEDO2

// Enable normal texture sampling
// #define EFFECT_NORMALMAP1
// #define EFFECT_NORMALMAP2

// Enable distance resampling
// #define EFFECT_RESAMPLING

// Enable normal effects
// #define EFFECT_MICROWAVE
// #define EFFECT_PARALLAX

// We only have reflection up to a certain distance
// Ensures we blend over to safe params before that
// #define EFFECT_SMOOTH_TRANSITION

// Mirror effect done by surface shader
// #define EFFECT_REFLECTION
// #define EFFECT_MIRROR

// Foam effect seems broken
// #define EFFECT_FOAM

// Tessellate geometry
#define EFFECT_TESSELLATE
// Define tesselate mode
#define TESS_LENGTH_CULL
// Uncomment to disable displacement
// #define EFFECT_TESSELLATE_NOWAVES

// Define normal blending
#define BLEND_NORMAL_RNM

// Make water transparent at shore
#define EFFECT_DEPTH_ALPHA

// Fade according to wave height
// Ranges from -1 to 1 normally
// #define EFFECT_WAVE_FADE

// Fade according to wind speed
// Make it more clear when calm
// #define EFFECT_WIND_FADE

// Fade according to eye depth
// Note: Plants are also considered
// Make plants not write z-buffer?
// #define EFFECT_DEPTH_FADE

