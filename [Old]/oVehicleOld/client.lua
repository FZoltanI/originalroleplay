local sx, sy = guiGetScreenSize()
local vehsWithSpoiler = {}
local enabledModels = {[451] = -20, [411] = -30}
local vehcount = 0

addEvent("client->turnDownWindow", true)
addEventHandler("client->turnDownWindow", getRootElement(), function(window, status)
	setVehicleWindowOpen(source, window, not status)
end)

bindKey("j", "down", function()
	if not getElementData(localPlayer, "user:loggedin") then return end
	if getPedOccupiedVehicleSeat(localPlayer) == 0 then
		local veh = getPedOccupiedVehicle(localPlayer)

		if not (getElementModel(vehicle) == 509 or getElementModel(vehicle) == 481 or getElementModel(vehicle) == 510) then 
			if getElementData(localPlayer,"user:aduty") or exports.oInventory:hasItem(36,getElementData(veh,"veh:id")) then
				if not isTimer(engineTimer) then
					local engine = getElementData(veh, "veh:engine")
					if engine then
						triggerServerEvent("toggleEngine", localPlayer, veh, engine)
						exports.cl_chat:sendLocalMeAction("leállítja a jármű motorját.")
					end
				end
			else
				exports.cl_infobox:outputInfoBox("Nincs kulcsod a járműhöz.", "error")
			end
		end
	end
end)

bindKey("space", "down", function()
	if not getElementData(localPlayer, "user:loggedin") or not getKeyState("j") then return end
	if getPedOccupiedVehicleSeat(localPlayer) == 0 then
		local veh = getPedOccupiedVehicle(localPlayer)
		if not (getElementModel(vehicle) == 509 or getElementModel(vehicle) == 481 or getElementModel(vehicle) == 510) then 
			if getElementData(localPlayer,"user:aduty") or exports.oInventory:hasItem(36,getElementData(veh,"veh:id")) then
				engineTimer = setTimer(function()
					if not getKeyState("space") then return end
					if getElementHealth(veh) <= 250 then
						exports.cl_chat:sendLocalMeAction("megpróbálja beindítani a jármű motorját, de nem sikerül neki.")
						exports.cl_infobox:outputInfoBox("Túl sérült a járműved motorja.", "error")
						killTimer(engineTimer)
					else
						triggerServerEvent("toggleEngine", localPlayer, veh, engine)
						exports.cl_chat:sendLocalMeAction("beindítja a jármű motorját.")
						killTimer(engineTimer)
					end
				end, 1100, 1)
				playSound("files/sounds/motor.mp3")
			else
				exports.cl_infobox:outputInfoBox("Nincs kulcsod a járműhöz.", "error")
			end
		end
	end
end)

bindKey("k", "down", function()
	if not getElementData(localPlayer, "user:loggedin") then return end
    local veh = getNearestVehicle(localPlayer, 4)
    if veh then
        if getElementData(localPlayer,"user:aduty") or exports.oInventory:hasItem(36,getElementData(veh,"veh:id")) then
            local locked = getElementData(veh, "veh:locked")
			triggerServerEvent("lockVehicle", localPlayer, veh, locked)
			if locked then
				exports.cl_chat:sendLocalMeAction("kinyitja egy közelben lévő járművet. ("..getModdedVehicleName(veh)..")")
            else
                exports.cl_chat:sendLocalMeAction("lezár egy közelben lévő járművet. ("..getModdedVehicleName(veh)..")")
            end
			if getPedOccupiedVehicle(localPlayer) then
				playSound("files/sounds/zar2.mp3")
			else
				playSound("files/sounds/zar.mp3")
			end
        else
            exports.cl_infobox:outputInfoBox("Nincs kulcsod a járműhöz.", "error")
        end
    end
end)

bindKey("f5", "down", function()
	if not getElementData(localPlayer, "user:loggedin") then return end
	local veh = getPedOccupiedVehicle(localPlayer)
    if veh then
        local seatbelt = getElementData(localPlayer, "char:seatbelt")
        if seatbelt then
			exports.cl_chat:sendLocalMeAction("kikapcsolja a biztonsági övét.")
			playSound("files/sounds/ovki.mp3")
        else
			exports.cl_chat:sendLocalMeAction("bekapcsolja a biztonsági övét.")
			playSound("files/sounds/ovbe.mp3")
        end
		setElementData(localPlayer, "char:seatbelt", not seatbelt)
    end
end)

