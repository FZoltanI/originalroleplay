setWaterColor(36, 155, 201)

setOcclusionsEnabled(false)
engineSetAsynchronousLoading(true, false)


function showcs(m, down)
	if isCursorShowing() then
		showCursor(false)
	else
		showCursor(true)
	end
end
bindKey("m", "down", showcs)

local hungerTimer = false
local thirstTimer = false

addEventHandler("onClientElementDataChange", localPlayer, function(theKey, oldValue, newValue)
	if getElementType(source) == "player" then
		if theKey == "user:loggedin" and newValue then
			--hungerTimer = setTimer(checkHunger, 1200000, 1)
			--thirstTimer = setTimer(checkHunger, 1000000, 1)
		elseif theKey == "user:aduty" then 
			if not getElementData(source, theKey) then
				--hungerTimer = setTimer(checkHunger, 1200000, 1)
				--thirstTimer = setTimer(checkHunger, 1000000, 1)
			end
		end
	end
end)

addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()), function()
	hungerTimer = setTimer(checkHunger, minToMilisec(10), 0)
	thirstTimer = setTimer(checkThirst, minToMilisec(8), 0)
end)

local sx, sy = guiGetScreenSize()

addEventHandler("onClientRender", root,
	function()
		setControlState("walk", true)
		if getElementData(localPlayer, "user:loggedin") then 

		--dxDrawRectangle(0, sy*0.985, sx*0.953, sy*0.015)
			dxDrawText("#ffffff"..serverName.."[v"..serverVersion.."] - AccountID: ".. getElementData(localPlayer, "user:id") .." - "..getDate("year").."."..getDate("month").."."..getDate("monthday"), sx - 90, sy -6, sx - 90, sy - 6, tocolor(255, 255, 255, 150), 1, "ariel", "right", "center", false, false, false, true)
		else 
			dxDrawText("#ffffff"..serverName.."[v"..serverVersion.."] | "..getDate("year")..". "..getDate("month").."."..getDate("monthday"), sx - 90, sy -6, sx - 90, sy - 6, tocolor(255, 255, 255, 150), 1, "default", "right", "center", false, false, false, true)
		end  
	end  
)

addEventHandler("onClientPedDamage", root,
	function()
		if getElementType(source) == "ped" then
			if not getElementData(source, "ped:damageable") then 
				setElementHealth(source, 100)
			end
		end
	end 
)

function checkHunger()
--	if not (getElementData(localPlayer,"user:aduty") or getElementData(localPlayer,"adminJail.IsAdminJail") or getElementData(localPlayer,"pd:jail")) then 
		if not getElementData(localPlayer, "user:loggedin") then 
			return 
		end	

		if getElementData(localPlayer, "adminJail.IsAdminJail") then 
			return
		end		
		if getElementData(localPlayer,"pd:jail") then 
			
			return
		end

		if getElementData(localPlayer, "user:aduty") then 
			return
		end

		local hunger = getElementData(localPlayer, "char:hunger")
		if 8 >= hunger then 
		--	killPed(localPlayer)
			setElementHealth(localPlayer, 0)
			setElementData(localPlayer,"char:health", 0)
			setElementData(localPlayer, "customDeath", "éhen halt")
			setElementData(localPlayer,"char:hunger", 0, true)
			--hungerTimer = setTimer(checkHunger, 1200000,1)
		else
			--hungerTimer = setTimer(checkHunger, 1200000,1)
			setElementData(localPlayer,"char:hunger", hunger - 4, true)
			if getElementData(localPlayer, "char:hunger") <= 20 then
				outputChatBox(getServerPrefix("server", "OriginalRoleplay", 1).."Kezdesz éhes lenni egyél valamit, vagy össze fogsz esni.", 255, 255, 255, true)
				exports.oInfobox:outputInfoBox("Figyelj a éhség szintedre, mert alacsony!", "warning")
			end
		end
		
--	end
end

