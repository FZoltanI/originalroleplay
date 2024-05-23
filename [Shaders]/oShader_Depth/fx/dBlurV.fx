//
// dBlurV.fx
//

//------------------------------------------------------------------------------------------
// blurV settings
//------------------------------------------------------------------------------------------
texture sTex0 : TEX0;
texture sTex1 : TEX1;
float2 sTex0Size : TEX0SIZE;
float gblurFactor = 0.5;
float gBrightBlurAdd = 0.3;
bool gBrightBlur = true;
//------------------------------------------------------------------------------------------
// Include some common stuff
//------------------------------------------------------------------------------------------
float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;

//------------------------------------------------------------------------------------------
// Static data
//------------------------------------------------------------------------------------------
static const float Kernel[7] = {-3,     -2,     -1,     0,      1,      2,      3};

//------------------------------------------------------------------------------------------
// Samplers
//------------------------------------------------------------------------------------------
sampler2D Sampler0 = sampler_state
{
    Texture         = (sTex0);
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
    AddressU        = Mirror;
    AddressV        = Mirror;
};

sampler2D Sampler1 = sampler_state
{
    Texture         = (sTex1);
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
    AddressU        = Mirror;
    AddressV        = Mirror;
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
// VertexShaderFunction
//------------------------------------------------------------------------------------------
PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

    // Calculate screen pos of vertex
    PS.Position = mul( float4(VS.Position,1),gWorldViewProjection );

    // Pass through color and tex coord
    PS.Diffuse = VS.Diffuse;
    PS.TexCoord = VS.TexCoord;

    return PS;
}

//------------------------------------------------------------------------------------------
// PixelShaderFunction
//------------------------------------------------------------------------------------------
float4 PixelShaderFunctionSM3(PSInput PS) : COLOR0
{
    float4 Color = 0;
    float4 Texel = tex2D(Sampler0, PS.TexCoord);
    float3 origCoC = tex2D(Sampler1, PS.TexCoord).xyz;
	
    float Bright = 1;
    if (gBrightBlur) Bright = saturate(Texel.r + Texel.g + Texel.b + gBrightBlurAdd);
    float2 coord;
    coord.x = PS.TexCoord.x;

    for(int i = 0; i < 7; ++i)
    {
        float sampleoffset = (origCoC.r * Bright * gblurFactor * Kernel[i])/sTex0Size.y;
        float3 sampleCoC = tex2D(Sampler1, PS.TexCoord.xy + float2(0,sampleoffset)).xyz;
        if(origCoC.y>origCoC.z && sampleCoC.x<origCoC.x) sampleoffset = sampleoffset/origCoC.x*sampleCoC.x;
        coord.y = PS.TexCoord.y + sampleoffset;
        Color.rgb += tex2D(Sampler0, coord.xy).rgb;
    }
    Color.rgb /= 7;
    Color.a = 1;	
    return Color * PS.Diffuse;
}

float4 PixelShaderFunctionSM2(PSInput PS) : COLOR0
{
    float4 Color = 0;
    float4 Texel = tex2D(Sampler0, PS.TexCoord);
    float3 origCoC = tex2D(Sampler1, PS.TexCoord).xyz;
	
    float Bright = 1;
    if (gBrightBlur) Bright = saturate(Texel.r + Texel.g + Texel.b + gBrightBlurAdd);
    float2 coord;
    coord.x = PS.TexCoord.x;

    for(int i = 0; i < 7; ++i)
    {
        float sampleoffset = (origCoC.r * Bright * gblurFactor * Kernel[i])/sTex0Size.y;
        coord.y = PS.TexCoord.y + sampleoffset;
        Color.rgb += tex2D(Sampler0, coord.xy).rgb;
    }
    Color.rgb /= 7;
    Color.a = 1;	
    return Color * PS.Diffuse;
}
//------------------------------------------------------------------------------------------
// Techniques
//------------------------------------------------------------------------------------------
technique blurv_sm3
{
    pass P0
    {
        VertexShader = compile vs_3_0 VertexShaderFunction();
        PixelShader  = compile ps_3_0 PixelShaderFunctionSM3();
    }
}

technique blurv_sm2
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader  = compile ps_2_0 PixelShaderFunctionSM2();
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
