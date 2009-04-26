//////////////////////////
//
//
//
//////////////

float4x4 World;
float4x4 View;
float4x4 Projection;

struct VertexShaderInput
{
    float4 Position : POSITION0;
    float3 Normal : NORMAL0;
    float2 TexCoord : TEXCOORD0;
};

struct VertexShaderOutput
{
    float4 Position : POSITION0;
};

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;

    float4x4 worldViewProjection = mul( mul(World, View), Projection);
    output.Position = mul(input.Position, worldViewProjection);

    return output;
}

struct PixelShaderOutput
{
	// Position(float)
    float4 RT1 : COLOR0;
    
    // Color(half3) and Specular Power(half)
    float4 RT2 : COLOR1;
    
    // Normal(half3) and Specular Intensity(half)
    float4 RT3 : COLOR2;
    
    // Emissive light
    float4 RT4 : COLOR3;
};

PixelShaderOutput PixelShaderFunction(VertexShaderOutput input)
{
    PixelShaderOutput output;
    
    output.RT1.rgba = 0.0f;
    output.RT1.a = 0.0f;
    	
    output.RT2.rgb = 0.0f;
	output.RT2.a = 0.0f;

    output.RT3.rgb = 0.0f;
	output.RT3.a = 0.0f;
	
	output.RT4.rgb = 0.0f;
	output.RT4.a = 1.0f;
    
    return output;
}

technique Technique1
{
    pass Pass1
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}
