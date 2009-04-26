using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Content.Pipeline;
using Microsoft.Xna.Framework.Content.Pipeline.Graphics;

namespace MaterialPipeline
{
    public class MaterialContent
    {
        bool m_useTexture;
        public bool UseTexture
        {
            get { return m_useTexture; }
            set { m_useTexture = value; }
        }

        Color m_diffuseColor;
        public Color DiffuseColor
        {
            get { return m_diffuseColor; }
            set { m_diffuseColor = value; }
        }

        String m_diffuse;
        public String Texture
        {
            get { return m_diffuse; }
            set { m_diffuse = value; }
        }

        ExternalReference<TextureContent> m_diffuseRef;
        public ExternalReference<TextureContent> TextureRef
        {
            get { return m_diffuseRef; }
            set { m_diffuseRef = value; }
        }

        bool m_useNormal;
        public bool UseNormal
        {
            get { return m_useNormal; }
            set { m_useNormal = value; }
        }

        String m_normal;
        public String Normal
        {
            get { return m_normal; }
            set { m_normal = value; }
        }


        ExternalReference<TextureContent> m_normalRef;
        public ExternalReference<TextureContent> NormalRef
        {
            get { return m_normalRef; }
            set { m_normalRef = value; }
        }

        float m_normalScale;
        public float NormalScale
        {
            get { return m_normalScale; }
            set { m_normalScale = value; }
        }

        bool m_useEmissive;
        public bool UseEmissive
        {
            get { return m_useEmissive; }
            set { m_useEmissive = value; }
        }

        String m_Emissive;
        public String Emissive
        {
            get { return m_Emissive; }
            set { m_Emissive = value; }
        }

        ExternalReference<TextureContent> m_EmissiveRef;
        public ExternalReference<TextureContent> EmissiveRef
        {
            get { return m_EmissiveRef; }
            set { m_EmissiveRef = value; }
        }

        float m_specularIntensity;
        public float SpecularIntensity
        {
            get { return m_specularIntensity; }
            set { m_specularIntensity = value; }
        }

        float m_specularPower;
        public float SpecularPower
        {
            get { return m_specularPower; }
            set { m_specularPower = value; }
        }

        public static MaterialContent Default
        {
            get { return new MaterialContent(); }
        }

        public MaterialContent()
        {
            UseTexture = false;
            DiffuseColor = Color.White;
            Texture = null;

            UseEmissive = false;
            Emissive = null;

            UseNormal = false;
            Normal = null;
            NormalScale = 1.0f;

            SpecularIntensity = 1.0f;
            SpecularPower = 24.0f;
        }
    }
}
