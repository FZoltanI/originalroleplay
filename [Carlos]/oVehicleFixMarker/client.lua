local markers = {
    {pos = {1566.0612792969,-2416.49609375,12.5546875}, blip = 62, name = "Helikopter szervíz", type = "Helicopter"},
    {pos = {-859.16833496094,203.07759094238,-0.55000001192093}, blip = 63, name = "Hajó szervíz", type = "Boat"},
    --{pos = {-2291.2885742188, 2482.3051757812, -0.01854207515717}, blip = 63, name = "Hajó szervíz", type = "Boat"},
}

local core = exports.oCore
local color, r, g, b = core:getServerColor()
local infobox = exports.oInfobox

for k, v in ipairs(markers) do 
    local marker = createMarker(v.pos[1], v.pos[2], v.pos[3], "cylinder", 4.0, r, g, b, 100)
    local blip = createBlip(v.pos[1], v.pos[2], v.pos[3], v.blip)
    setElementData(blip, "blip:name", v.name)
    setElementData(marker, "fixMarker:type", v.type)
    setElementData(marker, "fixMarker:pos", v.pos)
end

local sx, sy = guiGetScreenSize()
local myX, myY = 1768, 992

local vehType = "Boat"
local vehTypeNames = {
    ["Boat"] = "Hajó szervíz",
    ["Helicopter"] = "Helikopter szervíz",
}
local buttons = {
    {"Jármű szerelése ({fix_price}$)", "fix_veh", r, g, b, 200},
    {"Jármű tankolása ({fuel_price}$)", "fuel_veh", r, g, b, 200},
    {"Bezárás", "close", 245, 66, 66, 200},
}

function renderSelectorPanel()
    dxDrawRectangle(sx*0.4, sy*0.4, sx*0.2, sy*0.15, tocolor(30, 30, 30, 100))
    dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.4 + 2/myY*sy, sx*0.2 - 4/myX*sx, sy*0.15 - 4/myY*sy, tocolor(35, 35, 35, 255))
    dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.4 + 2/myY*sy, sx*0.2 - 4/myX*sx, sy*0.02, tocolor(30, 30, 30, 255))
    dxDrawText(vehTypeNames[vehType], sx*0.4 + 2/myX*sx, sy*0.4 + 2/myY*sy, sx*0.4 + 2/myX*sx + sx*0.2 - 4/myX*sx, sy*0.4 + 2/myY*sy + sy*0.02, tocolor(255, 255, 255, 100), 1, exports.oFont:getFont("condensed", 10/myX*sx), "center", "center")

    local startY = sy*0.41 + 17/myY*sy
    for k, v in ipairs(buttons) do
        local text = v[1]

        local fix_price = math.floor(1000 - getElementHealth(getPedOccupiedVehicle(localPlayer)))*25
        local fuel_price = math.floor(getElementData(getPedOccupiedVehicle(localPlayer), "veh:maxFuel") - getElementData(getPedOccupiedVehicle(localPlayer), "veh:fuel")) * 100
        text = text:gsub("{fix_price}", fix_price)
        text = text:gsub("{fuel_price}", fuel_price)

        core:dxDrawButton(sx*0.4 + 4/myX*sx, startY, sx*0.2 - 8/myX*sx, sy*0.035, v[3], v[4], v[5], v[6], text, tocolor(255, 255, 255, 255), 1, exports.oFont:getFont("condensed", 11/myX*sx), true, tocolor(0, 0, 0, 100)) 

        startY = startY + sy*0.04
    end
end

function keySelectorPanel(key, state)
    if key == "mouse1" and state then 
        local startY = sy*0.41 + 17/myY*sy
        for k, v in ipairs(buttons) do    
            local fix_price = math.floor(1000 - getElementHealth(getPedOccupiedVehicle(localPlayer)))*25
            local fuel_price = math.floor(getElementData(getPedOccupiedVehicle(localPlayer), "veh:maxFuel") - getElementData(getPedOccupiedVehicle(localPlayer), "veh:fuel")) * 100
    
            if core:isInSlot(sx*0.4 + 4/myX*sx, startY, sx*0.2 - 8/myX*sx, sy*0.035) then 
                if getKeyState("mouse1") then 
                    if v[2] == "fix_veh" then 
                        if fix_price > 0 then 
                            if getElementData(localPlayer, "char:money") >= fix_price then 
                                setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money") - fix_price)
                                triggerServerEvent("fixMarker > fixVehicle", resourceRoot)
                            else
                                infobox:outputInfoBox("Nincs elég pénzed a szerelésre!", "error")
                            end
                        else
                            infobox:outputInfoBox("Nincs szükség a jármű szerelésére!", "error")
                        end
                    elseif v[2] == "fuel_veh" then 
                        if fuel_price > 0 then 
                            if getElementData(localPlayer, "char:money") >= fuel_price then 
                                setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money") - fuel_price)
                                setElementData(getPedOccupiedVehicle(localPlayer), "veh:fuel", getElementData(getPedOccupiedVehicle(localPlayer), "veh:maxFuel"))
                            else
                                infobox:outputInfoBox("Nincs elég pénzed a tankolásra!", "error")
                            end
                        else
                            infobox:outputInfoBox("Nincs szükség a jármű tankolására!", "error")
                        end
                    elseif v[2] == "close" then 
                        removeEventHandler("onClientRender", root, renderSelectorPanel)
                        setElementFrozen(getPedOccupiedVehicle(localPlayer), false)
                        toggleControl("enter_exit", true)
                        setElementData(getPedOccupiedVehicle(localPlayer), "adminFreeze", false)
                        removeEventHandler("onClientKey", root, keySelectorPanel)
                    end
                end
            end
    
            startY = startY + sy*0.04
        end
    end
end

addEventHandler("onClientMarkerHit", resourceRoot, function(player, mdim)
    if player == localPlayer and mdim then 
        if getPedOccupiedVehicle(localPlayer) then
            if getElementData(source, "fixMarker:type") then 
                if getElementData(source, "fixMarker:type") == getVehicleType(getPedOccupiedVehicle(localPlayer)) then 
                    if getPedOccupiedVehicleSeat(localPlayer) == 0 then
                        if core:getDistance(source, localPlayer) < 6 then
                            vehType = getVehicleType(getPedOccupiedVehicle(localPlayer))
                            local markerX, markerY, markerZ = getElementPosition(source)

                            if vehType == "Helicopter" then 
                                markerZ = markerZ + 2.5
                                setElementRotation(getPedOccupiedVehicle(localPlayer), 0, 0, 0)
                            end

                            setElementPosition(getPedOccupiedVehicle(localPlayer), markerX, markerY, markerZ)

                            setElementFrozen(getPedOccupiedVehicle(localPlayer), true)
                            toggleControl("enter_exit", false)

                            setElementData(getPedOccupiedVehicle(localPlayer), "adminFreeze", true)

                            addEventHandler("onClientRender", root, renderSelectorPanel)
                            addEventHandler("onClientKey", root, keySelectorPanel)
                        end
                    end
                end
            end
        end
    end
end)