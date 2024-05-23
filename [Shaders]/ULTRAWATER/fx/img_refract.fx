//
// file: img_refract.fx
// author: Ren712
//

//---------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------
float3 sElementPosition = float3(0,0,0);
float3 sElementRotation = float3(0,0,0);
float2 sScrSize = float2(800,600);
float3 sCameraPosition = float3(0,0,0);
float3 sCameraDirection = float3(0,0,0);
float sCameraRoll = 0;
float2 sElementSize = float2(1,1);
float2 sElementLow = float2(1,1);

float sFov = 0;
int fFogEnable = 0;
float gAlpha = 1;
float2 gNormalStrength = float2(0.05,0.05);

bool bIsDetailed = true; 

//---------------------------------------------------------------------
// Include some common stuff
//---------------------------------------------------------------------
float4x4 gWorld : WORLD;
float4x4 gView : VIEW;
float4x4 gProjection : PROJECTION;
float4x4 gViewProjection : VIEWPROJECTION;
float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;
float4x4 gViewInverse : VIEWINVERSE;
float3 gCameraDirection : CAMERADIRECTION;
texture gDepthBuffer : DEPTHBUFFER;
texture gTexture0 < string textureState="0,Texture"; >;
matrix gProjectionMainScene : PROJECTION_MAIN_SCENE;
float3 gCameraPosition : CAMERAPOSITION;
float3 gCameraRotation : CAMERAROTATION;
int CUSTOMFLAGS <string skipUnusedParameters = "yes"; >;
int gFogEnable < string renderState="FOGENABLE"; >;
float4 gFogColor < string renderState="FOGCOLOR"; >;
float gFogStart < string renderState="FOGSTART"; >;
float gFogEnd < string renderState="FOGEND"; >;
float gTime : TIME;

//--------------------------------------------------------------------------------------
// Textures
//--------------------------------------------------------------------------------------
texture sProjectiveTexture;
texture sRandomTexture;

//--------------------------------------------------------------------------------------
// Sampler Inputs
//--------------------------------------------------------------------------------------
sampler2D ProjectiveSampler = sampler_state
{
    Texture = (sProjectiveTexture);
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Mirror;
    AddressV = Mirror;
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

sampler2D RandomSampler = sampler_state
{
    Texture = (sRandomTexture);
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
};

//--------------------------------------------------------------------------------------
// Structures
//--------------------------------------------------------------------------------------
struct VSInput
{
    float3 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
};

struct PSInput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
    float DistFromCam : TEXCOORD1;
    float3 TexCoordP : TEXCOORD2;
    float4 SparkleTex : TEXCOORD3; 
    float3 WorldPos : TEXCOORD4;	
};

//-----------------------------------------------------------------------------
// Get value from the depth buffer
// Uses define set at compile time to handle RAWZ special case (which will use up a few more slots)
//-----------------------------------------------------------------------------
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
 
//-----------------------------------------------------------------------------
// Use the last scene projecion matrix to linearize the depth value a bit more
//-----------------------------------------------------------------------------
float Linearize(float posZ)
{
    return gProjectionMainScene[3][2] / (posZ - gProjectionMainScene[2][2]);
}

//-----------------------------------------------------------------------------
// Create world matrix with world position and a single direction vector
//-----------------------------------------------------------------------------
float4x4 createWorldMatrix( float3 pos, float3 dir )
{
    float3 zaxis = normalize( dir );    // The "forward" vector.
    float3 xaxis = normalize( cross( float3(0, 0, -1.0f ), zaxis ));// The "right" vector.
    float3 yaxis = cross( xaxis, zaxis );     // The "up" vector.

    // Create a 4x4 world matrix from the right, up, forward and eye position vectors
    float4x4 worldMatrix = {
        float4(      xaxis.x,            xaxis.y,            xaxis.z,       0 ),
        float4(      yaxis.x,            yaxis.y,            yaxis.z,       0 ),
        float4(      zaxis.x,            zaxis.y,            zaxis.z,       0 ),
        float4(	     pos.x,              pos.y,              pos.z,         1 )
    };
    
    return worldMatrix;
}

//-----------------------------------------------------------------------------
// Create view matrix 
//----------------------------------------------------------------------------- 
float4x4 createViewMatrix( float3 pos, float3 dir )
{
    float3 zaxis = normalize( dir );    // The "forward" vector.
    float3 xaxis = normalize( cross( float3(0, 0, -1.0f ), zaxis ));// The "right" vector.
    float3 yaxis = cross( xaxis, zaxis );     // The "up" vector.

    // Create a 4x4 view matrix from the right, up, forward and eye position vectors
    float4x4 viewMatrix = {
        float4(      xaxis.x,            yaxis.x,            zaxis.x,       0 ),
        float4(      xaxis.y,            yaxis.y,            zaxis.y,       0 ),
        float4(      xaxis.z,            yaxis.z,            zaxis.z,       0 ),
        float4(-dot( xaxis, pos ), -dot( yaxis, pos ), -dot( zaxis, pos ),  1 )
    };
    
    return viewMatrix;
}

