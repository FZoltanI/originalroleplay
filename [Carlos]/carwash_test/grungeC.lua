-- Custom events
addEvent("onClientVehicleDirtLevelChange", true)

-- NEEDED!
addEvent("handleDirtShader", true)

local sx, sy = guiGetScreenSize()

local grungeVehicles = {}

local grungeTextures = {}
grungeTextures[1] = dxCreateTexture("files/images/nogrunge.png")
grungeTextures[2] = dxCreateTexture("files/images/lowgrunge.png")
grungeTextures[3] = dxCreateTexture("files/images/defaultgrunge.png")
grungeTextures[4] = dxCreateTexture("files/images/biggrunge.png")
grungeTextures[5] = dxCreateTexture("files/images/megagrunge.png")

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
	function()
		if debugEnabled then
			addEventHandler("onClientRender", root, displayDebug)
		end
	end
)

function handleDirtShader(vehicle, level)
	level = tonumber(level)
	if isValidDirtVehicle(vehicle) then
		if not level then level = 1 end
		
		if not grungeVehicles[vehicle] or grungeVehicles[vehicle] == nil then
			grungeVehicles[vehicle] = {}
			grungeVehicles[vehicle].shader = dxCreateShader("files/textureReplace.fx", 0, shaderVisibleDistance, true, "vehicle")
		else
			destroyElement(grungeVehicles[vehicle].shader)
			grungeVehicles[vehicle] = {}
			grungeVehicles[vehicle].shader = dxCreateShader("files/textureReplace.fx", 0, shaderVisibleDistance, true, "vehicle")
		end
		
		dxSetShaderValue(grungeVehicles[vehicle].shader, "Grunge", grungeTextures[level])
		for k, v in pairs(replaceTextures) do
			for i=1, #v do
				engineApplyShaderToWorldTexture(grungeVehicles[vehicle].shader, v[i], vehicle)
			end
		end
		engineApplyShaderToWorldTexture(grungeVehicles[vehicle].shader, "?emap*", vehicle)
		
		local oldDirtLevel = getVehicleDirtLevel(vehicle)
		local newDirtLevel = level
		triggerEvent("onClientVehicleDirtLevelChange", vehicle, oldDirtLevel, newDirtLevel)
	end
	return false
end
addEventHandler("handleDirtShader", root, handleDirtShader)

function setVehicleDirtLevel(vehicle, level)
	level = tonumber(level)
	if isValidDirtVehicle(vehicle) then
		if not level then level = 1 end
		
		handleDirtShader(vehicle, level)
	end
	return false
end

