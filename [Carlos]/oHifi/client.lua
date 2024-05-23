local streamedHifis = {}
local sounds = {}

local pickupAble = true
local scales = 0

addEventHandler("onClientElementStreamIn", root, function()
    if getElementData(source, "isHifi") or intCustomHifis[getElementModel(source)] then 
        --outputChatBox("hifi streamed in")
        if getElementData(source, "hifi:state") then 
            streamedHifis[source] = source
            local pos = Vector3(getElementPosition(source))
            local sound = playSound3D(stations[(getElementData(source, "hifi:radioStation") or 1)][2], pos.x, pos.y, pos.z)
            setSoundMaxDistance(sound, (getElementData(source, "hifi:volume") or 1)/soundMultiplier)
            setSoundVolume(sound, (getElementData(source, "hifi:volume") or 1)/soundMultiplier/10)

            sounds[source] = sound

            attachElements(sound, source)

            --outputChatBox("streamed")
            setElementCollisionsEnabled(sound, true)

            setElementInterior(sound, getElementInterior(source))
            setElementDimension(sound, getElementDimension(source))
        end
    end
end)

addEventHandler("onClientElementStreamOut", root, function()
    if getElementData(source, "isHifi") or intCustomHifis[getElementModel(source)] then 
        --outputChatBox("hifi streamed out")
        streamedHifis[source] = false
        noteBlock = {}
        if sounds[source] then 
            destroyElement(sounds[source])
            sounds[source] = false
        end
    end
end)

addEventHandler("onClientElementDataChange", getRootElement(), function(key, old, new)
    if getElementType(source) == "object" and getElementModel(source) == 2103 then 
        if key == "hifi:state" then 
            if new then 
                if isElementStreamedIn(source) then 
                    streamedHifis[source] = source
                end
                local pos = Vector3(getElementPosition(source))
                local sound = playSound3D(stations[(getElementData(source, "hifi:radioStation") or 1)][2], pos.x, pos.y, pos.z)
                setSoundMaxDistance(sound, (getElementData(source, "hifi:volume") or 50)/soundMultiplier)
                setSoundVolume(sound, (getElementData(source, "hifi:volume") or 50)/soundMultiplier/10)
                setElementInterior(sound, getElementInterior(source))
                setElementDimension(sound, getElementDimension(source))

                sounds[source] = sound

                attachElements(sound, source)
            else 
                if sounds[source] then 
                    destroyElement(sounds[source])
                    sounds[source] = false
                    noteBlock = {}
                end
            end
        end

        if key == "hifi:volume" and isElement(sounds[source]) then
            setSoundMaxDistance(sounds[source], (getElementData(source, "hifi:volume") or 50)/soundMultiplier)
            setSoundVolume(sounds[source], (getElementData(source, "hifi:volume") or 50)/soundMultiplier/10)
        end

        if key == "hifi:radioStation" and isElement(sounds[source]) then 
            if sounds[source] then 
                destroyElement(sounds[source])
                sounds[source] = false
                noteBlock = {}
            end

            local pos = Vector3(getElementPosition(source))
            local sound = playSound3D(stations[(getElementData(source, "hifi:radioStation") or 1)][2], pos.x, pos.y, pos.z)
            setSoundMaxDistance(sound, (getElementData(source, "hifi:volume") or 50)/soundMultiplier)
            setSoundVolume(sound, (getElementData(source, "hifi:volume") or 50)/soundMultiplier/10)

            setElementInterior(sound, getElementInterior(source))
            setElementDimension(sound, getElementDimension(source))

            sounds[source] = sound

            attachElements(sound, source)
        end
    end
end)

lastSize = {} 

noteVisibles = {}
noteBlock = {}
noteTexture = {}

noteTexture2 = {
    [1] = "files/note1.png",
    [2] = "files/note2.png"
}

for k=1,2 do 
    noteTexture[k] = dxCreateTexture(noteTexture2[k], "dxt5")
end


