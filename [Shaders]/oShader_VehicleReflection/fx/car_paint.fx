// RAYTRACING TECHNIQUE (update May 2018)
// car_paint.fx
// author: Dutchman101, reflection technique written from scratch by Ren712 (custom order by Dutchman101) to take no (FPS) performance toll at all for players.
// Updated: 17/05/2018
//

//---------------------------------------------------------------------
// Settings
//---------------------------------------------------------------------
float2 uvMul = float2(1,1);
float2 uvMov = float2(0,0);
float sNorFac = 1;
float bumpSize = 1;
float envIntensity = 1;
float bumpIntensity = 0.25;

float specularValue = 1;
float refTexValue = 0.2;

float sAdd = 0.1;
float sMul = 1.1;
float sPower = 2;
float sCutoff = 0.16;

texture sReflectionTexture;
texture sRandomTexture;

static const float pi = 3.141592653589793f;
texture gDepthBuffer : DEPTHBUFFER;

//---------------------------------------------------------------------
// Include some common stuff
//---------------------------------------------------------------------
#define GENERATE_NORMALS      // Uncomment for normals to be generated
#include "mta-helper.fx"

//---------------------------------------------------------------------
// Sampler for the main texture
//---------------------------------------------------------------------
sampler Sampler0 = sampler_state
{
    Texture = (gTexture0);
};

sampler Sampler1 = sampler_state
{
    Texture = (gTexture1);
    AddressU = Wrap;
    AddressV = Wrap;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
};

sampler3D RandomSampler = sampler_state
{
    Texture = (sRandomTexture);
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = POINT;
    MIPMAPLODBIAS = 0.000000;
};

sampler2D ReflectionSampler = sampler_state
{
    Texture = (sReflectionTexture);
    AddressU = Mirror;
    AddressV = Mirror;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
};

sampler SamplerDepth = sampler_state
{
    Texture = (gDepthBuffer);
    MinFilter = Point;
    MagFilter = Point;
    MipFilter = None;
    AddressU = Clamp;
    AddressV = Clamp;
};

//---------------------------------------------------------------------
// Structure of data sent to the vertex shader
//---------------------------------------------------------------------
struct VSInput
{
  float3 Position : POSITION0;
  float3 Normal : NORMAL0;
  float4 Diffuse : COLOR0;
  float2 TexCoord : TEXCOORD0;
  float2 TexCoord1 : TEXCOORD1;
};

//---------------------------------------------------------------------
// Structure of data sent to the pixel shader ( from the vertex shader )
//---------------------------------------------------------------------
struct PSInput
{
  float4 Position : POSITION0;
  float4 Diffuse : COLOR0;
  float4 Specular : COLOR1;
  float2 TexCoord : TEXCOORD0;
  float3 Normal : TEXCOORD1;
  float4 WorldPos : TEXCOORD2;
  float3 SparkleTex : TEXCOORD3;
  float2 TexCoord1 : TEXCOORD4;
};

