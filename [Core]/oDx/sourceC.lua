local screenX, screenY = guiGetScreenSize()
local width, height = 350, 150
local alertX, alertY = screenX/2 - width/2, screenY/2 - height/2
local isAlertBoxActive = false

function dxDrawCorrectText(text, posX, posY, width, height, color, fontScale, font, alignX, alignY, clip, wBrake, postGui, colorCode)

    local fontWIDTH = dxGetTextWidth(text, fontScale, font)
	local fontMINUS = 0

	if fontWIDTH > width then
		fontMINUS = ((fontWIDTH / width) - 1 ) * 1.05
	end

    dxDrawText(text, posX, posY, posX + width, posY + height, color, fontScale - fontMINUS, font, alignX, alignY, clip, wBrake, postGui, colorCode)
end

function reMap(value, low1, high1, low2, high2)
	return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

responsiveMultiplier = math.min(1, reMap(screenX, 1024, 1920, 0.75, 1))

function getResponsiveMultiplier()
    return responsiveMultiplier
end

function resp(value)
	return value * responsiveMultiplier
end

function respc(value)
	return math.ceil(value * responsiveMultiplier)
end

local text = [[
Biztos meg akarod változtatni a járműved színét?
]]



local font = exports["oFont"]:getFont("condensed",resp(12))

local alertSettings = {
    alertMessage = "Alert Message Text",
    buttons = {
        {"N", getTickCount(), 0, "Text", "eventName"},
        {"N", getTickCount(), 0, "Text2"},
    },
}

local alphaAnim = "N"
local alphaTick = getTickCount()

myX, myY = 1600, 900
function alertRender()
    if alphaAnim == "Y" then
        alpha = interpolateBetween(0,0,0,1,0,0,(getTickCount() - alphaTick)/300,"Linear")
    else 
        alpha = interpolateBetween(1,0,0,0,0,0,(getTickCount() - alphaTick)/300,"Linear")
        --outputChatBox(alpha)
        if alpha <= 0 then 
            removeEventHandler("onClientRender", getRootElement(), alertRender)
            removeEventHandler("onClientClick", getRootElement(), alertClick)
            removeEventHandler("onClientKey", getRootElement(), alertKey)
            isAlertBoxActive = true
            alertSettings = {}
            return
        end
    end
    exports["oCore"]:drawWindow(alertX, alertY, width, height, "Figyelem", alpha)
    dxDrawCorrectText(alertSettings.alertMessage, alertX, alertY+30, width, height, tocolor(255,255,255,255*alpha),1,font,"center","top", false,true,false,false)
    local startX = alertX + 10
    for k=1,#alertSettings["buttons"] do 
        local data = alertSettings["buttons"][k]
        if data then
            colorR, colorG, colorB = 233, 118, 25
            if k == 2 then 
                colorR, colorG, colorB = 224, 54, 31
            end
            if exports["oCore"]:isInSlot(startX,alertY+height - 35, 120, 30) then 
                if data[1] == "N" then 
                    data[1] = "hover"
                    data[2] = getTickCount()
                end
            else 
                if data[1] == "hover" then 
                    data[1] = "N"
                    data[2] = getTickCount()
                end
            end

            if data[1] == "N" then 
                data[3] = interpolateBetween(data[3], 0, 0, 0, 0, 0,(getTickCount()-data[2])/500, "InOutQuad")
            else 
                data[3] = interpolateBetween(data[3], 0, 0, 1.5, 0, 0,(getTickCount()-data[2])/500, "InOutQuad")
            end
            exports["oCore"]:dxDrawButton(startX - (2/myX*screenX*data[3]),alertY+height - 40 - (2/myX*screenX*data[3]), 120+ (4/myX*screenX*data[3]), 30+ (4/myX*screenX*data[3]), colorR, colorG, colorB, 150*alpha, data[4], tocolor(255,255,255,255*alpha),0.85,font, true, tocolor(0,0,0,255*alpha))
            startX = startX + width - 140
        end
    end
end

function checkAlertBox()
    return isAlertBoxActive
end

function alertClick(button, state)
    if button == "left" and state == "down" and checkAlertBox() then 
        local startX = alertX + 10
        for k=1,#alertSettings["buttons"] do 
            local data = alertSettings["buttons"][k]
            if data then
                if exports["oCore"]:isInSlot(startX,alertY+height - 35, 120, 30) then 
                    if data[5] then 
                        triggerEvent(data[5], localPlayer)
                    else
                        closeAlert()
                    end
                end
                startX = startX + width - 140
            end
        end
    end
end

function alertKey(button, state)
    if button == "enter" and state then 
        if checkAlertBox() then 
            for k=1,#alertSettings["buttons"] do 
                local data = alertSettings["buttons"][k]
                if data then
                    if data[5] then 
                        triggerEvent(data[5], localPlayer)
                    else
                        closeAlert()
                    end
                end
            end
        end
    elseif button == "backspace" and state then 
        closeAlert()
    end
end

function addAlert(alertText, buttonName1, buttonName2, eventName1, eventName2)
    if not alertText or buttonName1 or buttonName2 or eventName1 then 
        alertSettings = {}
        alertSettings = {
            alertMessage = alertText,
            buttons = {
                {"N", getTickCount(), 0, buttonName1, eventName1},
                {"N", getTickCount(), 0, buttonName2, eventName2},
            },
        }
        isAlertBoxActive = true
        alphaTick = getTickCount()
        alphaAnim = "Y"
        addEventHandler("onClientRender", getRootElement(), alertRender)
        addEventHandler("onClientClick", getRootElement(), alertClick)
        addEventHandler("onClientKey", getRootElement(), alertKey)
    end
end


function closeAlert()
    alphaTick = getTickCount()
    alphaAnim = "N"
end



--[[setCursorAlpha(0)

addEventHandler("onClientRender",getRootElement(), function()
    if isCursorShowing() then
        if not getElementData(localPlayer, "bigmapIsVisible") then
            local cx,cy = getCursorPosition()
            local posX,posY = screenX*cx-15, screenY*cy
            dxDrawImage(posX,posY, 32,16, "assets/cursor/normal.png", 0, 0, 0, tocolor(255,255,255,255), true)
        end
    end
end)]]