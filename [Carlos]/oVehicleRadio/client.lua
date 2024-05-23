local sx, sy = guiGetScreenSize() 
local myX, myY = 1600, 900 

--sx, sy = 1360, 768
--sx, sy = 1920, 1080


local fonts = {
    ["condensed-11"] = font:getFont("condensed", 11),
    ["bebasneue-13"] = font:getFont("bebasneue", 13),
    ["condensed-16"] = font:getFont("condensed", 16),
    ["fontawesome-16"] = font:getFont("fontawesome2", 16),
}

local tick = getTickCount()

local colors = {"#ff8700","#ff8600","#ff8600","#ff8500","#ff8400","#ff8300","#ff8300","#ff8200","#ff8100","#ff8000","#ff8000","#ff7f00","#ff7e00","#ff7d00","#ff7d00","#ff7c00","#ff7b00","#ff7a00","#ff7900","#ff7900","#ff7800","#ff7700","#ff7600","#ff7600","#ff7500","#ff7400","#ff7300","#ff7300","#ff7200","#ff7100","#ff7000","#ff6f00","#ff6f00","#ff6e00","#ff6d00","#ff6c00","#ff6c00","#ff6b00","#ff6a00","#ff6900","#ff6900","#ff6800","#ff6700","#ff6600","#ff6600","#ff6500","#ff6400","#ff6300","#ff6200","#ff6200","#ff6100","#ff6000","#ff5f00","#ff5f00","#ff5e00","#ff5d00","#ff5c00","#ff5c00","#ff5b00","#ff5a00","#ff5900","#ff5900","#ff5800","#ff5700","#ff5600","#ff5500","#ff5500","#ff5400","#ff5300","#ff5200","#ff5200","#ff5100","#ff5000","#ff4f00","#ff4f00","#ff4e00","#ff4d00","#ff4c00","#ff4c00","#ff4b00","#ff4a00","#ff4900","#ff4800","#ff4800","#ff4700","#ff4600","#ff4500","#ff4500","#ff4400","#ff4300","#ff4200","#ff4200","#ff4100","#ff4000","#ff3f00","#ff3e00","#ff3e00","#ff3d00","#ff3c00","#ff3b00","#ff3b00","#ff3a00","#ff3900","#ff3800","#ff3800","#ff3700","#ff3600","#ff3500","#ff3500","#ff3400"}

local positions = {
    ["big"] = {sx*0.375, sy*0.39},
    --["small"] = {sx*0.375, sy*0.75},
}

local audioVizualizerShowing = true

local lastTextMove = 0
local textTableIndex = 0

local volumeBarAnimation = {getTickCount(), 0, "off"}

local radioScroll = 0

local radioMoveing = false

local playedMusics = {}

addEventHandler("onClientElementDataChange", root, function(data, old, new)
    if data == "vehicleRadio:state" then 
        if not isElementStreamedIn(source) then return end

        if new then 
            if not playedMusics[source] then 
                local url = getElementData(source, "vehicleRadio:streamURL")
                local valid = false 
                for k, v in ipairs(stations) do
                    if v[2] == url then 
                        valid = true 
                        break
                    end 
                end

                if valid then
                    playedMusics[source] = playSound(url)
                else
                    if isElement(playedMusics[source]) then 
                        destroyElement(playedMusics[source])
                    end  
                    playedMusics[source] = false
                end
            end      
        else
            if isElement(playedMusics[source]) then 
                destroyElement(playedMusics[source])
            end  
            playedMusics[source] = false
        end  
    elseif data == "vehicleRadio:streamURL" then
        if not isElementStreamedIn(source) then return end

        if not getElementData(source, "vehicleRadio:state") then return end 
        if isElement(playedMusics[source]) then 
            destroyElement(playedMusics[source])
        end  

        local valid = false 
        for k, v in ipairs(stations) do
            if v[2] == new then 
                valid = true 
                break
            end 
        end

        if valid then
            playedMusics[source] = playSound(new)
        end
    end
end)

addEventHandler("onClientElementStreamIn", root, function()
    if getElementData(source, "vehicleRadio:state") then 
        if not playedMusics[source] then 
            local url = getElementData(source, "vehicleRadio:streamURL")

            local valid = false 
            for k, v in ipairs(stations) do
                if v[2] == url then 
                    valid = true 
                    break
                end 
            end

            if valid then
                playedMusics[source] = playSound(url)
            end
        end 
    end
end)

