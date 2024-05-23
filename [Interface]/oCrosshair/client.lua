Crosshair = {
	crosshairs = {};
	shader = {};

	default = dxCreateTexture("crosshairs/255/"..(getElementData(localPlayer, "char:crosshairID") or 1)..".png");
	
	register = function(weaponid, crosshairpath)
		if not crosshairpath:find(":") then
			crosshairpath = (":%s/%s"):format(getResourceName(sourceResource), crosshairpath)
		end
		assert(fileExists(crosshairpath), "Invalid File for Crosshair.register")
		
		if Crosshair.crosshairs[weaponid] then destroyElement(Crosshair.crosshairs[weaponid]) end
		Crosshair.crosshairs[weaponid] = dxCreateTexture(crosshairpath)
	end,
	
	unregister = function(weaponid)
		if Crosshair.crosshairs[weaponid] then destroyElement(Crosshair.crosshairs[weaponid]) end
		Crosshair.crosshairs[weaponid] = nil
	end,
	
	init = function()
		Crosshair.shader = dxCreateShader("texreplace.fx")

		color, _, _ = unpack(getElementData(localPlayer, "char:crosshairCOLOR") or {255, 255, 255})
		Crosshair.default = dxCreateTexture("crosshairs/"..color.."/"..(getElementData(localPlayer, "char:crosshairID") or 1)..".png")
		--changeTextureColor(Crosshair.default, crosshairColor[1], crosshairColor[2], crosshairColor[3], 255)


		assert(Crosshair.shader, "Could not create Crosshair Replacement Shader")
		engineApplyShaderToWorldTexture(Crosshair.shader, "siteM16")
		dxSetShaderValue(Crosshair.shader, "gTexture", Crosshair.default)
	end, 

	weaponSwitch = function(prev, now)
		local weapon = getPedWeapon(localPlayer)
		dxSetShaderValue(Crosshair.shader, "gTexture", Crosshair.crosshairs[weapon] or Crosshair.default)
	end
}

setPlayerHudComponentVisible("crosshair", true)

addEventHandler("onClientPlayerWeaponSwitch", localPlayer, Crosshair.weaponSwitch)

addEventHandler("onClientElementDataChange", root, function(data, old, new)
	if source == localPlayer then 
		if data == "char:crosshairID" or data == "char:crosshairCOLOR" then 
			Crosshair.init()
		end
	end
end)

-- Exports
register 	= Crosshair.register
unregister 	= Crosshair.unregister

Crosshair.init()