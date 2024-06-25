using UnityEngine;
using System.Collections.Generic;
using static StringParsers;

public class WaterShaderCmd : ConsoleCmdAbstract
{

    private static string info = "watershader";
    public override string[] getCommands()
    {
        return new string[2] { info, "ws" };
    }

    public override string getDescription()
    {
        return "Adjust settings for Water shaders";
    }

    public override bool IsExecuteOnClient => true;
    public override bool AllowedInMainMenu => false;

    public static Vector4 ParseVector4(string _input)
    {
        SeparatorPositions separatorPositions = GetSeparatorPositions(_input, ',', 3);
        if (separatorPositions.TotalFound != 3) return Vector4.zero;
        return new Vector4(ParseFloat(_input, 0, separatorPositions.Sep1 - 1),
            ParseFloat(_input, separatorPositions.Sep1 + 1, separatorPositions.Sep2 - 1),
            ParseFloat(_input, separatorPositions.Sep2 + 1, separatorPositions.Sep3 - 1),
            ParseFloat(_input, separatorPositions.Sep3 + 1));
    }


    void SetMatProperty(Material mat, string type, string name, string value)
    {
        if (mat.HasProperty(name))
        {
            switch (type)
            {
                case "f":
                case "float":
                    mat.SetFloat(name, ParseFloat(value));
                    break;
                case "c":
                case "col":
                case "color":
                    mat.SetColor(name, ParseColor(value));
                    break;
                case "v2":
                case "vec2":
                case "vector2":
                    mat.SetVector(name, ParseVector2(value));
                    break;
                case "v3":
                case "vec3":
                case "vector3":
                    mat.SetVector(name, ParseVector3(value));
                    break;
                case "v":
                case "v4":
                case "vec4":
                case "vector4":
                    mat.SetVector(name, ParseVector4(value));
                    break;
                case "s":
                case "scale":
                    mat.SetTextureScale(name, ParseVector2(value));
                    break;
                case "o":
                case "off":
                case "offset":
                    mat.SetTextureOffset(name, ParseVector2(value));
                    break;
            }
        }
        else
        {
            Log.Warning("Material {0} missing {1}",
                mat.name, name);
        }
    }

    object GetMatProperty(Material mat, string type, string name)
    {
        if (mat.HasProperty(name))
        {
            switch (type)
            {
                case "f":
                case "float":
                    return mat.GetFloat(name);
                case "c":
                case "col":
                case "color":
                    return mat.GetColor(name);
                case "v":
                case "v2":
                case "vec2":
                case "vector2":
                case "v3":
                case "vec3":
                case "vector3":
                case "v4":
                case "vec4":
                case "vector4":
                    return mat.GetVector(name);
                case "s":
                case "scale":
                    return mat.GetTextureScale(name);
                case "o":
                case "off":
                case "offset":
                    return mat.GetTextureOffset(name);
                default:
                    return $"Unknown type {type}";
            }
        }
        return $"missing {name}";
    }

    public override void Execute(List<string> _params, CommandSenderInfo _senderInfo)
    {

        var mesh = MeshDescription.meshes[MeshDescription.MESH_WATER];

        if (_params.Count == 1)
            switch (_params[0])
            {
                case "props":
                    for (int i = 0; i < mesh.material.shader.GetPropertyCount(); i++)
                    {
                        object value = "NULL";
                        string name = mesh.material.shader.GetPropertyName(i);
                        UnityEngine.Rendering.ShaderPropertyType type = mesh.material.shader.GetPropertyType(i);
                        if (mesh.material.HasProperty(name))
                        {
                            switch (type)
                            {
                                case UnityEngine.Rendering.ShaderPropertyType.Color:
                                    value = mesh.material.GetColor(name);
                                    break;
                                case UnityEngine.Rendering.ShaderPropertyType.Vector:
                                    value = mesh.material.GetVector(name);
                                    break;
                                case UnityEngine.Rendering.ShaderPropertyType.Float:
                                case UnityEngine.Rendering.ShaderPropertyType.Range:
                                    value = mesh.material.GetFloat(name);
                                    break;
                                case UnityEngine.Rendering.ShaderPropertyType.Texture:
                                    value = mesh.material.GetTexture(name);
                                    break;
                            }
                        }
                        Log.Out(" <{0}> {1} => {2}", type, name, value);
                    }
                    return;
            }

        if (_params.Count == 3)
            switch (_params[0])
            {
                case "get":
                    Log.Out("Showing current value of {0}", _params[0]);
                    Log.Out(" details: {0}", GetMatProperty(mesh.material, _params[1], _params[2]));
                    Log.Out(" distant: {0}", GetMatProperty(mesh.materialDistant, _params[1], _params[2]));
                    return;
            }
        if (_params.Count == 4)
            switch (_params[0])
            {
                case "set":
                    SetMatProperty(mesh.material, _params[1], _params[2], _params[3]);
                    SetMatProperty(mesh.materialDistant, _params[1], _params[2], _params[3]);
                    return;
            }

        // If not returned by now we have not done
        Log.Warning("Invalid `watershader` command");

    }

}
