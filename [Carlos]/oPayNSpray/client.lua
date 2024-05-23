removeWorldModel(5856, 9999, 0, 0, 0)
removeWorldModel(5422, 9999, 0, 0, 0)
--removeWorldModel(6400, 9999, 0, 0, 0)
removeWorldModel(13028, 9999, 0, 0, 0)
removeWorldModel(7891, 10, 1965.8811035156, 2161.8937988281, 10.8203125)
removeWorldModel(3294, 10, -1421.2822265625, 2591.6545410156, 55.822052001953)

local occupiedPayAndSpray = 0

local openHour, closeHour = 22, 8

addEventHandler("onClientColShapeHit", resourceRoot, function(player, mdim)
    if player == localPlayer and mdim then 
        local occupiedVeh = getPedOccupiedVehicle(localPlayer)
        if occupiedVeh then 
            if getPedOccupiedVehicleSeat(localPlayer) == 0 then
                --local date = getRealTime()
                --print(date.hour)
                --if (date.hour <= closeHour or date.hour >= openHour) then  
                    local count = 0 

                    for k, v in ipairs(getElementsByType("player")) do 
                        if (getElementData(v, "char:duty:faction") or 0) == 3 then 
                            count = count + 1
                        end
                    end

                    if count == 0 then
                        if getElementHealth(occupiedVeh) < 1000 then 
                            occupiedPayAndSpray = getElementData(source, "PayAndSpray:ID")
                            openPanel()
                        else
                            exports.oInfobox:outputInfoBox("A járműved nem szorul szerelésre!", "warning")
                        end
                    else
                        exports.oInfobox:outputInfoBox("Jelenleg van elérhető szerelő!", "error")
                    end
                --else
                --    exports.oInfobox:outputInfoBox("Szerelésre csak este 10 és reggel 8 óra között van lehetőség!", "error")
                --end
            end
        end
    end
end)

addEventHandler("onClientColShapeLeave", resourceRoot, function(player, mdim)
    if player == localPlayer and mdim then 
        closePanel()
    end
end)

local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900

local panelHeight = {sy*0.05, sy*0.05}
clickTick = getTickCount()
local height = 0

local priceElements = {}

local fonts = {
    ["condensed-15"] = exports.oFont:getFont("condensed", 15),
    ["fontawesome-15"] = exports.oFont:getFont("fontawesome2", 15),
}

local alpha = 0
local tick = getTickCount()
local animType = "open"

local checkNeed = false

