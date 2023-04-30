using HarmonyLib;
using System.Xml;
using UnityEngine;
using static StringParsers;

public class WaterXmlConfig
{

    // Replacement shaders to load afterwards
    public static DataLoader.DataPathIdentifier ShaderNearPath;
    public static DataLoader.DataPathIdentifier ShaderDistPath;
    public static Shader ShaderNear;
    public static Shader ShaderDist;
    // Base PBR lighting config
    public static float Metallic = 0.175f;
    public static float Glossiness = 0.725f;
    // Water clarity params (start/end/power/offset)
    public static Vector4 Clarity = new Vector4(0.125f, 12.5f, 0.425f, 0);
    // Main textures to load afterwards
    public static DataLoader.DataPathIdentifier Albedo1Path;
    public static DataLoader.DataPathIdentifier Albedo2Path;
    public static DataLoader.DataPathIdentifier Normal1Path;
    public static DataLoader.DataPathIdentifier Normal2Path;
    public static Texture Albedo1;
    public static Texture Albedo2;
    public static Texture Normal1;
    public static Texture Normal2;
    // Texture uv scale and offets
    public static Vector2 Albedo1Scale;
    public static Vector2 Albedo2Scale;
    public static Vector2 Normal1Scale;
    public static Vector2 Normal2Scale;
    public static Vector2 Albedo1Offset;
    public static Vector2 Albedo2Offset;
    public static Vector2 Normal1Offset;
    public static Vector2 Normal2Offset;
    // Flow speeds of texture UVs
    public static float Albedo1Flow = 0;
    public static float Albedo2Flow = 0;
    public static float NormalMap1Flow = 0;
    public static float NormalMap2Flow = 0;
    // Normal strengths for various features
    public static float NormalMap1Strength = 0.175f;
    public static float NormalMap2Strength = 0.325f;
    public static float MicrowaveStrength = 0.225f;
    public static float MicrowaveScale = 0.75f;
    // Tint color for the albedo textures
    public static Color Albedo1Color = Color.black;
    public static Color Albedo2Color = Color.black;
    // Color for shallow water
    public static Color ShoreColor = Color.gray;
    // Color for water surface
    public static Color SurfaceColor = Color.gray;
    // Factors for final albedo color
    public static float SurfaceIntensity = 0.65f;
    public static float SurfaceContrast = 0.85f;
    // Settings for parallax feature
    public static float ParallaxStrength = 0.01f;
    public static float ParallaxFlow = 0;
    public static float ParallaxAlbedo1Factor = 1;
    public static float ParallaxAlbedo2Factor = 1;
    public static float ParallaxNormal1Factor = 1;
    public static float ParallaxNormal2Factor = 1;
    public static float ParallaxNoiseGain = 0.5f;
    public static float ParallaxNoiseAmplitude = 3;
    public static float ParallaxNoiseFrequency = 1;
    public static float ParallaxNoiseScale = 1;
    public static float ParallaxNoiseLacunary = 4;
    // Settings for foam module
    public static Vector4 FoamSoft = new Vector4(0f, 5f, 25, 2);
    public static Color FoamColor = new Color(0.65f, 0.65f, 0.65f, 1);
    public static float FoamFlow = 10; // 0.85
    public static float FoamGain = 0.6f; // 1
    public static float FoamAmplitude = 1.5f;
    public static float FoamFrequency = 1f; // 20
    public static float FoamScale = 1f; // 20
    public static float FoamLacunary = 3.14f;
    // Settings for mirror module (not yet enabled)
    public static Color MirrorColor = new Color(0.19f, 0.15f, 0.17f, 0.5f);
    public static Color MirrorDepthColor = new Color(0.0f, 0.0f, 0.0f, 0.5f);
    public static float MirrorStrength = 2.4f;
    public static float MirrorSaturation = 0.8f;
    public static float MirrorContrast = 1.5f;
    public static float MirrorFPOW = 5;
    public static float MirrorR0 = 0.01f;
    public static float MirrorWavePow = 0.5f;
    public static float MirrorWaveScale = 2;
    public static float MirrorWaveFlow = 2;

