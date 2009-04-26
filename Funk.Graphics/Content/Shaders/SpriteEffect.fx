
float4x4 World;
float4x4 View;
float4x4 Projection;

float2 UVScale = {1,1};
float2 UVOffset = {0,0};
float Alpha = 1;

texture SpriteTexture;

sampler2D SpriteTextureSampler = sampler_state
{
	Texture = <SpriteTexture>;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
};

struct VertexShaderInput
{
    float4 Position : POSITION0;
    float2 UV : TEXCOORD0; 
};

struct VertexShaderOutput
{
    float4 Position : POSITION0;
    float2 UV : TEXCOORD0; 
};

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;

    float4x4 worldViewProjection = mul( mul(World, View), Projection);
    output.Position = mul(input.Position, worldViewProjection);
    
    output.UV.x = input.UV.x * UVScale.x + UVOffset.x;
    output.UV.y = input.UV.y * UVScale.y + UVOffset.y;
	
    return output;
}

float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{
	float4 color = tex2D(SpriteTextureSampler, input.UV);
	color.a = color.a * Alpha;
    return color;
}

technique Technique1
{
    pass Pass1
    {
        VertexShader = compile vs_1_1 VertexShaderFunction();
        PixelShader = compile ps_1_1 PixelShaderFunction();
    }
}
