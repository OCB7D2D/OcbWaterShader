// Enable wind attenuations
#define EFFECT_WIND
#define EFFECT_TIME

// Enable foam texture sampling
#define EFFECT_ALBEDO1
#define EFFECT_ALBEDO2

// Enable normal texture sampling
#define EFFECT_NORMALMAP1
#define EFFECT_NORMALMAP2

// Enable distance resampling
#ifdef QUALITY_HIGH
    #define EFFECT_RESAMPLING
#endif

// Enable normal effects
#ifdef QUALITY_HIGH
    #define EFFECT_MICROWAVE
    #define EFFECT_PARALLAX
#endif

// We only have reflection up to a certain distance
// Ensures we blend over to safe params before that
#define EFFECT_SMOOTH_TRANSITION

// Mirror effect done by surface shader
// #define EFFECT_REFLECTION
// #define EFFECT_MIRROR

// Foam effect seems broken
// #define EFFECT_FOAM

#define EFFECT_WAVE_NOISE
#ifdef QUALITY_HIGH
    #define EFFECT_DISPLACE_NORMAL;
    #define EFFECT_DISPLACE_VERTEX;
#endif

#ifdef QUALITY_HIGH
    // Enable geometry tessellation
    #define EFFECT_TESSELLATE
    // Define tesselate mode
    #define TESS_LENGTH_CULL
#endif

// Define normal blending
// #define BLEND_NORMAL_RNM
// #define BLEND_NORMAL_PDN
// #define BLEND_NORMAL_WHITEOUT
#define BLEND_NORMAL_UDM

// Make water transparent at shore
#define EFFECT_DEPTH_ALPHA

// Fade according to wave height
// Ranges from -1 to 1 normally
#define EFFECT_WAVE_FADE

// Fade according to wind speed
// Make it more clear when calm
#define EFFECT_WIND_FADE

// Fade according to eye depth
// Note: Plants are also considered
// Make plants not write z-buffer?
// #define EFFECT_DEPTH_FADE

// #define DEBUG_WORLD_NORMALS