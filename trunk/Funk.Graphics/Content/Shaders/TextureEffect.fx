//////////////////////////
//
//
//
//////////////

float4x4 World;
float4x4 View;
float4x4 Projection;

float2 halfPixel;

texture Texture;
sampler textureSampler = sampler_state
{
    Texture = (Texture);
    MAGFILTER = Linear;
    MINFILTER = Linear;
    MIPFILTER = Linear;
    AddressU = Clamp;
    AddressV = Clamp;
};

struct VertexShaderInput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
};

struct VertexShaderOutput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
};

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;

    float4x4 worldViewProjection = mul( mul(World, View), Projection);
    output.Position = mul(input.Position, worldViewProjection);

	output.TexCoord = input.TexCoord + halfPixel;

    return output;
}


float4 PixelShaderFunction(VertexShaderOutput input) : Color0
{    
    return tex2D(textureSampler, input.TexCoord);
}

technique Technique1
{
    pass Pass1
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}