function checkThirst()
	if not getElementData(localPlayer, "user:loggedin") then 
		return 
	end	

	if getElementData(localPlayer, "adminJail.IsAdminJail") then 
		return
	end		
	if getElementData(localPlayer,"pd:jail") then 
		return
	end

	if getElementData(localPlayer, "user:aduty") then 
		return
	end

	local thirst = getElementData(localPlayer, "char:thirst")
	if 2 >= thirst then 
	--	killPed(localPlayer)
		setElementHealth(localPlayer, 0)
		setElementData(localPlayer,"char:health", 0)
		setElementData(localPlayer, "customDeath", "szomjan halt")
		setElementData(localPlayer,"char:thirst", 0, true)
		--thirstTimer = setTimer(checkThirst, 1200000,1)
	else
		--thirstTimer = setTimer(checkThirst, 1200000,1)
		setElementData(localPlayer,"char:thirst", thirst - 4, true)
		if getElementData(localPlayer, "char:thirst") <= 20 then
			outputChatBox(getServerPrefix("server", "OriginalRoleplay", 1).."Kezdesz szomjas lenni igyál valamit, vagy össze fogsz esni.", 255, 255, 255, true)
			exports.oInfobox:outputInfoBox("Figyelj a szomjúság szintedre, mert alacsony!", "warning")
		end
	end
	
end

function lossThirst()
	if not (getElementData(localPlayer,"user:aduty") or getElementData(localPlayer,"adminJail.IsAdminJail") or getElementData(localPlayer,"pd:jail")) then 
		local thirst = tonumber(getElementData(localPlayer, "char:thirst"))
		local loss = math.random(2, 4)
		if loss > thirst then
			setElementData(localPlayer, "char:thirst", 0)
			setElementData(localPlayer, "customDeath", "Szomjan halt")
			setElementHealth(localPlayer,0)
			setElementData(localPlayer,"char:health",0)
		else
			setElementData(localPlayer, "char:thirst", thirst - loss)
			setTimer(lossThirst, math.random(240000, 360000), 1)
		end

		if getElementData(localPlayer, "char:thirst") <= 20 then 
			outputChatBox(getServerPrefix("server", "OriginalRoleplay", 1).."Figyelj a szomjúság szintedre, mert alacsony!", 255, 255, 255, true)
			exports.oInfobox:addInfoBox("warning", "Figyelj a szomjúság szintedre, mert alacsony!")
		end
	end
end

function lossDrowsiness()
	if not (getElementData(localPlayer,"user:aduty") or getElementData(localPlayer,"adminJail.IsAdminJail") or getElementData(localPlayer,"pd:jail")) then 
		local drowsiness = tonumber(getElementData(localPlayer, "char:drowsiness"))
		local loss = math.random(2, 5)
		if loss > drowsiness then
			setElementData(localPlayer, "char:thirst", 0)
			setElementData(localPlayer, "customDeath", "Szomjan halt")
			setElementHealth(localPlayer,0)
			setElementData(localPlayer,"char:health",0)
		else
			setElementData(localPlayer, "char:thirst", thirst - loss)
			setTimer(lossDrowsiness, math.random(600000, 1000000), 1)
		end
	end
end

function lossHunger()
	if not (getElementData(localPlayer,"user:aduty") or getElementData(localPlayer,"adminJail.IsAdminJail") or getElementData(localPlayer,"pd:jail")) then 
		local hunger = tonumber(getElementData(localPlayer, "char:hunger"))
		--outputChatBox("a")
		local loss = math.random(2, 4)
		if loss > hunger then
			setElementData(localPlayer, "char:hunger", 0)
			setElementData(localPlayer, "customDeath", "Éhség")
			setElementHealth(localPlayer,0)
			setElementData(localPlayer,"char:health",0)
		else
			setElementData(localPlayer, "char:hunger", hunger - loss)
			setTimer(lossHunger, math.random(420000, 600000), 1)
		end

		if getElementData(localPlayer, "char:hunger") <= 20 then 
			outputChatBox(getServerPrefix("server", "OriginalRoleplay", 1).."Figyelj az éhség szintedre, mert alacsony!", 255, 255, 255, true)
			exports.oInfobox:addInfoBox("warning", "Figyelj az éhség szintedre, mert alacsony!")
		end
	end
end



local bodypartNames = {
    [3] = "Mellkason",
    [4] = "Seggen",
    [5] = "Bal kézen",
    [6] = "Jobb kézen",
    [7] = "Bal lábon",
    [8] = "Jobb lábon",
    [9] = "Fejen",
}

