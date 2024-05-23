local sx, sy = guiGetScreenSize()

local inVeh = false 
local sec, min = 0
local realTimer = nil

addEventHandler("onClientRender", root, function()
    for k, v in ipairs(getElementsByType("vehicle", resourceRoot, true)) do 
        if not getVehicleOccupant(v) then
            local distance = core:getDistance(localPlayer, v)

            if distance < 7 then 
                local x, y, z = getElementPosition(v)
                local x, y = getScreenFromWorldPosition(x, y, z + 0.5)
    
                if x and y then 
                    draw3DText("Bérelhető kerékpár", x - sx*0.05, y, x + sx*0.05, y, 255, 255, 255, (1 - (distance / 7)), 1, font:getFont("condensed", 12), "center", "center")
                    draw3DText("Percdíj: "..color.."2$", x - sx*0.05, y + sy*0.01, x + sx*0.05, y + sy*0.03, 255, 255, 255, (1 - (distance / 7)), 1, font:getFont("condensed", 11), "center", "center", false, false, false, true)
                end
            end
        end
    end

    if inVeh then 
        draw3DText(color..string.format("%02d",min).."#ffffff:"..string.format("%02d",sec).." #8ee087(Teljes összeg: $"..(min * 2)..")", 0, sy*0.8, sx, sy*0.81, 255, 255, 255, 1, 1, font:getFont("condensed", 12), "center", "center", false, false, false, true)
        draw3DText("A bérlés leállításához szállj ki a járműből!", 0, sy*0.82, sx, sy*0.83, 255, 255, 255, 1, 0.8, font:getFont("condensed", 12), "center", "center", false, false, false, true)
    end
end)

addEventHandler("onClientVehicleStartEnter", root, function(player)
    if player == localPlayer then 
        if getElementData(source, "isSharedBicycle") then 
            if getElementData(localPlayer, "char:money") < 2 then 
                outputChatBox(core:getServerPrefix("red-dark", "Bérlés", 2).."Nincs pénzed a kerékpár használatára!", 255, 255, 255, true)
                cancelEvent()
            end
        end
    end
end)

addEventHandler("onClientVehicleEnter", root, function(player)
    if player == localPlayer then 
        if getElementData(source, "isSharedBicycle") then 
            setElementFrozen(source, false)
            inVeh = source
            sec, min = 0, 0
            
            if isTimer(realTimer) then 
                killTimer(realTimer) 
            end

            realTimer = setTimer(function()
                sec = sec + 1

                if sec == 60 then 
                    min = min + 1

                    setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money") - 2)

                    if getElementData(localPlayer, "char:money") >= 2 then 
                        sec = 0
                    else
                        setElementFrozen(inVeh, true)
                        inVeh = false 
                        if isTimer(realTimer) then 
                            killTimer(realTimer) 
                        end

                        outputChatBox(core:getServerPrefix("red-dark", "Bérlés", 2).."Nincs elegendő pénzed a kerékpár további használatára!", 255, 255, 255, true)
                        outputChatBox(core:getServerPrefix("green-dark", "Bérlés", 2).."Befejezted a kerékpár bérlését! Teljes összeg: "..color..(min * 2).."$#ffffff.", 255, 255, 255, true)
                    end
                end
            end, 1000, 0)
        end
    end
end)

addEventHandler("onClientVehicleExit", root, function(player)
    if player == localPlayer then 
        if getElementData(source, "isSharedBicycle") then 
            outputChatBox(core:getServerPrefix("green-dark", "Bérlés", 2).."Befejezted a kerékpár bérlését! Teljes összeg: "..color..(min * 2).."$#ffffff.", 255, 255, 255, true)

            setElementFrozen(source, true)
            inVeh = false

            if isTimer(realTimer) then 
                killTimer(realTimer) 
            end
        end
    end
end)

function draw3DText(text, x, y, w, h, r, g, b, alpha, ...)
    dxDrawText(string.gsub(text, "#......", ""), x + 2, y + 2, w + 2, h + 2, tocolor(0, 0, 0, 100 * alpha), ...)
    dxDrawText(text, x, y, w, h, tocolor(r, g, b, 255 * alpha), ...)
end

addEventHandler("onClientPlayerQuit", resourceRoot, function()
    if source == localPlayer then 
        if inVeh then
            setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money") - math.max((min * 2), 2))
        end
    end
end)