local activeSlotMachine = false
local inRot = false
local sound = false

local streamedSlotMachines = {}

local bet = 0

local sx, sy = guiGetScreenSize()
local myX, myY = 1768, 992

addEventHandler("onClientElementStreamIn", resourceRoot, function()
    if getElementData(source, "slotMachine:id") then 
        streamedSlotMachines[source] = source 
        --outputChatBox("slotmachine streamed in")
    end
end)

addEventHandler("onClientElementStreamOut", resourceRoot, function()
    if getElementData(source, "slotMachine:id") then 
        streamedSlotMachines[source] = false 
        --outputChatBox("slotmachine streamed out")
    end
end)

local sounds = {}
addEventHandler("onClientElementDataChange", root, function(key, old, new)
    if key == "slotMachine:sound" then 
        if fileExists("files/"..tostring(new)) then 
            local loop = false
            local distance = 7

            if new == "slotmachine_win.wav" then 
                distance = 15
            elseif new == "slotmachine_spin.wav" then 
                loop = true
            end

            local x, y, z = getElementPosition(source)
            local dim, int = getElementDimension(source), getElementInterior(source)

            sounds[source] = playSound3D("files/"..new, x, y, z, loop)
            setSoundMaxDistance(sounds[source], distance)

            setElementDimension(sounds[source], dim)
            setElementInterior(sounds[source], int)
        else
            if isElement(sounds[source]) then 
                destroyElement(sounds[source])
            end

            sounds[source] = false
        end
    end
end)

local isBetTableActive = false
local bet = 0

