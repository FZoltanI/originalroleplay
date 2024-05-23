local sx, sy = guiGetScreenSize()
local myX, myY = 1768, 992

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oFont" or getResourceName(res) == "oBank" or getResourceName(res) == "oInfobox" or getResourceName(res) == "oChat" then  
        core = exports.oCore
        font = exports.oFont
        infobox = exports.oInfobox
        chat = exports.oChat
        color, r, g, b = core:getServerColor()
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    triggerServerEvent("bank > getBankDatas", resourceRoot)
end)

addEventHandler("onClientElementDataChange", root, function(data, old, new)
    if source == localPlayer then
        if data == "user:loggedin" and new then 
            triggerServerEvent("bank > getBankDatas", resourceRoot)
        end
    end
end)

local fonts = {
    ["condensed-12"] = font:getFont("condensed", 12),
    ["condensed-15"] = font:getFont("condensed", 15),
    ["condensed-17"] = font:getFont("condensed", 17),
    ["bebasneue-12"] = font:getFont("bebasneue", 12),
    ["bebasneue-15"] = font:getFont("bebasneue", 15),
}

local selectedMenu = 1

local bankAccounts = {}
local bankLogs = {}

local selectedAccount = 0

local delState = 0

addEvent("bank > updateBankDatas > client", true)
addEventHandler("bank > updateBankDatas > client", root, function(accounts, logs)
    bankAccounts = accounts 
    bankLogs = logs
    createBankPanelDatas()
end)

local bankDatas = {
    ["accounts"] = {},
    ["transactions"] = {},
    ["transfers"] = {},
}

function createBankPanelDatas()
    bankDatas["accounts"] = {}
    for k, v in pairs(bankAccounts) do 
        if v then 
            if v[2] == getElementData(localPlayer, "char:id") then 
                if v[4] == 1 then 
                    table.insert(bankDatas["accounts"], {k, true, v[3], v[2], v[1], v[5]})
                else
                    table.insert(bankDatas["accounts"], {k, false, v[3], v[2], v[1], v[5]})
                end
            end
        end
        --print(k)
    end
end

function countInterest()
    local all = 0
    for k, v in ipairs(bankDatas["accounts"]) do 
        local interest = math.floor(v[3]*0.005)
        --outputChatBox(toJSON(v))
        triggerServerEvent("bank > setAccountMoney", resourceRoot, v[1], v[3] + interest)
        all = all + interest
    end

    return all
end

function getPlayerAllBankMoney()
    local allmoney = 0
    for k, v in ipairs(bankDatas["accounts"]) do 
        allmoney = allmoney + v[3]
    end

    return allmoney
end

setTimer(function()
    setElementData(localPlayer, "char:allBankMoney", getPlayerAllBankMoney())
end, 1000, 0)

local bankDatasPointer = 0
local transactionsPointer = 0
local transferPointer = 0

local alpha = 0

local pintext = ""

local utalasShowing = false
local transferTo = {"", "", "", ""}

local panelType = 1
local atmState = 1

local activePed = false
local animState = "open"
local tick = getTickCount()

local selectedATMSerial = ""

