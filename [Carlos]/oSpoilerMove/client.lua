vehsWithSpoiler = {}
local enabledModels = {
    [415] = -30,
}

addEventHandler("onClientPreRender", getRootElement(), function(deltaTime)
	local veh = getPedOccupiedVehicle(localPlayer)

	if veh then 
        for k, v in pairs(vehsWithSpoiler) do
			local rot = v[2] or 0
			local a = math.abs(v[3]/500)

			if v[1] == 0 then
				if getVehicleOccupant(v) and getElementSpeed(v) > 150 then
					if rot > v[3] then
						setVehicleComponentRotation(v, "movspoiler", rot - a*deltaTime, 0, 0)
						vehsWithSpoiler[v][2] = rot - a*deltaTime
					end
				else
					if rot < 0 then
						local rot = (rot + a*deltaTime) <= 0 and (rot + a*deltaTime) or 0
						setVehicleComponentRotation(k, "movspoiler", rot, 0, 0)
						vehsWithSpoiler[v][2] = rot
					end
				end
			elseif v[1] == 1 then
				if getElementData(v, "veh:engine") then
					if rot > v[3] then
						setVehicleComponentRotation(k, "movspoiler", rot - a*deltaTime, 0, 0)
						vehsWithSpoiler[v][2] = rot - a*deltaTime
					end
				else
					if rot < 0 then
						local rot = (rot + a*deltaTime) <= 0 and (rot + a*deltaTime) or 0
						setVehicleComponentRotation(k, "movspoiler", rot, 0, 0)
						vehsWithSpoiler[v][2] = rot
					end
				end
			end
		end
	end
end)

addEventHandler("onClientElementStreamIn", getRootElement(), function()
    outputChatBox(getElementType(source))
    if getElementType(source) == "vehicle" then
        outputChatBox("asd")
		local rotAngle = enabledModels[getElementModel(source)]
		if rotAngle ~= nil then
			local mode = getElementData(source, "sp_mode") or 0
			if mode == 0 then
				setVehicleComponentRotation(source, "movspoiler", 0, 0, 0)
                vehsWithSpoiler[source] = {mode, 0, rotAngle, 0}
                outputChatBox("spoiler")
            elseif mode == 1 then
                outputChatBox("spoiler")
				setVehicleComponentRotation(source, "movspoiler", rotAngle, 0, 0)
				vehsWithSpoiler[source] = {mode, rotAngle, rotAngle}
			end
		end
	end
end)

addEventHandler("onClientElementStreamOut", getRootElement(), function()
	if getElementType(source) == "vehicle" and enabledModels[getElementModel(source)] ~= nil then
		if vehsWithSpoiler[source] then
			vehsWithSpoiler[source] = nil
		end
	end
end)

addEventHandler("onClientElementDataChange", getRootElement(), function(theKey, oldValue, newValue)
	if getElementType(source) == "vehicle" and theKey == "sp_mode" then
		if vehsWithSpoiler[source] then
			vehsWithSpoiler[source] = {newValue, vehsWithSpoiler[source][2], enabledModels[getElementModel(source)]}
		end
	end
end)