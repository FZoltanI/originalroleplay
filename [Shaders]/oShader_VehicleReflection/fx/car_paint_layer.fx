// RAYTRACING TECHNIQUE (update May 2018)
// car_paint_layer.fx
// author: Dutchman101, reflection technique written from scratch by Ren712 (custom order by Dutchman101) to take no (FPS) performance toll at all for players.
// Updated: 17/05/2018
//

//---------------------------------------------------------------------
// Settings
//---------------------------------------------------------------------
float2 uvMul = float2(1,1);
float2 uvMov = float2(0,0);
float sNorFac = 0.25;
float bumpSize = 1;
float envIntensity = 1;
float bumpIntensity = 0.25;

float sAdd = 0.1;
float sMul = 1.1;
float sCutoff = 0.16;
float sPower = 2;

texture sReflectionTexture;
texture sRandomTexture;

static const float pi = 3.141592653589793f;

//---------------------------------------------------------------------
// Include some common stuff
//---------------------------------------------------------------------
#define GENERATE_NORMALS      // Uncomment for normals to be generated
#include "mta-helper.fx"

//---------------------------------------------------------------------
// Sampler for the main texture
//---------------------------------------------------------------------

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

//---------------------------------------------------------------------
// Structure of data sent to the vertex shader
//---------------------------------------------------------------------
struct VSInput
{
  float3 Position : POSITION0;
  float3 Normal : NORMAL0;
  float4 Diffuse : COLOR0;
  float2 TexCoord : TEXCOORD0;
};

//---------------------------------------------------------------------
// Structure of data sent to the pixel shader ( from the vertex shader )
//---------------------------------------------------------------------
struct PSInput
{
  float4 Position : POSITION0;
  float2 Diffuse : COLOR0;
  float2 TexCoord : TEXCOORD0;
  float3 SparkleTex : TEXCOORD1;
  float3 Normal : TEXCOORD2;
  float4 WorldPos : TEXCOORD3;
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

    // Set information to do normal calculation
    PS.Normal = MTACalcWorldNormal(VS.Normal);
    PS.WorldPos.xyz = MTACalcWorldPosition(VS.Position).xyz;

    // Pass through tex coord
    PS.TexCoord = VS.TexCoord;

    // Calculate screen pos of vertex
    float4 worldPos = mul(float4(VS.Position.xyz,1) , gWorld );
    float4 viewPos = mul(worldPos , gView);
    PS.WorldPos.w = viewPos.z / viewPos.w;
    PS.Position = mul(viewPos, gProjection);

    // Calculate alpha
    PS.Diffuse.r = MTACalcGTABuildingDiffuse(VS.Diffuse).a;
    PS.Diffuse.g = pow(mul(VS.Normal, (float3x3)gWorld ).z ,2.5);

    float3 h = normalize(normalize(gCameraPosition - worldPos.xyz ) - normalize(gCameraDirection));
    PS.Diffuse.g *= 1 - saturate(pow(saturate(dot(PS.Normal,h)), 2));
    PS.Diffuse.g *= saturate(1 + gCameraDirection.z);
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

    // Combine
    float4 finalColor = float4(envMap.rgb, PS.Diffuse.g * envIntensity);
    finalColor.a *= PS.Diffuse.r;
    return saturate(finalColor);
}


//------------------------------------------------------------------------------------------
// Techniques
//------------------------------------------------------------------------------------------
technique car_paint_reflite_layered
{
    pass P0
    {
        DepthBias = -0.0002;
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