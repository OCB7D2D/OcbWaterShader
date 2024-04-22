using HarmonyLib;
using System.Reflection;
using UnityEngine;

public class OcbWaterShader : IModApi
{

    // True once when config was loaded
    public static bool IsLoaded = false;

    public void InitMod(Mod mod)
    {
        if (GameManager.IsDedicatedServer) return;
        Log.Out("OCB Harmony Patch: " + GetType().ToString());
        Harmony harmony = new Harmony(GetType().ToString());
        harmony.PatchAll(Assembly.GetExecutingAssembly());
        ModEvents.GameShutdown.RegisterHandler(OnGameShutdown);
    }

    // Hook to reset the loaded flag
    private void OnGameShutdown()
    {
        IsLoaded = false;
    }

    // Hook to load our own water shader by quality
    [HarmonyPatch(typeof(MeshDescription), "SetWaterQuality")]
    static class MeshDescriptionSetWaterQualityPatch
    {
        static bool Prefix()
        {
            if (IsLoaded == false) return true; // Let vanilla do early initialization
            if (GameManager.IsDedicatedServer || MeshDescription.meshes == null) return false;
            if (MeshDescription.MESH_WATER >= MeshDescription.meshes.Length) return false;
            switch (GamePrefs.GetInt(EnumGamePrefs.OptionsGfxWaterQuality))
            {
                case 0:
                    WaterXmlConfig.LoadWaterShader("Low");
                    break;
                default:
                    WaterXmlConfig.LoadWaterShader("High");
                    break;
            }
            return false;
        }
    }

/*
    // Was only required to do the reflection?
    [HarmonyPatch(typeof(UnityDistantTerrainTest), "LoadTerrain")]
    static class PatchLoadTerrain
    {
        static void Prefix()
        {
            if (GameManager.IsDedicatedServer || MeshDescription.meshes == null) return;
            if (MeshDescription.MESH_WATER >= MeshDescription.meshes.Length) return;
            MeshDescription mesh = MeshDescription.meshes[MeshDescription.MESH_WATER];
            if (GameManager.Instance.World.ChunkCache.ChunkProvider is ChunkProviderGenerateWorldFromRaw provider)
            {
                var size = provider.GetWorldSize();
                var dim = new Vector2(size.x, size.y);
                mesh.material.SetVector("_WorldDim", dim);
                mesh.materialDistant.SetVector("_WorldDim", dim);
                if (!GameManager.Instance.gameObject.GetComponent<OcbNvWaterShaders>())
                    GameManager.Instance.gameObject.AddComponent<OcbNvWaterShaders>();
            }
        }
    }
*/

    // Hook to animate the wind zone a bit more than vanilla
    [HarmonyPatch(typeof(WeatherManager), "WindFrameUpdate")]
    static class WeatherManagerWindFrameUpdate
    {

        static Vector2 RotateSpeed = new Vector2(0.4f, 0.4f);
        static Vector2 RotateDistance = new Vector2(2.0f, 2.0f);
        static Vector4 NvWatersMovement = new Vector4(0, 0, 0, 0);
        static Vector2 wVectorX = new Vector2(0, 0);
        static Vector2 wVectorY = new Vector2(0, 0);

        static void Postfix(float ___windTime /*,
            WindZone ___windZone, float ___windGust,
            float ___windGustStep, float ___windGustTime*/)
        {

// when windspeed is low, randomize wind direction more
// realize different water and wave movements here
// make speed pow(wind, 0.5) (fast increasing, but still 1)

            var ax = Quaternion.AngleAxis(___windTime * RotateSpeed.x, Vector3.forward);
            var ay = Quaternion.AngleAxis(___windTime * RotateSpeed.x, Vector3.forward);
            wVectorX = ax * Vector2.one * RotateDistance.x;
            wVectorY = ay * Vector2.one * RotateDistance.y;
            NvWatersMovement.x = wVectorX.x * RotateDistance.x;
            NvWatersMovement.y = wVectorX.y * RotateDistance.x;
            NvWatersMovement.z = wVectorY.x * RotateDistance.y;
            NvWatersMovement.w = wVectorY.y * RotateDistance.y;
            Shader.SetGlobalVector("_NvWatersMovement", NvWatersMovement);
        }
    }

}
