sx, sy = guiGetScreenSize()
myX, myY = 1768, 992

setElementData(localPlayer, "canWindowControll", true)

fonts = {
    ["condensed-12"] = exports.oFont:getFont("condensed", 12),
}

windowNames = {"Bal első", "Jobb első", "Bal hátsó", "Jobb hátsó"}

local animType = "open"
local animTick = getTickCount()
local animValue = 0

local winPanel = {sx*0.001, sy*0.45}
local winSize = {sx*0.0945, sy*0.162}
local isPanelMoveing = false

function drawWindowControlPanel()
    if not getPedOccupiedVehicle(localPlayer) then 
        removeEventHandler("onClientKey", root, keyWindowControlPanel)
        removeEventHandler("onClientRender", root, drawWindowControlPanel)
        return
    end

    if animType == "open" then 
        animValue = interpolateBetween(animValue, 0, 0, 1, 0, 0, (getTickCount()-animTick)/300, "Linear")
    else
        animValue = interpolateBetween(animValue, 0, 0, 0, 0, 0, (getTickCount()-animTick)/300, "Linear")
    end

    dxDrawRectangle(winPanel[1], winPanel[2], winSize[1], winSize[2], tocolor(30, 30, 30, 255*animValue))
    dxDrawRectangle(winPanel[1], winPanel[2], winSize[1], sy*0.02, tocolor(27, 27, 27, 255*animValue))

    dxDrawText("Ablakok kezelése", winPanel[1], winPanel[2], winPanel[1]+sx*0.0945, winPanel[2]+sy*0.02, tocolor(255, 255, 255, 255*animValue), 0.7/myX*sx, fonts["condensed-12"], "center", "center")
    
    local startX, startY = winPanel[1], winPanel[2]+23/myY*sy
    local windowStates = (getElementData(getPedOccupiedVehicle(localPlayer), "veh:windowStates") or {false, false, false, false})

    for i = 1, 4 do 
        dxDrawRectangle(startX+3/myX*sx, startY, sx*0.045, sy*0.04, tocolor(35, 35, 35, 255*animValue))

        local stateText = ""

        if windowStates[i] then 
            stateText = "#9cd64bleengedve"
        else
            stateText = "#eb4646felhúzva"
        end
        
        if core:isInSlot(startX+3/myX*sx, startY, sx*0.045, sy*0.04) then 
            dxDrawText(windowNames[i] .. "\n" .. stateText, startX+3/myX*sx, startY, startX+3/myX*sx+sx*0.045, startY+sy*0.04, tocolor(r, g, b, 255*animValue), 0.75/myX*sx, fonts["condensed-12"], "center", "center", false, false, false, true)
        else
            dxDrawText(windowNames[i] .. "\n" .. stateText, startX+3/myX*sx, startY, startX+3/myX*sx+sx*0.045, startY+sy*0.04, tocolor(255, 255, 255, 255*animValue), 0.75/myX*sx, fonts["condensed-12"], "center", "center", false, false, false, true)
        end
        
        if i%2 == 0 then 
            startY = startY + sy*0.04+2/myY*sy
            startX = winPanel[1]
        else
            startX = startX + sx*0.045+2/myX*sx
        end
    end

    dxDrawRectangle(winPanel[1]+3/myX*sx, winPanel[2]+106/myY*sy, sx*0.09+2/myX*sx, sy*0.025, tocolor(35, 35, 35, 255*animValue))
    if core:isInSlot(winPanel[1]+3/myX*sx, winPanel[2]+106/myY*sy, sx*0.09+2/myX*sx, sy*0.025) then 
        dxDrawText("Összes ablak felhúzása", winPanel[1]+3/myX*sx, winPanel[2]+106/myY*sy, winPanel[1]+3/myX*sx+sx*0.09+2/myX*sx, winPanel[2]+106/myY*sy+sy*0.025, tocolor(r, g, b, 255*animValue), 0.75/myX*sx, fonts["condensed-12"], "center", "center")
    else
        dxDrawText("Összes ablak felhúzása", winPanel[1]+3/myX*sx, winPanel[2]+106/myY*sy, winPanel[1]+3/myX*sx+sx*0.09+2/myX*sx, winPanel[2]+106/myY*sy+sy*0.025, tocolor(255, 255, 255, 255*animValue), 0.75/myX*sx, fonts["condensed-12"], "center", "center")
    end
            
    dxDrawRectangle(winPanel[1]+3/myX*sx, winPanel[2]+106/myY*sy+sy*0.025+2/myY*sy, sx*0.09+2/myX*sx, sy*0.025, tocolor(35, 35, 35, 255*animValue))
    if core:isInSlot(winPanel[1]+3/myX*sx, winPanel[2]+106/myY*sy+sy*0.025+2/myY*sy, sx*0.09+2/myX*sx, sy*0.025) then 
        dxDrawText("Összes ablak leengedése", winPanel[1]+3/myX*sx, winPanel[2]+106/myY*sy+sy*0.025+2/myY*sy, winPanel[1]+3/myX*sx+sx*0.09+2/myX*sx, winPanel[2]+106/myY*sy+sy*0.025+sy*0.025+2/myY*sy, tocolor(r, g, b, 255*animValue), 0.75/myX*sx, fonts["condensed-12"], "center", "center")
    else
        dxDrawText("Összes ablak leengedése", winPanel[1]+3/myX*sx, winPanel[2]+106/myY*sy+sy*0.025+2/myY*sy, winPanel[1]+3/myX*sx+sx*0.09+2/myX*sx, winPanel[2]+106/myY*sy+sy*0.025+sy*0.025+2/myY*sy, tocolor(255, 255, 255, 255*animValue), 0.75/myX*sx, fonts["condensed-12"], "center", "center")
    end

    if isPanelMoveing then 
        if not isCursorShowing() then isPanelMoveing = false return end
        local cx, cy = getCursorPosition()
        cx, cy = cx*sx, cy*sy 

        local newX, newY = cx-isPanelMoveing[1], cy-isPanelMoveing[2] 

        if newX < 0 or newY < 0 then return end 
        if newX + winSize[1] > sx or newY + winSize[2] > sy then return end 

        winPanel = {cx-isPanelMoveing[1], cy-isPanelMoveing[2]} 
    end
