local moveX, moveY = sx*0.445, sy*0.325

local buttons = {
    {false, false, getTickCount(), "open", 0.025},
    {false, false, getTickCount(), "open", 0.025},
}

addEventHandler("onClientResourceStart", resourceRoot, function()
    if exports.oJSON:loadDataFromJSONFile("airridePanelPos", true) then 
        moveX, moveY = unpack(exports.oJSON:loadDataFromJSONFile("airridePanelPos", true))
    end
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    exports.oJSON:saveDataToJSONFile({moveX, moveY}, "airridePanelPos", true)
end)

local clickX, clickY = 0, 0

local panelShowing = false

function drawAirRide()
    if not getPedOccupiedVehicle(localPlayer) then 
        showAirridePanel()
        return
    end

    dxDrawRectangle(moveX, moveY, sx*0.05, sy*0.252, tocolor(35, 35, 35, 255))
    dxDrawRectangle(moveX+2/myX*sx, moveY+2/myY*sy, sx*0.05-4/myX*sx, sy*0.252-4/myY*sy, tocolor(40, 40, 40, 255))

    dxDrawRectangle(moveX+4/myX*sx, moveY+4/myY*sy, sx*0.05-8/myX*sx, sy*0.08, tocolor(35, 35, 35, 255))
    dxDrawText((getElementData(getPedOccupiedVehicle(localPlayer), "veh:airride") or 0), moveX+4/myX*sx, moveY+4/myY*sy, moveX+4/myX*sx+sx*0.05-8/myX*sx, moveY+4/myY*sy+sy*0.08, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["bebasneue-25"], "center", "center")

    dxDrawRectangle(moveX+4/myX*sx, moveY+4/myY*sy+sy*0.082, sx*0.05-8/myX*sx, sy*0.08, tocolor(35, 35, 35, 255))
    dxDrawRectangle(moveX+4/myX*sx, moveY+4/myY*sy+(sy*0.082*2), sx*0.05-8/myX*sx, sy*0.08, tocolor(35, 35, 35, 255))

    dxDrawRectangle(moveX+4/myX*sx, moveY+4/myY*sy+sy*0.082, (sx*0.05-8/myX*sx)*buttons[1][5], sy*0.08, tocolor(r, g, b, 255*math.max(1*buttons[1][5], 0.3)))
    dxDrawImage(moveX+4/myX*sx+20/myX*sx, moveY+4/myY*sy+sy*0.082+20/myX*sx, 40/myX*sx, 40/myY*sy, "files/arrow.png", 270, 0, 0)

    if core:isInSlot(moveX+4/myX*sx, moveY+4/myY*sy+sy*0.082, sx*0.05-8/myX*sx, sy*0.08) then 
        if not buttons[1][1] then 
            buttons[1][1] = true 
            buttons[1][2] = false
        else
            if not buttons[1][2] then 
                buttons[1][2] = true 
                buttons[1][3] = getTickCount()
                buttons[1][4] = "open"
            end

            if buttons[1][4] == "open" then 
                buttons[1][5] = interpolateBetween(buttons[1][5], 0, 0, 1, 0, 0, (getTickCount() - buttons[1][3])/500, "Linear")
            end
        end
    else
        if buttons[1][1] then 
            buttons[1][1] = false
            buttons[1][2] = false
        else
            if not buttons[1][2] then 
                buttons[1][2] = true 
                buttons[1][3] = getTickCount()
                buttons[1][4] = "close"
            end

            if buttons[1][4] == "close" then 
                buttons[1][5] = interpolateBetween(buttons[1][5], 0, 0, 0.025, 0, 0, (getTickCount() - buttons[1][3])/500, "Linear")
            end
        end
    end

    dxDrawRectangle(moveX+4/myX*sx, moveY+4/myY*sy+(sy*0.082*2), (sx*0.05-8/myX*sx)*buttons[2][5], sy*0.08, tocolor(r, g, b, 255*math.max(1*buttons[2][5], 0.3)))
    dxDrawImage(moveX+4/myX*sx+20/myX*sx, moveY+4/myY*sy+(sy*0.082*2)+20/myX*sx, 40/myX*sx, 40/myY*sy, "files/arrow.png", 90, 0, 0)

    if core:isInSlot(moveX+4/myX*sx, moveY+4/myY*sy+(sy*0.082*2), sx*0.05-8/myX*sx, sy*0.08) then 
        if not buttons[2][1] then 
            buttons[2][1] = true 
            buttons[2][2] = false
        else
            if not buttons[2][2] then 
                buttons[2][2] = true 
                buttons[2][3] = getTickCount()
                buttons[2][4] = "open"
            end

            if buttons[2][4] == "open" then 
                buttons[2][5] = interpolateBetween(buttons[2][5], 0, 0, 1, 0, 0, (getTickCount() - buttons[2][3])/500, "Linear")
            end
        end
    else
        if buttons[2][1] then 
            buttons[2][1] = false
            buttons[2][2] = false
        else
            if not buttons[2][2] then 
                buttons[2][2] = true 
                buttons[2][3] = getTickCount()
                buttons[2][4] = "close"
            end

            if buttons[2][4] == "close" then 
                buttons[2][5] = interpolateBetween(buttons[2][5], 0, 0, 0.025, 0, 0, (getTickCount() - buttons[2][3])/500, "Linear")
            end
        end
    end

    if moveing then 
        if not isCursorShowing() then moveing = false return end
        local cx, cy = getCursorPosition()

        if ((cx*sx-clickX+sx*0.05) < sx) and ((cx*sx-clickX+sx*0.05) > 0) and ((cy*sy-clickY+sy*0.252) < sy) then 
            if cx*sx-clickX > 0 then 
                if cy*sy-clickY > 0 then 
                    moveX, moveY = cx*sx-clickX, cy*sy-clickY
                else
                    moveing = false
                end
            else
                moveing = false
            end
        end
    end
