using System;
using System.Collections.Generic;
using System.Text;
using LuaInterface;
using Funk.Engine.Script;

namespace MaterialPipeline
{
    public class LuaAssetReader
    {
        public static MaterialContent ReadMaterial(LuaSourceFile luaSource)
        {
            LuaManager lua = new LuaManager();
            MaterialContent material = MaterialContent.Default;

            lua.DoString("load_assembly(\"Microsoft.Xna.Framework.Graphics\")");

            lua["Material"] = material;

            lua.DoString(luaSource.Source);

            return material;
        }
    }
}