    public static void SetupWaterMaterial(Material water)
    {

        water.SetFloat("_Metallic", WaterXmlConfig.Metallic);
        water.SetFloat("_Glossiness", WaterXmlConfig.Glossiness);

        water.SetVector("_Clarity", WaterXmlConfig.Clarity);

        water.SetColor("_ShoreColor", WaterXmlConfig.ShoreColor);
        water.SetColor("_SurfaceColor", WaterXmlConfig.SurfaceColor);
        water.SetFloat("_SurfaceContrast", WaterXmlConfig.SurfaceContrast);
        water.SetFloat("_SurfaceIntensity", WaterXmlConfig.SurfaceIntensity);

        water.SetColor("_Albedo1Color", WaterXmlConfig.Albedo1Color);
        water.SetTexture("_AlbedoTex1", WaterXmlConfig.Albedo1);
        water.SetTextureScale("_AlbedoTex1", WaterXmlConfig.Albedo1Scale);
        water.SetTextureOffset("_AlbedoTex1", WaterXmlConfig.Albedo1Offset);
        water.SetFloat("_Albedo1Flow", WaterXmlConfig.Albedo1Flow);

        water.SetColor("_Albedo2Color", WaterXmlConfig.Albedo2Color);
        water.SetTexture("_AlbedoTex2", WaterXmlConfig.Albedo2);
        water.SetTextureScale("_AlbedoTex2", WaterXmlConfig.Albedo2Scale);
        water.SetTextureOffset("_AlbedoTex2", WaterXmlConfig.Albedo2Offset);
        water.SetFloat("_Albedo2Flow", WaterXmlConfig.Albedo2Flow);

        water.SetFloat("_NormalMap1Strength", WaterXmlConfig.NormalMap1Strength);
        water.SetTexture("_NormalMap1", WaterXmlConfig.Normal1);
        water.SetTextureScale("_NormalMap1", WaterXmlConfig.Normal1Scale);
        water.SetTextureOffset("_NormalMap1", WaterXmlConfig.Normal1Offset);
        water.SetFloat("_NormalMap1Flow", WaterXmlConfig.NormalMap1Flow);

        water.SetFloat("_NormalMap2Strength", WaterXmlConfig.NormalMap2Strength);
        water.SetTexture("_NormalMap2", WaterXmlConfig.Normal2);
        water.SetTextureScale("_NormalMap2", WaterXmlConfig.Normal2Scale);
        water.SetTextureOffset("_NormalMap2", WaterXmlConfig.Normal2Offset);
        water.SetFloat("_NormalMap2Flow", WaterXmlConfig.NormalMap2Flow);

        // Settings for microwave module
        water.SetFloat("_MicrowaveStrength", WaterXmlConfig.MicrowaveStrength);
        water.SetFloat("_MicrowaveScale", WaterXmlConfig.MicrowaveScale);

        // Settings for parallax module
        water.SetFloat("_ParallaxStrength", WaterXmlConfig.ParallaxStrength);
        water.SetFloat("_ParallaxFlow", WaterXmlConfig.ParallaxFlow);
        water.SetFloat("_ParallaxAlbedo1Factor", WaterXmlConfig.ParallaxAlbedo1Factor);
        water.SetFloat("_ParallaxAlbedo2Factor", WaterXmlConfig.ParallaxAlbedo2Factor);
        water.SetFloat("_ParallaxNormal1Factor", WaterXmlConfig.ParallaxNormal1Factor);
        water.SetFloat("_ParallaxNormal2Factor", WaterXmlConfig.ParallaxNormal2Factor);
        water.SetFloat("_ParallaxNoiseGain", WaterXmlConfig.ParallaxNoiseGain);
        water.SetFloat("_ParallaxNoiseAmplitude", WaterXmlConfig.ParallaxNoiseAmplitude);
        water.SetFloat("_ParallaxNoiseFrequency", WaterXmlConfig.ParallaxNoiseFrequency);
        water.SetFloat("_ParallaxNoiseScale", WaterXmlConfig.ParallaxNoiseScale);
        water.SetFloat("_ParallaxNoiseLacunary", WaterXmlConfig.ParallaxNoiseLacunary);

        // Settings for mirror module
        water.SetColor("_MirrorColor", WaterXmlConfig.MirrorColor);
        water.SetColor("_MirrorDepthColor", WaterXmlConfig.MirrorDepthColor);
        water.SetFloat("_MirrorStrength", WaterXmlConfig.MirrorStrength);
        water.SetFloat("_MirrorSaturation", WaterXmlConfig.MirrorSaturation);
        water.SetFloat("_MirrorContrast", WaterXmlConfig.MirrorContrast);
        water.SetFloat("_MirrorFPOW", WaterXmlConfig.MirrorFPOW);
        water.SetFloat("_MirrorR0", WaterXmlConfig.MirrorR0);
        water.SetFloat("_MirrorWavePow", WaterXmlConfig.MirrorWavePow);
        water.SetFloat("_MirrorWaveScale", WaterXmlConfig.MirrorWaveScale);
        water.SetFloat("_MirrorWaveFlow", WaterXmlConfig.MirrorWaveFlow);

        // Settings for foam module
        water.SetVector("_FoamSoft", WaterXmlConfig.FoamSoft);
        water.SetColor("_FoamColor", WaterXmlConfig.FoamColor);
        water.SetFloat("_FoamFlow", WaterXmlConfig.FoamFlow);
        water.SetFloat("_FoamGain", WaterXmlConfig.FoamGain);
        water.SetFloat("_FoamAmplitude", WaterXmlConfig.FoamAmplitude);
        water.SetFloat("_FoamFrequency", WaterXmlConfig.FoamFrequency);
        water.SetFloat("_FoamScale", WaterXmlConfig.FoamScale);
        water.SetFloat("_FoamLacunary", WaterXmlConfig.FoamLacunary);

        // Below uniforms are only for specular setup

        // [HideInInspector]_Shininess("Shininess", Range(0.01, 1)) = 0.15
        // water.SetFloat("_Shininess", 0.75f);
        // [HideInInspector][HDR]_SpecColor("Specular Color", Color) = (0.086, 0.086, 0.086, 1)
        // water.SetColor("_SpecColor", new Color(0.086f, 0.086f, 0.086f, 1));

        // [HideInInspector]_ReflectionCube("Reflection Cubemap", Cube) = "" { }
        // water.SetCube("_ReflectionCube", where is that cube?);
        // [HideInInspector][HDR] _ReflectionColor("Reflection Color", Color) = (0.28, 0.29, 0.25, 0.5)
        // water.SetColor("_ReflectionColor", new Color(0.78f, 0.75f, 0.71f, 0.5f));
        // [HideInInspector]_ReflectionStrength("Reflection Strength", Range(0, 10)) = 0.15
        // water.SetFloat("_ReflectionStrength", 0.15f);
        // [HideInInspector]_ReflectionSaturation("Reflection Saturation", Range(0, 5)) = 1
        // water.SetFloat("_ReflectionSaturation", 1);
        // [HideInInspector]_ReflectionContrast("Reflection Contrast", Range(0, 5)) = 1
        // water.SetFloat("_ReflectionContrast", 1);
        // [HideInInspector]_MirrorReflectionTex("_MirrorReflectionTex", 2D) = "gray" { }
        // water.SetTexture("_MirrorReflectionTex", mirror);

    }

