float red;
float green;
float blue;
float alpha;

technique colorChange
{
    pass P0
    {
        MaterialAmbient = float4(red, green, blue, alpha);
    }
}