end        

function keyWindowControlPanel(key, state)
    if key == "mouse1" then 
        if state then 
            if core:isInSlot(winPanel[1], winPanel[2], sx*0.0945, sy*0.02) then 
                local cx, cy = getCursorPosition()
                cx, cy = cx*sx, cy*sy 

                cx, cy = cx-winPanel[1], cy-winPanel[2]
                isPanelMoveing = {cx, cy}
            end

            if not getElementData(localPlayer, "canWindowControll") then return end
                

            local startX, startY = winPanel[1], winPanel[2]+23/myY*sy
            local windowStates = getElementData(getPedOccupiedVehicle(localPlayer), "veh:windowStates") or {false, false, false, false}

            for i = 1, 4 do 
                if core:isInSlot(startX+3/myX*sx, startY, sx*0.045, sy*0.04) then 
                    windowStates[i] = not windowStates[i]
                    setElementData(getPedOccupiedVehicle(localPlayer), "veh:windowStates", windowStates)

                    if windowStates[i] then 
                        exports.oChat:sendLocalMeAction("lehúzott egy ablakot.")
                            
                        setElementData(localPlayer, "canWindowControll", false)
                        setTimer(function()
                            setElementData(localPlayer, "canWindowControll", true)
                        end, 1500, 1)
                    else
                        exports.oChat:sendLocalMeAction("felhúzott egy ablakot.")
                            
                        setElementData(localPlayer, "canWindowControll", false)
                        setTimer(function()
                            setElementData(localPlayer, "canWindowControll", true)
                        end, 1500, 1)
                    end
                end
                
                if i%2 == 0 then 
                    startY = startY + sy*0.04+2/myY*sy
                    startX = winPanel[1]
                else
                    startX = startX + sx*0.045+2/myX*sx
                end
            end

            if core:isInSlot(winPanel[1]+3/myX*sx, winPanel[2]+106/myY*sy, sx*0.09+2/myX*sx, sy*0.025) then 
                setElementData(getPedOccupiedVehicle(localPlayer), "veh:windowStates", {false, false, false, false})

                setElementData(localPlayer, "canWindowControll", false)
                setTimer(function()
                    setElementData(localPlayer, "canWindowControll", true)
                end, 1500, 1)
            end

            if core:isInSlot(winPanel[1]+3/myX*sx, winPanel[2]+106/myY*sy+sy*0.025+2/myY*sy, sx*0.09+2/myX*sx, sy*0.025) then 
                setElementData(getPedOccupiedVehicle(localPlayer), "veh:windowStates", {true, true, true, true})

                setElementData(localPlayer, "canWindowControll", false)
                setTimer(function()
                    setElementData(localPlayer, "canWindowControll", true)
                end, 1500, 1)
            end
        else
            isPanelMoveing = false
        end
    end
