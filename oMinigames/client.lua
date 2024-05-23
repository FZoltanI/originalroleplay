local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900

local core = exports.oCore 
local color, r, g, b = core:getServerColor()

local fonts = {
    ["bebasneue-25"] = exports.oFont:getFont("bebasneue", 25),
}



local activeMinigame

local avaibleCharacters = {"A", "B", "C", "D", "E", "G", "H", "I", "Q", "F", "R", "T", "Z", 'Y'}

local minigameValues = {}

local lastRectangle = {0.5, 0.65, 0.03, 0.05}
lastRectangle[1] = math.random(440, 530)/1000
lastRectangle[2] = math.random(645, 785)/1000
lastRectangle[3] = math.random(20, 30)/1000
lastRectangle[4] = math.random(20, 30)/1000

local clickPlus = 0.02
local timeMinus = 0.0005

local oldX, oldY, oldW, oldH = 0, 0, 0, 0
local oldvalue = 0

local tick = getTickCount()
local tick2 = getTickCount()

local minigameMove = -0.2
local pointerPos = sx*0.5 - sx*0.01/2
local successPercent = 0

function renderMinigame()
    type, count, start, maxtime = activeMinigame[1], activeMinigame[2], activeMinigame[3], activeMinigame[4]

    if type == 1 then 
        dxDrawRectangle(sx/2-70/myX*sx/2, sy*0.77, 70/myX*sx, 70/myY*sy, tocolor(30, 30, 30, 255))

        dxDrawRectangle(sx/2-70/myX*sx/2, sy*0.77+70/myY*sy, 70/myX*sx, -70/myY*sy*minigameValues[2], tocolor(r, g, b, 100))

        dxDrawText(minigameValues[1], sx/2-70/myX*sx/2, sy*0.77, sx/2-70/myX*sx/2+70/myX*sx, sy*0.77+70/myY*sy, tocolor(r, g, b, 255), 1/myX*sx, fonts["bebasneue-25"], "center", "center")

        if getKeyState(string.lower(minigameValues[1])) then 
            if minigameValues[2] < 1 then 
                minigameValues[2] = minigameValues[2] + 0.015
            else 
                minigameValues[3] = minigameValues[3] + 1
                minigameValues[4] = getTickCount()

                if minigameValues[3] == count then 
                    endMinigame("successful")
                end

                minigameValues[2] = 0 
                minigameValues[1] = avaibleCharacters[math.random(#avaibleCharacters)]
            end
        else
            if minigameValues[2] > 0 then 
                minigameValues[2] = minigameValues[2] - 0.015
            end
        end

        core:dxDrawOutLine(sx/2-70/myX*sx/2, sy*0.77, 70/myX*sx, 70/myY*sy, tocolor(35, 35, 35, 255), 2)

        dxDrawRectangle(sx*0.5-200/myX*sx/2, sy*0.858, 200/myX*sx, 10/myY*sy, tocolor(35, 35, 35, 255))
        dxDrawRectangle(sx*0.5-200/myX*sx/2+1.5/myX*sx, sy*0.858+2/myY*sy, 200/myX*sx-4/myX*sx, 10/myY*sy-4/myY*sy, tocolor(40, 40, 40, 255))

        local lineWidth = 0 
        
        if minigameValues[3] >= 1 then 
            lineWidth = interpolateBetween((minigameValues[3]-1)/count, 0, 0, minigameValues[3]/count, 0, 0, (getTickCount()-minigameValues[4])/300, "InOutQuad")
        end

        dxDrawRectangle(sx*0.5-200/myX*sx/2+1.5/myX*sx, sy*0.858+2/myY*sy, (200/myX*sx-4/myX*sx)*lineWidth, 10/myY*sy-4/myY*sy, tocolor(r, g, b, 255))

        local time = interpolateBetween(1, 0, 0, 0, 0, 0, (getTickCount()-start)/maxtime, "Linear")

        dxDrawRectangle(sx*0.5-200/myX*sx/2, sy*0.872, 200/myX*sx, 10/myY*sy, tocolor(35, 35, 35, 255))
        dxDrawRectangle(sx*0.5-200/myX*sx/2+1.5/myX*sx, sy*0.872+2/myY*sy, 200/myX*sx-4/myX*sx, 10/myY*sy-4/myY*sy, tocolor(40, 40, 40, 255))
        dxDrawRectangle(sx*0.5-200/myX*sx/2+1.5/myX*sx, sy*0.872+2/myY*sy, (200/myX*sx-4/myX*sx)*time, 10/myY*sy-4/myY*sy, tocolor(224, 70, 70, 255))

        if time <= 0.001 then 
            endMinigame("unseccessful")
        end

    elseif type == 2 then 
        local renderX, renderY, renderW, renderH
        if  oldX > 0 and oldX > 0 and oldY > 0 and oldW > 0 and oldH > 0 then 
            renderX, renderY = interpolateBetween(oldX, oldY, 0, lastRectangle[1], lastRectangle[2], 0, (getTickCount() - minigameValues[4])/250, "Linear")
            renderW, renderH = interpolateBetween(oldW, oldH, 0, lastRectangle[3], lastRectangle[4], 0, (getTickCount() - minigameValues[4])/250, "Linear")
        else
            renderX, renderY, renderW, renderH = lastRectangle[1], lastRectangle[2], lastRectangle[3], lastRectangle[4]
        end
    
        showCursor(true)
    
        local time = interpolateBetween(1, 0, 0, 0, 0, 0, (getTickCount()-start)/maxtime, "Linear")

        if time > 0 then 
            time = time - timeMinus
        else
            endMinigame("unseccessful")
        end
    
        dxDrawRectangle(sx*0.5-200/myX*sx/2, sy*0.64, 200/myX*sx, 180/myY*sy, tocolor(35, 35, 35, 255))
        dxDrawRectangle(sx*0.5-200/myX*sx/2+2/myX*sx, sy*0.64+2/myY*sy, 200/myX*sx-4/myX*sx, 180/myY*sy-4/myY*sy, tocolor(40, 40, 40, 255))
    
        dxDrawRectangle(sx*0.5-200/myX*sx/2, sy*0.845, 200/myX*sx, 10/myY*sy, tocolor(35, 35, 35, 255))
        dxDrawRectangle(sx*0.5-200/myX*sx/2+1.5/myX*sx, sy*0.845+2/myY*sy, 200/myX*sx-4/myX*sx, 10/myY*sy-4/myY*sy, tocolor(40, 40, 40, 255))
    
        local lineWidth = 0 
        
        if (minigameValues[3] or 0) >= 1 then 
            lineWidth = interpolateBetween((minigameValues[3]-1)/count, 0, 0, minigameValues[3]/count, 0, 0, (getTickCount()-minigameValues[4])/300, "InOutQuad")
        end

        dxDrawRectangle(sx*0.5-200/myX*sx/2+1.5/myX*sx, sy*0.845+2/myY*sy, (200/myX*sx-4/myX*sx)*lineWidth, 10/myY*sy-4/myY*sy, tocolor(r, g, b, 200))
    
        dxDrawRectangle(sx*0.5-200/myX*sx/2, sy*0.858, 200/myX*sx, 10/myY*sy, tocolor(35, 35, 35, 255))
        dxDrawRectangle(sx*0.5-200/myX*sx/2+1.5/myX*sx, sy*0.858+2/myY*sy, 200/myX*sx-4/myX*sx, 10/myY*sy-4/myY*sy, tocolor(40, 40, 40, 255))
        dxDrawRectangle(sx*0.5-200/myX*sx/2+1.5/myX*sx, sy*0.858+2/myY*sy, (200/myX*sx-4/myX*sx)*time, 10/myY*sy-4/myY*sy, tocolor(224, 70, 70, 200))
    
        dxDrawRectangle(sx*renderX, sy*renderY, sx*renderW, sy*renderH, tocolor(33, 33, 33, 255))
    elseif type == 3 then 
        dxDrawRectangle(sx*0.4, sy*0.8, sx*0.2, sy*0.02, tocolor(35, 35, 35, 100))
        dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.8 + 2/myY*sy, sx*0.2 - 4/myX*sx, sy*0.02 - 4/myY*sy, tocolor(35, 35, 35, 255))

        dxDrawImage(sx*0.4 + 2/myX*sx, sy*0.8 + 2/myY*sy, sx*0.035, sy*0.02 - 4/myY*sy, "files/gradient.png", 0, 0, 0, tocolor(242, 51, 51, 255))
        dxDrawImage(sx*0.4 + 2/myX*sx + sx*0.2 - 4/myX*sx - sx*0.035, sy*0.8 + 2/myY*sy, sx*0.035, sy*0.02 - 4/myY*sy, "files/gradient.png", 180, 0, 0, tocolor(242, 51, 51, 255))

        dxDrawRectangle(pointerPos, sy*0.8 - 1/myY*sy, sx*0.001, sy*0.02, tocolor(255, 255, 255, 200))
        dxDrawRectangle(pointerPos - 2/myX*sx, sy*0.8 - 3/myY*sy, sx*0.001 + 4/myX*sx, sy*0.02 + 4/myY*sy, tocolor(255, 255, 255, 50))

        dxDrawRectangle(sx*0.4, sy*0.822, sx*0.2, sy*0.01, tocolor(35, 35, 35, 100))
        dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.822 + 2/myY*sy, sx*0.2 - 4/myX*sx, sy*0.01 - 4/myY*sy, tocolor(35, 35, 35, 255))

        if successPercent >= 100 then
            dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.822 + 2/myY*sy, (sx*0.2 - 4/myX*sx) * successPercent / 100, sy*0.01 - 4/myY*sy, tocolor(r, g, b, 200))
        else
            dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.822 + 2/myY*sy, (sx*0.2 - 4/myX*sx) * successPercent / 100, sy*0.01 - 4/myY*sy, tocolor(242, 51, 51, 200))
        end

        dxDrawRectangle(sx*0.4 + 2/myX*sx + (sx*0.2 - 4/myX*sx) * successPercent / 100, sy*0.822 + 2/myY*sy, sx*0.001, sy*0.02, tocolor(255, 255, 255, 200))
        dxDrawRectangle((sx*0.4 + 2/myX*sx + (sx*0.2 - 4/myX*sx) * successPercent / 100) - 2/myX*sx, sy*0.822, sx*0.001 + 4/myX*sx, sy*0.02 + 4/myY*sy, tocolor(255, 255, 255, 50))

        dxDrawText(math.floor(successPercent).."%", (sx*0.4 + 2/myX*sx + (sx*0.2 - 4/myX*sx) * successPercent / 100), sy*0.822, -sx*0.002, sy*0.02 + 4/myY*sy, tocolor(255, 255, 255, 255), 1, exports.oFont:getFont("condensed", 10/myX*sx), "right", "bottom")

        if successPercent < 100 then
            successPercent = successPercent + activeMinigame[4]
        else
            endMinigame("successful")
        end

        if getKeyState("arrow_l") or getKeyState("a") then 
            minigameMove = minigameMove - math.random(3, 10) / 100
        elseif getKeyState("arrow_r") or getKeyState("d") then 
            minigameMove = minigameMove + math.random(3, 10) / 100
        else
            if minigameMove > 0 and minigameMove < 1.5 then
                minigameMove = 1.5 
            elseif minigameMove < 0 and minigameMove > -1.5 then 
                minigameMove = -1.5 
            end
        end

        pointerPos = pointerPos + minigameMove/myX*sx

        if pointerPos < sx*0.41 or pointerPos > sx*0.59 then 
            endMinigame("unseccessful")
        end
    end
