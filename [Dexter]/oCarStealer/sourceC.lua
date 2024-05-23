local screenX, screenY = guiGetScreenSize()
local myX, myY = 1768, 992
local pw,ph = 600,300
local font = exports["oFont"]
local interface = exports["oInterface"]
local pedElement = false
local pedRot = 0
local scene = 1
local dialogLong1 = 1
local dialogTextCount = 1
local dialogType = "start"
local dialogTickCount = getTickCount()
local prompt = false
local successClick = false
local talking = false
local randomPoint = 0
local zoneName = "Los Santos"
local vehicleName = "Savanna"
local vehicleColorText = "Piros"
local elements = {}
local progressBarAnimType = "open"
local progressBarAnimTick = getTickCount()
local componentName = ""
local progressBarText = ""
local progressTime = 0
local tick = getTickCount()
local vehicles = {}
local timers = {}
local isTalking = false
local randMoney = 0
local factoryZone = getZoneName(factoryMarkerX, factoryMarkerY, factoryMarkerZ)

local destinationData = {}
local vehicleX = 0
local vehicleY = 0
local osszesen = 0
local osszesenKesz = 0

local stealerScene = 0
local showedStripe = false
local factoryPark = false
local pedName = ""
local blipElement = false
local pedPosition = false

setElementData(localPlayer, "carStealerScene", 0)
setElementData(localPlayer,"showedStripe",false)
setElementData(localPlayer,"factoryPark",false)
setElementData(localPlayer,"componentInHand",false)
setElementData(localPlayer, "char:stealer", false)

local _dxDrawText = dxDrawText 
function dxDrawText(text, x, y, w, h, ...)
    _dxDrawText(text, x, y, x + w, y + h, ...)
end

addEventHandler("onClientElementDataChange", getRootElement(), function(dataName)
    if getElementType(source) == "player" and source == localPlayer then
        if dataName == "carStealerScene" then 
            stealerScene = getElementData(source, dataName)
        end        
        if dataName == "showedStripe" then 
            showedStripe = getElementData(source, dataName)
        end        
        if dataName == "factoryPark" then 
            factoryPark = getElementData(source, dataName)
        end
    end
end)

addEventHandler("onClientClick", getRootElement(), function(button, state, absX, absY, worldX, worldY, worldZ, clickElement)
    if button == "right" and state == "down" then 
        if clickElement and getElementType(clickElement) == "ped" and getElementData(clickElement, "isCarStealerPed") then
            pedElement = clickElement
            pedName = getElementData(pedElement, "ped:name")
            pedPosition = Vector3(getElementPosition(pedElement))
            if not isTalking then
                if getElementData(pedElement, "isSpeakToStealer") then outputChatBox(core:getServerPrefix("server", "Autólopás", 2).."Michael most el foglalt próbáld meg később!", 255, 255, 255, true) return end
                if getElementData(localPlayer,"carStealerScene") == 0 then 
                    triggerServerEvent("startStealer",localPlayer, localPlayer)
                elseif getElementData(localPlayer,"carStealerScene") == 1 then 
                    --outputChatBox("asd")
                    --
                    if destinationData and destinationData.colShapeBounds then
                        if checkAABB(getElementData(localPlayer,"veh:stealedCarElement"), destinationData.colShapeBounds) then
                                if getElementData(getElementData(localPlayer,"veh:stealedCarElement"), "veh:stealedCarOwner") == localPlayer then
                                    startTalkAnimation()
                                    talkingAnimation("scene1")
                                else
                                    outputChatBox(core:getServerPrefix("server", "Autólopás", 2).."Ez nem a te kocsid!", 255, 255, 255, true)
                                end
                        else
                            outputChatBox(core:getServerPrefix("server", "Autólopás", 2).."Nincs a kijelölt ponton a kocsi!", 255, 255, 255, true)
                        end
                    else 
                        outputChatBox(core:getServerPrefix("server", "Autólopás", 2).."Nincs a kijelölt ponton a kocsi!", 255, 255, 255, true)
                    end
                elseif getElementData(localPlayer,"carStealerScene") == 2 then 
                    --if destinationData and destinationData.colShapeBounds then
                        --if checkFactory(getElementData(localPlayer,"veh:stealedCarElement"), destinationData.colShapeBounds) then
                            if osszesenKesz >= osszesen then 
                                startTalkAnimation()
                                talkingAnimation("sence2")
                            else 
                                outputChatBox(core:getServerPrefix("server", "Autólopás", 2).."Még nem szerelted le teljesen a kocsit hiányzó elem: ".. osszesen - osszesenKesz .." db!", 255, 255, 255, true)
                            end
                       -- else
                        --    outputChatBox(core:getServerPrefix("server", "Autólopás", 2).."Nincs a kijelölt ponton a kocsi!", 255, 255, 255, true)
                        --end
                    --else
                    --    outputChatBox(core:getServerPrefix("server", "Autólopás", 2).."Nincs a kijelölt ponton a kocsi!", 255, 255, 255, true)
                    --end
                end
            --if checkAABB(getElementData(localPlayer,"veh:stealedCarElement"), destinationData.colShapeBounds) then
            end
        end
    end
end)

addEvent("stealerHandler", true)
addEventHandler("stealerHandler", getRootElement(), function(state)
    --outputChatBox("asd")
    --print(state)
    if state then 
        startTalkAnimation()
        talkingAnimation("start")

    else
        outputChatBox(core:getServerPrefix("server", "Autólopás", 2).."Csak 5 óránként tudod használni!", 255, 255, 255, true)
    end
end)

local animation_tick = getTickCount()
local animation_state = "open"
local talk_text = {"nan", 1}
local inTalk = false
local pC1x, pC1y, pC1z, pC2x, pC2y, pC2z
local startCamera = {}

function startTalkAnimation() 
   -- setElementAlpha(localPlayer, 0)
   setElementFrozen(localPlayer, true)
    pC1x, pC1y, pC1z, pC2x, pC2y, pC2z = getCameraMatrix()
    startCamera = {getCameraMatrix()}
    local bossPedPos = Vector3(getElementPosition(pedElement))
    if isElement(blipElement) then 
        destroyElement(blipElement)
    end
    --moveCameraToNPC(pedElement, 1000)
    local camNow = {getCameraMatrix()}
    local pedPos = {getElementPosition(pedElement)}
    local playerPos = {getElementPosition(localPlayer)}

    local pedRot = getPedRotation(pedElement)

    local addX, addY = -4, 0

    if pedRot > 0 and pedRot <= 90 then 
        addX = 0
        addY = -4
    elseif pedRot > 90 and pedRot <= 180 then 
        addX = -4
        addY = 0
    elseif pedRot > 180 and pedRot <= 270 then 
        addX = 0
        addY = 4
    elseif pedRot > 270 and pedRot <= 360 then 
        addX = 4
        addY = 0
    end

    smoothMoveCamera(camNow[1], camNow[2], camNow[3], camNow[4], camNow[5], camNow[6], pedPos[1] + addX, pedPos[2] + addY, pedPos[3] + 0.7, pedPos[1], pedPos[2], pedPos[3] + 0.7, 2000)

    animation_state = "open"
    animation_tick = getTickCount() 
    addEventHandler("onClientRender", root, renderTalkPanel)
    addEventHandler("onClientClick", getRootElement(), talkPanelClick)

    setElementFrozen(localPlayer, true)

    showChat(false)
    interface:toggleHud(true)
    setElementData(pedElement, "isSpeakToStealer", true)
    isTalking = true
    inTalk = true
