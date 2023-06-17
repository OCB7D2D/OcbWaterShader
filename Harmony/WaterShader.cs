using HarmonyLib;
using System.Reflection;
using UnityEngine;

public class OcbWaterShader : IModApi
{

    public void InitMod(Mod mod)
    {
        Log.Out("OCB Harmony Patch: " + GetType().ToString());
        Harmony harmony = new Harmony(GetType().ToString());
        harmony.PatchAll(Assembly.GetExecutingAssembly());
    }


    [HarmonyPatch(typeof(MeshDescription), "SetWaterQuality")]
    static class PatchSetWaterQuality
    {
        static bool Prefix()
        {
            return false;
        }
    }

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
