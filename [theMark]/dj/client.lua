--Script by theMark
local sx, sy = guiGetScreenSize()
local zoom = math.min(1,0.75 + (sx - 1024) * (1 - 0.75) / (1600 - 1024))
function res(value) return value * zoom end
function resFont(value) return math.floor(res(value)) end
setDevelopmentMode(true)
local col = createColSphere(-2659.87890625, 1407.3564453125, 906.2734375, 15) -- EZT ODA HELYEZD ÁT AHOL MAJD LESZ A DISZKÓ HELYE, HOGY CSAK OTT LEGYEN HALLHATÓ!!
setElementDimension(col, 1764)
setElementInterior(col, 3)
local state = true

local webBrowser = createBrowser(sx, sy, false, false)



addEventHandler("onClientColShapeHit", col, function(hitelement, md)
    if hitelement == localPlayer and md then
        setBrowserVolume(webBrowser, 1)
    end
end)

addEventHandler("onClientColShapeLeave", col, function(hitelement, md)
    if hitelement == localPlayer and md then
        setBrowserVolume(webBrowser, 0)
    end
end)

local dj = createObject(1957, -2672.0107421875, 1410.4462890625, 907.5703125) -- KEVERŐPULT OBJECT!
setElementDimension(dj, 262)
setElementInterior(dj, 3)
local x, y, z = getElementPosition(dj)
local djCol = createColSphere(x, y, z, 1)
setElementDimension(djCol, 262)
setElementInterior(djCol, 3)
addEventHandler("onClientColShapeHit", djCol, function(hitelement, md)
    if hitelement == localPlayer and md then
        removeEventHandler("onClientRender", root, djPanel)
        addEventHandler("onClientRender", root, djPanel)
        gui = guiCreateEdit(sx / 2 - res(200) / 2, sy / 2 - res(40) / 2, res(200), res(40), "YT link", false)
        show = true
    end
end)

addEventHandler("onClientColShapeLeave", djCol, function(hitelement, md)
    if hitelement == localPlayer and md then
        removeEventHandler("onClientRender", root, djPanel)
        show = false
        destroyElement(gui)
    end
end)

function djPanel()
    dxDrawRectangle(sx / 2 - res(200) / 2, sy / 2 + res(55) / 2, res(200), res(35), tocolor(0, 0, 0, 255))
    dxDrawText("Lejátszás!", sx / 2 - res(200) / 2, sy / 2 + res(55) / 2, (sx / 2 - res(200) / 2 + res(200)), (sy / 2 + res(55) / 2 + res(35)), tocolor(255, 255, 255), 1.3, "sans", "center", "center")
end

setElementCollisionsEnabled(dj, false)
setElementData(dj, "mixPult", true)
function webBrowserRender()
	dxDrawImage(0, 0, 1, 1, webBrowser, 0, 0, 0, tocolor(255,255,255,255), true)
end

addEvent("playVid", true)
addEventHandler("playVid", root, function(url)
    -- addEventHandler("onClientBrowserCreated", webBrowser, function()
        if getElementDimension(localPlayer) == 262 and getElementInterior(localPlayer) == 3 then
            loadBrowserURL(webBrowser, url  .. "?autoplay=1&showinfo=0&rel=0&controls=0&disablekb=1")
            -- outputChatBox("Sikeres lejátszás!")
        end
    -- end)
end)

--[[startRadio = function(who)
    webBrowser = createBrowser(1, 1, false, false)
    addEventHandler("onClientBrowserCreated", webBrowser, function()
        loadBrowserURL(source, "https://youtube.com"))
    end
end]]

addEventHandler("onClientClick", root, function(button, state)
    if button == "left" and state == "down" and show then
        if isInSlot(sx / 2 - res(200) / 2, sy / 2 + res(55) / 2, res(200), res(35)) then
            triggerServerEvent("playSoundVid", localPlayer, localPlayer, guiGetText(gui))
        end
    end
end)

--UTILS
function getMousePosition()
    if isCursorShowing() then
        local cX, cY = getCursorPosition();
        return sx*cX, sy*cY;
    end
    return false;
end


function checkNumbers(numbers)
    if type(numbers) == "table" then
        for k, v in pairs(numbers) do
            if not tonumber(v) then
                return false;
            end
        end
        return true;
    end
    return false;
end

function isInSlot(x, y, w, h)
    if isCursorShowing() then
        local cX, cY = getMousePosition();
        if checkNumbers({x, y, w, h, cX, cY}) then
            if cX >= x and cY >= y and cX <= x+w and cY <= y+h then
                return true;
            end
        end
    end
    return false;
end

function isInBox(dX, dY, dW, dH, eX, eY)
    if checkNumbers({dX, dY, dW, dH, eX, eY}) then
        if eX >= dX and eY >= dY and eX <= dX+dW and eY <= dY+dH then
            return true;
        end
    end
    return false;
end