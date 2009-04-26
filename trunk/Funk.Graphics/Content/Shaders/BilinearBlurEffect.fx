float4x4 World;
float4x4 View;
float4x4 Projection;

float2 halfPixel;

const int nbrSamples = 4;

const float weights9[5] = {
	0.20,
	0.16,
	0.12,
	0.07,
	0.05,
};

texture Texture;
sampler textureSampler = sampler_state
{
    Texture = (Texture);
    MAGFILTER = Linear;
    MINFILTER = Linear;
    MIPFILTER = Linear;
    AddressU = Mirror;
    AddressV = Mirror;
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

float4 SumSamples(float2 texCoord, float2 offset)
{
	float4 final = 0;
	final = weights9[0] * tex2D(textureSampler, texCoord);
	for(int i=0; i<nbrSamples; i++) {
		final = final + weights9[i+1] * tex2D(textureSampler, texCoord + (i+1) * offset);
		final = final + weights9[i+1] * tex2D(textureSampler, texCoord + -(i+1) * offset);
    }
    return final;
}

float4 PixelShaderFunctionH(VertexShaderOutput input) : Color0
{    
    return SumSamples(input.TexCoord, float2( 2 * halfPixel.x, 0));
}

float4 PixelShaderFunctionV(VertexShaderOutput input) : Color0
{    
    return SumSamples(input.TexCoord, float2( 0, 2 * halfPixel.y));
}

technique VerticalBlur
{
    pass Pass1
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader = compile ps_2_0 PixelShaderFunctionV();
    }
}

technique HorizontalBlur
{  
    pass Pass1
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader = compile ps_2_0 PixelShaderFunctionH();
    }
}