    [HarmonyPatch(typeof(WorldGlobalFromXml), "Load")]
    static class PatchWorldGlobalFromXmlLoad
    {
        static void Prefix(XmlFile _xmlFile)
        {
            if (GameManager.IsDedicatedServer) return;
            foreach (XmlNode node in _xmlFile.XmlDoc.DocumentElement.ChildNodes)
            {
                if (node.Name != "water") continue;
                foreach (XmlNode subnode in node.ChildNodes)
                {
                    if (subnode.Name != "property") continue;
                    if (subnode.NodeType != XmlNodeType.Element) continue;
                    XmlElement child = subnode as XmlElement;
                    string value = child.GetAttribute("value");
                    switch (child.GetAttribute("name"))
                    {
                        // Replacement shaders to load afterwards
                        case "shader": ShaderNearPath = DataLoader.ParseDataPathIdentifier(value); break;
                        case "distant": ShaderDistPath = DataLoader.ParseDataPathIdentifier(value); break;
                        // Base PBR lighting config
                        case "metallic": Metallic = ParseFloat(value); break;
                        case "glossiness": Glossiness = ParseFloat(value); break;
                        // Water clarity params (start/end/power/offset)
                        case "clarity": Clarity = ParseColor(value); break;
                        // Main textures to load afterwards
                        case "albedo1": Albedo1Path = DataLoader.ParseDataPathIdentifier(value); break;
                        case "albedo2": Albedo2Path = DataLoader.ParseDataPathIdentifier(value); break;
                        case "normal1": Normal1Path = DataLoader.ParseDataPathIdentifier(value); break;
                        case "normal2": Normal2Path = DataLoader.ParseDataPathIdentifier(value); break;
                        // Texture uv scale and offets
                        case "albedo1-scale": Albedo1Scale = ParseVector2(value); break;
                        case "albedo2-scale": Albedo2Scale = ParseVector2(value); break;
                        case "normal1-scale": Normal1Scale = ParseVector2(value); break;
                        case "normal2-scale": Normal2Scale = ParseVector2(value); break;
                        case "albedo1-offset": Albedo1Offset = ParseVector2(value); break;
                        case "albedo2-offset": Albedo2Offset = ParseVector2(value); break;
                        case "normal1-offset": Normal1Offset = ParseVector2(value); break;
                        case "normal2-offset": Normal2Offset = ParseVector2(value); break;
                        // Flow speeds of texture UVs
                        case "albedo1-flow": Albedo1Flow = ParseFloat(value); break;
                        case "albedo2-flow": Albedo2Flow = ParseFloat(value); break;
                        case "normal1-flow": NormalMap1Flow = ParseFloat(value); break;
                        case "normal2-flow": NormalMap2Flow = ParseFloat(value); break;
                        // Normal strengths for various features
                        case "normal1-strength": NormalMap1Strength = ParseFloat(value); break;
                        case "normal2-strength": NormalMap2Strength = ParseFloat(value); break;
                        case "microwave-strength": MicrowaveStrength = ParseFloat(value); break;
                        case "microwave-scale": MicrowaveScale = ParseFloat(value); break;
                        // Tint color for the albedo textures
                        case "albedo1-color": Albedo1Color = ParseColor(value); break;
                        case "albedo2-color": Albedo2Color = ParseColor(value); break;
                        // Color for shallow water
                        case "shore-color": ShoreColor = ParseColor(value); break;
                        // Color for water surface
                        case "surface-color": SurfaceColor = ParseColor(value); break;
                        // Factors for final albedo color
                        case "surface-intensity": SurfaceIntensity = ParseFloat(value); break;
                        case "surface-contrast": SurfaceContrast = ParseFloat(value); break;
                        // Configs for parallax module
                        case "parallax-strength": ParallaxStrength = ParseFloat(value); break;
                        case "parallax-flow": ParallaxFlow = ParseFloat(value); break;
                        case "parallax-albedo1-factor": ParallaxAlbedo1Factor = ParseFloat(value); break;
                        case "parallax-albedo2-factor": ParallaxAlbedo2Factor = ParseFloat(value); break;
                        case "parallax-normal1-factor": ParallaxNormal1Factor = ParseFloat(value); break;
                        case "parallax-normal2-factor": ParallaxNormal2Factor = ParseFloat(value); break;
                        case "parallax-noise-gain": ParallaxNoiseGain = ParseFloat(value); break;
                        case "parallax-noise-amplitude": ParallaxNoiseAmplitude = ParseFloat(value); break;
                        case "parallax-noise-frequency": ParallaxNoiseFrequency = ParseFloat(value); break;
                        case "parallax-noise-scale": ParallaxNoiseScale = ParseFloat(value); break;
                        case "parallax-noise-Lacunary": ParallaxNoiseLacunary = ParseFloat(value); break;
                        // Configs for foam module
                        case "foam-color": FoamColor = ParseColor(value); break;
                        case "foam-soft": FoamSoft = ParseColor(value); break;
                        case "foam-flow": FoamFlow = ParseFloat(value); break;
                        case "foam-gain": FoamGain = ParseFloat(value); break;
                        case "foam-amplitude": FoamAmplitude = ParseFloat(value); break;
                        case "foam-frequency": FoamFrequency = ParseFloat(value); break;
                        case "foam-scale": FoamScale = ParseFloat(value); break;
                        case "foam-Lacunary": FoamLacunary = ParseFloat(value); break;
                        // Configs for mirror module (not yet enabled)
                        case "mirror-color": MirrorColor = ParseColor(value); break;
                        case "mirror-depth-color": MirrorDepthColor = ParseColor(value); break;
                        case "mirror-strength": MirrorStrength = ParseFloat(value); break;
                        case "mirror-saturation": MirrorSaturation = ParseFloat(value); break;
                        case "mirror-contrast": MirrorContrast = ParseFloat(value); break;
                        case "mirror-fpow": MirrorFPOW = ParseFloat(value); break;
                        case "mirror-r0": MirrorR0 = ParseFloat(value); break;
                        case "mirror-wave-pow": MirrorWavePow = ParseFloat(value); break;
                        case "mirror-wave-scale": MirrorWaveScale = ParseFloat(value); break;
                        case "mirror-wave-flow": MirrorWaveFlow = ParseFloat(value); break;
                    }
                }
            }

            // We should be able to assign to water mesh description by now!?
            if (MeshDescription.MESH_WATER >= MeshDescription.meshes?.Length) return;
            MeshDescription mesh = MeshDescription.meshes[MeshDescription.MESH_WATER];

            // Load the resources define by configuration
            if (ShaderNearPath.IsBundle) ShaderNear = DataLoader.LoadAsset<Shader>(ShaderNearPath);
            if (ShaderDistPath.IsBundle) ShaderDist = DataLoader.LoadAsset<Shader>(ShaderDistPath);
            if (Albedo1Path.IsBundle) Albedo1 = DataLoader.LoadAsset<Texture>(Albedo1Path);
            if (Albedo2Path.IsBundle) Albedo2 = DataLoader.LoadAsset<Texture>(Albedo2Path);
            if (Normal1Path.IsBundle) Normal1 = DataLoader.LoadAsset<Texture>(Normal1Path);
            if (Normal2Path.IsBundle) Normal2 = DataLoader.LoadAsset<Texture>(Normal2Path);

            // Load the near water shader
            if (ShaderNearPath.IsBundle)
            {
                ShaderNear = DataLoader.LoadAsset<Shader>(ShaderNearPath);
                mesh.material.shader = ShaderNear;
                SetupWaterMaterial(mesh.material);
            }

            // Load the distant water shader
            if (ShaderDistPath.IsBundle)
            {
                ShaderDist = DataLoader.LoadAsset<Shader>(ShaderDistPath);
                mesh.materialDistant.shader = ShaderDist;
                SetupWaterMaterial(mesh.materialDistant);
            }

        }
    }

}