bindKey("l", "down", function()
	local veh = getPedOccupiedVehicle(localPlayer)
	if veh and getPedOccupiedVehicleSeat(localPlayer) == 0 then
		--if ((not getElementModel(veh) == 509) or (not getElementModel(veh) == 481) or (not getElementModel(veh) == 510)) then 
			if getVehicleOverrideLights(veh) ~= 2 then
				triggerServerEvent("toggleLights", localPlayer, veh, 2)
				exports.cl_chat:sendLocalMeAction("felkapcsolja a jármű lámpáit.")
			else
				triggerServerEvent("toggleLights", localPlayer, veh, 1)
				exports.cl_chat:sendLocalMeAction("lekapcsolja a jármű lámpáit.")
			end
		--end
	end
end)

function getElementSpeed(theVehicle)
    return (Vector3(getElementVelocity(theVehicle)) * 180).length
end

addEventHandler("onClientRender", root, function()
	local veh = getPedOccupiedVehicle(localPlayer)
	if veh then
		local text = math.floor(getElementSpeed(veh)).." km/h"
		dxDrawText(text, sx - dxGetTextWidth(text, 1, "pricedown") - 120, sy - 25, 0, 0, tocolor(255, 255, 255), 1, "pricedown")
	end
end)

addEventHandler("onClientPreRender", getRootElement(), function(deltaTime)
	local veh = getPedOccupiedVehicle(localPlayer)

	if veh then 
		for k, v in pairs(vehsWithSpoiler) do
			local rot = v[2] or 0
			local a = math.abs(v[3]/500)

			if v[1] == 0 then
				--[[if getVehicleOccupant(v) and getElementSpeed(v) > 150 then
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
				end]]
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
	if getElementType(source) == "vehicle" then
		local rotAngle = enabledModels[getElementModel(source)]
		if rotAngle ~= nil then
			local mode = getElementData(source, "sp_mode") or 0
			if mode == 0 then
				setVehicleComponentRotation(source, "movspoiler", 0, 0, 0)
				vehsWithSpoiler[source] = {mode, 0, rotAngle, 0}
			elseif mode == 1 then
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

bindKey("NUM_5", "down", function()
	local veh = getPedOccupiedVehicle(localPlayer)
	
	if isTimer(spamTimer) then
		return
	elseif not veh then
		return
	elseif enabledModels[getElementModel(veh)] == nil then
		return
	elseif not getElementData(veh, "veh:engine") then
		return
	elseif getPedOccupiedVehicleSeat(localPlayer) ~= 0 then
		return
	end
		
	spamTimer = setTimer(function() end, 1500, 1)
	
	setElementData(veh, "sp_mode", ((getElementData(veh, "sp_mode") or 0) == 0) and 1 or 0)
end)

function isVehicleOccupied(vehicle)
    local _, occupant = next(getVehicleOccupants(vehicle))
    return occupant and true, occupant
end

addCommandHandler("rtc", function()
	local vehTable = {}
	if exports.cl_admin:getPlayerAdminLevel(localPlayer) >= 3 then
		local x, y, z = getElementPosition(localPlayer)
		vehTable = {}

		for k, v in ipairs(getElementsByType("vehicle"), getRootElement(), true) do
			if getDistanceBetweenPoints3D(x, y, z, getElementPosition(v)) <= 7 then
				if not isVehicleOccupied(v) then
                    table.insert(vehTable, v)
				end
			end
		end
		triggerServerEvent("respawnVehicles", localPlayer, vehTable)
		outputChatBox("[Jármű]: #ffffffJárművek respawnolva. "..color.."["..#vehTable.."db]", r, g, b, true)
	end
end)

addCommandHandler("nearbyvehicles", 
    function(player,cmd)
        local vehicles = {}
        local vehindex = 1

        for k,v in ipairs(getElementsByType("vehicle")) do
            local pX, pY, pZ = getElementPosition(localPlayer)
            local cX, cY, cZ = getElementPosition(v)
            
            if core:getDistance(localPlayer,v) < 15 then 
                vehicles[vehindex] = {}
                vehicles[vehindex][1] = getModdedVehicleName(v)
                vehicles[vehindex][2] = getElementModel(v)
                vehicles[vehindex][3] = getElementData(v, "veh:owner")
				vehicles[vehindex][4] = getElementData(v, "veh:id")
				vehicles[vehindex][7] = math.floor(core:getDistance(localPlayer,v))
            
                if getElementData(v,"veh:locked") then 
                    vehicles[vehindex][5] = "#c11c0dZárva"
                else 
                    vehicles[vehindex][5] = "#05a344Nyitva"
                end

                if not getElementData(v,"veh:engine") then 
                    vehicles[vehindex][6] = "#c11c0dNem jár"
                else 
                    vehicles[vehindex][6] = "#05a344Jár"
				end
				


                vehindex = vehindex + 1
            end
        end

        outputChatBox(#vehicles)
        if #vehicles > 0 then 
            outputChatBox(core:getServerColor().."=======[ Közeledben lévű járművek ]=======",255,255,255,true) 
            for k,v in ipairs(vehicles) do 
                outputChatBox("Jármű ID: "..color..(v[4] or "nan").. " #ffffffModell ID: "..color..(v[2] or "nan").."#ffffff, Modell Neve: "..color..(v[1] or "nan").." #ffffffTulajdonos ID: "..color..(v[3] or "nan").. " #ffffffAjtó állapota: "..(v[5] or "nan").." #ffffffMotor állapota: "..(v[6] or "nan").." #ffffffTávolság: "..color..v[7]..'m',255,255,255,true)
            end
        else
            outputChatBox(core:getServerColor().."[Vehicle]: #ffffffNincsennek járművek a közeledben!",255,255,255,true) 
        end
    end 
)

addEventHandler("onClientPlayerVehicleEnter", getRootElement(), function(vehicle, seat)
	if source == localPlayer then 
		if not (getElementModel(vehicle) == 509 or getElementModel(vehicle) == 481 or getElementModel(vehicle) == 510) then 
			setVehicleEngineState(vehicle, getElementData(vehicle, "veh:engine"))
		else
			setVehicleEngineState(vehicle, true)
		end
		if not (getElementModel(vehicle) == 509 or getElementModel(vehicle) == 481 or getElementModel(vehicle) == 510) then 
			if seat == 0 then
				outputChatBox("[Jármű]: #ffffffA jármű motorjának beindításához/leállításához nyomd le a "..color.."[J] #ffffff+ "..color.."[SPACE] #ffffffbillenyűt.", r, g, b, true)
			end
			outputChatBox("[Jármű]: #ffffffA biztonsági öv becsatoláshoz nyomd le a "..color.."[F5] #ffffffbillenyűt.", r, g, b, true)
		end
		if not getElementData(vehicle, "veh:broke") then
			setVehicleDamageProof(vehicle, false)
		end
	end
end)

--jobbklikkes ajtónyitás
local maxDistanceToOpen = 2

local components = {
    {"bonnet_dummy", 0, "motorháztető"},
    {"boot_dummy", 1, "csomagtartó"},
    {"door_lf_dummy", 2, "bal első"},
    {"door_rf_dummy", 3, "jobb első"},
    {"door_lr_dummy", 4, "bal hátsó"},
    {"door_rr_dummy", 5, "jobb hátsó"},
}

function boneBreaked(e)
--    char >> bone felépítése = {Has, Bal kéz, Jobb kéz, Bal láb, Jobb láb}
    local bone = getElementData(e, "char >> bone") or {true, true, true, true, true}
    if not bone[2] or not bone[3] then 
        return true
    end
    return false
end

function getNearbyVehicle(e)
    if e == localPlayer then
        local shortest = {2000, nil, nil}
        local px,py,pz = getElementPosition(localPlayer)
        for k,v in pairs(getElementsByType("vehicle", root, true)) do
            local locked = getElementData(v, "veh:locked")
            local x,y,z = getElementPosition(v)
            local firstDist = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
            if firstDist < 2 then
                for k2,v2 in pairs(components) do
                    local x,y,z = getVehicleComponentPosition(v, v2[1], "world")
                    if x and y and z then
                        local dist = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
                        if v2[1] == "bonnet_dummy" then
                            if dist < shortest[1] and dist < 3 and not locked then
                                shortest = {dist, v, v2}
                            end
                        else
                            if dist < shortest[1] and dist < maxDistanceToOpen and not locked then
                                shortest = {dist, v, v2}
                            end
                        end
                    end
                end
            end
        end
        if not shortest[2] or shortest[2] and not isElement(shortest[2]) then
            return false
        else
            return shortest
        end
    end
end

function interactVeh()
    if isTimer(spamTimer) then return end
    spamTimer = setTimer(function() end, 600, 1)
    if boneBreaked(localPlayer) then return end
	if getPedWeapon(localPlayer) ~= 0 then return end
	if isCursorShowing() then return end
    if not getPedOccupiedVehicle(localPlayer) then
        local veh = getNearbyVehicle(localPlayer)
        if veh then
            local dist, element, componentDetails = unpack(veh)
            local newState = getVehicleDoorOpenRatio(element, componentDetails[2]) == 1
            triggerServerEvent("changeDoorState2", localPlayer, element, componentDetails[2], newState)
            if not newState then
                if componentDetails[2] >= 2 then
                    playSound("files/sounds/dooropen.mp3")
                   exports.cl_chat:sendLocalMeAction("kinyitja a "..componentDetails[3].."ajtót", 1)
                else
                    playSound("files/sounds/dooropen.mp3")
                   exports.cl_chat:sendLocalMeAction("felnyitja a "..componentDetails[3].."t", 1)
                end
            else
                if componentDetails[2] >= 2 then
                    playSound("files/doorclose.mp3")
                   exports.cl_chat:sendLocalMeAction("bezárja a "..componentDetails[3].."ajtót", 1)
                else
                    playSound("files/doorclose.mp3")
                   exports.cl_chat:sendLocalMeAction("bezárja a "..componentDetails[3].."t", 1)
                end
            end
        end
    end
end
bindKey("mouse2", "down", interactVeh)
-------------------------------


--------rendszám---------------

local font = exports.cl_font:getFont("roboto", 15)
local font2 = exports.cl_font:getFont("bebasneue", 55)
local icon = exports.cl_font:getFont("fontawesome2", 35)


local rendszamshowing = false

addEventHandler("onClientResourceStart", resourceRoot, function()
	if not fileExists("status.xml") then 
		local file = xmlCreateFile("status.xml","xml")
		local node = xmlCreateSubNode(file, "showingStatus")
		xmlNodeSetValue(node,"showingStatus","0")
		xmlSaveFile(file)
		xmlUnloadFile(file)
	else
		local file = xmlLoadFile("status.xml") 

		local node = xmlFindSubNode(file,"showingStatus",0)
		local value = xmlNodeGetValue(node,"showingStatus") 

		if tonumber(value) == 1 then 
			rendszamshowing = true 
		else
			rendszamshowing = false 
		end

		xmlUnloadFile(file)
	end
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
	if fileExists("status.xml") then 
		local file = xmlLoadFile("status.xml") 

		local atribute = 0 

		if rendszamshowing then 
			atribute = 1
		else
			atribute = 0
		end

		local node = xmlFindSubNode(file,"showingStatus",0)
		local node = xmlNodeSetValue(node,tostring(atribute)) 

		xmlUnloadFile(file)
	end
end)


function renderNumberPlates()
	local px, py, pz = getCameraMatrix()
	for k, v in ipairs(getElementsByType("vehicle"))do
		local tx, ty, tz = getElementPosition(v)
		local dist = math.sqrt(( px - tx ) ^ 2 + ( py - ty ) ^ 2 + ( pz - tz ) ^ 2)
		if dist < 25 then
			if isLineOfSightClear(px, py, pz, tx, ty, tz, true, false, false, true, false, false, false, localPlayer) then
				local sx, sy, sz = getElementPosition(v)
				local x, y = getScreenFromWorldPosition(sx, sy, sz + 1)

				if x then
					local rendszam = getVehiclePlateText(v)
					local vehname = getModdedVehicleName(v) or "nincs megadva"
					local vehtype = getVehicleType(v)

					dxDrawText(rendszam.." ("..vehname..")", x+1, y+1 - dist/4, x+1, y+1 - dist/4, tocolor(0, 0, 0, 180 - dist*5), 1 - dist/35, font, "center", "top", false, false, false, true)
					dxDrawText(rendszam..core:getServerColor().." ("..vehname..")", x, y - dist/4, x, y - dist/4, tocolor(255, 255, 255, 255 - dist*5), 1 - dist/35, font, "center", "top", false, false, false, true)

					if vehtype == "Automobile" then 
						dxDrawText("", x, y - 55 + dist*1.5, x, y - 55 + dist*1.5, tocolor(255, 255, 255, 220), 1 - dist/35, icon, "center", "top", false, false, false, true)
					elseif vehtype == "Bike" then 
						dxDrawText("", x, y - 55 + dist*1.5, x, y - 55 + dist*1.5, tocolor(255, 255, 255, 220), 1 - dist/35, icon, "center", "top", false, false, false, true)
					end
				end
			end
		end
	end
end 
bindKey("F10","up",
	function()
		if rendszamshowing then 
			removeEventHandler("onClientRender",root,renderNumberPlates)
			rendszamshowing = false 
			outputChatBox(core:getServerColor().."[classGaming]: #ffffffRendszámok megjelenítése kikapcsolva.",255,255,255,true)
		else 
			addEventHandler("onClientRender",root,renderNumberPlates)
			rendszamshowing = true 
			outputChatBox(core:getServerColor().."[classGaming]: #ffffffRendszámok megjelenítése bekapcsolva.",255,255,255,true)
		end
	end 
)
-------------------------------