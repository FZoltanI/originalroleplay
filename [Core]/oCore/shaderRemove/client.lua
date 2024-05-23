local texture = dxCreateTexture(1, 1)
local shader = dxCreateShader("shaderRemove/files/ped_shader.fx")
dxSetShaderValue(shader, "reTexture", texture)

addEventHandler("onClientResourceStart", resourceRoot,
function ()
	engineApplyShaderToWorldTexture(shader, "shad_ped")
    engineApplyShaderToWorldTexture(shader, "shad_car")
end )