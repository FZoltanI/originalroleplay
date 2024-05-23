Resource: dynamic_lighting_nightMod v0.0.3 Alpha
Author: Ren_712
Video: https://www.youtube.com/watch?v=kumiFy4pyw8

Requires:
bone_attach: https://community.multitheftauto.com/index.php?p=resources&s=details&id=2540
dynamic_lighting: https://community.multitheftauto.com/index.php?p=resources&s=details&id=9398
dynamic_lighting_projectiles: http://community.multitheftauto.com/index.php?p=resources&..p;id=11072
dynamic_lighting_vehicles: http://community.multitheftauto.com/index.php?p=resources&..p;id=11071

Shader_flashlight_test v1.2.4 is included in this resource.

Description:

This is one of my old resources - I've decided to release it.
The video should be enough to describe it. There are several things to work on, 
the issues are listed below, but don't expect me to update it - i'll leave it up to You.

Known issues:
-Reduced draw distance - forced weather id 0 as default. The effect draw distance
 is limited due to framerate issues. You might want to setEffectRange a bit higher,
 at a cost of lower framerate.
-Lack of coronastar - since many gtasa objects use coronas at night, and you can't 
 selectively remove the texture, i've decided to remove all. So no vehicle corona,
 sun, stars etc. To restore coronas you will have to use custom_coronas resource or 
 material3D_corona class from material3DEffects. At this point it is up to you 
 to recreate the effects.
-Needs a decent screen shader (to make night a bit grayish)

The original flashlight model from:
http://www.sharecg.com/v/29667/related/5/3D-Model/Flashlight-model+texture
Slightly modified and converted.