addEventHandler("onClientElementStreamOut", root, function()
    if playedMusics[source] then 
        if isElement(playedMusics[source]) then 
            destroyElement(playedMusics[source])
        end  
        playedMusics[source] = false
    end
end)

addEventHandler("onClientElementDestroy", root, function()
    if playedMusics[source] then 
        if isElement(playedMusics[source]) then 
            destroyElement(playedMusics[source])
        end  
        playedMusics[source] = false
    end
end)

setTimer(function()
    for k, v in pairs(playedMusics) do 
        if isElement(v) then 
            if isElementStreamedIn(k) then 
                local hearingSound = false
                local windowStates = getElementData(k, "veh:windowStates") or {false, false, false, false}
            
                for k, v in pairs(windowStates) do 
                    if v then 
                        hearingSound = true
                        break 
                    end
                end

                local occupiedVeh = getPedOccupiedVehicle(localPlayer)
                if occupiedVeh == k then 
                    hearingSound = true 
                elseif isElement(occupiedVeh) then 
                    if hearingSound then 
                        hearingSound = false 

                        local windowStates = getElementData(occupiedVeh, "veh:windowStates") or {false, false, false, false}
                
                        for k, v in pairs(windowStates) do 
                            if v then 
                                hearingSound = true
                                break 
                            end
                        end
                    end
                end
                
                local volume = getElementData(k, "vehicleRadio:volume") or 0.5

                local distance = core:getDistance(k, localPlayer) 

                local multiplier = volume

                if distance <= 1 then 
                    multiplier = 1 
                end 

                realDistance = distance/(20*multiplier)
                realDistance = 1 - realDistance

                if realDistance > 0 then 
                    if hearingSound then 
                        setSoundVolume(v, volume*realDistance)
                    else
                        setSoundVolume(v, 0)
                    end
                else
                    setSoundVolume(v, 0)
                end 
            end
        end
    end
end, 100, 0)

local a = 0
local animType = "open" 