end


function stopTalkAnimation()
    --setElementAlpha(localPlayer, 255)
    
    removeEventHandler("onClientRender", root, renderTalkPanel) 
    removeEventHandler("onClientClick", getRootElement(), talkPanelClick)
    local camNow = {getCameraMatrix()}
    smoothMoveCamera(camNow[1], camNow[2], camNow[3], camNow[4], camNow[5], camNow[6], startCamera[1], startCamera[2], startCamera[3], startCamera[4], startCamera[5], startCamera[6], 2000)
    animation_state = "close"
    animation_tick = getTickCount() 
    prompt = false 
    talking = false
    randomPoint = 0
    zoneName = "Los Santos"
    vehicleName = "Savanna"
    vehicleColorText = "Piros"
    successClick = false
    showChat(true)
    setPedAnimation(pedElement)
    interface:toggleHud(false)
    unbindKey("backspace", "up", stoppingAnimation)
    setPedAnimation(pedElement,nil,nil)
    if dialogTextCount == "success" and getElementData(localPlayer, "carStealerScene") == 1 then
        setElementData(localPlayer, "carStealerScene", 2) 
    end
    if dialogTextCount == "decline" and getElementData(localPlayer, "carStealerScene") == 1 then 
        --randMoney = math.random(scene1MinPrice, scene1MaxPrice)
        setElementData(localPlayer,"showedStripe",false)
        setElementData(localPlayer,"factoryPark",false)
        setElementData(localPlayer,"componentInHand",false)
        setElementData(localPlayer, "carStealerScene", 0)
       -- outputChatBox("itt a pénzed" .. randMoney)
        outputChatBox(core:getServerPrefix("server", "Autólopás", 2).."Sikeresen le szállítottad a járművet!", 255, 255, 255, true)
        outputChatBox(core:getServerPrefix("server", "Autólopás", 2).."Fizetséged: "..randMoney.." $!", 255, 255, 255, true)
        setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money")+ randMoney)
    end    
    if dialogTextCount == 3 and getElementData(localPlayer, "carStealerScene") == 2 then 
        --randMoney = math.random(scene2MinPrice, scene2MaxPrice)
        setElementData(localPlayer,"showedStripe",false)
        setElementData(localPlayer,"factoryPark",false)
        setElementData(localPlayer,"componentInHand",false)
        setElementData(localPlayer, "carStealerScene", 0)
        outputChatBox(core:getServerPrefix("server", "Autólopás", 2).."Sikeresen le szállítottad és szét szerelted a járművet!", 255, 255, 255, true)
        outputChatBox(core:getServerPrefix("server", "Autólopás", 2).."Fizetséged: "..randMoney.." $!", 255, 255, 255, true)
        setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money")+ randMoney)
        triggerServerEvent("destroyTheCar", localPlayer, localPlayer)
    end


    setTimer(function()
        setElementFrozen(localPlayer, false)
        setCameraTarget(localPlayer)
        isTalking = false
        setElementData(pedElement, "isSpeakToStealer", false)
        pedElement = false
    end,2000,1)
    --setElementFrozen(localPlayer, false)
end

function stoppingAnimation()
    if talking then 
        dialogLong1 = 1
        dialogTextCount = "backspace"
       -- stopTalkAnimation()
    end
end

function talkingAnimation(value)
    local allowed = false
    for k,v in pairs(factionId) do
        if exports["oDashboard"]:isPlayerFactionMember(v) then 
            allowed = true
        end
    end
    setPedAnimation(pedElement, "GHANDS", "gsign5", -1, true, false, false, false)
    if allowed then
        dialogLong1 = 1
        dialogTextCount = 1
        dialogType = value
        
        dialogTickCount = getTickCount()
        bindKey("backspace", "up", stoppingAnimation) 
    else 
        dialogLong1 = 1
        dialogTextCount = "noPermission"
        dialogType = value
        dialogTickCount = getTickCount()
    end
end


function renderTalkPanel()
    local alpha 
    
    if animation_state == "open" then 
        alpha = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - animation_tick)/1000, "Linear")
    else
        alpha = interpolateBetween(1, 0, 0, 0, 0, 0, (getTickCount() - animation_tick)/1000, "Linear")
    end



    dxDrawRectangle(0, 0, screenX, 100, tocolor(0, 0, 0, 255*alpha))
    dxDrawRectangle(0, screenY, screenX, -100, tocolor(0, 0, 0, 255*alpha))

    text = string.sub(texts[dialogType][dialogTextCount],1,dialogLong1)
    --iprint(texts[dialogType][dialogTextCount])
    if dialogTextCount == "success" and stealerScene == 0 then 
        text = string.gsub(text,"#s",zoneName)
        text = string.gsub(text,"#c",vehicleColorText)
        text = string.gsub(text,"#a",vehicleName)
    end
    if stealerScene == 1 then
        if dialogTextCount == "decline" then
            text = string.gsub(text,"#F",randMoney)
        end
        if dialogTextCount == "success" then
--            print("asd") 
            text = string.gsub(text,"#s",factoryZone)
        end
    end
    if dialogTextCount == 2 and stealerScene == 2 then 
        text = string.gsub(text,"#F",randMoney)
    end

    local elapsedTime = getTickCount() - dialogTickCount
    local progress = elapsedTime / 3579
    dialogLong = string.len(texts[dialogType][dialogTextCount])
    if dialogLong1 < dialogLong then
        dialogLong1 = dialogLong1 + 0.85
        talking = false
    else 
        talking = true
        if progress > 1 and not prompt and not successClick then
            if dialogTextCount == "noPermission" or dialogTextCount == "backspace" then
                stopTalkAnimation()
            else
                nextFunc()
               -- print(dialogTextCount)
                if stealerScene == 0 or stealerScene == 1 then
                    if dialogTextCount == 3 then 
                        prompt = true
                    end
                elseif stealerScene == 1 then 
                    if dialogTextCount == "decline" then 
                        stopTalkAnimation()
                    end
                elseif stealerScene == 2 then 
                   -- print(dialogTextCount)
                    if dialogTextCount == 3 then 
                        stopTalkAnimation()
                    end
                end
            end
        end
        if dialogTextCount == "decline" then 
            
            if progress > 1 then 
                stopTalkAnimation()
                
            end
        elseif dialogTextCount == "success" then 
            if progress > 1.5 then 
                stopTalkAnimation()
            end
        end
        --setTimer(nextFunc,dialogLong,1)  
    end
    --print(progress)


    _dxDrawText(color.."[".. pedName.."]: #dcdcdc"..text, 0, screenY*0.9, screenX, screenY, tocolor(220, 220, 220, 255*alpha), 1, font:getFont("condensed", 15/myX*screenX), "center", "center", false, false, false, true)
    if prompt then 
        if stealerScene == 0 then
            core:dxDrawButton(screenX/2 - 150,screenY -150, 150, screenY*0.03, r, g, b, 200 * alpha, "Elfogadom", tocolor(255, 255, 255, 255 * alpha), 1, font:getFont("condensed", 15/myX*screenX), true, tocolor(0, 0, 0, 100 * alpha))
            core:dxDrawButton(screenX/2 + 5,screenY -150, 150, screenY*0.03, 245, 56, 56, 200 * alpha, "Nem fogadom el!", tocolor(255, 255, 255, 255 * alpha), 1, font:getFont("condensed", 15/myX*screenX), true, tocolor(0, 0, 0, 100 * alpha))
        elseif stealerScene == 1 then
            core:dxDrawButton(screenX/2 - 150,screenY -150, 150, screenY*0.03, r, g, b, 200 * alpha, "Igen", tocolor(255, 255, 255, 255 * alpha), 1, font:getFont("condensed", 15/myX*screenX), true, tocolor(0, 0, 0, 100 * alpha))
            core:dxDrawButton(screenX/2 + 5,screenY -150, 150, screenY*0.03, 245, 56, 56, 200 * alpha, "Kérem a pénzem!", tocolor(255, 255, 255, 255 * alpha), 1, font:getFont("condensed", 15/myX*screenX), true, tocolor(0, 0, 0, 100 * alpha))
        end
    end
