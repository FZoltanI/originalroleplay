//
// transform.fx
//

//---------------------------------------------------------------------
// Ssettings
//---------------------------------------------------------------------
float gScale = 1;
float gAspect = 1;
float3 gTransform = float3(1,1,1);

texture gTexture;

//---------------------------------------------------------------------
// Include some common stuff
//---------------------------------------------------------------------
static const float PI = 3.141592653589793;

//---------------------------------------------------------------------
// Sampler for the main texture
//---------------------------------------------------------------------
sampler Sampler0 = sampler_state
{
    Texture = (gTexture);
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = None;
    AddressU = Wrap;
    AddressV = Wrap;
};

//-----------------------------------------------------------------------------
// AngularTEX
// Source: https://github.com/notlion/streetview-stereographic/blob/master/index.html
//-----------------------------------------------------------------------------
float2 AngularTEX(float2 texUV, float scale, float aspect, float3 transform)
{
    float2 rads = float2(PI * 2.0, -PI * 0.5); // rads.y was PI
    texUV.xy = 2 * (texUV.xy - 0.5) * float2(scale, scale * aspect);
	
    // Project to Sphere
    float x2y2 = ( texUV.x * texUV.x + texUV.y * texUV.y );
    float3 sphere_pnt = float3( texUV.x, texUV.y, x2y2 - 1.0 ) / ( x2y2 + 1.0 );
    sphere_pnt *= transform;
	
    // Convert to Spherical Coordinates
    float r = length( sphere_pnt );
    float lon = atan2( sphere_pnt.x, sphere_pnt.y ); 
    float lat = acos( sphere_pnt.z / r);
    return float2( lon, lat )/ rads;
}

//------------------------------------------------------------------------------------------
// PixelShaderFunction
//------------------------------------------------------------------------------------------
float4 PixelShaderFunction(float2 TexCoord : TEXCOORD0) : COLOR0
{
	return tex2D(Sampler0, AngularTEX( TexCoord, gScale, gAspect, gTransform ));
}


//------------------------------------------------------------------------------------------
// Techniques
//------------------------------------------------------------------------------------------
technique transform
{
    pass P0
    {
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