addEvent("sendKillLog", true)
addEventHandler("sendKillLog", localPlayer, function(player, killer, weapon, bodypart)
	if getElementData(localPlayer, "user:admin") >= 2 then
		if not getElementData(localPlayer, "showAlogs") then 
			local x, y, z = getElementPosition(player)
			local date = getDate("year") .. "." .. getDate("month").. "." .. getDate("monthday") .. "." .. getDate("hour") .. ":" .. getDate("minute") .. ":" .. getDate("second")
			if killer then
				local killer = (getElementType(killer) == "player") and killer or getVehicleOccupant(killer)
				if getPlayerName(killer) then
					outputChatBox("#2379cf["..date.."]: #e97619"..getPlayerName(killer):gsub("_", " ").."#FFFFFF ["..getElementData(killer, "playerid").."] megölte #e97619"..getPlayerName(player):gsub("_", " ").."#FFFFFF-t. ["..getWeaponNameFromID(weapon).."] ["..(bodypartNames[bodypart] or "ismeretlen").."]", 255, 255, 255, true)
				else 
					--outputChatBox(getElementType(killer))
					outputChatBox("#2379cf["..date.."]: #e97619Ismeretlen [Object]#FFFFFF megölte #e97619"..getPlayerName(player):gsub("_", " ").."#FFFFFF ["..getElementData(player, "playerid").."].  ("..getZoneName(x, y, z, true)..") ["..getWeaponNameFromID(weapon).."] ["..(bodypartNames[bodypart] or "ismeretlen").."]", 255, 255, 255, true)
				end
			else
				outputChatBox("#2379cf["..date.."]: #e97619"..getPlayerName(player):gsub("_", " ").."#FFFFFF ["..getElementData(player, "playerid").."] meghalt (Oka: ".. getElementData(player, "customDeath")..").", 255, 255, 255, true)
			end
		end
	end
end)


addEventHandler("onClientPlayerWasted", localPlayer, function()
    setElementData(localPlayer, "char:armor", 0)
	setElementData(localPlayer, "char:health", 0)
end)

addEventHandler("onClientPlayerDamage", localPlayer, function(attacker, weapon, bodypart)
    if (getElementData(localPlayer,"user:aduty") or getElementData(localPlayer,"adminJail.IsAdminJail") or getElementData(localPlayer,"pd:jail")) then
		cancelEvent()
	elseif bodypart == 9 then
		if not (weapon == 23) then
			triggerServerEvent("killPlayer", localPlayer, attacker, weapon, 9)
		end
    else
        setElementData(localPlayer, "char:health", getElementHealth(localPlayer))
        setElementData(localPlayer, "char:armor", getPedArmor(localPlayer))
        setElementData(localPlayer, "char:dmg", true)
		if isTimer(dmgTimer) then killTimer(dmgTimer) end
		dmgTimer = setTimer(function()
			setElementData(localPlayer, "char:dmg", false)
		end, 3000, 1)
    end
end)

addCommandHandler("getpos", function()
	if getElementData(localPlayer, "user:admin") > 1 then
		local x, y, z = getElementPosition(localPlayer)
		local rx, ry, rz = getElementRotation(localPlayer)
		outputChatBox("Pozició: "..serverColor..x.."#ffffff, "..serverColor..y.."#ffffff, "..serverColor..z, 255, 255, 255, true)
		outputChatBox("Rotáció: "..serverColor..rx.."#ffffff, "..serverColor..ry.."#ffffff, "..serverColor..rz, 255, 255, 255, true)
		outputChatBox("Interior: "..serverColor..getElementInterior(localPlayer).."#ffffff Dimenzió "..serverColor..getElementDimension(localPlayer), 255, 255, 255, true)
	end
end)

addCommandHandler("getcampos", function()
	if getElementData(localPlayer, "user:admin") > 1 then
		local x, y, z, lx, ly, lz = getCameraMatrix()
		outputChatBox(serverColor.."Camera Matrix: #ffffff"..x..","..y..","..z..","..lx..","..ly..","..lz,255,255,255,true)
	end
end)

addCommandHandler("pay", function(cmd, target, amount)
	local amount = tonumber(amount)
	if target and amount and math.floor(amount) > 0 then
		local amount = math.floor(amount)
		local target, targetName = getPlayerFromPartialName(localPlayer, target, false, 0)
		if not (target == localPlayer) then 
			if target then
				local x1, y1, z1 = getElementPosition(localPlayer)
				local x2, y2, z2 = getElementPosition(target)
				if getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) <= 20 then
					if getElementData(localPlayer, "char:money") >= amount then
						triggerServerEvent("sendMoney", localPlayer, target, amount)
						setElementData(localPlayer, "log:money", {getElementData(target, "char:id"), amount})
						exports.oChat:sendLocalMeAction("átad $"..amount.."-t "..targetName.."-nak/-nek.")
						outputChatBox("Adtál $"..amount.."-t "..targetName.."-nak/-nek.", 255, 255, 255)
					else
						outputChatBox("Nincs elég pénzed.", 255, 255, 255)
					end
				else
					outputChatBox("A játékos túl messze van tőled!", 255, 255, 255)
				end
			end
		end
	else
		outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID] [Összeg]", serverRGB[1], serverRGB[2], serverRGB[3], true)
	end