function panelRender()

    if getPlayerPing(localPlayer) > 125 then 
        closePanel()
    end

    if not core:getNetworkConnection() then 
        closePanel()
    end

    if animState == "open" then 
        alpha = interpolateBetween(alpha, 0, 0, 1, 0, 0, (getTickCount()-tick)/250, "Linear")
    elseif animState == "close" then 
        alpha = interpolateBetween(alpha, 0, 0, 0, 0, 0, (getTickCount()-tick)/250, "Linear")
    end

    if activePed then 
        if core:getDistance(localPlayer, activePed) > 4 then 
            closePanel()
        end
    end

    if panelType == 1 then 
        --core:drawWindow(sx*0.25, sy*0.25, sx*0.5, sy*0.5, "OriginalRoleplay - Bank", alpha)
        dxDrawRectangle(sx*0.3, sy*0.3, sx*0.4, sy*0.4, tocolor(30, 30, 30, 150*alpha))
        dxDrawRectangle(sx*0.3+2/myX*sx, sy*0.3+2/myY*sy, sx*0.4-4/myX*sx, sy*0.4-4/myY*sy, tocolor(35, 35, 35, 255*alpha))

        dxDrawRectangle(sx*0.3+4/myX*sx, sy*0.3+4/myY*sy, sx*0.1, sy*0.084, tocolor(32, 32, 32, 255*alpha))

        local startY = sy*0.3+6/myY*sy 
        for i = 1, 3 do
            local v = points[i] 

            if v then 
                local color = tocolor(40, 40, 40, 255*alpha)
                local color2 = tocolor(r, g, b, 255*alpha)

                if i % 2 == 0 then 
                    color = tocolor(40, 40, 40, 150*alpha)
                    color2 = tocolor(r, g, b, 150*alpha)
                end 

                dxDrawRectangle(sx*0.3+6/myX*sx, startY, sx*0.095, sy*0.025, color)
                --dxDrawRectangle(sx*0.3+6/myX*sx, startY, 2/myX*sx, sy*0.025, color2)

                if selectedMenu == i then 
                    dxDrawImage(sx*0.3+12/myX*sx, startY+5/myY*sy, 15/myX*sx, 15/myY*sy, "files/"..v[2], 0, 0, 0, tocolor(r, g, b, 255*alpha))
                    dxDrawText(v[1], sx*0.3+38/myX*sx, startY, sx*0.3+38/myX*sx+sx*0.095, startY+sy*0.025, tocolor(r, g, b, 255*alpha), 0.8/myX*sx, font:getFont("condensed", 12), "left", "center")
                else
                    dxDrawImage(sx*0.3+12/myX*sx, startY+5/myY*sy, 15/myX*sx, 15/myY*sy, "files/"..v[2], 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
                    dxDrawText(v[1], sx*0.3+38/myX*sx, startY, sx*0.3+38/myX*sx+sx*0.095, startY+sy*0.025, tocolor(255, 255, 255, 255*alpha), 0.8/myX*sx, font:getFont("condensed", 12), "left", "center")
                end
            end

            startY = startY + sy*0.028
        end

        
        local selectedAccountSerial
        if #bankDatas["accounts"] > 0 then 
            if selectedAccount > 0 then 
                selectedAccountSerial = bankDatas["accounts"][selectedAccount][1] or false
            end
        else
            selectedAccountSerial = false
        end



        
        --if selectedMenu == 1 then 
            local startY = sy*0.3+7/myY*sy 

            for k, v in ipairs(mainPageTexts) do
                local height = sy*0.04 + #v.texts*sy*0.018
                
                local color1 = tocolor(40, 40, 40, 200*alpha)
                local color2 = tocolor(r, g, b, 220*alpha)

                if k % 2 == 0 then 
                    color1 = tocolor(40, 40, 40, 140*alpha)
                    color2 = tocolor(r, g, b, 120*alpha)
                end

                dxDrawRectangle(sx*0.403+5/myX*sx, startY, sx*0.24, height, color1)
                dxDrawRectangle(sx*0.403+5/myX*sx, startY, sx*0.0015, height, color2)

                dxDrawText(v.title, sx*0.403+15/myX*sx, startY, sx*0.403+15/myX*sx+sx*0.1, startY+sy*0.04, tocolor(255, 255, 255, 255*alpha), 1/myX*sx, fonts["bebasneue-12"], "left", "center")

                local startY2 = startY + sy*0.03

                for k2, v2 in ipairs(v.texts) do 
                    dxDrawText(v2, sx*0.403+15/myX*sx, startY2, sx*0.403+15/myX*sx+sx*0.2, startY2+sy*0.02, tocolor(220, 220, 220, 255*alpha), 0.8/myX*sx, fonts["condensed-12"], "left", "center")
                    startY2 = startY2 + sy*0.02
                end

                startY = startY + height + 3/myY*sy
            end
            dxDrawRectangle(sx*0.4035, sy*0.3+4/myY*sy, sx*0.2945, sy*0.04, tocolor(29, 29, 29, 255*alpha))
            dxDrawRectangle(sx*0.4035, sy*0.3+4/myY*sy+sy*0.04, sx*0.2945, sy*0.108, tocolor(32, 32, 32, 255*alpha))
            dxDrawText("Bankszámláid "..color.."("..#bankDatas["accounts"].."/10)", sx*0.4035, sy*0.3+4/myY*sy, sx*0.4035+sx*0.2945, sy*0.3+4/myY*sy+sy*0.04, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, font:getFont("bebasneue", 14), "center", "center", false, false, false, true)

            local startY = sy*0.3+4/myY*sy+sy*0.045
            for i = 1, 4 do 
                local v = bankDatas["accounts"][i+bankDatasPointer]

                if v then 
                    local color1 = tocolor(40, 40, 40, 200*alpha)
                    local color2 = tocolor(r, g, b, 220*alpha)

                    if (i+bankDatasPointer) % 2 == 0 then 
                        color1 = tocolor(40, 40, 40, 140*alpha)
                        color2 = tocolor(r, g, b, 120*alpha)
                    end

                    local pintext = "(****)"

                    if core:isInSlot(sx*0.403+5/myX*sx, startY, sx*0.285, sy*0.023) or selectedAccount == i+bankDatasPointer then 
                        dxDrawRectangle(sx*0.403+5/myX*sx, startY, sx*0.285, sy*0.023, tocolor(r, g, b, 100*alpha))
                    else
                        dxDrawRectangle(sx*0.403+5/myX*sx, startY, sx*0.285, sy*0.023, color1)
                    end

                    if core:isInSlot(sx*0.403+5/myX*sx, startY, sx*0.24, sy*0.023) then 
                        pintext = "("..v[6]..") " or "(nan) "
                    end

                    dxDrawRectangle(sx*0.403+5/myX*sx, startY, sx*0.0015, sy*0.023, color2)

                    if v[2] then 
                        dxDrawText(pintext.." #ffffff"..v[1]..color.." [Elsődleges]", sx*0.403+15/myX*sx, startY, sx*0.403+15/myX*sx+sx*0.1, startY+sy*0.023, tocolor(180, 180, 180, 255*alpha), 0.7/myX*sx, font:getFont("condensed", 14), "left", "center", false, false, false, true)
                    else
                        dxDrawText(pintext.." #ffffff"..v[1], sx*0.403+15/myX*sx, startY, sx*0.403+15/myX*sx+sx*0.1, startY+sy*0.023, tocolor(180, 180, 180, 255*alpha), 0.7/myX*sx, font:getFont("condensed", 14), "left", "center", false, false, false, true)
                    end

                    dxDrawText(string.format("%010d", v[3]).."#72b368$", sx*0.403+15/myX*sx, startY, sx*0.403+15/myX*sx+sx*0.276, startY+sy*0.023, tocolor(220, 220, 220, 255*alpha), 0.7/myX*sx, font:getFont("condensed", 14), "right", "center", false, false, false, true)

                    startY = startY + sy*0.025
                end
            end

            local lineHeight = 4/#bankDatas["accounts"] 

            if lineHeight > 1 then 
                lineHeight = 1 
            end 

            dxDrawRectangle(sx*0.694, sy*0.3+3/myY*sy+sy*0.045, 2/myX*sx, sy*0.1, tocolor(r, g, b, 150*alpha))
            dxDrawRectangle(sx*0.694, sy*0.3+3/myY*sy+sy*0.045 + sy*0.1*(lineHeight*bankDatasPointer/4), 2/myX*sx, sy*0.1*lineHeight, tocolor(r, g, b, 255*alpha))
        if selectedMenu == 1 then
            dxDrawRectangle(sx*0.4035, sy*0.455, sx*0.2945, sy*0.04, tocolor(29, 29, 29, 255*alpha))
            dxDrawRectangle(sx*0.4035, sy*0.455+sy*0.04, sx*0.2945, sy*0.116, tocolor(32, 32, 32, 255*alpha))
            if selectedAccount > 0 then 
                dxDrawText("Kezelés: "..color..bankDatas["accounts"][selectedAccount][1], sx*0.4035, sy*0.455, sx*0.4035+sx*0.2945, sy*0.455+sy*0.04, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, font:getFont("bebasneue", 14), "center", "center", false, false, false, true)
            else
                dxDrawText("Kezelés", sx*0.4035, sy*0.455, sx*0.4035+sx*0.2945, sy*0.455+sy*0.04, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, font:getFont("bebasneue", 14), "center", "center")
            end

            local startY = sy*0.455+sy*0.045
            for k, v in ipairs(controlPoints) do 
                local color1 = tocolor(40, 40, 40, 200*alpha)
                local color2 = tocolor(r, g, b, 220*alpha)

                if k % 2 == 0 then 
                    color1 = tocolor(40, 40, 40, 140*alpha)
                    color2 = tocolor(r, g, b, 120*alpha)
                end

                local text = ""

                if k == 4 then 
                    color2 = tocolor(222, 71, 71, 120*alpha)

                    if delState == 0 then 
                        text = v[1]
                    else
                        text = "Biztosan törölni szeretnéd?" 
                    end
                else
                    text = v[1]
                end

                if core:isInSlot(sx*0.4035+5/myX*sx, startY, sx*0.291, sy*0.025) then 
                    if k == 4 then 
                        dxDrawRectangle(sx*0.403+5/myX*sx, startY, sx*0.291, sy*0.025, tocolor(222, 71, 71, 100*alpha))
                    else
                        dxDrawRectangle(sx*0.403+5/myX*sx, startY, sx*0.291, sy*0.025, tocolor(r, g, b, 100*alpha))
                    end
                else
                    dxDrawRectangle(sx*0.4035+5/myX*sx, startY, sx*0.291, sy*0.025, color1)
                end
                dxDrawRectangle(sx*0.4035+5/myX*sx, startY, sx*0.001, sy*0.025, color2)

                dxDrawText(text, sx*0.4035+35/myX*sx, startY, sx*0.4035+sx*0.1+35/myX*sx, startY+sy*0.025, tocolor(220, 220, 220, 255*alpha), 0.8/myX*sx, font:getFont("condensed", 12), "left", "center", false, false, false, true)
                dxDrawText(v[2], sx*0.4035, startY, sx*0.4035+40/myX*sx, startY+sy*0.025, tocolor(220, 220, 220, 255*alpha), 0.7/myX*sx, font:getFont("fontawesome2", 14), "center", "center", false, false, false, true)
                startY = startY + sy*0.027
            end

            if selectedAccount <= 0 then 
                dxDrawRectangle(sx*0.4035, sy*0.455+sy*0.04, sx*0.2945, sy*0.116, tocolor(32, 32, 32, 220*alpha))
                dxDrawText("Nincs kiválasztva számla!", sx*0.4035, sy*0.455+sy*0.04, sx*0.4035+sx*0.2945, sy*0.455+sy*0.04+sy*0.11, tocolor(219, 48, 48, 255*alpha), 0.9/myX*sx, font:getFont("bebasneue", 25), "center", "bottom")
                dxDrawText("", sx*0.4035, sy*0.455+sy*0.04, sx*0.4035+sx*0.2945, sy*0.455+sy*0.04+sy*0.08, tocolor(219, 48, 48, 255*alpha), 0.9/myX*sx, font:getFont("fontawesome2", 30), "center", "center")
            end

            dxDrawRectangle(sx*0.4035, sy*0.614, sx*0.2945, sy*0.04, tocolor(29, 29, 29, 255*alpha))
            dxDrawRectangle(sx*0.4035, sy*0.614+sy*0.04, sx*0.2945, sy*0.04, tocolor(32, 32, 32, 255*alpha))
            dxDrawText("Új bankszámla igénylése", sx*0.4035, sy*0.614, sx*0.4035+sx*0.2945, sy*0.614+sy*0.04, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, font:getFont("bebasneue", 14), "center", "center")

            if core:isInSlot(sx*0.4035+5/myX*sx, sy*0.614+sy*0.04+5/myY*sy, sx*0.291, sy*0.03) then 
                dxDrawRectangle(sx*0.4035+5/myX*sx, sy*0.614+sy*0.04+5/myY*sy, sx*0.291, sy*0.03, tocolor(r, g, b, 100*alpha))
            else
                dxDrawRectangle(sx*0.4035+5/myX*sx, sy*0.614+sy*0.04+5/myY*sy, sx*0.291, sy*0.03, tocolor(40, 40, 40, 200*alpha))
            end
            dxDrawRectangle(sx*0.4035+5/myX*sx, sy*0.614+sy*0.04+5/myY*sy, sx*0.001, sy*0.03, tocolor(r, g, b, 220*alpha))
            dxDrawText("Új bankszámla igénylése #72b368(500$)", sx*0.4035+35/myX*sx, sy*0.614+sy*0.04+5/myY*sy, sx*0.4035+35/myX*sx+sx*0.291, sy*0.614+sy*0.04+5/myY*sy+sy*0.03, tocolor(220, 220, 220, 255*alpha), 0.8/myX*sx, font:getFont("condensed", 12), "left", "center", false, false, false, true)
            dxDrawText("", sx*0.4035, sy*0.614+sy*0.04+5/myY*sy, sx*0.4035+40/myX*sx, sy*0.614+sy*0.04+5/myY*sy+sy*0.03, tocolor(220, 220, 220, 255*alpha), 0.7/myX*sx, font:getFont("fontawesome2", 14), "center", "center", false, false, false, true)

        elseif selectedMenu == 2 then 
            --if #bankDatas["transactions"] > 0 then 
                if selectedAccountSerial then 
                    bankDatas["transactions"] = bankLogs[selectedAccountSerial][1]
                end
            --end


            dxDrawRectangle(sx*0.498, sy*0.455, sx*0.2, sy*0.04, tocolor(29, 29, 29, 255*alpha))
            dxDrawRectangle(sx*0.498, sy*0.455+sy*0.04, sx*0.2, sy*0.201, tocolor(32, 32, 32, 255*alpha))
            if selectedAccount > 0 then 
                dxDrawText("Tranzakciók: "..color..bankDatas["accounts"][selectedAccount][1], sx*0.498, sy*0.455, sx*0.498+sx*0.2, sy*0.455+sy*0.04, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, font:getFont("bebasneue", 14), "center", "center", false, false, false, true)
            else
                dxDrawText("Tranzakciók", sx*0.498, sy*0.455, sx*0.498+sx*0.2, sy*0.455+sy*0.04, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, font:getFont("bebasneue", 14), "center", "center", false, false, false, true)

                dxDrawText("Nincs kiválasztva számla!", sx*0.498, sy*0.455+sy*0.04, sx*0.498+sx*0.2, sy*0.455+sy*0.04+sy*0.15, tocolor(219, 48, 48, 255*alpha), 0.9/myX*sx, font:getFont("bebasneue", 25), "center", "bottom")
                dxDrawText("", sx*0.498, sy*0.455+sy*0.04, sx*0.498+sx*0.2, sy*0.455+sy*0.04+sy*0.13, tocolor(219, 48, 48, 255*alpha), 0.9/myX*sx, font:getFont("fontawesome2", 30), "center", "center")
            end

            local startY = sy*0.455+sy*0.04+2/myY*sy
            for i = 1, 9 do 
                local revTable = ReverseTable(bankDatas["transactions"]) 
                local v = revTable[i+transactionsPointer]

                if v then 
                    local color1 = tocolor(40, 40, 40, 200*alpha)
                    local color2 = tocolor(104, 212, 107, 220*alpha)
                    local prefix = "+"

                    if v[2] then 
                        prefix = "-"
                        if (i + transactionsPointer) % 2 == 0 then 
                            color1 = tocolor(40, 40, 40, 140*alpha)
                            color2 = tocolor(222, 71, 71, 120*alpha)
                        else
                            color2 = tocolor(222, 71, 71, 220*alpha)
                        end
                    else
                        if (i + transactionsPointer) % 2 == 0 then 
                            color1 = tocolor(40, 40, 40, 140*alpha)
                            color2 = tocolor(104, 212, 107, 120*alpha)
                        end
                    end

                    if core:isInSlot(sx*0.498+2/myX*sx, startY, sx*0.191, sy*0.02) then 
                        if v[2] then 
                            dxDrawRectangle(sx*0.498+2/myX*sx, startY, sx*0.191, sy*0.02, tocolor(222, 71, 71, 100*alpha))
                        else
                            dxDrawRectangle(sx*0.498+2/myX*sx, startY, sx*0.191, sy*0.02, tocolor(104, 212, 107, 100*alpha))
                        end
                    else
                        dxDrawRectangle(sx*0.498+2/myX*sx, startY, sx*0.191, sy*0.02, color1)
                    end
                    dxDrawRectangle(sx*0.498+2/myX*sx, startY, sx*0.001, sy*0.02, color2)

                    dxDrawText(prefix.." "..v[1].."$", sx*0.492+20/myX*sx, startY, sx*0.492+20/myX*sx+sx*0.1, startY+sy*0.02, color2, 0.7/myX*sx, font:getFont("condensed", 12), "left", "center", false, false, false, true)
                    startY = startY + sy*0.022
                end
            end

            local lineHeight = 9/#bankDatas["transactions"]

            if lineHeight > 1 then 
                lineHeight = 1 
            end 

            dxDrawRectangle(sx*0.694, sy*0.455+sy*0.04+2/myY*sy, 2/myX*sx, sy*0.198, tocolor(r, g, b, 150*alpha))
            dxDrawRectangle(sx*0.694, sy*0.455+sy*0.04+2/myY*sy + (sy*0.198*(lineHeight*transactionsPointer/9)), 2/myX*sx, sy*0.198*lineHeight, tocolor(r, g, b, 255*alpha))
            
            dxDrawRectangle(sx*0.4035, sy*0.455, sx*0.0925, sy*0.04, tocolor(29, 29, 29, 255*alpha))
            dxDrawRectangle(sx*0.4035, sy*0.455+sy*0.04, sx*0.0925, sy*0.201, tocolor(32, 32, 32, 255*alpha))
            dxDrawText("Műveletek", sx*0.4035, sy*0.455, sx*0.4035+sx*0.0925, sy*0.455+sy*0.04, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, font:getFont("bebasneue", 14), "center", "center")
            local startY = sy*0.455+sy*0.04+5/myY*sy
            for k, v in ipairs(transactionPoints) do
                local color1 = tocolor(40, 40, 40, 200*alpha)
                local color2 = tocolor(r, g, b, 220*alpha)

                if k % 2 == 0 then 
                    color1 = tocolor(40, 40, 40, 140*alpha)
                    color2 = tocolor(r, g, b, 120*alpha)
                end


                if core:isInSlot(sx*0.4035+5/myX*sx, startY, sx*0.0875, sy*0.062) then 
                    dxDrawRectangle(sx*0.4035+5/myX*sx, startY, sx*0.0875, sy*0.062, tocolor(r, g, b, 100))
                else
                    dxDrawRectangle(sx*0.4035+5/myX*sx, startY, sx*0.0875, sy*0.062, color1)
                end
                dxDrawRectangle(sx*0.4035+5/myX*sx, startY, sx*0.001, sy*0.062, color2)

                dxDrawText(v[1], sx*0.4095, startY+5/myY*sy, sx*0.4095+sx*0.0875, startY+5/myY*sy+sy*0.062, tocolor(220, 220, 220, 255*alpha), 0.85/myX*sx, font:getFont("condensed", 12), "left", "top", false, false, false, true)
                dxDrawText(v[2], sx*0.4035+5/myX*sx, startY+5/myY*sy, sx*0.4035+5/myX*sx+sx*0.083, startY+5/myY*sy+sy*0.062, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, font:getFont("fontawesome2", 20), "right", "center", false, false, false, true)
                startY = startY + sy*0.064
            end

            if selectedAccount <= 0 then 
                dxDrawRectangle(sx*0.4035, sy*0.455+sy*0.04, sx*0.0925, sy*0.201, tocolor(32, 32, 32, 220*alpha))
                dxDrawText("Nincs \nkiválasztva \nszámla!", sx*0.4035, sy*0.455+sy*0.04, sx*0.4035+sx*0.0925, sy*0.455+sy*0.04+sy*0.201, tocolor(219, 48, 48, 255*alpha), 0.9/myX*sx, font:getFont("bebasneue", 25), "center", "center")
            end
        elseif selectedMenu == 3 then 
            if selectedAccountSerial then 
                bankDatas["transfers"] = bankLogs[selectedAccountSerial][2]
            end

            dxDrawRectangle(sx*0.498, sy*0.455, sx*0.2, sy*0.04, tocolor(29, 29, 29, 255*alpha))
            dxDrawRectangle(sx*0.498, sy*0.455+sy*0.04, sx*0.2, sy*0.201, tocolor(32, 32, 32, 255*alpha))
            if selectedAccount > 0 then 
                dxDrawText("Utalások: "..color..bankDatas["accounts"][selectedAccount][1], sx*0.498, sy*0.455, sx*0.498+sx*0.2, sy*0.455+sy*0.04, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, font:getFont("bebasneue", 14), "center", "center", false, false, false, true)
            else
                dxDrawText("Utalások", sx*0.498, sy*0.455, sx*0.498+sx*0.2, sy*0.455+sy*0.04, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, font:getFont("bebasneue", 14), "center", "center", false, false, false, true)

                dxDrawText("Nincs kiválasztva számla!", sx*0.498, sy*0.455+sy*0.04, sx*0.498+sx*0.2, sy*0.455+sy*0.04+sy*0.15, tocolor(219, 48, 48, 255*alpha), 0.9/myX*sx, font:getFont("bebasneue", 25), "center", "bottom")
                dxDrawText("", sx*0.498, sy*0.455+sy*0.04, sx*0.498+sx*0.2, sy*0.455+sy*0.04+sy*0.13, tocolor(219, 48, 48, 255*alpha), 0.9/myX*sx, font:getFont("fontawesome2", 30), "center", "center")
            end

            local startY = sy*0.455+sy*0.04+2/myY*sy
            for i = 1, 9 do 
                local revTable = ReverseTable(bankDatas["transfers"]) 
                local v = revTable[i+transferPointer]

                if v then 
                    local color1 = tocolor(40, 40, 40, 200*alpha)
                    local color2 = tocolor(104, 212, 107, 220*alpha)
                    local prefix = "+"

                    if v[3] then 
                        prefix = "-"
                        if (i + transferPointer) % 2 == 0 then 
                            color1 = tocolor(40, 40, 40, 140*alpha)
                            color2 = tocolor(222, 71, 71, 120*alpha)
                        else
                            color2 = tocolor(222, 71, 71, 220*alpha)
                        end
                    else
                        if (i + transferPointer) % 2 == 0 then 
                            color1 = tocolor(40, 40, 40, 140*alpha)
                            color2 = tocolor(104, 212, 107, 120*alpha)
                        end
                    end

                    if core:isInSlot(sx*0.498+2/myX*sx, startY, sx*0.191, sy*0.02) then 
                        if v[3] then 
                            dxDrawRectangle(sx*0.498+2/myX*sx, startY, sx*0.191, sy*0.02, tocolor(222, 71, 71, 100*alpha))
                        else
                            dxDrawRectangle(sx*0.498+2/myX*sx, startY, sx*0.191, sy*0.02, tocolor(104, 212, 107, 100*alpha))
                        end
                    else
                        dxDrawRectangle(sx*0.498+2/myX*sx, startY, sx*0.191, sy*0.02, color1)
                    end
                    dxDrawRectangle(sx*0.498+2/myX*sx, startY, sx*0.001, sy*0.02, color2)

                    dxDrawText(prefix.." "..v[2].."$", sx*0.492+20/myX*sx, startY, sx*0.492+sx*0.195, startY+sy*0.02, color2, 0.7/myX*sx, font:getFont("condensed", 12), "right", "center", false, false, false, true)
                    dxDrawText(v[1], sx*0.492+20/myX*sx, startY, sx*0.492+sx*0.195, startY+sy*0.02, tocolor(255, 255, 255, 255*alpha), 0.7/myX*sx, font:getFont("condensed", 12), "left", "center", false, false, false, true)
                    startY = startY + sy*0.022
                end
            end

            local lineHeight = 9/#bankDatas["transfers"]

            if lineHeight > 1 then 
                lineHeight = 1 
            end 

            dxDrawRectangle(sx*0.694, sy*0.455+sy*0.04+2/myY*sy, 2/myX*sx, sy*0.198, tocolor(r, g, b, 150*alpha))
            dxDrawRectangle(sx*0.694, sy*0.455+sy*0.04+2/myY*sy + (sy*0.198*(lineHeight*transferPointer/9)), 2/myX*sx, sy*0.198*lineHeight, tocolor(r, g, b, 255*alpha))
            
            dxDrawRectangle(sx*0.4035, sy*0.455, sx*0.0925, sy*0.04, tocolor(29, 29, 29, 255*alpha))
            dxDrawRectangle(sx*0.4035, sy*0.455+sy*0.04, sx*0.0925, sy*0.201, tocolor(32, 32, 32, 255*alpha))
            dxDrawText("Műveletek", sx*0.4035, sy*0.455, sx*0.4035+sx*0.0925, sy*0.455+sy*0.04, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, font:getFont("bebasneue", 14), "center", "center")
            local startY = sy*0.455+sy*0.04+5/myY*sy
            for k, v in ipairs(transferPoints) do
                local color1 = tocolor(40, 40, 40, 200*alpha)
                local color2 = tocolor(r, g, b, 220*alpha)

                if k % 2 == 0 then 
                    color1 = tocolor(40, 40, 40, 140*alpha)
                    color2 = tocolor(r, g, b, 120*alpha)
                end


                if core:isInSlot(sx*0.4035+5/myX*sx, startY, sx*0.0875, sy*0.096) then 
                    dxDrawRectangle(sx*0.4035+5/myX*sx, startY, sx*0.0875, sy*0.096, tocolor(r, g, b, 100))
                else
                    dxDrawRectangle(sx*0.4035+5/myX*sx, startY, sx*0.0875, sy*0.096, color1)
                end
                dxDrawRectangle(sx*0.4035+5/myX*sx, startY, sx*0.001, sy*0.096, color2)

                dxDrawText(v[1], sx*0.4095, startY+5/myY*sy, sx*0.4095+sx*0.0875, startY+5/myY*sy+sy*0.062, tocolor(220, 220, 220, 255*alpha), 0.85/myX*sx, font:getFont("condensed", 15), "left", "top", false, false, false, true)
                dxDrawText(v[2], sx*0.4035+5/myX*sx, startY+5/myY*sy, sx*0.4035+5/myX*sx+sx*0.083, startY+5/myY*sy+sy*0.085, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, font:getFont("fontawesome2", 20), "right", "bottom", false, false, false, true)
                startY = startY + sy*0.098
            end

            if utalasShowing then 
                dxDrawRectangle(sx*0.35, sy*0.71, sx*0.3, sy*0.05, tocolor(30, 30, 30, 255*alpha))
                dxDrawRectangle(sx*0.35+3/myX*sx, sy*0.71+3/myY*sy, sx*0.3-6/myX*sx, sy*0.05-6/myY*sy, tocolor(34, 34, 34, 255*alpha))

                local startX = sx*0.35+6/myX*sx

                for i = 1, 4 do 
                    dxDrawRectangle(startX, sy*0.71+6/myY*sy, sx*0.04, sy*0.037, tocolor(40, 40, 40, 220*alpha))
                    dxDrawText(transferTo[i], startX, sy*0.71+6/myY*sy, startX+sx*0.04, sy*0.71+6/myY*sy+sy*0.037, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, font:getFont("condensed", 12), "center", "center")

                    if i < 4 then 
                        dxDrawText("-", startX+sx*0.04, sy*0.71+6/myY*sy, startX+sx*0.04+sx*0.02, sy*0.71+6/myY*sy+sy*0.037, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, font:getFont("condensed", 12), "center", "center")
                    end

                    startX = startX + sx*0.06
                end

                dxDrawRectangle(sx*0.582, sy*0.71+8/myY*sy, sx*0.06, sy*0.015, tocolor(40, 40, 40, 220*alpha))
                if core:isInSlot(sx*0.582, sy*0.71+8/myY*sy, sx*0.06, sy*0.015) then 
                    dxDrawText("Utalás", sx*0.582, sy*0.71+8/myY*sy, sx*0.582+sx*0.06, sy*0.71+8/myY*sy+sy*0.015, tocolor(r, g, b, 255*alpha), 0.65/myX*sx, font:getFont("condensed", 12), "center", "center")
                else
                    dxDrawText("Utalás", sx*0.582, sy*0.71+8/myY*sy, sx*0.582+sx*0.06, sy*0.71+8/myY*sy+sy*0.015, tocolor(220, 220, 220, 255*alpha), 0.65/myX*sx, font:getFont("condensed", 12), "center", "center")
                end

                dxDrawRectangle(sx*0.582, sy*0.71+8/myY*sy+sy*0.017, sx*0.06, sy*0.015, tocolor(40, 40, 40, 220*alpha))
                if core:isInSlot(sx*0.582, sy*0.71+8/myY*sy+sy*0.017, sx*0.06, sy*0.015) then 
                    dxDrawText("Mégsem", sx*0.582, sy*0.71+8/myY*sy+sy*0.017, sx*0.582+sx*0.06, sy*0.71+8/myY*sy+sy*0.015+sy*0.017, tocolor(222, 71, 71, 255*alpha), 0.65/myX*sx, font:getFont("condensed", 12), "center", "center")
                else
                    dxDrawText("Mégsem", sx*0.582, sy*0.71+8/myY*sy+sy*0.017, sx*0.582+sx*0.06, sy*0.71+8/myY*sy+sy*0.015+sy*0.017, tocolor(220, 220, 220, 255*alpha), 0.65/myX*sx, font:getFont("condensed", 12), "center", "center")
                end
            end
        end 

        if points[selectedMenu][3] then 
            dxDrawRectangle(sx*0.3+4/myX*sx, sy*0.39, sx*0.1, sy*0.04, tocolor(29, 29, 29, 255*alpha))
            dxDrawRectangle(sx*0.3+4/myX*sx, sy*0.39+sy*0.04, sx*0.1, sy*0.266, tocolor(32, 32, 32, 255*alpha))
            dxDrawText(points[selectedMenu][4]..": "..pintext, sx*0.3+4/myX*sx, sy*0.39, sx*0.3+4/myX*sx+sx*0.1, sy*0.39+sy*0.04, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, font:getFont("bebasneue", 15), "center", "center")

            --dxDrawText(pintext, sx*0.403+5/myX*sx, sy*0.353, sx*0.403+5/myX*sx+sx*0.072, sy*0.353+sy*0.025, tocolor(220, 220, 220, 255*alpha), 0.95/myX*sx, font:getFont("condensed", 12), "center", "center")

            local startX, startY = sx*0.3+6/myX*sx, sy*0.39+sy*0.04+18/myY*sy

            for i = 1, 11 do 
                if i == 10 then 
                    startX = startX + 28/myX*sx
                end

                if core:isInSlot(startX, startY, 54/myX*sx, 54/myY*sy) then 
                    dxDrawRectangle(startX, startY, 54/myX*sx, 54/myY*sy, tocolor(r, g, b, 100*alpha))
                else
                    dxDrawRectangle(startX, startY, 54/myX*sx, 54/myY*sy, tocolor(35, 35, 35, 255*alpha))
                end

                if i == 10 then 
                    dxDrawText(0, startX, startY, startX+54/myX*sx, startY+54/myY*sy, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, font:getFont("condensed", 18), "center", "center")
                elseif i == 11 then 
                    dxDrawText("<", startX, startY, startX+54/myX*sx, startY+54/myY*sy, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, font:getFont("condensed", 18), "center", "center")
                else
                    dxDrawText(i, startX, startY, startX+54/myX*sx, startY+54/myY*sy, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, font:getFont("condensed", 18), "center", "center")
                end

                startX = startX + 59/myX*sx
                if i%3 == 0 then 
                    startY = startY + 59/myY*sy
                    startX = sx*0.3+6/myX*sx    
                end
            end
        end 
    elseif panelType == 2 then 
        dxDrawRectangle(sx*0.44, sy*0.3, sx*0.118, sy*0.375, tocolor(30, 30, 30, 255*alpha))
        dxDrawRectangle(sx*0.44+3/myX*sx, sy*0.3+3/myY*sy, sx*0.118-6/myX*sx, sy*0.375-6/myY*sy, tocolor(34, 34, 34, 255*alpha))
        if atmState == 1 then 
            local startX, startY = sx*0.442+9/myX*sx, sy*0.306+sy*0.04+33/myY*sy
            for i = 1, 12 do 

                if core:isInSlot(startX, startY, 60/myX*sx, 60/myY*sy) then 
                    dxDrawRectangle(startX, startY, 60/myX*sx, 60/myY*sy, tocolor(r, g, b, 100*alpha))
                else
                    dxDrawRectangle(startX, startY, 60/myX*sx, 60/myY*sy, tocolor(40, 40, 40, 200*alpha))
                end

                if i == 10 then  
                    dxDrawText("C", startX, startY, startX+60/myX*sx, startY+60/myY*sy, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, fonts["condensed-15"], "center", "center")
                elseif i == 11 then 
                    dxDrawText(0, startX, startY, startX+60/myX*sx, startY+60/myY*sy, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, fonts["condensed-15"], "center", "center")
                elseif i == 12 then 
                    dxDrawText("<", startX, startY, startX+60/myX*sx, startY+60/myY*sy, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, fonts["condensed-15"], "center", "center")
                else
                    dxDrawText(i, startX, startY, startX+60/myX*sx, startY+60/myY*sy, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, fonts["condensed-15"], "center", "center")
                end

                startX = startX + 62/myX*sx
                if i%3 == 0 then 
                    startY = startY + 62/myY*sy
                    startX = sx*0.442+9/myX*sx
                end
            end

            dxDrawRectangle(sx*0.442+2/myX*sx, sy*0.64, sx*0.1125, sy*0.03, tocolor(40, 40, 40, 200*alpha))

            if core:isInSlot(sx*0.442+2/myX*sx, sy*0.64, sx*0.1125, sy*0.03) then 
                dxDrawText("Belépés", sx*0.442+2/myX*sx, sy*0.64, sx*0.442+2/myX*sx+sx*0.1125, sy*0.64+sy*0.03, tocolor(r, g, b, 255*alpha), 0.9/myX*sx, fonts["condensed-12"], "center", "center")
            else
                dxDrawText("Belépés", sx*0.442+2/myX*sx, sy*0.64, sx*0.442+2/myX*sx+sx*0.1125, sy*0.64+sy*0.03, tocolor(220, 220, 220, 255*alpha), 0.9/myX*sx, fonts["condensed-12"], "center", "center")
            end

            local starts = ""
            for i = 1, string.len(pintext) do 
                starts = starts .. "*"
            end
            dxDrawRectangle(sx*0.442+2/myX*sx, sy*0.3+6/myY*sy, sx*0.1125, sy*0.06, tocolor(40, 40, 40, 200*alpha))
            dxDrawText(starts, sx*0.442+2/myX*sx, sy*0.3+6/myY*sy, sx*0.442+2/myX*sx+sx*0.1125, sy*0.3+6/myY*sy+sy*0.06, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, fonts["condensed-17"], "center", "center")
        elseif atmState == 2 then 
            local startX, startY = sx*0.442+9/myX*sx, sy*0.306+sy*0.04+33/myY*sy
            for i = 1, 12 do 

                if core:isInSlot(startX, startY, 60/myX*sx, 60/myY*sy) then 
                    dxDrawRectangle(startX, startY, 60/myX*sx, 60/myY*sy, tocolor(r, g, b, 100*alpha))
                else
                    dxDrawRectangle(startX, startY, 60/myX*sx, 60/myY*sy, tocolor(40, 40, 40, 200*alpha))
                end

                if i == 10 then  
                    dxDrawText("C", startX, startY, startX+60/myX*sx, startY+60/myY*sy, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, fonts["condensed-15"], "center", "center")
                elseif i == 11 then 
                    dxDrawText(0, startX, startY, startX+60/myX*sx, startY+60/myY*sy, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, fonts["condensed-15"], "center", "center")
                elseif i == 12 then 
                    dxDrawText("<", startX, startY, startX+60/myX*sx, startY+60/myY*sy, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, fonts["condensed-15"], "center", "center")
                else
                    dxDrawText(i, startX, startY, startX+60/myX*sx, startY+60/myY*sy, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, fonts["condensed-15"], "center", "center")
                end

                startX = startX + 62/myX*sx
                if i%3 == 0 then 
                    startY = startY + 62/myY*sy
                    startX = sx*0.442+9/myX*sx
                end
            end

            dxDrawRectangle(sx*0.442+2/myX*sx, sy*0.63, sx*0.1125, sy*0.02, tocolor(40, 40, 40, 200*alpha))
            dxDrawRectangle(sx*0.442+2/myX*sx, sy*0.651, sx*0.1125, sy*0.02, tocolor(40, 40, 40, 200*alpha))

            if core:isInSlot(sx*0.442+2/myX*sx, sy*0.63, sx*0.1125, sy*0.02) then 
                dxDrawText("Pénz kivétele", sx*0.442+2/myX*sx, sy*0.63, sx*0.442+2/myX*sx+sx*0.1125, sy*0.63+sy*0.02, tocolor(r, g, b, 255*alpha), 0.75/myX*sx, fonts["condensed-12"], "center", "center")
            else
                dxDrawText("Pénz kivétele", sx*0.442+2/myX*sx, sy*0.63, sx*0.442+2/myX*sx+sx*0.1125, sy*0.63+sy*0.02, tocolor(220, 220, 220, 255*alpha), 0.75/myX*sx, fonts["condensed-12"], "center", "center")
            end

            if core:isInSlot(sx*0.442+2/myX*sx, sy*0.651, sx*0.1125, sy*0.02) then 
                dxDrawText("Bezárás", sx*0.442+2/myX*sx, sy*0.651, sx*0.442+2/myX*sx+sx*0.1125, sy*0.651+sy*0.02, tocolor(222, 71, 71, 255*alpha), 0.75/myX*sx, fonts["condensed-12"], "center", "center")
            else
                dxDrawText("Bezárás", sx*0.442+2/myX*sx, sy*0.651, sx*0.442+2/myX*sx+sx*0.1125, sy*0.651+sy*0.02, tocolor(220, 220, 220, 255*alpha), 0.75/myX*sx, fonts["condensed-12"], "center", "center")
            end


            dxDrawRectangle(sx*0.442+2/myX*sx, sy*0.3+6/myY*sy, sx*0.1125, sy*0.04, tocolor(40, 40, 40, 200*alpha))
            dxDrawText(moneytext.."$", sx*0.442+2/myX*sx, sy*0.3+6/myY*sy, sx*0.442+2/myX*sx+sx*0.1125, sy*0.3+6/myY*sy+sy*0.04, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, fonts["condensed-17"], "center", "center")
            dxDrawRectangle(sx*0.442+2/myX*sx, sy*0.3435+6/myY*sy, sx*0.1125, sy*0.025, tocolor(40, 40, 40, 200*alpha))
            if bankAccounts[selectedATMSerial] then 
                dxDrawText("Egyenleg: "..color..bankAccounts[selectedATMSerial][3].."#dcdcdc$", sx*0.442+2/myX*sx, sy*0.3435+6/myY*sy, sx*0.442+2/myX*sx+sx*0.1125, sy*0.3435+6/myY*sy+sy*0.025, tocolor(220, 220, 220, 255*alpha), 0.8/myX*sx, fonts["condensed-12"], "center", "center", false, false, false, true)
            end
        end
    end
end

local lastInteraction = 0
function panelKey(key, state)
    if state then 
        key = key:gsub("num_", "")
        if key == "mouse1" then 
            if panelType == 1 then 
                local startY = sy*0.3+6/myY*sy 
                for i = 1, 3 do
                    local v = points[i] 
                    if v then 
                        if core:isInSlot(sx*0.3+6/myX*sx, startY, sx*0.095, sy*0.025) then 
                            selectedMenu = i
                            --bankDatasPointer = 0
                            transactionsPointer = 0
                            transferPointer = 0
                            delState = 0
                            pintext = ""
                        end
                    end
        
                    startY = startY + sy*0.028
                end

                local startY = sy*0.3+4/myY*sy+sy*0.045
                for i = 1, 4 do 
                    local v = bankDatas["accounts"][i+bankDatasPointer]

                    if v then 
                        if core:isInSlot(sx*0.403+5/myX*sx, startY, sx*0.285, sy*0.023) then 
                            if selectedAccount == i+bankDatasPointer then 
                                selectedAccount = 0
                                bankDatas["transactions"] = {}
                                bankDatas["transfers"] = {}
                            else
                                selectedAccount = i+bankDatasPointer
                                transactionsPointer = 0
                                transferPointer = 0
                                delState = 0
                                pintext = ""
                            end
                        end

                        startY = startY + sy*0.025
                    end
                end

                if selectedMenu == 1 then     
                    if core:isInSlot(sx*0.4035+5/myX*sx, sy*0.614+sy*0.04+5/myY*sy, sx*0.291, sy*0.03) then 
                        if lastInteraction + 1000 < getTickCount() then 
                            if countPlayerAccounts() <= 9 then 
                                if getElementData(localPlayer, "char:money") >= 500 then 
                                    triggerServerEvent("bank > createNewBankAccount", resourceRoot, 0)
                                    infobox:outputInfoBox("Sikeresen igényeltél egy bankszámlát!", "success")
                                    lastInteraction = getTickCount()
                                else
                                    infobox:outputInfoBox("Nincs elegendő pénzed az igényléshez!", "error")
                                end
                            else
                                infobox:outputInfoBox("Elérted a maximálisan nyitható számlák számát!", "error")
                            end
                        end
                    end

                    local startY = sy*0.455+sy*0.045
                    for k, v in ipairs(controlPoints) do 
                        if core:isInSlot(sx*0.4035+5/myX*sx, startY, sx*0.291, sy*0.025) then 
                            if selectedAccount > 0 then 
                                if lastInteraction + 1000 < getTickCount() then 
                                    if k == 1 then -- update pin
                                        if string.len(pintext) == 4 then 
                                            triggerServerEvent("bank > modifyPin", resourceRoot, bankDatas["accounts"][selectedAccount][1], pintext)
                                            lastInteraction = getTickCount()
                                            pintext = ""
                                            infobox:outputInfoBox("Sikeresen módosítottad a számlád PIN kódját!", "success")
                                        else
                                            infobox:outputInfoBox("Nem megfelelő PIN formátum!", "error")
                                        end
                                    elseif k == 2 then -- bankkártya igénylés
                                        if getElementData(localPlayer, "char:money") >= 250 then 
                                            --if (not exports.oInventory:hasItem(155, bankDatas["accounts"][selectedAccount][1])) then 
                                                triggerServerEvent("bank > giveCreditCard", resourceRoot, bankDatas["accounts"][selectedAccount][1])
                                                lastInteraction = getTickCount()
                                                infobox:outputInfoBox("Sikeresen igényeltél egy bankkártyát!", "success")
                                            --else
                                            --    infobox:outputInfoBox("Már van bankkártyád ehhez a számlához!", "error")
                                            --end
                                        else
                                            infobox:outputInfoBox("Nincs elegendő pénzed!", "error")
                                        end
                                    elseif k == 3 then -- beállítás elsődlegesnek
                                        if not bankDatas["accounts"][selectedAccount][2] then 
                                            triggerServerEvent("bank > setToMainAccount", resourceRoot, bankDatas["accounts"][selectedAccount][1], playerHasMainAccount())
                                            lastInteraction = getTickCount()
                                            infobox:outputInfoBox("Sikeresen beállítottad az alapértelmezett számlád!", "success")
                                        else
                                            infobox:outputInfoBox("Már ez az elsődleges számlád!", "error")
                                        end
                                    elseif k == 4 then -- törlés 
                                        delState = delState + 1

                                        if delState == 2 then 
                                            delState = 0
                                            triggerServerEvent("bank > delBankAccount", resourceRoot, bankDatas["accounts"][selectedAccount][5], bankDatas["accounts"][selectedAccount][1])
                                            selectedAccountSerial = 0
                                            lastInteraction = getTickCount()
                                            infobox:outputInfoBox("Sikeresen töröltél egy bankszámlát!", "success")

                                            if bankDatasPointer > 0 then 
                                                bankDatasPointer = bankDatasPointer - 1
                                            end

                                            selectedAccount = 0
                                        end
                                    end
                                end 
                            end
                        end
                    
                        startY = startY + sy*0.027
                    end
                elseif selectedMenu == 2 then 
                    local startY = sy*0.455+sy*0.04+5/myY*sy
                    for k, v in ipairs(transactionPoints) do
                        if core:isInSlot(sx*0.4035+5/myX*sx, startY, sx*0.0875, sy*0.062) then 
                            if selectedAccount > 0 then 
                                if lastInteraction + 1000 < getTickCount() then 
                                    if k == 1 then -- kivétel 
                                        if (tonumber(pintext) or 0) > 0 then 
                                            if bankDatas["accounts"][selectedAccount][3] >= tonumber(pintext) then 
                                                infobox:outputInfoBox("Sikeres tranzakció", "success")
                                                triggerServerEvent("bank > moneyFromAccount", resourceRoot, bankDatas["accounts"][selectedAccount][1], tonumber(pintext))
                                                pintext = ""
                                                lastInteraction = getTickCount()
                                            else
                                                infobox:outputInfoBox("Nincs ennyi pénz a bankszámládon!", "error")
                                            end
                                        end
                                    elseif k == 2 then -- befizetés
                                        if (tonumber(pintext) or 0) > 0 then 
                                            if getElementData(localPlayer, "char:money") >= tonumber(pintext) then 
                                                infobox:outputInfoBox("Sikeres tranzakció", "success")
                                                lastInteraction = getTickCount()
                                                triggerServerEvent("bank > moneyToAccount", resourceRoot, bankDatas["accounts"][selectedAccount][1], tonumber(pintext))
                                                pintext = ""
                                            else
                                                infobox:outputInfoBox("Nincs ennyi pénz nállad!", "error")
                                            end
                                        end
                                    elseif k == 3 then -- előzmények törlése
                                        triggerServerEvent("bank > clearTransactionLog", resourceRoot, bankDatas["accounts"][selectedAccount][1])
                                        transactionsPointer = 0
                                        lastInteraction = getTickCount()
                                    end
                                end
                            end
                        end
                    
                        startY = startY + sy*0.064
                    end 
                elseif selectedMenu == 3 then 
                    local startY = sy*0.455+sy*0.04+5/myY*sy
                    for k, v in ipairs(transferPoints) do
                        if core:isInSlot(sx*0.4035+5/myX*sx, startY, sx*0.0875, sy*0.096) then 
                            if k == 1 then -- utalás
                                if string.len(pintext) > 0 then 
                                    utalasShowing = true
                                end
                            elseif k == 2 then -- log törlés
                                if lastInteraction + 1000 < getTickCount() then 
                                    triggerServerEvent("bank > clearTransferLog", resourceRoot, bankDatas["accounts"][selectedAccount][1])
                                    lastInteraction = getTickCount()
                                end
                            end
                        end
                        startY = startY + sy*0.098
                    end

                    if utalasShowing then 
                        if core:isInSlot(sx*0.582, sy*0.71+8/myY*sy, sx*0.06, sy*0.015) then -- utalas
                            if string.len(transferTo[1]) == 4 and string.len(transferTo[2]) == 4 and string.len(transferTo[3]) == 4 and string.len(transferTo[4]) == 4 then 
                                local serial = transferTo[1].."-"..transferTo[2].."-"..transferTo[3].."-"..transferTo[4]
                                if bankAccounts[serial] then
                                    if not (serial == bankDatas["accounts"][selectedAccount][1]) then 
                                        if lastInteraction + 1000 < getTickCount() then 
                                            if bankDatas["accounts"][selectedAccount][3] >= tonumber(pintext) then 
                                                lastInteraction = getTickCount()
                                                triggerServerEvent("bank > transferMoney", resourceRoot, bankDatas["accounts"][selectedAccount][1], serial, tonumber(pintext))
                                                utalasShowing = false 
                                                pintext = ""
                                                transferTo = {"", "", "", ""}
                                                infobox:outputInfoBox("Sikeres tranzakció!", "success")
                                            else
                                                infobox:outputInfoBox("Nincs ennyi pénz a számládon!", "error")
                                            end
                                        end
                                    else
                                        infobox:outputInfoBox("Nem utalhatsz a saját számládra!", "error")
                                    end
                                else
                                    infobox:outputInfoBox("Nem létezik ilyen számla!", "error")
                                end 
                            else
                                infobox:outputInfoBox("Hibás formátum!", "error")
                            end
                        end
                        
                        if core:isInSlot(sx*0.582, sy*0.71+8/myY*sy+sy*0.017, sx*0.06, sy*0.015) then -- mégsem 
                            utalasShowing = false 
                            moneytext2 = ""
                            transferTo = {"", "", "", ""}
                        end
                    end
                end

                if points[selectedMenu][3] then 
                    local startX, startY = sx*0.3+6/myX*sx, sy*0.39+sy*0.04+18/myY*sy
                    for i = 1, 11 do 
                        if i == 10 then 
                            startX = startX + 28/myX*sx
                        end
            
                        if core:isInSlot(startX, startY, 54/myX*sx, 54/myY*sy) then 
                            local maxChar = 4 

                            if selectedMenu > 1 then 
                                maxChar = 10
                            end

                            if string.len(pintext) < maxChar then 
                                if i == 10 then 
                                    pintext = pintext .. "0"
                                elseif i == 11 then 
                                    pintext = pintext:gsub("[^\128-\191][\128-\191]*$", "")
                                else
                                    pintext = pintext .. tostring(i)
                                end
                            else 
                                if i == 11 then 
                                    pintext = pintext:gsub("[^\128-\191][\128-\191]*$", "")
                                end
                            end
                        end
        
                        startX = startX + 59/myX*sx
                        if i%3 == 0 then 
                            startY = startY + 59/myY*sy
                            startX = sx*0.3+6/myX*sx    
                        end
                    end
                end 

            elseif panelType == 2 then 
                if atmState == 1 then 
                    local startX, startY = sx*0.442+9/myX*sx, sy*0.306+sy*0.04+33/myY*sy
                    for i = 1, 12 do 
                        if core:isInSlot(startX, startY, 60/myX*sx, 60/myY*sy) then 
                            if string.len(pintext) < 4 then 
                                if i == 10 then 
                                    pintext = ""
                                elseif i == 11 then 
                                    pintext = pintext .. "0"
                                elseif i == 12 then 
                                    pintext = pintext:gsub("[^\128-\191][\128-\191]*$", "")
                                else
                                    pintext = pintext .. tostring(i)
                                end
                                playSound("files/atm.wav")
                            else
                                if i == 10 then 
                                    pintext = "" 
                                    playSound("files/atm.wav")
                                elseif i == 12 then 
                                    pintext = pintext:gsub("[^\128-\191][\128-\191]*$", "")
                                    playSound("files/atm.wav")
                                end
                            end    
                        end

                        startX = startX + 62/myX*sx
                        if i%3 == 0 then 
                            startY = startY + 62/myY*sy
                            startX = sx*0.442+9/myX*sx
                        end
                    end

                    if core:isInSlot(sx*0.442+2/myX*sx, sy*0.64, sx*0.1125, sy*0.03) then 
                        if tostring(pintext) == tostring(bankAccounts[selectedATMSerial][5]) then 
                            infobox:outputInfoBox("Sikeres belépés!", "success")
                            atmState = 2
                        else
                            infobox:outputInfoBox("Hibás PIN-kód!", "error")
                        end
                    end
                elseif atmState == 2 then 
                    local startX, startY = sx*0.442+9/myX*sx, sy*0.306+sy*0.04+33/myY*sy
                    for i = 1, 12 do 
                        if core:isInSlot(startX, startY, 60/myX*sx, 60/myY*sy) then 
                            if string.len(moneytext) < 12 then 
                                if i == 10 then 
                                    moneytext = ""
                                elseif i == 11 then 
                                    moneytext = moneytext .. "0"
                                elseif i == 12 then 
                                    moneytext = moneytext:gsub("[^\128-\191][\128-\191]*$", "")
                                else
                                    moneytext = moneytext .. tostring(i)
                                end
                                playSound("files/atm.wav")
                            else
                                if i == 10 then 
                                    moneytext = "" 
                                    playSound("files/atm.wav")
                                elseif i == 12 then 
                                    moneytext = moneytext:gsub("[^\128-\191][\128-\191]*$", "")
                                    playSound("files/atm.wav")
                                end
                            end    
                        end

                        startX = startX + 62/myX*sx
                        if i%3 == 0 then 
                            startY = startY + 62/myY*sy
                            startX = sx*0.442+9/myX*sx
                        end
                    end

                    if core:isInSlot(sx*0.442+2/myX*sx, sy*0.63, sx*0.1125, sy*0.02) then 
                        if tonumber(moneytext) > 0 then 
                            if tonumber(moneytext) <= tonumber(bankAccounts[selectedATMSerial][3]) then 
                                triggerServerEvent("bank > moneyFromAccount", resourceRoot, selectedATMSerial, tonumber(moneytext))
                                moneytext = ""
                                infobox:outputInfoBox("Sikeres tranzakció!", "success")
                                chat:sendLocalMeAction("kivett pénzt az ATM-ből.")
                            else
                                infobox:outputInfoBox("Nincs ennyi pénz a számládon!", "error")
                            end
                        end
                    end
        
                    if core:isInSlot(sx*0.442+2/myX*sx, sy*0.651, sx*0.1125, sy*0.02) then 
                       closePanel()
                    end
                end
            end
        elseif key == "mouse_wheel_down" then 
            if panelType == 1 then 
                --if selectedMenu == 1 then 
                    if core:isInSlot(sx*0.4035, sy*0.3+4/myY*sy+sy*0.04, sx*0.2945, sy*0.108) then 
                        if bankDatas["accounts"][5+bankDatasPointer] then 
                            bankDatasPointer = bankDatasPointer + 1
                        end
                    end
                if selectedMenu == 2 then 
                    if core:isInSlot(sx*0.498, sy*0.455+sy*0.04, sx*0.2, sy*0.201) then 
                        if bankDatas["transactions"][10+transactionsPointer] then 
                            transactionsPointer = transactionsPointer + 1
                        end
                    end
                elseif selectedMenu == 3 then 
                    if core:isInSlot(sx*0.498, sy*0.455+sy*0.04, sx*0.2, sy*0.201) then 
                        if bankDatas["transfers"][10+transferPointer] then 
                            transferPointer = transferPointer + 1
                        end
                    end
                end
            end
        elseif key == "mouse_wheel_up" then 
            if panelType == 1 then 
                --if selectedMenu == 1 then 
                    if core:isInSlot(sx*0.4035, sy*0.3+4/myY*sy+sy*0.04, sx*0.2945, sy*0.108) then 
                        if bankDatasPointer > 0 then 
                            bankDatasPointer = bankDatasPointer - 1
                        end
                    end
                if selectedMenu == 2 then 
                    if core:isInSlot(sx*0.498, sy*0.455+sy*0.04, sx*0.2, sy*0.201) then 
                        if transactionsPointer > 0 then 
                            transactionsPointer = transactionsPointer - 1
                        end
                    end
                elseif selectedMenu == 3 then 
                    if core:isInSlot(sx*0.498, sy*0.455+sy*0.04, sx*0.2, sy*0.201) then 
                        if transferPointer > 0 then 
                            transferPointer = transferPointer - 1
                        end
                    end
                end
            end
        elseif tonumber(key) then 
            if panelType == 1 then 
                if utalasShowing then 
                    if string.len(transferTo[1]) == 4 then 
                        if string.len(transferTo[2]) == 4 then 
                            if string.len(transferTo[3]) == 4 then 
                                if string.len(transferTo[4]) == 4 then 
                                else
                                    transferTo[4] = transferTo[4]..key 
                                end
                            else
                                transferTo[3] = transferTo[3]..key 
                            end
                        else
                            transferTo[2] = transferTo[2]..key 
                        end
                    else
                        transferTo[1] = transferTo[1]..key 
                    end
                    --outputChatBox(key)
                end
            end
        elseif key == "backspace" then 
            if panelType == 1 then 
                if utalasShowing then 
                    if string.len(transferTo[4]) == 0 then 
                        if string.len(transferTo[3]) == 0 then 
                            if string.len(transferTo[2]) == 0 then 
                                if string.len(transferTo[1]) == 0 then 
                                else
                                    transferTo[1] = transferTo[1]:gsub("[^\128-\191][\128-\191]*$", "") 
                                    return
                                end
                            else
                                transferTo[2] = transferTo[2]:gsub("[^\128-\191][\128-\191]*$", "") 
                                return
                            end
                        else
                            transferTo[3] = transferTo[3]:gsub("[^\128-\191][\128-\191]*$", "") 
                            return
                        end
                    else
                        transferTo[4] = transferTo[4]:gsub("[^\128-\191][\128-\191]*$", "") 
                        return
                    end
                else
                    closePanel()
                end
            else
                closePanel()
            end
        end
    end
end

function showPanel()
    pintext = ""
    moneytext = ""
    moneytext2 = ""

    tick = getTickCount()
    animState = "open"
    addEventHandler("onClientRender", root, panelRender)
    addEventHandler("onClientKey", root, panelKey)
    createBankPanelDatas()
    setElementData(localPlayer,"inBank",true)
end
--showPanel()

function closePanel()
    tick = getTickCount()
    animState = "close"
    setTimer(function() removeEventHandler("onClientRender", root, panelRender) activePed = false end, 250, 1)
    removeEventHandler("onClientKey", root, panelKey)

    if selectedATMSerial then 
        chat:sendLocalMeAction("kivett egy bankkártyát az ATM-ből.")
    end
    selectedATMSerial = false
    activePed = false
    setElementData(localPlayer,"inBank",false)
end

addEventHandler("onClientClick", root, function(key, state, _, _, _, _, _, element)
    if key == "right" and state == "up" then 
        if element then 
            if getElementData(element, "isBankPed") then 
                if core:getDistance(localPlayer, element) < 4 then 
                    if not activePed then 
                        showPanel()
                        panelType = 1
                        activePed = element
                        selectedATMSerial = false
                    end
                end
            elseif getElementData(element, "atm:id") then 
                if getElementData(element, "atm:working") then
                    outputChatBox(core:getServerPrefix("server", "ATM", 2).."Húzz rá egy bankkártyát!", 255, 255, 255, true)
                else
                    outputChatBox(core:getServerPrefix("red-dark", "ATM", 2).."Ez az ATM üzemen kívül van!", 255, 255, 255, true)
                end
            end
        end
    end
end)

function openATM(serial, object)
    if not activePed then 
        createBankPanelDatas()

        if bankAccounts[serial] then 
            activePed = object
            showPanel()
            panelType = 2
            atmState = 1
            selectedATMSerial = serial  
            chat:sendLocalMeAction("behelyzett egy bankkártyát az ATM-be.")
        else
            infobox:outputInfoBox("Nincs ilyen bankszámla létrehozva!", "error")
        end
    end
end

addCommandHandler("nearbyatms", function(cmd)
    if getElementData(localPlayer, "user:admin") > 4 then 
        if getElementData(localPlayer, "user:aduty") then 
            local nearbyATMS = {}
            for k, v in ipairs(getElementsByType("object")) do 
                if getElementData(v, "atm:id") then 
                    if core:getDistance(localPlayer, v) < 10 then 
                        table.insert(nearbyATMS, v)
                    end
                end
            end

            if #nearbyATMS > 0 then
                outputChatBox(core:getServerPrefix("server", "ATM", 2).."Közeledben lévő ATM-ek:", 255, 255, 255, true)
                for k, v in ipairs(nearbyATMS) do 
                    outputChatBox(core:getServerPrefix("server", "ATM", 3).."ID: "..color..getElementData(v, "atm:id").."#ffffff, Távolság: "..color..math.floor(core:getDistance(localPlayer, v)).."#ffffff yard.", 255, 255, 255, true)
                end
            else
                outputChatBox(core:getServerPrefix("red-dark", "ATM", 2).."Nincs a közeledben egyetlen ATM sem. ", 255, 255, 255, true)
            end
        end
    end
end)    

addCommandHandler("delatm", function(cmd, id)
    if getElementData(localPlayer, "user:admin") >= 7 then
        if tonumber(id) then 
            local volt = false
            for k, v in ipairs(getElementsByType("object")) do 
                if getElementData(v, "atm:id") == tonumber(id) then 
                    volt = v 
                    break 
                end
            end

            if volt then 
                triggerServerEvent("bank > delATM", resourceRoot, volt)
            else
                outputChatBox(core:getServerPrefix("red-dark", "ATM", 2).."Nincs ilyen azonosítóval rendelkező ATM.", 255, 255, 255, true)
            end
        else
            outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [ID]", 255, 255, 255, true)
        end
    end
end)

function ReverseTable(t)
    local reversedTable = {}
    local itemCount = #t
    for k, v in ipairs(t) do
        reversedTable[itemCount + 1 - k] = v
    end
    return reversedTable
end

function countPlayerAccounts()
    local count = 0 

    local charID = getElementData(localPlayer, "char:id")
    for k, v in pairs(bankAccounts) do 
        if v then 
            if v[2] == charID then 
                count = count + 1
            end
        end
    end
    return count
end

function playerHasMainAccount()
    local mainAccount = false

    local charID = getElementData(localPlayer, "char:id")
    for k, v in pairs(bankAccounts) do 
        if v then 
            if v[2] == charID then 
                if v[4] == 1 then 
                    mainAccount = k
                    break
                end
            end
        end
    end
    return mainAccount
end

-- atm robbery

exports.oCompiler:loadCompliedModel(17128, "C4FdGgC5J-@5cECm", ":oBank/files/flexdff.originalmodel", ":oBank/files/flextxd.originalmodel")

local flexInUse = false
local flexObj = nil
local flexTimer = nil
local activeATM = nil

addEventHandler("onClientKey", root, function(key, state)
    if key == "mouse1" then 
        if state then
            if getElementData(localPlayer, "char:flexInUse") then 
                for k, v in pairs(getElementsByType("object", resourceRoot, true)) do 
                    if getElementData(v, "atm:id") then 
                        if getElementData(v, "atm:working") then 
                            if core:getDistance(v, localPlayer) < 1 then
                                if exports.oDashboard:isPlayerFactionTypeMember({4, 5}) then
                                    if exports.oDashboard:getOnlineFactionTypeMemberCount({1}) < 2 then -- > jel kell ide
                                        flexObj = v 
                                        flexInUse = true
                                        triggerServerEvent("bank > atmRob > setPedAnimation", resourceRoot, "sword", "sword_idle")    

                                        if not getElementData(flexObj, "atm:robStart") then 
                                            setElementData(flexObj, "atm:robStart", true)
                                            triggerServerEvent("factionScripts > cctv > sendMessage", root, core:getServerPrefix("blue-light-2", "ATM Rablás", 3).."Elkezdtek rabolni egy ATM-et, itt: "..color..getZoneName(getElementPosition(localPlayer)).."#ffffff.")
                                            local pos = Vector3(getElementPosition(localPlayer))
                                            blip = createBlip(pos.x, pos.y, pos.z, 26)
                                            setElementData(blip, "blip:name", "ATM rablás")

                                        end

                                        flexTimer = setTimer(function()
                                            local hp = getElementData(flexObj, "atm:hp")

                                            if hp > 0 then
                                                setElementData(flexObj, "atm:hp", getElementData(flexObj, "atm:hp") - 1)
                                                setElementData(localPlayer, "atmRobbery:flexing", true)
                                            else
                                                triggerServerEvent("bank > atmRob > atmFlexed", resourceRoot, flexObj)

                                                activeATM = flexObj 
                                                
                                                flexInUse = false 
                                                flexObj = nil 
                                                triggerServerEvent("bank > atmRob > setPedAnimation", resourceRoot, "", "") 
                                                
                                                if isTimer(flexTimer) then 
                                                    killTimer(flexTimer)
                                                end

                                                setElementData(localPlayer, "atmRobbery:flexing", false)

                                                destroyElement(blip)
                                            end
                                        end, 1000, 0)                    
                                        break
                                    else
                                        outputChatBox(core:getServerPrefix("red-dark", "ATM", 2).."Nincs fent elég rendvédelmi tag. (2)", 255, 255, 255, true)
                                    end
                                else
                                    outputChatBox(core:getServerPrefix("red-dark", "ATM", 2).."Csak illegális frakció tagjaként tudod elkezdeni a rablást.", 255, 255, 255, true)
                                end
                            end
                        end
                    end
                end
            end
        else
            if flexInUse then 
                flexInUse = false 
                flexObj = nil 
                triggerServerEvent("bank > atmRob > setPedAnimation", resourceRoot, "", "") 
                setElementData(localPlayer, "atmRobbery:flexing", false)
                
                if isTimer(flexTimer) then 
                    killTimer(flexTimer)
                end
            end
        end
    end
end)

function renderATMRobPanel()
    local casettes = getElementData(activeATM, "atm:moneyCasettes") or 4

    if casettes > 0 then
        dxDrawRectangle(sx*0.5 - sx*0.13/2,  sy*0.8, sx*0.13, sy*0.08, tocolor(30, 30, 30, 200))
        dxDrawText("Pénzkazetták: "..color..casettes.."#ffffffdb \n A kazetta kivételéhez\n nyomd meg az "..color.."[E] #ffffffgombot.", sx*0.5 - sx*0.13/2,  sy*0.8, sx*0.5 - sx*0.13/2 + sx*0.13,  sy*0.8 + sy*0.08, tocolor(255, 255, 255, 255), 0.85/myX*sx, fonts["condensed-12"], "center", "center", false, false, false, true)
        dxDrawRectangle(sx*0.5 - sx*0.13/2,  sy*0.8 + sy*0.078, sx*0.13 * (casettes/4), sy*0.002, tocolor(r, g, b, 255))
    end
end

local isPickUp = false
function removeMoneyCasette()
    local casettes = getElementData(activeATM, "atm:moneyCasettes") or 4

    if casettes > 0 then 
        if not isPickUp then 
            if exports.oInventory:getAllItemWeight() + 4 <= 20 then
                chat:sendLocalMeAction("elkezd kivenni egy pénzkazettát az ATM-ből.")
                exports.oInventory:giveItem(44, 1, 1, 0)
                setElementData(localPlayer, "atmRob:hasMoneyCaset", true)
                isPickUp = true
                setElementData(activeATM, "atm:moneyCasettes", casettes - 1)
                setElementFrozen(localPlayer, true)
                triggerServerEvent("bank > atmRob > setPedAnimation", resourceRoot, "rob_bank", "cat_safe_rob")    

                setTimer(function()
                    chat:sendLocalDoAction("kivett egy pénzkazettát.")
                    triggerServerEvent("bank > atmRob > setPedAnimation", resourceRoot, "", "")    
                    isPickUp = false
                    setElementFrozen(localPlayer, false)
                end, 15000, 1)
            else
                outputChatBox(core:getServerPrefix("red-dark", "ATM", 2).."Nem fér el nálad a pénzkazetta!", 255, 255, 255, true)
            end
        end
    end
end

addEventHandler("onClientColShapeHit", resourceRoot, function(player, mdim)
    if player == localPlayer and mdim then 
        if getElementData(source, "atm:isRobberyCol") then 
            activeATM = source
            addEventHandler("onClientRender", root, renderATMRobPanel)
            bindKey("e", "up", removeMoneyCasette)
        end
    end
end)

addEventHandler("onClientColShapeLeave", resourceRoot, function(player, mdim)
    if player == localPlayer and mdim then 
        if getElementData(source, "atm:isRobberyCol") then 
            activeATM = nil
            removeEventHandler("onClientRender", root, renderATMRobPanel)
            unbindKey("e", "up", removeMoneyCasette)
        end
    end
end)

local sparkTimers = {}
local flexSounds = {}
addEventHandler("onClientElementDataChange", root, function(data, old, new)
    if data == "atmRobbery:flexing" then 
        if new == true then 
            local player = source

            local x2, y2, z2 = getElementPosition(getElementData(player, "activeFlexObject"))
            local x1, y1, z1 = getElementPosition(player)

            setSoundMaxDistance(playSound3D("files/flex_start.mp3", x1, y1, z1), 10)

            if isElement(flexSounds[source]) then 
                destroyElement(flexSounds[source])
            end

            setTimer(function()
                if getElementData(player, "atmRobbery:flexing") then
                    flexSounds[player] = playSound3D("files/flex.mp3", x1, y1, z1, true)
                    setSoundMaxDistance(flexSounds[player], 10)
                end
            end, 500, 1)
           

            sparkTimers[source] = setTimer(function()
                x2, y2, z2 = getElementPosition(getElementData(player, "activeFlexObject"))
                x1, y1, z1 = getElementPosition(player)

                fxAddSparks( x2, y2, z2, 0, -(y2 - y1), 0, 1.0, 20, 0, 0, 0, false, 1, math.random(8, 20)/10)
            end, 50, 0)
        else
            if isTimer(sparkTimers[source]) then 
                killTimer(sparkTimers[source])
            end

            if isElement(flexSounds[source]) then 
                destroyElement(flexSounds[source])
            end

            local x1, y1, z1 = getElementPosition(source)
            setSoundMaxDistance(playSound3D("files/flex_end.mp3", x1, y1, z1), 10)
        end
    end

end)

local streamedATMS = {}

addEventHandler("onClientRender", root, function()
    for k, v in pairs(streamedATMS) do 
        if v and isElement(k) then 
            if core:getDistance(localPlayer, k) <= 3 then
                local posX, posY, posZ = getElementPosition(k)

                local drawX, drawY = getScreenFromWorldPosition(posX, posY, posZ + 1)

                if drawX and drawY then 
                    local hp = getElementData(k, "atm:hp") 
                    local inWork = getElementData(k, "atm:working")

                    if inWork then
                        if getElementData(localPlayer, "char:flexInUse") then 
                            dxDrawRectangle(drawX - 100, drawY, 200, 10, tocolor(30, 30, 30, 100))
                            dxDrawRectangle((drawX - 100) + 2, drawY + 2, 200 - 4, 10 - 4, tocolor(30, 30, 30, 100))
                            dxDrawRectangle((drawX - 100) + 2, drawY + 2, (200 - 4) * (hp / 100), 10 - 4, tocolor(237, 73, 62, 200))
                        end
                    else
                        dxDrawImage(drawX - 25 - 1, drawY - 60 - 1, 50 + 2, 50 + 2, "files/warn.png", 0, 0, 0, tocolor(0, 0, 0, 255))
                        dxDrawImage(drawX - 25, drawY - 60, 50, 50, "files/warn.png", 0, 0, 0, tocolor(237, 73, 62, 255))
                        core:dxDrawShadowedText("Üzemen kívül!", drawX - 100, drawY, drawX - 100 + 200, drawY + 10, tocolor(237, 73, 62, 255), tocolor(0, 0, 0, 255), 1, fonts["condensed-12"], "center", "center")
                    end
                end
            end
        end
    end
end)

addEventHandler("onClientElementStreamIn", resourceRoot, function()
    setObjectBreakable(source, false)

    if getElementData(source, "atm:id") then 
        streamedATMS[source] = true
    end
end)

addEventHandler("onClientElementStreamOut", resourceRoot, function()
    if streamedATMS[source] then 
        streamedATMS[source] = false
    end
end)