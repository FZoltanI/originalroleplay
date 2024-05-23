Resource: Shader Ped Normal v1.0.2
Video: http://www.youtube.com/watch?v=PQp7WZmECso
Author: Ren712
Contact: knoblauch700@o2.pl

update v1.0.0:
-rewritten the resource lua code from scratch
-added shader_dynamic_sky support

This is a normal map resource for MTA. It enables normal mapping effect for peds.
Also adds sun and moon light to make gtasa lighting a bit more interesting.
It is compatible with the peds created to work with normalmap plugin for gtasa.
You'll have to extract normals from the txd file and apply them with
the applyNormalToPedTexture function. I have uploaded a test resource to present
a better explanation. https://www.dropbox.com/s/3odhp5ybn9gg7vc/winterSkinNormal.zip?dl=0

The resource itself adds exported clientside functions:
----------------------------------------------------------------------------------------
applyNormalToPedTexture( filepath string table ) - Required argument: the table of filepaths to
to apply. Those should be paths for the normals extracted from the txd archive.
----------------------------------------------------------------------------------------
removeNormalFromPedTexture( filepath string table ) -- Required argument: the table of previously
applied normals to be disabled.
----------------------------------------------------------------------------------------
applySpecularToGTAPeds(ped model id table or nil,bool sobel) -- Optional argument: the ped model id table
If left blank the effect is applied to all standard ped textures. This function applies better 
lighting  to chosen or all peds. The second argument generates normals based on original textures if set true.
Sobel filter works only when your graphics card support shader model 3.
----------------------------------------------------------------------------------------
removeSpecularFromGTAPeds(ped model id table or nil)-- Optional argument: the ped model id table
If left blank the effect is removed from all ped textures. The function removes the effect from peds. 
----------------------------------------------------------------------------------------

All the functions Return true if set successfully, false otherwise.

examples:
----------------------------------------------------------------------------------------
example: applyNormalToPedTexture({"normals/face_nrm1.0.png","normals/skin_nrm1.0.png"})
applies normal map effect to textures "face" and "skin". Notice that the nrm textures
should be placed in the resource the function is being called from.
----------------------------------------------------------------------------------------
example: applySpecularToGTAPeds({0,7,121},false)
applies the specular effect to peds by id 0,7,121
----------------------------------------------------------------------------------------
removeSpecularFromGTAPeds() 
removes the specular effect from all the peds.
----------------------------------------------------------------------------------------

Of course when you want to use theese functions in your resources you have to include 
the ShaderPedNormal resource in meta. Also call the functions like this:

exports.shaderPedNormal:removeSpecularFromGTAPeds() 