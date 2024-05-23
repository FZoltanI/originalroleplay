--Script by theMark
local sx, sy = guiGetScreenSize()
local zoom = math.min(1,0.75 + (sx - 1024) * (1 - 0.75) / (1600 - 1024))
function res(value) return value * zoom end
function resFont(value) return math.floor(res(value)) end
local ticketShow = false
local signedText = ""

local font = exports.oFont:getFont("bebasneue", resFont(12))

local amountGui = GuiEdit(-1000, -1000, 0, 0, "", false)
amountGui.maxLength = 5
local carTypeGui = GuiEdit(-1000, -1000, 0, 0, "", false)
local carPlateGui = GuiEdit(-1000, -1000, 0, 0, "", false)
local perpetratorGui = GuiEdit(-1000, -1000, 0, 0, "", false)
local penaltyGui = GuiEdit(-1000, -1000, 0, 0, "", false)
carTypeGui.maxLength = 10
carPlateGui.maxLength = 10
perpetratorGui.maxLength = 23
penaltyGui.maxLength = 10
local carTypeDefText = ""
local penaltyGuiDefText = ""
local carPlateDefText = ""
local perpetratorGuiDefText = ""
local ticketGuis = {amountGui, carTypeGui, carPlateGui, perpetratorGui, penaltyGui}

function drawText(text, x, y, w, h, ...)
    if text then
        if x and y and w and h then
            return dxDrawText(text, x, y, (x + w), (y + h), ...)
        end
    end
    return false
end

function renderTicket()
    local realTime = getRealTime()

    local amountGuiText = tonumber(amountGui.text) or "0"
    local carTypeGuiText = ticketGuis[2].text
    local carPlateGuiText = ticketGuis[3].text
    local perpetratorGuiText = ticketGuis[4].text

    if ticketGuis[2].text == "" then
        carTypeDefText = "Jármű és típusa"
    else
        carTypeDefText = carTypeGuiText
    end

    if ticketGuis[3].text == "" then
        carPlateDefText = "Jármű rendszáma"
    else
        carPlateDefText = carPlateGuiText
    end

    if ticketGuis[4].text == "" then
        perpetratorGuiDefText = "Elkövető"
    else
        perpetratorGuiDefText = perpetratorGuiText
    end


    if ticketGuis[5].text == "" then
        penaltyGuiDefText = "Büntetés"
    else
        penaltyGuiDefText = ticketGuis[5].text
    end

    dxDrawImage(sx / 2 - res(500) / 2, sy / 2 - res(700) / 2, res(500), res(700), "assets/ticket.png")


    if ticketGuis[4].text == "" then
        signedText = "Elkövető aláírása"
    else
        signedText = perpetratorGuiText
    end


    dxDrawRectangle(sx / 2 - res(345) / 2, sy / 2 + res(40) / 2, res(173), res(20), tocolor(255, 11, 11, 100)) --bal
    dxDrawRectangle(sx / 2 + res(5) / 2, sy / 2 + res(40) / 2, res(173), res(20), tocolor(255, 11, 11, 100)) -- jobb

    -- dxDrawRectangle(sx / 2 - 300 / 2, sy - 150, 300, 10, tocolor(255, 11, 11, 100)) -- jobb
    drawText("Csekk kiadása", sx / 2 - res(300) / 2, sy / 2 + res(590) / 2, res(300), res(10), tocolor(0, 0, 0), 1, font, "center", "center")
    drawText(localPlayer.name, sx / 2 + res(65) / 2, sy / 2 + res(360) / 2, res(173), res(10), tocolor(0, 0, 0), 1, font, "center", "center") -- büntető aláírása
    drawText(signedText, sx / 2 - res(395) / 2, sy / 2 + res(360) / 2, res(173), res(10), tocolor(0, 0, 0), 1, font, "center", "center") -- elkövető aláírás

    --elkövető, és büntetés!
    drawText(perpetratorGuiDefText, sx / 2 - res(345) / 2, sy / 2 + res(40) / 2, res(173), res(20), tocolor(0, 0, 0), 1, font, "center", "center")

    -- dxDrawRectangle(500, 500, 200, 40, tocolor(255, 88, 88))

    drawText(amountGuiText .. "$", sx / 2 - res(500) / 2, sy / 2 - res(435) / 2, res(500), res(20), tocolor(0, 0, 0), 1, font, "center", "center")
    drawText(carTypeDefText, sx / 2 - res(350) / 2, sy / 2 - res(249) / 2, res(173), res(20), tocolor(0, 0, 0), 1, font, "center", "center")
    drawText(carPlateDefText, sx / 2 + res(5) / 2, sy / 2 - res(249) / 2, res(173), res(20), tocolor(0, 0, 0), 1, font, "center", "center")
    -- automatikus kitöltés!!!!
    drawText(exports.oCore:getDate("year") .. "." .. exports.oCore:getDate("month") .. "." .. exports.oCore:getDate("monthday"), sx / 2 - 350 / 2, sy / 2 - 108 / 2, 173, 20, tocolor(0, 0, 0), 1, font, "center", "center")
    drawText(getZoneName(localPlayer.position), sx / 2 + res(5) / 2, sy / 2 - res(108) / 2, res(173), res(20), tocolor(0, 0, 0), 1, font, "center", "center")

    drawText(penaltyGuiDefText, sx / 2 + res(5) / 2, sy / 2 + res(40) / 2, res(173), res(20), tocolor(0, 0, 0), 1, font, "center", "center")