//-------------------------------------------
// Returns a rotation matrix (rotate by Z)
//-------------------------------------------
float4x4 makeZRotation( float angleInRadians) 
{
  float c = cos(angleInRadians);
  float s = sin(angleInRadians);
  
  return float4x4(
     c, s, 0, 0,
    -s, c, 0, 0,
     0, 0, 1, 0,
     0, 0, 0, 1
  );
}


//-----------------------------------------------------------------------------
// Create projection matrix 
//----------------------------------------------------------------------------- 
float4x4 createProjectionMatrix(float near_plane, float far_plane, float fov_horiz, float fov_vert)
{
    float h, w, Q;

    w = 1/tan(fov_horiz * 0.5);
    h = 1/tan(fov_vert * 0.5);
    Q = far_plane/(far_plane - near_plane);

    // Create a 4x4 projection matrix from given input

    float4x4 projectionMatrix = {
        float4(      w,            0,        0,            0 ),
        float4(      0,            h,        0,            0 ),
        float4(      0,            0,        Q,             1),
        float4(      0,            0,        -Q*near_plane,0 )
    };    
    return projectionMatrix;
} 

//-----------------------------------------------------------------------------
// Vertex Shader 
//----------------------------------------------------------------------------- 
PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;
	
    float2 elementSize = sElementSize;
    if (!bIsDetailed) elementSize = sElementLow;

    VS.Position.xy /= float2(sScrSize.x, sScrSize.y);
    VS.Position.xy =  0.5 - VS.Position.xy;
    VS.Position.xy = VS.Position.yx;
    VS.Position.xy *= elementSize.xy;
    float3 elementRotation = sElementRotation + float3(0.0000001f, 0, 0);
    float4x4 sWorld = createWorldMatrix(sElementPosition, elementRotation);
    float4 wPos = mul(float4(VS.Position, 1 ), sWorld);
    PS.WorldPos = wPos.xyz;

    float4x4 sView = createViewMatrix(sCameraPosition, sCameraDirection);
    sView = mul(sView, makeZRotation(sCameraRoll));
    float4 vPos = mul( wPos, sView );
    PS.DistFromCam = vPos.z / vPos.w;	
	
    float sAspect = (sScrSize.y / sScrSize.x);
    float sFarClip = gProjectionMainScene[3][2] / (1 - gProjectionMainScene[2][2]);
    float sNearClip = gProjectionMainScene[3][2] / (0 - gProjectionMainScene[2][2]);
    float sFrac = -0.06717908497 * pow(sAspect,2) - 0.1044366013 * sAspect + 1.171615686;
    float4x4 sProjection = createProjectionMatrix(sNearClip, sFarClip, sFov, sFov * sAspect * sFrac);  
    float4 pPos = mul(vPos, sProjection);
    PS.Position = pPos;
	
    float projectedX = (0.5 * (pPos.w + pPos.x));
    float projectedY = (0.5 * (pPos.w - pPos.y));
    PS.TexCoordP = float3(projectedX, projectedY, pPos.w);   

    // Scroll noise texture
    float2 uvpos1 = 0;
    float2 uvpos2 = 0;

    uvpos1.x = sin(gTime/40);
    uvpos1.y = fmod(gTime/50,1);

    uvpos2.x = fmod(gTime/10,1);
    uvpos2.y = sin(gTime/12);

    VS.TexCoord.xy += sElementPosition.xy / elementSize;
    PS.TexCoord = VS.TexCoord.xy * elementSize;
    VS.TexCoord.xy *= elementSize / 24.0f ;
	
    PS.SparkleTex.x = VS.TexCoord.x * 1 + uvpos1.x ;
    PS.SparkleTex.y = VS.TexCoord.y * 1 + uvpos1.y ;
    PS.SparkleTex.z = VS.TexCoord.x * 2 + uvpos2.x ;
    PS.SparkleTex.w = VS.TexCoord.y * 2 + uvpos2.y ;

    return PS;
}

