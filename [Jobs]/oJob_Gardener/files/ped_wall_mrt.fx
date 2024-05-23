//
// ped_wall_mrt.fx
//

//------------------------------------------------------------------------------------------
// Variables
//------------------------------------------------------------------------------------------
float4 sColorizePed = float4(1,1,1,1);
float sSpecularPower = 2;

//------------------------------------------------------------------------------------------
// Include some common stuff
//------------------------------------------------------------------------------------------
texture gTexture0 < string textureState="0,Texture"; >;
float4x4 gWorld : WORLD;
float4x4 gView : VIEW;
float4x4 gWorldView : WORLDVIEW;
float4x4 gProjection: PROJECTION;
float3 gCameraDirection : CAMERADIRECTION;
float3 gCameraPosition : CAMERAPOSITION;
int CUSTOMFLAGS <string createNormals = "yes"; string skipUnusedParameters = "yes"; >;
texture secondRT < string renderTarget = "yes"; >;

//------------------------------------------------------------------------------------------
// Sampler Inputs
//------------------------------------------------------------------------------------------
sampler ColorSampler = sampler_state
{
    Texture = (gTexture0);
};

//------------------------------------------------------------------------------------------
// Structure of data sent to the vertex shader
//------------------------------------------------------------------------------------------
struct VSInput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
};

//------------------------------------------------------------------------------------------
// Structure of data sent to the pixel shader ( from the vertex shader )
//------------------------------------------------------------------------------------------
struct PSInput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
};

//------------------------------------------------------------------------------------------
// VertexShaderFunction
//------------------------------------------------------------------------------------------
PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;
    float4 worldPosition = mul(float4(VS.Position.xyz, 1.0),gWorld);
    float4 worldViewPosition = mul(worldPosition,gView);
    PS.Position = mul(worldViewPosition,gProjection);
	
    // Pass through tex coords
    PS.TexCoord = VS.TexCoord;
	
    return PS;
}

//------------------------------------------------------------------------------------------
// Structure of color data sent to the renderer ( from the pixel shader  )
//------------------------------------------------------------------------------------------
struct Pixel
{
    float4 Color : COLOR0;      // Render target #0
    float4 Extra : COLOR1;      // Render target #1
};

//------------------------------------------------------------------------------------------
// PixelShaderFunction
//------------------------------------------------------------------------------------------
Pixel PixelShaderFunction(PSInput PS)
{
    Pixel output;
	
    output.Color = float4(0, 0, 0, 0.02);
    output.Extra = sColorizePed;
	
    return output;
}

//------------------------------------------------------------------------------------------
// Techniques
//------------------------------------------------------------------------------------------
technique ped_wall
{
    pass P0
    {
		ZEnable = false;
        AlphaBlendEnable = true;
        AlphaRef = 1;
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