addEventHandler("onClientRender", root, function()
    for k, v in pairs(streamedHifis) do 
        if isElement(k) then 
            if core:getDistance(k, localPlayer) < 25 then
                if (getElementDimension(k) == getElementDimension(localPlayer)) and (getElementInterior(k) == getElementInterior(localPlayer)) then  
                    if getElementData(k, "hifi:state") then 
                        if isElementOnScreen(k) then 
                            
                            local sound = sounds[k]
                            if isElement(sound) then 
                                if getSoundLevelData(sound) and (getElementData(k, "hifi:volume") or 50)/100 > 0 then
                                    if not noteVisibles[k] then 
                                        noteVisibles[k] = getSoundLevelData(sound) / 32768 + getSoundLevelData(sound) / 32768 
                                    end
                                    noteVisibles[k] = noteVisibles[k] + (getSoundLevelData(sound) / 32768 + getSoundLevelData(sound) / 32768)
                                    if noteVisibles[k] > math.random(20, 290) then
                                        noteVisibles[k] = 0
                                       -- outputChatBox(#noteBlock)
                                        local x,y,z = getElementPosition(k)
                                        --outputChatBox(x)
                                        for k = 1, math.random(1, 3) do
                                            table.insert(noteBlock, {
                                                noteTexture[math.random(1,2)],
                                                x + math.random(-2, 2) / 10,
                                                y + math.random(-2, 2) / 10,
                                                z + 0.5,
                                                z + 5,
                                                getTickCount(),
                                                math.random(0, 180)*2,
                                                {
                                                    math.cos(math.rad(math.random(0, 180) * 2)),
                                                    -math.sin(math.rad(math.random(0, 360)))
                                                },
                                                math.random(7, 10),
                                                math.random(5, 15) / 10
                                            })
                                        end
                                    end
                                end


                                for k,v in pairs(noteBlock) do
                                    if noteBlock[k] then 
                                        noteBlock[k][6] = getTickCount()
                                        noteBlock[k][7] = noteBlock[k][7] % 360 + 0.05
                                        noteBlock[k][4] = noteBlock[k][4] + (getTickCount() - noteBlock[k][6]) * 0.001 * noteBlock[k][10] + 0.004
                                        if k % 2 == 0 then 
                                            alpha = math.random(100,150)
                                        elseif k % 3 == 0 then 
                                            alpha = math.random(160,255) 
                                        end
                                       -- print(noteBlock[k][5]-noteBlock[k][4])
                                        dxDrawMaterialLine3D(noteBlock[k][2] + noteBlock[k][8][1] * (math.cos(noteBlock[k][7]) / noteBlock[k][9]), noteBlock[k][3] + noteBlock[k][8][2] * (math.cos(noteBlock[k][7]) / noteBlock[k][9]), noteBlock[k][4], noteBlock[k][2] + noteBlock[k][8][1] * (math.cos(noteBlock[k][7]) / noteBlock[k][9]), noteBlock[k][3] + noteBlock[k][8][2] * (math.cos(noteBlock[k][7]) / noteBlock[k][9]), noteBlock[k][4] - 0.1, noteBlock[k][1], 0.1, tocolor(0,0,0, alpha))
                                        if noteBlock[k][5]-noteBlock[k][4] < 3.8 then
                                            noteBlock[k] = nil
                                        end
                                    end
                                end

                                if not getElementData(k, "hifi:inVehicle") then 
                                    local soundFFT = getSoundFFTData (sound, 8192)

                                    local model = getElementModel(k)
                                    if ( soundFFT ) then
                                        if intCustomHifis[model] then
                                            lines = intCustomHifis[model][3] or 16
                                            for i = 0, lines-1 do 

                                                if soundFFT[i] then 
                                                    local alpha = 120 

                                                    if i % 2 == 0 then 
                                                        alpha = 150
                                                    elseif i % 3 == 0 then 
                                                        alpha = 200 
                                                    end

                                                    local height = (math.sqrt ( soundFFT[i] or 0 ) * 256 / 100) or 0

                                                    if height > 2 then height = 1.2 end

                                                    local lineX, lineY, lineZ = core:getPositionFromElementOffset(k, (intCustomHifis[model][4] or 0)-(lines*0.05/2) + 0.05*i, intCustomHifis[model][2] or 0, intCustomHifis[model][1] or 0.38)

                                                    local volume = (getElementData(k, "hifi:volume") or 50)/100
                                                    if tonumber(lineX) and tonumber(lineY) and tonumber(lineZ) and tonumber(height) and tonumber(volume) and tonumber(alpha) then 
                                                        dxDrawLine3D(lineX, lineY, lineZ, lineX, lineY, lineZ + tonumber(tonumber(height)*volume), tocolor(r, g, b, alpha), 3)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end

                                if (lastSize[k] or 0) + 25 < getTickCount() then 
                                    lastSize[k] = getTickCount()
                                    if sounds[k] and getSoundFFTData(sounds[k], 2048, 0) then
                                        scales = math.sqrt(getSoundFFTData(sounds[k], 2048, 0)[1]) * 5
                                        if scales < 1 then 
                                            scales = 1
                                        end
                                        if scales > 1.2 then 
                                            scales = 1.2
                                        end
                                        setObjectScale(k, scales)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

local hifiControllPanelShowing = false 
local selectedHifi = false

local cursorPos = Vector2(0.3, 0.5)

local alpha = 0 
local tick = getTickCount()
local animType = "open"

local checkNeeded = false

local setVolume = false

addEventHandler("onClientClick", root, function(key, state, _, _, _, _, _, element)
    if key == "right" then 
        if state == "up" then 
            if isElement(element) then 
                if getElementData(element, "isHifi") or intCustomHifis[getElementModel(element)] then 

                    if core:getDistance(localPlayer, element) < 2 then 
                        --if (getElementData(element, "hifi:owner") == getElementData(localPlayer, "char:id")) or (getElementData(localPlayer, "user:aduty")) then 
                            pickupAble = getElementData(element, "isHifi")

                            --outputChatBox(getElementModel(element))
                            if not hifiControllPanelShowing then 
                                hifiControllPanelShowing = true
                                selectedHifi = element
                                core:createOutline(element, {r, g, b})

                                animType = "open"
                                tick = getTickCount()
                                cursorPos = Vector2(getCursorPosition())

                                checkNeeded = true

                                addEventHandler("onClientRender", root, renderPanel)
                                addEventHandler("onClientKey", root, panelKey)
                            --else
                             --   animType = "open"
                              --  tick = getTickCount()
                                --cursorPos = Vector2(getCursorPosition())
                            end
                        --else
                        --    outputChatBox(core:getServerPrefix("red-dark", "Hifi", 2).."Ennek a hifinek nem te vagy a tulajdonosa!", 255, 255, 255, true)
                        --end 
                    end
                end
            end
        end
    end
end)    

local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900 

local fonts = {
    ["condensed-11"] = font:getFont("condensed", 11),
    ["condensed-13"] = font:getFont("condensed", 13),
}

function renderPanel()
    if checkNeeded then 
        if core:getDistance(selectedHifi, localPlayer) > 2 then 
            closeRadioPanel()
        end 
    end

    if animType == "open" then 
        alpha = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - tick)/300, "Linear")
    else
        alpha = interpolateBetween(1, 0, 0, 0, 0, 0, (getTickCount() - tick)/300, "Linear")
    end

    dxDrawRectangle(sx*cursorPos.x, sy*cursorPos.y, sx*0.12, sy*0.22, tocolor(30, 30, 30, 240*alpha))
    dxDrawRectangle(sx*cursorPos.x+3/myX*sx, sy*cursorPos.y+3.5/myY*sy, sx*0.12-6/myX*sx, sy*0.22-7/myY*sy, tocolor(35, 35, 35, 255*alpha))

    dxDrawText("Hifi", sx*cursorPos.x, sy*cursorPos.y+3.5/myY*sy+3/myY*sx, sx*cursorPos.x+sx*0.12, sy*cursorPos.y+3.5/myY*sy+sy*0.13-7/myY*sy, tocolor(r, g, b, 255*alpha), 1/myX*sx, fonts["condensed-13"], "center", "top", false, false, false, true)

    if core:isInSlot(sx*cursorPos.x+6/myX*sx, sy*cursorPos.y+6.5/myY*sy, 20/myX*sx, 20/myY*sy) then 
        dxDrawImage(sx*cursorPos.x+6/myX*sx, sy*cursorPos.y+6.5/myY*sy, 20/myX*sx, 20/myY*sy, "files/close.png", 0, 0, 0, tocolor(230, 65, 53, 255*alpha))
    else
        dxDrawImage(sx*cursorPos.x+6/myX*sx, sy*cursorPos.y+6.5/myY*sy, 20/myX*sx, 20/myY*sy, "files/close.png", 0, 0, 0, tocolor(220, 220, 220, 255*alpha))
    end

    if isElement(selectedHifi) then 
        if getElementData(selectedHifi, "hifi:state") then 
            dxDrawText(stations[getElementData(selectedHifi, "hifi:radioStation") or 1][1], sx*cursorPos.x, sy*cursorPos.y+3.5/myY*sy-7/myY*sx, sx*cursorPos.x+sx*0.12, sy*cursorPos.y+3.5/myY*sy+sy*0.13-7/myY*sy, tocolor(255, 255, 255, 255*alpha), 1/myX*sx, fonts["condensed-11"], "center", "center", false, false, false, true)
            
            local musicTitle
            if isElement(selectedHifi) then 
                musicTitle = getSoundMetaTags(sounds[selectedHifi]) or ""
                if not musicTitle["stream_title"] then 
                    musicTitle = "nan"
                else
                    musicTitle = musicTitle["stream_title"]
                end
            else
                musicTitle = ""
            end

            --dxDrawRectangle(sx*cursorPos.x, sy*cursorPos.y+3.5/myY*sy+5/myY*sy, sx*0.12, sy*0.13+5/myY*sy)
            dxDrawText(musicTitle, sx*cursorPos.x, sy*cursorPos.y+3.5/myY*sy+sy*0.065, sx*cursorPos.x+sx*0.12, sy*cursorPos.y+3.5/myY*sy+sy*0.13+5/myY*sy+sy*0.065, tocolor(255, 255, 255, 180*alpha), 0.8/myX*sx, fonts["condensed-11"], "center", "top", true, true, false, false)
            
            if core:isInSlot(sx*cursorPos.x+9/myX*sx, sy*cursorPos.y+5/myY*sy + ((sy*0.13-7/myY*sy) /2) + sy*0.11, 30/myX*sx, 30/myY*sy) then 
                dxDrawImage(sx*cursorPos.x+9/myX*sx, sy*cursorPos.y+5/myY*sy + ((sy*0.13-7/myY*sy) /2) + sy*0.11, 30/myX*sx, 30/myY*sy, "files/arrow.png", 180, 0, 0, tocolor(r, g, b, 255*alpha))
            else
                dxDrawImage(sx*cursorPos.x+9/myX*sx, sy*cursorPos.y+5/myY*sy + ((sy*0.13-7/myY*sy) /2) + sy*0.11, 30/myX*sx, 30/myY*sy, "files/arrow.png", 180, 0, 0, tocolor(220, 220, 220, 255*alpha))
            end

            if core:isInSlot(sx*cursorPos.x+5/myX*sx+sx*0.12-6/myX*sx-38/myX*sx, sy*cursorPos.y+5/myY*sy + ((sy*0.13-7/myY*sy) /2) + sy*0.11, 30/myX*sx, 30/myY*sy) then 
                dxDrawImage(sx*cursorPos.x+5/myX*sx+sx*0.12-6/myX*sx-38/myX*sx, sy*cursorPos.y+5/myY*sy + ((sy*0.13-7/myY*sy) /2) + sy*0.11, 30/myX*sx, 30/myY*sy, "files/arrow.png", 0, 0, 0, tocolor(r, g, b, 255*alpha))
            else
                dxDrawImage(sx*cursorPos.x+5/myX*sx+sx*0.12-6/myX*sx-38/myX*sx, sy*cursorPos.y+5/myY*sy + ((sy*0.13-7/myY*sy) /2) + sy*0.11, 30/myX*sx, 30/myY*sy, "files/arrow.png", 0, 0, 0, tocolor(220, 220, 220, 255*alpha))
            end

            if core:isInSlot(sx*cursorPos.x+(sx*0.12/2)-15/myX*sx, sy*cursorPos.y+5/myY*sy + ((sy*0.13-7/myY*sy) /2) + sy*0.11, 30/myX*sx, 30/myY*sy) then 
                dxDrawImage(sx*cursorPos.x+(sx*0.12/2)-15/myX*sx, sy*cursorPos.y+5/myY*sy + ((sy*0.13-7/myY*sy) /2) + sy*0.11, 30/myX*sx, 30/myY*sy, "files/stop.png", 180, 0, 0, tocolor(r, g, b, 255*alpha))
            else
                dxDrawImage(sx*cursorPos.x+(sx*0.12/2)-15/myX*sx, sy*cursorPos.y+5/myY*sy + ((sy*0.13-7/myY*sy) /2) + sy*0.11, 30/myX*sx, 30/myY*sy, "files/stop.png", 180, 0, 0, tocolor(220, 220, 220, 255*alpha))
            end

            volume = getElementData(selectedHifi, "hifi:volume") or 50

            dxDrawRectangle(sx*cursorPos.x+6/myX*sx, sy*cursorPos.y+sy*0.14, sx*0.12-12/myX*sx, sy*0.025, tocolor(40, 40, 40, 255*alpha))
            dxDrawRectangle(sx*cursorPos.x+8/myX*sx, sy*cursorPos.y+sy*0.14+2/myY*sy, sx*0.12-16/myX*sx, sy*0.025-4/myY*sy, tocolor(35, 35, 35, 255*alpha))
            dxDrawRectangle(sx*cursorPos.x+8/myX*sx, sy*cursorPos.y+sy*0.14+2/myY*sy, (sx*0.12-16/myX*sx)*(volume/100), sy*0.025-4/myY*sy, tocolor(r, g, b, 220*alpha))
            dxDrawText(volume.."%", sx*cursorPos.x+6/myX*sx, sy*cursorPos.y+sy*0.14, sx*cursorPos.x+6/myX*sx+sx*0.12-12/myX*sx, sy*cursorPos.y+sy*0.14+sy*0.025, tocolor(220, 220, 220, 255*alpha), 0.7/myX*sx, fonts["condensed-11"], "center", "center")

            if setVolume then 
                local cursor = Vector2(getCursorPosition())
                
                local cursorRealPos = (0-(cursorPos.x + 8/myX - cursor.x ))*0.95

                local volume2 = cursorRealPos*1000

                if volume2 < 0 then 
                    volume2 = 0 
                elseif volume2 > 100 then 
                    volume2 = 100
                end

                --volume2 = volume2/sx*0.12-16/myX*sx

                --volume2 = volume2/100

                volume2 = math.floor(volume2)

                setElementData(selectedHifi, "hifi:volume", volume2)
            end

            if pickupAble then
                dxDrawRectangle(sx*cursorPos.x+6/myX*sx, sy*cursorPos.y+sy*0.11, sx*0.12-12/myX*sx, sy*0.025, tocolor(40, 40, 40, 255*alpha))
                if core:isInSlot(sx*cursorPos.x+8/myX*sx, sy*cursorPos.y+sy*0.11+2/myY*sy, sx*0.12-16/myX*sx, sy*0.025-4/myY*sy) then 
                    dxDrawRectangle(sx*cursorPos.x+8/myX*sx, sy*cursorPos.y+sy*0.11+2/myY*sy, sx*0.12-16/myX*sx, sy*0.025-4/myY*sy, tocolor(r, g, b, 220*alpha))
                else
                    dxDrawRectangle(sx*cursorPos.x+8/myX*sx, sy*cursorPos.y+sy*0.11+2/myY*sy, sx*0.12-16/myX*sx, sy*0.025-4/myY*sy, tocolor(35, 35, 35, 255*alpha))
                end
                dxDrawText("Hifi felvétele", sx*cursorPos.x+6/myX*sx, sy*cursorPos.y+sy*0.11, sx*cursorPos.x+6/myX*sx+sx*0.12-12/myX*sx, sy*cursorPos.y+sy*0.11+sy*0.025, tocolor(220, 220, 220, 255*alpha), 0.7/myX*sx, fonts["condensed-11"], "center", "center")
            end
        else
            dxDrawText("A rádió ki van kapcsolva!", sx*cursorPos.x, sy*cursorPos.y, sx*cursorPos.x+sx*0.12, sy*cursorPos.y+sy*0.22, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, fonts["condensed-11"], "center", "center")
            if core:isInSlot(sx*cursorPos.x+(sx*0.12/2)-15/myX*sx, sy*cursorPos.y+5/myY*sy + ((sy*0.13-7/myY*sy) /2) + sy*0.11, 30/myX*sx, 30/myY*sy) then 
                dxDrawImage(sx*cursorPos.x+(sx*0.12/2)-15/myX*sx, sy*cursorPos.y+5/myY*sy + ((sy*0.13-7/myY*sy) /2) + sy*0.11, 30/myX*sx, 30/myY*sy, "files/start.png", 0, 0, 0, tocolor(r, g, b, 255*alpha))
            else
                dxDrawImage(sx*cursorPos.x+(sx*0.12/2)-15/myX*sx, sy*cursorPos.y+5/myY*sy + ((sy*0.13-7/myY*sy) /2) + sy*0.11, 30/myX*sx, 30/myY*sy, "files/start.png", 0, 0, 0, tocolor(220, 220, 220, 255*alpha))
            end

            if pickupAble then
                dxDrawRectangle(sx*cursorPos.x+6/myX*sx, sy*cursorPos.y+sy*0.125, sx*0.12-12/myX*sx, sy*0.025, tocolor(40, 40, 40, 255*alpha))
                if core:isInSlot(sx*cursorPos.x+8/myX*sx, sy*cursorPos.y+sy*0.125+2/myY*sy, sx*0.12-16/myX*sx, sy*0.025-4/myY*sy) then 
                    dxDrawRectangle(sx*cursorPos.x+8/myX*sx, sy*cursorPos.y+sy*0.125+2/myY*sy, sx*0.12-16/myX*sx, sy*0.025-4/myY*sy, tocolor(r, g, b, 255*alpha))
                else
                    dxDrawRectangle(sx*cursorPos.x+8/myX*sx, sy*cursorPos.y+sy*0.125+2/myY*sy, sx*0.12-16/myX*sx, sy*0.025-4/myY*sy, tocolor(35, 35, 35, 220*alpha))
                end
                dxDrawText("Hifi felvétele", sx*cursorPos.x+6/myX*sx, sy*cursorPos.y+sy*0.125, sx*cursorPos.x+6/myX*sx+sx*0.12-12/myX*sx, sy*cursorPos.y+sy*0.125+sy*0.025, tocolor(220, 220, 220, 255*alpha), 0.7/myX*sx, fonts["condensed-11"], "center", "center")
            end
        end
    end