function renderBetMenu()

    --[[if getPlayerPing(localPlayer) > 75 then 
        triggerServerEvent("casino > slotmachine > quitFromChar", resourceRoot, activeSlotMachine)
        activeSlotMachine = false
        isBetTableActive = false
        --unbindKey("backspace", "up", quitFromChair)
        unbindKey("space", "up", spinWheel)
        removeEventHandler("onClientRender", root, renderTooltip)
        removeEventHandler("onClientRender", root, renderBetMenu)
        removeEventHandler("onClientKey", root, betMenuClick)

        exports.oInterface:toggleHud(false)
    end]]

    if not core:getNetworkConnection() then 
        triggerServerEvent("casino > slotmachine > quitFromChar", resourceRoot, activeSlotMachine)
        activeSlotMachine = false
        isBetTableActive = false
        --unbindKey("backspace", "up", quitFromChair)
        unbindKey("space", "up", spinWheel)
        removeEventHandler("onClientRender", root, renderTooltip)
        removeEventHandler("onClientRender", root, renderBetMenu)
        removeEventHandler("onClientKey", root, betMenuClick)

        exports.oInterface:toggleHud(false)
    end

    dxDrawRectangle(sx*0.9, sy*0.845, sx*0.095, sy*0.137, tocolor(35, 35, 35, 255))
    dxDrawRectangle(sx*0.9+3/myX*sx, sy*0.845+3/myY*sy, sx*0.095-6/myY*sy, sy*0.07, tocolor(40, 40, 40, 255))
    dxDrawText(bet.."#ffffffcc", sx*0.9+3/myX*sx, sy*0.845+3/myY*sy, sx*0.9+3/myX*sx+sx*0.095-6/myY*sy, sy*0.845+3/myY*sy+sy*0.07, tocolor(r, g, b, 255), 0.8/myX*sx, fonts["condensed-25"], "center", "center", false, false, false, true)

    dxDrawRectangle(sx*0.9+3/myX*sx, sy*0.92+3/myY*sy, sx*0.095-6/myY*sy, sy*0.025, tocolor(40, 40, 40, 255))
        if core:isInSlot(sx*0.9+3/myX*sx, sy*0.92+3/myY*sy, sx*0.095-6/myY*sy, sy*0.025) then 
            dxDrawText("Tét nullázása", sx*0.9+3/myX*sx, sy*0.92+3/myY*sy, sx*0.9+3/myX*sx+sx*0.095-6/myY*sy, sy*0.92+3/myY*sy+sy*0.025, tocolor(r, g, b, 255), 1/myX*sx, fonts["condensed-10"], "center", "center", false, false, false, true)
        else
            dxDrawText("Tét nullázása", sx*0.9+3/myX*sx, sy*0.92+3/myY*sy, sx*0.9+3/myX*sx+sx*0.095-6/myY*sy, sy*0.92+3/myY*sy+sy*0.025, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-10"], "center", "center", false, false, false, true)
        end
    dxDrawRectangle(sx*0.9+3/myX*sx, sy*0.95+3/myY*sy, sx*0.095-6/myY*sy, sy*0.025, tocolor(40, 40, 40, 255))
        if core:isInSlot(sx*0.9+3/myX*sx, sy*0.95+3/myY*sy, sx*0.095-6/myY*sy, sy*0.025) then  
            dxDrawText("All in", sx*0.9+3/myX*sx, sy*0.95+3/myY*sy, sx*0.9+3/myX*sx+sx*0.095-6/myY*sy, sy*0.95+3/myY*sy+sy*0.025, tocolor(r, g, b, 255), 1/myX*sx, fonts["condensed-10"], "center", "center", false, false, false, true)
        else
            dxDrawText("All in", sx*0.9+3/myX*sx, sy*0.95+3/myY*sy, sx*0.9+3/myX*sx+sx*0.095-6/myY*sy, sy*0.95+3/myY*sy+sy*0.025, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-10"], "center", "center", false, false, false, true)
        end

    dxDrawRectangle(sx*0.9, sy*0.8, sx*0.095, sy*0.04, tocolor(35, 35, 35, 255))
    dxDrawRectangle(sx*0.9+3/myX*sx, sy*0.8+3/myY*sy, sx*0.095-6/myX*sx, sy*0.04-6/myY*sy, tocolor(40, 40, 40, 255))
    dxDrawText(color..(getElementData(localPlayer, "char:cc") or 0).."#ffffffcc", sx*0.9+3/myX*sx, sy*0.8+3/myY*sy, sx*0.9+3/myX*sx+sx*0.095-6/myX*sx, sy*0.8+3/myY*sy+sy*0.04-6/myY*sy, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-13"], "center", "center", false, false, false, true)

    dxDrawRectangle(sx*0.425, sy*0.85, sx*0.15, sy*0.03, tocolor(35, 35, 35, 255))
    dxDrawRectangle(sx*0.425+3/myX*sx, sy*0.85+3/myY*sy, sx*0.15-6/myX*sx, sy*0.03-6/myY*sy, tocolor(40, 40, 40, 255))
    if core:isInSlot(sx*0.425+3/myX*sx, sy*0.85+3/myY*sy, sx*0.15-6/myX*sx, sy*0.03-6/myY*sy) then 
        dxDrawText("Kilépés", sx*0.425+3/myX*sx, sy*0.85+3/myY*sy, sx*0.425+3/myX*sx+sx*0.15-6/myX*sx, sy*0.85+3/myY*sy+sy*0.03-6/myY*sy, tocolor(245, 66, 66, 255), 1/myX*sx, fonts["condensed-10"], "center", "center", false, false, false, true)
    else
        dxDrawText("Kilépés", sx*0.425+3/myX*sx, sy*0.85+3/myY*sy, sx*0.425+3/myX*sx+sx*0.15-6/myX*sx, sy*0.85+3/myY*sy+sy*0.03-6/myY*sy, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-10"], "center", "center", false, false, false, true)
    end
end

function betMenuClick(key, state)
    if state then 
        if key == "mouse1" then 
            if not inRot then 
                if core:isInSlot(sx*0.9+3/myX*sx, sy*0.845+3/myY*sy, sx*0.095-6/myY*sy, sy*0.07) then 
                    isBetTableActive = true 
                else
                    isBetTableActive = false
                end

                if core:isInSlot(sx*0.9+3/myX*sx, sy*0.92+3/myY*sy, sx*0.095-6/myY*sy, sy*0.025) then 
                    bet = 0
                end

                if core:isInSlot(sx*0.9+3/myX*sx, sy*0.95+3/myY*sy, sx*0.095-6/myY*sy, sy*0.025) then  
                    bet = (getElementData(localPlayer, "char:cc") or 0)

                    if bet > 999999999 then 
                        bet = 999999999
                    end
                end

                if core:isInSlot(sx*0.425+3/myX*sx, sy*0.85+3/myY*sy, sx*0.15-6/myX*sx, sy*0.03-6/myY*sy) then 
                    quitFromChair()
                end
            end
        end

        if isBetTableActive then 
            key = key:gsub("num_", "")
            if tonumber(key) then 
                if string.len(tostring(bet)) < 9 then 
                    if bet == 0 then 
                        if not (tonumber(key) == 0) then 
                            bet = key
                        end
                    else
                        bet = bet ..key
                    end
                end
            end

            if key == "backspace" then 
                bet = tostring(bet):gsub("[^\128-\191][\128-\191]*$", "")

                if bet == "" then 
                    bet = 0 
                end
            end
        end
    end
end

addEventHandler("onClientClick", root, function(key, state, _, _, _, _, _, element)
    if key == "right" then 
        if state == "up" then 
            if element then 
                if getElementData(element, "slotMachine:isSlotMachine") then 
                    if not getElementData(element, "slotMachine:machineUsePlayer") then 
                        if core:getDistance(element, localPlayer) < 2.5 then 
                            if not activeSlotMachine then 
                                activeSlotMachine = element
                                triggerServerEvent("casino > slotmachine > warpPlayerToSMFront", resourceRoot, element)
                                bindKey("space", "up", spinWheel)
                                --bindKey("backspace", "up", quitFromChair)

                                tooltipDatas = {
                                    ["title"] = "Slot Machine",
                                    ["controll-lines"] = {
                                        {title = "Forgatás", key = "Space"},
                                        --{title = "Kilépés", key = "Backspace"},
                                    },
                                    ["other-lines"] = {},
                                    ["long-descs"] = {},
                                }

                                for k, v in pairs(slotMachineImagesMultiplier) do 
                                    table.insert(tooltipDatas["other-lines"], #tooltipDatas["other-lines"]+1, {title = k, desc = "2db: "..v[1].."x | 3db: "..v[2].."x"})
                                end

                                addEventHandler("onClientRender", root, renderTooltip)
                                addEventHandler("onClientRender", root, renderBetMenu)
                                addEventHandler("onClientKey", root, betMenuClick)

                                exports.oInterface:toggleHud(true)
                            end
                        end
                    else
                        outputChatBox(core:getServerPrefix("red-dark", "SlotMachine", 2).."Ez a gép már használatban van!", 255, 255, 255, true)
                    end
                end
            end
        end
    end
end)

function spinWheel()
    if not inRot then 
        if tonumber(bet) > 0 then
            if (getElementData(localPlayer, "char:cc") or 0) >= tonumber(bet) then 
                if core:getNetworkConnection() then 
                    inRot = true
                    isBetTableActive = false
                    triggerServerEvent("casino > slotmachine > spinMachineWheels", resourceRoot, activeSlotMachine, tonumber(bet))
                    --setTimer(function() sound = playSound("files/slotmachine_spin.wav", true) end, 500, 1)
                else
                    infobox:outputInfoBox("Az internetkapcsolatod nem elég stabil a játék megkezdéséhez!", "warning")
                end
            else
                infobox:outputInfoBox("Nincs elegendő CasinoCoinod! ("..bet.."cc)", "error")
                outputChatBox(core:getServerPrefix("red-dark", "SlotMachine", 2).."Nincs elegendő CasinoCoinod! "..color.."("..bet.."cc)", 255, 255, 255, true)
            end
        end
    end
end

function quitFromChair()
    if not inRot then 
        --if not isBetTableActive then 
            triggerServerEvent("casino > slotmachine > quitFromChar", resourceRoot, activeSlotMachine)
            activeSlotMachine = false
            isBetTableActive = false
            --unbindKey("backspace", "up", quitFromChair)
            unbindKey("space", "up", spinWheel)
            removeEventHandler("onClientRender", root, renderTooltip)
            removeEventHandler("onClientRender", root, renderBetMenu)
            removeEventHandler("onClientKey", root, betMenuClick)

            exports.oInterface:toggleHud(false)
        --end
    else 
        outputChatBox(core:getServerPrefix("red-dark", "SlotMachine", 3).."Játék közben nem léphetsz ki!", 255, 255, 255, true)
    end
end

addEvent("casino > slotmachine > endrot", true)
addEventHandler("casino > slotmachine > endrot", localPlayer, function()
    --destroyElement(sound)
    --outputChatBox(" ")

    local images = {}
    for k, v in pairs(getElementData(getElementData(activeSlotMachine, "slotMachine:machine"), "slotMachine:wheels")) do 

        local rot, _, _ = getElementRotation(v)
        rot = math.ceil(rot)

        local image = slotmachineWheelRotationImages[rot] or "nan"

        if image == "nan" then 
            image = slotmachineWheelRotationImages[rot-1] or "nan"

            if image == "nan" then 
                image = slotmachineWheelRotationImages[rot+1] or "nan"
            end
        end

        --outputChatBox((image) .. " - "..rot)
        if not images[image] then 
            --outputChatBox("new")
            images[image] = 1
        else
            images[image] = images[image] + 1
            --outputChatBox("már volt ilyen")
        end
    end

    local index = 0
    local winner = ""
    for k, v in pairs(images) do 
        index = index + 1

        if v > 1 then 
            winner = k  
        end
        --outputChatBox(k..": "..v)
    end

    if index == 1 then 
        triggerServerEvent("casino > slotMachine > payBet", resourceRoot, math.floor(bet*slotMachineImagesMultiplier[winner][2]))
        outputChatBox(core:getServerPrefix("green-dark", "SlotMachine", 2).."Nyertél "..color..math.floor(bet*slotMachineImagesMultiplier[winner][2]).."#ffffffcc-t. ", 255, 255, 255, true)
        infobox:outputInfoBox("Nyertél "..math.floor(bet*slotMachineImagesMultiplier[winner][2]).."cc-t. ", "success")
        triggerServerEvent("casino > playWinSound", resourceRoot, activeSlotMachine)
        --outputChatBox(slotMachineImagesMultiplier[winner][2])
        --sound = playSound("files/slotmachine_win.wav")
    elseif index == 2 then
        triggerServerEvent("casino > slotMachine > payBet", resourceRoot, math.floor(bet*slotMachineImagesMultiplier[winner][1]))
        outputChatBox(core:getServerPrefix("green-dark", "SlotMachine", 2).."Nyertél "..color..math.floor(bet*slotMachineImagesMultiplier[winner][1]).."#ffffffcc-t. ", 255, 255, 255, true)
        infobox:outputInfoBox("Nyertél "..math.floor(bet*slotMachineImagesMultiplier[winner][1]).."cc-t. ", "success")
        --outputChatBox(slotMachineImagesMultiplier[winner][1])
    else
        outputChatBox(core:getServerPrefix("red-dark", "SlotMachine", 2).."Veszítettél "..color..bet.."#ffffffcc-t. ", 255, 255, 255, true)
    end

    inRot = false

end) 

addEvent("casino > sync > sound", true)
addEventHandler("casino > sync > sound", resourceRoot, function(sound, pos, looped)
    playSound3D("files/"..sound..".wav", pos.x, pos.y, pos.z, looped)
end)

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end