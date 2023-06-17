# OCB Water Shader Mod  - 7 Days to Die (A21) Addon

Replacing vanilla water shader with an improved version [based on][4]:  
https://github.com/nvjob/nvjob-water-shader-simple-and-fast

You need to disable EAC to use this mod!

## Download

End-Users are encouraged to download my mods from [NexusMods][3].  
Every download there helps me to buy stuff for mod development.

Otherwise please use one of the [official releases][2] here.  
Only clone or download the repo if you know what you do!

## Configuration

Users can adjust the shader setting in [`Config/worldglobal.xml`][5]:
```xml
<water>

  <!-- load resources from asset bundle -->
  <property name="shader" value="#@modfolder:Resources/OcbWaterShader.unity3d?ocbwatershader.shader"/>
  <property name="distant" value="#@modfolder:Resources/OcbWaterShader.unity3d?ocbwaterdistant.shader"/>
  <property name="albedo1" value="#@modfolder:Resources/OcbWaterShader.unity3d?textures/wateralbedo1.png"/>
  <property name="albedo2" value="#@modfolder:Resources/OcbWaterShader.unity3d?textures/wateralbedo2.png"/>
  <property name="normal1" value="#@modfolder:Resources/OcbWaterShader.unity3d?textures/waternormal1.png"/>
  <property name="normal2" value="#@modfolder:Resources/OcbWaterShader.unity3d?textures/waternormal2.png"/>

  <!-- configure main PBR shader properties -->
  <property name="metallic" value="0.175"/>
  <property name="glossiness" value="0.725"/>

  <!-- water clarity params (start/end/power/offset) -->
  <property name="clarity" value="0.125,12.5,0.425,0"/>

  <!-- scales for the different textures -->
  <property name="albedo1-scale" value="115,115"/>
  <property name="normal1-scale" value="115,115"/>
  <property name="albedo2-scale" value="232,236"/>
  <property name="normal2-scale" value="232,236"/>

  <!-- offsets for the different textures -->
  <property name="albedo1-offset" value="0,0"/>
  <property name="albedo2-offset" value="0,0"/>
  <property name="normal1-offset" value="0,0"/>
  <property name="normal2-offset" value="0,0"/>

  <!-- movement flow for the different textures -->
  <property name="albedo1-flow" value="1"/>
  <property name="albedo2-flow" value="0.9"/>
  <property name="normal1-flow" value="1"/>
  <property name="normal2-flow" value="0.9"/>

  <!-- normal strengths for various features -->
  <property name="normal1-strength" value="0.175"/>
  <property name="normal2-strength" value="0.325"/>
  <property name="microwave-strength" value="0.225"/>

  <!-- tint color for the albedo textures -->
  <property name="albedo1-color" value="0.59,0.625,0.735,1"/>
  <property name="albedo2-color" value="0.59,0.625,0.735,1"/>

  <!-- color for shallow water -->
  <property name="shore-color" value="0.37,0.38,0.39,1"/>
  <!-- color for water surface -->
  <property name="surface-color" value="0.5,0.52,0.535,1"/>

  <!-- factors to influence final albedo color -->
  <property name="surface-intensity" value="0.65"/>
  <property name="surface-contrast" value="0.85"/>

  <!-- settings for parallax module -->
  <property name="parallax-strength" value="0.003"/>
  <property name="parallax-flow" value="72"/>
  <property name="parallax-albedo1-factor" value="1"/>
  <property name="parallax-albedo2-factor" value="1"/>
  <property name="parallax-normal1-factor" value="1"/>
  <property name="parallax-normal2-factor" value="1"/>
  <property name="parallax-noise-gain" value="0.526"/>
  <property name="parallax-noise-amplitude" value="3"/>
  <property name="parallax-noise-frequency" value="1"/>
  <property name="parallax-noise-scale" value="1"/>
  <property name="parallax-noise-lacunary" value="4"/>

  <!-- settings for mirror module -->
  <property name="mirror-strength" value="2.4"/>
  <property name="mirror-color" value="0.19,0.15,0.17,0.5"/>
  <property name="mirror-depth-color" value="0.0,0.0,0.0,0.5"/>
  <property name="mirror-saturation" value="0.8"/>
  <property name="mirror-contrast" value="1.5"/>
  <property name="mirror-fpow" value="5"/>
  <property name="mirror-r0" value="0.01"/>
  <property name="mirror-wave-pow" value="0.5"/>
  <property name="mirror-wave-scale" value="2"/>
  <property name="mirror-wave-flow" value="2"/>

  <!-- settings for foam module -->
  <property name="foam-soft" value="0,5,2.5,1.35"/>
  <property name="foam-color" value="0.53,0.55,0.58,0"/>
  <property name="foam-flow" value=".75"/>
  <property name="foam-gain" value="0.6"/>
  <property name="foam-amplitude" value="1.5"/>
  <property name="foam-frequency" value="1"/>
  <property name="foam-scale" value="1"/>
  <property name="foam-lacunary" value="3.14"/>

</water>
```

