local sx, sy = guiGetScreenSize()
local myX, myY = 1768, 992

local scroll = 0
local playerDatas = {
    {"Felhasználónév", "user:name"},
    {"Felhasználó ID", "user:id"},
    {"Regisztráció dátuma", "user:registerDate"},
    {"Karakter név", "char:name"},
    {"Karakter ID", "char:id"},
    {"Játszott idő", "char:playedTime"},
    {"Skin ID", "skin"},
    {"Járművek", "vehicles"},
    {"Ingatlanok", "interiors"},
    {"Jármű slotok", "char:vehSlot"},
    {"Ingatlan slotok", "char:intSlot"},
    {"Készpénz", "char:money"},
    {"Összesített banki egyenleg", "char:allBankMoney"},
    {"Prémium Pont", "char:pp"},
    {"Kaszinó egyenleg", "char:cc"},
    {"Jelenlegi pozíció", "pos"},
    {"Munka", "char:job"},
    {"Adminisztrátor szint", "user:admin"},
    {"Adminisztrátor név", "user:adminnick"},
    {"Kickek", "dashboard:banKickJailCount"},
    {"Jailek", "dashboard:banKickJailCount"},
    {"Bannok", "dashboard:banKickJailCount"},

    -- a frakciók legyenek mindig legalul!!!!
    {"Frakciók", "factions"},
}

