using System;
using System.Collections.Generic;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Content.Pipeline;
using Microsoft.Xna.Framework.Content.Pipeline.Graphics;
using Microsoft.Xna.Framework.Content.Pipeline.Processors;
using Ika.Script;
using System.ComponentModel;

namespace MaterialPipeline
{
    [ContentProcessor(DisplayName = "Lua Material Processor")]
    public class MaterialFromLuaProcessor : ContentProcessor<LuaSourceFile, MaterialContent>
    {/*
        bool m_compileTextures = true;
        [DefaultValue(true)]
        [DisplayName("Compile Textures")]
        public bool CompileTextures
        {
            get { return m_generateMipmaps; }
            set { m_generateMipmaps = value; }
        }*/

        bool m_generateMipmaps = true;  
        [DefaultValue(true)]
        [DisplayName("Generate Mipmaps")]
        public bool GenerateMipmaps
        {
            get { return m_generateMipmaps; }
            set { m_generateMipmaps = value; }
        }

        bool m_resizeToPowerOfTwo = true;
        [DefaultValue(true)]
        [DisplayName("Resize To Power Of Two")]
        public bool ResizeToPowerOfTwo
        {
            get { return m_resizeToPowerOfTwo; }
            set { m_resizeToPowerOfTwo = value; }
        }

        public override MaterialContent Process(LuaSourceFile input, ContentProcessorContext context)
        {
            MaterialContent myMat = LuaAssetReader.ReadMaterial(input);

            TextureProcessor texProcessor = new TextureProcessor();
            texProcessor.TextureFormat = TextureProcessorOutputFormat.DxtCompressed;
            texProcessor.ResizeToPowerOfTwo = true;
            texProcessor.GenerateMipmaps = true;


            OpaqueDataDictionary parameters = new OpaqueDataDictionary();
            parameters.Add("TextureFormat",TextureProcessorOutputFormat.DxtCompressed);
            parameters.Add("ResizeToPowerOfTwo",true);
            parameters.Add("GenerateMipmaps", true);
       //     parameters.Add("CompileTextures", true);

            if (myMat.UseTexture)
            {
                myMat.TextureRef = context.BuildAsset<TextureContent, TextureContent>(new ExternalReference<TextureContent>(myMat.Texture), "TextureProcessor", parameters, null, null);
            }
            if (myMat.UseNormal)
            {
                myMat.NormalRef = context.BuildAsset<TextureContent, TextureContent>(new ExternalReference<TextureContent>(myMat.Normal), "TextureProcessor", parameters, null, null);
            }
            if (myMat.UseEmissive)
            {
                myMat.EmissiveRef = context.BuildAsset<TextureContent, TextureContent>(new ExternalReference<TextureContent>(myMat.Emissive), "TextureProcessor", parameters, null, null);
            }

            return myMat;
        }
    }
}