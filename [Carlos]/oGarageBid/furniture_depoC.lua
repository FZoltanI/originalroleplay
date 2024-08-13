local depoCol = createColCuboid(unpack(furnitureDepo.col))
local sellPed = createPed(130, unpack(furnitureDepo.ped))
setElementFrozen(sellPed, true)
setElementData(sellPed, "ped:name", "Charlotte")
setElementData(sellPed, "ped:prefix", "Felvásárló")

local items = {}
local carPanelListPointer = 0

local selectedItem = 1

local inMinigame = false
local minigameItemPrice, minigameItem = 0, 0
local minigameVehicle = false

addEventHandler("onClientClick", root, function(key, state, _, _, _, _, _, element)
	if key == "right" and state == "up" then 
        if element then 
			if element == sellPed then 
				if core:getDistance(localPlayer, element) < 2 then 
                    if inMinigame then return end 
                    showTraderPanel()
                end
            end
        end
    end
end)

local panelAnimationV, panelAnimationType, panelAnimTick = 0, "open", getTickCount()
local panelShowing = false
function renderTraderPanel()
    if panelAnimationType == "open" then 
        if core:getDistance(localPlayer, sellPed) > 2 then 
            closeTraderPanel()
        end

        panelAnimationV = interpolateBetween(panelAnimationV, 0, 0, 1, 0, 0, (getTickCount() - panelAnimTick)/500, "Linear")
    else
        panelAnimationV = interpolateBetween(panelAnimationV, 0, 0, 0, 0, 0, (getTickCount() - panelAnimTick)/500, "Linear")
    end

    core:drawWindow(sx*0.375, sy*0.3, sx*0.25, sy*0.4, "Bútor felvásárló", panelAnimationV)

    dxDrawText("Név", sx*0.385, sy*0.32, sx*0.385 + sx*0.235, sy*0.32 + sy*0.035, tocolor(255, 255, 255, 255 * panelAnimationV), 0.9, font:getFont("p_bo", 15/myX*sx), "left", "center")
    dxDrawText("Becsült ár", sx*0.385, sy*0.32, sx*0.385 + sx*0.225, sy*0.32 + sy*0.035, tocolor(255, 255, 255, 255 * panelAnimationV), 0.9, font:getFont("p_bo", 15/myX*sx), "right", "center")

    local startY = sy*0.35
    for i = 1, 5 do 
        if core:isInSlot(sx*0.38, startY, sx*0.235, sy*0.03) or selectedItem == i + carPanelListPointer then 
            dxDrawRectangle(sx*0.38, startY, sx*0.235, sy*0.03, tocolor(50, 50, 50, ((i % 2) == 0 and 220 or 150) * panelAnimationV))  
        else
            dxDrawRectangle(sx*0.38, startY, sx*0.235, sy*0.03, tocolor(20, 20, 20, ((i % 2) == 0 and 220 or 150) * panelAnimationV))  
        end

        if items[i + carPanelListPointer] then
            dxDrawText(objectNames[items[i + carPanelListPointer]], sx*0.385, startY, sx*0.385 + sx*0.235, startY + sy*0.035, tocolor(255, 255, 255, 255 * panelAnimationV), 0.9, font:getFont("p_m", 15/myX*sx), "left", "center")
            dxDrawText(itemPrices[items[i + carPanelListPointer]] .. "$", sx*0.385, startY, sx*0.385 + sx*0.225, startY + sy*0.035, tocolor(126, 219, 103, 255 * panelAnimationV), 0.9, font:getFont("p_m", 15/myX*sx), "right", "center")
        end

        startY = startY + sy*0.032
    end

    core:dxDrawScrollbar(sx*0.618, sy*0.35, sx*0.0016, sy*0.158, items, carPanelListPointer, 5, r, g, b, panelAnimationV)

    --
    dxDrawRectangle(sx*0.38, sy*0.517, sx*0.24, sy*0.17, tocolor(20, 20, 20, 100 * panelAnimationV))
    dxDrawText("Tárgy: "..color..objectNames[items[selectedItem]], sx*0.385, sy*0.525, _, _, tocolor(255, 255, 255, 255 * panelAnimationV), 0.9, font:getFont("p_m", 15/myX*sx), _, _, false, false, false, true)
    dxDrawText("Becsült ár: #7edb67"..itemPrices[items[selectedItem]].."$", sx*0.385, sy*0.545, _, _, tocolor(255, 255, 255, 255 * panelAnimationV), 0.9, font:getFont("p_m", 15/myX*sx), _, _, false, false, false, true)

    dxDrawRectangle(sx*0.56 - 55/myX*sx, sy*0.523, 155/myX*sx, 155/myX*sx, tocolor(35, 35, 35, 200 * panelAnimationV))
    dxDrawImage(sx*0.56 - 55/myX*sx, sy*0.523, 155/myX*sx, 155/myX*sx, "files/items/"..items[selectedItem]..".png", 0, 0, 0, tocolor(255, 255, 255, 255 * panelAnimationV))

    core:dxDrawButton(sx*0.384, sy*0.65, sx*0.14, sy*0.03, r, g, b, 150 * panelAnimationV, "Alkudozás", tocolor(255, 255, 255, 255 * panelAnimationV), 0.9, font:getFont("condensed", 11/myX*sx), false)
