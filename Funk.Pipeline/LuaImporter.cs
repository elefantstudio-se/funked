using System;
using System.Collections.Generic;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Content.Pipeline;
using Microsoft.Xna.Framework.Content.Pipeline.Graphics;
using Microsoft.Xna.Framework.Content.Pipeline.Processors;
using Funk.Engine.Script;

namespace MaterialPipeline
{
    /// <summary>
    /// </summary>
    [ContentImporter(".lua", DefaultProcessor = "LuaImporter",
      DisplayName = "Lua Source Code Importer")]
    public class LuaImporter : ContentImporter<LuaSourceFile>
    {
        public override LuaSourceFile Import(string filename, ContentImporterContext context)
        {
            return new LuaSourceFile(System.IO.File.ReadAllText(filename));
        }
    }
}