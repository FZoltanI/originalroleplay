local pointerPos = sy*0.5
local cursorPos = {0, 0}
local state = false
local showing = false

function getCursorPos(x, y, absX, absY)
    --print(x, y, absX, absY)
    if (absY > sy*0.5-sy*0.15+2/myY*sy) and (absY < sy*0.5-sy*0.15+2/myY*sy+sy*0.3-4/myY*sy) then 
        pointerPos = absY
    end
end

function drawHandbrake()
    if not getPedOccupiedVehicle(localPlayer) then 
        removeEventHandler("onClientRender", root, drawHandbrake)
        removeEventHandler("onClientCursorMove", root, getCursorPos)
        showCursor(false)
        return
    end

    showCursor(true)
    dxDrawRectangle(sx*0.985, sy*0.5-sy*0.15, sx*0.008, sy*0.3, tocolor(30, 30, 30, 200))
    dxDrawRectangle(sx*0.985+2/myX*sx, sy*0.5-sy*0.15+2/myY*sy, sx*0.008-4/myX*sx, sy*0.3-4/myY*sy, tocolor(35, 35, 35, 255))
    dxDrawRectangle(sx*0.985+2/myX*sx, sy*0.5-sy*0.15+2/myY*sy+sy*0.3-(sy*0.07+4/myY*sy), sx*0.008-4/myX*sx, sy*0.07, tocolor(222, 70, 62, 255))
    dxDrawRectangle(sx*0.985+2/myX*sx, sy*0.5-sy*0.15+2/myY*sy, sx*0.008-4/myX*sx, sy*0.07, tocolor(106, 214, 99, 255))

    dxDrawRectangle(sx*0.9785-2/myX*sx, pointerPos-2.5/myY*sy-2/myY*sy, sx*0.02+4/myX*sx, 5/myY*sy+4/myY*sy, tocolor(220, 220, 220, 50))
    dxDrawRectangle(sx*0.9785, pointerPos-2.5/myY*sy, sx*0.02, 5/myY*sy, tocolor(220, 220, 220, 255))
end 

function openHandbrakePanel()
    if getPedOccupiedVehicleSeat(localPlayer) == 0 then 
        if getElementSpeed(getPedOccupiedVehicle(localPlayer)) > 5 then return end
        showing = true
        pointerPos = sy*0.5
        setCursorPosition(sx*0.5, sy*0.5)
        addEventHandler("onClientRender", root, drawHandbrake)
        addEventHandler("onClientCursorMove", root, getCursorPos)
    end
end

function closeHandbrakePanel()
    if getPedOccupiedVehicleSeat(localPlayer) == 0 then 
        if showing then 
            removeEventHandler("onClientRender", root, drawHandbrake)
            removeEventHandler("onClientCursorMove", root, getCursorPos)
            showCursor(false)

            if not getElementData(getPedOccupiedVehicle(localPlayer), "adminFreeze") then 
                if (pointerPos < sy*0.5-sy*0.15+2/myY*sy+sy*0.07) then 
                    if getElementData(getPedOccupiedVehicle(localPlayer), "vehicleInTeslaCharger") then return end
                    if getElementData(getPedOccupiedVehicle(localPlayer), "inPayNSpary") then return end 
                    
                    playSound("files/handbrake/off.wav")
                    setElementData(getPedOccupiedVehicle(localPlayer), "veh:handbrake", false)
                    triggerServerEvent("veh > setVehicleHandbrakeState", resourceRoot, getPedOccupiedVehicle(localPlayer), false)
                end

                if (pointerPos > sy*0.5-sy*0.15+2/myY*sy+sy*0.3-(sy*0.07+4/myY*sy)) then 
                    playSound("files/handbrake/on.wav")
                    setElementData(getPedOccupiedVehicle(localPlayer), "veh:handbrake", true)
                    triggerServerEvent("veh > setVehicleHandbrakeState", resourceRoot, getPedOccupiedVehicle(localPlayer), true)
                end
            end

            showing = false
        end
    end
end

bindKey("lalt", "down", openHandbrakePanel)
bindKey("lalt", "up", closeHandbrakePanel)