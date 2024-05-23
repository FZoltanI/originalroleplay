setElementData(localPlayer, "veh:vehSit:attachDatas", false)
local sx, sy = guiGetScreenSize()
local myX, myY = 1768, 992

addEventHandler("onClientRender", root, function()
    local sitData = getElementData(localPlayer, "veh:vehSit:attachDatas")
    if not getPedOccupiedVehicle(localPlayer) then
        if not sitData then
            local pX, pY, pZ = getElementPosition(localPlayer)
            for _, vehicle in ipairs(getElementsByType("vehicle", root, true)) do 
                if core:getDistance(localPlayer, vehicle) < 15 then
                    local model = getElementModel(vehicle)
                    local usageTable = getElementData(vehicle, "veh:vehSit:usageTable") or {}

                    if vehicleSitList[model] then 
                        local x, y, z = getElementPosition(vehicle)
                        for id, pos in ipairs(vehicleSitList[model]) do
                            if not isElement(usageTable[id]) then
                                local tempx, tempy, tempz = getPositionFromElementOffset(vehicle, pos[1], pos[2], pos[3])

                                if getDistanceBetweenPoints3D(tempx, tempy, tempz, pX, pY, pZ) < 1.5 then
                                    local screenX, screenY = getScreenFromWorldPosition(tempx, tempy, tempz)

                                    if screenX and screenY then 
                                        if core:isInSlot(screenX - 20/myX*sx, screenY - 20/myY*sy, 40/myX*sx, 40/myX*sx) then
                                            dxDrawRectangle(screenX - 20/myX*sx, screenY - 20/myY*sy, 40/myX*sx, 40/myX*sx, tocolor(30, 30, 30, 200))
                                            dxDrawImage(screenX - 15/myX*sx, screenY - 15/myY*sy, 30/myX*sx, 30/myX*sx, "files/sit.png", 0, 0, 0, tocolor(r, g, b, 200))
                                        else
                                            dxDrawRectangle(screenX - 20/myX*sx, screenY - 20/myY*sy, 40/myX*sx, 40/myX*sx, tocolor(30, 30, 30, 150))
                                            dxDrawImage(screenX - 15/myX*sx, screenY - 15/myY*sy, 30/myX*sx, 30/myX*sx, "files/sit.png", 0, 0, 0, tocolor(255, 255, 255, 150))
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        else
            local tempx, tempy, tempz = getPositionFromElementOffset(sitData[1], sitData[2][1], sitData[2][2], sitData[2][3])
            local screenX, screenY = getScreenFromWorldPosition(tempx, tempy, tempz)

            if screenX and screenY then 
                if core:isInSlot(screenX - 20/myX*sx, screenY - 20/myY*sy, 40/myX*sx, 40/myX*sx) then
                    dxDrawRectangle(screenX - 20/myX*sx, screenY - 20/myY*sy, 40/myX*sx, 40/myX*sx, tocolor(30, 30, 30, 200))
                    dxDrawImage(screenX - 15/myX*sx, screenY - 15/myY*sy, 30/myX*sx, 30/myX*sx, "files/stand_up.png", 0, 0, 0, tocolor(r, g, b, 200))
                else
                    dxDrawRectangle(screenX - 20/myX*sx, screenY - 20/myY*sy, 40/myX*sx, 40/myX*sx, tocolor(30, 30, 30, 150))
                    dxDrawImage(screenX - 15/myX*sx, screenY - 15/myY*sy, 30/myX*sx, 30/myX*sx, "files/stand_up.png", 0, 0, 0, tocolor(255, 255, 255, 150))
                end
            end
        end
    end

    local datas = getElementData(localPlayer, "veh:vehSit:attachDatas") or false
    if datas then 
        if isElement(datas[1]) then 
            local rx, ry, rz = getElementRotation(datas[1])
            setElementRotation(localPlayer, 0, 0, rz - datas[2][4])
        end
    end
end)

addEventHandler("onClientKey", root, function(key, state)
    if key == "mouse1" and state then
        if not getPedOccupiedVehicle(localPlayer) then
            local sitData = getElementData(localPlayer, "veh:vehSit:attachDatas")
            if not sitData then
                local pX, pY, pZ = getElementPosition(localPlayer)

                for _, vehicle in ipairs(getElementsByType("vehicle", root, true)) do 
                    if core:getDistance(localPlayer, vehicle) < 15 then
                        local model = getElementModel(vehicle)

                        if vehicleSitList[model] then 
                            local x, y, z = getElementPosition(vehicle)
                            for id, pos in ipairs(vehicleSitList[model]) do
                                local tempx, tempy, tempz = getPositionFromElementOffset(vehicle, pos[1], pos[2], pos[3])

                                if getDistanceBetweenPoints3D(tempx, tempy, tempz, pX, pY, pZ) < 1.5 then
                                    local screenX, screenY = getScreenFromWorldPosition(tempx, tempy, tempz)

                                    if screenX and screenY then 
                                        if core:isInSlot(screenX - 20/myX*sx, screenY - 20/myY*sy, 40/myX*sx, 40/myX*sx) then
                                            triggerServerEvent("vehicle > vehicleSit > sitDown", resourceRoot, vehicle, pos, id)
                                            chat:sendLocalMeAction("leül.")
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            else
                local tempx, tempy, tempz = getPositionFromElementOffset(sitData[1], sitData[2][1], sitData[2][2], sitData[2][3])
                local screenX, screenY = getScreenFromWorldPosition(tempx, tempy, tempz)
        
                if screenX and screenY then 
                    if core:isInSlot(screenX - 20/myX*sx, screenY - 20/myY*sy, 40/myX*sx, 40/myX*sx) then
                        triggerServerEvent("vehicle > vehicleSit > standUp", resourceRoot)
                        chat:sendLocalMeAction("feláll.")
                    end
                end
            end
        end
    end
end)