end)

function getNetworkConnection()
    if getNetworkStats().packetlossLastSecond < 5 then
        return true
    end
    return false
end

--[[addCommandHandler("getinfo", function()
	for k, v in pairs(dxGetStatus()) do
		outputConsole(k..": "..tostring(v))
	end
end)]]

--fp--
local root = getRootElement()
local localPlayer = getLocalPlayer()
local PI = math.pi

local isEnabled = false
local wasInVehicle = isPedInVehicle(localPlayer)

local mouseSensitivity = 0.1
local rotX, rotY = 0,0
local mouseFrameDelay = 0
local idleTime = 2500
local fadeBack = false
local fadeBackFrames = 50
local executeCounter = 0
local recentlyMoved = false
local Xdiff,Ydiff

function toggleCockpitView ()
	if (not isEnabled) then
		if not getElementData(localPlayer,"user:loggedin") then return end --Csak ha bejelentkezett.
		if getElementHealth(localPlayer) == 0 then return end
		isEnabled = true
		addEventHandler ("onClientPreRender", root, updateCamera)
		addEventHandler ("onClientCursorMove",root, freecamMouse)
	else
		isEnabled = false
		setCameraTarget (localPlayer, localPlayer)
		removeEventHandler ("onClientPreRender", root, updateCamera)
		removeEventHandler ("onClientCursorMove", root, freecamMouse)
	end
end
addCommandHandler("fp", toggleCockpitView)

addEvent("fp > toggleFPMode", true)
addEventHandler("fp > toggleFPMode", root, function()
	if isEnabled then 
		isEnabled = false
		removeEventHandler ("onClientPreRender", root, updateCamera)
		removeEventHandler ("onClientCursorMove", root, freecamMouse)
	end
end)

function updateCamera ()
	if (isEnabled) then
	
		local nowTick = getTickCount()

		if wasInVehicle and recentlyMoved and not fadeBack and startTick and nowTick - startTick > idleTime then
			recentlyMoved = false
			fadeBack = true
			if rotX > 0 then
				Xdiff = rotX / fadeBackFrames
			elseif rotX < 0 then
				Xdiff = rotX / -fadeBackFrames
			end
			if rotY > 0 then
				Ydiff = rotY / fadeBackFrames
			elseif rotY < 0 then
				Ydiff = rotY / -fadeBackFrames
			end
		end
		
		if fadeBack then
		
			executeCounter = executeCounter + 1
		
			if rotX > 0 then
				rotX = rotX - Xdiff
			elseif rotX < 0 then
				rotX = rotX + Xdiff
			end
		
			if rotY > 0 then
				rotY = rotY - Ydiff
			elseif rotY < 0 then
				rotY = rotY + Ydiff
			end
		
			if executeCounter >= fadeBackFrames then
				fadeBack = false
				executeCounter = 0
			end
		
		end
		
		local camPosXr, camPosYr, camPosZr = getPedBonePosition (localPlayer, 6)
		local camPosXl, camPosYl, camPosZl = getPedBonePosition (localPlayer, 7)
		local camPosX, camPosY, camPosZ = (camPosXr + camPosXl) / 2, (camPosYr + camPosYl) / 2, (camPosZr + camPosZl) / 2
		local roll = 0
		
		inVehicle = isPedInVehicle(localPlayer)
		
		if inVehicle then
			local rx,ry,rz = getElementRotation(getPedOccupiedVehicle(localPlayer))
			
			roll = -ry
			if rx > 90 and rx < 270 then
				roll = ry - 180
			end
			
			if not wasInVehicle then
				rotX = rotX + math.rad(rz)
				if rotY > -PI/15 then
					rotY = -PI/15 
				end
			end
			
			cameraAngleX = rotX - math.rad(rz)
			cameraAngleY = rotY + math.rad(rx)
			
			if getControlState("vehicle_look_behind") or ( getControlState("vehicle_look_right") and getControlState("vehicle_look_left") ) then
				cameraAngleX = cameraAngleX + math.rad(180)
			elseif getControlState("vehicle_look_left") then
				cameraAngleX = cameraAngleX - math.rad(90)
			elseif getControlState("vehicle_look_right") then
				cameraAngleX = cameraAngleX + math.rad(90)  
			end
		else
			local rx, ry, rz = getElementRotation(localPlayer)
			
			if wasInVehicle then
				rotX = rotX - math.rad(rz)
			end
			cameraAngleX = rotX
			cameraAngleY = rotY
		end
		
		wasInVehicle = inVehicle
		
		local freeModeAngleZ = math.sin(cameraAngleY)
		local freeModeAngleY = math.cos(cameraAngleY) * math.cos(cameraAngleX)
		local freeModeAngleX = math.cos(cameraAngleY) * math.sin(cameraAngleX)

		local camTargetX = camPosX + freeModeAngleX * 100
		local camTargetY = camPosY + freeModeAngleY * 100
		local camTargetZ = camPosZ + freeModeAngleZ * 100

		local camAngleX = camPosX - camTargetX
		local camAngleY = camPosY - camTargetY
		local camAngleZ = 0
		
		local angleLength = math.sqrt(camAngleX*camAngleX+camAngleY*camAngleY+camAngleZ*camAngleZ)

		local camNormalizedAngleX = camAngleX / angleLength
		local camNormalizedAngleY = camAngleY / angleLength
		local camNormalizedAngleZ = 0

		local normalAngleX = 0
		local normalAngleY = 0
		local normalAngleZ = 1

		local normalX = (camNormalizedAngleY * normalAngleZ - camNormalizedAngleZ * normalAngleY)
		local normalY = (camNormalizedAngleZ * normalAngleX - camNormalizedAngleX * normalAngleZ)
		local normalZ = (camNormalizedAngleX * normalAngleY - camNormalizedAngleY * normalAngleX)

		camTargetX = camPosX + freeModeAngleX * 100
		camTargetY = camPosY + freeModeAngleY * 100
		camTargetZ = camPosZ + freeModeAngleZ * 100

		setCameraMatrix (camPosX, camPosY, camPosZ, camTargetX, camTargetY, camTargetZ, roll)
	end
