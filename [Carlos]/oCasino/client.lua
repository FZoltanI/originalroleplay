function createPeds()
    for k, v in ipairs(casinoPeds) do 
        local ped = createPed(v.skin, v.pos.x, v.pos.y, v.pos.z, v.rot)

        setElementDimension(ped, v.dim)
        setElementInterior(ped, v.int)

        setElementData(ped, "ped:name", v.name)
        setElementData(ped, "ped:prefix", "Casino Coin")

        setElementFrozen(ped, true)
        setElementData(ped, "isCasinoCoinPed", true)
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function() 
    createPeds()
end)

sx, sy = guiGetScreenSize()
myX, myY = 1768, 992

fonts = {
    ["condensed-10"] = font:getFont("condensed", 10),
    ["condensed-13"] = font:getFont("condensed", 13),
    ["condensed-25"] = font:getFont("condensed", 25),

    ["bebasneue-15"] = font:getFont("bebasneue", 15),
}

tooltipDatas = {
    ["title"] = "",
    ["controll-lines"] = {},
    ["other-lines"] = {},
    ["long-descs"] = {},
}

function renderTooltip()
    local height = ((#tooltipDatas["controll-lines"])*sy*0.037) + sy*0.1 + 6/myY*sy + (#tooltipDatas["other-lines"]*sy*0.032)
    for k, v in pairs(tooltipDatas["long-descs"]) do
        height = height + sy*0.02*v.lines
    end
    dxDrawRectangle(sx*0.83, sy*0.01, sx*0.165, height, tocolor(40, 40, 40, 255))
    dxDrawRectangle(sx*0.83+4/myX*sx, sy*0.01+4/myY*sy, sx*0.165-8/myX*sx, sy*0.1-8/myY*sy, tocolor(30, 30, 30, 255))
    dxDrawText(tooltipDatas["title"], sx*0.83+4/myX*sx, sy*0.01+4/myY*sy, sx*0.83+4/myX*sx+sx*0.165-8/myX*sx, sy*0.01+4/myY*sy+sy*0.1-8/myY*sy, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["condensed-25"], "center", "center")

    local newY = sy*0.01+4/myY*sy+sy*0.1-8/myY*sy + 4/myY*sy 
    for k, v in pairs(tooltipDatas["controll-lines"]) do 
        dxDrawRectangle(sx*0.83+4/myX*sx, newY, sx*0.165-8/myX*sx, sy*0.035, tocolor(30, 30, 30, 255))
        dxDrawText(v.title..": "..color.."["..v.key.."]", sx*0.83+4/myX*sx, newY, sx*0.83+4/myX*sx+sx*0.165-8/myX*sx, newY+sy*0.035, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-10"], "center", "center", false, false, false, true)

        newY = newY + sy*0.037
    end

    --newY = newY + 3/myY*sy

    --local newY = sy*0.01+4/myY*sy+sy*0.1-8/myY*sy + 4/myY*sy +sy*0.037*#tooltipDatas["controll-lines"]
    for k, v in pairs(tooltipDatas["other-lines"]) do 
        local alpha = 255 

        if k % 2 == 0 then 
            alpha = 180 
        end
            
        dxDrawRectangle(sx*0.83+4/myX*sx, newY, sx*0.165-8/myX*sx, sy*0.03, tocolor(30, 30, 30, alpha))
        dxDrawText(v.title..": ", sx*0.83+10/myX*sx, newY, sx*0.83+10/myX*sx+sx*0.165-8/myX*sx, newY+sy*0.03, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-10"], "left", "center", false, false, false, true)
        dxDrawText(v.desc, sx*0.83+10/myX*sx, newY, sx*0.83-4/myX*sx+sx*0.165-4/myX*sx, newY+sy*0.03, tocolor(r, g, b, 255), 1/myX*sx, fonts["condensed-10"], "right", "center", false, false, false, true)

        newY = newY + sy*0.032
    end

    for k, v in pairs(tooltipDatas["long-descs"]) do 
        local alpha = 255 

        if k % 2 == 0 then 
            alpha = 180 
        end
            
        dxDrawRectangle(sx*0.83+4/myX*sx, newY, sx*0.165-8/myX*sx, sy*0.02*v.lines, tocolor(30, 30, 30, alpha))
        dxDrawText(color..v.title..": #ffffff"..v.text, sx*0.83+10/myX*sx, newY, sx*0.83+10/myX*sx+sx*0.165-8/myX*sx, newY+sy*0.02*v.lines, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-10"], "left", "center", false, false, false, true)
        --dxDrawText(v.text, sx*0.83+10/myX*sx, newY, sx*0.83-4/myX*sx+sx*0.165-4/myX*sx, newY+sy*0.03, tocolor(r, g, b, 255), 1/myX*sx, fonts["condensed-10"], "right", "center", false, false, false, true)

        newY = newY + sy*0.032
    end

end

local isBetInputActive = false
local inputValue = 0
local alpha = 0
local tick = getTickCount()
local animType = "open"
local open = false
local active = false
local ellenorzes = true

function betBuyPanelRender()

    if getPlayerPing(localPlayer) > 75 then 
        closeCasinoCoinBuy()
    end

    if not core:getNetworkConnection() then 
        closeCasinoCoinBuy()
    end

    if ellenorzes then 
        if core:getDistance(active, localPlayer) > 3 then
            closeCasinoCoinBuy()
            ellenorzes = false 
        end
    end

    if animType == "open" then 
        alpha = interpolateBetween(alpha, 0, 0, 1, 0, 0, (getTickCount() - tick)/300, "Linear")
    else
        alpha = interpolateBetween(alpha, 0, 0, 0, 0, 0, (getTickCount() - tick)/300, "Linear")
    end
    dxDrawRectangle(sx*0.4, sy*0.4, sx*0.2, sy*0.202, tocolor(35, 35, 35, 255*alpha))
    dxDrawRectangle(sx*0.4+3/myX*sx, sy*0.4+3/myY*sy, sx*0.2-6/myX*sx, sy*0.202-6/myY*sy, tocolor(40, 40, 40, 255*alpha))
    --dxDrawRectangle(sx*0.405, sy*0.41, sx*0.1, sy*0.03)
    dxDrawText("Casino Coin Vásárlás", sx*0.435, sy*0.41, sx*0.435+sx*0.1, sy*0.41+sy*0.03, tocolor(255, 255, 255, 220*alpha), 1/myX*sx, fonts["bebasneue-15"], "left", "center")
    dxDrawText("OriginalRoleplay", sx*0.435, sy*0.43, sx*0.435+sx*0.1, sy*0.43+sy*0.03, tocolor(255, 255, 255, 100*alpha), 0.8/myX*sx, fonts["condensed-13"], "left", "center")

    dxDrawText(color..(getElementData(localPlayer, "char:cc") or 0).."#ffffffCC", sx*0.46, sy*0.43, sx*0.46+sx*0.132, sy*0.43+sy*0.03, tocolor(255, 255, 255, 100*alpha), 0.8/myX*sx, fonts["condensed-13"], "right", "center", false, false, false, true)

    dxDrawImage(sx*0.404, sy*0.407, 50/myX*sx, 50/myY*sy, "files/logo.png", 0, 0, 0, tocolor(r, g, b, 255*alpha))

    if core:isInSlot(sx*0.405, sy*0.46, sx*0.19, sy*0.04) then 
        dxDrawRectangle(sx*0.405, sy*0.46, sx*0.19, sy*0.04, tocolor(30, 30, 30, 200*alpha))

        if tonumber(inputValue) == 0 then 
            dxDrawText("Összeg", sx*0.405, sy*0.46, sx*0.405+sx*0.19, sy*0.46+sy*0.04, tocolor(255, 255, 255, 220*alpha), 1/myX*sx, fonts["condensed-10"], "center", "center")
        else
            dxDrawText(inputValue, sx*0.405, sy*0.46, sx*0.405+sx*0.19, sy*0.46+sy*0.04, tocolor(r, g, b, 255*alpha), 1/myX*sx, fonts["condensed-10"], "center", "center")
        end
    else
        dxDrawRectangle(sx*0.405, sy*0.46, sx*0.19, sy*0.04, tocolor(30, 30, 30, 150*alpha))

        if tonumber(inputValue) == 0 then 
            dxDrawText("Összeg", sx*0.405, sy*0.46, sx*0.405+sx*0.19, sy*0.46+sy*0.04, tocolor(255, 255, 255, 100*alpha), 1/myX*sx, fonts["condensed-10"], "center", "center")
        else
            dxDrawText(inputValue, sx*0.405, sy*0.46, sx*0.405+sx*0.19, sy*0.46+sy*0.04, tocolor(r, g, b, 100*alpha), 1/myX*sx, fonts["condensed-10"], "center", "center")
        end
    end

    if core:isInSlot(sx*0.405, sy*0.503, sx*0.19, sy*0.03) then 
        dxDrawRectangle(sx*0.405, sy*0.503, sx*0.19, sy*0.03, tocolor(30, 30, 30, 255*alpha))
        dxDrawText("Átváltás ($ > CC)", sx*0.405, sy*0.503, sx*0.405+sx*0.19, sy*0.503+sy*0.03, tocolor(255, 255, 255, 220*alpha), 1/myX*sx, fonts["condensed-10"], "center", "center")
    else
        dxDrawRectangle(sx*0.405, sy*0.503, sx*0.19, sy*0.03, tocolor(30, 30, 30, 150*alpha))
        dxDrawText("Átváltás ($ > CC)", sx*0.405, sy*0.503, sx*0.405+sx*0.19, sy*0.503+sy*0.03, tocolor(255, 255, 255, 150*alpha), 1/myX*sx, fonts["condensed-10"], "center", "center")
    end

    if core:isInSlot(sx*0.405, sy*0.536, sx*0.19, sy*0.03) then 
        dxDrawRectangle(sx*0.405, sy*0.536, sx*0.19, sy*0.03, tocolor(30, 30, 30, 255*alpha))
        dxDrawText("Átváltás (CC > $)", sx*0.405, sy*0.536, sx*0.405+sx*0.19, sy*0.536+sy*0.03, tocolor(255, 255, 255, 220*alpha), 1/myX*sx, fonts["condensed-10"], "center", "center")
    else
        dxDrawRectangle(sx*0.405, sy*0.536, sx*0.19, sy*0.03, tocolor(30, 30, 30, 150*alpha))
        dxDrawText("Átváltás (CC > $)", sx*0.405, sy*0.536, sx*0.405+sx*0.19, sy*0.536+sy*0.03, tocolor(255, 255, 255, 150*alpha), 1/myX*sx, fonts["condensed-10"], "center", "center")
    end

    if core:isInSlot(sx*0.405, sy*0.569, sx*0.19, sy*0.024) then 
        dxDrawRectangle(sx*0.405, sy*0.569, sx*0.19, sy*0.024, tocolor(30, 30, 30, 255*alpha))
        dxDrawText("Bezárás", sx*0.405, sy*0.569, sx*0.405+sx*0.19, sy*0.569+sy*0.024, tocolor(245, 66, 66, 220*alpha), 1/myX*sx, fonts["condensed-10"], "center", "center")
    else
        dxDrawRectangle(sx*0.405, sy*0.569, sx*0.19, sy*0.024, tocolor(30, 30, 30, 150*alpha))
        dxDrawText("Bezárás", sx*0.405, sy*0.569, sx*0.405+sx*0.19, sy*0.569+sy*0.024, tocolor(245, 66, 66, 150*alpha), 1/myX*sx, fonts["condensed-10"], "center", "center")
    end
end

function betBuyPanelKey(key, state)
    if state then 
        if key == "mouse1" then
            if core:isInSlot(sx*0.405, sy*0.46, sx*0.19, sy*0.04) then 
                isBetInputActive = true 
            else
                isBetInputActive = false
            end

            if core:isInSlot(sx*0.405, sy*0.503, sx*0.19, sy*0.03) then
                if tonumber(inputValue) > 1 then 
                    if getElementData(localPlayer, "char:money") >= tonumber(inputValue) then 
                        triggerServerEvent("casino > changeMoneyToCasinoCoin", resourceRoot, tonumber(inputValue))
                        infobox:outputInfoBox("Sikeresen átváltottad a pénzed!", "success")
                        outputChatBox(core:getServerPrefix("green-dark", "CasinoCoin", 2).."Sikeresen átváltottad a pénzed! "..color.."("..inputValue.."$ > "..math.floor(inputValue/3).."cc)", 255, 255, 255, true)
                        inputValue = 0
                    else
                        infobox:outputInfoBox("Nincs elegendő pénzed! ("..inputValue.."$)", "error")
                        outputChatBox(core:getServerPrefix("red-dark", "CasinoCoin", 2).."Nincs elegendő pénzed a vásárláshoz! "..color.."("..inputValue.."$)", 255, 255, 255, true)
                        inputValue = 0
                    end
                end
            end 

            if core:isInSlot(sx*0.405, sy*0.536, sx*0.19, sy*0.03) then 
                if tonumber(inputValue) > 0 then 
                    if getElementData(localPlayer, "char:cc") >= tonumber(inputValue) then 
                        triggerServerEvent("casino > changeCasinoCoinToMoney", resourceRoot, tonumber(inputValue))
                        infobox:outputInfoBox("Sikeresen átváltottad a CasinoCoinod!", "success")
                        outputChatBox(core:getServerPrefix("green-dark", "CasinoCoin", 2).."Sikeresen átváltottad a CasinoCoinod! "..color.."("..inputValue.."cc > "..math.floor(inputValue*2).."$)", 255, 255, 255, true)
                        outputChatBox(core:getServerPrefix("green-dark", "CasinoCoin", 2).."Adó: "..color..math.floor(inputValue*2*0.1).."$#ffffff.", 255, 255, 255, true)
                        inputValue = 0
                    else
                        infobox:outputInfoBox("Nincs elegendő CasinoCoinod! ("..inputValue.."cc)", "error")
                        outputChatBox(core:getServerPrefix("red-dark", "CasinoCoin", 2).."Nincs elegendő CasinoCoinod a vásárláshoz! "..color.."("..inputValue.."cc)", 255, 255, 255, true)
                        inputValue = 0
                    end
                end
            end

            if core:isInSlot(sx*0.405, sy*0.569, sx*0.19, sy*0.024) then 
                closeCasinoCoinBuy()
            end
        end

        if isBetInputActive then 
            key = key:gsub("num_", "")
            if tonumber(key) then 
                if string.len(tostring(inputValue)) < 25 then 
                    if inputValue == 0 then 
                        inputValue = key
                    else
                        inputValue = inputValue ..key
                    end
                end
            end

            if key == "backspace" then 
                inputValue = tostring(inputValue):gsub("[^\128-\191][\128-\191]*$", "")

                if inputValue == "" then 
                    inputValue = 0 
                end
            end
        end
    end
end

function openCasinoCoinBuy()
    open = true
    addEventHandler("onClientKey", root, betBuyPanelKey)
    addEventHandler("onClientRender", root, betBuyPanelRender)
    tick = getTickCount()
    animType = "open"
end

function closeCasinoCoinBuy()
    removeEventHandler("onClientKey", root, betBuyPanelKey)

    tick = getTickCount()
    animType = "close"
    active = false 
    ellenorzes = false
    isBetInputActive = false

    setTimer(function() 
        removeEventHandler("onClientRender", root, betBuyPanelRender)
        open = false 
    end, 300, 1)
end

addEventHandler("onClientClick", root, function(key, state, _, _, _, _, _, element)
    if key == "right" then 
        if state == "up" then 
            if element then 
                if getElementData(element, "isCasinoCoinPed") then 
                    if core:getDistance(element, localPlayer) < 3 then
                        if not open then 
                            openCasinoCoinBuy()
                            ellenorzes = true
                            active = element
                        end
                    end
                end
            end
        end
    end
end)