end

local lastClick = 0
function panelKey(key, state)
    if state then 
        if key == "mouse1" then 
            if lastClick + 500 < getTickCount() then 
                if core:isInSlot(sx*cursorPos.x+6/myX*sx, sy*cursorPos.y+6.5/myY*sy, 20/myX*sx, 20/myY*sy) then 
                    closeRadioPanel()
                end

                if getElementData(selectedHifi, "hifi:state") then 
                    if core:isInSlot(sx*cursorPos.x+(sx*0.12/2)-15/myX*sx, sy*cursorPos.y+5/myY*sy + ((sy*0.13-7/myY*sy) /2) + sy*0.11, 30/myX*sx, 30/myY*sy) then 
                        triggerServerEvent("hifi > setHifiState", resourceRoot, selectedHifi, false)
                        chat:sendLocalMeAction("kikapcsol egy hifit.")
                        lastClick = getTickCount()
                    end

                    if core:isInSlot(sx*cursorPos.x+8/myX*sx, sy*cursorPos.y+sy*0.14+2/myY*sy, sx*0.12-16/myX*sx, sy*0.025-4/myY*sy) then 
                        setVolume = true
                        lastClick = getTickCount()
                    end

                    if core:isInSlot(sx*cursorPos.x+9/myX*sx, sy*cursorPos.y+5/myY*sy + ((sy*0.13-7/myY*sy) /2) + sy*0.11, 30/myX*sx, 30/myY*sy) then 
                        local newValue = 0 

                        if (getElementData(selectedHifi, "hifi:radioStation") or 1) > 1 then 
                            newValue = (getElementData(selectedHifi, "hifi:radioStation") or 1) - 1
                        else
                            newValue = #stations
                        end
                        lastClick = getTickCount()

                        triggerServerEvent("hifi > setHifiChannel", resourceRoot, selectedHifi, newValue)
                        chat:sendLocalMeAction("átállítja egy hifi csatornáját. (("..stations[newValue][1].."))")
                    end
            
                    if core:isInSlot(sx*cursorPos.x+5/myX*sx+sx*0.12-6/myX*sx-38/myX*sx, sy*cursorPos.y+5/myY*sy + ((sy*0.13-7/myY*sy) /2) + sy*0.11, 30/myX*sx, 30/myY*sy) then 
                        local newValue = 0 

                        if (getElementData(selectedHifi, "hifi:radioStation") or 1) < #stations then 
                            newValue = (getElementData(selectedHifi, "hifi:radioStation") or 1) + 1
                        else
                            newValue = 1
                        end
                        lastClick = getTickCount()

                        triggerServerEvent("hifi > setHifiChannel", resourceRoot, selectedHifi, newValue)
                        chat:sendLocalMeAction("átállítja egy hifi csatornáját. (("..stations[newValue][1].."))")
                    end

                    if core:isInSlot(sx*cursorPos.x+8/myX*sx, sy*cursorPos.y+sy*0.11+2/myY*sy, sx*0.12-16/myX*sx, sy*0.025-4/myY*sy) then 
                        if pickupAble then
                            local hifi_cache = selectedHifi
                            closeRadioPanel()
                            lastClick = getTickCount()

                            --setTimer(function()
                                streamedHifis[hifi_cache] = false
                                
                                triggerServerEvent("hifi > pickupHifi", resourceRoot, hifi_cache)
                                chat:sendLocalMeAction("felvesz egy hifit.")
                            --end, 300, 1)
                        end
                    end
                else
                    if core:isInSlot(sx*cursorPos.x+8/myX*sx, sy*cursorPos.y+sy*0.125+2/myY*sy, sx*0.12-16/myX*sx, sy*0.025-4/myY*sy) then 
                        if pickupAble then
                            local hifi_cache = selectedHifi
                            closeRadioPanel()
                            lastClick = getTickCount()

                            --setTimer(function()
                                streamedHifis[hifi_cache] = false

                                if getElementData(hifi_cache, "hifi:state") then 
                                    destroyElement(getElementData(hifi_cache, "hifi:3dSound"))
                                end

                                triggerServerEvent("hifi > pickupHifi", resourceRoot, hifi_cache)
                                chat:sendLocalMeAction("felvesz egy hifit.")
                            --end, 300, 1)
                        end
                    end

                    if core:isInSlot(sx*cursorPos.x+(sx*0.12/2)-15/myX*sx, sy*cursorPos.y+5/myY*sy + ((sy*0.13-7/myY*sy) /2) + sy*0.11, 30/myX*sx, 30/myY*sy) then 
                        triggerServerEvent("hifi > setHifiState", resourceRoot, selectedHifi, true)
                        chat:sendLocalMeAction("bekapcsol egy hifit.")

                        lastClick = getTickCount()
                    end
                end
            end
        end
    else 
        if key == "mouse1" then 
            if setVolume then 
                setVolume = false
                triggerServerEvent("hifi > setHifiVolume", resourceRoot, selectedHifi, getElementData(selectedHifi, "hifi:volume"))
                chat:sendLocalMeAction("átállítja egy hifi hangerejét.")
            end
        end
    end
end

function closeRadioPanel()
    removeEventHandler("onClientKey", root, panelKey)
    checkNeeded = false
    animType = "close"
    tick = getTickCount()
    setVolume = false

    core:destroyOutline(selectedHifi)

    setTimer(function() 
        hifiControllPanelShowing = false
        selectedHifi = false

        removeEventHandler("onClientRender", root, renderPanel)
    end, 300, 1)
end