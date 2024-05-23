//
// Shader pedSobel v1.15
// By Ren712
//

float2 sEffIntens = float2(0.61,1);
float2 sFreshlInten = float2(1.2,1);

float3 sLightDir = float3(0.507,-0.507,-0.2);
float sSpecularPower = 4;
float sSpecularBrightness = 1;
float sVisibility = 1;

float3 sSunColor = float3(0,0,0);
bool isSobel = false;

#define GENERATE_NORMALS   
#include "mta-helper.fx"

sampler2D ColorSampler = sampler_state
{
    Texture = <gTexture0>;
    MinFilter = linear;
    MagFilter = linear;
    MipFilter = linear;
};

struct VertexShaderInput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
    float4 Diffuse : COLOR0;
    float3 Normal : NORMAL0;
    float3 Binormal : BINORMAL0;
    float3 Tangent : TANGENT0;
};

struct VertexShaderOutput
{
    float4 Position : POSITION0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
    float4 Fresnel : COLOR1;
    float3 Normal : TEXCOORD1;
    float3 Binormal : TEXCOORD2;
    float3 Tangent : TEXCOORD3;
    float3 CamInWorld : TEXCOORD4;
    float3 WorldPos : TEXCOORD5; 
    float SpecLighting : TEXCOORD6;
};

VertexShaderOutput VertexShaderFunction(VertexShaderInput VS)
{
    VertexShaderOutput PS;
    MTAFixUpNormal( VS.Normal );
    float4 worldPosition = mul(VS.Position, gWorld);
    float4 viewPosition = mul(worldPosition, gView);
    PS.Position = mul(viewPosition, gProjection);
    PS.TexCoord = VS.TexCoord;
	
    // Fake tangent and binormal
    float3 Tangent = VS.Normal.yxz;
    Tangent.xz = VS.TexCoord.xy;
    float3 Binormal = normalize( cross(Tangent, VS.Normal) );
    Tangent = normalize( cross(Binormal, VS.Normal) );
	
    PS.Tangent = mul(Tangent, gWorldInverseTranspose);
    PS.Binormal = mul(-Binormal, gWorldInverseTranspose);
    PS.Normal = mul(VS.Normal, gWorldInverseTranspose);
    
    PS.CamInWorld = normalize(gCameraPosition - worldPosition.xyz);
    PS.WorldPos = worldPosition.xyz;
    float3 View = normalize( PS.CamInWorld - normalize(gCameraDirection));
    PS.Diffuse = MTACalcGTABuildingDiffuse( VS.Diffuse );	
    PS.Fresnel = (1-saturate(pow(saturate(dot(PS.Normal,View )),sFreshlInten.y)))*PS.Diffuse*sFreshlInten.x;
    float3 ligDir = dot(sLightDir,-PS.Normal);
    PS.SpecLighting = pow(max(ligDir,0.0), sSpecularPower ); 
    return PS;
}

float TextureSize=512.0;

float3 ComputeNormalsPS(float2 texCoord,float4 lightness)
{
   float off = 1.0 / TextureSize;

   // Take all neighbor samples
   float4 s00 = tex2D(ColorSampler, texCoord + float2(-off, -off));
   float4 s01 = tex2D(ColorSampler, texCoord + float2( 0,   -off));
   float4 s02 = tex2D(ColorSampler, texCoord + float2( off, -off));

   float4 s10 = tex2D(ColorSampler, texCoord + float2(-off,  0));
   float4 s12 = tex2D(ColorSampler, texCoord + float2( off,  0));

   float4 s20 = tex2D(ColorSampler, texCoord + float2(-off,  off));
   float4 s21 = tex2D(ColorSampler, texCoord + float2( 0,    off));
   float4 s22 = tex2D(ColorSampler, texCoord + float2( off,  off));

   // Slope in X direction
   float4 sobelX = s00 + 2 * s10 + s20 - s02 - 2 * s12 - s22;
   // Slope in Y direction
   float4 sobelY = s00 + 2 * s01 + s02 - s20 - 2 * s21 - s22;

   // Weight the slope in all channels, we use grayscale as height
   float sx = dot(sobelX, lightness);
   float sy = dot(sobelY, lightness);

   // Compose the normal
   float3 normal = normalize(float3(sx, sy, 1));

   // Pack [-1, 1] into [0, 1]
   return float3(normal * 0.5 + 0.5);
}

int gFogEnable                     < string renderState="FOGENABLE"; >;
float4 gFogColor                   < string renderState="FOGCOLOR"; >;
float gFogStart                    < string renderState="FOGSTART"; >;
float gFogEnd                      < string renderState="FOGEND"; >;
 
float3 MTAApplyFog( float3 texel, float3 worldPos )
{
    if ( !gFogEnable )
        return texel;
 
    float DistanceFromCamera = distance( gCameraPosition, worldPos );
    float FogAmount = ( DistanceFromCamera - gFogStart )/( gFogEnd - gFogStart );
    texel.rgb = lerp(texel.rgb, gFogColor, saturate( FogAmount ) );
    return texel;
}

