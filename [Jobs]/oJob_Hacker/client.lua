local sx, sy = guiGetScreenSize()
local myX, myY = 1768, 992

local apps = {
    -- név, ablak háttér, x, y, w, h, megnyitva, desktopIcon
    {"cmd", "cmd.PNG", sx*0.45, sy*0.25, 566/myX*sx, 426/myY*sy, false, "consol.png"},
    {"Megbízások", "list.PNG", sx*0.2, sy*0.17, 366/myX*sx, 459/myY*sy, false, "web.png"},
}

local fonts

local computerIsOpen = false
local playerInChair = false

local imageTextures = {}
_dxDrawImage = dxDrawImage
function dxDrawImage(x, y, w, h, img, ...) 
	--[[if not imageTextures[img] then 
		imageTextures[img] = dxCreateTexture(img, "dxt5")
	end]]

	_dxDrawImage(x, y, w, h, img, ...)
end

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oInfobox" or getResourceName(res) == "oJob_Hacker" then  
		core = exports.oCore
        infobox = exports.oInfobox
        color, r, g, b = core:getServerColor()
	end
end)

--/ UI /--
local movedElement = false
local pickupX, pickupY
----------

--/ CMD /--
local hackText = hackTexts[math.random(#hackTexts)]

local cmdTexts = {}
local cmdPointer = 0

local isCMDEditActive = false
local cmdEditText = ""
local cmdCursorTick = getTickCount()

local successHacks, successNeededHacks = 0, 5

local accessState = false
local activeWork = false
-----------

--/ Jobs /--
local works = {
    -- cég neve, lejárat, fizetség, szükséges hackek száma, ip, isActiv
}

setTimer(createNewWork, 100, 1)

local workPointer = 0

local newJobTimer = math.random(25, 60)

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oInfobox" then  
		core = exports.oCore
        infobox = exports.oInfobox
        color, r, g, b = core:getServerColor()
	end
end)
------------

function renderScreen()
    dxDrawImage(sx*0.19, sy*0.09, 1600/myX*sx*0.68, 900/myY*sy*0.68, "files/orpbg.png")

    --dxDrawRectangle(sx*0.695, sy*0.09, sx*0.1, sy*0.1)
    local hour, min = core:getDate("hour"), core:getDate("minute")
    local year, monthname, monthday = core:getDate("year"), core:getDate("monthname"), core:getDate("monthday")
    dxDrawText(string.format("%02d:%02d", hour, min), sx*0.695, sy*0.09, sx*0.695+sx*0.1, sy*0.09+sy*0.1, tocolor(255, 255, 255, 200), 0.8/myX*sx, fonts["ui-light-45"], "right", "center")
    dxDrawText(string.format("%04d. %s %02d.", year, monthname, monthday), sx*0.695, sy*0.09+sy*0.05, sx*0.695+sx*0.1, sy*0.09+sy*0.13, tocolor(255, 255, 255, 100), 0.8/myX*sx, fonts["ui-15"], "right", "center")

    if core:isInSlot(sx*0.74, sy*0.635, sx*0.06, sy*0.05) then 
        dxDrawText("LEÁLLÍTÁS", sx*0.695, sy*0.58+sy*0.05, sx*0.695+sx*0.1, sy*0.58+sy*0.13, tocolor(255, 255, 255, 200), 0.8/myX*sx, fonts["ui-15"], "right", "center")
    else
        dxDrawText("LEÁLLÍTÁS", sx*0.695, sy*0.58+sy*0.05, sx*0.695+sx*0.1, sy*0.58+sy*0.13, tocolor(255, 255, 255, 100), 0.8/myX*sx, fonts["ui-15"], "right", "center")
    end

    local startX, startY = sx*0.2, sy*0.115
    for k, v in ipairs(apps) do 
        if v[7] then 
            dxDrawImage(v[3], v[4], v[5], v[6], "files/"..v[2], 0, 0, 0, tocolor(255, 255, 255, 255), true)

            if core:isInSlot(v[3] + v[5] - 30/myX*sx, v[4] + sy*0.013, 17/myX*sx, 17/myY*sy) then 
                dxDrawImage(v[3] + v[5] - 30/myX*sx, v[4] + sy*0.013, 17/myX*sx, 17/myY*sy, "files/close.png", 0, 0, 0, tocolor(255, 255, 255, 220), true)
            else
                dxDrawImage(v[3] + v[5] - 30/myX*sx, v[4] + sy*0.013, 17/myX*sx, 17/myY*sy, "files/close.png", 0, 0, 0, tocolor(255, 255, 255, 150), true)
            end

            if v[1] == "Megbízások" then 
                dxDrawText(v[1] .. " ("..newJobTimer.."mp)", v[3]+sx*0.023, v[4]+sy*0.01, v[3]+sx*0.023+sx*0.1, v[4]+sy*0.01+sy*0.025, tocolor(255, 255, 255, 200), 0.7/myX*sx, fonts["ui-15"], "left", "center", false, false, true)
            elseif v[1] == "cmd" then 
                if activeWork then 
                    dxDrawText(v[1] .. " ("..works[activeWork][5]..")", v[3]+sx*0.023, v[4]+sy*0.01, v[3]+sx*0.023+sx*0.1, v[4]+sy*0.01+sy*0.025, tocolor(255, 255, 255, 200), 0.7/myX*sx, fonts["ui-15"], "left", "center", false, false, true)
                else
                    dxDrawText(v[1], v[3]+sx*0.023, v[4]+sy*0.01, v[3]+sx*0.023+sx*0.1, v[4]+sy*0.01+sy*0.025, tocolor(255, 255, 255, 200), 0.7/myX*sx, fonts["ui-15"], "left", "center", false, false, true)
                end
            else
                dxDrawText(v[1], v[3]+sx*0.023, v[4]+sy*0.01, v[3]+sx*0.023+sx*0.1, v[4]+sy*0.01+sy*0.025, tocolor(255, 255, 255, 200), 0.7/myX*sx, fonts["ui-15"], "left", "center", false, false, true)
            end

            if v[1] == "cmd" then 

                dxDrawRectangle(v[3]+sx*0.305, v[4]+sy*0.15, sx*0.005, sy*0.21, tocolor(77, 100, 122, 100), true)
                local lineHeight = math.min(7/#cmdTexts, 1)
                dxDrawRectangle(v[3]+sx*0.305, v[4]+sy*0.15 + (sy*0.21 * (lineHeight*cmdPointer/7)), sx*0.005, sy*0.21 * lineHeight, tocolor(77, 100, 122, 255), true)
    
                if activeWork then 
                    dxDrawRectangle(v[3]+sx*0.045, v[4]+sy*0.35, dxGetTextWidth(hackText, 0.6/myX*sx, fonts["ui-15"]) + sx*0.01, sy*0.02, tocolor(77, 100, 122, 255), true)
                    dxDrawText(hackText, v[3]+sx*0.045, v[4]+sy*0.35, v[3]+sx*0.045 + dxGetTextWidth(hackText, 0.6/myX*sx, fonts["ui-15"]) + sx*0.01, v[4]+sy*0.35 + sy*0.02, tocolor(255, 255, 255, 200), 0.6/myX*sx, fonts["ui-15"], "center", "center", false, false, true)

                    dxDrawText(works[activeWork][5], v[3]+sx*0.06, v[4]+sy*0.055, v[3]+sx*0.06+sx*0.1, v[4]+sy*0.055+sy*0.023, tocolor(255, 255, 255, 200), 0.65/myX*sx, fonts["ui-15"], "left", "center", false, false, true)
                end

                --dxDrawRectangle(v[3]+sx*0.06, v[4]+sy*0.055, sx*0.1, sy*0.023, tocolor(255, 255, 255, 255), true)
                
    
                local startY = v[4] + sy*0.15
                for i = 1, 7 do 
                    local v2 = cmdTexts[i + cmdPointer]
    
                    if v2 then 
                        --dxDrawRectangle(v[3]+sx*0.015, startY, sx*0.15, sy*0.025)
                        dxDrawText("> "..v2, v[3]+sx*0.015, startY, v[3]+sx*0.015+sx*0.15, startY+sy*0.025, tocolor(255, 255, 255, 200), 0.65/myX*sx, fonts["ui-15"], "left", "center", false, false, true, true)
                    end
                    startY = startY + sy*0.026
                end
    
                if isCMDEditActive then 
                    if cmdCursorTick + 300 < getTickCount() then 
                        if cmdCursorTick + 500 < getTickCount() then 
                            cmdCursorTick = getTickCount()
                        end
    
                        dxDrawText(cmdEditText.."|", v[3]+sx*0.027, v[4]+sy*0.38, v[3]+sx*0.027+sx*0.27, v[4]+sy*0.38+sy*0.024, tocolor(255, 255, 255, 220), 0.7/myX*sx, fonts["ui-15"], "left", "center", false, false, true)
                    else
                        dxDrawText(cmdEditText, v[3]+sx*0.027, v[4]+sy*0.38, v[3]+sx*0.027+sx*0.27, v[4]+sy*0.38+sy*0.024, tocolor(255, 255, 255, 220), 0.7/myX*sx, fonts["ui-15"], "left", "center", false, false, true)
                    end
                else
                    dxDrawText(cmdEditText, v[3]+sx*0.027, v[4]+sy*0.38, v[3]+sx*0.027+sx*0.27, v[4]+sy*0.38+sy*0.024, tocolor(255, 255, 255, 220), 0.7/myX*sx, fonts["ui-15"], "left", "center", false, false, true)
                end
    
                dxDrawRectangle(v[3]+sx*0.083, v[4]+sy*0.095, sx*0.22, sy*0.02, tocolor(191, 207, 204, 100), true)
                dxDrawRectangle(v[3]+sx*0.083, v[4]+sy*0.095, sx*0.22 * (successHacks/successNeededHacks), sy*0.02, tocolor(191, 207, 204, 255), true)
    
                if accessState then 
                    core:dxDrawOutLine(v[3] + sx*0.1, v[4]+sy*0.22, sx*0.1, sy*0.05, accessStates[accessState][2], 1, true)
                    dxDrawText(accessStates[accessState][1], v[3] + sx*0.1, v[4]+sy*0.22, v[3] + sx*0.1+sx*0.1, v[4]+sy*0.22+sy*0.05, accessStates[accessState][2], 0.8/myX*sx, fonts["ui-15"], "center", "center", false, false, true)
                end

            elseif v[1] == "Megbízások" then 
                local startY = v[4] + sy*0.044

                for i = 1, 7 do 
                    local v2 = works[i + workPointer] 

                    if v2 then
                        if core:isInSlot(v[3] + sx*0.007, startY, sx*0.175, sy*0.05) or v2[7] then 
                            dxDrawRectangle(v[3] + sx*0.007, startY, sx*0.175, sy*0.05, tocolor(77, 100, 122, 200), true)
                        else
                            dxDrawRectangle(v[3] + sx*0.007, startY, sx*0.175, sy*0.05, tocolor(77, 100, 122, 100), true)
                        end

                        --dxDrawRectangle(v[3] + sx*0.01, startY, sx*0.1, sy*0.02, _, true)
                        dxDrawText(v2[1], v[3] + sx*0.01, startY, v[3] + sx*0.01+sx*0.1, startY+sy*0.02, tocolor(255, 255, 255, 200), 0.65/myX*sx, fonts["ui-15"], "left", "center", false, false, true)
                        dxDrawText(v2[3].."$ | "..v2[4].." szükséges hack", v[3] + sx*0.01, startY + sy*0.02, v[3] + sx*0.01+sx*0.1, startY+sy*0.03, tocolor(255, 255, 255, 100), 0.55/myX*sx, fonts["ui-15"], "left", "center", false, false, true)

                        if v2[6] then 
                            dxDrawText(v2[5], v[3] + sx*0.01, startY + sy*0.03, v[3] + sx*0.01+sx*0.1, startY+sy*0.05, tocolor(255, 255, 255, 200), 0.55/myX*sx, fonts["ui-15"], "left", "center", false, false, true)
                        else
                            if core:isInSlot(v[3] + sx*0.01, startY + sy*0.03, sx*0.02, sy*0.02) then 
                                dxDrawText("Elvállal", v[3] + sx*0.01, startY + sy*0.03, v[3] + sx*0.01+sx*0.1, startY+sy*0.05, tocolor(r, g, b, 255), 0.55/myX*sx, fonts["ui-15"], "left", "center", false, false, true)
                            else
                                dxDrawText("Elvállal", v[3] + sx*0.01, startY + sy*0.03, v[3] + sx*0.01+sx*0.1, startY+sy*0.05, tocolor(r, g, b, 100), 0.55/myX*sx, fonts["ui-15"], "left", "center", false, false, true)
                            end
                        end

                        dxDrawImage(v[3] + sx*0.167, startY + sy*0.024, 20/myX*sx, 20/myY*sy, "files/clock.png", 0, 0, 0, tocolor(r, g, b, 255), true)
                        dxDrawText(v2[2], v[3] + sx*0.15, startY + sy*0.024, v[3] + sx*0.15+sx*0.015, startY + sy*0.024+20/myY*sy, tocolor(r, g, b, 255), 0.6/myX*sx, fonts["ui-15"], "right", "center", false, false, true)
                    end

                    startY = startY + sy*0.059
                end

                dxDrawRectangle(v[3]+sx*0.189, v[4]+sy*0.044, sx*0.005, sy*0.404, tocolor(77, 100, 122, 100), true)
                local lineHeight = math.min(7/#works, 1)
                dxDrawRectangle(v[3]+sx*0.189, v[4]+sy*0.044 + (sy*0.404 * (lineHeight*workPointer/7)), sx*0.005, sy*0.404 * lineHeight, tocolor(77, 100, 122, 255), true)
            end

            if movedElement == k then 
                local cx, cy = getCursorPosition()
                --cx, cy = cx, cy

                cx, cy = cx*sx - (pickupX), cy*sy - (pickupY)

                if cx > sx*0.185 and cy > sy*0.09 and (cy + v[6]) < sy*0.71 and (cx + v[5]) < sx*0.81 then 
                    v[3], v[4] = cx, cy
                end
            end
        end

        --dxDrawRectangle(startX, startY, 50/myX*sx, 50/myY*sy)
        if core:isInSlot(startX, startY, 50/myX*sx, 50/myY*sy) then 
            dxDrawImage(startX, startY, 50/myX*sx, 50/myY*sy, "files/icons/"..v[8], 0, 0, 0, tocolor(255, 255, 255, 255))
        else
            dxDrawImage(startX, startY, 50/myX*sx, 50/myY*sy, "files/icons/"..v[8], 0, 0, 0, tocolor(255, 255, 255, 200))
        end
        dxDrawText(v[1], startX, startY, startX+50/myX*sx, startY+65/myY*sy, tocolor(255, 255, 255, 255), 0.45/myX*sx, fonts["ui-15"], "center", "bottom")

        startY = startY + 80/myY*sy
        
    end

    dxDrawImage(sx*0.15, sy*0.03, 2456/myX*sx*0.5, 1816/myY*sy*0.5, "files/monitor.png", 0, 0, 0, tocolor(255, 255, 255), false)
end

function keyScreen(key, state)

    if key == "mouse1" and state then 
        if core:isInSlot(sx*0.74, sy*0.635, sx*0.06, sy*0.05) then 
            if not activeWork then 
                closeComputer()
            end
        end
    end

    local startX, startY = sx*0.2, sy*0.115
    for k, v in ipairs(apps) do 
        if v[7] then 
            if key == "mouse1" then 
                if state then 
                    if core:isInSlot(v[3] + v[5] - 30/myX*sx, v[4] + sy*0.013, 17/myX*sx, 17/myY*sy) then 
                        v[7] = false
                    end

                    if core:isInSlot(v[3]+sx*0.023, v[4]+sy*0.01, v[5] - sx*0.045, sy*0.025) then 
                        movedElement = k
                        pickupX, pickupY = getCursorPosition()
                        pickupX, pickupY = pickupX*sx - v[3], pickupY*sy - v[4]
                    end
                else
                    if movedElement then 
                        movedElement = false 
                    end
                end
            end

            if v[1] == "cmd" then 
                if state then 
                    if core:isInSlot(v[3], v[4]+sy*0.14, v[5], sy*0.23) then 
                        if key == "mouse_wheel_down" then 
                            if cmdTexts[cmdPointer + 8] then
                                cmdPointer = cmdPointer + 1
                            end
                        elseif key == "mouse_wheel_up" then 
                            if cmdPointer > 0 then
                                cmdPointer = cmdPointer - 1
                            end
                        end
                    end

                    if key == "mouse1" then 
                        if core:isInSlot(v[3]+sx*0.018, v[4]+sy*0.38, sx*0.285, sy*0.024) then 
                            isCMDEditActive = true
                        else
                            isCMDEditActive = false
                        end
                    end

                    if isCMDEditActive then 
                        cancelEvent()
                        if accessState then return end
                        if key == "backspace" then 
                            cmdEditText = cmdEditText:gsub("[^\128-\191][\128-\191]*$", "")
                        elseif key == "enter" then 
                            table.insert(cmdTexts, cmdEditText)

                            if activeWork then 
                                if cmdEditText == hackText then 
                                    successHacks = successHacks + 1

                                    if successHacks == successNeededHacks then 
                                        table.insert(cmdTexts, "#3dc45fSystem Hack Successful!")
                                        table.insert(cmdTexts, "#3dc45fACCESS GRANTED!")
                                        accessState = "granted"
                                        playSound("files/sounds/granted.mp3")

                                        setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money") + works[activeWork][3])
                                        infobox:outputInfoBox("A sikeres hackelésért kaptál "..works[activeWork][3].."$-t.", "success")
                                        table.remove(works, activeWork)
                                        activeWork = false

                                        setTimer(function()
                                            accessState = false
                                            successHacks = 0
                                        end, 2500, 1)
                                    end
                                else
                                    playSound("files/sounds/bad.mp3")
                                    table.insert(cmdTexts, "#bf3939Bad usage!")
                                    successHacks = math.max(0, successHacks - math.random(1, 4))

                                    if successHacks - 1 < 0 then 
                                        accessState = "denied"

                                        setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money") - math.floor(works[activeWork][3] * 0.1))
                                        infobox:outputInfoBox("A sikertelen hackelésért levontak tőled "..math.floor(works[activeWork][3] * 0.1).."$-t.", "warning")

                                        setTimer(function()
                                            accessState = false
                                            successHacks = 0
                                        end, 2500, 1)
                        
                                        table.remove(works, activeWork)
                                        activeWork = false
                                    end 
                                end
                            else
                                if string.find(cmdEditText, "connect") then 
                                    local ip = cmdEditText:gsub("connect ", "")
                                    --print(ip)

                                    table.insert(cmdTexts, "Connecting to: "..ip)

                                    setTimer(function()
                                        for k, v in ipairs(works) do 
                                            if v[5] == ip then 
                                                if v[6] then 
                                                    activeWork = k
                                                    successNeededHacks = v[4]
                                                    table.insert(cmdTexts, "#3dc45fConnection successful!")

                                                    cmdEditText = ""

                                                    if #cmdTexts > 7 then 
                                                        cmdPointer = #cmdTexts - 7
                                                    end

                                                    return
                                                end
                                            end
                                        end

                                        table.insert(cmdTexts, "#bf3939Connection error!")
                                    end, math.random(750, 2500), 1)

                                elseif cmdEditText == "clear" then 
                                    cmdTexts = {}
                                    cmdPointer = 0
                                end
                            end

                            cmdEditText = ""

                            if #cmdTexts > 7 then 
                                cmdPointer = #cmdTexts - 7
                            end

                            hackText = hackTexts[math.random(#hackTexts)]
                        elseif key == "space" then 
                            cmdEditText = cmdEditText .. " "
                        elseif key == "." then 
                            cmdEditText = cmdEditText .. "."
                        elseif core:keyIsRealKeyboardLetter(key) then 
                            if not deniedKeyboardLetters[tostring(key)] then
                                cmdEditText = cmdEditText .. core:getHungarianKeyboardLetter(key):gsub("num_", "")
                            end
                        end
                    end
                end
            elseif v[1] == "Megbízások" then 
                local startY = v[4] + sy*0.044

                if key == "mouse1" and state then 
                    for i = 1, 7 do 
                        local v2 = works[i + workPointer] 

                        if v2 then
                            if not v2[6] then 
                                if core:isInSlot(v[3] + sx*0.01, startY + sy*0.03, sx*0.02, sy*0.02) then 
                                    v2[6] = true
                                    infobox:outputInfoBox("Elfogadtál egy megbízást!", "success")
                                    infobox:outputInfoBox("A feladat kezdéséhez használd a 'connect "..v2[5].."' parancsot a konzolban.", "info")
                                end
                            end
                        end

                        startY = startY + sy*0.059
                    end
                end

                if state then
                    if core:isInSlot(v[3] + sx*0.005, v[4] + sy*0.04, v[5] - sx*0.01, v[6] - sy*0.05) then 
                        if key == "mouse_wheel_down" then 
                            if works[workPointer + 8] then
                                workPointer = workPointer + 1
                            end
                        elseif key == "mouse_wheel_up" then 
                            if workPointer > 0 then
                                workPointer = workPointer - 1
                            end
                        end
                    end
                end
            end
        end

        if key == "mouse1" and state then 
            if core:isInSlot(startX, startY, 50/myX*sx, 50/myY*sy) then 
                v[7] = true
            end
        end

        startY = startY + 80/myY*sy
    end
end

local clockTimer = false
function openComputer()

    fonts = {
        ["ui-15"] = dxCreateFont("files/ui.ttf", 15),
        ["ui-light-45"] = dxCreateFont("files/ui-light.ttf", 45),
    }

    showChat(false)
    exports.oInterface:toggleHud(true)

    computerIsOpen = true
    addEventHandler("onClientKey", root, keyScreen)
    addEventHandler("onClientRender", root, renderScreen)

    clockTimer = setTimer(function()
        for k, v in ipairs(works) do 
            v[2] = v[2] - 1
    
            if v[2] <= 0 then 
                if v[6] then 
                    --setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money") - math.floor(v[3] * 0.1))
                    infobox:outputInfoBox("Lejárt az idő! A sikertelen hackelésért levontak tőled "..math.floor(works[activeWork][3] * 0.1).."$-t.", "warning")
                    if activeWork == k then 
                        accessState = "denied"
                        table.insert(cmdTexts, "#bf3939Time is up!")
    
                        setTimer(function()
                            accessState = false
                            successHacks = 0
                        end, 2500, 1)

                        activeWork = false
                    end
    
                    table.remove(works, k)
                else
                    table.remove(works, k)
                end
            end
        end
    
        newJobTimer = newJobTimer - 1 
    
        if newJobTimer <= 0 then 
            newJobTimer = math.random(25, 60)
    
            if #works < 10 then 
                createNewWork()
            end
        end
    end, 1000, 0)
end

function createNewWork()
    local hackCount = math.random(8, 25)
    if exports.oJob:isJobHasDoublePaymant(4) then
        table.insert(works, {companys[math.random(#companys)], math.random(110, 250), (60 + (hackCount * 10)) * 2, hackCount, generateRandomIP(), false})
    else
        table.insert(works, {companys[math.random(#companys)], math.random(110, 250), (60 + (hackCount * 10)), hackCount, generateRandomIP(), false})
    end
end

function closeComputer()
    for k, v in pairs(fonts) do 
        destroyElement(v)
    end

    for k, v in pairs(imageTextures) do 
        if v then
            destroyElement(v)
            imageTextures[k] = false
        end
    end

    removeEventHandler("onClientKey", root, keyScreen)
    removeEventHandler("onClientRender", root, renderScreen)
    computerIsOpen = false
    if isTimer(clockTimer) then killTimer(clockTimer) end

    showChat(true)
    exports.oInterface:toggleHud(false)
    outputChatBox(core:getServerPrefix("server", "Etikus Hacker", 3).."A székből való kiszáláshoz nyomd a "..color.."[Backspace] #ffffffgombot!", 255, 255, 255, true)
end

--openComputer()

addEventHandler("onClientKey", root, function(key, state)
    if key == "backspace" and state then 
        if playerInChair then 
            if computerIsOpen then return end
            setElementData(playerInChair, "job:hacker:charIsBusy", false)
            triggerServerEvent("job > hacker > leaveFromTheChair", resourceRoot, playerInChair)

            playerInChair = false 
        end
    end
end)

addEventHandler("onClientClick", root, function(key, state, _, _, _, _, _, element)
    if key == "right" and state == "up" then 
        if element then 
            if core:getDistance(localPlayer, element) < 2 then 
                if getElementData(element, "job:hacker:isHackerChair") then 
                    if getElementData(localPlayer, "char:job") == 4 then 
                        if computerIsOpen then return end
                        if isElement(getElementData(element, "job:hacker:charIsBusy")) then return end
                        if playerInChair then return end

                        triggerServerEvent("job > hacker > sitOnTheChair", resourceRoot, element)
                        setElementData(element, "job:hacker:charIsBusy", localPlayer)
                        playerInChair = element

                        openComputer()
                    end
                end
            end
        end
    end
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    if playerInChair then 
        triggerServerEvent("job > hacker > leaveFromTheChair", resourceRoot, playerInChair)
    end
end)

function printJobTips()
    outputChatBox(core:getServerPrefix("server", "Etikus Hacker", 3).."Az irodát megjelöltük a térképen egy "..color.."narancssárga#ffffff táska ikonnal.", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Etikus Hacker", 3).."A munka kezdéséhez ülj le az egyik szabad számítógép elé.", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Etikus Hacker", 3).."A megbízásokat a "..color.."'Megbízások' #ffffffmenüpont alatt találod meg.", 255, 255, 255, true)
end

local jobblip = false
addEventHandler("onClientElementDataChange", root, function(data, old, new)
    if source == localPlayer then 
        if data == "char:job" then 
            if new == 4 then 
                printJobTips()
                jobblip = createBlip(1738.6251220703, -1582.8795166016, 14.159929275513, 11)
                setElementData(jobblip, "blip:name", "Etikus Hacker Iroda")
            elseif old == 4 then 
                if isElement(jobblip) then destroyElement(jobblip) end
            end
        end
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    if getElementData(localPlayer, "char:job") == 4 then 
        printJobTips()
        jobblip = createBlip(1738.6251220703, -1582.8795166016, 14.159929275513, 11)
        setElementData(jobblip, "blip:name", "Etikus Hacker Iroda")
    end
end)