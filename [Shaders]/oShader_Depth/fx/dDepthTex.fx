//
// dBuffer.fx
//

//------------------------------------------------------------------------------------------
// dBuffer settings
//------------------------------------------------------------------------------------------
float2 sTexSize = float2(800,600);
#define zFarPlane 	1
#define zNearPlane 	0.001

bool fManualFocus = true;
float fNearBlurCurve = 10.0;	//[0.4 to X] Power of blur of closer-than-focus areas.
float fFarBlurCurve = 0.5;	//[0.4 to X] Elementary, my dear Watson: Blur power of areas behind focus plane.
float fManualFocusDepth = 0.1;	//[0.0 to 1.0] Manual focus depth. 0.0 means camera is focus plane, 1.0 means sky is focus plane.

//------------------------------------------------------------------------------------------
// These parameters are set by MTA whenever a shader is drawn
//------------------------------------------------------------------------------------------
texture gDepthBuffer : DEPTHBUFFER;
float4x4 gWorld : WORLD;
float4x4 gView : VIEW;
float4x4 gProjection : PROJECTION;
matrix gProjectionMainScene : PROJECTION_MAIN_SCENE;

//------------------------------------------------------------------------------------------
// Samplers
//------------------------------------------------------------------------------------------

sampler SamplerDepth = sampler_state
{
    Texture     = (gDepthBuffer);
    AddressU    = Clamp;
    AddressV    = Clamp;
};

//------------------------------------------------------------------------------------------
// Structure of data sent to the vertex shader
//------------------------------------------------------------------------------------------
struct VSInput
{
    float3 Position : POSITION0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
};

//------------------------------------------------------------------------------------------
// Structure of data sent to the pixel shader ( from the vertex shader )
//------------------------------------------------------------------------------------------
struct PSInput
{
    float4 Position : POSITION0;
    float4 Diffuse : COLOR0;
    float2 TexCoord: TEXCOORD0;
};

//------------------------------------------------------------------------------------------
//-- Helper functions
//------------------------------------------------------------------------------------------
float FetchDepthBufferValue( float2 uv )
{
    float4 texel = tex2D(SamplerDepth, uv);
#if IS_DEPTHBUFFER_RAWZ
    float3 rawval = floor(255.0 * texel.arg + 0.5);
    float3 valueScaler = float3(0.996093809371817670572857294849, 0.0038909914428586627756752238080039, 1.5199185323666651467481343000015e-5);
    return dot(rawval, valueScaler / 255.0);
#else
    return texel.r;
#endif
}

//------------------------------------------------------------------------------------------
// VertexShaderFunction
//------------------------------------------------------------------------------------------
PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

    // Calculate screen pos of vertex
    float4 posWorld = mul(float4(VS.Position.xyz,1), gWorld);
    float4 posWorldView = mul(posWorld, gView);
    PS.Position = mul(posWorldView, gProjection);
	
    // Pass through color and tex coord
    PS.Diffuse = VS.Diffuse;
    PS.TexCoord = VS.TexCoord;

    return PS;
}

float GetLinearDepth(float depth)
{
	return  1 / ((depth * ((zFarPlane - zNearPlane) / (-zFarPlane * zNearPlane)) + zFarPlane / (zFarPlane * zNearPlane)));
}

float GetFocalDepth(float2 focalpoint)
{ 
 	float depthsum = 0;
 	float fcRadius = 0.00;
    float scXY = sTexSize.x/sTexSize.y;
	
	for(int r=0;r<6;r++)
	{ 
 		float t = (float)r; 
 		t *= 3.1415*2/6; 
 		float2 coord = float2(cos(t),sin(t)); 
 		coord.y *= scXY; 
 		coord *= fcRadius; 
 		float depth = GetLinearDepth(FetchDepthBufferValue( float4(coord+focalpoint,0,0) )); 
 		depthsum += depth; 
 	}

	depthsum = depthsum/6;

    if (fManualFocus) depthsum = fManualFocusDepth;

	return depthsum; 
}

//------------------------------------------------------------------------------------------
// PixelShaderFunction
//------------------------------------------------------------------------------------------
float4 PixelShaderFunction(PSInput PS) : COLOR0
{
	float scenedepth = GetLinearDepth(FetchDepthBufferValue( PS.TexCoord.xy ));
	float scenefocus =  GetFocalDepth(float2(0.5,0.5));
	
	float depthdiff = abs(scenedepth-scenefocus);
	depthdiff = (scenedepth < scenefocus) ? pow(depthdiff, fNearBlurCurve) : depthdiff;
	depthdiff = (scenedepth > scenefocus) ? pow(depthdiff, fFarBlurCurve) : depthdiff;

	return saturate(float4(depthdiff,scenedepth,scenefocus,1));
}

//------------------------------------------------------------------------------------------
// Techniques
//------------------------------------------------------------------------------------------
technique dCoC
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader  = compile ps_2_0 PixelShaderFunction();
    }
}

// Fallback
technique fallback
{
    pass P0
    {
        // Just draw normally
    }
}
