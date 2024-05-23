texture gTexture;
 
technique paintjob
{
        pass P0
        {
                Texture[0] = gTexture;
        }
}
 