end

function talkPanelClick(button, state)
    if prompt and talking then 
        if button == "left" and state == "down" then 
            if getElementData(localPlayer, "carStealerScene") == 0 then
                if core:isInSlot(screenX/2 - 150,screenY -150, 150, screenY*0.03) then  -- accept
                    randomPoint = math.random(1,#destinationPoints)
                    x,y,z = destinationPoints[randomPoint][1],destinationPoints[randomPoint][2],destinationPoints[randomPoint][3]
                    randomVehicleCount = math.random(1, #vehicleIds)
                    randomVehicleColor = math.random(1, #vehicleColor)
                    vehicleName = exports["oVehicle"]:getModdedVehName(vehicleIds[randomVehicleCount])
                    vehicleColorText = vehicleColor[randomVehicleColor][1]
                    zoneName = getZoneName(x,y,z)
                    successFunction(vehicleIds[randomVehicleCount], x, y, z, vehicleColor[randomVehicleColor][2], vehicleColor[randomVehicleColor][3], vehicleColor[randomVehicleColor][4])
                    dialogTickCount = getTickCount()
                    dialogLong1 = 1
                    dialogTextCount = "success"
                    successClick = true
                    prompt = false
                end
                if core:isInSlot(screenX/2 + 5,screenY -150, 150, screenY*0.03) then -- decline
                    dialogTickCount = getTickCount()
                    dialogLong1 = 1
                    dialogTextCount = "decline"
                    setElementData(localPlayer, "carStealerScene", 0)
                end
            elseif getElementData(localPlayer, "carStealerScene") == 1 then
                if core:isInSlot(screenX/2 - 150,screenY -150, 150, screenY*0.03) then  -- accept
                    dialogTickCount = getTickCount()
                    dialogLong1 = 1
                    dialogTextCount = "success"
                    successClick = true
                    prompt = false
                    setElementData(localPlayer,"showedStripe",false)
                    setElementData(localPlayer,"factoryPark",true)
                    outputChatBox(core:getServerPrefix("server", "Autólopás", 2).."Menj Michael garázsába és szedd szét a járművet!", 255, 255, 255, true)
                    blipElement = createBlip(factoryMarkerX, factoryMarkerY, factoryMarkerZ, 3)
                    setElementData(blipElement, "blip:name", "Michael garázsa")
                    for k,veh in ipairs(getElementsByType("vehicle")) do
                        if getElementData(veh, "veh:stealedCar") then 
                            for v in pairs ( getVehicleComponents(veh) ) do
                                if components[v] then
                                    osszesen = osszesen + 1
                                end
                            end
                        end
                    end
                    createFactoryPoint()
                end
                if core:isInSlot(screenX/2 + 5,screenY -150, 150, screenY*0.03) then -- decline
                    dialogTickCount = getTickCount()
                    dialogLong1 = 1
                    dialogTextCount = "decline"
                    successClick = true
                    prompt = false
                    scene1MinPrice = exports["oCarshop"]:getVehiclePriceInCarshop(getElementModel(getElementData(localPlayer,"veh:stealedCarElement")))/4/2
                    scene1MaxPrice = exports["oCarshop"]:getVehiclePriceInCarshop(getElementModel(getElementData(localPlayer,"veh:stealedCarElement")))/4
                    randMoney = math.random(scene1MinPrice, scene1MaxPrice)
                    
                    vehElement = checkAABB(getElementData(localPlayer,"veh:stealedCarElement"), destinationData.colShapeBounds)
                    triggerServerEvent("destroyTheCar", localPlayer, localPlayer)
                end
            end
        end
    end
end

function successFunction(modelId, posX, posY, posZ, vehicleColorR, vehicleColorG, vehicleColorB)
    outputChatBox(core:getServerPrefix("server", "Autólopás", 2).."A radaron megjelöltük a járművet amit el kell lopnod!", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Autólopás", 2).."Egy ".. vehicleColorText .. " ".. vehicleName.. "-t.", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Autólopás", 2).."Siess és hozd vissza Michael-nek, azután mondani fogja a további instrukciókat!", 255, 255, 255, true)
    triggerServerEvent("createStealedCar", localPlayer, localPlayer, modelId, posX, posY, posZ, vehicleColorR, vehicleColorG, vehicleColorB)
    setTimer(function()
        vehElement = getElementData(localPlayer, "veh:stealedCarElement")
        blipElement = createBlipAttachedTo(vehElement, 3)
        setElementData(blipElement, "blip:name", "Lopott Jármű: "..vehicleName)
    end,500,1)
    setTimer(function()
        setElementData(localPlayer,"carStealerScene",1)
        setElementData(localPlayer, "showedStripe", true)
        createDropPoint(1)
    end,6000,1)
end

function nextFunc()
    if dialogTextCount >= 1 then 
        dialogTickCount = getTickCount()
        dialogLong1 = 1
        dialogTextCount = dialogTextCount + 1
    end     
end

addEventHandler("onClientVehicleEnter",getRootElement(), function(thePlayer, seat)
    if thePlayer == localPlayer and seat == 0 then 
        if getElementData(source, "veh:stealedCar") and getElementData(localPlayer, "veh:stealedCarElement") == source then 
            if getElementData(localPlayer, "carStealerScene") == 1 then
                if isElement(blipElement) then 
                    destroyElement(blipElement)
                    blipElement = createBlip(pedPosition.x,pedPosition.y,pedPosition.z, 3)
                    setElementData(blipElement, "blip:name", "Michael")
                end
            end
        end
    end
end)

function createDropPoint(randNum)
    --print(randNum)
    local middleX, middleY = pedRandPositon.dropDown[randNum][1], pedRandPositon.dropDown[randNum][2]
    local parkingDetails = {middleX, middleY, pedRandPositon.dropDown[randNum][3], 7, 3}

    destinationData = {
		basePosition = {parkingDetails[1], parkingDetails[2], pedRandPositon.dropDown[randNum][3]},
		baseRotation = pedRandPositon.dropDown[randNum][4] + 90,
		parkingSizes = {parkingDetails[4], parkingDetails[5]},
	}

    rotated_x1, rotated_y1 = rotateAround(destinationData.baseRotation, -destinationData.parkingSizes[1] / 2, -destinationData.parkingSizes[2] / 2)
	local rotated_x2, rotated_y2 = rotateAround(destinationData.baseRotation, destinationData.parkingSizes[1] / 2, -destinationData.parkingSizes[2] / 2)
	local rotated_x3, rotated_y3 = rotateAround(destinationData.baseRotation, destinationData.parkingSizes[1] / 2, destinationData.parkingSizes[2] / 2)
	local rotated_x4, rotated_y4 = rotateAround(destinationData.baseRotation, -destinationData.parkingSizes[1] / 2, destinationData.parkingSizes[2] / 2)


	destinationData.colShape = createColPolygon(
		destinationData.basePosition[1],
		destinationData.basePosition[2],

		destinationData.basePosition[1] + rotated_x1,
		destinationData.basePosition[2] + rotated_y1,

		destinationData.basePosition[1] + rotated_x2,
		destinationData.basePosition[2] + rotated_y2,

		destinationData.basePosition[1] + rotated_x3,
		destinationData.basePosition[2] + rotated_y3,

		destinationData.basePosition[1] + rotated_x4,
		destinationData.basePosition[2] + rotated_y4
	)

    destinationData.colShapeBounds = {
		[1] = {destinationData.basePosition[1] + rotated_x2, destinationData.basePosition[2] + rotated_y2}, -- top right
		[2] = {destinationData.basePosition[1] + rotated_x3, destinationData.basePosition[2] + rotated_y3}, -- top left
		[3] = {destinationData.basePosition[1] + rotated_x1, destinationData.basePosition[2] + rotated_y1}, -- bottom right
		[4] = {destinationData.basePosition[1] + rotated_x4, destinationData.basePosition[2] + rotated_y4} -- bottom left
	}
    --addEventHandler("onClientRender", root, renderParkingZone)
end

function checkAABB(vehicleElement, colshapeBounds, requiredRotation)
	if not isElement(vehicleElement) then
		return false
	end

	if not getElementData(vehicleElement, "veh:stealedCar") then
		return false
	end

	local vehicleMatrix = getElementMatrix(vehicleElement)
	local vehicleBounds = {
		[1] = {getPositionFromOffset(vehicleMatrix, 1, 2.5, 0)}, -- Top right
		[2] = {getPositionFromOffset(vehicleMatrix, -1, 2.5, 0)}, -- Top left
		[3] = {getPositionFromOffset(vehicleMatrix, 1, -2.5, 0)}, -- Bottom right
		[4] = {getPositionFromOffset(vehicleMatrix, -1, -2.5, 0)}, -- Bottom left
	}

	vehicleX = {vehicleBounds[1][1], vehicleBounds[2][1], vehicleBounds[3][1], vehicleBounds[4][1]} 
	vehicleY = {vehicleBounds[1][2], vehicleBounds[2][2], vehicleBounds[3][2], vehicleBounds[4][2]}

	local colshapeX = {colshapeBounds[1][1], colshapeBounds[2][1], colshapeBounds[3][1], colshapeBounds[4][1]}
	local colshapeY = {colshapeBounds[1][2], colshapeBounds[2][2], colshapeBounds[3][2], colshapeBounds[4][4]}

	local colMinX, colMinY = math.min(unpack(colshapeX)), math.min(unpack(colshapeY))
	local colMaxX, colMaxY = math.max(unpack(colshapeX)), math.max(unpack(colshapeY))
    
	local vehMinX, vehMinY = math.min(unpack(vehicleX)), math.min(unpack(vehicleY))
	local vehMaxX, vehMaxY = math.max(unpack(vehicleX)), math.max(unpack(vehicleY))

	if requiredRotation then
		local vehicleRotation = select(3, getElementRotation(vehicleElement))

		if vehicleRotation < requiredRotation - 15 or vehicleRotation > requiredRotation + 15 then
			return false
		end
	end

	if vehMinX > colMinX and vehMaxX < colMaxX then
		if vehMinY > colMinY and vehMaxY < colMaxY then
			return true
		end
	end

	return false
end

function createFactoryPoint(randNum)
    --print(randNum)
    local middleX, middleY = factoryPosition[1][1], factoryPosition[1][2]
    local parkingDetails = {middleX, middleY, factoryPosition[1][3], 7, 3}

    destinationData = {
		basePosition = {parkingDetails[1], parkingDetails[2], factoryPosition[1][3]},
		baseRotation = factoryPosition[1][4] + 90,
		parkingSizes = {parkingDetails[4], parkingDetails[5]},
	}

    rotated_x1, rotated_y1 = rotateAround(destinationData.baseRotation, -destinationData.parkingSizes[1] / 2, -destinationData.parkingSizes[2] / 2)
	local rotated_x2, rotated_y2 = rotateAround(destinationData.baseRotation, destinationData.parkingSizes[1] / 2, -destinationData.parkingSizes[2] / 2)
	local rotated_x3, rotated_y3 = rotateAround(destinationData.baseRotation, destinationData.parkingSizes[1] / 2, destinationData.parkingSizes[2] / 2)
	local rotated_x4, rotated_y4 = rotateAround(destinationData.baseRotation, -destinationData.parkingSizes[1] / 2, destinationData.parkingSizes[2] / 2)


	destinationData.colShape = createColPolygon(
		destinationData.basePosition[1],
		destinationData.basePosition[2],

		destinationData.basePosition[1] + rotated_x1,
		destinationData.basePosition[2] + rotated_y1,

		destinationData.basePosition[1] + rotated_x2,
		destinationData.basePosition[2] + rotated_y2,

		destinationData.basePosition[1] + rotated_x3,
		destinationData.basePosition[2] + rotated_y3,

		destinationData.basePosition[1] + rotated_x4,
		destinationData.basePosition[2] + rotated_y4
	)

    destinationData.colShapeBounds = {
		[1] = {destinationData.basePosition[1] + rotated_x2, destinationData.basePosition[2] + rotated_y2}, -- top right
		[2] = {destinationData.basePosition[1] + rotated_x3, destinationData.basePosition[2] + rotated_y3}, -- top left
		[3] = {destinationData.basePosition[1] + rotated_x1, destinationData.basePosition[2] + rotated_y1}, -- bottom right
		[4] = {destinationData.basePosition[1] + rotated_x4, destinationData.basePosition[2] + rotated_y4} -- bottom left
	}
    --addEventHandler("onClientRender", root, renderParkingZone)
end
--createFactoryPoint()

function checkFactory(vehicleElement, colshapeBounds, requiredRotation)
	if not isElement(vehicleElement) then
		return false
	end

	if not getElementData(vehicleElement, "veh:stealedCar") then
		return false
	end

	local vehicleMatrix = getElementMatrix(vehicleElement)
	local vehicleBounds = {
		[1] = {getPositionFromOffset(vehicleMatrix, 1, 2.5, 0)}, -- Top right
		[2] = {getPositionFromOffset(vehicleMatrix, -1, 2.5, 0)}, -- Top left
		[3] = {getPositionFromOffset(vehicleMatrix, 1, -2.5, 0)}, -- Bottom right
		[4] = {getPositionFromOffset(vehicleMatrix, -1, -2.5, 0)}, -- Bottom left
	}

	vehicleX = {vehicleBounds[1][1], vehicleBounds[2][1], vehicleBounds[3][1], vehicleBounds[4][1]} 
	vehicleY = {vehicleBounds[1][2], vehicleBounds[2][2], vehicleBounds[3][2], vehicleBounds[4][2]}

	local colshapeX = {colshapeBounds[1][1], colshapeBounds[2][1], colshapeBounds[3][1], colshapeBounds[4][1]}
	local colshapeY = {colshapeBounds[1][2], colshapeBounds[2][2], colshapeBounds[3][2], colshapeBounds[4][4]}

	local colMinX, colMinY = math.min(unpack(colshapeX)), math.min(unpack(colshapeY))
	local colMaxX, colMaxY = math.max(unpack(colshapeX)), math.max(unpack(colshapeY))
    
	local vehMinX, vehMinY = math.min(unpack(vehicleX)), math.min(unpack(vehicleY))
	local vehMaxX, vehMaxY = math.max(unpack(vehicleX)), math.max(unpack(vehicleY))

	if requiredRotation then
		local vehicleRotation = select(3, getElementRotation(vehicleElement))

		if vehicleRotation < requiredRotation - 15 or vehicleRotation > requiredRotation + 15 then
			return false
		end
	end

	if vehMinX > colMinX and vehMaxX < colMaxX then
		if vehMinY > colMinY and vehMaxY < colMaxY then
			return vehicleElement
		end
	end

	return false
end


local putdownTraget = dxCreateRenderTarget(256, 512, true)
local stripe = dxCreateTexture("files/park.png", "dxt3")

addEventHandler("onClientRender",root,
    function()
        if showedStripe then
            dxSetRenderTarget(putdownTraget, true)
            local color = tocolor(217, 83, 79, 255)
            if checkAABB(getElementData(localPlayer,"veh:stealedCarElement"), destinationData.colShapeBounds) then
                color = tocolor(37, 153, 8,255)
            end
            dxDrawImage(0, 0, 256, 512, stripe, 0,0,0, color)
            dxSetRenderTarget()
            if destinationData then
                local groundZ = getGroundPosition(destinationData.basePosition[1], destinationData.basePosition[2]-3.5, destinationData.basePosition[3])
                dxDrawMaterialLine3D(destinationData.basePosition[1], destinationData.basePosition[2]-3.5, groundZ+0.01, destinationData.basePosition[1], destinationData.basePosition[2]-3.5 +destinationData.parkingSizes[1], groundZ+0.01, putdownTraget, destinationData.parkingSizes[2], Color, destinationData.basePosition[1], destinationData.basePosition[2]-3.5, destinationData.basePosition[3]+10)
            end
        end
        if factoryPark then 
            dxSetRenderTarget(putdownTraget, true)
            local color = tocolor(217, 83, 79, 255)
            if checkFactory(getElementData(localPlayer,"veh:stealedCarElement"), destinationData.colShapeBounds) then
                color = tocolor(37, 153, 8,255)
            end
            dxDrawImage(0, 0, 256, 512, stripe, 0,0,0, color)
            dxSetRenderTarget()
            if destinationData then
                local groundZ = getGroundPosition(destinationData.basePosition[1], destinationData.basePosition[2]-3.5, destinationData.basePosition[3])
                dxDrawMaterialLine3D(destinationData.basePosition[1], destinationData.basePosition[2]-3.5, groundZ+0.01, destinationData.basePosition[1], destinationData.basePosition[2]-3.5 +destinationData.parkingSizes[1], groundZ+0.01, putdownTraget, destinationData.parkingSizes[2], Color, destinationData.basePosition[1], destinationData.basePosition[2]-3.5, destinationData.basePosition[3]+10)
            end

            if checkFactory(getElementData(localPlayer,"veh:stealedCarElement"), destinationData.colShapeBounds) then
                if not isPedInVehicle(localPlayer) then
                    for k,veh in ipairs(getElementsByType("vehicle")) do
                        if not getElementData(veh,"attachedVehicle") then
                            for v in pairs ( getVehicleComponents(veh) ) do
                                if components[v] then
                                    --print("asd")

                                    local sX,sY,sZ = getVehicleComponentPosition ( veh, v, "world" )
                                    local posX,posY,posZ = getScreenFromWorldPosition ( sX, sY, sZ )

                                    x, y, z = getElementPosition(localPlayer)
                                    vehicleX, vehicleY, vehicleZ = getElementPosition(veh)
                                    --print("Player to Vehicle: "..getDistanceBetweenPoints3D(x, y, z, vehicleX, vehicleY, vehicleZ))
                                    --print("Player to Components: "..getDistanceBetweenPoints3D(x, y, z,sX,sY,sZ))
                                    if getDistanceBetweenPoints3D(x, y, z, vehicleX, vehicleY, vehicleZ) <= 6 then
                                        if getDistanceBetweenPoints3D(x, y, z,sX,sY,sZ) <= 2 then
                                            --print("asd")
                                            selectedVehicle = veh
                                             
                                            if posX and posY then
                                                if doorsStates[v] then
                                                    if getVehicleComponentVisible(veh, v) then
                                                        local text = ""
                                                        text = realComponentNames[v].." leszerelése"
                                                        --print("asd")
                                                        --dxDrawRectangle(0, 0, 200, 200)
                                                        core:dxDrawButton(posX+7,posY+4, 200, screenY*0.03, r, g, b, 200, text, tocolor(255, 255, 255, 255), 0.85, font:getFont("condensed", 15/myX*screenX), true, tocolor(0, 0, 0, 100))
                                                    end
                                                end

                                                if wheelStates[v] then
                                                    local text = ""
                                                    if getVehicleComponentVisible(veh, v) then
                                                        text = realComponentNames[v].." leszerelése"
                                                        core:dxDrawButton(posX+7,posY+4, 200, screenY*0.03, r, g, b, 200, text, tocolor(255, 255, 255, 255), 0.85, font:getFont("condensed", 15/myX*screenX), true, tocolor(0, 0, 0, 100))
                                                    end
                                                end

                                                if panelStates[v] then
                                                    local text = ""
                                                    if getVehicleComponentVisible(veh, v) then
                                                        text = realComponentNames[v].." leszerelése"
                                                        core:dxDrawButton(posX+7,posY+4, 200, screenY*0.03, r, g, b, 200, text, tocolor(255, 255, 255, 255), 0.85, font:getFont("condensed", 15/myX*screenX), true, tocolor(0, 0, 0, 100))
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
)


addEventHandler("onClientClick", getRootElement(), function(button,state)
    if button == "left" and state == "down" then 
        if getElementData(localPlayer, "factoryPark") then 
            if checkFactory(getElementData(localPlayer,"veh:stealedCarElement"), destinationData.colShapeBounds) then
                if not isPedInVehicle(localPlayer) and not getElementData(localPlayer, "componentInHand") then
                    for k,veh in ipairs(getElementsByType("vehicle")) do
                        if not getElementData(veh,"attachedVehicle") then
                            
                            for v in pairs ( getVehicleComponents(veh) ) do
                                if components[v] then
                                    local sX,sY,sZ = getVehicleComponentPosition ( veh, v, "world" )
                                    local posX,posY,posZ = getScreenFromWorldPosition ( sX, sY, sZ )

                                    x, y, z = getElementPosition(localPlayer)
                                    vehicleX, vehicleY, vehicleZ = getElementPosition(veh)
                                    if getDistanceBetweenPoints3D(x, y, z, vehicleX, vehicleY, vehicleZ) <= 6 then
                                        if getDistanceBetweenPoints3D(x, y, z,sX,sY,sZ) <= 2 then
                                            if posX and posY then
                                                if doorsStates[v] then
                                                    if core:isInSlot(posX+7,posY+4, 200, screenY*0.03) then
                                                        --outputChatBox("Door")
                                                        text = realComponentNames[v].." leszerelése"
                                                        setElementData(localPlayer,"componentInHand",true)
                                                        componentName = v
                                                        progressBarText = text
                                                        progressTime = math.random(2500, 10000)
                                                        progressBarAnimType = "open"
                                                        tick = getTickCount()
                                                        progressBarAnimTick = getTickCount()
                                                        addEventHandler("onClientRender", root, renderProgressBar)
                                                        triggerServerEvent("setMechanicAnim",localPlayer,localPlayer,"create")
                                                    end
                                                end
                                                if wheelStates[v] then
                                                    if core:isInSlot(posX+7,posY+4, 200, screenY*0.03) then
                                                      --  outputChatBox("Wheel")
                                                        text = realComponentNames[v].." leszerelése"
                                                        setElementData(localPlayer,"componentInHand",true)
                                                        componentName = v
                                                        progressBarText = text
                                                        progressTime = math.random(2500, 10000)
                                                        progressBarAnimType = "open"
                                                        tick = getTickCount()
                                                        progressBarAnimTick = getTickCount()
                                                        addEventHandler("onClientRender", root, renderProgressBar)
                                                        triggerServerEvent("setMechanicAnim",localPlayer,localPlayer,"create")
                                                    end
                                                end
                                                if panelStates[v] then
                                                    if core:isInSlot(posX+7,posY+4, 200, screenY*0.03) then
                                                       -- outputChatBox("Panel")
                                                        text = realComponentNames[v].." leszerelése"
                                                        setElementData(localPlayer,"componentInHand",true)
                                                        componentName = v
                                                        progressBarText = text
                                                        progressTime = math.random(2500, 10000)
                                                        progressBarAnimType = "open"
                                                        tick = getTickCount()
                                                        progressBarAnimTick = getTickCount()
                                                        addEventHandler("onClientRender", root, renderProgressBar)
                                                        triggerServerEvent("setMechanicAnim",localPlayer,localPlayer,"create")
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                else 
                    outputChatBox(core:getServerPrefix("server", "Autólopás", 2).."Már van egy komponens a kezedben!", 255, 255, 255, true)
                end
            end
        end
    end
end)

function renderProgressBar()
    local alpha
    
    if progressBarAnimType == "open" then 
        alpha = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - progressBarAnimTick)/250, "Linear")
    else
        alpha = interpolateBetween(1, 0, 0, 0, 0, 0, (getTickCount() - progressBarAnimTick)/250, "Linear")
    end

    local line_height = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - tick)/progressTime, "Linear")

    dxDrawRectangle(screenX*0.4, screenY*0.85, screenX*0.2, screenY*0.025, tocolor(40, 40, 40, 255*alpha))
    dxDrawRectangle(screenX*0.401, screenY*0.852, (screenX*0.2-screenX*0.002), screenY*0.025-screenY*0.004, tocolor(35, 35, 35, 255*alpha))
    dxDrawRectangle(screenX*0.401, screenY*0.852, (screenX*0.2-screenX*0.002)*line_height, screenY*0.025-screenY*0.004, tocolor(r, g, b, 255*alpha))
    dxDrawText(progressBarText, screenX*0.2, screenY*0.425, screenX*0.4+screenX*0.2, screenY*0.85+screenY*0.025, tocolor(255,255,255, 255*alpha), 0.85, font:getFont("condensed", 15/myX*screenX), "center", "center", false, false, false, true)
    if line_height >= 1 then 
        removeEventHandler("onClientRender", getRootElement(), renderProgressBar)
        chat:sendLocalMeAction("leszerelt egy ".. progressBarText:gsub("leszerelése","") .."-t.")
        triggerServerEvent("setMechanicAnim",localPlayer,localPlayer,"remove",getElementData(localPlayer,"componentInHand"))
        triggerServerEvent("nemtudomServer",localPlayer,localPlayer,selectedVehicle,false, componentName)
    end
