local streamedPlacedos = {}

local fonts = {
    ["condensed-15"] = exports.oFont:getFont("condensed", 15),
}

addEventHandler("onClientElementStreamIn", resourceRoot, function()
    if getElementData(source, "isPlacedo") then 
        streamedPlacedos[source] = streamedPlacedos
    end
end)

addEventHandler("onClientElementStreamOut", resourceRoot, function()
    if getElementData(source, "isPlacedo") then 
        streamedPlacedos[source] = false 
    end
end)

local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900

addEventHandler("onClientRender", root, function()
    for k, v in pairs(streamedPlacedos) do 
        if v then 
            if isElement(k) then 
             --   outputDebugString("a")
                if core:getDistance(k, localPlayer) < 30 then 
                    local placedoPos = Vector3(getElementPosition(k))
                    local x, y = getScreenFromWorldPosition(placedoPos.x, placedoPos.y, placedoPos.z)
                    
                    if x and y then 
                        local px, py, pz = getCameraMatrix()
                        local tx, ty, tz = placedoPos.x, placedoPos.y, placedoPos.z
                        local dist = math.sqrt(( px - tx ) ^ 2 + ( py - ty ) ^ 2 + ( pz - tz ) ^ 2)
                        local size = 1 - (dist / 36)

                        --if isLineOfSightClear(px, py, pz, tx, ty, tz, true, false, false, true, false, false, false, localPlayer) then

                            local text = getElementData(k, "placedo:text").." (("..getElementData(k, "placedo:ownerName").."))"
                            local minus = dxGetTextWidth(text, 1*size, fonts["condensed-15"], true)/2
                            drawShadowedText(text, x-minus, y, x-minus, y, tocolor(235, 24, 9, 200), 1*size, fonts["condensed-15"])

                            local aduty = getElementData(localPlayer, "user:aduty") or false
                            if (getElementData(k, "placedo:ownerID") == getElementData(localPlayer, "char:id")) or (aduty) then 
                                if core:isInSlot(x-15/myX*sx*size, y+25/myX*sx*size, 30/myX*sx*size, 30/myX*sx*size) then 
                                    dxDrawImage(x-15/myX*sx*size, y+25/myX*sx*size, 30/myX*sx*size, 30/myX*sx*size, "del.png", 0, 0, 0, tocolor(235, 24, 9, 150))
                                else
                                    dxDrawImage(x-15/myX*sx*size, y+25/myX*sx*size, 30/myX*sx*size, 30/myX*sx*size, "del.png", 0, 0, 0, tocolor(235, 24, 9, 100))
                                end
                            end

                            if aduty then 
                                local createTime = "["..getElementData(k, "placedo:createTime").."]"
                                local minus = dxGetTextWidth(createTime, 0.8*size, fonts["condensed-15"], true)/2
                                drawShadowedText(createTime, x-minus, y-20, x-minus, y-20, tocolor(220, 220, 220, 200), 0.8*size, fonts["condensed-15"])
                            end

                        --end
                    end
                end
            else
                streamedPlacedos[k] = false
            end
        end
    end
end)

addEventHandler("onClientKey", root, function(key, state)
    if key == "mouse1" then 
        if state then 
            for k, v in pairs(streamedPlacedos) do 
                if v then 
                    if core:getDistance(k, localPlayer) < 10 then 
                        local placedoPos = Vector3(getElementPosition(k))
                        local x, y = getScreenFromWorldPosition(placedoPos.x, placedoPos.y, placedoPos.z)
                        
                        if x and y then 
                            local px, py, pz = getCameraMatrix()
                            local tx, ty, tz = placedoPos.x, placedoPos.y, placedoPos.z
                            local dist = math.sqrt(( px - tx ) ^ 2 + ( py - ty ) ^ 2 + ( pz - tz ) ^ 2)
                            local size = 1 - (dist / 35)

                            --if isLineOfSightClear(px, py, pz, tx, ty, tz, true, false, false, true, false, false, false, localPlayer) then

                                if (getElementData(k, "placedo:ownerID") == getElementData(localPlayer, "char:id")) or (getElementData(localPlayer, "user:aduty")) then 
                                    if core:isInSlot(x-15/myX*sx*size, y+25/myX*sx*size, 30/myX*sx*size, 30/myX*sx*size) then 
                                        triggerServerEvent("placedo > delPlacedo", resourceRoot, k)
                                    end
                                end

                            --end
                        end
                    end
                end
            end
        end
    end
end)

function drawShadowedText(text, x, y, w, h, color, size, font)
    dxDrawText(text, x+1, y+1, w+1, h+1, tocolor(0, 0, 0, 100), size, font)
    dxDrawText(text, x, y, w, h, color, size, font)
end