//------------------------------------------------------------------------------------------
// VertexShaderFunction
//  1. Read from VS structure
//  2. Process
//  3. Write to PS structure
//------------------------------------------------------------------------------------------
PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

    // Make sure normal is valid
    MTAFixUpNormal( VS.Normal );

    PS.SparkleTex.x = fmod( VS.Position.x, 10 ) * 16 * bumpSize;
    PS.SparkleTex.y = fmod( VS.Position.y, 10 ) * 16 * bumpSize;
    PS.SparkleTex.z = fmod( VS.Position.z, 10 ) * 16 * bumpSize;

    // Set information to do specular calculation
    PS.Normal = mul(VS.Normal, (float3x3)gWorld);
    PS.WorldPos.xyz = mul( float4(VS.Position.xyz,1) , gWorld ).xyz;

    // Pass through tex coord
    PS.TexCoord = VS.TexCoord;

    float3 posInWorld = gWorld[3].xyz * 0.02;
    posInWorld.x = ( posInWorld.x  - int(posInWorld.x )) * -gWorld[1].x;
    posInWorld.y = ( posInWorld.y  - int(posInWorld.y )) * -gWorld[1].y;

    float anim = posInWorld.x + posInWorld.y;
    PS.TexCoord1 = VS.TexCoord1 + float2( anim, 0 );

    // Calculate screen pos of vertex
    float4 worldPos = mul( float4(VS.Position.xyz,1) , gWorld );
    float4 viewPos = mul( worldPos , gView );
    PS.WorldPos.w = viewPos.z / viewPos.w;
    PS.Position = mul( viewPos, gProjection);

    // Calculate GTA lighting for Vehicles
    PS.Diffuse = MTACalcGTACompleteDiffuse( PS.Normal, VS.Diffuse );
    PS.Specular.rgb = gMaterialSpecular.rgb * MTACalculateSpecular( gCameraDirection, gLight1Direction, PS.Normal, gMaterialSpecPower ) * specularValue;

    PS.Specular.a = pow( mul( VS.Normal, (float3x3)gWorld ).z ,2.5 );
    float3 h = normalize(normalize(gCameraPosition - worldPos.xyz) - normalize(gCameraDirection));
    PS.Specular.a *=  1 - saturate(pow(saturate(dot(PS.Normal,h)), 2));
    PS.Specular.a *=  saturate(1 + gCameraDirection.z);
    return PS;
}

//------------------------------------------------------------------------------------------
// GetUV from WorldPos
//------------------------------------------------------------------------------------------
float3 GetUV(float3 position, float4x4 ViewProjection)
{
    float4 pVP = mul(float4(position, 1.0f), ViewProjection);
    pVP.xy = float2(0.5f, 0.5f) + float2(0.5f, -0.5f) * ((pVP.xy / pVP.w) * uvMul) + uvMov;
    return float3(pVP.xy, pVP.z / pVP.w);
}

//------------------------------------------------------------------------------------------
// PixelShaderFunction
//  1. Read from PS structure
//  2. Process
//  3. Return pixel color
//------------------------------------------------------------------------------------------
float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    // Get texture pixel
    float4 texel = tex2D(Sampler0, PS.TexCoord);
    float4 refTex = tex2D(Sampler1, PS.TexCoord1);

    float3 vFlakesNormal = tex3D(RandomSampler, PS.SparkleTex).rgb;
    vFlakesNormal = 2 * vFlakesNormal - 1.0;

    // get to pixel view direction
    float3 viewDir = normalize(PS.WorldPos.xyz - gCameraPosition);

    // lerp between scene and material world normal
    vFlakesNormal = bumpIntensity * vFlakesNormal;
    float3 worldNormal = normalize(refract(PS.Normal, vFlakesNormal, 1));

    // reflection direction
    float3 reflectDir = normalize(reflect(viewDir, worldNormal));
    // cast rays
    float3 currentRay = PS.WorldPos.xyz + reflectDir * sNorFac;
    float farClip = gProjection[3][2] / (1 - gProjection[2][2]);

    currentRay += 2 * gWorld[2].xyz * (1.0 + (PS.WorldPos.w / farClip));
    float3 nuv = GetUV(currentRay , gViewProjection);

    // Sample environment map using this reflection vector:
    float4 envMap = tex2D( ReflectionSampler, nuv.xy );

    // basic filter for vehicle effect reflection
    float lum = (envMap.r + envMap.g + envMap.b)/3;
    float adj = saturate( lum - sCutoff );
    adj = adj / (1.01 - sCutoff);
    envMap += sAdd;
    envMap = (envMap * adj);
    envMap = pow(envMap, sPower);
    envMap *= sMul;
    envMap.rgb = saturate( envMap.rgb );

    // Apply diffuse lighting
    float4 finalColor = texel * PS.Diffuse;

    // Apply specular
    finalColor.rgb += PS.Specular.rgb;
    finalColor.rgb += saturate( envMap.rgb * envIntensity) * PS.Specular.a;
    finalColor.rgb += saturate( refTex.rgb * gMaterialSpecular.rgb * refTexValue );

    return saturate(finalColor);
}


//------------------------------------------------------------------------------------------
// Techniques
//------------------------------------------------------------------------------------------
technique car_paint_reflite
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader = compile ps_2_0 PixelShaderFunction();
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