end
-- addEventHandler("onClientRender", root, renderTicket)


addCommandHandler("ticket2", function()
    -- if not exports.oDashboard:isPlayerFactionMember(1) or not exports.oDashboard:isPlayerFactionMember(17) then return end
    if ticketShow then
        removeEventHandler("onClientRender", root, renderTicket)
        ticketShow = false
        ticketGuis[1].text = ""
        ticketGuis[2].text = ""
        ticketGuis[3].text = ""
        ticketGuis[4].text = ""
        ticketGuis[5].text = ""
        -- showCursor(false)
        -- GuiElement.setInputEnabled(false)
    else
        removeEventHandler("onClientRender", root, renderTicket)
        addEventHandler("onClientRender", root, renderTicket)
        ticketShow = true
    end
end, false, false)


addEventHandler("onClientClick", root, function(button, state)
    if button == "left" and state == "down" then
        if exports.oCore:isInSlot(sx / 2 - res(300) / 2, sy / 2 + res(590) / 2, res(300), res(10)) then
            for key, value in ipairs(ticketGuis) do
                local targetPlayer = exports.oCore:getPlayerFromPartialName(localPlayer, perpetratorGui.text:gsub(" ", "_"), 0, 0)
                if not targetPlayer then return outputChatBox(exports.oCore:getServerPrefix("servercolor", 1) .. "Nem található ilyen játékos!", 255, 255, 255, true) end
                if value.text == "" then
                    return outputChatBox(exports.oCore:getServerPrefix("servercolor", 1) .. "Nincs minden mező kitöltve!", 255, 255, 255, true)
                    -- break
                else
                    if getDistanceBetweenPoints3D(localPlayer.position.x, localPlayer.position.y, localPlayer.position.z, targetPlayer.position.x, targetPlayer.position.y, targetPlayer.position.z) < 2 then
                        triggerServerEvent("oPayTicket2", localPlayer, localPlayer, perpetratorGui.text:gsub(" ", "_"), amountGui.text)
                        removeEventHandler("onClientRender", root, renderTicket)
                        ticketShow = false
                        ticketGuis[1].text = ""
                        ticketGuis[2].text = ""
                        ticketGuis[3].text = ""
                        ticketGuis[4].text = ""
                        ticketGuis[5].text = ""
                        -- showCursor(false)
                        -- GuiElement.setInputEnabled(false)
                        break
                    else 
                        outputChatBox(exports.oCore:getServerPrefix("servercolor", 1) .. "A játékos túl messze van tőled!", 255, 255, 255, true)
                        break
                    end
                end
            end
        end
    end
end)


addEventHandler("onClientClick", root, function(button, state)
    if button == "left" and state == "down" then
        if ticketShow then
            if exports.oCore:isInSlot(sx / 2 - res(500) / 2, sy / 2 - res(435) / 2, res(500), res(20)) then
                ticketGuis[1]:bringToFront()
            elseif exports.oCore:isInSlot(sx / 2 - 350 / 2, sy / 2 - 249 / 2, 173, 20) then
                -- if ticketGuis[2].text == "Jármű és típusa" then
                --     ticketGuis[2].text = ""
                -- end
                ticketGuis[2]:bringToFront()
            elseif exports.oCore:isInSlot(sx / 2 + res(5) / 2, sy / 2 - res(249) / 2, res(173), res(20)) then
                ticketGuis[3]:bringToFront()
            elseif exports.oCore:isInSlot(sx / 2 - res(345) / 2, sy / 2 + res(40) / 2, res(173), res(20)) then
                ticketGuis[4]:bringToFront()
            elseif exports.oCore:isInSlot(sx / 2 + res(5) / 2, sy / 2 + res(40) / 2, res(173), res(20)) then
                ticketGuis[5]:bringToFront()
            end
            -- GuiElement.setInputEnabled(true)
        end
    end
end)