renderTarget = dxCreateRenderTarget(400, 150)

addEventHandler("onClientRender", root, function()
    if isElement(renderTarget) then
		dxSetRenderTarget(renderTarget, true)

		dxDrawRectangle(0, 0, 200, 200, tocolor(0, 0, 0))
		dxDrawText("OriginalRoleplay - Closed Beta Test I.", 400, 160, 0, 0, tocolor(227, 133, 45, 255), 1.5, "default-bold", "center", "center", false, false, false, true)

		dxSetRenderTarget()
	end
end)

shader = dxCreateShader("texturechanger.fx")
dxSetShaderValue(shader, "textureFile", renderTarget)
--engineApplyShaderToWorldTexture(shader, "heat_02")
engineApplyShaderToWorldTexture(shader, "grifnewtex1x_las")