float4x4 World;
float4x4 View;
float4x4 Projection;

float4 ambientColor;

float2 halfPixel;

bool useSSAO = false;

texture lightMap;
sampler lightMapSampler = sampler_state
{
    Texture = (lightMap);
    MAGFILTER = POINT;
    MINFILTER = POINT;
    MIPFILTER = POINT;
    AddressU = Clamp;
    AddressV = Clamp;
};

texture AOMap;
sampler AOMapSampler = sampler_state
{
    Texture = (AOMap);
    MAGFILTER = Linear;
    MINFILTER = Linear;
    MIPFILTER = Linear;
    AddressU = Clamp;
    AddressV = Clamp;
};

texture RT1;
sampler RT1Sampler = sampler_state
{
    Texture = (RT1);
    MAGFILTER = POINT;
    MINFILTER = POINT;
    MIPFILTER = POINT;
    AddressU = Clamp;
    AddressV = Clamp;
};

texture RT2;
sampler RT2Sampler = sampler_state
{
    Texture = (RT2);
    MAGFILTER = POINT;
    MINFILTER = POINT;
    MIPFILTER = POINT;
    AddressU = Clamp;
    AddressV = Clamp;
};

texture RT3;
sampler RT3Sampler = sampler_state
{
    Texture = (RT3);
    MAGFILTER = POINT;
    MINFILTER = POINT;
    MIPFILTER = POINT;
    AddressU = Clamp;
    AddressV = Clamp;
};

texture RT4;
sampler RT4Sampler = sampler_state
{
    Texture = (RT4);
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

	output.TexCoord = input.TexCoord;

    return output;
}

struct PixelShaderOutput
{
    float4 Color : COLOR0;    
};

PixelShaderOutput PixelShaderFunction(VertexShaderOutput input)
{
    PixelShaderOutput output;
    
    float2 texCoord = input.TexCoord;
      
    float3 diffuseColor = tex2D(RT2Sampler, texCoord);
    float4 diffuseLight = tex2D(lightMapSampler, texCoord + halfPixel);
    float3 emissiveLight = tex2D(RT4Sampler, texCoord);
    float ambientLight = tex2D(AOMapSampler, texCoord - halfPixel);
    
    float3 ambient = ambientColor.rgb;  
    
    float specularLight = diffuseLight.a;
      
	float3 color;
    if(useSSAO)
    {
		float3 light = diffuseLight.rgb +  ambient; 
		light = light + emissiveLight; 

		color = light * diffuseColor + specularLight;    
		color = color * ambientLight + emissiveLight;
    }   
    else
    {
		float3 light = diffuseLight.rgb +  ambient; 
		light = light + emissiveLight; 

		color = light * diffuseColor + specularLight;    
		color = color + emissiveLight;
    }
        
    output.Color.rgb = color;   
    output.Color.a = 1.0f;   
       
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
