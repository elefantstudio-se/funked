float4x4 World;
float4x4 View;
float4x4 Projection;

float specularIntensity = 0.8f;
float specularPower = 0.5f; 

bool useTexture;
bool useEmissive;
bool useNormal = false;
float normalScale = 1.0f;

float4 diffuseColor = {1.0f, 1.0f, 1.0f, 1.0f};
float4 emissiveColor = {0.0f, 0.0f, 0.0f, 1.0f};

texture diffuseTexture;
sampler diffuseSampler = sampler_state
{
    Texture = (diffuseTexture);
    MAGFILTER = Linear;
    MINFILTER = Linear;
    MIPFILTER = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
};

texture normalTexture;
sampler normalSampler = sampler_state
{
    Texture = (normalTexture);
    MAGFILTER = Linear;
    MINFILTER = Linear;
    MIPFILTER = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
};

texture emissiveTexture;
sampler emissiveSampler = sampler_state
{
    Texture = (emissiveTexture);
    MAGFILTER = Linear;
    MINFILTER = Linear;
    MIPFILTER = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
};

struct VertexShaderInput
{
    float4 Position : POSITION0;
    float3 Normal : NORMAL0;
    float2 TexCoord : TEXCOORD0;
    float3 Binormal : BINORMAL0;
    float3 Tangent : TANGENT0;
};

struct VertexShaderOutput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
    float3 Normal : TEXCOORD1;
    float4 PointPosition : TEXCOORD2;
    float3x3 TangentToWorld : TEXCOORD3;
};

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;

    float4x4 worldViewProjection = mul( mul(World, View), Projection);
    output.Position = mul(input.Position, worldViewProjection);

    output.TexCoord = input.TexCoord;
                              
    output.Normal = mul(input.Normal,World);               
    output.PointPosition = mul(input.Position, World);
	output.TangentToWorld[0] = mul(input.Tangent, World);
	output.TangentToWorld[1] = mul(input.Binormal, World);
	output.TangentToWorld[2] = mul(input.Normal, World);

    return output;
}

struct PixelShaderOutput
{
	// Position(half3)
    float4 MRT1 : COLOR0;
    
    // Color(half3) and Specular Power(half)
    float4 MRT2 : COLOR1;
    
    // Normal(half3) and Specular Intensity(half)
    float4 MRT3 : COLOR2;
    
    // Emissive light
    float4 MRT4 : COLOR3;
};

PixelShaderOutput PixelShaderFunction(VertexShaderOutput input)
{
    PixelShaderOutput output;
    
    float3 position = input.PointPosition.xyz;
     
    float3 color;    
    if( useTexture)
    {
		color = tex2D(diffuseSampler, input.TexCoord);
    }
    else
    {
    	color = diffuseColor.rgb;
    }  
    
    float3 emissive;    
    if( useEmissive)
    {
		emissive = tex2D(emissiveSampler, input.TexCoord);
    }
    else
    {
    	emissive = emissiveColor;
    }    
    
    float3 normal = input.Normal;
    if( useNormal)
    {
		float3 normalMap = tex2D(normalSampler, input.TexCoord);
		normalMap = 2.0f * normalMap - 1.0f;
		normalMap.xy = normalMap.xy * normalScale;
		normalMap = normalize(normalMap);
		normal = mul(normalMap, input.TangentToWorld);
    }
    normal = normalize(normal);

	output.MRT1.rgb = position;
    output.MRT1.a = 1.0f;    

    output.MRT2.rgb = color;
	output.MRT2.a = specularPower / 255.0f;
    
    output.MRT3.rgb = normal * 0.5f + 0.5f;
	output.MRT3.a = specularIntensity;
	
	output.MRT4.rgb = emissive;
	output.MRT4.a = 1.0f;
    
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
