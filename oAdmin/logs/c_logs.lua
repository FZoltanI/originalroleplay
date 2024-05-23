local sx, sy = guiGetScreenSize()
local showing = false

local font = {exports.oFont:getFont("condensed", 18), exports.oFont:getFont("roboto-light", 14)}

local dp_names = {
    money = "Pénz utalás",
    bank = "Bank művelet",
    carshop = "Jármű vétel",
    vehicle = "Jármű átírás",
    admincmd = "Admin parancsok"
}

local sections = {
    "money",
    "bank",
    "carshop",
    "vehicle",
    "admincmd",
}

local dropdown = {sections[1], false}

local input = {"", "Játékos neve", false}
local tickCount = getTickCount()

local logTable = {
    money = {},
    bank = {},
    carshop = {},
    vehicle = {},
    admincmd = {}
}

local importantCommands = {
    ["unjail"] = true,
    ["fixveh"] = true,
    ["givelicense"] = true,
    ["delplayeritem"] = true,
    ["setpp"] = true,
    ["givepp"] = true,
    ["setmoney"] = true,
    ["givemoney"] = true,
    ["makeveh"] = true,
    ["delveh"] = true,

    ["createinterior"] = true,
    ["delinterior"] = true,
    ["setinteriorname"] = true,
    ["setinteriorcost"] = true,
    ["asellint"] = true,

    ["oban"] = true,
    ["unban"] = true,
    ["setvehplatetext"] = true,
    ["removeplayerfromfaction"] = true,
    ["removefromfaction"] = true,
    ["giveitem"] = true,
    ["setfactionleader"] = true,
    ["removefromallfaction"] = true,

    ["delelevator"] = true,
    ["addelevator"] = true,

    ["setaccountstate"] = true,
    ["setalevel"] = true,

    ["clearadminstats"] = true,
}

