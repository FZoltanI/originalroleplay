//
// skydome.fx v0.5
// Author: Ren712/AngerMAN
//

//---------------------------------------------------------------------
//-- Settings
//---------------------------------------------------------------------
bool gIsInWater = false;
float3 gRescale = float3(1,1,1);

float3 gTexScale = float3(1,1,1);

float gColorPow = 1;
float4 gColorMul = float4(1,1,1,1);
float gColorAlpha = 1;
bool gAngularTex = false;

float fFogEnable = false;
float fFogMul = 1;
float fFogPow = 1;

texture gSkyTexture;

//---------------------------------------------------------------------
//-- Include some common things
//---------------------------------------------------------------------
static const float PI = 3.141592653589793;
float4x4 gWorld : WORLD;
float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;
float3 gCameraPosition : CAMERAPOSITION;
matrix gProjectionMainScene : PROJECTION_MAIN_SCENE;
int gFogEnable < string renderState="FOGENABLE"; >;
float4 gFogColor < string renderState="FOGCOLOR"; >;
float gFogStart < string renderState="FOGSTART"; >;
float gFogEnd < string renderState="FOGEND"; >;
float gTime : TIME;

//---------------------------------------------------------------------
//-- Sampler for the main texture (needed for pixel shaders)
//---------------------------------------------------------------------
sampler texMap = sampler_state
{
	Texture = (gSkyTexture);
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = None;
    AddressU = Wrap;
    AddressV = Wrap;
};

//---------------------------------------------------------------------
//-- Structure of data sent to the vertex shader
//--------------------------------------------------------------------- 
struct VSInput
{
    float4 Position : POSITION; 
    float3 TexCoord : TEXCOORD0;
};

//---------------------------------------------------------------------
//-- Structure of data sent to the pixel shader ( from the vertex shader )
//---------------------------------------------------------------------
struct PSInput
{
    float4 Position : POSITION; 
    float3 TexCoord : TEXCOORD0;
    float4 PositionVS : TEXCOORD1;	
};
	
//-----------------------------------------------------------------------------
//-- VertexShader
//-----------------------------------------------------------------------------
PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;
    PS.PositionVS = VS.Position;
    float farClip = gProjectionMainScene[3][2] / (1 - gProjectionMainScene[2][2]);
    if ((gFogEnable) && (gIsInWater)) farClip = min(gFogStart, farClip );
    VS.Position.xyz *= 0.003 * max( 230, farClip ) * gRescale;
	
    PS.Position = mul( VS.Position, gWorldViewProjection );
    PS.TexCoord = VS.TexCoord.xyz;
    return PS;
}

//------------------------------------------------------------------------------------------
// AddObjectSpaceDepth
//------------------------------------------------------------------------------------------
float3 AddObjectSpaceDepth( float3 texel, float posZ )
{
    if ( !gFogEnable )
        return texel;

    float fogAmount = 1 - saturate( pow( abs( posZ ), fFogPow ) * fFogMul);
    if (posZ < 0) fogAmount = 1;
    texel.rgb = lerp( texel.rgb, gFogColor, saturate( fogAmount ));
    return texel;
}

//-----------------------------------------------------------------------------
//-- PixelShader
//-----------------------------------------------------------------------------
float4 PixelShaderFunction(PSInput PS) : COLOR0
{	
    float3 TexCoord = PS.TexCoord.xyz;
    float4 texel = tex2D( texMap, TexCoord.xy * gTexScale );
    texel.rgb = pow ( texel.rgb * gColorMul.rgb , gColorPow );
    float4 outPut = float4( texel.rgb, texel.a * gColorMul.a );
	
    if ( fFogEnable ) outPut.rgb = AddObjectSpaceDepth( outPut.rgb, PS.PositionVS.z );
    outPut.a *= gColorAlpha;
    return outPut;
}

//-----------------------------------------------------------------------------
//-- Techniques
//-----------------------------------------------------------------------------
technique Skydome
{	
	pass P0
    {
        FogEnable = false;
        AlphaRef = 1;
        AlphaBlendEnable = true;
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}