function renderPanel()
    if checkNeed then 
        if not getPedOccupiedVehicleSeat(localPlayer) then 
            closePanel()
        end
    end

    if animType == "open" then 
        alpha = interpolateBetween(alpha, 0, 0, 1, 0, 0, (getTickCount()-tick)/300, "Linear")
    else
        alpha = interpolateBetween(alpha, 0, 0, 0, 0, 0, (getTickCount()-tick)/300, "Linear")
    end

    height = interpolateBetween(panelHeight[2], 0, 0, panelHeight[1], 0, 0, (getTickCount()-clickTick)/400, "InOutQuad")
    
    dxDrawRectangle(sx*0.4, sy*0.5-height/2, sx*0.2, height, tocolor(30, 30, 30, 200*alpha))
    dxDrawRectangle(sx*0.4+2/myX*sx, sy*0.5-height/2+2/myY*sy, sx*0.2-4/myX*sx, height-4/myY*sy, tocolor(35, 35, 35, 255*alpha))

    dxDrawText("PAY N SPRAY", sx*0.4+2/myX*sx, sy*0.5-height/2+2/myY*sy, sx*0.4+2/myX*sx+sx*0.2-4/myX*sx, sy*0.5-height/2+2/myY*sy+ sy*0.03, tocolor(255, 255, 255, 255*alpha), 0.8/myX*sx, fonts["condensed-15"], "center", "center")
    dxDrawText(core:getServerName(), sx*0.4+2/myX*sx, sy*0.5-height/2+2/myY*sy, sx*0.4+2/myX*sx+sx*0.2-4/myX*sx, sy*0.5-height/2+2/myY*sy+ sy*0.04, tocolor(r, g, b, 255*alpha), 0.5/myX*sx, fonts["condensed-15"], "center", "bottom")

    dxDrawText(countPrice().."$", sx*0.4+10/myX*sx, sy*0.5-height/2+2/myY*sy, sx*0.4+10/myX*sx+sx*0.2-4/myX*sx, sy*0.5-height/2+2/myY*sy+ sy*0.045, tocolor(r, g, b, 255*alpha), 0.75/myX*sx, fonts["condensed-15"], "left", "center")

    if core:isInSlot(sx*0.575, sy*0.5-height/2+2/myY*sy, sx*0.02, sy*0.045) then 
        dxDrawText("", sx*0.565, sy*0.5-height/2+2/myY*sy, sx*0.565+sx*0.028, sy*0.5-height/2+2/myY*sy+sy*0.045, tocolor(r, g, b, 255*alpha), 1/myX*sx, fonts["fontawesome-15"], "right", "center")
    else
        dxDrawText("", sx*0.565, sy*0.5-height/2+2/myY*sy, sx*0.565+sx*0.028, sy*0.5-height/2+2/myY*sy+sy*0.045, tocolor(255, 255, 255, 255*alpha), 1/myX*sx, fonts["fontawesome-15"], "right", "center")
    end
    
    local startY = sy*0.5-height/2 + sy*0.05
    for k, v in ipairs(priceElements) do 
        local color1 = tocolor(30, 30, 30, 220*alpha)
        local color2 = tocolor(r, g, b, 255*alpha)

        if (k % 2) == 0 then 
            color1 = tocolor(30, 30, 30, 150*alpha)
            color2 = tocolor(r, g, b, 150*alpha)
        end 

        dxDrawRectangle(sx*0.4+2/myX*sx, startY, sx*0.2-5/myX*sx, sy*0.04, color1)
        dxDrawRectangle(sx*0.4+2/myX*sx, startY, 1/myX*sx, sy*0.04, color2)

        if v[3] then 
            if core:isInSlot(sx*0.4+2/myX*sx, startY, sx*0.2-5/myX*sx, sy*0.04) then 
                dxDrawText("Törlés", sx*0.4+2/myX*sx, startY, sx*0.4+2/myX*sx+sx*0.2-5/myX*sx, startY+sy*0.04, tocolor(212, 42, 0, 200*alpha), 0.6/myX*sx, fonts["condensed-15"], "center", "center")
            else
                dxDrawText(v[1], sx*0.4+10/myX*sx, startY, sx*0.4+10/myX*sx+sx*0.1, startY+sy*0.04, tocolor(255, 255, 255, 255*alpha), 0.6/myX*sx, fonts["condensed-15"], "left", "center", false, false, false, true)
                dxDrawText(v[2].."$", sx*0.4+10/myX*sx, startY, sx*0.4+10/myX*sx+sx*0.189, startY+sy*0.04, tocolor(r, g, b, 255*alpha), 0.6/myX*sx, fonts["condensed-15"], "right", "center", false, false, false, true)
            end
        else
            dxDrawText(v[1], sx*0.4+10/myX*sx, startY, sx*0.4+10/myX*sx+sx*0.1, startY+sy*0.04, tocolor(255, 255, 255, 255*alpha), 0.6/myX*sx, fonts["condensed-15"], "left", "center", false, false, false, true)
            dxDrawText(v[2].."$", sx*0.4+10/myX*sx, startY, sx*0.4+10/myX*sx+sx*0.189, startY+sy*0.04, tocolor(r, g, b, 255*alpha), 0.6/myX*sx, fonts["condensed-15"], "right", "center", false, false, false, true)
        end
        startY = startY + sy*0.042
    end
end