end

local isPanelShowing = false
local lastInteraction = 0

function togglePanel()
    if not getPedOccupiedVehicle(localPlayer) then return end 
    if getVehicleType(getPedOccupiedVehicle(localPlayer)) == "Automobile" then 
        local seat = getPedOccupiedVehicleSeat(localPlayer)
        if seat == 0 then 
            if lastInteraction + 300 < getTickCount() then 
                lastInteraction = getTickCount()
                isPanelShowing = not isPanelShowing 

                if isPanelShowing then 
                    animType = "open"
                    animTick = getTickCount()

                    addEventHandler("onClientRender", root, drawWindowControlPanel)
                    addEventHandler("onClientKey", root, keyWindowControlPanel)
                else
                    animType = "close"
                    animTick = getTickCount()

                    removeEventHandler("onClientKey", root, keyWindowControlPanel)
                    setTimer(function()
                        removeEventHandler("onClientRender", root, drawWindowControlPanel)
                    end, 300, 1)
                end
            end
        else
            local windows = getElementData(getPedOccupiedVehicle(localPlayer), "veh:windowStates") or {false, false, false, false}
            windows[seat + 1] = not windows[seat + 1] 

            setElementData(getPedOccupiedVehicle(localPlayer), "veh:windowStates", windows)

            if windows[seat + 1] then 
                exports.oChat:sendLocalMeAction("lehúzott egy ablakot.")
            else
                exports.oChat:sendLocalMeAction("felhúzott egy ablakot.")
            end
        end
    end
end
bindKey("F4", "up", togglePanel)

addEventHandler("onClientResourceStop", resourceRoot, function()
    exports.oJSON:saveDataToJSONFile(winPanel, "windowsPanelPos", true)
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    winPanel = (exports.oJSON:loadDataFromJSONFile("windowsPanelPos", true) or {sx*0.001, sy*0.45})
end)

local seatWindows = {
	[1] = 4,
	[2] = 2,
	[3] = 5,
	[4] = 3,
}

addEventHandler("onClientElementDataChange", resourceRoot, function(data, old, new)
    local occupiedVeh = getPedOccupiedVehicle(localPlayer) or false

    if getElementType(source) == "vehicle" then 
        if data == "veh:windowStates" then 
            if source == occupiedVeh then 
                playSound("files/window.mp3")
            end

            for k, v in ipairs(seatWindows) do 
                setVehicleWindowOpen(source, seatWindows[k], new[k])
            end
        end
    end
end)

addEventHandler("onClientElementStreamIn", resourceRoot, function()
    if getElementType(source) == "vehicle" then 
        local windows = getElementData(source, "veh:windowStates") or {false, false, false, false}
        for k, v in ipairs(seatWindows) do 
            setVehicleWindowOpen(source, seatWindows[k], windows[k])
        end
    end
end)