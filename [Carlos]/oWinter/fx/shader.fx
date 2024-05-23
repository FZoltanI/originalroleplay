//-- Declare the texture. These are set using dxSetShaderValue( shader, "TextSnow", texture )
texture TextSnow;
 
technique simple
{
    pass P0
    {
        //-- Set up texture stage 0
        Texture[0] = TextSnow;

 
        //-- Leave the rest of the states to the default settings
    }
}