float4 PixelShaderFunctionSM3(VertexShaderOutput PS) : COLOR0
{
    float4 color = tex2D(ColorSampler, PS.TexCoord);
	float4 normal = 1;
	if (isSobel)  { normal = float4(ComputeNormalsPS(PS.TexCoord.xy,color),1); 
        normal.xy = normal.xy * 2.0 - 1.0;
        } else { normal = 1;}
        normal.w = normal.w * sEffIntens.y + 1.0;
    float3 normalMap = normalize(PS.Normal);
    if (isSobel) { normalMap += (normal.x * normalize(PS.Tangent) + normal.y * normalize(PS.Binormal) )* sqrt(1.0 - dot(normal.xy, normal.xy)); }
    float dotDir=0;	
    float3 diffuse = PS.Diffuse.xyz;
    float3 specular = 0.0;
	
    if (gLight1Enable) {
    dotDir = dot(gLight1Direction, -normalMap);
    diffuse += pow(dotDir * 0.5 + 0.5,1.5) * gLight1Diffuse;
    specular += pow(max(dotDir, 0.0), normal.w) * gLight1Diffuse;
                       }
    if (gLight2Enable) {
    dotDir = dot(gLight2Direction, -normalMap);
    diffuse += pow(dotDir * 0.5 + 0.5,1.5) * gLight2Diffuse;
    specular += pow(max(dotDir, 0.0), normal.w) * gLight2Diffuse;	
                       }
    if (gLight3Enable) {
    dotDir = dot(gLight3Direction, -normalMap);
    diffuse += pow(dotDir * 0.5 + 0.5,1.5) * gLight3Diffuse;
    specular += pow(max(dotDir, 0.0), normal.w) * gLight3Diffuse;	
                       }
    if (gLight4Enable) {
    dotDir = dot(gLight4Direction, -normalMap);
    diffuse += pow(dotDir * 0.5 + 0.5,1.5) * gLight4Diffuse;
    specular += pow(max(dotDir, 0.0), normal.w) * gLight4Diffuse;	
                       }
    diffuse = saturate(diffuse); specular = saturate(specular);	
	
    float3 ligDir = dot(sLightDir,-normalMap);
    float specSun = pow(max(ligDir,0.0), sSpecularPower ); 
    float3 sunLight = specSun * sSpecularBrightness * sVisibility * sSunColor.rgb; 
    float4 outPut = PS.Diffuse * color + PS.Fresnel * color + color * float4(sunLight + diffuse * specular * normal.z * sEffIntens.x,1);
    outPut.rgb = MTAApplyFog( outPut.rgb, PS.WorldPos);
    return outPut;
}

float4 PixelShaderFunctionSM2(VertexShaderOutput PS) : COLOR0
{
    float4 color = tex2D(ColorSampler, PS.TexCoord);
    float specPow = sEffIntens.y + 1 ;
    float dotDir=0;	
    float3 diffuse = PS.Diffuse.xyz * 0.8;
    float3 specular = 0.0;
    float3 normalMap = normalize(PS.Normal);
	
    if (gLight1Enable) {
    dotDir = dot(gLight1Direction, -normalMap);
    diffuse += (dotDir * 0.5 + 0.5) * gLight1Diffuse;
    specular += pow(max(dotDir, 0.0), specPow) * gLight1Diffuse;
                       }
    if (gLight2Enable) {
    dotDir = dot(gLight2Direction, -normalMap);
    diffuse += (dotDir * 0.5 + 0.5) * gLight2Diffuse;
    specular += pow(max(dotDir, 0.0), specPow) * gLight2Diffuse;	
                       }
    if (gLight3Enable) {
    dotDir = dot(gLight3Direction, -normalMap);
    diffuse += (dotDir * 0.5 + 0.5) * gLight3Diffuse;
    specular += pow(max(dotDir, 0.0), specPow) * gLight3Diffuse;	
                       }
    if (gLight4Enable) {
    dotDir = dot(gLight4Direction, -normalMap);
    diffuse += (dotDir * 0.5 + 0.5) * gLight4Diffuse;
    specular += pow(max(dotDir, 0.0), specPow) * gLight4Diffuse;	
                       }
    diffuse = saturate(diffuse); specular = saturate(specular);	
	
    float3 ligDir = dot(sLightDir,-normalMap);
    float specSun = pow(max(ligDir,0.0), sSpecularPower ); 	
    float3 sunLight = PS.SpecLighting * sSpecularBrightness * sVisibility * sSunColor.rgb; 
    return PS.Diffuse * color + PS.Fresnel * color + color * float4(sunLight + diffuse * specular * sEffIntens.x,1);
}

technique TechniqueSobel_SM3
{
    pass Pass0
    {
        AlphaRef = 1;
        AlphaBlendEnable = TRUE;
        VertexShader = compile vs_3_0 VertexShaderFunction();
        PixelShader = compile ps_3_0 PixelShaderFunctionSM3();
    }
}

technique TechniqueSpecular_SM2
{
    pass Pass0
    {
        AlphaRef = 1;
        AlphaBlendEnable = TRUE;
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader = compile ps_2_0 PixelShaderFunctionSM2();
    }
}