function renderRadio()
    if not getPedOccupiedVehicle(localPlayer) then 
        removeEventHandler("onClientKey", root, keyRadio)
        removeEventHandler("onClientRender", root, renderRadio)
        return 
    end 

    if animType == "open" then 
        a = interpolateBetween(a, 0, 0, 1, 0, 0, (getTickCount()-tick)/300, "Linear")
    else
        a = interpolateBetween(a, 0, 0, 0, 0, 0, (getTickCount()-tick)/300, "Linear")
    end

    dxDrawRectangle(positions["big"][1], positions["big"][2], sx*0.25, sy*0.2, tocolor(40, 40, 40, 255*a))
    dxDrawRectangle(positions["big"][1]+2/myX*sx, positions["big"][2]+2/myY*sy, sx*0.215, sy*0.161, tocolor(33, 33, 33, 255*a))

    dxDrawRectangle(positions["big"][1]+110/myX*sx, positions["big"][2]+148/myY*sy, sx*0.18, sy*0.033, tocolor(33, 33, 33, 255*a))

    dxDrawRectangle(positions["big"][1]+2/myX*sx, positions["big"][2]+148/myY*sy, sx*0.067, sy*0.033, tocolor(33, 33, 33, 255*a))
    --dxDrawRectangle(positions["big"][1]+2/myX*sx, positions["big"][2]+148/myY*sy, sx*0.067/3, sy*0.033, tocolor(255, 33, 33, 255*a))


    local occupiedVeh = getPedOccupiedVehicle(localPlayer)

    local radioStatus = getElementData(occupiedVeh, "vehicleRadio:state") or false 

    --[[if core:isInSlot(sx*0.375+5/myX*sx, sy*0.39+6/myY*sy, 20/myX*sx, 20/myY*sy) then 
        dxDrawImage(sx*0.375+5/myX*sx, sy*0.39+6/myY*sy, 20/myX*sx, 20/myY*sy, "files/off.png", 0, 0, 0, tocolor(r, g, b, 255*a))
    else
        dxDrawImage(sx*0.375+5/myX*sx, sy*0.39+6/myY*sy, 20/myX*sx, 20/myY*sy, "files/off.png", 0, 0, 0, tocolor(255, 255, 255, 255*a))
    end]]

    local volume = (getElementData(occupiedVeh, "vehicleRadio:volume") or 0.5)*100

    if volumeBarAnimation[3] == "off" then 
        volumeBarAnimation[2] = interpolateBetween(volumeBarAnimation[2], 0, 0, 0, 0, 0, (getTickCount()-volumeBarAnimation[1])/300, "InOutQuad")
    else
        volumeBarAnimation[2] = interpolateBetween(volumeBarAnimation[2], 0, 0, 1, 0, 0, (getTickCount()-volumeBarAnimation[1])/300, "InOutQuad")
    end

    dxDrawRectangle(positions["big"][1]+357/myX*sx - 4/myX*sx*volumeBarAnimation[2], positions["big"][2]+10/myY*sy - 4/myY*sy*volumeBarAnimation[2], sx*0.02 + 8/myX*sx*volumeBarAnimation[2], sy*0.143 + 8/myY*sy*volumeBarAnimation[2], tocolor(33, 33, 33, 255*a))
    dxDrawRectangle(positions["big"][1]+357/myX*sx - 4/myX*sx*volumeBarAnimation[2], positions["big"][2]+10/myY*sy + (sy*0.143-(sy*0.143*volume/100)) - 4/myY*sy*volumeBarAnimation[2], sx*0.02 + 8/myX*sx*volumeBarAnimation[2], sy*0.143*volume/100 + 8/myY*sy*volumeBarAnimation[2], tocolor(r, g, b, 200*a))
    dxDrawRectangle(positions["big"][1]+357/myX*sx - 6/myX*sx - 2/myX*sx*volumeBarAnimation[2],  positions["big"][2]+10/myY*sy + (sy*0.143-(sy*0.143*volume/100)) - 4/myY*sy*volumeBarAnimation[2], sx*0.02+12/myX*sx + 4/myX*sx*volumeBarAnimation[2], sy*0.005 + sy*0.005*volumeBarAnimation[2], tocolor(220, 220, 220, 255*a))

    if core:isInSlot(positions["big"][1]+357/myX*sx - 4/myX*sx*volumeBarAnimation[2], positions["big"][2]+10/myY*sy - 4/myY*sy*volumeBarAnimation[2], sx*0.02 + 8/myX*sx*volumeBarAnimation[2], sy*0.143 + 8/myY*sy*volumeBarAnimation[2]) then 
        if volumeBarAnimation[3] == "off" then 
            volumeBarAnimation[3] = "on"
            volumeBarAnimation[1] = getTickCount()
        end

        if getKeyState("mouse1") then 
            local cx, cy = getCursorPosition()
            cx, cy = cx*sx, cy*sy


            cy = cy - (positions["big"][2]+10/myY*sy - 4/myY*sy*volumeBarAnimation[2])

            local level = 1 - (cy/(sy*0.143 + 8/myY*sy*volumeBarAnimation[2]))

            setElementData(occupiedVeh, "vehicleRadio:volume", level)
        end
    else
        if volumeBarAnimation[3] == "on" then 
            volumeBarAnimation[3] = "off"
            volumeBarAnimation[1] = getTickCount()
        end
    end

    if core:isInSlot(positions["big"][1]+2/myX*sx+sx*0.067/3, positions["big"][2]+148/myY*sy, sx*0.067/3, sy*0.033) then 
        dxDrawText("", positions["big"][1]+2/myX*sx+sx*0.067/3, positions["big"][2]+148/myY*sy, positions["big"][1]+2/myX*sx+(sx*0.067/3*2), positions["big"][2]+148/myY*sy+sy*0.033, tocolor(r, g, b, 255*a), 0.7/myX*sx, fonts["fontawesome-16"], "center", "center")
    else
        dxDrawText("", positions["big"][1]+2/myX*sx+sx*0.067/3, positions["big"][2]+148/myY*sy, positions["big"][1]+2/myX*sx+(sx*0.067/3*2), positions["big"][2]+148/myY*sy+sy*0.033, tocolor(255, 255, 255, 255*a), 0.7/myX*sx, fonts["fontawesome-16"], "center", "center")
    end

    if radioStatus then 
        if core:isInSlot(positions["big"][1]+2/myX*sx, positions["big"][2]+148/myY*sy, sx*0.067/3, sy*0.033) then 
            if audioVizualizerShowing then 
                dxDrawText("", positions["big"][1]+2/myX*sx, positions["big"][2]+148/myY*sy, positions["big"][1]+2/myX*sx+(sx*0.067/3), positions["big"][2]+148/myY*sy+sy*0.033, tocolor(r, g, b, 255*a), 0.7/myX*sx, fonts["fontawesome-16"], "center", "center")
            else
                dxDrawText("", positions["big"][1]+2/myX*sx, positions["big"][2]+148/myY*sy, positions["big"][1]+2/myX*sx+(sx*0.067/3), positions["big"][2]+148/myY*sy+sy*0.033, tocolor(r, g, b, 255*a), 0.7/myX*sx, fonts["fontawesome-16"], "center", "center")
            end
        else
            if audioVizualizerShowing then 
                dxDrawText("", positions["big"][1]+2/myX*sx, positions["big"][2]+148/myY*sy, positions["big"][1]+2/myX*sx+(sx*0.067/3), positions["big"][2]+148/myY*sy+sy*0.033, tocolor(255, 255, 255, 255*a), 0.7/myX*sx, fonts["fontawesome-16"], "center", "center")
            else
                dxDrawText("", positions["big"][1]+2/myX*sx, positions["big"][2]+148/myY*sy, positions["big"][1]+2/myX*sx+(sx*0.067/3), positions["big"][2]+148/myY*sy+sy*0.033, tocolor(255, 255, 255, 255*a), 0.7/myX*sx, fonts["fontawesome-16"], "center", "center")
            end
        end
    
        if core:isInSlot(positions["big"][1]+2/myX*sx+(sx*0.067/3*2), positions["big"][2]+148/myY*sy, sx*0.067/3, sy*0.033) then 
            dxDrawText("", positions["big"][1]+2/myX*sx+(sx*0.067/3*2), positions["big"][2]+148/myY*sy, positions["big"][1]+2/myX*sx+(sx*0.067/3*3), positions["big"][2]+148/myY*sy+sy*0.033, tocolor(r, g, b, 255*a), 0.7/myX*sx, fonts["fontawesome-16"], "center", "center")
        else
            dxDrawText("", positions["big"][1]+2/myX*sx+(sx*0.067/3*2), positions["big"][2]+148/myY*sy, positions["big"][1]+2/myX*sx+(sx*0.067/3*3), positions["big"][2]+148/myY*sy+sy*0.033, tocolor(255, 255, 255, 255*a), 0.7/myX*sx, fonts["fontawesome-16"], "center", "center")
        end    

        local tags = getSoundMetaTags(playedMusics[occupiedVeh])

        if (tags.stream_name or false) then 
            dxDrawText(tags.stream_name, positions["big"][1]+2/myX*sx, positions["big"][2]+8/myY*sy, positions["big"][1]+2/myX*sx+sx*0.215, positions["big"][2]+8/myY*sy+sy*0.161, tocolor(255, 255, 255, 255*a), 0.95/myX*sx, fonts["bebasneue-13"], "center", "top", true)
        end

        if tags.stream_title then 
            --[[if lastTextMove + 500 < getTickCount() then 
                lastTextMove = getTickCount()
                textTableIndex = textTableIndex + 1
            end

            text = string.split(tags.stream_title)

            if textTableIndex > #text-30 then 
               textTableIndex = 1
            end
            

            if #text < 30 then
               positions["big"][1]+2/myX*sx, positions["big"][2]+2/myY*sy, sx*0.215, sy*0.161]]

                dxDrawText(tags.stream_title, positions["big"][1]+115/myX*sx, positions["big"][2]+148/myY*sy, positions["big"][1]+115/myX*sx+sx*0.173, positions["big"][2]+148/myY*sy+sy*0.033, tocolor(255, 255, 255, 255*a), 0.85/myX*sx, fonts["condensed-11"], "left", "center", true)
            --else
                --dxDrawText(table.concat(text, "", textTableIndex, textTableIndex+30), positions["big"][1]+115/myX*sx, positions["big"][2]+148/myY*sy, positions["big"][1]+115/myX*sx+sx*0.173, positions["big"][2]+148/myY*sy+sy*0.033, tocolor(255, 255, 255, 255), 0.85/myX*sx, fonts["condensed-11"], "center", "center", true)
            --end
        else
            dxDrawText("Nincs adat!", positions["big"][1]+110/myX*sx, positions["big"][2]+148/myY*sy, positions["big"][1]+110/myX*sx+sx*0.18, positions["big"][2]+148/myY*sy+sy*0.033, tocolor(255, 255, 255, 255*a), 0.85/myX*sx, fonts["condensed-11"], "center", "center", false, false, false, true)
        end

        if audioVizualizerShowing then 
            local startx = positions["big"][1]+13/myX*sx
            if playedMusics[occupiedVeh] then
                local soundFFT = getSoundFFTData (playedMusics[occupiedVeh], 2048, 120)
                if (soundFFT) then
                    for i = 0, 105 do
                        if soundFFT[i] > 0.4 then 
                            soundFFT[i] = 0.4 
                        end
                        local r, g, b = hex2rgb(colors[i+1])

                        soundFFT[i] = tonumber(soundFFT[i])*volume/100
                    
                        dxDrawRectangle ( startx,  positions["big"][2]+sy*0.095 + sy*math.sqrt(soundFFT[i])/10, 3/myX*sx, (0-math.sqrt( soundFFT[i] ) * (256*0.8))/myY*sy, tocolor(r, g, b, 255*a))
                        startx = startx + 3/myX*sx
                    end
                end
            end
        else
            dxDrawImage(positions["big"][1]+120/myX*sx, positions["big"][2]+10/myY*sy, 110/myX*sx, 110/myY*sy, "files/logo.png", 0, 0, 0, tocolor(r, g, b, 100*a))
            dxDrawText("ORIGINAL ROLEPLAY \n VEHICLE AUDIO SYSTEM", positions["big"][1]+120/myX*sx, positions["big"][2]+120/myY*sy, positions["big"][1]+240/myX*sx, positions["big"][2]+120/myY*sy+sy*0.01, tocolor(r, g, b, 200*a), 0.65/myX*sx, fonts["condensed-16"], "center", "center")
        end

        dxDrawRectangle(positions["big"][1], positions["big"][2]+sy*0.203, sx*0.25, sy*0.1, tocolor(40, 40, 40, 255*a))

        local startY = positions["big"][2]+sy*0.205
    
        for i = 1, 3 do 
            local barColor = tocolor(33, 33, 33, 255*a)
            local barColor2 = tocolor(r, g, b, 255*a)

            if (i+radioScroll) % 2 == 0 then 
                barColor = tocolor(33, 33, 33, 140*a)
                barColor2 = tocolor(r, g, b, 150*a)
            end

            dxDrawRectangle(positions["big"][1]+2/myX*sx, startY, sx*0.245, sy*0.03, barColor)
            dxDrawRectangle(positions["big"][1]+2/myX*sx, startY, 2/myX*sx, sy*0.03, barColor2)

            --dxDrawRectangle(positions["big"][1]+sx*0.245-25/myX*sx, startY, 25/myX*sx, sy*0.03, tocolor(255, 0, 0, 255))
            if core:isInSlot(positions["big"][1]+sx*0.245-25/myX*sx, startY, 25/myX*sx, sy*0.03) or stations[i+radioScroll][3] == 1 then 
                dxDrawText("", positions["big"][1]+sx*0.245-25/myX*sx, startY, positions["big"][1]+sx*0.245-2/myX*sx, startY+sy*0.03, tocolor(255, 255, 255, 255*a), 0.65/myX*sx, fonts["fontawesome-16"], "right", "center")
            else
                dxDrawText("", positions["big"][1]+sx*0.245-25/myX*sx, startY, positions["big"][1]+sx*0.245-2/myX*sx, startY+sy*0.03, tocolor(255, 255, 255, 100*a), 0.65/myX*sx, fonts["fontawesome-16"], "right", "center")
            end

            if getElementData(occupiedVeh, "vehicleRadio:streamURL") == stations[i+radioScroll][2] then 
                dxDrawText(stations[i+radioScroll][1], positions["big"][1]+sx*0.005, startY, positions["big"][1]+sx*0.245, startY+sy*0.03, tocolor(r, g, b, 255*a), 0.8/myX*sx, fonts["condensed-11"], "left", "center")
            else
                dxDrawText(stations[i+radioScroll][1], positions["big"][1]+sx*0.005, startY, positions["big"][1]+sx*0.245, startY+sy*0.03, tocolor(255, 255, 255, 255*a), 0.8/myX*sx, fonts["condensed-11"], "left", "center")
            end

            startY = startY + sy*0.033
        end
        
        dxDrawRectangle(positions["big"][1]+sx*0.2475, positions["big"][2]+sy*0.203+2/myY*sy, 2/myX*sx, sy*0.1-4/myY*sy, tocolor(r, g, b, 150*a))

        local lineHeight = 3/#stations 

        if lineHeight > 1 then 
            lineHeight = 1 
        end 

        dxDrawRectangle(positions["big"][1]+sx*0.2475, positions["big"][2]+sy*0.203+2/myY*sy + ((sy*0.1-4/myY*sy)*(lineHeight*radioScroll/3)), 2/myX*sx, (sy*0.1-4/myY*sy)*lineHeight, tocolor(r, g, b, 255*a))
    else
        dxDrawText("A rádió ki van kapcsolva!", positions["big"][1]+115/myX*sx, positions["big"][2]+148/myY*sy, positions["big"][1]+115/myX*sx+sx*0.173, positions["big"][2]+148/myY*sy+sy*0.033, tocolor(255, 255, 255, 255*a), 0.85/myX*sx, fonts["condensed-11"], "left", "center", true)

        dxDrawImage(positions["big"][1]+120/myX*sx, positions["big"][2]+2/myY*sy, 110/myX*sx, 110/myY*sy, "files/logo.png", 0, 0, 0, tocolor(r, g, b, 100*a))
        dxDrawText("ORIGINAL ROLEPLAY \n VEHICLE AUDIO SYSTEM", positions["big"][1]+120/myX*sx, positions["big"][2]+115/myY*sy, positions["big"][1]+240/myX*sx, positions["big"][2]+115/myY*sy+sy*0.01, tocolor(r, g, b, 200*a), 0.75/myX*sx, fonts["condensed-16"], "center", "center")
    end

    if radioMoveing then 
        if not isCursorShowing() then radioMoving = false return end
        local cx, cy = getCursorPosition()

        cx, cy = cx*sx, cy*sy 
        cx, cy = cx + radioMoveing[1], cy + radioMoveing[2]

        positions["big"][1] = cx 
        positions["big"][2] = cy 
    end
