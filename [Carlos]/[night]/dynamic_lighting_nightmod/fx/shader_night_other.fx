 float2 gDistFade = float2(250, 150);
 float gBrightness = 1;
 float gDayTime = 1;

 bool gNightSpotEnable = false;
 float3 gNightSpotPosition = float3(0,0,0);
 float gNightSpotRadius = 0;
 
 float4x4 gWorld : WORLD;
 float4x4 gView : VIEW;
 float4x4 gProjection : PROJECTION;
 float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;
 float4x4 gWorldInverseTranspose : WORLDINVERSETRANSPOSE;
 float3 gCameraPosition : CAMERAPOSITION; 
 #include "common.txt" 
 texture gTexture0 < string textureState="0,Texture"; >;
 sampler Sampler0 = sampler_state
 {
 Texture = (gTexture0);
 }; 
 struct VSInput{
 float4 Position : POSITION0;
 float3 TexCoord : TEXCOORD0;
 float4 Normal : NORMAL0;
 float4 Diffuse : COLOR0;
 }; 
 struct PSInput{
 float4 Position : POSITION;
 float2 TexCoord : TEXCOORD0;
 float DistFade : TEXCOORD1;
 float3 WorldPos : TEXCOORD2;
 float4 Diffuse : COLOR0;
 float4 ViewPos : TEXCOORD4; 
 }; 
 PSInput VertexShaderSB(VSInput VS)
 {
 PSInput PS = (PSInput)0;
 PS.Position = mul(VS.Position, gWorldViewProjection);
 PS.ViewPos = PS.Position;
 PS.WorldPos = mul(float4(VS.Position.xyz,1), gWorld).xyz;
 PS.TexCoord = VS.TexCoord; 
 float DistanceFromCamera = distance( gCameraPosition, PS.WorldPos );
 PS.DistFade = MTAUnlerp ( gDistFade[0], gDistFade[1], DistanceFromCamera ); 
 float4 Diffuse = VS.Diffuse;
 
 float dayTime = gDayTime;
 float brightness = gBrightness;

 float nightLight = createVertexLightPoint(PS.WorldPos.xyz, gNightSpotPosition, gNightSpotRadius );
 dayTime = max( gDayTime, nightLight );
 brightness = max( gBrightness, nightLight );

 float diffGray = saturate(0.1 + (( Diffuse.r +Diffuse.g+Diffuse.b)/3 ) * dayTime);
 Diffuse = lerp( float4(diffGray, diffGray, diffGray, Diffuse.a ), Diffuse, saturate( dayTime)); 
 Diffuse.rgb *= brightness;
 PS.Diffuse = saturate(Diffuse);
 return PS;
 } 
 struct PSOutput 
 {
 float4 color : COLOR0; 
 }; 
 PSOutput PixelShaderSB(PSInput PS)
 {
 PSOutput output = (PSOutput)0;
 float4 texel = tex2D(Sampler0, PS.TexCoord);
 texel.rgb *= PS.Diffuse.rgb; 
 output.color = saturate( texel ); 
 output.color.a = 1;
 return output;
 } 
 technique dynamic_lighting 
 {
 pass P0 
 { 
 AlphaBlendEnable = TRUE;
 VertexShader = compile vs_2_0 VertexShaderSB();
 //PixelShader = compile ps_2_0 PixelShaderSB();
 }
 }
 technique fallback 
 {
 pass P0 
 { }
 } 