end

function freecamMouse (cX,cY,aX,aY)

	if isCursorShowing() or isMTAWindowActive() then
		mouseFrameDelay = 5
		return
	elseif mouseFrameDelay > 0 then
		mouseFrameDelay = mouseFrameDelay - 1
		return
	end
	
	startTick = getTickCount()
	recentlyMoved = true

	if fadeBack then
		fadeBack = false
		executeCounter = 0
	end

	local width, height = guiGetScreenSize()
	aX = aX - width / 2 
	aY = aY - height / 2
	
	rotX = rotX + aX * mouseSensitivity * 0.01745
	rotY = rotY - aY * mouseSensitivity * 0.01745

	local pRotX, pRotY, pRotZ = getElementRotation (localPlayer)
	pRotZ = math.rad(pRotZ)
	
	if rotX > PI then
		rotX = rotX - 2 * PI
	elseif rotX < -PI then
		rotX = rotX + 2 * PI
	end
	
	if rotY > PI then
		rotY = rotY - 2 * PI
	elseif rotY < -PI then
		rotY = rotY + 2 * PI
	end

	if isPedInVehicle(localPlayer) then
		if rotY < -PI / 4 then
			rotY = -PI / 4
		elseif rotY > -PI/15 then
			rotY = -PI/15
		end
	else
		if rotY < -PI / 4 then
			rotY = -PI / 4
		elseif rotY > PI / 2.1 then
			rotY = PI / 2.1
		end
	end
end

local screenSize_X, screenSize_Y = guiGetScreenSize()

function pedLookAt()
   local x, y, z = getWorldFromScreenPosition(screenSize_X / 2, screenSize_Y / 2, 15)
   setPedLookAt(localPlayer, x, y, z, -1, 0)
end
--setTimer(pedLookAt, 120, 0)

-- DISABLE PEDVOICE 

function disableOnePedVoice(element)
	setPedVoice(element, "PED_TYPE_DISABLED")
end

function disableAllElementVoice()
	for k, v in ipairs(getElementsByType("ped")) do 
		disableOnePedVoice(v)
	end

	for k, v in ipairs(getElementsByType("player")) do 
		disableOnePedVoice(v)
	end
end
addEventHandler("onClientResourceStart", resourceRoot, disableAllElementVoice)

addEventHandler("onClientElementStreamIn", root, function()
	if getElementType(source) == "player" or getElementType(source) == "ped" then 
		disableOnePedVoice(source)
	end 
end)