addEventHandler("onClientRender", getRootElement(), function()
    if showing then
        logCount = #logTable[dropdown[1]]

        dxDrawRectangle(sx/2 - 350, sy/2 - 250, 700, 485, tocolor(30, 30, 30, 255))
        --dxDrawRectangle(sx/2 - 345, sy/2 - 245, 690, 475, tocolor(0, 0, 0, 100))

        dxDrawRectangle(sx/2 - 345, sy/2 - 245, 690, 50, tocolor(34, 34, 34, 255))

        dxDrawText("Player Log Browser", sx/2 - 345, sy/2 - 245, sx/2 + 345, sy/2 - 195, tocolor(255, 255, 255), 1, font[1], "center", "center")

        dxDrawRectangle(sx/2 - 250, sy/2 - 180, 200, 45, tocolor(40, 40, 40, isCursorHover(sx/2 + 50, sy/2 - 180, 200, 45) and 130 or 100))

        local text = input[1]..((getTickCount() - tickCount < 500 and input[3]) and "|" or "")

        dxDrawText((input[1] ~= "" or input[3]) and text or input[2], sx/2 - 240, sy/2 - 180, sx/2 - 60, sy/2 - 135, tocolor(255, 255, 255, (input[1] ~= "" or input[3]) and 255 or 200), 1, font[2], "left", "center")

        if foundCharacter and foundCharacter ~= 0 then
            dxDrawText("Játékos megtalálva! (#"..foundCharacter..")", sx/2 - 240, sy/2 - 130, sx/2 - 60, sy/2 - 115, tocolor(0, 255, 0), 1, "default-bold", "center", "center")
        elseif foundCharacter == 0 then
            dxDrawText("Nincs játékos ilyen névvel!", sx/2 - 240, sy/2 - 130, sx/2 - 60, sy/2 - 115, tocolor(255, 0, 0), 1, "default-bold", "center", "center")
        end

        dxDrawRectangle(sx/2 + 50, sy/2 - 180, 200, 45, tocolor(40, 40, 40, isCursorHover(sx/2 + 50, sy/2 - 180, 200, 45) and 130 or 100))

        dxDrawText(dp_names[dropdown[1]], sx/2 + 60, sy/2 - 180, sx/2 + 240, sy/2 - 135, tocolor(255, 255, 255, 255), 1, font[2], "left", "center")

        dxDrawRectangle(sx/2 - 345, sy/2 - 110, 690, 40, tocolor(34, 34, 34, 255))

        if dropdown[1] == sections[1] then
            dxDrawText("Pénzt küldte", sx/2 - 345, sy/2 - 110, sx/2 - 172, sy/2 - 70, tocolor(255, 255, 255), 1, font[2], "center", "center")
            dxDrawText("Pénzt kapta", sx/2 - 172, sy/2 - 110, sx/2, sy/2 - 70, tocolor(255, 255, 255), 1, font[2], "center", "center")
            dxDrawText("Összeg", sx/2, sy/2 - 110, sx/2 + 172, sy/2 - 70, tocolor(255, 255, 255), 1, font[2], "center", "center")
            dxDrawText("Dátum", sx/2 + 172, sy/2 - 110, sx/2 + 345, sy/2 - 70, tocolor(255, 255, 255), 1, font[2], "center", "center")
            for i = 1, (logCount > 10 and 10 or logCount) do
                dxDrawRectangle(sx/2 - 345, sy/2 - 100 + i*30, 690, 30, i%2==0 and tocolor(40, 40, 40, 255) or tocolor(40, 40, 40, 100))
                dxDrawText(logTable[dropdown[1]][i+list].source, sx/2 - 345, sy/2 - 100 + i*30, sx/2 - 172, sy/2 - 70 + i*30, tocolor(255, 255, 255), 1, font[2], "center", "center")
                dxDrawText(logTable[dropdown[1]][i+list].destination, sx/2 - 172, sy/2 - 100 + i*30, sx/2, sy/2 - 70 + i*30, tocolor(255, 255, 255), 1, font[2], "center", "center")
                dxDrawText("$"..logTable[dropdown[1]][i+list].amount, sx/2, sy/2 - 100 + i*30, sx/2 + 172, sy/2 - 70 + i*30, tocolor(255, 255, 255), 1, font[2], "center", "center")
                dxDrawText(logTable[dropdown[1]][i+list].date, sx/2 + 172, sy/2 - 100 + i*30, sx/2 + 345, sy/2 - 70 + i*30, tocolor(255, 255, 255), 0.9, font[2], "center", "center")
            end
        elseif dropdown[1] == sections[2] then
            dxDrawText("Játékos", sx/2 - 345, sy/2 - 110, sx/2 - 172, sy/2 - 70, tocolor(255, 255, 255), 1, font[2], "center", "center")
            dxDrawText("Összeg", sx/2 - 172, sy/2 - 110, sx/2, sy/2 - 70, tocolor(255, 255, 255), 1, font[2], "center", "center")
            dxDrawText("Művelet", sx/2, sy/2 - 110, sx/2 + 172, sy/2 - 70, tocolor(255, 255, 255), 1, font[2], "center", "center")
            dxDrawText("Dátum", sx/2 + 172, sy/2 - 110, sx/2 + 345, sy/2 - 70, tocolor(255, 255, 255), 1, font[2], "center", "center")
            for i = 1, (logCount > 10 and 10 or logCount) do
                dxDrawRectangle(sx/2 - 345, sy/2 - 100 + i*30, 690, 30, i%2==0 and tocolor(40, 40, 40, 255) or tocolor(40, 40, 40, 100))
                dxDrawText(logTable[dropdown[1]][i+list].source, sx/2 - 345, sy/2 - 100 + i*30, sx/2 - 172, sy/2 - 70 + i*30, tocolor(255, 255, 255), 1, font[2], "center", "center")
                dxDrawText("$"..logTable[dropdown[1]][i+list].amount, sx/2 - 172, sy/2 - 100 + i*30, sx/2, sy/2 - 70 + i*30, tocolor(255, 255, 255), 1, font[2], "center", "center")
                dxDrawText(logTable[dropdown[1]][i+list].type == 1 and "Kifizetés" or "Befizetés", sx/2, sy/2 - 100 + i*30, sx/2 + 172, sy/2 - 70 + i*30, tocolor(255, 255, 255), 1, font[2], "center", "center")
                dxDrawText(logTable[dropdown[1]][i+list].date, sx/2 + 172, sy/2 - 100 + i*30, sx/2 + 345, sy/2 - 70 + i*30, tocolor(255, 255, 255), 1, font[2], "center", "center")
            end
        elseif dropdown[1] == sections[3] then
            dxDrawText("Eladó", sx/2 - 345, sy/2 - 110, sx/2 - 207, sy/2 - 70, tocolor(255, 255, 255), 1, font[2], "center", "center")
            dxDrawText("Vevő", sx/2 - 207, sy/2 - 110, sx/2 - 69, sy/2 - 70, tocolor(255, 255, 255), 1, font[2], "center", "center")
            dxDrawText("Jármű ID", sx/2 - 69, sy/2 - 110, sx/2 + 69, sy/2 - 70, tocolor(255, 255, 255), 1, font[2], "center", "center")
            dxDrawText("Ár", sx/2 + 69, sy/2 - 110, sx/2 + 207, sy/2 - 70, tocolor(255, 255, 255), 1, font[2], "center", "center")
            dxDrawText("Dátum", sx/2 + 207, sy/2 - 110, sx/2 + 345, sy/2 - 70, tocolor(255, 255, 255), 1, font[2], "center", "center")
            for i = 1, (logCount > 10 and 10 or logCount) do
                dxDrawRectangle(sx/2 - 345, sy/2 - 100 + i*30, 690, 30, i%2==0 and tocolor(40, 40, 40, 255) or tocolor(40, 40, 40, 100))
                dxDrawText(logTable[dropdown[1]][i+list].source, sx/2 - 345, sy/2 - 100 + i*30, sx/2 - 172, sy/2 - 70 + i*30, tocolor(255, 255, 255), 1, font[2], "center", "center")
                dxDrawText("$"..logTable[dropdown[1]][i+list].amount, sx/2 - 172, sy/2 - 100 + i*30, sx/2, sy/2 - 70 + i*30, tocolor(255, 255, 255), 1, font[2], "center", "center")
                dxDrawText(logTable[dropdown[1]][i+list].type == 1 and "Kifizetés" or "Befizetés", sx/2, sy/2 - 100 + i*30, sx/2 + 172, sy/2 - 70 + i*30, tocolor(255, 255, 255), 1, font[2], "center", "center")
                dxDrawText(logTable[dropdown[1]][i+list].date, sx/2 + 172, sy/2 - 100 + i*30, sx/2 + 345, sy/2 - 70 + i*30, tocolor(255, 255, 255), 1, font[2], "center", "center")
            end
        elseif dropdown[1] == sections[4] then
            dxDrawText("Játékos", sx/2 - 345, sy/2 - 110, sx/2 - 115, sy/2 - 70, tocolor(255, 255, 255), 1, font[2], "center", "center")
            dxDrawText("Jármű ID", sx/2 - 115, sy/2 - 110, sx/2 + 115, sy/2 - 70, tocolor(255, 255, 255), 1, font[2], "center", "center")
            dxDrawText("Dátum", sx/2 + 115, sy/2 - 110, sx/2 + 345, sy/2 - 70, tocolor(255, 255, 255), 1, font[2], "center", "center")
        elseif dropdown[1] == sections[5] then
            dxDrawText("Admin", sx/2 - 345, sy/2 - 110, sx/2 - 172, sy/2 - 70, tocolor(255, 255, 255), 1, font[2], "center", "center")
            dxDrawText("Játékos", sx/2 - 172, sy/2 - 110, sx/2, sy/2 - 70, tocolor(255, 255, 255), 1, font[2], "center", "center")
            dxDrawText("Parancs", sx/2, sy/2 - 110, sx/2 + 172, sy/2 - 70, tocolor(255, 255, 255), 1, font[2], "center", "center")
            dxDrawText("Dátum", sx/2 + 172, sy/2 - 110, sx/2 + 345, sy/2 - 70, tocolor(255, 255, 255), 1, font[2], "center", "center")
            for i = 1, (logCount > 10 and 10 or logCount) do
                dxDrawRectangle(sx/2 - 345, sy/2 - 100 + i*30, 690, 30, i%2==0 and tocolor(40, 40, 40, 255) or tocolor(40, 40, 40, 100))

                local textcolor = tocolor(255, 255, 255, 255)

                if importantCommands[logTable[dropdown[1]][i+list].cmd] then 
                    textcolor = tocolor(220, 0, 0, 255)
                end

                dxDrawText(logTable[dropdown[1]][i+list].source, sx/2 - 345, sy/2 - 100 + i*30, sx/2 - 172, sy/2 - 70 + i*30, textcolor, 1, font[2], "center", "center")
                dxDrawText(logTable[dropdown[1]][i+list].player, sx/2 - 172, sy/2 - 100 + i*30, sx/2, sy/2 - 70 + i*30, textcolor, 1, font[2], "center", "center")
                dxDrawText(logTable[dropdown[1]][i+list].cmd, sx/2, sy/2 - 100 + i*30, sx/2 + 172, sy/2 - 70 + i*30, textcolor, 1, font[2], "center", "center")
                dxDrawText(logTable[dropdown[1]][i+list].date, sx/2 + 172, sy/2 - 100 + i*30, sx/2 + 345, sy/2 - 70 + i*30, textcolor, 0.9, font[2], "center", "center")
            end
        end

        if dropdown[2] then
            for i = 1, #sections do
                dxDrawRectangle(sx/2 + 50, sy/2 - 180 + 45*i, 200, 45, tocolor(50, 50, 50, isCursorHover(sx/2 + 50, sy/2 - 180 + 45*i, 200, 45) and 130 or 100))
                dxDrawText(dp_names[sections[i]], sx/2 + 60, sy/2 - 180 + 45*i, sx/2 + 240, sy/2 - 135 + 45*i, tocolor(255, 255, 255, 255), 1, font[2], "left", "center")
            end
        end
    end
end)

