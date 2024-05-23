local screenX, screenY = guiGetScreenSize()
local panelW, panelH = 250, 130
local panelX, panelY = screenX/2 - panelW/2, screenY/2 - panelH/2

local price = 25

local core = exports.oCore
color, r, g, b = core:getServerColor()
color2, red1, red2, red3 = core:getColor("red-dark")

local bollards = {}
local bollardsLOD = {}
local borderColShape = {}
local borderState = {}
local borderAnimation = {}

local borderOffsetZ = 1.5
local borderOpenTime = 2000
local borderCloseTime = 1500

local borderPedSkins = {265, 266, 267, 277, 278, 288}

function rotateAround(angle, x, y, x2, y2)
	local theta = math.rad(angle)
	local rotatedX = x * math.cos(theta) - y * math.sin(theta) + (x2 or 0)
	local rotatedY = x * math.sin(theta) + y * math.cos(theta) + (y2 or 0)
	return rotatedX, rotatedY
end

local font = exports.oFont:getFont("condensed", 12);

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		for i = 1, #availableBorders do
			local datas = availableBorders[i]

			bollards[i] = {}
			bollardsLOD[i] = {}
			
			for k, v in ipairs(borderOffset[datas[13]]) do
				local rotatedX, rotatedY = rotateAround(datas[4], v[1], v[2])
				
				bollards[i][k] = createObject(1214, datas[1] + rotatedX, datas[2] + rotatedY, datas[3])
				bollardsLOD[i][k] = createObject(1214, datas[1] + rotatedX, datas[2] + rotatedY, datas[3], 0, 0, 0, true)
				
				setLowLODElement(bollards[i][k], bollardsLOD[i][k])
				setObjectScale(bollards[i][k], 1)
				setObjectBreakable(bollards[i][k], false)
				setElementFrozen(bollards[i][k], true)
			end
			

			
			borderColShape[i] = {
				[1] = createColSphere(datas[5], datas[6], datas[7], datas[8]),
				[2] = createColSphere(datas[9], datas[10], datas[11], datas[12])
			}
			
			setElementData(borderColShape[i][1], "borderId", i)
			setElementData(borderColShape[i][2], "borderId", i)
			
			borderState[i] = getElementData(resourceRoot, "border." .. i .. ".state")
            setElementData(resourceRoot, "border." .. i .. ".mode", 1)
			borderAnimation[i] = 0

			local borderPed = createPed(borderPedSkins[math.random(1, #borderPedSkins)], unpack(borderPedPositions[i]))
			setElementFrozen(borderPed, true)
			setElementData(borderPed, "ped:name", "Határőr", false)
			setElementData(borderPed, "invulnerable", true)
		end
	end
)

addEventHandler("onClientElementDataChange", getResourceRootElement(),
	function (dataName, oldValue)
		if string.find(dataName, "border.") then
			local borderId = tonumber(gettok(dataName, 2, "."))
            --outputChatBox(borderId)
			if borderId then
				if availableBorders[borderId] then
					local dataType = gettok(dataName, 3, ".")
                    
					if dataType == "state" then
						borderState[borderId] = getElementData(source, dataName)
						borderAnimation[borderId] = getTickCount()
					elseif dataType == "mode" then
						local dataValue = getElementData(source, dataName) or 1

						if dataValue == 1 or dataValue == 3 then
							borderState[borderId] = false
						elseif dataValue == 2 then
							borderState[borderId] = true
						end
						
						borderAnimation[borderId] = getTickCount()
					end
				end
			end
		end
	end
)

addEventHandler("onClientRender", getRootElement(),
	function ()
		local now = getTickCount()

		for k, v in pairs(borderAnimation) do
			if now <= v + borderOpenTime then
				local z = 0

				if borderState[k] then
					z = interpolateBetween(0, 0, 0, borderOffsetZ, 0, 0, (now - v) / borderOpenTime, "InQuad")
				else
					z = interpolateBetween(borderOffsetZ, 0, 0, 0, 0, 0, (now - v) / borderCloseTime, "InQuad")
				end

				for k2, v2 in pairs(bollards[k]) do
					local x, y = getElementPosition(v2)

					if k2 < #bollards[k] then
						setElementPosition(v2, x, y, availableBorders[k][3] - z)
					else
						setElementPosition(v2, x, y, availableBorders[k][3] - z)
					end
				end
			end
		end
	end
)

function rgbToHex(r, g, b)
	return string.format("#%.2X%.2X%.2X", r, g, b)
end

function isOfficer()
    local pFaction = getElementData(localPlayer, "char:duty:faction") or 0
    if pFaction > 0 then 
        if exports.oDashboard:getFactionType(pFaction) == 1 then 
            return true
        else
            return false
        end
    else 
        return false
    end
    return false
end

addCommandHandler("border",
	function (commandName, mode, type)
		if isOfficer(localPlayer) or getElementData(localPlayer, "user:admin") >= 8 then
			mode = tonumber(mode)

			if not (mode and mode >= 1 and mode <= 3) then
				outputChatBox(core:getServerPrefix("red-dark", "Határ", 3).."/" .. commandName .. " [Mód (1/2/3)] <Opcionális: all>", 255, 255, 255, true)
				outputChatBox(core:getServerPrefix("red-dark", "Határ", 3).."Automatikus(1), Nyitva(2), Zárva(3)", 255, 255, 255, true)
			else
                if type == "all" then 
                    for i = 1, #availableBorders do
                        setElementData(resourceRoot, "border." .. i .. ".mode", mode)
                        if mode == 2 then
                            setElementData(resourceRoot, "border." .. i .. ".state", true)
                        elseif mode == 1 or mode == 3 then
                            setElementData(resourceRoot, "border." .. i .. ".state", false)
                        end
                    end
                    triggerServerEvent("warnAboutBorderSet2", localPlayer, getElementData(localPlayer, "char:name"), mode)
                else
                    local borderId = false

                    for k, v in pairs(borderColShape) do
                        if isElementWithinColShape(localPlayer, v[1]) then
                            borderId = getElementData(v[1], "borderId")
                            break
                        elseif isElementWithinColShape(localPlayer, v[2]) then
                            borderId = getElementData(v[2], "borderId")
                            break
                        end
                    end

                    if borderId then
                        setElementData(resourceRoot, "border." .. borderId .. ".mode", mode)

                        if mode == 2 then
                            setElementData(resourceRoot, "border." .. borderId .. ".state", true)
                        elseif mode == 1 or mode == 3 then
                            setElementData(resourceRoot, "border." .. borderId .. ".state", false)
                        end

                        triggerServerEvent("warnAboutBorderSet", localPlayer, getElementData(localPlayer, "char:name"), borderId, mode)
                    else
                        outputChatBox(core:getServerPrefix("red-dark", "Határ", 3).."Csak a határ közelében használhatod ezt a parancsot! (ColShape)", 255, 255, 255, true)
                    end
                end
			end
        else 
            outputChatBox(core:getServerPrefix("red-dark", "Határ", 3).."Nem vagy rendvédelmi szervezet tagja, vagy nem vagy szolgálatban.", 255, 255, 255, true) 
		end
	end
)

addEvent("warnAboutBorderSet", true)
addEventHandler("warnAboutBorderSet", getRootElement(),
	function (playerName, borderId, set)
		if isOfficer(localPlayer) or getElementData(localPlayer, "user:admin") >= 1 then
			if set == 2 or set == 3 then
				local state = "nyitva"

				if set == 3 then
					state = "zárva"
				end

				outputChatBox(core:getServerPrefix("blue-light-2", "Határ", 3) ..color .. playerName:gsub("_", " ") .. "#FFFFFF átállított egy határt manuálisra. ".. color .."(#" .. borderId .. " - " .. state .. ")", 255, 255, 255, true)
			elseif set == 1 then
				outputChatBox(core:getServerPrefix("blue-light-2", "Határ", 3) .. color ..playerName:gsub("_", " ") .. "#FFFFFF átállított egy határt automatikus nyitásra. ".. color .."(#" .. borderId .. ")", 255, 255, 255, true)
			end
		end
	end
)

addEvent("warnAboutBorderSet2", true)
addEventHandler("warnAboutBorderSet2", getRootElement(),
	function (playerName, set)
		if isOfficer(localPlayer) or getElementData(localPlayer, "user:admin") >= 1 then
            local state = "nyitva"
            if set == 2 or set == 3 then
                if set == 3 then
                    state = "zárva"
                end
                outputChatBox(core:getServerPrefix("blue-light-2", "Határ", 3).. color .. playerName:gsub("_", " ") .. "#FFFFFF átállította az összes határt manuálisra.  ".. color .."(" .. state .. ")", 255, 255, 255, true)
            elseif set == 1 then 
                outputChatBox(core:getServerPrefix("blue-light-2", "Határ", 3).. color .. playerName:gsub("_", " ") .. "#FFFFFF átállította az összes határt automatikus nyitásra.", 255, 255, 255, true)
            end
		end
	end
)

local borderWarns = true

addCommandHandler("togborder",
	function ()
		if borderWarns then
			outputChatBox(core:getServerPrefix("red-dark", "Határ", 3) .."Sikeresen kikapcsoltad az határ értesítéseket!", 255, 255, 255, true)
			borderWarns = false
		else
			outputChatBox(core:getServerPrefix("red-dark", "Határ", 3) .."Sikeresen bekapcsoltad az határ értesítéseket!", 255, 255, 255, true)
			borderWarns = true
		end
	end
)

addEvent("warnAboutBorderCross", true)
addEventHandler("warnAboutBorderCross", getRootElement(),
	function (vehicle, isWanted, wantedData)
		if isElement(vehicle) and isOfficer(localPlayer) and borderWarns then
			local plateText = getVehiclePlateText(vehicle)

			if plateText then
				local plateParts = split(plateText, "-")
				
				plateText = {}

				for i = 1, #plateParts do
					if utf8.len(plateParts[i]) >= 1 then
						table.insert(plateText, plateParts[i])
					end
				end
                if not isWanted then 
				    outputChatBox(core:getServerPrefix("blue-light-2", "Határ", 3) .."Egy jármű átlépte a határt! Rendszáma: "..color .. table.concat(plateText, "-"), 255, 255, 255, true)
				    local r1, g1, b1, r2, g2, b2 = getVehicleColor(vehicle, true)
				    outputChatBox(core:getServerPrefix("blue-light-2", "Határ", 3) .."Típus: ".. color .. exports.oVehicle:getModdedVehicleName(getElementModel(vehicle)) .. "#FFFFFF Színek: " .. rgbToHex(r1, g1, b1) .. "szín1 " .. rgbToHex(r2, g2, b2) .. "szín2", 255, 255, 255, true)
                else 
                    local r1, g1, b1, r2, g2, b2 = getVehicleColor(vehicle, true)
                    outputChatBox(core:getServerPrefix("blue-light-2", "Határ", 3) .."Egy körözött jármű átlépte a határt! Rendszáma: "..color .. table.concat(plateText, "-"), 255, 255, 255, true)
                    outputChatBox(core:getServerPrefix("blue-light-2", "Határ", 3) .."Típus: ".. color .. exports.oVehicle:getModdedVehicleName(getElementModel(vehicle)) .. "#FFFFFF Színek: " .. rgbToHex(r1, g1, b1) .. "szín1 " .. rgbToHex(r2, g2, b2) .. "szín2", 255, 255, 255, true)
                    outputChatBox(core:getServerPrefix("blue-light-2", "Határ", 3) .."Körözési indok: #e0361f" ..wantedData["reason"], 255, 255, 255, true)
                end
            end
		end
	end
)

local currentBorderId = 1
local currentBorderColShapeId = 2

addEventHandler("onClientColShapeHit", getResourceRootElement(),
	function (theElement, matchingDimension)
		if theElement == localPlayer and matchingDimension then
			local borderId = getElementData(source, "borderId")

			if borderId then
				local pedveh = getPedOccupiedVehicle(localPlayer)

				if isElement(pedveh) then
					if not getElementData(pedveh, "borderTargetColShapeId") then
						if not getElementData(resourceRoot, "border." .. borderId .. ".state") and getElementData(resourceRoot, "border." .. borderId .. ".mode") == 1 then
							if source == borderColShape[borderId][2] then
								return
							end
                            setElementFrozen(pedveh, true)
                            if not isCursorShowing() then
                                showCursor(true)
                            end
							currentBorderId = borderId
							currentBorderColShapeId = 2
                            addEventHandler("onClientRender", getRootElement(), drawBorder)
                            addEventHandler("onClientClick", getRootElement(), clickBorder)
                            addEventHandler("onClientKey", getRootElement(), keyBorder)
						end
					end
				end
			end
		end
	end
)

addEventHandler("onClientColShapeLeave", getResourceRootElement(),
	function (theElement)
		if theElement == localPlayer then
			if getElementData(source, "borderId") then
				currentBorderId = false
				currentBorderColShapeId = false
                
			end
		end

		if isElement(theElement) then
			if getElementType(theElement) == "vehicle" then
				if getVehicleController(theElement) == localPlayer then
					local targetColShapeId = getElementData(theElement, "borderTargetColShapeId")
                    --outputChatBox(getElementType(theElement))
					if targetColShapeId then
						local borderId = getElementData(source, "borderId")
                      --  outputChatBox(targetColShapeId)
						if borderId then
							if source == borderColShape[borderId][targetColShapeId] then
								triggerServerEvent("closeTheBorder", localPlayer, borderId, targetColShapeId, theElement)
							end
						end
					end
				end
			end
		end
	end
)

function drawBorder()
    core:drawWindow(panelX, panelY, panelW, panelH, "Határátkelés")
    dxDrawText("Át szeretnél kelni a határon\n"..color.. price .."$#dcdcdc-ért?", screenX/2,panelY,screenX/2,panelY+100,tocolor(220, 220, 220, 255),0.85,font,"center","center", false, false,false, true)
    core:dxDrawButton(panelX + 5, panelY+ panelH - 25 - 33, panelW - 10, 25, r,g,b,255, "Igen", tocolor(255, 255, 255, 255), 0.85, font, false, tocolor(0, 0, 0, 255))
    core:dxDrawButton(panelX + 5, panelY+ panelH - 25 - 5, panelW - 10, 25, red1, red2, red3,255, "Nem", tocolor(255, 255, 255, 255), 0.85, font, false, tocolor(0, 0, 0, 255))
end

local theTimer = false

function clickBorder(button, state)
    if button == "left" and state == "down" then 
        if core:isInSlot(panelX + 5, panelY+ panelH - 20 - 30, panelW - 10, 20) then  -- igen
            if isTimer(theTimer) then return end
            local pedveh = getPedOccupiedVehicle(localPlayer)
            --outputChatBox("nyitas")
            triggerServerEvent("openTheBorder", localPlayer, currentBorderId, currentBorderColShapeId, pedveh, price)
            currentBorderId = false
            currentBorderColShapeId = false
            removeEventHandler("onClientRender", getRootElement(), drawBorder)
            removeEventHandler("onClientClick", getRootElement(), clickBorder)
            removeEventHandler("onClientKey", getRootElement(), keyBorder)
            setElementFrozen(pedveh, false)
            if isCursorShowing() then
                showCursor(false)
            end
            theTimer = setTimer(function() end, 1000, 1)
        end        
        if core:isInSlot(panelX + 5, panelY+ panelH - 20 - 5, panelW - 10, 20) then  -- nem
            if isTimer(theTimer) then return end
            local pedveh = getPedOccupiedVehicle(localPlayer)
            currentBorderId = false
            currentBorderColShapeId = false
            removeEventHandler("onClientRender", getRootElement(), drawBorder)
            removeEventHandler("onClientClick", getRootElement(), clickBorder)
            removeEventHandler("onClientKey", getRootElement(), keyBorder)
            setElementFrozen(pedveh, false)
            if isCursorShowing() then
                showCursor(false)
            end
            theTimer = setTimer(function() end, 1000, 1)
        end
    end
end

function keyBorder(key,state)
    if key == "enter" or key == "num_enter" and state then 
        cancelEvent()
        if isTimer(theTimer) then return end
        
        local pedveh = getPedOccupiedVehicle(localPlayer)
        triggerServerEvent("openTheBorder", localPlayer, currentBorderId, currentBorderColShapeId, pedveh, price)
        currentBorderId = false
        currentBorderColShapeId = false
        removeEventHandler("onClientRender", getRootElement(), drawBorder)
        removeEventHandler("onClientClick", getRootElement(), clickBorder)
        removeEventHandler("onClientKey", getRootElement(), keyBorder)
        setElementFrozen(pedveh, false)
        if isCursorShowing() then
            showCursor(false)
        end
        theTimer = setTimer(function() end, 1000, 1)
    elseif key == "backspace" and state then
        if isTimer(theTimer) then return end
        local pedveh = getPedOccupiedVehicle(localPlayer)
        currentBorderId = false
        currentBorderColShapeId = false
        removeEventHandler("onClientRender", getRootElement(), drawBorder)
        removeEventHandler("onClientClick", getRootElement(), clickBorder)
        removeEventHandler("onClientKey", getRootElement(), keyBorder)
        setElementFrozen(pedveh, false)
        if isCursorShowing() then
            showCursor(false)
        end
        theTimer = setTimer(function() end, 1000, 1)
    end
end

addCommandHandler("gate2", function()
    if isOfficer(localPlayer) or getElementData(localPlayer, "user:admin") >= 8 then
        local borderId = false

        for k, v in pairs(borderColShape) do
            if isElementWithinColShape(localPlayer, v[1]) then
                borderId = getElementData(v[1], "borderId")
                break
            elseif isElementWithinColShape(localPlayer, v[2]) then
                borderId = getElementData(v[2], "borderId")
                break
            end
        end
        if borderId then 
            if getElementData(resourceRoot,"border.".. borderId ..".state") then 
                triggerServerEvent("closeTheBorderManual", localPlayer, borderId)
            else
                triggerServerEvent("openTheBorderManual", localPlayer, borderId)
            end
        else
            outputChatBox(core:getServerPrefix("red-dark", "Határ", 3).."Csak a határ közelében használhatod ezt a parancsot! (ColShape)", 255, 255, 255, true)
        end
    end
end)