function renderPanel()
    dxDrawRectangle(sx*0.4, sy*0.25, sx*0.2, sy*0.4, tocolor(30, 30, 30, 150))
    dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.25 + 2/myY*sy, sx*0.2 - 4/myX*sx, sy*0.4 - 4/myY*sy, tocolor(35, 35, 35, 255))

    local startY = sy*0.255
    for i = 1, 13 do 
        local v = playerDatas[i + scroll]

        local bgColor = tocolor(30, 30, 30, 255)
        if (i+scroll) % 2 == 0 then 
            bgColor = tocolor(30, 30, 30, 150)
        end

        dxDrawRectangle(sx*0.4 + 4/myX*sx, startY, sx*0.2 - 25/myX*sx, sy*0.03, bgColor)

        if v then
            if v[2] == "fk" then 
                dxDrawText(v[1], sx*0.4 + 10/myX*sx, startY, sx*0.4 + 4/myX*sx + sx*0.2 - 30/myX*sx, startY + sy*0.03, tocolor(r, g, b, 255), 1, exports.oFont:getFont("condensed", 10.5/myX*sx), "right", "center") 
            else
                dxDrawText(v[1]..":", sx*0.4 + 10/myX*sx, startY, sx*0.4 + 4/myX*sx + sx*0.2 - 25/myX*sx, startY + sy*0.03, tocolor(255, 255, 255, 255), 1, exports.oFont:getFont("condensed", 10.5/myX*sx), "left", "center") 
            end

            if v[2] == "char:playedTime" then 
                dxDrawText(v[3][1] .. " óra " .. v[3][2] .. " perc", sx*0.4 + 10/myX*sx, startY, sx*0.4 + 4/myX*sx + sx*0.2 - 30/myX*sx, startY + sy*0.03, tocolor(r, g, b, 255), 1, exports.oFont:getFont("condensed", 10.5/myX*sx), "right", "center", false, false, false, true) 
            elseif v[2] == "dashboard:banKickJailCount" then 
                if v[1] == "Kickek" then
                    dxDrawText(tostring(v[3][2]):gsub("_", " "), sx*0.4 + 10/myX*sx, startY, sx*0.4 + 4/myX*sx + sx*0.2 - 30/myX*sx, startY + sy*0.03, tocolor(r, g, b, 255), 1, exports.oFont:getFont("condensed", 10.5/myX*sx), "right", "center", false, false, false, true) 
                elseif v[1] == "Jailek" then
                    dxDrawText(tostring(v[3][3]):gsub("_", " "), sx*0.4 + 10/myX*sx, startY, sx*0.4 + 4/myX*sx + sx*0.2 - 30/myX*sx, startY + sy*0.03, tocolor(r, g, b, 255), 1, exports.oFont:getFont("condensed", 10.5/myX*sx), "right", "center", false, false, false, true) 
                elseif v[1] == "Bannok" then
                    dxDrawText(tostring(v[3][1]):gsub("_", " "), sx*0.4 + 10/myX*sx, startY, sx*0.4 + 4/myX*sx + sx*0.2 - 30/myX*sx, startY + sy*0.03, tocolor(r, g, b, 255), 1, exports.oFont:getFont("condensed", 10.5/myX*sx), "right", "center", false, false, false, true) 
                end
            elseif v[2] == "fk" then 
                -- itt nem kell kirajzolni semmit
            else
                dxDrawText(tostring(v[3]):gsub("_", " "), sx*0.4 + 10/myX*sx, startY, sx*0.4 + 4/myX*sx + sx*0.2 - 30/myX*sx, startY + sy*0.03, tocolor(r, g, b, 255), 1, exports.oFont:getFont("condensed", 10.5/myX*sx), "right", "center", false, false, false, true) 
            end
        end

        startY = startY + sy*0.03
    end 

    local lineHeight = math.min(13 / #playerDatas, 1) 

    dxDrawRectangle(sx*0.5915, sy*0.255, sx*0.004, sy*0.39, tocolor(30, 30, 30, 150))
    dxDrawRectangle(sx*0.5915, sy*0.255 + (sy*0.39 * (lineHeight * scroll/13)), sx*0.004, sy*0.39 * lineHeight, tocolor(r, g, b, 255))

    core:dxDrawButton(sx*0.4, sy*0.65, sx*0.2, sy*0.03, r, g, b, 200, "Játékos járműveinek listázása", tocolor(255, 255, 255), 1, exports.oFont:getFont("condensed", 10.5/myX*sx), false, false)
end

function key(key, state)
    if state then 
        if key == "mouse_wheel_up" then
            if scroll > 0 then scroll = scroll - 1 end
        elseif key == "mouse_wheel_down" then 
            if playerDatas[13 + scroll + 1] then 
                scroll = scroll + 1
            end
        elseif key == "mouse1" then 
            if core:isInSlot(sx*0.4, sy*0.65, sx*0.2, sy*0.03) then 
                outputChatBox(playerDatas[4][3]:gsub("_", " ") .. " járművei: ", r, g, b)
                for k, v in ipairs(getElementsByType("vehicle")) do 
                    if getElementData(v, "veh:owner") == playerDatas[5][3] then 
                        if getElementData(v, "veh:isFactionVehice") == 0 then
                            outputChatBox(core:getServerPrefix("server", getElementData(v, "veh:id"), 3).. exports.oVehicle:getModdedVehName(getElementModel(v)) .. " | "..getVehiclePlateText(v), 255, 255, 255, true)
                        end
                    end
                end
            end
        end
    end
end

local panelState = false
function setPanelState(cmd, id)
    if not panelState then 
        if hasPermission(localPlayer,'playerstats') then
            if tonumber(id) then 
                local player = core:getPlayerFromPartialName(localPlayer, id, false, 2)

                if player then 
                    scroll = 0
                    for k, v in ipairs(playerDatas) do 
                        if v[2] == "pos" then 
                            v[3] = getZoneName(getElementPosition(player))
                        elseif v[2] == "vehicles" then 
                            local vehCount = 0 

                            for k, v in ipairs(getElementsByType("vehicle")) do 
                                if getElementData(v, "veh:isFactionVehice") == 0 then 
                                    if getElementData(v, "veh:owner") == getElementData(player, "char:id") then 
                                        vehCount = vehCount + 1
                                    end
                                end
                            end

                            v[3] = vehCount
                        elseif v[2] == "interiors" then 
                            local intCount = 0 

                            for k, v in ipairs(getElementsByType("marker")) do 
                                if getElementData(v, "dbid") then 
                                    if getElementData(v, "owner") == getElementData(player, "char:id") then 
                                        intCount = intCount + 1
                                    end
                                end
                            end

                            v[3] = intCount/2
                        elseif v[2] == "skin" then 
                            v[3] = getElementModel(player)
                        elseif v[2] == "char:job" then 
                            if (getElementData(player, v[2]) or 0) > 0 then
                                v[3] = exports.oJob:getJobName(getElementData(player, v[2]))
                            else
                                v[3] = "Munkanélküli"
                            end
                        elseif v[2] == "user:admin" then 
                            v[3] = adminColors[(getElementData(player, v[2]) or 0)]..getAdminPrefix((getElementData(player, v[2]) or 0))
                        elseif v[2] == "factions" then 
                            for key, value in ipairs(exports.oDashboard:getPlayerAllFactions(player)) do 
                                table.insert(playerDatas, {exports.oDashboard:getFactionName(value), "fk"})

                            end
                            v[3] = ""
                        else
                            v[3] = getElementData(player, v[2]) or "#f04848Nincs megjeleníthető adat!"
                        end
                    end

                    panelState = true
                    addEventHandler("onClientRender", root, renderPanel)
                    addEventHandler("onClientKey", root, key)
                end
            else
                outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [ID]", 255, 255, 255, true)
            end 
        end
    else
        panelState = false
        removeEventHandler("onClientRender", root, renderPanel)
        removeEventHandler("onClientKey", root, key)
        local count = 0
        for k, v in ipairs(playerDatas) do 
            if v[2] == "fk" then 
                count = count + 1
            end
        end

        for i = 1, count do 
            table.remove(playerDatas, #playerDatas)
        end
    end
end
addCommandHandler("playerstats", setPanelState)
addCommandHandler("stats", setPanelState)