addEventHandler("onClientClick", getRootElement(), function(button, state)
    if showing and button == "left" and state == "down" then
        guiSetInputEnabled(false)
        input[3] = false
        if isCursorHover(sx/2 - 250, sy/2 - 180, 200, 45) then
            tickCount = getTickCount()
            guiSetInputEnabled(true)
            dropdown[2] = false
            input[3] = true
        elseif isCursorHover(sx/2 + 50, sy/2 - 180, 200, 45) then
            dropdown[2] = not dropdown[2]
        elseif dropdown[2] and isCursorHover(sx/2 + 50, sy/2 - 180, 200, 270) then
            for i = 1, #sections do
                if isCursorHover(sx/2 + 50, sy/2 - 180 + 45*i, 200, 45) then
                    list = 0
                    dropdown[1] = sections[i]
                    dropdown[2] = false
                end
            end
        else
            dropdown[2] = false
        end
    end
end)

addEventHandler("onClientCharacter", getRootElement(), function(character)
    if showing and input[3] then
        input[1] = input[1]..character
    end
end)

addEventHandler("onClientKey", getRootElement(), function(button, state)
    if showing and state then
        if button == "mouse_wheel_up" then
            if list > 0 then
                list = list - 1
            end
        elseif button == "mouse_wheel_down" then
            if list < logCount - 10 then
                list = list + 1
            end
        elseif button == "backspace" then
            if input[3] then
                input[1] = input[1]:gsub("[^\128-\191][\128-\191]*$", "")
            else
                showing = false
            end
        elseif button == "enter" then
            if input[1] ~= "" then
                triggerServerEvent("server->requestLogs", localPlayer, input[1]:gsub(" ", "_"))
                logTable = {
                    money = {},
                    bank = {},
                    carshop = {},
                    vehicle = {},
                    admincmd = {}
                }
            end
        end
    end
end)

addEvent("client->serverResponse", true)
addEventHandler("client->serverResponse", localPlayer, function(data)
    if isTimer(foundTimer) then killTimer(foundTimer) end
    foundTimer = setTimer(function() foundCharacter = nil end, 5000, 1)
    if not data then
        foundCharacter = 0
        return
    elseif type(data) == "number" then
        foundCharacter = data
        return
    end

    logTable[data[1]] = data[2]
end)

addCommandHandler("playerlogs", function()
    if hasPermission(localPlayer,'playerlogs') then
        if isTimer(tickTimer) then killTimer(tickTimer) end
        list = 0
        showing = not showing

        tickTimer = setTimer(function()
            tickCount = getTickCount()
        end, 1000, 0)
    end
end)

function isCursorHover(rectX, rectY, rectW, rectH)
    if isCursorShowing() then
        local cursorX, cursorY = getCursorPosition()
        cursorX, cursorY = cursorX * sx, cursorY * sy
        return (cursorX >= rectX and cursorX <= rectX+rectW) and (cursorY >= rectY and cursorY <= rectY+rectH)
    else
        return false
    end
end