end

function keyRenderPanel(key, state)
    if key == "mouse1" and state then 
        local startY = sy*0.35
        for i = 1, 5 do 
            if core:isInSlot(sx*0.38, startY, sx*0.235, sy*0.03) then 
                if items[i + carPanelListPointer] then
                    selectedItem = i + carPanelListPointer
                end
            end

            startY = startY + sy*0.032
        end

        if core:isInSlot(sx*0.384, sy*0.65, sx*0.14, sy*0.03) then 
            minigameItemPrice = itemPrices[items[selectedItem]]
            minigameItem = items[selectedItem]
            closeTraderPanel()
            startCraftMinigame()
        end

    elseif key == "mouse_wheel_down" and state then 
        if items[carPanelListPointer + 6] then
            carPanelListPointer = carPanelListPointer + 1
        end
    elseif key == "mouse_wheel_up" and state then 
        if carPanelListPointer > 0 then 
            carPanelListPointer = carPanelListPointer - 1
        end
    elseif key == "backspace" and state then 
        closeTraderPanel()
    end
end

function showTraderPanel()
    if panelShowing then return end

    local veh = searchForTransporterCar(localPlayer)
    if veh then 
        items = getElementData(veh, "veh:garageBid:items") or {}

        if #items > 0 then
            panelShowing = true
            carPanelListPointer = 0
            selectedItem = 1
            minigameVehicle = veh

            panelAnimationType = "open"
            panelAnimTick = getTickCount()
            addEventHandler("onClientRender", root, renderTraderPanel)
            addEventHandler("onClientKey", root, keyRenderPanel)
        end
    end
end

function closeTraderPanel()
    panelAnimationType = "close"
    panelAnimTick = getTickCount()
    setTimer(function()
        panelShowing = false
        removeEventHandler("onClientRender", root, renderTraderPanel)
    end, 500, 1)
    removeEventHandler("onClientKey", root, keyRenderPanel)
end

function searchForTransporterCar(owner)
    local ownerId = getElementData(owner, "char:id")
    local vehicle = false 
    local elements = getElementsWithinColShape(depoCol, "vehicle")
    for k2, v2 in ipairs(elements) do 
        if (getElementData(v2, "veh:owner") == ownerId) then 
            if allowedVehiclesForTransport[getElementModel(v2)] then 
                if getElementData(v2, "veh:garageBid:items") then 
                    vehicle = v2 
                    break 
                end
            end
        end
    end 
    return vehicle
end 

-- Furniture display in the car
function renderCarFurniturePanel()
    core:drawWindow(sx*0.873, sy*0.4, sx*0.125, sy*0.186, "Szállított tárgyak", 1)

    items = getElementData(getPedOccupiedVehicle(localPlayer), "veh:garageBid:items") or {}

    if #items == 0 then 
        toggleCarFurniturePanel()
    end

    local startY = sy*0.424
    for i = 1, 5 do 
        dxDrawRectangle(sx*0.875, startY, sx*0.118, sy*0.03, tocolor(20, 20, 20, (i % 2) == 0 and 220 or 150))  

        if items[i + carPanelListPointer] then
            dxDrawText(objectNames[items[i + carPanelListPointer]], sx*0.875, startY, sx*0.875 + sx*0.118, startY + sy*0.035, tocolor(255, 255, 255), 0.9, font:getFont("p_m", 15/myX*sx), "center", "center")
        end

        startY = startY + sy*0.032
    end

    core:dxDrawScrollbar(sx*0.9942, sy*0.424, sx*0.0016, sy*0.158, items, carPanelListPointer, 5, r, g, b, 1)
end

function keyCarFurniturePanel(key, state)
    if state then 
        if key == "mouse_wheel_down" then 
            if items[carPanelListPointer + 6] then
                carPanelListPointer = carPanelListPointer + 1
            end
        elseif key == "mouse_wheel_up" then 
            if carPanelListPointer > 0 then 
                carPanelListPointer = carPanelListPointer - 1
            end
        end
    end
end

function showCarFuniturePanel()
    carPanelListPointer = 0
    addEventHandler("onClientRender", root, renderCarFurniturePanel)
    addEventHandler("onClientKey", root, keyCarFurniturePanel)
end

function toggleCarFurniturePanel()
    removeEventHandler("onClientRender", root, renderCarFurniturePanel)
    removeEventHandler("onClientKey", root, keyCarFurniturePanel)
end

addEventHandler("onClientVehicleEnter", root, function(player, seat)
    if player == localPlayer then 
        if getElementData(source, "veh:garageBid:items") then 
            showCarFuniturePanel()
        end
    end
end)

addEventHandler("onClientVehicleStartExit", root, function(player, seat)
    if player == localPlayer then 
        if getElementData(source, "veh:garageBid:items") then 
            toggleCarFurniturePanel()
        end
    end
end)

