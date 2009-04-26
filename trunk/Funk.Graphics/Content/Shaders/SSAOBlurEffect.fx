
//Matrix used by this shader pass
float4x4 World;
float4x4 View;
float4x4 Projection;

//The render target half pixel
float2 halfPixel;

//The camera forward vector
float3 viewForward;

//The raw SSAO output
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

//Geometric information(world position)
texture RT1;
sampler positionSampler = sampler_state
{
    Texture = (RT1);
    MAGFILTER = Linear;
    MINFILTER = Linear;
    MIPFILTER = Linear;
    AddressU = Border;
    AddressV = Border;
};

//Geometric information(world normal)
texture RT3;
sampler normalSampler = sampler_state
{
    Texture = (RT3);
    MAGFILTER = Linear;
    MINFILTER = Linear;
    MIPFILTER = Linear;
    AddressU = Border;
    AddressV = Border;
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

// Simple vertex shader
VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;

    float4x4 worldViewProjection = mul( mul(World, View), Projection);
    output.Position = mul(input.Position, worldViewProjection);

	output.TexCoord = input.TexCoord + halfPixel;

    return output;
}

//The kernel distribution
const int nbrSamples = 4;
const float weights9[5] = {
	0.20,
	0.16,
	0.12,
	0.07,
	0.05,
};

//Global values used by the pixel shader
float fragmentDepth;
float3 fragmentNormal;
float3 forward;

//Depth comparison function
float depthThresholdMin = 3;
float depthThresholdMax = 6;
float WeightDepth(float d1, float d2)
{
	float delta = abs(d2-d1);
	float w = 1 / ( depthThresholdMax - depthThresholdMin) * delta - depthThresholdMin / ( depthThresholdMax - depthThresholdMin);
	return  (1 - saturate(w)) * (1 - saturate(w));
}

//Normal comparison function
float normalThresholdMin = 0.90;
float normalThresholdMax = 0.98;
float WeightNormal(float3 n1, float3 n2)
{
	float dot = abs(dot(n2, n1));
	float w = 1 / ( normalThresholdMax - normalThresholdMin) * dot - normalThresholdMin / ( normalThresholdMax - normalThresholdMin);
	return saturate(w) * saturate(w);	
}

//A structure holding information about a sampled pixel
struct SampleInfo
{
	float4 value;
	float weight;
};

//Sample a pixel at texCoords, and compute a new weight taking depth and normal into account
SampleInfo EvaluateSample(float2 texCoords, float baseWeight)
{
		SampleInfo sampleInfo;
		
		//We sample the different buffers
		float3 samplePos = tex2D(positionSampler, texCoords);
		float3 sampleNormal = tex2D(normalSampler, texCoords);
		float4 sampleColor = tex2D(textureSampler, texCoords);
		
		//And extract the desired information
		sampleNormal = normalize((sampleNormal - 0.5f) * 2.0f); 		
		float sampleDepth = dot(samplePos, forward);
		
		//The weight depends on the depth and normal comparison functions
		float weight = baseWeight * WeightNormal(sampleNormal, fragmentNormal) * WeightDepth( sampleDepth, fragmentDepth);
		
		//We return these values
		sampleInfo.value = weight * sampleColor;
		sampleInfo.weight = weight;
		
		return sampleInfo;
}

//Sum all the desired samples, along one axis(offset)
float4 SumSamples(float2 texCoord, float2 offset)
{
	//Obtain the normalized forward vector
	forward = normalize(viewForward);
	
	//We sample the different buffers
	float3 fragmentPos = tex2D(positionSampler, texCoord);
	fragmentNormal = tex2D(normalSampler, texCoord);
	
	//And extract the desired information
	fragmentNormal = normalize((fragmentNormal - 0.5f) * 2.0f); 	
	fragmentDepth = dot(fragmentPos, forward);
	
	//We initialze the accumulator with the center fragment values
	//We need to store the total weight to renormalize the result at the end
	SampleInfo accumulator;	
	accumulator.value = weights9[0] * tex2D(textureSampler, texCoord);
	accumulator.weight = weights9[0];
	
	//Sampling in the positive direction
	for(int i=0; i<nbrSamples; i++) 
	{
		SampleInfo info = EvaluateSample( texCoord + (i+1) * offset, weights9[i+1]);
		accumulator.value += info.value;
		accumulator.weight += info.weight;
	}	
	
	//Sampling in the negative direction
	for(int i=0; i<nbrSamples; i++) 
	{
		SampleInfo info = EvaluateSample( texCoord - (i+1) * offset, weights9[i+1]);
		accumulator.value += info.value;
		accumulator.weight += info.weight;
	}
	
	//We re-normalize the final weight before outputing the result
    return accumulator.value / accumulator.weight;
}

//Sample along the horizontal axis
float4 PixelShaderFunctionH(VertexShaderOutput input) : Color0
{    
    return SumSamples(input.TexCoord, float2( 2 * halfPixel.x, 0));
}

//Sample along the vertical axis
float4 PixelShaderFunctionV(VertexShaderOutput input) : Color0
{ 
    return SumSamples(input.TexCoord, float2( 0, 2 * halfPixel.y));
}


technique VerticalBlur
{
    pass Pass1
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader = compile ps_3_0 PixelShaderFunctionV();
    }
}

technique HorizontalBlur
{  
    pass Pass1
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader = compile ps_3_0 PixelShaderFunctionH();
    }
}