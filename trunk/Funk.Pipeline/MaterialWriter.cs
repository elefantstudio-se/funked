using System;
using System.Collections.Generic;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Content.Pipeline;
using Microsoft.Xna.Framework.Content.Pipeline.Graphics;
using Microsoft.Xna.Framework.Content.Pipeline.Processors;
using Microsoft.Xna.Framework.Content.Pipeline.Serialization.Compiler;

namespace MaterialPipeline
{
    /// <summary>
    /// This class will be instantiated by the XNA Framework Content Pipeline
    /// to write the specified data type into binary .xnb format.
    ///
    /// This should be part of a Content Pipeline Extension Library project.
    /// </summary>
    [ContentTypeWriter]
    public class MaterialWriter : ContentTypeWriter<MaterialContent>
    {
        protected override void Write(ContentWriter output, MaterialContent value)
        {
            output.Write(value.UseTexture);
            output.Write(value.DiffuseColor.ToVector4());

            output.Write(value.UseNormal);
            output.Write(value.NormalScale);

            output.Write(value.UseEmissive);

            output.Write(value.SpecularIntensity);
            output.Write(value.SpecularPower);

            if (value.UseTexture)
            {
                output.WriteExternalReference<TextureContent>(value.TextureRef);
            }
            if (value.UseNormal)
            {
                output.WriteExternalReference<TextureContent>(value.NormalRef);
            }
            if (value.UseEmissive)
            {
                output.WriteExternalReference<TextureContent>(value.EmissiveRef);
            }
        }

        public override string GetRuntimeReader(TargetPlatform targetPlatform)
        {
            return "DeferredShading.MaterialReader, DeferredShading";
        }
    }
}
