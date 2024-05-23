local marker = createMarker(2192.2944335938, -1984.2502441406, 11, "cylinder", 3.0, 245, 66, 66, 100)

local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900

local core = exports.oCore
local color, r, g, b = core:getServerColor()

local fonts = {
    ["bebasneue-35"] = exports.oFont:getFont("bebasneue", 35),

    ["condensed-15"] = exports.oFont:getFont("condensed", 15),
}

local clickCount = 0

local tick = getTickCount()
local animType = "open"
local alpha = 0

function renderJunkyardPanel()
    if not getPedOccupiedVehicle(localPlayer) then closePanel() end

    if animType == "open" then 
        alpha = interpolateBetween(alpha, 0, 0, 1, 0, 0, (getTickCount()-tick)/300, "Linear")
    else
        alpha = interpolateBetween(alpha, 0, 0, 0, 0, 0, (getTickCount()-tick)/300, "Linear")
    end

    dxDrawRectangle(sx*0.4, sy*0.35, sx*0.2, sy*0.25, tocolor(30, 30, 30, 200*alpha))
    dxDrawRectangle(sx*0.4+2/myX*sx, sy*0.35+2/myY*sy, sx*0.2-4/myX*sx, sy*0.25-4/myY*sy, tocolor(35, 35, 35, 255*alpha))

    --dxDrawRectangle(sx*0.4+2/myX*sx, sy*0.36, sx*0.2-6/myX*sx, sy*0.1, tocolor(30, 30, 30, 255))
    dxDrawImage(sx*0.5-35/myX*sx, sy*0.38, 70/myX*sx, 70/myY*sy, "files/crane.png", 0, 0, 0, tocolor(r, g, b, 100*alpha))
    dxDrawText("Junkyard", sx*0.4+2/myX*sx, sy*0.36, sx*0.4+2/myX*sx+sx*0.2-6/myX*sx, sy*0.36+sy*0.1, tocolor(255, 255, 255, 255*alpha), 0.8/myX*sx, fonts["bebasneue-35"], "center", "center")
    --dxDrawText("Original Roleplay", sx*0.4+2/myX*sx, sy*0.36, sx*0.4+2/myX*sx+sx*0.2-6/myX*sx, sy*0.36+sy*0.1, tocolor(r, g, b, 255), 0.35/myX*sx, fonts["bebasneue-35"], "center", "top")
    dxDrawText("Willowfield", sx*0.4+2/myX*sx, sy*0.36, sx*0.4+2/myX*sx+sx*0.2-6/myX*sx, sy*0.36+sy*0.09, tocolor(255, 255, 255, 255*alpha), 0.4/myX*sx, fonts["bebasneue-35"], "center", "bottom")

    local occupiedVeh = getPedOccupiedVehicle(localPlayer)
    if not occupiedVeh then return end
    local price 
    local vehType = getVehicleType(occupiedVeh)

    if getElementModel(occupiedVeh) == 604 then
        price = 100000
    else
        if vehType == "BMX" then 
            price = exports.oCarshop:getVehiclePriceInCarshop(getElementModel(occupiedVeh), 3)
        else
            price = exports.oCarshop:getVehiclePriceInCarshop(getElementModel(occupiedVeh), 1)
        end
    end

    if price then 
        price = price * 0.4
        price = math.floor(price)
        dxDrawText("Ezt a járművet \n"..color..price.."$#ffffff-ért zúzathatod be!", sx*0.4+2/myX*sx, sy*0.48, sx*0.4+2/myX*sx+sx*0.2-6/myX*sx, sy*0.48+sy*0.09, tocolor(255, 255, 255, 255*alpha), 0.75/myX*sx, fonts["condensed-15"], "center", "top", false, false, false, true)

    else
        dxDrawText("Ezt a járművet \nnem zúzathatod be!", sx*0.4+2/myX*sx, sy*0.48, sx*0.4+2/myX*sx+sx*0.2-6/myX*sx, sy*0.48+sy*0.09, tocolor(255, 255, 255, 255*alpha), 0.75/myX*sx, fonts["condensed-15"], "center", "top", false, false, false, true)

    end

    dxDrawRectangle(sx*0.4+2/myX*sx, sy*0.555, sx*0.2-6/myX*sx, sy*0.04, tocolor(30, 30, 30, 255*alpha))
    dxDrawRectangle(sx*0.4+2/myX*sx, sy*0.555, 1.5/myX*sx, sy*0.04, tocolor(r, g, b, 255*alpha))

    
    if clickCount == 0 then 
        dxDrawText("Zúzatás", sx*0.4+10/myX*sx, sy*0.555, sx*0.4+10/myX*sx+sx*0.2-6/myX*sx, sy*0.555+sy*0.04, tocolor(255, 255, 255, 255*alpha), 0.7/myX*sx, fonts["condensed-15"], "left", "center")
    else
        dxDrawText("Biztosan be szeretnéd zúzatni a járműved?", sx*0.4+10/myX*sx, sy*0.555, sx*0.4+10/myX*sx+sx*0.2-6/myX*sx, sy*0.555+sy*0.04, tocolor(255, 255, 255, 255*alpha), 0.7/myX*sx, fonts["condensed-15"], "left", "center")
    end