-- minigame 
local minigameMove = -0.2
local pointerPos = sx*0.5 - sx*0.01/2
local successPercent = 0

function renderMinigame()
    showCursor(true)

    dxDrawRectangle(sx*0.4, sy*0.8, sx*0.2, sy*0.02, tocolor(35, 35, 35, 100))
    dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.8 + 2/myY*sy, sx*0.2 - 4/myX*sx, sy*0.02 - 4/myY*sy, tocolor(35, 35, 35, 255))

    dxDrawImage(sx*0.4 + 2/myX*sx, sy*0.8 + 2/myY*sy, sx*0.035, sy*0.02 - 4/myY*sy, "files/gradient.png", 0, 0, 0, tocolor(242, 51, 51, 255))
    dxDrawImage(sx*0.4 + 2/myX*sx + sx*0.2 - 4/myX*sx - sx*0.035, sy*0.8 + 2/myY*sy, sx*0.035, sy*0.02 - 4/myY*sy, "files/gradient.png", 180, 0, 0, tocolor(242, 51, 51, 255))

    dxDrawRectangle(pointerPos, sy*0.8 - 1/myY*sy, sx*0.001, sy*0.02, tocolor(255, 255, 255, 200))
    dxDrawRectangle(pointerPos - 2/myX*sx, sy*0.8 - 3/myY*sy, sx*0.001 + 4/myX*sx, sy*0.02 + 4/myY*sy, tocolor(255, 255, 255, 50))

    dxDrawRectangle(sx*0.4, sy*0.822, sx*0.2, sy*0.01, tocolor(35, 35, 35, 100))
    dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.822 + 2/myY*sy, sx*0.2 - 4/myX*sx, sy*0.01 - 4/myY*sy, tocolor(35, 35, 35, 255))

    if successPercent >= 15 then
        dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.822 + 2/myY*sy, (sx*0.2 - 4/myX*sx) * successPercent / 100, sy*0.01 - 4/myY*sy, tocolor(r, g, b, 200))
    else
        dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.822 + 2/myY*sy, (sx*0.2 - 4/myX*sx) * successPercent / 100, sy*0.01 - 4/myY*sy, tocolor(242, 51, 51, 200))
    end

    dxDrawRectangle(sx*0.4 + 2/myX*sx + (sx*0.2 - 4/myX*sx) * successPercent / 100, sy*0.822 + 2/myY*sy, sx*0.001, sy*0.02, tocolor(255, 255, 255, 200))
    dxDrawRectangle((sx*0.4 + 2/myX*sx + (sx*0.2 - 4/myX*sx) * successPercent / 100) - 2/myX*sx, sy*0.822, sx*0.001 + 4/myX*sx, sy*0.02 + 4/myY*sy, tocolor(255, 255, 255, 50))

    dxDrawText(math.floor(successPercent).."%", (sx*0.4 + 2/myX*sx + (sx*0.2 - 4/myX*sx) * successPercent / 100), sy*0.822, -sx*0.002, sy*0.02 + 4/myY*sy, tocolor(255, 0, 0, 255),0.9, font:getFont("p_m", 15/myX*sx), "right", "bottom")

    if successPercent < 100 then
        successPercent = successPercent + 0.05
    else
        endMinigame()
    end

    if getKeyState("arrow_l") or getKeyState("a") then 
        minigameMove = minigameMove - math.random(3, 10) / 100
    elseif getKeyState("arrow_r") or getKeyState("d") then 
        minigameMove = minigameMove + math.random(3, 10) / 100
    else
        if minigameMove > 0 and minigameMove < 1.5 then
            minigameMove = 1.5 
        elseif minigameMove < 0 and minigameMove > -1.5 then 
            minigameMove = -1.5 
        end
    end

    pointerPos = pointerPos + minigameMove/myX*sx

    if pointerPos < sx*0.41 or pointerPos > sx*0.59 then 
        endMinigame()
    end
end

function startCraftMinigame()
    local values = {-0.3, -0.25, -0.2, -0.1, 0.1, 0.2, 0.25, 0.3}
    pointerPos = sx*0.5 - sx*0.01/2
    minigameMove = values[math.random(#values)]
    successPercent = 0
    minigameInProgress = true

    addEventHandler("onClientRender", root, renderMinigame)
    inMinigame = true
    showCursor(true)

end

function endMinigame()
    successPercent = math.floor(successPercent)

    local neededPercent = 15

    local money = math.floor((math.max(neededPercent, successPercent)/100)*minigameItemPrice)
    setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money") + money)
    
    outputChatBox(core:getServerPrefix("server", "Felvásárló", 2).."Sikeresen eladtál egy "..color..objectNames[minigameItem].."#ffffff-ot/et #7edb67"..money.."$#ffffff-ért.", 255, 255, 255, true)

    for i = 1, #items do 
        if items[i] == minigameItem then 
            table.remove(items, i)
        end
    end
    setElementData(minigameVehicle, "veh:garageBid:items", items)
    minigameInProgress = false

    removeEventHandler("onClientRender", root, renderMinigame)
    showCursor(false)
    inMinigame = false
end