function displayDebug()
	local streamedVehicleIndex = 1
	local streamedVehicles = {}

	for k, vehicle in pairs(getElementsByType("vehicle")) do
		if isElementStreamedIn(vehicle) then
			if isValidDirtVehicle(vehicle) then
				streamedVehicleIndex = streamedVehicleIndex + 1
				streamedVehicles[streamedVehicleIndex] = vehicle
			end
		end
	end
	
	if debugEnabled then
		local currentVehicle = getPedOccupiedVehicle(localPlayer)
		local debug3D = true
		
		for k, vehicle in pairs(streamedVehicles) do
			local text = "Vehicle: " .. getVehicleName(vehicle) .. " | Progress: #d7b428" .. tostring(convertNumber(getVehicleDirtProgress(vehicle))) .. (currentVehicle and currentVehicle == vehicle and "#00FF00" or "#FFFFFF") .. " / " .. convertNumber(tonumber(getNextDirtTime(vehicle))) .. " | Dirt level: #d7b428" .. getVehicleDirtLevel(vehicle)
			if debug3D then
				local scx, scy = getScreenFromWorldPosition(getElementPosition(vehicle))
				if scx and scy then
					local x, y, z = getElementPosition(getCamera())
					local vx, vy, vz = getElementPosition(vehicle)
					if isLineOfSightClear(x, y, z, vx, vy, vz, true, false, false, false) then
						dxDrawRectangle(scx - dxGetTextWidth(text, 1, "default", true)/2, scy, dxGetTextWidth(text, 1, "default", true) + 10, 16, tocolor(0,0,0,150))
						dxDrawText(text, scx - dxGetTextWidth(text, 1, "default", true)/2 + 5, scy, 0, 0, currentVehicle and currentVehicle == vehicle and tocolor(0,255,0,255) or tocolor(255,255,255,255), 1, "default", "left", "top", false, false, false, true)
					end
				end
			else
				local chatOffset = getChatboxLayout()["chat_lines"]
				local headerText = "Streamed vehicles:"
				dxDrawRectangle((20/1440)*sx, ((20 + 15*chatOffset + 25)/900)*sy, dxGetTextWidth(headerText, 1, "default", true) + 10, 16, tocolor(0,0,0,150))
				dxDrawText(headerText, (25/1440)*sx, ((20 + 15*chatOffset + 25)/900)*sy, 0, 0, tocolor(255,180,40,255), 1, "default", "left", "top", false, false, false, true)
			
				dxDrawRectangle((20/1440)*sx, ((20 + 15*chatOffset + 13 + 16*k)/900)*sy, dxGetTextWidth(text, 1, "default", true) + 10, 16, tocolor(0,0,0,150))
				dxDrawText(text, (25/1440)*sx, ((20 + 15*chatOffset + 13 + 16*k)/900)*sy, 0, 0, currentVehicle and currentVehicle == vehicle and tocolor(0,255,0,255) or tocolor(255,255,255,255), 1, "default", "left", "top", false, false, false, true)
			end
		end
	end
end

addEventHandler("onClientElementStreamIn", getRootElement(),
    function()
        if getElementType(source) == "vehicle" then
			if isValidDirtVehicle(source) then
				if not grungeVehicles[source] or grungeVehicles[source] == nil then
					triggerServerEvent("loadVehicleDirtServer", source, source)
				end
			end
		end
	end
)

addEventHandler("onClientElementStreamOut", getRootElement(),
    function()
        if getElementType(source) == "vehicle" then
			if isValidDirtVehicle(source) then
				if grungeVehicles[source] then
					destroyElement(grungeVehicles[source].shader)
					grungeVehicles[source].shader = nil
					grungeVehicles[source] = nil
				end
			end
		end
	end
)

addEventHandler("onClientElementDestroy", getRootElement(),
	function ()
		if getElementType(source) == "vehicle" then
			if grungeVehicles[source] then
				destroyElement(grungeVehicles[source].shader)
				grungeVehicles[source] = {}
			end
		end
	end
)

addEventHandler("onClientVehicleDirtLevelChange", getRootElement(),
    function(oldLevel, newLevel)
		if debugEnabled then
			if source and isElement(source) then
				outputChatBox("#961919[CLIENT EVENT] #FFFFFF" .. getVehicleName(source) .. ", old dirt level: #2399dd" .. oldLevel .. "#FFFFFF, new dirt level: #d7b428" .. newLevel, 255, 255, 255, true)
			end
		end
    end
)

--[[ Unused/Debug functions

function getSurfaceVehicleIsOn(vehicle)
    if isElement(vehicle) and (isVehicleOnGround(vehicle) or isElementInWater(vehicle)) then
        local cx, cy, cz = getElementPosition(vehicle)
        local gz = getGroundPosition(cx, cy, cz) - 0.001
        local hit, _, _, _, _, _, _, _, surface = processLineOfSight(cx, cy, cz, cx, cy, gz)
        if hit then
            return surface
        end
    end
    return false
end

function isElementUnderSomething(element)
    if isElement(element) then
        local cx, cy, cz = getElementPosition(element)
        local hit, _, _, _, _, _, _, _, _ = processLineOfSight(cx, cy, cz, cx, cy, cz + 500, true, false, false, true, true, false, false, false, false, false)
        if hit then
            return true
        end
    end
    return false
end

addCommandHandler("clear",
    function ()
        local lines = getChatboxLayout()["chat_lines"]
        for i=1,lines do
            outputChatBox("")
        end
    end
)
--]]