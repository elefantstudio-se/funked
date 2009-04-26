//////////////////////////
//
//
//
//////////////

float4x4 World;
float4x4 View;
float4x4 Projection;

float3 cameraPosition = {0.0f, 0.0f, 0.0f};

float3 lightColor =  {1.0f, 1.0f, 1.0f};
float3 lightDirection =  {1.0f, 1.0f, 1.0f};
float lightIntensity = 1.0f;

float2 halfPixel;

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

struct VertexShaderInput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
};

struct VertexShaderOutput
{
    float4 Position : POSITION0;
    float3 LightDirection : TEXCOORD1;
    float2 TexCoord : TEXCOORD0;
};

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;

    float4x4 worldViewProjection = mul( mul(World, View), Projection);
    output.Position = mul(input.Position, worldViewProjection);

	output.TexCoord = input.TexCoord - halfPixel;
	output.LightDirection = normalize( lightDirection );

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
    
    float4 rt1Data = tex2D(RT1Sampler, texCoord);
    float4 rt2Data = tex2D(RT2Sampler, texCoord);
    float4 rt3Data = tex2D(RT3Sampler, texCoord);
    
    float3 fragmentPosition = rt1Data.rgb;
    float3 normal = (rt3Data.rgb -0.5f) * 2.0f; 
    
    float specularIntensity = rt3Data.a;
    float specularPower = rt2Data.a * 255.0f;
    
    float3 lightVector = - input.LightDirection;
    float3 viewVector = cameraPosition - fragmentPosition;
    float3 reflectionVector = reflect( lightVector, normal);  
    
    lightVector = normalize(lightVector);
    viewVector = normalize(viewVector);
    reflectionVector = normalize(reflectionVector); 
    
    float diffuseLighting = lightIntensity * max(0, dot( lightVector, normal));
    float specLighting = lightIntensity * specularIntensity * pow ( max(0, - dot( reflectionVector, viewVector)), specularPower);
    
    output.Color.rgb = saturate(diffuseLighting * lightColor); 
    output.Color.a = lightColor * specLighting;
       
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
