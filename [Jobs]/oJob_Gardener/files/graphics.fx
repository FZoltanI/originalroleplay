texture gCustomTexture : TEXTURE;

technique hello{
    pass P0{
        Texture[0] = gCustomTexture;
    }
}