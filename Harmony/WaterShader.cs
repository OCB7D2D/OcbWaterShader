using HarmonyLib;
using System.Reflection;
using UnityEngine;

public class OcbWaterShader : IModApi
{

    public void InitMod(Mod mod)
    {
        Debug.Log("Loading OCB WaterShader Patch: " + GetType().ToString());
        new Harmony(GetType().ToString()).PatchAll(Assembly.GetExecutingAssembly());
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

}