end

function keyRadio(key, state)
    if state then 
        if core:isInSlot(positions["big"][1], positions["big"][2]+sy*0.203, sx*0.25, sy*0.1) then 
            if key == "mouse_wheel_down" then
                if stations[radioScroll+4] then 
                    radioScroll = radioScroll + 1
                end
            elseif key == "mouse_wheel_up" then 
                if radioScroll > 0 then 
                    radioScroll = radioScroll - 1
                end
            end
        end

        if key == "mouse1" then 
            local startY = positions["big"][2]+sy*0.205
            for i = 1, 3 do 
                if core:isInSlot(positions["big"][1]+sx*0.245-25/myX*sx, startY, 25/myX*sx, sy*0.03) then 
                    if stations[i+radioScroll][3] == 0 then 
                        stations[i+radioScroll][3] = 1 
                    elseif stations[i+radioScroll][3] == 1 then 
                        stations[i+radioScroll][3] = 0
                    end
                    sortChannels()
                end

                if core:isInSlot(positions["big"][1]+2/myX*sx, startY, sx*0.225, sy*0.03) then 
                    setElementData(getPedOccupiedVehicle(localPlayer), "vehicleRadio:streamURL", stations[i+radioScroll][2])
                end

                startY = startY + sy*0.033
            end

            if core:isInSlot(positions["big"][1]+2/myX*sx, positions["big"][2]+2/myY*sy, sx*0.215, sy*0.161) then 
                local cx, cy = getCursorPosition()
                cx, cy = cx*sx, cy*sy 

                radioMoveing = {positions["big"][1]-cx, positions["big"][2]-cy}
            end

            if core:isInSlot(positions["big"][1]+2/myX*sx+sx*0.067/3, positions["big"][2]+148/myY*sy, sx*0.067/3, sy*0.033) then 
                local occupiedVeh = getPedOccupiedVehicle(localPlayer)

                local state = getElementData(occupiedVeh, "vehicleRadio:state") or false 

                if not state then 
                    --setElementData(occupiedVeh, "vehicleRadio:streamURL", stations[math.random(#stations)][2])
                    setElementData(occupiedVeh, "vehicleRadio:streamURL", stations[1][2])
                end

                setElementData(occupiedVeh, "vehicleRadio:state", not state)
            end

            if core:isInSlot(positions["big"][1]+2/myX*sx+(sx*0.067/3*2), positions["big"][2]+148/myY*sy, sx*0.067/3, sy*0.033) then 
                setElementData(getPedOccupiedVehicle(localPlayer), "vehicleRadio:volume", 0)
            end    

            if core:isInSlot(positions["big"][1]+2/myX*sx, positions["big"][2]+148/myY*sy, sx*0.067/3, sy*0.033) then 
                audioVizualizerShowing = not audioVizualizerShowing 
            end
        end
    else
        if key == "mouse1" then 
            radioMoveing = false
        end
    end
end

local showing = false
local lastInteraction = 0
bindKey("r", "up", function()
    if (getPedOccupiedVehicleSeat(localPlayer) or 2) <= 1 then 
        if getVehicleType(getPedOccupiedVehicle(localPlayer)) == "Automobile" then 
            if lastInteraction + 300 < getTickCount() then 
                lastInteraction = getTickCount()
                showing = not showing 

                if showing then 
                    if isCursorShowing() then return end
                    animType = "open" 
                    tick = getTickCount()
                    addEventHandler("onClientRender", root, renderRadio)
                    addEventHandler("onClientKey", root, keyRadio)
                else 
                    animType = "close"
                    tick = getTickCount() 
                    removeEventHandler("onClientKey", root, keyRadio)

                    setTimer(function()
                        removeEventHandler("onClientRender", root, renderRadio)
                    end, 300, 1)
                end
            end
        end
    end
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    local favouriteChannels = {}

    for k, v in ipairs(stations) do 
        if v[3] == 1 then 
            table.insert(favouriteChannels, v[1])
        end
    end

    exports.oJSON:saveDataToJSONFile(favouriteChannels, "radio_FavouriteChannels", true)
    exports.oJSON:saveDataToJSONFile(positions, "radio_Positions", true)
    exports.oJSON:saveDataToJSONFile(audioVizualizerShowing, "radio_VizualizerShowing", true)
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    local favouriteChannels = {}

    for k, v in ipairs(exports.oJSON:loadDataFromJSONFile("radio_FavouriteChannels", true)) do 
        table.insert(favouriteChannels, v)
    end

    for k, v in ipairs(stations) do 
        if core:tableContains(favouriteChannels, v[1]) then 
            v[3] = 1
        end
    end

    sortChannels()

    positions = exports.oJSON:loadDataFromJSONFile("radio_Positions", true) or {
        ["big"] = {sx*0.375, sy*0.39},
        --["small"] = {sx*0.375, sy*0.75},
    }

    for k, v in ipairs(getElementsByType("vehicle", root, true)) do 
        if getElementData(v, "vehicleRadio:state") then 
            if not playedMusics[v] then 
                playedMusics[v] = playSound(getElementData(v, "vehicleRadio:streamURL"))
            end  
        end
    end

    --if exports.oJSON:loadDataFromJSONFile("radio_VizualizerShowing", true) then 
        audioVizualizerShowing =  exports.oJSON:loadDataFromJSONFile("radio_VizualizerShowing", true)
    --end
end)

function hex2rgb(hex)
    if hex then
        hex = hex:gsub("#","")
        return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
    end
end

function string.split(str)

    if not str or type(str) ~= "string" then return false end
 
    local splitStr = {}
    for i=1,string.len(str) do
        local char = string.sub(str, i, i )
        --char = CodeToUTF8(char)
        --if not (char == " ") then 
            table.insert( splitStr , char )
        --end
    end
 
    --outputConsole(toJSON(splitStr))
    return splitStr 
end

function sortChannels()
    local channels = {}

    local primaryChannels = {}

    for k, v in ipairs(stations) do 
        if v[3] == 1 then 
            table.insert(primaryChannels, v)
        else
            table.insert(channels, v)
        end
    end

    for k, v in ipairs(primaryChannels) do 
        table.insert(channels, 1, v)
    end

    stations = channels
end