end

function keyJunkyardPanel(key, state)
    if key == "mouse1" and state then 
        if core:isInSlot(sx*0.4+2/myX*sx, sy*0.555, sx*0.2-6/myX*sx, sy*0.04) then 
            local occupiedVeh = getPedOccupiedVehicle(localPlayer)

            if getElementData(occupiedVeh, "veh:isFactionVehice") == 0 then 
                if getElementData(occupiedVeh, "veh:owner") == getElementData(localPlayer, "char:id") then 
                    clickCount = clickCount + 1

                    if clickCount == 2 then 
                        local price 

                        local vehType = getVehicleType(occupiedVeh)

                        if getElementModel(occupiedVeh) == 604 then
                            price = 100000
                        else
                            if vehType == "BMX" then 
                                price = exports.oCarshop:getVehiclePriceInCarshop(getElementModel(occupiedVeh), 3)
                            else
                                price = exports.oCarshop:getVehiclePriceInCarshop(getElementModel(occupiedVeh), 1)
                            end
                        end                    

                        if price then 
                            price = price * 0.4
                            price = math.floor(price)
                            triggerServerEvent("junkyard > destroyVeh", resourceRoot, occupiedVeh, price)
                            exports.oInfobox:outputInfoBox("Sikeresen bezúzatad a járművedet!", "success")
                        else
                            exports.oInfobox:outputInfoBox("Ezt a járművet nem zúzathatod be!", "error")
                        end
                    end
                else
                    exports.oInfobox:outputInfoBox("Csak a saját járművedet zúzathatod be!", "error")
                end
            else
                exports.oInfobox:outputInfoBox("Frakció járművet nem zúzhatsz be!", "error")
            end
        end
    end
end

function openPanel()
    clickCount = 0
    tick = getTickCount()
    animType = "open"
    addEventHandler("onClientRender", root, renderJunkyardPanel)
    addEventHandler("onClientKey", root, keyJunkyardPanel)
end

function closePanel()
    tick = getTickCount()
    animType = "close"

    setTimer(function()
        removeEventHandler("onClientRender", root, renderJunkyardPanel)
    end, 250, 1)
    removeEventHandler("onClientKey", root, keyJunkyardPanel)
end

addEventHandler("onClientMarkerHit", resourceRoot, function(player, mdim)
    if player == localPlayer and mdim then 
        if getPedOccupiedVehicleSeat(localPlayer) == 0 then
            openPanel()
        end
    end
end)

addEventHandler("onClientMarkerLeave", resourceRoot, function(player, mdim)
    if player == localPlayer and mdim then 
        closePanel()
    end
end)