end

function minigame2Keys(key, state)
    if state and key == "mouse1" then 
        if core:isInSlot(sx*lastRectangle[1], sy*lastRectangle[2], sx*lastRectangle[3], sy*lastRectangle[4]) then 
            oldvalue = (minigameValues[3] or 0)

            minigameValues[3] = (minigameValues[3] or 0) + 1
            minigameValues[4] = getTickCount()

            oldX, oldY, oldW, oldH = lastRectangle[1], lastRectangle[2], lastRectangle[3], lastRectangle[4]

            lastRectangle[1] = math.random(4400, 5300)/10000
            lastRectangle[2] = math.random(6450, 7850)/10000
            lastRectangle[3] = math.random(200, 300)/10000
            lastRectangle[4] = math.random(200, 300)/10000

            if minigameValues[3] >= count then 
                endMinigame("successful")
            end
        end
    end
end

function createMinigame(type, successCount, time, successEvent, unsuccessEvent)
    if activeMinigame then return false end
    activeMinigame = {type, successCount, getTickCount(), time, successEvent, unsuccessEvent}

    if type == 1 then 
        minigameValues = {avaibleCharacters[math.random(#avaibleCharacters)], 0, 0, getTickCount()}
        addEventHandler("onClientKey", root, cancelKeys)

        outputChatBox(core:getServerPrefix("server", "Minigame", 2).."Tartsd lenyomva a képernyő közepén látható billentyűt.", 255, 255, 255, true)
    elseif type == 2 then 
        minigameValues = {"", 0, 0, getTickCount()}

        outputChatBox(core:getServerPrefix("server", "Minigame", 2).."Kattinst a szürke négyzetekre.", 255, 255, 255, true)
        addEventHandler("onClientKey", root, minigame2Keys)
    elseif type == 3 then 
        local values = {-0.3, -0.25, -0.2, -0.1, 0.1, 0.2, 0.25, 0.3}
        pointerPos = sx*0.5 - sx*0.01/2
        minigameMove = values[math.random(#values)]
        successPercent = 0
        minigameInProgress = true    

        if not activeMinigame[4] then 
            activeMinigame[4] = 0.05
        end
    end

    addEventHandler("onClientRender", root, renderMinigame)
end

function endMinigame(type)
    removeEventHandler("onClientRender", root, renderMinigame)

    if activeMinigame[1] == 1 then 
        removeEventHandler("onClientKey", root, cancelKeys)
    elseif activeMinigame[1] == 2 then 
        showCursor(false)
        removeEventHandler("onClientKey", root, minigame2Keys)
    end

    if type == "successful" then 
        triggerEvent(activeMinigame[5], root)
    elseif type == "unseccessful" then 
        triggerEvent(activeMinigame[6], root)
    end

    activeMinigame = false
end

function cancelKeys()
    cancelEvent()
end