//------------------------------------------------------------------------------------------
// MTAApplyFogFade
//------------------------------------------------------------------------------------------
float MTAApplyFogFade( float texelAp, float3 worldPos )
{
    if ( !fFogEnable )
        return texelAp;

    float DistanceFromCamera = distance( sCameraPosition, worldPos );
    float FogAmount = ( DistanceFromCamera - gFogStart )/( gFogEnd - gFogStart );
    texelAp = lerp(texelAp, 0, pow(saturate( FogAmount ), 2 ));
    return texelAp;
}

//-----------------------------------------------------------------------------
// Pixel shaders 
//-----------------------------------------------------------------------------
float4 PixelShaderFunctionDB(PSInput PS) : COLOR0
{
    float2 distFromCam = float2( distance(sCameraPosition.x, PS.WorldPos.x), distance(sCameraPosition.y, PS.WorldPos.y));
    if (((distFromCam.x < sElementSize.x * 0.5  ) && (distFromCam.y < sElementSize.y * 0.5 )) && !bIsDetailed) return 0;

    float2 TexCoordProj = float2(PS.TexCoordP.x, PS.TexCoordP.y) / PS.TexCoordP.z;
    TexCoordProj += float2(0.0006, 0.0006);
	
    float depthPrm = Linearize(FetchDepthBufferValue(TexCoordProj));
    float blurFactor = saturate((depthPrm - PS.DistFromCam) * 0.95);
	
    float3 vFlakesNormal1 = tex2D(RandomSampler,PS.SparkleTex.xy).rgb;
    float3 vFlakesNormal2 = tex2D(RandomSampler,PS.SparkleTex.zw).rgb;
    float3 vFlakesNormal = (vFlakesNormal1 + vFlakesNormal2) / 2 ;
    vFlakesNormal = 2 * vFlakesNormal - 1.0;	
	
    float3 projCoord = float3((PS.TexCoordP.xy / PS.TexCoordP.z),0) ;	
    float3 fvNormal = normalize(float3(vFlakesNormal.x * gNormalStrength.x, vFlakesNormal.y * gNormalStrength.y, vFlakesNormal.z));
    projCoord.xy += blurFactor * float2(fvNormal.x ,fvNormal.y);	

    TexCoordProj.xy += float2(fvNormal.x ,fvNormal.y);
    float depthAlt = Linearize(FetchDepthBufferValue(TexCoordProj));
	
    float4 finalColor = tex2D(ProjectiveSampler, projCoord.xy);
    finalColor.a *= MTAApplyFogFade(finalColor.a, PS.WorldPos);
    finalColor.a *= gAlpha;
	
    if (depthAlt < PS.DistFromCam) finalColor.a = 0;
	
    return saturate(finalColor);
}

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float2 distFromCam = float2( distance(sCameraPosition.x, PS.WorldPos.x), distance(sCameraPosition.y, PS.WorldPos.y));
    if (((distFromCam.x < sElementSize.x * 0.5  ) && (distFromCam.y < sElementSize.y * 0.5 )) && !bIsDetailed) return 0;
	
    float3 vFlakesNormal1 = tex2D(RandomSampler,PS.SparkleTex.xy).rgb;
    float3 vFlakesNormal2 = tex2D(RandomSampler,PS.SparkleTex.zw).rgb;
    float3 vFlakesNormal = (vFlakesNormal1 + vFlakesNormal2) / 2 ;
    vFlakesNormal = 2 * vFlakesNormal - 1.0;	
	
    float3 projCoord = float3((PS.TexCoordP.xy / PS.TexCoordP.z),0) ;
    float3 fvNormal = normalize(float3(vFlakesNormal.x * gNormalStrength.x, vFlakesNormal.y * gNormalStrength.y, vFlakesNormal.z));	
    projCoord.xy += float2(fvNormal.x ,fvNormal.y);	
	
    float4 finalColor = tex2D(ProjectiveSampler, projCoord.xy);
    finalColor.a *= MTAApplyFogFade(finalColor.a, PS.WorldPos);
    finalColor.a *= gAlpha;
    return saturate(finalColor);
}

//-----------------------------------------------------------------------------
// Techniques
//-----------------------------------------------------------------------------
technique dxDrawImage4D
{
  pass P0
  {
    AlphaRef = 1;
    AlphaBlendEnable = true;
    FogEnable = false;
    VertexShader = compile vs_2_0 VertexShaderFunction();
    PixelShader  = compile ps_2_0 PixelShaderFunctionDB();
  }
}

technique dxDrawImage4D_noDBuff
{
  pass P0
  {
    AlphaRef = 1;
    AlphaBlendEnable = true;
    FogEnable = false;
    VertexShader = compile vs_2_0 VertexShaderFunction();
    PixelShader  = compile ps_2_0 PixelShaderFunction();
  }
} 
	