## Adjusting on runtime

In order to find the best parameters, I added some raw helper console commands.
These allow to query and update the shader parameters on the fly.


### Listing all shader properties

```cs
ws props
```

> // Base PBR lighting config  
> Range _Metallic => 0.175  
> Range _Glossiness => 0.575  
> // Water clarity params (start/end/power/offset)  
> Vector _Clarity => (0.1, 12.5, 0.4, 0.0)  
> // Flow speeds of texture UVs  
> Float _Albedo1Flow => 1  
> Float _Albedo2Flow => 0.9  
> Float _NormalMap1Flow => 1  
> Float _NormalMap2Flow => 0.9  
> // Normal strengths for various features  
> Range _NormalMap1Strength => 0.175  
> Range _NormalMap2Strength => 0.325  
> Range _MicrowaveStrength => 0.225  
> Range _MicrowaveScale => 0.75  
> // Tint color for the albedo textures  
> Color _Albedo1Color => RGBA(0.590, 0.625, 0.735, 1.000)  
> Color _Albedo2Color => RGBA(0.590, 0.625, 0.735, 1.000)  
> // Color for shallow water  
> Color _ShoreColor => RGBA(0.370, 0.380, 0.390, 1.000)  
> // Color for water surface  
> Color _SurfaceColor => RGBA(0.500, 0.520, 0.535, 1.000)  
> // Factors for final albedo color  
> Range _SurfaceIntensity => 0.65  
> Range _SurfaceContrast => 0.85  
> // Settings for parallax module  
> Float _ParallaxStrength => 0.003  
> Float _ParallaxFlow => 72  
> Float _ParallaxAlbedo1Factor => 1  
> Float _ParallaxAlbedo2Factor => 1  
> Float _ParallaxNormal1Factor => 1  
> Float _ParallaxNormal2Factor => 1  
> Range _ParallaxNoiseGain => 0.526  
> Range _ParallaxNoiseAmplitude => 3  
> Range _ParallaxNoiseFrequency => 1  
> Float _ParallaxNoiseScale => 1  
> Range _ParallaxNoiseLacunary => 4  
> // Settings for foam module  
> Vector _FoamSoft => (0.0, 5.0, 2.5, 1.4)  
> Color _FoamColor => RGBA(0.530, 0.550, 0.580, 0.000)  
> Float _FoamFlow => 0.75  
> Float _FoamGain => 0.6  
> Float _FoamAmplitude => 1.5  
> Float _FoamFrequency => 1  
> Float _FoamScale => 1  
> Float _FoamLacunary => 3.14  
> // Settings for mirror module (not enabled yet)  
> Color _MirrorColor => RGBA(0.190, 0.150, 0.170, 0.500)  
> Color _MirrorDepthColor => RGBA(0.000, 0.000, 0.000, 0.500)  
> Float _MirrorFPOW => 5  
> Float _MirrorR0 => 0.01  
> Range _MirrorSaturation => 0.8  
> Range _MirrorStrength => 2.4  
> Range _MirrorContrast => 1.5  
> Float _MirrorWavePow => 0.5  
> Float _MirrorWaveScale => 2  
> Float _MirrorWaveFlow => 2

### Query or update a shader property

```cs
ws get [type] [name]
ws set [type] [name] [value]
ws set f _NormalMap1Strength 0.6
ws set c _SurfaceColor 0.6,0.9,0.7,1
ws set v _FoamSoft 0,8,6,1
```

### Adjusting texture uv scales and offsets

The textures are not exchangeable on runtime:

> Texture _AlbedoTex1 => WaterAlbedo1 (UnityEngine.Texture2D)  
> Texture _AlbedoTex2 => WaterAlbedo2 (UnityEngine.Texture2D)  
> Texture _NormalMap1 => WaterNormal1 (UnityEngine.Texture2D)  
> Texture _NormalMap2 => WaterNormal2 (UnityEngine.Texture2D)  
> Texture _MirrorReflectionTex => Not yet enabled!

But you can adjust scale and offset for them:

```cs
ws set s _AlbedoTex1 80,80 // set uv scale
ws set o _NormalMap1 7,13 // set uv offset
```

## Changelog

### Version 0.2.0

- Update compatibility for 7D2D A21.0(b313)
- Add initial weather/wind integration
- Adjusted shader settings slightly

### Version 0.1.1

- Add smooth transitions for reflections

### Version 0.1.0

- Initial version

## Compatibility

Developed initially for version a20.7(b1), updated through A21.0(b313).

[1]: https://github.com/OCB7D2D/OcbWaterShader
[2]: https://github.com/OCB7D2D/OcbWaterShader/releases
[3]: https://www.nexusmods.com/7daystodie/mods/2880
[4]: https://assetstore.unity.com/packages/vfx/shaders/water-shaders-v2-x-149916
[5]: https://github.com/OCB7D2D/OcbWaterShader/blob/master/Config/worldglobal.xml