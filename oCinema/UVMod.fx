//
// shader_UVMod.fx
//


//------------------------------------------------------------------------------------------
//-- Global variables
//------------------------------------------------------------------------------------------
texture gCustomTex0 : CUSTOMTEX0;

float2 gUVPrePosition = float2( 0, 0 );
float2 gUVScale = float2( 1, 1 );                     // UV scale
float2 gUVScaleCenter = float2( 0.5, 0.5 );
float gUVRotAngle = float( 0 );                   // UV Rotation
float2 gUVRotCenter = float2( 0.5, 0.5 );
float2 gUVPosition = float2( 0, 0 );             // UV position
float2 gUVAnim = float2(0, 0);
float4 gColorMulti = float4( 1, 1, 1, 1);        // Multiply texture color
bool gVertexColor = false;

//------------------------------------------------------------------------------------------
//-- Common parameters set by MTA
//------------------------------------------------------------------------------------------
float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;
float gTime : TIME;

//------------------------------------------------------------------------------------------
//-- Common states for the building diffuse
//------------------------------------------------------------------------------------------
int gLighting                      < string renderState="LIGHTING"; >;                        //  = 137,
float4 gGlobalAmbient              < string renderState="AMBIENT"; >;                    //  = 139,
int gDiffuseMaterialSource         < string renderState="DIFFUSEMATERIALSOURCE"; >;           //  = 145,
int gAmbientMaterialSource         < string renderState="AMBIENTMATERIALSOURCE"; >;           //  = 147,
int gEmissiveMaterialSource        < string renderState="EMISSIVEMATERIALSOURCE"; >;          //  = 148,
float4 gMaterialAmbient     < string materialState="Ambient"; >;
float4 gMaterialDiffuse     < string materialState="Diffuse"; >;
float4 gMaterialEmissive    < string materialState="Emissive"; >;

//------------------------------------------------------------------------------------------
//-- Include matrix transformations
//------------------------------------------------------------------------------------------
#include "tex_matrix.fx"
 
//------------------------------------------------------------------------------------------
//-- Sampler for the new texture
//------------------------------------------------------------------------------------------
sampler Sampler0 = sampler_state
{
    Texture = (gCustomTex0);
};
 
 
//------------------------------------------------------------------------------------------
//-- Structure of data sent to the vertex shader
//------------------------------------------------------------------------------------------
struct VSInput
{
    float3 Position : POSITION0;
    float3 Normal : NORMAL0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
};
 
//------------------------------------------------------------------------------------------
//-- Structure of data sent to the pixel shader ( from the vertex shader )
//------------------------------------------------------------------------------------------
struct PSInput
{
    float4 Position : POSITION0;
    float4 Diffuse : COLOR0;
    float3 TexCoord : TEXCOORD0;
};

//------------------------------------------------------------------------------------------
//-- Returns UV transform using external settings
//------------------------------------------------------------------------------------------
float3x3 getTextureTransform()
{
    return makeTextureTransform( gUVPrePosition, gUVScale, gUVScaleCenter, gUVRotAngle, gUVRotCenter, gUVPosition, gUVAnim );
}

//------------------------------------------------------------------------------------------
// MTACalcGTABuildingDiffuse
// - Calculate GTA lighting for buildings
//------------------------------------------------------------------------------------------
float4 MTACalcGTABuildingDiffuse( float4 InDiffuse )
{
    float4 OutDiffuse;

    if ( !gLighting )
    {
        // If lighting render state is off, pass through the vertex color
        OutDiffuse = InDiffuse;
    }
    else
    {
        // If lighting render state is on, calculate diffuse color by doing what D3D usually does
        float4 ambient  = gAmbientMaterialSource  == 0 ? gMaterialAmbient  : InDiffuse;
        float4 diffuse  = gDiffuseMaterialSource  == 0 ? gMaterialDiffuse  : InDiffuse;
        float4 emissive = gEmissiveMaterialSource == 0 ? gMaterialEmissive : InDiffuse;
        OutDiffuse = gGlobalAmbient * saturate( ambient + emissive );
        OutDiffuse.a *= diffuse.a;
    }
    return OutDiffuse;
}

//--------------------------------------------------------------------------------------------
//-- VertexShaderFunction
//--  1. Read from VS structure
//--  2. Process
//--  3. Write to PS structure
//--------------------------------------------------------------------------------------------
PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;
 
    //-- Calculate screen pos of vertex
    PS.Position = mul(float4(VS.Position, 1), gWorldViewProjection);
 
    //-- Pass through tex coord and multiply with the transformation matrix
    float3 TexCoord = float3(VS.TexCoord.xy, 1);
    PS.TexCoord = mul( TexCoord, getTextureTransform ());
 
    //-- Calculate GTA lighting for buildings
    PS.Diffuse = MTACalcGTABuildingDiffuse( VS.Diffuse );

    return PS;
}

//--------------------------------------------------------------------------------------------
//-- PixelShaderFunction
//--  1. Read from PS structure
//--  2. Process
//--  3. Return pixel color
//--------------------------------------------------------------------------------------------
float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    //-- Get texture pixel
    float4 finalColor = tex2D( Sampler0, PS.TexCoord.xy );
	
    //-- Apply diffuse lighting	
    if (gVertexColor) finalColor.rgb *= PS.Diffuse.rgb;	
    finalColor.a *= PS.Diffuse.a;

    //-- Apply color alterations	
    finalColor *= gColorMulti;
		
    return saturate( finalColor );
}
 
 
//--------------------------------------------------------------------------------------------
//-- Techniques
//--------------------------------------------------------------------------------------------
technique tec
{
    pass P0
    {
        AlphaBlendEnable = TRUE;
        AlphaRef = 1;
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}

technique Falloff
{
    pass P0
    {
    }
}