end

local lastinteraction = 0
function keyAirRide(key, state)
    if state then 
        if key == "mouse1" then 
            if lastinteraction + 300 < getTickCount() then 
                if core:isInSlot(moveX+4/myX*sx, moveY+4/myY*sy+sy*0.082, sx*0.05-8/myX*sx, sy*0.08) then 
                    local height = (getElementData(getPedOccupiedVehicle(localPlayer), "veh:airride") or 0) 
                    
                    if height < 5 then 
                        setElementData(getPedOccupiedVehicle(localPlayer), "veh:airride", height + 1)

                        local level = (height+1)/10

                        level = 0 - level

                        --print(handling["suspensionLowerLimit"], level)

                        triggerServerEvent("tuning > modifyVehicleAirrideLevel", resourceRoot, getPedOccupiedVehicle(localPlayer), level)
                        playSound("files/sounds/airride.mp3")
                        lastinteraction = getTickCount()
                    end
                end

                if core:isInSlot(moveX+4/myX*sx, moveY+4/myY*sy+(sy*0.082*2), sx*0.05-8/myX*sx, sy*0.08) then 
                    local height = (getElementData(getPedOccupiedVehicle(localPlayer), "veh:airride") or 0) 

                    if height > -5 then 
                        setElementData(getPedOccupiedVehicle(localPlayer), "veh:airride", height - 1)

                        local level = (height-1)/10

                        level = 0 - level

                        --print(handling["suspensionLowerLimit"], level)

                        triggerServerEvent("tuning > modifyVehicleAirrideLevel", resourceRoot, getPedOccupiedVehicle(localPlayer), level)
                        playSound("files/sounds/airride.mp3")
                        lastinteraction = getTickCount()
                    end
                end
            end
        end
    end

    if key == "mouse1" then 
        if state then 
            if core:isInSlot(moveX+4/myX*sx, moveY+4/myY*sy, sx*0.05-8/myX*sx, sy*0.08) then                 
                local cx, cy = getCursorPosition()
                cx, cy = cx*sx, cy*sy 

                clickX, clickY = cx - moveX, cy - moveY

                moveing = true 
            end
        else
            if moveing then 
                moveing = false
            end
        end
    end
end

function showAirridePanel()
    if panelShowing then 
        removeEventHandler("onClientKey", root, keyAirRide)
        removeEventHandler("onClientRender", root, drawAirRide)
        panelShowing = false
    else
        addEventHandler("onClientKey", root, keyAirRide)
        addEventHandler("onClientRender", root, drawAirRide)
        panelShowing = true
    end
end

addCommandHandler("airride", function()
    if not getPedOccupiedVehicle(localPlayer) then return end 
    if not (getPedOccupiedVehicleSeat(localPlayer) == 0) then return end
    if (getElementData(getPedOccupiedVehicle(localPlayer), "veh:tuning:airride") or 0) == 0 then return end
    showAirridePanel()
end)