local fixingSound = false
function keyPanel(key, state)
    if key == "mouse1" and state then 
        local startY = sy*0.5-height/2 + sy*0.05
        for k, v in ipairs(priceElements) do 
            if v[3] then 
                if core:isInSlot(sx*0.4+2/myX*sx, startY, sx*0.2-5/myX*sx, sy*0.04) then 
                    table.remove(priceElements, k)

                    clickTick = getTickCount()
                    panelHeight[2] = height
                    panelHeight[1] = sy*0.05 + (sy*0.0425*#priceElements)
                end
            end
            startY = startY + sy*0.042
        end

        
        if core:isInSlot(sx*0.575, sy*0.5-height/2+2/myY*sy, sx*0.02, sy*0.045) then 
            if getElementData(localPlayer, "char:money") >= countPrice() then 
                exports.oInfobox:outputInfoBox("Elkzedték a járműved szerelését!", "success")

                local fixNeededElements = {}

                for k, v in ipairs(priceElements) do 
                    if v[3] then 
                        table.insert(fixNeededElements, v[3])
                    end
                end

                triggerServerEvent("PayNSpray > startVehFixing", resourceRoot, getPedOccupiedVehicle(localPlayer), countPrice(), occupiedPayAndSpray, fixNeededElements)
                closePanel()

                fixingSound = playSound("files/wrench.wav", true)

                setElementData(getPedOccupiedVehicle(localPlayer), "inPayNSpary", true)
            else
                if #priceElements == 2 then 
                    closePanel()
                end
                exports.oInfobox:outputInfoBox("Nincs elegendő pénzed ajármű szereltetéséhez!", "error")
            end
        end
    end
end

function openPanel()
    checkNeed = true
    priceElements = {{"Alap díj", 500}}

    local occupiedVeh = getPedOccupiedVehicle(localPlayer)
    table.insert(priceElements, {"Motor", math.floor((1000-getElementHealth(occupiedVeh))*7)})

    for k2, v2 in pairs(getVehicleComponents(occupiedVeh)) do 
        local componentAllowed = false
        local componentIndex = 0
        for k3, v3 in ipairs(vehicleMechanicComponents) do 
            if v3.gtaName == k2 then 
                if v3.componentVisible then 
                    componentAllowed = true 
                    componentIndex = k3
                end
                break
            end
        end

        if componentAllowed then 
            if getComponentState(occupiedVeh, componentIndex) then 
                table.insert(priceElements, {vehicleMechanicComponents[componentIndex].name, vehicleMechanicComponents[componentIndex].price, componentIndex})
            end
        end
    end

    panelHeight = {sy*0.05 + (sy*0.0425*#priceElements),  sy*0.05 + (sy*0.0425*#priceElements)}

    tick = getTickCount()
    animType = "open"

    addEventHandler("onClientRender", root, renderPanel)
    addEventHandler("onClientKey", root, keyPanel)
end

function closePanel()
    checkNeed = false
    tick = getTickCount()
    animType = "close"
    removeEventHandler("onClientKey", root, keyPanel)
    setTimer(function() removeEventHandler("onClientRender", root, renderPanel) end, 300, 1)
end

addEvent("PayNSpray > end", true)
addEventHandler("PayNSpray > end", root, function()
    if isElement(fixingSound) then 
        destroyElement(fixingSound)
    end

    exports.oInfobox:outputInfoBox("A járműved szerelése befejeződött!", "success")
    setElementData(getPedOccupiedVehicle(localPlayer), "inPayNSpary", false)
end)

--
function countPrice()
    local price = 0 

    for k, v in ipairs(priceElements) do 
        price = price + v[2]
    end
    return price
end

function getComponentState(vehicle, componentIndex)
    if vehicleMechanicComponents[componentIndex].panelID then 
        if getVehiclePanelState(vehicle, vehicleMechanicComponents[componentIndex].panelID) > 0 then 
            if getVehiclePanelState(vehicle, vehicleMechanicComponents[componentIndex].panelID) == 3 then 
                return "missing"
            else
                return "fix"
            end
        else
            return false
        end
    elseif vehicleMechanicComponents[componentIndex].doorID then 
        if getVehicleDoorState(vehicle, vehicleMechanicComponents[componentIndex].doorID) >= 2 then 
            if getVehicleDoorState(vehicle, vehicleMechanicComponents[componentIndex].doorID) == 4 then 
                return "missing"
            else
                return "fix"
            end
        else
            return false
        end
    elseif vehicleMechanicComponents[componentIndex].wheelID then 
        local wheelStates = {getVehicleWheelStates(vehicle)}

        if wheelStates[vehicleMechanicComponents[componentIndex].wheelID] == 1 then 
            return "missing"
        elseif wheelStates[vehicleMechanicComponents[componentIndex].wheelID] == 2 then 
            return "missing"
        else
            return false
        end
    else
        return false
    end
end