end

addEvent("vehicleComponentEvent", true)
addEventHandler("vehicleComponentEvent", getRootElement(), function(vehicle,state,component,element)
	if not vehicles[vehicle] then
		vehicles[vehicle] = {}
	end
    if state == true then
		if doorsStates[component] then
			local doorState = getVehicleDoorState(vehicles[vehicle][component], doorsStates[component][1])
			if (doorState ~= 0) then
				return
			end
		end
		if panelStates[component] then
			local panelState = getVehiclePanelState(vehicles[vehicle][component], panelStates[component][1])
			if (panelState ~= 0) then
				return
			end
		end

		if isElement(vehicles[vehicle][component]) then
			destroyElement(vehicles[vehicle][component])
		end
		setVehicleComponentVisible(vehicle,component, true)
		if doorsStates[component] then
			setVehicleDoorState(vehicle, componentPos[component][7],0)
		end
		if panelStates[component] then
			setVehiclePanelState(vehicle, componentPos[component][7],0)
		end
	elseif state == false then
		if not isElement(vehicles[vehicle][component]) then
			local x,y,z = getElementPosition(vehicle)
			vehicles[vehicle][component] = createVehicle(getElementModel(vehicle),x,y,z)
			setElementAlpha(vehicles[vehicle][component],0)
			setElementFrozen(vehicles[vehicle][component],true)
			setElementData(localPlayer,"componentInHand",vehicles[vehicle][component])

			setElementData(vehicles[vehicle][component],"attachedVehicle",true)
			setElementData(vehicles[vehicle][component],"attachedElement",element)
			setElementData(vehicles[vehicle][component],"attachedVehicleElement",vehicles[vehicle][component])
			setElementData(vehicles[vehicle][component],"attachedComponent",component)
			local r,g,b,r1,g1,b1 = getVehicleColor(vehicle)
			setElementData(vehicles[vehicle][component],"attachedColor",{r,g,b,r1,g1,b1})
			setElementCollisionsEnabled(vehicles[vehicle][component], false)
			attachElements(vehicles[vehicle][component],element,componentPos[component][1],componentPos[component][2],componentPos[component][3],componentPos[component][4],componentPos[component][5],componentPos[component][6])
			timers[element] = setTimer(function()
				setElementAlpha(vehicles[vehicle][component],255)
				local r,g,b,r1,g1,b1 = getVehicleColor(vehicle)
				setVehicleColor(vehicles[vehicle][component],r,g,b,r1,g1,b1)
				local hR,hG,hB = getVehicleHeadLightColor(vehicle)
				setVehicleHeadLightColor(vehicles[vehicle][component],hR,hG,hB)
				for a in pairs(getVehicleComponents(vehicles[vehicle][component])) do
					if component ~= a then
						setVehicleComponentVisible(vehicles[vehicle][component],a, false)
					end
				end
				killTimer(timers[element])
			end,50,1)
		end
		setVehicleComponentVisible(vehicle,component, false)
	end
end)

addEventHandler("onClientMarkerHit",getRootElement(), function(hitPlayer, matchDim)
    if hitPlayer == localPlayer then 
        if getElementData(source, "isFactoryMarker") then 
            if getElementData(localPlayer,"componentInHand") then
                local playerX,playerY,playerZ = getElementPosition(localPlayer)
                local objectX,objectY,objectZ = getElementPosition(getElementData(localPlayer, "componentInHand"))
                --osszesen = 0
                osszesenKesz = 0
                vehElement =  checkFactory(getElementData(localPlayer,"veh:stealedCarElement"), destinationData.colShapeBounds)
                if getDistanceBetweenPoints3D(playerX,playerY,playerZ,objectX,objectY,objectZ) <= 3.4 then
                    for k,v in ipairs(getElementsByType("vehicle")) do
                        if getElementData(v,"attachedVehicle") then
                            if getElementData(v,"attachedElement") == localPlayer then

                                setElementData(localPlayer,"componentInHand",false)

                                triggerServerEvent("componentDestroyFromHand",localPlayer,localPlayer)
                               
                                for v in pairs ( getVehicleComponents(vehElement) ) do
                                    --print(#components)
                                    if components[v] then
                                        --osszesen = osszesen + 1
                                        --print(#components[v])
                                        --print(#doorsStates)
                                        if not getVehicleComponentVisible(vehElement, v) then
                                            osszesenKesz = osszesenKesz + 1
                                        end
                                    end
                                end
                                if osszesenKesz >= osszesen then 
                                    outputChatBox(core:getServerPrefix("server", "Autólopás", 2).."Sikeresen szét szerelted az autót!", 255, 255, 255, true)
                                    outputChatBox(core:getServerPrefix("server", "Autólopás", 2).."Menj és beszélj Michael-el.", 255, 255, 255, true)
                                    --print("asd")
                                    if isElement(blipElement) then 
                                        destroyElement(blipElement)
                                    end
                                    blipElement = createBlip(pedPosition.x,pedPosition.y,pedPosition.z, 3)
                                    setElementData(blipElement, "blip:name", "Michael")
                                    scene2MinPrice = exports["oCarshop"]:getVehiclePriceInCarshop(getElementModel(getElementData(localPlayer,"veh:stealedCarElement")))/2/2
                                    scene2MaxPrice = exports["oCarshop"]:getVehiclePriceInCarshop(getElementModel(getElementData(localPlayer,"veh:stealedCarElement")))/2
                                    randMoney = math.random(scene2MinPrice, scene2MaxPrice)
                                    triggerServerEvent("destroyTheCar", localPlayer, localPlayer)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

addEvent("componentDestroyClient",true)
addEventHandler("componentDestroyClient",getRootElement(),function(element)
	for k,v in ipairs(getElementsByType("vehicle")) do
		if getElementData(v,"attachedVehicle") then
			if getElementData(v,"attachedElement") == element then
				destroyElement(v)
			end
		end
	end
end)

for k,veh in ipairs(getElementsByType("vehicle")) do 
    if getElementData(veh, "veh:stealedCar") then 
        for v in pairs ( getVehicleComponents(veh) ) do
            setVehicleComponentVisible(veh, v, true)
        end
    end
end

--CAM


-- Cam move
local sm = {}
sm.moov = 0
sm.object1,sm.object2 = nil,nil
 
local function removeCamHandler()
	if(sm.moov == 1)then
		sm.moov = 0
	end
end
 
local function camRender()
	if (sm.moov == 1) then
		local x1,y1,z1 = getElementPosition(sm.object1)
		local x2,y2,z2 = getElementPosition(sm.object2)
		setCameraMatrix(x1,y1,z1,x2,y2,z2)
	else
		removeEventHandler("onClientPreRender",root,camRender)
	end
end

 
function smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t,x2,y2,z2,x2t,y2t,z2t,time)
	if(sm.moov == 1)then return false end
	sm.object1 = createObject(1337,x1,y1,z1)
	sm.object2 = createObject(1337,x1t,y1t,z1t)
        setElementCollisionsEnabled (sm.object1,false) 
	setElementCollisionsEnabled (sm.object2,false) 
	setElementAlpha(sm.object1,0)
	setElementAlpha(sm.object2,0)
	setObjectScale(sm.object1,0.01)
	setObjectScale(sm.object2,0.01)
	moveObject(sm.object1,time,x2,y2,z2,0,0,0,"InOutQuad")
	moveObject(sm.object2,time,x2t,y2t,z2t,0,0,0,"InOutQuad")
	sm.moov = 1
	setTimer(removeCamHandler,time,1)
	setTimer(destroyElement,time,1,sm.object1)
	setTimer(destroyElement,time,1,sm.object2)
	addEventHandler("onClientPreRender",root,camRender)
	return true
end

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x-3, y, z
end




--------------------------------------------------------------------------------------
local priceMultiplier = 0
local sx, sy = guiGetScreenSize()
local minigameStarted = false
local counter = 0
local maxCounter = 5
local wrongCounter = 0


local barPositions = {0.1, 0.4, 0.5, 0.7, 1}
local cursorPos, cursorStart = 0, getTickCount()
local barColors = {
    tocolor(227, 62, 50, 255),
    tocolor(227, 150, 50, 255),
    tocolor(50, 227, 121, 255),
    tocolor(227, 150, 50, 255),
    tocolor(227, 62, 50, 255),
}

function createlockpickingMechanic()	
    interface:toggleHud(true)
    cursorPos = 0
    counter = 0
    maxCounter = 5
    wrongCounter = 0
    addEventHandler("onClientKey", getRootElement(), onKey)
    addEventHandler("onClientRender",getRootElement(),drawMinigame)
    generateBarPoitions()
end


function drawMinigame()
    _dxDrawText("Törd fel a kocsit! (".. counter .."/ ".. maxCounter .." | Wrong: ".. wrongCounter ..")", 0, sy - sy*0.15, sx, sy - sy*0.1, tocolor(255, 255, 255, 100), 1, font:getFont("condensed", 12/myX*sx), "center", "center")
    _dxDrawText("Akkor engedd fel a "..color.."[Space] #ffffffgombot, amikor a fehér vonal a zöld mezőbe ér!", 0, sy - sy*0.05, sx, sy, tocolor(255, 255, 255, 100), 1, font:getFont("condensed", 12/myX*sx), "center", "center", false, false, false, true)

    
    if not minigameStarted then
        _dxDrawText("A minigame kezdéséhez tartsd lenyomva a [Space] gombot.", 0, sy - sy*0.15, sx, sy, tocolor(r, g, b, 255 ), 1, font:getFont("bebasneue", 18/myX*sx), "center", "center")
    else
        dxDrawRectangle(sx*0.4, sy*0.91, sx*0.2, sy*0.03, tocolor(30, 30, 30, 100))
        for i = 1, 5 do 
            if i == 1 then 
                dxDrawRectangle(sx*0.4, sy*0.91, sx*0.2 * (barPositions[i]), sy*0.03, barColors[i])
            else
                dxDrawRectangle(sx*0.4 + (sx*0.2 * barPositions[i-1]), sy*0.91, (barPositions[i] - barPositions[i-1]) * sx*0.2, sy*0.03, barColors[i])
            end
        end
        if spaceState then
            cursorPos = interpolateBetween(cursorPos, 0, 0, 1, 0, 0, (getTickCount() - cursorStart) / 5000, "InOutQuad")
        end
        dxDrawRectangle(sx*0.4 + sx*0.2 * cursorPos, sy*0.9, sx*0.003, sy*0.05, tocolor(255, 255, 255, 255))
    end



    --[[dxDrawRectangle(screenX/2 - pw/2, screenY/2 - ph/2, pw,ph, tocolor(0,0,0,150))
    dxDrawText("Ha nem vagy megelégedve a kínált árral akkor a lenti minigame segítségével finomíthatsz az áron!", screenX/2, screenY/2 - ph/2, screenX/2 - screenX/2, screenY/2 - ph - 100, tocolor(255, 255, 255, 255), 1, font:getFont("condensed", 12/myX*sx), "center", "center")
    dxDrawText("Akkor engedd fel a "..color.."[Space] #ffffffgombot, amikor a fehér vonal a zöld mezőbe ér!", screenX/2, screenY/2 - ph/2 + 20, screenX/2 - screenX/2, screenY/2 - ph-100, tocolor(255, 255, 255, 255), 1, font:getFont("condensed", 12/myX*sx), "center", "center", false, false, false, true)
    if not minigameStarted then
        dxDrawText("A minigame kezdéséhez tartsd lenyomva a [Space] gombot.", screenX/2, screenY/2 - ph/2 + 80, screenX/2 - screenX/2, screenY/2 - ph - 100, tocolor(r, g, b, 255), 1, font:getFont("bebasneue", 18/myX*sx), "center", "center")
        dxDrawRectangle(screenX/2 - pw/2 + 138, screenY/2 - ph/2 + 130, sx*0.2, sy*0.03, tocolor(30, 30, 30, 150))
        for i = 1, 5 do 
            if i == 1 then 
                dxDrawRectangle(screenX/2 - pw/2 + 138, screenY/2 - ph/2 + 130, sx*0.2 * (barPositions[i]), sy*0.03, barColors[i])
            else
                dxDrawRectangle(screenX/2 - pw/2 + 138 + (sx*0.2 * barPositions[i-1]), screenY/2 - ph/2 + 130, (barPositions[i] - barPositions[i-1]) * sx*0.2, sy*0.03, barColors[i])
            end
        end
    els

    end]]
end


local colorMultipliers = {0, 1, 2, 1, 0}



function onKey(key, state)
    --if panelText == 3 then 
        if key == "space" then 
            cancelEvent()
            if state then 
                cursorPos = 0
                cursorStart = getTickCount()
                minigameStarted = true
                spaceState = true
            else
                spaceState = false
                minigameShowing = false


                for i = 1, 5 do 
                    if cursorPos > 0.95 then 
                        priceMultiplier = colorMultipliers[5]
                    elseif cursorPos < barPositions[i] then 
                        priceMultiplier = colorMultipliers[i]
                        break
                    end
                end
                if priceMultiplier == 0 then 
                    if wrongCounter >= 3 then 
                        --outputChatBox("nem sikerült")
                        vehElement = getElementData(localPlayer, "veh:stealedCarElement")
                        triggerServerEvent("factionScripts > cctv > sendMessage", root, core:getServerPrefix("blue-light-2", "Autólopás", 2).."Feltörtek egy ".. exports["oVehicle"]:getModdedVehName(getElementModel(vehElement)) .. " típusú járművet")
                        triggerServerEvent("factionScripts > cctv > sendMessage", root, core:getServerPrefix("blue-light-2", "Autólopás", 2).."Pozíció: ".. getZoneName(Vector3(getElementPosition(vehElement))))
                        removeEventHandler("onClientRender", getRootElement(), drawMinigame)
                        removeEventHandler("onClientKey", getRootElement(), onKey)
                        setElementData(vehElement, "char:stealer", true)
                        interface:toggleHud(false)
                    else 
                        wrongCounter = wrongCounter + 1
                        
                    end
                elseif priceMultiplier == 2 then 
                    if counter > maxCounter-1 then 
                        vehElement = getElementData(localPlayer, "veh:stealedCarElement")
                        triggerServerEvent("factionScripts > cctv > sendMessage", root, core:getServerPrefix("blue-light-2", "Autólopás", 2).."Feltörtek egy ".. exports["oVehicle"]:getModdedVehName(getElementModel(vehElement)) .. " típusú járművet")
                        triggerServerEvent("factionScripts > cctv > sendMessage", root, core:getServerPrefix("blue-light-2", "Autólopás", 2).."Pozíció: ".. getZoneName(Vector3(getElementPosition(vehElement))))
                        removeEventHandler("onClientRender", getRootElement(), drawMinigame)
                        removeEventHandler("onClientKey", getRootElement(), onKey)
                        triggerServerEvent("unlockTheVehicle", localPlayer, localPlayer)
                        interface:toggleHud(false)
                    else 
                        counter = counter + 1
                    end
                elseif priceMultiplier == 1 then 
                    if maxCounter < 15 then 
                        maxCounter = maxCounter + 1
                    end
                end
            end
        end
    --end
end


local stealerBlip = nil
addEventHandler("onClientElementDataChange", getRootElement(), function(data, new, old)
    if getElementType(source) == "vehicle" then
        if data == "char:stealer" then 
            stealerBlip = setTimer(function(vehElement)
                setElementData(vehElement, "char:stealer", false)
                triggerServerEvent("factionScripts > cctv > sendMessage", root, core:getServerPrefix("blue-light-2", "Autólopás", 2).."Az autórabló el menekült megszakadt a kapcsolat!")
            end,core:minToMilisec(10), 1, source)
        end
    end
end)


function generateBarPoitions()
    for i = 1, 4 do 
        if i == 1 then 
            barPositions[i] = math.random(10, 40) / 100
        else
            barPositions[i] = math.random(barPositions[i - 1] * 100, (barPositions[i - 1] * 100) + 5) / 100
            barPositions[i] =  barPositions[i] + 0.05
            --print(barPositions[i - 1])
        end
    end
end

function dxDrawCircle3D( x, y, z, radius, color, width, segments )
    local playerX,playerY,playerZ = getElementPosition(localPlayer)
    if getDistanceBetweenPoints3D(playerX,playerY,playerZ,x, y, z) <= 50 then
        segments = segments or 16;
        color = color or tocolor( 248, 126, 136, 200 );  
        width = width or 1; 
        local segAngle = 360 / segments; 
        local fX, fY, tX, tY;  
        local alpha = 20
        for i = 1, segments do 
            fX = x + math.cos( math.rad( segAngle * i ) ) * radius; 
            fY = y + math.sin( math.rad( segAngle * i ) ) * radius; 
            tX = x + math.cos( math.rad( segAngle * (i+1) ) ) * radius;  
            tY = y + math.sin( math.rad( segAngle * (i+1) ) ) * radius; 
            dxDrawLine3D( fX, fY, z, tX, tY, z, color, width);
        end
    end    
end

--triggerServerEvent("unlockTheVehicle", localPlayer, localPlayer)
