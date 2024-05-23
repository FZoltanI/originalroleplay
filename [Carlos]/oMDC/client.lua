local sx, sy = guiGetScreenSize()
local myX, myY = 1768, 992

local bgAlpha, bgAnimTick, bgAnimState = 0, getTickCount(), "open"
local cAlpha, cAnimTick, cAnimState = 0, getTickCount(), "open"
local page = 1

local posX, posY, width, height = 0, 0, 0, 0

local menuLinePos = 0

local mdcAccountDatas = {
    ["user"] = "",
    ["access"] = 0,  -- 1: normál, 2: admin, 3: system admin
    ["faction"] = "", -- pd: police department, sd: sheriff department, orp: adminisztrátor
    ["id"] = "", -- id
}

local clientMDCDatas = {
    ["wanted_persons"] = {
        -- név, indok, módosítás dátuma, módosítás végző felh., skinID, highDanger, id
    },

    ["wanted_cars"] = {
        -- rendszám, model, indok, szín, dátum, módosítás végző felh., id
    },

    ["penalties"] = {
        { -- police
            -- name, desc, price, id
        },

        { -- sheriff
        },
    },
}

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oFont" or getResourceName(res) == "oInfobox" or getResourceName(res) == "oDashboard" or getResourceName(res) == "oVehicle" then  
		core = exports.oCore 
        color, r, g, b = core:getServerColor()
        font = exports.oFont
        infobox = exports.oInfobox
        dashboard = exports.oDashboard
        vehicle = exports.oVehicle 
	end
end)


addEvent("mdc > syncMDCDatasWithServer", true)
addEventHandler("mdc > syncMDCDatasWithServer", root, function(datas)
    clientMDCDatas = datas
end)

-- Oldalváltozók
local penaltiesFaction = 1
local penaltiesLinePos = 0
local penaltiesMenuTick = getTickCount()
local penaltiesScroll = 0
local penaltiesListMaxCount = 8

local wantedPersonsScroll = 0
local addWantedPersonSkinID = 0
local lastSkinChange = 0
local selectedMostDanger = false
local modifyedLine = 0

local wantedCarsScroll = 0
local modifyedLineVeh = 0

local mdcUsersScroll = 0

local panelIsMoveing = false

local search_panelData = false
local search_panelOthers = false

local search_type = "veh"
local lastSearch = 0
local searchScroll = 0

local openType = "veh"
local openedPC = nil


function renderMDC()
    if openType == "veh" then
        if not getPedOccupiedVehicle(localPlayer) then closeMDC() end
    else
        if isElement(openedPC) then
            if core:getDistance(openedPC, localPlayer) > 1.5 then 
                closeMDC()
            end
        end
    end 

    if panelIsMoveing then 
        local cx, cy = getCursorPosition()

        posX, posY = cx*sx - panelIsMoveing[1], cy*sy - panelIsMoveing[2]
    end

    if bgAnimState == "open" then 
        bgAlpha = interpolateBetween(bgAlpha, 0, 0, 1, 0, 0, (getTickCount() - bgAnimTick) / 500, "Linear")
    else
        bgAlpha = interpolateBetween(bgAlpha, 0, 0, 0, 0, 0, (getTickCount() - bgAnimTick) / 500, "Linear")
    end

    if cAnimState == "open" then 
        cAlpha = interpolateBetween(cAlpha, 0, 0, 1, 0, 0, (getTickCount() - cAnimTick) / 500, "Linear")
    else
        cAlpha = interpolateBetween(cAlpha, 0, 0, 0, 0, 0, (getTickCount() - cAnimTick) / 500, "Linear")
    end

    dxDrawRectangle(posX - 2/myX*sx, posY - 2/myY*sy, width + 4/myX*sx, height + 4/myY*sy, tocolor(30, 30, 30, 125*bgAlpha))
    dxDrawRectangle(posX, posY, width, height, tocolor(35, 35, 35, 255*bgAlpha))

    if page > 1 then 
        dxDrawText("Bejelentkezve mint: #ffffff"..mdcAccountDatas["user"]..color.." #"..mdcAccountDatas["id"].." | Jogosultság típusa: #ffffff"..accessTypes[mdcAccountDatas["access"]]..color.." | Szervezet: #ffffff"..factions[mdcAccountDatas["faction"]]..color.." (Kijelentkezés)", posX + sx*0.004, posY, posX + width, posY + sy*0.03, tocolor(r, g, b, 255 * bgAlpha), 1, font:getFont("condensed", 10/myX*sx), "left", "center", false, false, false, true)
        dxDrawText(mdcPageNames[page] or "MDC", posX + sx*0.004, posY + sy*0.02, posX + width, posY + sy*0.07, tocolor(255, 255, 255, 255 * cAlpha), 1, font:getFont("bebasneue", 26/myX*sx), "left", "center")

        dxDrawRectangle(posX + width - sx*0.008, posY + sy*0.01, sx*0.0035, height - sy*0.02, tocolor(30, 30, 30, 200* bgAlpha))

        local lineHeight =  (height - sy*0.02) / (#mdcPageNames - 1)

        local startY = posY + sy*0.01
        for k, v in ipairs(mdcPageNames) do 
            if k >= 2 then 
                if k == page then 
                    if cAlpha < 0.5 then
                        dxDrawText(v, posX + width - sx*0.02, startY, posX + width - sx*0.02 + sx*0.01, startY + lineHeight, tocolor(255, 255, 255, 100 * bgAlpha), 1, font:getFont("condensed", 8/myX*sx), "center", "center", _, _, _, _, _, 270)
                    end
                    dxDrawText(v, posX + width - sx*0.02, startY, posX + width - sx*0.02 + sx*0.01, startY + lineHeight, tocolor(r, g, b, 255 * cAlpha), 1, font:getFont("condensed", 8/myX*sx), "center", "center", _, _, _, _, _, 270)
                else
                    dxDrawText(v, posX + width - sx*0.02, startY, posX + width - sx*0.02 + sx*0.01, startY + lineHeight, tocolor(255, 255, 255, 100 * bgAlpha), 1, font:getFont("condensed", 8/myX*sx), "center", "center", _, _, _, _, _, 270)
                end

                --[[local alpha = 200  -- Szaggatott háttér csík
                if k % 2 == 0 then 
                    alpha = 120
                end

                dxDrawRectangle(posX + width - sx*0.008, startY, sx*0.0035, lineHeight, tocolor(30, 30, 30, alpha * bgAlpha))]]

                startY = startY + lineHeight
            end
        end

        menuLinePos = interpolateBetween(menuLinePos, 0, 0, posY + sy*0.01 + (page - 2) * lineHeight, 0, 0, (getTickCount() - cAnimTick) / 500, "Linear")

        dxDrawRectangle(posX + width - sx*0.008, menuLinePos, sx*0.0035, lineHeight, tocolor(r, g, b, 200 * bgAlpha))
    end

    if page == 1 then -- bejelnetkező felület 
        dxDrawText("OriginalRoleplay", posX, posY, posX + width, posY + sy*0.03, tocolor(r, g, b, 255 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), "center", "center")
        dxDrawText("Mobile Data Computer", posX, posY + sy*0.02, posX + width, posY + sy*0.07, tocolor(255, 255, 255, 255 * cAlpha), 1, font:getFont("bebasneue", 24/myX*sx), "center", "center")

        if core:isInSlot(posX + sx*0.002, posY + sy*0.145, sx*0.146, sy*0.045) then 
            dxDrawRectangle(posX + sx*0.002, posY + sy*0.145, sx*0.146, sy*0.045, tocolor(r, g, b, 120 * cAlpha))
            dxDrawRectangle(posX + sx*0.002 + 2/myX*sx, posY + sy*0.145 + 2/myY*sy, sx*0.146 - 4/myX*sx, sy*0.045 - 4/myY*sy, tocolor(r, g, b, 170 * cAlpha))
        else
            dxDrawRectangle(posX + sx*0.002, posY + sy*0.145, sx*0.146, sy*0.045, tocolor(r, g, b, 100 * cAlpha))
            dxDrawRectangle(posX + sx*0.002 + 2/myX*sx, posY + sy*0.145 + 2/myY*sy, sx*0.146 - 4/myX*sx, sy*0.045 - 4/myY*sy, tocolor(r, g, b, 120 * cAlpha))
        end
        
        core:dxDrawShadowedText("Bejelentkezés", posX + sx*0.002, posY + sy*0.145, posX + sx*0.002 + sx*0.146, posY + sy*0.145 + sy*0.045, tocolor(255, 255, 255, 255 * cAlpha), tocolor(0, 0, 0, 255 * cAlpha), 1, font:getFont("condensed", 13/myX*sx), "center", "center")
    elseif page == 2 then -- áttekintés

        if openType == "veh" then
            dxDrawRectangle(posX + sx*0.005, posY + sy*0.065, sx*0.37, sy*0.245, tocolor(30, 30, 30, 120 * cAlpha))
            core:dxDrawButton(posX + sx*0.006 + sx * 0.302, posY + sy*0.067, 115/myX*sx, sy*0.035, r, g, b, 180 * cAlpha, "Mentés", tocolor(255, 255, 255, 255 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), true, tocolor(0, 0, 0, 255 * cAlpha))

            core:dxDrawButton(posX + sx*0.006, posY + sy*0.105, 649/myX*sx, sy*0.035, 3, 140, 252, 180 * cAlpha, "Járőr", tocolor(255, 255, 255, 255 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), true, tocolor(0, 0, 0, 255 * cAlpha))
            core:dxDrawButton(posX + sx*0.006, posY + sy*0.142, 649/myX*sx, sy*0.035, 87, 222, 78, 180 * cAlpha, "Pihenő", tocolor(255, 255, 255, 255 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), true, tocolor(0, 0, 0, 255 * cAlpha))
            core:dxDrawButton(posX + sx*0.006, posY + sy*0.179, 649/myX*sx, sy*0.035, 219, 42, 39, 180 * cAlpha, "Üldözés", tocolor(255, 255, 255, 255 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), true, tocolor(0, 0, 0, 255 * cAlpha))
            core:dxDrawButton(posX + sx*0.006, posY + sy*0.216, 649/myX*sx, sy*0.035, 219, 42, 39, 180 * cAlpha, "Erősítés", tocolor(255, 255, 255, 255 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), true, tocolor(0, 0, 0, 255 * cAlpha))
            core:dxDrawButton(posX + sx*0.006, posY + sy*0.253, 649/myX*sx, sy*0.035, 66, 66, 66, 180 * cAlpha, "Nincs szolgálatban", tocolor(255, 255, 255, 255 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), true, tocolor(0, 0, 0, 255 * cAlpha))

            local unitState = getElementData(getPedOccupiedVehicle(localPlayer), "mdc:unitState")
            dxDrawText("Jelenlegi állapot: "..unitState[5]..unitState[1], posX + sx*0.005, posY + sy*0.065, posX + sx*0.005 + sx*0.37, posY + sy*0.065 +  sy*0.244, tocolor(255, 255, 255, 255 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), "center", "bottom", false, false, false, true)
        else
            dxDrawImage(posX + ((width - 50/myX*sx) / 2) - 60/myX*sx, posY + sy*0.07, 120/myX*sx, 156.5/myY*sy, "pd_logo.png", 0, 0, 0, tocolor(255, 255, 255, 255 * cAlpha))
            dxDrawText("Országos Rendőr-főkapitányság", posX + sx*0.005, posY, posX + sx*0.005 + sx*0.37, posY + height - 80/myX*sx, tocolor(255, 255, 255, 255 * cAlpha), 1, font:getFont("condensed", 13/myX*sx), "center", "center", false, false, false, true)
            dxDrawText("Adatbázis", posX + sx*0.005, posY, posX + sx*0.005 + sx*0.37, posY + height - 30/myX*sx, tocolor(255, 255, 255, 100 * cAlpha), 0.8, font:getFont("condensed", 13/myX*sx), "center", "center", false, false, false, true)
        end

        dxDrawText("Legújabb körözött személy", posX + sx*0.005, posY + sy*0.32, posX + sx*0.005 + sx*0.37, posY + sy*0.33 + sy*0.02, tocolor(255, 255, 255, 255 * cAlpha), 1, font:getFont("bebasneue", 15/myX*sx), "center", "center")
        startY = posY + sy*0.35
        dxDrawRectangle(posX + sx*0.005, startY, sx*0.37, sy*0.078, tocolor(30, 30, 30, 120 * cAlpha))
        local v = clientMDCDatas["wanted_persons"][#clientMDCDatas["wanted_persons"]]
        if v then 
            dxDrawRectangle(posX + sx*0.005 + 6/myX*sx, startY + 4/myY*sy, 70/myX*sx, 70/myY*sy, tocolor(30, 30, 30, 255 * cAlpha))
            if v[5] > 0 then
                dxDrawImage(posX + sx*0.005 + 6/myX*sx, startY + 4/myY*sy, 70/myX*sx, 70/myY*sy, ":oLicenses/files/avatars/"..v[5]..".png", 0, 0, 0, tocolor(255, 255, 255, 255 * cAlpha))
            else
                dxDrawText("?", posX + sx*0.005 + 6/myX*sx, startY + 4/myY*sy, posX + sx*0.005 + 6/myX*sx + 70/myX*sx, startY + 4/myY*sy + 70/myY*sy, tocolor(237, 47, 47, 200 * cAlpha), 1, font:getFont("bebasneue", 30/myX*sx), "center", "center")
            end

            if v[6] then 
                dxDrawText(v[1] .. " (Fokozott veszély!)", posX + sx*0.05 + 2/myX*sx, startY, posX + sx*0.05 + 2/myX*sx + sx*0.37 - 12/myX*sx, startY + sy*0.04, tocolor(237, 47, 47, 255 * cAlpha), 1, font:getFont("bebasneue", 14/myX*sx), "left", "center")
            else
                dxDrawText(v[1], posX + sx*0.05 + 2/myX*sx, startY, posX + sx*0.05 + 2/myX*sx + sx*0.37 - 12/myX*sx, startY + sy*0.04, tocolor(r, g, b, 255 * cAlpha), 1, font:getFont("bebasneue", 14/myX*sx), "left", "center")
            end
            dxDrawText(v[2], posX + sx*0.05 + 2/myX*sx, startY + sy*0.03, posX + sx*0.05 + 2/myX*sx + sx*0.2, startY + sy*0.055, tocolor(255, 255, 255, 100 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), "left", "top", false, true)

            dxDrawText(v[3]..", "..color..v[4], posX + sx*0.05 + 2/myX*sx, startY + sy*0.01, posX + sx*0.05 + 2/myX*sx + sx*0.31, startY + sy*0.055, tocolor(255, 255, 255, 100 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), "right", "top", false, false, false, true)
        end

        dxDrawText("Legújabb körözött gépjármű", posX + sx*0.005, posY + sy*0.44, posX + sx*0.005 + sx*0.37, posY + sy*0.45 + sy*0.02, tocolor(255, 255, 255, 255 * cAlpha), 1, font:getFont("bebasneue", 15/myX*sx), "center", "center")
        startY = posY + sy*0.47
        local v = clientMDCDatas["wanted_cars"][#clientMDCDatas["wanted_cars"]]
        dxDrawRectangle(posX + sx*0.005, startY, sx*0.37, sy*0.078, tocolor(30, 30, 30, 120 * cAlpha))

        if v then 
            dxDrawImage(posX + sx*0.005 + 6/myX*sx, startY + 8/myY*sy, 110/myX*sx, 60/myY*sy, ":oVehicle/elements/betterVehPlate/files/1.png", 0, 0, 0, tocolor(255, 255, 255, 255 * cAlpha))
            dxDrawText(v[1], posX + sx*0.005 + 6/myX*sx, startY + 8/myY*sy, posX + sx*0.005 + 6/myX*sx + 110/myX*sx, startY + 8/myY*sy + 70/myY*sy, tocolor(51, 115, 232, 255 * cAlpha), 1, font:getFont("bebasneue", 14/myX*sx), "center", "center")

            dxDrawText(v[2], posX + sx*0.075 + 2/myX*sx, startY, posX + sx*0.05 + 2/myX*sx + sx*0.37 - 12/myX*sx, startY + sy*0.04, tocolor(r, g, b, 255 * cAlpha), 1, font:getFont("bebasneue", 14/myX*sx), "left", "center")
            dxDrawText("Szín: "..color..v[4], posX + sx*0.075 + 2/myX*sx, startY + sy*0.03, posX + sx*0.05 + 2/myX*sx + sx*0.2, startY + sy*0.055, tocolor(255, 255, 255, 100 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), "left", "top", false, false, false, true)
            dxDrawText("Körözés indoka: "..color..v[3], posX + sx*0.075 + 2/myX*sx, startY + sy*0.05, posX + sx*0.05 + 2/myX*sx + sx*0.2, startY + sy*0.055, tocolor(255, 255, 255, 100 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), "left", "top", false, false, false, true)

            dxDrawText(v[5]..", "..color..v[6], posX + sx*0.05 + 2/myX*sx, startY + sy*0.01, posX + sx*0.05 + 2/myX*sx + sx*0.31, startY + sy*0.055, tocolor(255, 255, 255, 100 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), "right", "top", false, false, false, true)
        end

    elseif page == 3 then -- körözött személyek
        dxDrawRectangle(posX + sx*0.005, posY + sy*0.065, sx*0.37, sy*0.525, tocolor(30, 30, 30, 120 * cAlpha))
        
        local scrollHeight = sy*0.398

        local wantedPersonsSearch = {}
        local searchText = core:getEditboxText("search2") or ""
        
        if not (searchText == "Keresés") then
            for k, v in ipairs(clientMDCDatas["wanted_persons"]) do 
                if string.match(string.lower(v[1]), string.lower(searchText)) then 
                    table.insert(wantedPersonsSearch, v)
                end
            end
        else
            wantedPersonsSearch = clientMDCDatas["wanted_persons"]
        end

        --dxDrawRectangle(posX + sx*0.35, posY + sy*0.023, sx*0.03, sy*0.035)
        dxDrawText("", posX + sx*0.355, posY + sy*0.023, posX + sx*0.35 + sx*0.03, posY + sy*0.023 + sy*0.035, tocolor(255, 255, 255, 255*cAlpha), 0.8, font:getFont("fontawesome2", 15/myX*sx), "left", "center")

        local startY = posY + sy*0.065 + 3/myY*sy
        for i = 1, 5 do 
            local alpha = 150
            if (i + wantedPersonsScroll) % 2 == 0 then 
                alpha = 220
            end

            
            dxDrawRectangle(posX + sx*0.005 + 2/myX*sx, startY, sx*0.37 - 12/myX*sx, sy*0.078, tocolor(35, 35, 35, alpha * cAlpha))

            if modifyedLine == i + wantedPersonsScroll then 
                core:dxDrawOutLine(posX + sx*0.005 + 2/myX*sx, startY, sx*0.37 - 12/myX*sx, sy*0.078, tocolor(r, g, b, 100 * cAlpha), 2)
            end

            local v = wantedPersonsSearch[wantedPersonsScroll + i]

            if v then 
                dxDrawRectangle(posX + sx*0.005 + 6/myX*sx, startY + 4/myY*sy, 70/myX*sx, 70/myY*sy, tocolor(30, 30, 30, 255 * cAlpha))
                if v[5] > 0 then
                    dxDrawImage(posX + sx*0.005 + 6/myX*sx, startY + 4/myY*sy, 70/myX*sx, 70/myY*sy, ":oLicenses/files/avatars/"..v[5]..".png", 0, 0, 0, tocolor(255, 255, 255, 255 * cAlpha))
                else
                    dxDrawText("?", posX + sx*0.005 + 6/myX*sx, startY + 4/myY*sy, posX + sx*0.005 + 6/myX*sx + 70/myX*sx, startY + 4/myY*sy + 70/myY*sy, tocolor(237, 47, 47, 200 * cAlpha), 1, font:getFont("bebasneue", 30/myX*sx), "center", "center")
                end

                if v[6] then 
                    dxDrawText(v[1] .. " (Fokozott veszély!)", posX + sx*0.05 + 2/myX*sx, startY, posX + sx*0.05 + 2/myX*sx + sx*0.37 - 12/myX*sx, startY + sy*0.04, tocolor(237, 47, 47, 255 * cAlpha), 1, font:getFont("bebasneue", 14/myX*sx), "left", "center")
                else
                    dxDrawText(v[1], posX + sx*0.05 + 2/myX*sx, startY, posX + sx*0.05 + 2/myX*sx + sx*0.37 - 12/myX*sx, startY + sy*0.04, tocolor(r, g, b, 255 * cAlpha), 1, font:getFont("bebasneue", 14/myX*sx), "left", "center")
                end
                dxDrawText(v[2], posX + sx*0.05 + 2/myX*sx, startY + sy*0.03, posX + sx*0.05 + 2/myX*sx + sx*0.2, startY + sy*0.055, tocolor(255, 255, 255, 100 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), "left", "top", false, true)

                dxDrawText(v[3]..", "..color..v[4], posX + sx*0.05 + 2/myX*sx, startY + sy*0.01, posX + sx*0.05 + 2/myX*sx + sx*0.31, startY + sy*0.055, tocolor(255, 255, 255, 100 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), "right", "top", false, false, false, true)

                if core:isInSlot(posX + sx*0.347, startY + sy*0.04, sx*0.02, sy*0.035) then
                    dxDrawText("", posX + sx*0.005 + 2/myX*sx, startY, posX + sx*0.005 + 2/myX*sx + sx*0.37 - 22/myX*sx, startY + sy*0.07, tocolor(66, 143, 212, 150 * cAlpha), 1, font:getFont("fontawesome2", 15/myX*sx), "right", "bottom")
                else
                    dxDrawText("", posX + sx*0.005 + 2/myX*sx, startY, posX + sx*0.005 + 2/myX*sx + sx*0.37 - 22/myX*sx, startY + sy*0.07, tocolor(66, 143, 212, 50 * cAlpha), 1, font:getFont("fontawesome2", 15/myX*sx), "right", "bottom")
                end
            end

            startY = startY + sy*0.08
        end

        if modifyedLine > 0 then 
            core:dxDrawButton(posX + sx*0.006, posY + sy*0.555, 232/myX*sx, 32/myY*sy, r, g, b, 180 * cAlpha, "Körözés módosítása", tocolor(255, 255, 255, 255 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), true, tocolor(0, 0, 0, 255 * cAlpha))
            core:dxDrawButton(posX + sx*0.006 + 234/myX*sx, posY + sy*0.555, 200/myX*sx, 32/myY*sy, 237, 47, 47, 180 * cAlpha, "Körözés visszavonása", tocolor(255, 255, 255, 255 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), true, tocolor(0, 0, 0, 255 * cAlpha))
        else
            core:dxDrawButton(posX + sx*0.006, posY + sy*0.555, 495/myX*sx, 32/myY*sy, r, g, b, 180 * cAlpha, "Körözés kiadása", tocolor(255, 255, 255, 255 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), true, tocolor(0, 0, 0, 255 * cAlpha))
        end

        if core:isInSlot(posX + sx*0.285 + 6/myX*sx, posY + sy*0.555, 30/myX*sx, 32/myY*sy) then
            dxDrawRectangle(posX + sx*0.285 + 6/myX*sx, posY + sy*0.555, 30/myX*sx, 32/myY*sy, tocolor(66, 143, 212, 120 * cAlpha))
            dxDrawRectangle(posX + sx*0.285 + 8/myX*sx, posY + sy*0.555 + 2/myY*sy, 30/myX*sx - 4/myX*sx, 32/myY*sy - 4/myY*sy, tocolor(66, 143, 212, 170 * cAlpha))

            if getKeyState("mouse1") then 
                if lastSkinChange + 100 < getTickCount() then
                    lastSkinChange = getTickCount()
                    if addWantedPersonSkinID > 0 then 
                        addWantedPersonSkinID = addWantedPersonSkinID - 1
                    else
                        addWantedPersonSkinID = #realSkins
                    end
                end
            end
        else
            dxDrawRectangle(posX + sx*0.285 + 6/myX*sx, posY + sy*0.555, 30/myX*sx, 32/myY*sy, tocolor(66, 143, 212, 100 * cAlpha))
            dxDrawRectangle(posX + sx*0.285 + 8/myX*sx, posY + sy*0.555 + 2/myY*sy, 30/myX*sx - 4/myX*sx, 32/myY*sy - 4/myY*sy, tocolor(66, 143, 212, 120 * cAlpha))
        end
        core:dxDrawShadowedText("", posX + sx*0.285 + 6/myX*sx, posY + sy*0.555, posX + sx*0.285 + 6/myX*sx + 30/myX*sx, posY + sy*0.555 + 32/myY*sy, tocolor(255, 255, 255, 255 * cAlpha), tocolor(0, 0, 0, 255 * cAlpha), 1, font:getFont("fontawesome2", 15/myX*sx), "center", "center")

        if core:isInSlot(posX + sx*0.006 + 540/myX*sx, posY + sy*0.555, 30/myX*sx, 32/myY*sy) then
            dxDrawRectangle(posX + sx*0.006 + 540/myX*sx, posY + sy*0.555, 30/myX*sx, 32/myY*sy, tocolor(66, 143, 212, 120 * cAlpha))
            dxDrawRectangle(posX + sx*0.006 + 542/myX*sx, posY + sy*0.555 + 2/myY*sy, 30/myX*sx - 4/myX*sx, 32/myY*sy - 4/myY*sy, tocolor(66, 143, 212, 170 * cAlpha))

            if getKeyState("mouse1") then 
                if lastSkinChange + 100 < getTickCount() then
                    lastSkinChange = getTickCount()
                    if addWantedPersonSkinID < #realSkins then 
                        addWantedPersonSkinID = addWantedPersonSkinID + 1
                    else
                        addWantedPersonSkinID = 0
                    end
                end
            end
        else
            dxDrawRectangle(posX + sx*0.006 + 540/myX*sx, posY + sy*0.555, 30/myX*sx, 32/myY*sy, tocolor(66, 143, 212, 100 * cAlpha))
            dxDrawRectangle(posX + sx*0.006 + 542/myX*sx, posY + sy*0.555 + 2/myY*sy, 30/myX*sx - 4/myX*sx, 32/myY*sy - 4/myY*sy, tocolor(66, 143, 212, 120 * cAlpha))
        end
        core:dxDrawShadowedText("", posX + sx*0.006 + 540/myX*sx, posY + sy*0.555, posX + sx*0.006 + 540/myX*sx + 30/myX*sx, posY + sy*0.555 + 32/myY*sy, tocolor(255, 255, 255, 255 * cAlpha), tocolor(0, 0, 0, 255 * cAlpha), 1, font:getFont("fontawesome2", 15/myX*sx), "center", "center")

        dxDrawRectangle(posX + sx*0.285 + 6/myX*sx, posY + sy*0.474, 70/myX*sx, 70/myY*sy, tocolor(30, 30, 30, 255 * cAlpha))
        if addWantedPersonSkinID > 0 then
            if fileExists(":oLicenses/files/avatars/"..realSkins[addWantedPersonSkinID]..".png") then 
                dxDrawImage(posX + sx*0.285 + 6/myX*sx, posY + sy*0.474, 70/myX*sx, 70/myY*sy, ":oLicenses/files/avatars/"..realSkins[addWantedPersonSkinID]..".png", 0, 0, 0, tocolor(255, 255, 255, 255 * cAlpha))
            else
                dxDrawText("?", posX + sx*0.285 + 6/myX*sx, posY + sy*0.474, posX + sx*0.285 + 6/myX*sx + 70/myX*sx, posY + sy*0.474 + 70/myY*sy, tocolor(237, 47, 47, 200 * cAlpha), 1, font:getFont("bebasneue", 30/myX*sx), "center", "center")
            end
        else
            dxDrawText("?", posX + sx*0.285 + 6/myX*sx, posY + sy*0.474, posX + sx*0.285 + 6/myX*sx + 70/myX*sx, posY + sy*0.474 + 70/myY*sy, tocolor(237, 47, 47, 200 * cAlpha), 1, font:getFont("bebasneue", 30/myX*sx), "center", "center")
        end

        if core:isInSlot(posX + sx*0.006 + 575/myX*sx, posY + sy*0.474, 72/myX*sx, 112/myY*sy) or selectedMostDanger then
            dxDrawRectangle(posX + sx*0.006 + 575/myX*sx, posY + sy*0.474, 72/myX*sx, 112/myY*sy, tocolor(237, 47, 47, 120 * cAlpha))
            dxDrawRectangle(posX + sx*0.006 + 577/myX*sx, posY + sy*0.474 + 2/myY*sy, 72/myX*sx - 4/myX*sx, 112/myY*sy - 4/myY*sy, tocolor(237, 47, 47, 170 * cAlpha))
        else
            dxDrawRectangle(posX + sx*0.006 + 575/myX*sx, posY + sy*0.474, 72/myX*sx, 112/myY*sy, tocolor(237, 47, 47, 100 * cAlpha))
            dxDrawRectangle(posX + sx*0.006 + 577/myX*sx, posY + sy*0.474 + 2/myY*sy, 72/myX*sx - 4/myX*sx, 112/myY*sy - 4/myY*sy, tocolor(237, 47, 47, 120 * cAlpha))
        end
        core:dxDrawShadowedText("", posX + sx*0.006 + 575/myX*sx, posY + sy*0.474, posX + sx*0.006 + 575/myX*sx + 72/myX*sx, posY + sy*0.474 + 112/myY*sy, tocolor(255, 255, 255, 255 * cAlpha), tocolor(0, 0, 0, 255 * cAlpha), 1, font:getFont("fontawesome2", 15/myX*sx), "center", "center")

        local lineHeight = math.min(5 / #clientMDCDatas["wanted_persons"], 1)
        dxDrawRectangle(posX + sx*0.371, posY + sy*0.065 + 3/myY*sy, sx*0.002, scrollHeight, tocolor(35, 35, 35, 200 * cAlpha))
        dxDrawRectangle(posX + sx*0.371, posY + sy*0.065 + 3/myY*sy + (scrollHeight * (lineHeight * wantedPersonsScroll / 5)), sx*0.002, scrollHeight * lineHeight, tocolor(r, g, b, 200 * cAlpha))

        local lengthName, lengthDesc = string.len(core:getEditboxText("kname") or ""), string.len(core:getEditboxText("kdesc") or "")

        if lengthName > penaltieLimits["kname"] then 
            dxDrawText(lengthName.."#ffffff/"..penaltieLimits["kname"], posX + sx*0.256, posY + sy*0.474, posX + sx*0.256 + sx*0.03, posY + sy*0.474 + sy*0.03, tocolor(237, 47, 47, 255 * cAlpha), 1, font:getFont("condensed", 12/myX*sx), "center", "center", _, _, _, true)
        else
            dxDrawText(lengthName.."#ffffff/"..penaltieLimits["kname"], posX + sx*0.256, posY + sy*0.474, posX + sx*0.256 + sx*0.03, posY + sy*0.474 + sy*0.03, tocolor(r, g, b, 255 * cAlpha), 1, font:getFont("condensed", 12/myX*sx), "center", "center", _, _, _, true)
        end

        if lengthDesc > penaltieLimits["kdesc"] then 
            dxDrawText(lengthDesc.."#ffffff/"..penaltieLimits["kdesc"], posX + sx*0.256, posY + sy*0.51, posX + sx*0.256 + sx*0.03, posY + sy*0.51 + sy*0.03, tocolor(237, 47, 47, 255 * cAlpha), 1, font:getFont("condensed", 12/myX*sx), "center", "center", _, _, _, true)
        else
            dxDrawText(lengthDesc.."#ffffff/"..penaltieLimits["kdesc"], posX + sx*0.256, posY + sy*0.51, posX + sx*0.256 + sx*0.03, posY + sy*0.51 + sy*0.03, tocolor(r, g, b, 255 * cAlpha), 1, font:getFont("condensed", 12/myX*sx), "center", "center", _, _, _, true)
        end
    elseif page == 4 then -- körözött járművek
        dxDrawRectangle(posX + sx*0.005, posY + sy*0.065, sx*0.37, sy*0.525, tocolor(30, 30, 30, 120 * cAlpha))
        
        local scrollHeight = sy*0.398

        local wantedCarsSearch = {}
        local searchText = core:getEditboxText("search3") or ""
        
        if not (searchText == "Keresés") then
            for k, v in ipairs(clientMDCDatas["wanted_cars"]) do 
                if string.match(string.lower(v[1]), string.lower(searchText)) then 
                    table.insert(wantedCarsSearch, v)
                end
            end
        else
            wantedCarsSearch = clientMDCDatas["wanted_cars"]
        end

        dxDrawText("", posX + sx*0.355, posY + sy*0.023, posX + sx*0.35 + sx*0.03, posY + sy*0.023 + sy*0.035, tocolor(255, 255, 255, 255*cAlpha), 0.8, font:getFont("fontawesome2", 15/myX*sx), "left", "center")

        local startY = posY + sy*0.065 + 3/myY*sy
        for i = 1, 5 do 
            local alpha = 150
            if (i + wantedCarsScroll) % 2 == 0 then 
                alpha = 220
            end

            
            dxDrawRectangle(posX + sx*0.005 + 2/myX*sx, startY, sx*0.37 - 12/myX*sx, sy*0.078, tocolor(35, 35, 35, alpha * cAlpha))

            if modifyedLineVeh == i + wantedCarsScroll then 
                core:dxDrawOutLine(posX + sx*0.005 + 2/myX*sx, startY, sx*0.37 - 12/myX*sx, sy*0.078, tocolor(r, g, b, 100 * cAlpha), 2)
            end

            local v = wantedCarsSearch[wantedCarsScroll + i]

            if v then 
                dxDrawImage(posX + sx*0.005 + 6/myX*sx, startY + 8/myY*sy, 110/myX*sx, 60/myY*sy, ":oVehicle/elements/betterVehPlate/files/1.png", 0, 0, 0, tocolor(255, 255, 255, 255 * cAlpha))
                dxDrawText(v[1], posX + sx*0.005 + 6/myX*sx, startY + 8/myY*sy, posX + sx*0.005 + 6/myX*sx + 110/myX*sx, startY + 8/myY*sy + 70/myY*sy, tocolor(51, 115, 232, 255 * cAlpha), 1, font:getFont("bebasneue", 14/myX*sx), "center", "center")

                dxDrawText(v[2], posX + sx*0.075 + 2/myX*sx, startY, posX + sx*0.05 + 2/myX*sx + sx*0.37 - 12/myX*sx, startY + sy*0.04, tocolor(r, g, b, 255 * cAlpha), 1, font:getFont("bebasneue", 14/myX*sx), "left", "center")
                dxDrawText("Szín: "..color..v[4], posX + sx*0.075 + 2/myX*sx, startY + sy*0.03, posX + sx*0.05 + 2/myX*sx + sx*0.2, startY + sy*0.055, tocolor(255, 255, 255, 100 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), "left", "top", false, false, false, true)
                dxDrawText("Körözés indoka: "..color..v[3], posX + sx*0.075 + 2/myX*sx, startY + sy*0.05, posX + sx*0.05 + 2/myX*sx + sx*0.2, startY + sy*0.055, tocolor(255, 255, 255, 100 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), "left", "top", false, false, false, true)

                dxDrawText(v[5]..", "..color..v[6], posX + sx*0.05 + 2/myX*sx, startY + sy*0.01, posX + sx*0.05 + 2/myX*sx + sx*0.31, startY + sy*0.055, tocolor(255, 255, 255, 100 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), "right", "top", false, false, false, true)

                if core:isInSlot(posX + sx*0.347, startY + sy*0.04, sx*0.02, sy*0.035) then
                    dxDrawText("", posX + sx*0.005 + 2/myX*sx, startY, posX + sx*0.005 + 2/myX*sx + sx*0.37 - 22/myX*sx, startY + sy*0.07, tocolor(66, 143, 212, 150 * cAlpha), 1, font:getFont("fontawesome2", 15/myX*sx), "right", "bottom")
                else
                    dxDrawText("", posX + sx*0.005 + 2/myX*sx, startY, posX + sx*0.005 + 2/myX*sx + sx*0.37 - 22/myX*sx, startY + sy*0.07, tocolor(66, 143, 212, 50 * cAlpha), 1, font:getFont("fontawesome2", 15/myX*sx), "right", "bottom")
                end
            end

            startY = startY + sy*0.08
        end

        if modifyedLineVeh > 0 then 
            core:dxDrawButton(posX + sx*0.006, posY + sy*0.555, 448/myX*sx, 32/myY*sy, r, g, b, 180 * cAlpha, "Körözés módosítása", tocolor(255, 255, 255, 255 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), true, tocolor(0, 0, 0, 255 * cAlpha))
            core:dxDrawButton(posX + sx*0.006 + 450/myX*sx, posY + sy*0.555, 200/myX*sx, 32/myY*sy, 237, 47, 47, 180 * cAlpha, "Körözés visszavonása", tocolor(255, 255, 255, 255 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), true, tocolor(0, 0, 0, 255 * cAlpha))
        else
            core:dxDrawButton(posX + sx*0.006, posY + sy*0.555, 650/myX*sx, 32/myY*sy, r, g, b, 180 * cAlpha, "Körözés kiadása", tocolor(255, 255, 255, 255 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), true, tocolor(0, 0, 0, 255 * cAlpha))
        end

        local lineHeight = math.min(5 / #clientMDCDatas["wanted_cars"], 1)
        dxDrawRectangle(posX + sx*0.371, posY + sy*0.065 + 3/myY*sy, sx*0.002, scrollHeight, tocolor(35, 35, 35, 200 * cAlpha))
        dxDrawRectangle(posX + sx*0.371, posY + sy*0.065 + 3/myY*sy + (scrollHeight * (lineHeight * wantedCarsScroll / 5)), sx*0.002, scrollHeight * lineHeight, tocolor(r, g, b, 200 * cAlpha))

        local lengthType, lengthDesc, lengthColor, lengthPlate = string.len(core:getEditboxText("kjtype") or ""), string.len(core:getEditboxText("kjdesc") or ""), string.len(core:getEditboxText("kjcolor") or ""), string.len(core:getEditboxText("kjplate") or "")

        if lengthType > penaltieLimits["kjtype"] then 
            dxDrawText(lengthType.."#ffffff/"..penaltieLimits["kjtype"], posX + sx*0.43, posY + sy*0.474, posX + sx*0.256 + sx*0.03, posY + sy*0.474 + sy*0.03, tocolor(237, 47, 47, 255 * cAlpha), 1, font:getFont("condensed", 12/myX*sx), "center", "center", _, _, _, true)
        else
            dxDrawText(lengthType.."#ffffff/"..penaltieLimits["kjtype"], posX + sx*0.43, posY + sy*0.474, posX + sx*0.256 + sx*0.03, posY + sy*0.474 + sy*0.03, tocolor(r, g, b, 255 * cAlpha), 1, font:getFont("condensed", 12/myX*sx), "center", "center", _, _, _, true)
        end

        if lengthColor > penaltieLimits["kjcolor"] then 
            dxDrawText(lengthColor.."#ffffff/"..penaltieLimits["kjcolor"], posX + sx*0.43, posY + sy*0.51, posX + sx*0.256 + sx*0.03, posY + sy*0.51 + sy*0.03, tocolor(237, 47, 47, 255 * cAlpha), 1, font:getFont("condensed", 12/myX*sx), "center", "center", _, _, _, true)
        else
            dxDrawText(lengthColor.."#ffffff/"..penaltieLimits["kjcolor"], posX + sx*0.43, posY + sy*0.51, posX + sx*0.256 + sx*0.03, posY + sy*0.51 + sy*0.03, tocolor(r, g, b, 255 * cAlpha), 1, font:getFont("condensed", 12/myX*sx), "center", "center", _, _, _, true)
        end

        if lengthPlate > penaltieLimits["kjplate"] then 
            dxDrawText(lengthPlate.."#ffffff/"..penaltieLimits["kjplate"], posX + sx*0.128, posY + sy*0.474, posX + sx*0.128 + sx*0.03, posY + sy*0.474 + sy*0.03, tocolor(237, 47, 47, 255 * cAlpha), 1, font:getFont("condensed", 12/myX*sx), "center", "center", _, _, _, true)
        else
            dxDrawText(lengthPlate.."#ffffff/"..penaltieLimits["kjplate"], posX + sx*0.128, posY + sy*0.474, posX + sx*0.128 + sx*0.03, posY + sy*0.474 + sy*0.03, tocolor(r, g, b, 255 * cAlpha), 1, font:getFont("condensed", 12/myX*sx), "center", "center", _, _, _, true)
        end

        if lengthDesc > penaltieLimits["kjdesc"] then 
            dxDrawText(lengthDesc.."#ffffff/"..penaltieLimits["kjdesc"], posX + sx*0.188, posY + sy*0.51, posX + sx*0.188 + sx*0.03, posY + sy*0.51 + sy*0.03, tocolor(237, 47, 47, 255 * cAlpha), 1, font:getFont("condensed", 12/myX*sx), "center", "center", _, _, _, true)
        else
            dxDrawText(lengthDesc.."#ffffff/"..penaltieLimits["kjdesc"], posX + sx*0.188, posY + sy*0.51, posX + sx*0.188 + sx*0.03, posY + sy*0.51 + sy*0.03, tocolor(r, g, b, 255 * cAlpha), 1, font:getFont("condensed", 12/myX*sx), "center", "center", _, _, _, true)
        end
    elseif page == 5 then -- szabálysértések
        local lineWidth = sx*0.37 / #penaltieFactions
        dxDrawRectangle(posX + sx*0.005, posY + sy*0.085, sx*0.37, sy*0.01, tocolor(30, 30, 30, 200 * cAlpha))

        penaltiesLinePos = interpolateBetween(penaltiesLinePos, 0, 0, posX + sx*0.005 + (lineWidth * (penaltiesFaction - 1)), 0, 0, (getTickCount() - penaltiesMenuTick) / 500, "Linear")

        dxDrawRectangle(penaltiesLinePos, posY + sy*0.085, lineWidth, sy*0.01, tocolor(r, g, b, 200 * cAlpha))

        local startX = posX + sx*0.005
        for k, v in ipairs(penaltieFactions) do 
            ---dxDrawRectangle(startX, posY + sy*0.065, lineWidth, sy*0.03)
            if k == penaltiesFaction then 
                dxDrawText(v[2], startX, posY + sy*0.07, startX + lineWidth, posY + sy*0.07 + sy*0.015, tocolor(r, g, b, 255 * bgAlpha), 1, font:getFont("condensed", 8/myX*sx), "center", "center")
            else
                dxDrawText(v[2], startX, posY + sy*0.07, startX + lineWidth, posY + sy*0.07 + sy*0.015, tocolor(255, 255, 255, 100 * bgAlpha), 1, font:getFont("condensed", 8/myX*sx), "center", "center")
            end

            startX = startX + lineWidth
        end

        dxDrawRectangle(posX + sx*0.005, posY + sy*0.1, sx*0.37, sy*0.49, tocolor(30, 30, 30, 120 * cAlpha))
        
        local scrollHeight = sy*0.485

        if mdcAccountDatas["access"] == 2 then 
            penaltiesListMaxCount = 6
            scrollHeight = sy*0.364
        else
            penaltiesListMaxCount = 8
        end

        local penaltiesSearch = {}
        local searchText = core:getEditboxText("search") or ""
        
        if not (searchText == "Keresés") then
            for k, v in ipairs(clientMDCDatas["penalties"][penaltiesFaction]) do 
                if string.match(string.lower(v[1]), string.lower(searchText)) then 
                    table.insert(penaltiesSearch, v)
                end
            end
        else
            penaltiesSearch = clientMDCDatas["penalties"][penaltiesFaction]
        end

        --dxDrawRectangle(posX + sx*0.35, posY + sy*0.023, sx*0.03, sy*0.035)
        dxDrawText("", posX + sx*0.355, posY + sy*0.023, posX + sx*0.35 + sx*0.03, posY + sy*0.023 + sy*0.035, tocolor(255, 255, 255, 255*cAlpha), 0.8, font:getFont("fontawesome2", 15/myX*sx), "left", "center")

        local startY = posY + sy*0.1 + 2/myY*sy
        for i = 1, penaltiesListMaxCount do 
            local alpha = 150
            if (i + penaltiesScroll) % 2 == 0 then 
                alpha = 220
            end

            dxDrawRectangle(posX + sx*0.005 + 2/myX*sx, startY, sx*0.37 - 12/myX*sx, sy*0.0608, tocolor(35, 35, 35, alpha * cAlpha))

            local v = penaltiesSearch[penaltiesScroll + i]

            if v then 
                --dxDrawRectangle(posX + sx*0.005 + 2/myX*sx, startY, sx*0.37 - 12/myX*sx, sy*0.03)
                dxDrawText(v[1], posX + sx*0.01 + 2/myX*sx, startY, posX + sx*0.01 + 2/myX*sx + sx*0.37 - 12/myX*sx, startY + sy*0.04, tocolor(r, g, b, 255 * cAlpha), 1, font:getFont("bebasneue", 14/myX*sx), "left", "center")
                dxDrawText(v[2], posX + sx*0.01 + 2/myX*sx, startY + sy*0.035, posX + sx*0.01 + 2/myX*sx + sx*0.37 - 12/myX*sx, startY + sy*0.055, tocolor(255, 255, 255, 100 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), "left", "center")

                if mdcAccountDatas["access"] == 2 then 
                    dxDrawText(comma_value(v[3]) .. "$", posX + sx*0.005 + 2/myX*sx, startY, posX + sx*0.005 + 2/myX*sx + sx*0.37 - 60/myX*sx, startY + sy*0.0608, tocolor(110, 209, 107, 200 * cAlpha), 1, font:getFont("bebasneue", 18/myX*sx), "right", "center")

                    if core:isInSlot(posX + sx*0.347, startY, sx*0.02, sy*0.0608) then
                        dxDrawText("", posX + sx*0.005 + 2/myX*sx, startY, posX + sx*0.005 + 2/myX*sx + sx*0.37 - 25/myX*sx, startY + sy*0.0608, tocolor(237, 47, 47, 150 * cAlpha), 1, font:getFont("fontawesome2", 15/myX*sx), "right", "center")
                    else
                        dxDrawText("", posX + sx*0.005 + 2/myX*sx, startY, posX + sx*0.005 + 2/myX*sx + sx*0.37 - 25/myX*sx, startY + sy*0.0608, tocolor(237, 47, 47, 50 * cAlpha), 1, font:getFont("fontawesome2", 15/myX*sx), "right", "center")
                    end
                else
                    dxDrawText(comma_value(v[3]) .. "$", posX + sx*0.005 + 2/myX*sx, startY, posX + sx*0.005 + 2/myX*sx + sx*0.37 - 20/myX*sx, startY + sy*0.0608, tocolor(110, 209, 107, 200 * cAlpha), 1, font:getFont("bebasneue", 18/myX*sx), "right", "center")
                end
            end

            startY = startY + sy*0.0608
        end

        if mdcAccountDatas["access"] == 2 then 
            local lengthName, lengthDesc = string.len(core:getEditboxText("pname") or ""), string.len(core:getEditboxText("pdesc") or "")

            if lengthName > penaltieLimits["name"] then 
                dxDrawText(lengthName.."#ffffff/"..penaltieLimits["name"], posX + sx*0.287, posY + sy*0.474, posX + sx*0.287 + sx*0.03, posY + sy*0.474 + sy*0.035, tocolor(237, 47, 47, 255 * cAlpha), 1, font:getFont("condensed", 12/myX*sx), "center", "center", _, _, _, true)
            else
                dxDrawText(lengthName.."#ffffff/"..penaltieLimits["name"], posX + sx*0.287, posY + sy*0.474, posX + sx*0.287 + sx*0.03, posY + sy*0.474 + sy*0.035, tocolor(r, g, b, 255 * cAlpha), 1, font:getFont("condensed", 12/myX*sx), "center", "center", _, _, _, true)
            end

            if lengthDesc > penaltieLimits["desc"] then 
                dxDrawText(lengthDesc.."#ffffff/"..penaltieLimits["desc"], posX + sx*0.287, posY + sy*0.51, posX + sx*0.287 + sx*0.03, posY + sy*0.51 + sy*0.035, tocolor(237, 47, 47, 255 * cAlpha), 1, font:getFont("condensed", 12/myX*sx), "center", "center", _, _, _, true)
            else
                dxDrawText(lengthDesc.."#ffffff/"..penaltieLimits["desc"], posX + sx*0.287, posY + sy*0.51, posX + sx*0.287 + sx*0.03, posY + sy*0.51 + sy*0.035, tocolor(r, g, b, 255 * cAlpha), 1, font:getFont("condensed", 12/myX*sx), "center", "center", _, _, _, true)
            end
            
            dxDrawText("$", posX + sx*0.287, posY + sy*0.547, posX + sx*0.287 + sx*0.03, posY + sy*0.547 + sy*0.035, tocolor(110, 209, 107, 255 * cAlpha), 1, font:getFont("condensed", 12/myX*sx), "center", "center")

            core:dxDrawButton(posX + sx*0.32, posY + sy*0.474, 94/myX*sx, 105/myY*sy, r, g, b, 180 * cAlpha, "", tocolor(255, 255, 255, 255 * cAlpha), 1, font:getFont("fontawesome2", 15/myX*sx), true, tocolor(0, 0, 0, 255 * cAlpha))
        end

        local lineHeight = math.min(penaltiesListMaxCount / #clientMDCDatas["penalties"][penaltiesFaction], 1)
        dxDrawRectangle(posX + sx*0.371, posY + sy*0.1 + 2/myY*sy, sx*0.002, scrollHeight, tocolor(35, 35, 35, 200 * cAlpha))
        dxDrawRectangle(posX + sx*0.371, posY + sy*0.1 + 2/myY*sy + (scrollHeight * (lineHeight * penaltiesScroll / penaltiesListMaxCount)), sx*0.002, scrollHeight * lineHeight, tocolor(r, g, b, 200 * cAlpha))

    elseif page == 6 then -- felhasználók kezelése (Leader)
        dxDrawRectangle(posX + sx*0.005, posY + sy*0.065, sx*0.37, sy*0.525, tocolor(30, 30, 30, 120 * cAlpha))
        
        local scrollHeight = sy*0.382

        dxDrawText("", posX + sx*0.355, posY + sy*0.023, posX + sx*0.35 + sx*0.03, posY + sy*0.023 + sy*0.035, tocolor(255, 255, 255, 255*cAlpha), 0.8, font:getFont("fontawesome2", 15/myX*sx), "left", "center")

        local startY = posY + sy*0.065 + 3/myY*sy
        for i = 1, 12 do 
            local alpha = 150
            if (i + wantedCarsScroll) % 2 == 0 then 
                alpha = 220
            end
            
            dxDrawRectangle(posX + sx*0.005 + 2/myX*sx, startY, sx*0.37 - 12/myX*sx, sy*0.03, tocolor(35, 35, 35, alpha * cAlpha))

            local v = clientMDCDatas["users"][mdcUsersScroll + i]

            if v then 
                dxDrawText(v[2] .. " #ffffff(#"..v[1]..")", posX + sx*0.01 + 2/myX*sx, startY, posX + sx*0.01 + 2/myX*sx + sx*0.37 - 12/myX*sx, startY + sy*0.03, tocolor(r, g, b, 255 * cAlpha), 1, font:getFont("bebasneue", 14/myX*sx), "left", "center", false, false, false, true)
                dxDrawText("Jogosultság: "..color..accessTypes[v[5]].. "#ffffff Szervezet: "..color..(factions[v[4]] or "Ismeretlen"), posX + sx*0.01 + 2/myX*sx, startY, posX + sx*0.01 + 2/myX*sx + sx*0.34 - 12/myX*sx, startY + sy*0.03, tocolor(255, 255, 255, 255 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), "right", "center", false, false, false, true)

                if core:isInSlot(posX + sx*0.35, startY, sx*0.02, sy*0.03) then
                    dxDrawText("", posX + sx*0.01 + 2/myX*sx, startY, posX + sx*0.01 + 2/myX*sx + sx*0.36 - 12/myX*sx, startY + sy*0.03, tocolor(237, 47, 47, 150 * cAlpha), 1, font:getFont("fontawesome2", 15/myX*sx), "right", "center", false, false, false, true)
                else
                    dxDrawText("", posX + sx*0.01 + 2/myX*sx, startY, posX + sx*0.01 + 2/myX*sx + sx*0.36 - 12/myX*sx, startY + sy*0.03, tocolor(237, 47, 47, 50 * cAlpha), 1, font:getFont("fontawesome2", 15/myX*sx), "right", "center", false, false, false, true)
                end
            end

            startY = startY + sy*0.032
        end

        core:dxDrawButton(posX + sx*0.006, posY + sy*0.555, 650/myX*sx, 32/myY*sy, r, g, b, 180 * cAlpha, "Járőr fiók létrehozása", tocolor(255, 255, 255, 255 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), true, tocolor(0, 0, 0, 255 * cAlpha))

        local lineHeight = math.min(12 / #clientMDCDatas["users"], 1)
        dxDrawRectangle(posX + sx*0.371, posY + sy*0.065 + 3/myY*sy, sx*0.002, scrollHeight, tocolor(35, 35, 35, 200 * cAlpha))
        dxDrawRectangle(posX + sx*0.371, posY + sy*0.065 + 3/myY*sy + (scrollHeight * (lineHeight * mdcUsersScroll / 12)), sx*0.002, scrollHeight * lineHeight, tocolor(r, g, b, 200 * cAlpha))
    elseif page == 7 then -- keresés
        dxDrawRectangle(posX + sx*0.16, posY + sy*0.07, 240/myX*sx, sy*0.035, tocolor(30, 30, 30, 200 * cAlpha))

        dxDrawText(searchTypes[search_type], posX + sx*0.16, posY + sy*0.07, posX + sx*0.16 + 240/myX*sx, posY + sy*0.07 + sy*0.035, tocolor(255, 255, 255, 200 * cAlpha), 1, font:getFont("condensed", 12/myX*sx), "center", "center", false, false, false, true)

        core:dxDrawButton(posX + sx*0.3, posY + sy*0.07, 100/myX*sx, 32/myY*sy, r, g, b, 180 * cAlpha, "Keresés", tocolor(255, 255, 255, 255 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), true, tocolor(0, 0, 0, 255 * cAlpha))



        if search_panelData then 
            
            dxDrawRectangle(posX + sx*0.006, posY + sy*0.12, 650/myX*sx, sy*0.03, tocolor(30, 30, 30, 200 * cAlpha))
            dxDrawText("Adatok", posX + sx*0.01, posY + sy*0.12, posX + sx*0.01 + 650/myX*sx, posY + sy*0.12 + sy*0.03, tocolor(255, 255, 255, 200 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), "left", "center", false, false, false, true)

            local startY = posY + sy*0.12 + sy*0.03
            for k, v in ipairs(displaySearchDatas[search_type]) do 
                local lineAlpha = 180 

                if (k % 2) == 0 then 
                    lineAlpha = 100
                end

                if v[2] == "skin" then 
                    dxDrawRectangle(posX + sx*0.006, startY, 650/myX*sx, sy*0.075, tocolor(25, 25, 25, lineAlpha * cAlpha))
                else
                    dxDrawRectangle(posX + sx*0.006, startY, 650/myX*sx, sy*0.025, tocolor(25, 25, 25, lineAlpha * cAlpha))
                end

                dxDrawText(v[1] .. ":", posX + sx*0.01, startY, posX + sx*0.01 + 650/myX*sx, startY + sy*0.025, tocolor(255, 255, 255, 255 * cAlpha), 0.9, font:getFont("condensed", 10/myX*sx), "left", "center", false, false, false, true)
                
                local data 

                if v[2] then
                    data = search_panelData[v[2]]
                else
                    if v[1] == "Körözés" then 
                        data = "Nincs kiadott körözés"

                        if search_type == "veh" then 
                            for k4, v4 in ipairs(clientMDCDatas["wanted_cars"]) do 
                                if v4[1] == search_panelData["plateText"] then 
                                    data = "#ffffff"..v4[5] .. ": #fc4c4c"..v4[3]
                                end
                            end
                        else
                            for k4, v4 in ipairs(clientMDCDatas["wanted_persons"]) do 
                                if v4[1] == search_panelData["charname"]:gsub("_", " ") then 
                                    data = "#ffffff"..v4[3] .. ": #fc4c4c"..v4[2]

                                    if v4[6] then 
                                        data = data .. " [Fokozottan veszélyes!]"
                                    end
                                end
                            end
                        end
                    end
                end

                if v[2] == "model" then
                    data = vehicle:getModdedVehName(search_panelData[v[2]])
                elseif v[2] == "color" then 
                    local vehicleColor = fromJSON(data)

                    data = rgbToHex(vehicleColor[1], vehicleColor[2], vehicleColor[3]).."Szín1"..rgbToHex(vehicleColor[4], vehicleColor[5], vehicleColor[6]).." Szín2"
                elseif v[2] == "owner" then 
                    if search_panelData["isFactionVehicle"] == 1 then 
                        data = "Szervezeti jármű"
                    end
                elseif v[2] == "isBooked" then 
                    if data == 0 then 
                        data = "Nem"
                    else
                        data = "Igen"
                    end
                elseif v[2] == "age" then 
                    data = tostring(data) .. "#ffffff év"
                elseif v[2] == "height" then 
                    data = tostring(data) .. "#ffffff cm"
                elseif v[2] == "weight" then 
                    data = tostring(data) .. "#ffffff kg"
                elseif v[2] == "job" then 
                    if tonumber(data) == 0 then 
                        data = "Munkanélküli"
                    else
                        data = exports.oJob:getJobName(data)
                    end
                elseif v[2] == "pdJailDatas" then 
                    local jaildatas = fromJSON(data)

                    if jaildatas[3] == false then 
                        data = "Szabadlábon"
                    else
                        data = jaildatas[1][1] .. " #ffffffnap, Oka: "..color..jaildatas[1][2]
                    end
                end

                if v[2] == "skin" then 
                    dxDrawImage(posX + 590/myX*sx, startY + 5/myY*sy, 65/myX*sx, 65/myX*sx, ":oLicenses/files/avatars/"..data..".png", 0, 0, 0, tocolor(255, 255, 255, 255 * cAlpha))
                else
                    dxDrawText(tostring(data):gsub("_", " "), posX + sx*0.01, startY, posX + sx*0.01 + 635/myX*sx, startY + sy*0.025, tocolor(r, g, b, 255 * cAlpha), 0.9, font:getFont("condensed", 10/myX*sx), "right", "center", false, false, false, true)
                end

                startY = startY + sy*0.025

                if v[2] == "skin" then 
                    startY = startY + sy*0.05
                end
            end

            startY = startY + sy*0.01

            if search_panelOthers then
                if #search_panelOthers > 0 then
                    dxDrawRectangle(posX + sx*0.006, startY, 650/myX*sx, sy*0.03, tocolor(30, 30, 30, 200 * cAlpha))
                    dxDrawText("Feljegyzések", posX + sx*0.01, startY, posX + sx*0.01 + 650/myX*sx, startY + sy*0.03, tocolor(255, 255, 255, 200 * cAlpha), 1, font:getFont("condensed", 10/myX*sx), "left", "center", false, false, false, true)

                    startY = startY + sy*0.03

                    dxDrawRectangle(posX + sx*0.006, startY, 650/myX*sx, sy*0.025, tocolor(30, 30, 30, 255 * cAlpha))
                    dxDrawText("Időpont", posX + sx*0.01, startY, posX + sx*0.01 + 650/myX*sx, startY + sy*0.025, tocolor(r, g, b, 255 * cAlpha), 0.9, font:getFont("condensed", 10/myX*sx), "left", "center", false, false, false, true)
                    dxDrawText("Indok", posX + sx*0.01, startY, posX + sx*0.01 + 650/myX*sx, startY + sy*0.025, tocolor(r, g, b, 255 * cAlpha), 0.9, font:getFont("condensed", 10/myX*sx), "center", "center", false, false, false, true)
                    dxDrawText("Egyéb", posX + sx*0.01, startY, posX + sx*0.01 + 635/myX*sx, startY + sy*0.025, tocolor(r, g, b, 255 * cAlpha), 0.9, font:getFont("condensed", 10/myX*sx), "right", "center", false, false, false, true)
                    startY = startY + sy*0.025


                    local scrollHeight = math.min(#search_panelOthers, 5) * sy*0.025
                    local lineHeight = math.min(5 / #search_panelOthers, 1)

                    dxDrawRectangle(posX + sx*0.006 + 645/myX*sx, startY, 5/myX*sx, scrollHeight, tocolor(r, g, b, 100 * cAlpha))
                    dxDrawRectangle(posX + sx*0.006 + 645/myX*sx, startY + (scrollHeight * (lineHeight * searchScroll / 5)), 5/myX*sx, scrollHeight * lineHeight, tocolor(r, g, b, 200 * cAlpha))


                    for i = 1, 5 do
                        if search_panelOthers[i + searchScroll] then 
                            local lineAlpha = 180 

                            if (i % 2) == 0 then 
                                lineAlpha = 100
                            end


                            dxDrawRectangle(posX + sx*0.006, startY, 645/myX*sx, sy*0.025, tocolor(25, 25, 25, lineAlpha * cAlpha))
                            dxDrawText(search_panelOthers[i + searchScroll]["time"], posX + sx*0.01, startY, posX + sx*0.01 + 650/myX*sx, startY + sy*0.025, tocolor(255, 255, 255, 255 * cAlpha), 0.9, font:getFont("condensed", 10/myX*sx), "left", "center", false, false, false, true)
                            dxDrawText(search_panelOthers[i + searchScroll]["reason"], posX + sx*0.01, startY, posX + sx*0.01 + 650/myX*sx, startY + sy*0.025, tocolor(255, 255, 255, 255 * cAlpha), 0.9, font:getFont("condensed", 10/myX*sx), "center", "center", false, false, false, true)

                            local other = search_panelOthers[i + searchScroll]["other"] 

                            if string.find(other, "$") then 
                                other = "#ade872" .. other
                            end

                            dxDrawText(other, posX + sx*0.01, startY, posX + sx*0.01 + 630/myX*sx, startY + sy*0.025, tocolor(255, 255, 255, 255 * cAlpha), 0.9, font:getFont("condensed", 10/myX*sx), "right", "center", false, false, false, true)


                            startY = startY + sy*0.025
                        end
                    end 
                end
            end 
        else
            dxDrawImage(posX + ((width - 50/myX*sx) / 2) - 60/myX*sx, posY + sy*0.19, 120/myX*sx, 156.5/myY*sy, "pd_logo.png", 0, 0, 0, tocolor(255, 255, 255, 255 * cAlpha))
            dxDrawText("Nem található a keresési feltételeknek megfelelő adat az adatbázisban.", posX, posY, posX + (width - 50/myX*sx), posY + height + 130/myX*sx, tocolor(255, 255, 255, 255 * cAlpha), 1, font:getFont("condensed", 13/myX*sx), "center", "center", false, false, false, true)
            dxDrawText("Próbálkozz később.", posX, posY, posX + (width - 50/myX*sx), posY + height + 180/myY*sy, tocolor(255, 255, 255, 100 * cAlpha), 0.8, font:getFont("condensed", 13/myX*sx), "center", "center", false, false, false, true)
        end
    end
end

local lastClickTimer = false
local lastAction = 0
local lastModify = 0
function keyMDC(key, state)
    if key == "mouse1" then 
        if state then
            if page > 1 then
                if core:isInSlot(posX + sx*0.004, posY + sy*0.02, width * 0.5, sy*0.04) then 
                    local cx, cy = getCursorPosition()
                    
                    cx, cy = cx*sx-posX, cy*sy-posY

                    panelIsMoveing = {cx, cy}

                    if mdcEditboxs[page] then 
                        for k, v in ipairs(mdcEditboxs[page]) do 
                            core:deleteEditbox(v.name)
                        end
                    end
                end
            end
        else
            if panelIsMoveing then 
                panelIsMoveing = false 
                createEditboxes()
            end
        end
    end

    if state then 
        if key == "mouse1" then 
            if page > 1 then 
                local lineHeight =  (height - sy*0.02) / (#mdcPageNames - 1)

                local startY = posY + sy*0.01
                for k, v in ipairs(mdcPageNames) do 
                    if k >= 2 then                         
                        if core:isInSlot(posX + width - sx*0.02, startY, sx*0.015, lineHeight) then 
                            if not (page == k) then
                                setMDCPage(k)
                            end
                        end

                        startY = startY + lineHeight
                    end
                end

                if core:isInSlot(posX + sx*0.004, posY, width - sx*0.03, sy*0.025) then 
                    if openType == "veh" then
                        setElementData(getPedOccupiedVehicle(localPlayer), "mdc:vehicleLoginDatas", false)
                    end

                    infobox:outputInfoBox("Sikeresen kijelentkeztél az MDC felhazsnálóból!", "success")
                    setMDCPage(1)
                end
            end

            if page == 1 then 
                if core:isInSlot(posX + sx*0.002, posY + sy*0.145, sx*0.146, sy*0.045) then 
                    local username, password = core:getEditboxText("user") or "", core:getEditboxText("pass") or ""

                    local errorMessage = false

                    local talalat = false
                    for k, v in ipairs(clientMDCDatas["users"]) do 
                        if username == v[2] then 
                            talalat = {v[3], v[4], v[5], v[1]}
                        end
                    end

                    if not talalat then 
                        errorMessage = "Nincs ilyen felhazsnálónévvel rendelkező MDC fiók!"
                    else
                        if password == talalat[1] then 
                            if talalat[3] == 2 then 
                                if not dashboard:isPlayerLeader(getElementData(localPlayer, "char:duty:faction") or 0) then 
                                    errorMessage = "Nem vagy a szervezet vezetője, így nincs jogosultásod belépni ebbe a fiókba!"
                                end
                            elseif talalat[3] == 3 then 
                                if not getElementData(localPlayer, "aclLogin") then
                                    errorMessage = "Nem rendelkezel megfelelő jogosultságokkal a bejelentkezéshez! (Fejlesztői fiók)"
                                end
                                talalat[2] = "orp"
                            end
                        else
                            errorMessage = "Hibás jelszó a(z) "..username.." felhasználónevű MDC fiókhoz!"
                        end
                    end

                    if errorMessage then 
                        infobox:outputInfoBox(errorMessage, "error")
                    else
                        infobox:outputInfoBox("Sikeresen bejelentkeztél a(z) "..username.." felhasználónevű MDC fiókba!", "success")

                        mdcAccountDatas["user"] = username
                        mdcAccountDatas["access"] = talalat[3]
                        mdcAccountDatas["faction"] = talalat[2]
                        mdcAccountDatas["id"] = talalat[4]
                        setMDCPage(2)

                        if openType == "veh" then
                            setElementData(getPedOccupiedVehicle(localPlayer), "mdc:vehicleLoginDatas", {username, talalat[3], talalat[2], talalat[4]})
                        end
                    end
                end
            elseif page == 2 then 
                if openType == "veh" then
                    if core:isInSlot(posX + sx*0.006 + sx * 0.302, posY + sy*0.067, 115/myX*sx, sy*0.035) then
                        if string.len(core:getEditboxText("enumber")) <= 12 then
                            setElementData(getPedOccupiedVehicle(localPlayer), "mdc:unitNumber", core:getEditboxText("enumber"))
                            infobox:outputInfoBox("Egységazonosító sikeresen megválltoztatva!", "success")
                        else
                            infobox:outputInfoBox("Maximum 12 karakter hosszúságú egységazonosítót adhatsz meg!", "warning")
                        end
                    end

                    if lastModify + 2000 < getTickCount() then
                        if core:isInSlot(posX + sx*0.006, posY + sy*0.105, 649/myX*sx, sy*0.035) then 
                            local unitNumber = getElementData(getPedOccupiedVehicle(localPlayer), "mdc:unitNumber")
                            if string.len(unitNumber) > 0 then 
                                setElementData(getPedOccupiedVehicle(localPlayer), "mdc:unitState", {"Járőr", 3, 140, 252, "#038cfc"})
                                lastModify = getTickCount()
                            end
                        end

                        if core:isInSlot(posX + sx*0.006, posY + sy*0.142, 649/myX*sx, sy*0.035) then 
                            local unitNumber = getElementData(getPedOccupiedVehicle(localPlayer), "mdc:unitNumber")
                            if string.len(unitNumber) > 0 then 
                                setElementData(getPedOccupiedVehicle(localPlayer), "mdc:unitState", {"Pihenő", 87, 222, 78, "#57de4e"})
                                lastModify = getTickCount()
                            end
                        end

                        if core:isInSlot(posX + sx*0.006, posY + sy*0.179, 649/myX*sx, sy*0.035) then 
                            local unitNumber = getElementData(getPedOccupiedVehicle(localPlayer), "mdc:unitNumber")
                            if string.len(unitNumber) > 0 then 
                                setElementData(getPedOccupiedVehicle(localPlayer), "mdc:unitState", {"Üldözés", 219, 42, 39, "#db2a27"})
                                lastModify = getTickCount()
                            end
                        end

                        if core:isInSlot(posX + sx*0.006, posY + sy*0.216, 649/myX*sx, sy*0.035) then 
                            local unitNumber = getElementData(getPedOccupiedVehicle(localPlayer), "mdc:unitNumber")
                            if string.len(unitNumber) > 0 then 
                                setElementData(getPedOccupiedVehicle(localPlayer), "mdc:unitState", {"Erősítés", 219, 42, 39, "#db2a27"})
                                lastModify = getTickCount()
                            end
                        end

                        if core:isInSlot(posX + sx*0.006, posY + sy*0.253, 649/myX*sx, sy*0.035) then 
                            local unitNumber = getElementData(getPedOccupiedVehicle(localPlayer), "mdc:unitNumber")
                            if string.len(unitNumber) > 0 then 
                                setElementData(getPedOccupiedVehicle(localPlayer), "mdc:unitState", {"Nincs szolgálatban", 66, 66, 66, "#424242"})
                                lastModify = getTickCount()
                            end
                        end
                    end
                end
            elseif page == 3 then 
                if core:isInSlot(posX + sx*0.006 + 575/myX*sx, posY + sy*0.474, 72/myX*sx, 112/myY*sy) then
                    selectedMostDanger = not selectedMostDanger
                end

                local lengthName, lengthDesc = string.len(core:getEditboxText("kname") or ""), string.len(core:getEditboxText("kdesc") or "")

                local x, y, w, h = posX + sx*0.006, posY + sy*0.555, 495/myX*sx, 32/myY*sy

                if modifyedLine > 0 then 
                    x, y, w, h = posX + sx*0.006, posY + sy*0.555, 232/myX*sx, 32/myY*sy

                    if core:isInSlot(posX + sx*0.006 + 234/myX*sx, posY + sy*0.555, 200/myX*sx, 32/myY*sy) then
                        infobox:outputInfoBox("'"..clientMDCDatas["wanted_persons"][modifyedLine][1].."' nevű személy körözése visszavonásra került!", "success")

                        triggerServerEvent("mdc > deleteDataFromMDC", resourceRoot, "wanted_persons", clientMDCDatas["wanted_persons"][modifyedLine][7])
                        modifyedLine = 0
                        addWantedPersonSkinID = 0
                        selectedMostDanger = false

                        core:setEditboxText("kname", mdcEditboxs[3][1].text)
                        core:setEditboxText("kdesc", mdcEditboxs[3][2].text)
                    end
                end

                if core:isInSlot(x, y, w, h) then 
                    if lengthName > 5 and lengthName <= penaltieLimits["kname"] then 
                        if lengthDesc <= penaltieLimits["kdesc"] then 
                            local name = core:getEditboxText("kname")
                            local desc = core:getEditboxText("kdesc") 

                            lastAction = getTickCount()

                            local skinID = 0

                            if addWantedPersonSkinID > 0 then 
                                skinID = realSkins[addWantedPersonSkinID]
                            end

                            if modifyedLine > 0 then
                                if name == clientMDCDatas["wanted_persons"][modifyedLine][1] and desc == clientMDCDatas["wanted_persons"][modifyedLine][2] and skinID == clientMDCDatas["wanted_persons"][modifyedLine][5] and selectedMostDanger == clientMDCDatas["wanted_persons"][modifyedLine][6] then 
                                    infobox:outputInfoBox("Nem történt változás a körözési adatokban!", "error") 
                                    return 
                                end
                                
                                infobox:outputInfoBox("'"..name.."' nevű személy körözési adatai módosultak!", "success")

                                triggerServerEvent("mdc > modifyDataInMDC", resourceRoot, "wanted_persons", clientMDCDatas["wanted_persons"][modifyedLine][7], {name, desc, string.format("%04d. %02d. %02d. %02d:%02d", core:getDate("year"), core:getDate("month"), core:getDate("monthday"), core:getDate("hour"), core:getDate("minute")), mdcAccountDatas["user"], skinID, selectedMostDanger, clientMDCDatas["wanted_persons"][modifyedLine][7]})
                                modifyedLine = 0
                            else
                                infobox:outputInfoBox("Körözés kiadva a(z) '"..name.."' nevű személyre!", "success")
                                triggerServerEvent("mdc > addDataToMDC", resourceRoot, "wanted_persons", {name, desc, string.format("%04d. %02d. %02d. %02d:%02d", core:getDate("year"), core:getDate("month"), core:getDate("monthday"), core:getDate("hour"), core:getDate("minute")), mdcAccountDatas["user"], skinID, selectedMostDanger})
                            end

                            addWantedPersonSkinID = 0
                            selectedMostDanger = false

                            core:setEditboxText("kname", mdcEditboxs[3][1].text)
                            core:setEditboxText("kdesc", mdcEditboxs[3][2].text)
                        else
                            infobox:outputInfoBox("A körözés indokának maximum "..penaltieLimits["kdesc"].." karakterből kell álnia.", "error")
                        end
                    else
                        infobox:outputInfoBox("A körözött személy nevének minimum 5 és maximum "..penaltieLimits["kname"].." karakterből kell álnia.", "error")
                    end
                end

                local searchText = core:getEditboxText("search2") or ""

                if string.len(searchText) == 0 then
                    local startY = posY + sy*0.065 + 3/myY*sy
                    for i = 1, 5 do         
                        --if v then 
                            if core:isInSlot(posX + sx*0.347, startY + sy*0.04, sx*0.02, sy*0.035) then
                                if modifyedLine > 0 then 
                                    modifyedLine = 0

                                    addWantedPersonSkinID = 0
                                    selectedMostDanger = false

                                    core:setEditboxText("kname", mdcEditboxs[3][1].text)
                                    core:setEditboxText("kdesc", mdcEditboxs[3][2].text)
                                else
                                    modifyedLine = wantedPersonsScroll + i

                                    core:setEditboxText("kname", clientMDCDatas["wanted_persons"][modifyedLine][1])
                                    core:setEditboxText("kdesc", clientMDCDatas["wanted_persons"][modifyedLine][2])

                                    for k, v in ipairs(realSkins) do 
                                        if v == clientMDCDatas["wanted_persons"][modifyedLine][5] then 
                                            addWantedPersonSkinID = k 
                                            break
                                        end
                                    end

                                    selectedMostDanger = clientMDCDatas["wanted_persons"][modifyedLine][6]
                                end
                            end
                        --end
            
                        startY = startY + sy*0.08
                    end
                end
            elseif page == 4 then 
                local x, y, w, h = posX + sx*0.006, posY + sy*0.555, 650/myX*sx, 32/myY*sy

                if modifyedLineVeh > 0 then 
                    x, y, w, h = posX + sx*0.006, posY + sy*0.555, 448/myX*sx, 32/myY*sy

                    if core:isInSlot(posX + sx*0.006 + 450/myX*sx, posY + sy*0.555, 200/myX*sx, 32/myY*sy) then
                        infobox:outputInfoBox("'"..clientMDCDatas["wanted_cars"][modifyedLineVeh][1].."' rendszámú gépjármű körözése visszavonásra került!", "success")

                        triggerServerEvent("mdc > deleteDataFromMDC", resourceRoot, "wanted_cars", clientMDCDatas["wanted_cars"][modifyedLineVeh][7])
                        modifyedLineVeh = 0

                        core:setEditboxText("kjplate", mdcEditboxs[4][1].text)
                        core:setEditboxText("kjcolor", mdcEditboxs[4][3].text)
                        core:setEditboxText("kjtype", mdcEditboxs[4][2].text)
                        core:setEditboxText("kjdesc", mdcEditboxs[4][4].text)
                    end
                end

                local lengthType, lengthDesc, lengthColor, lengthPlate = string.len(core:getEditboxText("kjtype") or ""), string.len(core:getEditboxText("kjdesc") or ""), string.len(core:getEditboxText("kjcolor") or ""), string.len(core:getEditboxText("kjplate") or "")
                if core:isInSlot(x, y, w, h) then 
                    if lengthType > 5 and lengthType <= penaltieLimits["kjtype"] then 
                        if lengthDesc <= penaltieLimits["kjdesc"] then
                            if lengthPlate >= 3 and lengthPlate <= penaltieLimits["kjplate"] then  
                                if lengthColor >= 3 and lengthColor <= penaltieLimits["kjcolor"] then  
                                    local plate = core:getEditboxText("kjplate")
                                    local desc = core:getEditboxText("kjdesc") 
                                    local color = core:getEditboxText("kjcolor") 
                                    local type = core:getEditboxText("kjtype") 

                                    lastAction = getTickCount()

                                    if modifyedLineVeh > 0 then
                                        if (plate == clientMDCDatas["wanted_cars"][modifyedLineVeh][1] and type == clientMDCDatas["wanted_cars"][modifyedLineVeh][2] and color == clientMDCDatas["wanted_cars"][modifyedLineVeh][4] and desc == clientMDCDatas["wanted_cars"][modifyedLineVeh][3]) then 
                                            infobox:outputInfoBox("Nem történt változás a körözési adatokban!", "error") 
                                            return 
                                        end
                                        
                                        infobox:outputInfoBox("'"..plate.."' rendszámú jármű körözési adatai módosultak!", "success")

                                        triggerServerEvent("mdc > modifyDataInMDC", resourceRoot, "wanted_cars", clientMDCDatas["wanted_cars"][modifyedLineVeh][7], {plate, type, desc, color, string.format("%04d. %02d. %02d. %02d:%02d", core:getDate("year"), core:getDate("month"), core:getDate("monthday"), core:getDate("hour"), core:getDate("minute")), mdcAccountDatas["user"], clientMDCDatas["wanted_cars"][modifyedLineVeh][7]})
                                        modifyedLineVeh = 0
                                    else
                                        infobox:outputInfoBox("Körözés kiadva a(z) '"..plate.."' rendszámú gépjárműre!", "success")
                                        triggerServerEvent("mdc > addDataToMDC", resourceRoot, "wanted_cars", {plate, type, desc, color, string.format("%04d. %02d. %02d. %02d:%02d", core:getDate("year"), core:getDate("month"), core:getDate("monthday"), core:getDate("hour"), core:getDate("minute")), mdcAccountDatas["user"]})
                                    end

                                    core:setEditboxText("kjplate", mdcEditboxs[4][1].text)
                                    core:setEditboxText("kjcolor", mdcEditboxs[4][4].text)
                                    core:setEditboxText("kjtype", mdcEditboxs[4][2].text)
                                    core:setEditboxText("kjdesc", mdcEditboxs[4][3].text)
                                else
                                    infobox:outputInfoBox("A körözött jármű színének minimum 3 és maximum "..penaltieLimits["kjcolor"].." karakterből kell álnia.", "error")
                                end
                            else
                                infobox:outputInfoBox("A körözött jármű rendszámának minimum 3 és maximum "..penaltieLimits["kjplate"].." karakterből kell álnia.", "error")
                            end
                        else
                            infobox:outputInfoBox("A körözés indokának maximum "..penaltieLimits["kjdesc"].." karakterből kell álnia.", "error")
                        end
                    else
                        infobox:outputInfoBox("A körözött jármű típusának legalább 5 és maximum "..penaltieLimits["kjtype"].." karakterből kell álnia.", "error")
                    end
                end

                local searchText = core:getEditboxText("search3") or ""
                if string.len(searchText) == 0 then
                    local startY = posY + sy*0.065 + 3/myY*sy
                    for i = 1, 5 do         
                        if core:isInSlot(posX + sx*0.347, startY + sy*0.04, sx*0.02, sy*0.035) then
                            if modifyedLineVeh > 0 then 
                                modifyedLineVeh = 0

                                core:setEditboxText("kjplate", mdcEditboxs[4][1].text)
                                core:setEditboxText("kjcolor", mdcEditboxs[4][4].text)
                                core:setEditboxText("kjtype", mdcEditboxs[4][2].text)
                                core:setEditboxText("kjdesc", mdcEditboxs[4][3].text)
                            else
                                modifyedLineVeh = wantedCarsScroll + i
                                core:setEditboxText("kjplate", clientMDCDatas["wanted_cars"][modifyedLineVeh][1])
                                core:setEditboxText("kjcolor", clientMDCDatas["wanted_cars"][modifyedLineVeh][4])
                                core:setEditboxText("kjtype", clientMDCDatas["wanted_cars"][modifyedLineVeh][2])
                                core:setEditboxText("kjdesc", clientMDCDatas["wanted_cars"][modifyedLineVeh][3])
                            end
                        end
            
                        startY = startY + sy*0.08
                    end
                end
            elseif page == 5 then 
                local lineWidth = sx*0.37 / #penaltieFactions
                local startX = posX + sx*0.005
                for k, v in ipairs(penaltieFactions) do 
                    
                    if core:isInSlot(startX, posY + sy*0.065, lineWidth, sy*0.03) then 
                        if not (penaltiesFaction == k) then
                            penaltiesFaction = k 
                            penaltiesMenuTick = getTickCount()
                            penaltiesScroll = 0
                        end
                    end

                    startX = startX + lineWidth
                end

                local penaltiesSearch = {}
                local searchText = core:getEditboxText("search") or ""
                
                if not (searchText == "Keresés") then
                    for k, v in ipairs(clientMDCDatas["penalties"][penaltiesFaction]) do 
                        if string.match(string.lower(v[1]), string.lower(searchText)) then 
                            table.insert(penaltiesSearch, v)
                        end
                    end
                else
                    penaltiesSearch = clientMDCDatas["penalties"][penaltiesFaction]
                end

                local searchText = core:getEditboxText("search") or ""
                if string.len(searchText) == 0 then
                    local startY = posY + sy*0.1 + 2/myY*sy
                    for i = 1, penaltiesListMaxCount do 
                        local v = penaltiesSearch[penaltiesScroll + i]
            
                        if v then 
                            if mdcAccountDatas["access"] == 2 then
                                if core:isInSlot(posX + sx*0.347, startY, sx*0.02, sy*0.0608) then
                                    if lastAction + 1000 < getTickCount() then 
                                        lastAction = getTickCount()
                                        local needScroll = false
                                        if #clientMDCDatas["penalties"][penaltiesFaction] > 6 then
                                            if penaltiesScroll > 0 then
                                                if penaltiesScroll + i + 6 > #clientMDCDatas["penalties"][penaltiesFaction] then 
                                                    needScroll = true
                                                end
                                            end
                                        end

                                        local name = ""
                                        for k, v in ipairs(clientMDCDatas["penalties"][penaltiesFaction]) do 
                                            if v[1] == penaltiesSearch[penaltiesScroll + i][1] then 
                                                name = v[1]

                                                triggerServerEvent("mdc > deleteDataFromMDC", resourceRoot, "penalties", v[4], penaltiesFaction)
                                                break
                                            end
                                        end
                                        infobox:outputInfoBox("A(z) '"..name.."' nevű szabályszegés törlésre került!", "success")

                                        if needScroll then 
                                            --penaltiesScroll = penaltiesScroll - 1
                                        end    
                                    end    
                                end
                            end
                        end
            
                        startY = startY + sy*0.0608
                    end
                end

                if mdcAccountDatas["access"] == 2 then 
                    if core:isInSlot(posX + sx*0.32, posY + sy*0.474, 94/myX*sx, 105/myY*sy) then 
                        local name, desc, price = core:getEditboxText("pname"), core:getEditboxText("pdesc"), core:getEditboxText("pprice")
                        local lName, lDesc = string.len(name), string.len(desc)

                        if lastAction + 1000 < getTickCount() then 
                            if lName >= 5 and lName <= penaltieLimits["name"] then 
                                if lDesc >= 5 and lName <= penaltieLimits["desc"] then 
                                    if tonumber(price) then 
                                        if tonumber(price) >= 10 and tonumber(price) <= 50000 then 
                                            infobox:outputInfoBox("A(z) '"..name.."' nevű szabályszegés sikeresen létrehozása került!", "success")
                                            lastAction = getTickCount()

                                            triggerServerEvent("mdc > addDataToMDC", resourceRoot, "penalties", {name, desc, price}, penaltiesFaction)

                                            core:setEditboxText("pname", mdcEditboxs[5][1].text)
                                            core:setEditboxText("pdesc", mdcEditboxs[5][2].text)
                                            core:setEditboxText("pprice", mdcEditboxs[5][3].text)
                                        else
                                            infobox:outputInfoBox("A büntetés értékének a 10-50000 értéktartományban kell lennie.", "error")
                                        end
                                    else
                                        infobox:outputInfoBox("A büntetés értéke csak pénzösszeg lehet.", "error")
                                    end
                                else
                                    infobox:outputInfoBox("A szabályszegés leírásának minimum 5 és maximum "..penaltieLimits["desc"].." karakterből kell álnia.", "error")
                                end
                            else
                                infobox:outputInfoBox("A szabályszegés nevének minimum 5 és maximum "..penaltieLimits["name"].." karakterből kell álnia.", "error")
                            end
                        end
                    end
                end
            elseif page == 6 then         
                local startY = posY + sy*0.065 + 3/myY*sy
                for i = 1, 12 do 
                    local alpha = 150
                    if (i + wantedCarsScroll) % 2 == 0 then 
                        alpha = 220
                    end
                            
                    local v = clientMDCDatas["users"][mdcUsersScroll + i]
        
                    if v then 
                        if core:isInSlot(posX + sx*0.35, startY, sx*0.02, sy*0.03) then
                            if v[5] == 1 then
                                if v[4] == mdcAccountDatas["faction"] then 
                                    triggerServerEvent("mdc > deleteDataFromMDC", resourceRoot, "users", v[1])
                                    infobox:outputInfoBox("Sikeresen töröltél egy mdc felhasználót!", "success")
                                else
                                    infobox:outputInfoBox("Csak a saját szervezetedbe tartozó felhasznlókat törölheted!", "error")
                                end
                            else
                                infobox:outputInfoBox("Ezt a fiókot nem törölheted ki!", "error")
                            end
                        end
                    end
        
                    startY = startY + sy*0.032
                end
                
                if core:isInSlot(posX + sx*0.006, posY + sy*0.555, 650/myX*sx, 32/myY*sy) then 
                    local username, password = core:getEditboxText("u_name"), core:getEditboxText("u_pass")

                    if string.len(username) >= 3 and string.len(username) <= 12 then 
                        if string.len(password) >= 3 and string.len(password) <= 12 then 
                            infobox:outputInfoBox("Sikeresen létrehoztál egy felhasználói fiókot!", "success")

                            triggerServerEvent("mdc > addDataToMDC", resourceRoot, "users", {username, password, mdcAccountDatas["faction"]})

                            core:setEditboxText("u_name", mdcEditboxs[6][1].text)
                            core:setEditboxText("u_pass", mdcEditboxs[6][2].text)
                        else
                            infobox:outputInfoBox("A fiók jelszavának 3-12 karakterből kell állnia!", "error")
                        end
                    else
                        infobox:outputInfoBox("A fiók felhasználónevének 3-12 karakterből kell állnia!", "error")
                    end
                end
            elseif page == 7 then 
                if core:isInSlot(posX + sx*0.3, posY + sy*0.07, 100/myX*sx, 32/myY*sy) then 
                    local searchValue = core:getEditboxText("search_value")

                    if getTickCount() - lastSearch > 1500 then 
                        lastSearch = getTickCount()

                        if search_panelData then
                            if search_type == "veh" then 
                                if not (search_panelData["plateText"] == searchValue) then 
                                    getMDCData(search_type, searchValue)
                                else
                                end
                            else
                                if not (search_panelData["charname"]:gsub("_", " ") == searchValue) then 
                                    getMDCData(search_type, searchValue)
                                else
                                end
                            end
                        else
                            getMDCData(search_type, searchValue)
                        end
                    else
                        infobox:outputInfoBox("Ne ilyen gyorsan!", "warning")
                    end
                end

                if core:isInSlot(posX + sx*0.16, posY + sy*0.07, 240/myX*sx, sy*0.035) then 
                    if search_type == "veh" then 
                        search_type = "char"
                    else
                        search_type = "veh"
                    end

                    search_panelData = false 
                    search_panelOthers = false
                end
            end
        elseif key == "mouse_wheel_up" then 
            if page == 1 then 
            elseif page == 2 then 
            elseif page == 3 then 
                if core:isInSlot(posX + sx*0.005, posY + sy*0.1, sx*0.37, sy*0.49) then 
                    if wantedPersonsScroll > 0 then wantedPersonsScroll = wantedPersonsScroll - 1 end
                end
            elseif page == 4 then 
                if core:isInSlot(posX + sx*0.005, posY + sy*0.1, sx*0.37, sy*0.49) then 
                    if wantedCarsScroll > 0 then wantedCarsScroll = wantedCarsScroll - 1 end
                end
            elseif page == 5 then 
                if core:isInSlot(posX + sx*0.005, posY + sy*0.1, sx*0.37, sy*0.49) then 
                    if penaltiesScroll > 0 then penaltiesScroll = penaltiesScroll - 1 end
                end
            elseif page == 6 then 
                if core:isInSlot(posX + sx*0.005, posY + sy*0.1, sx*0.37, sy*0.49) then 
                    if mdcUsersScroll > 0 then mdcUsersScroll = mdcUsersScroll - 1 end
                end
            elseif page == 7 then 
                if searchScroll > 0 then searchScroll = searchScroll - 1 end
            end
        elseif key == "mouse_wheel_down" then 
            if page == 1 then 
            elseif page == 2 then 
            elseif page == 3 then 
                if core:isInSlot(posX + sx*0.005, posY + sy*0.1, sx*0.37, sy*0.49) then 
                    if clientMDCDatas["wanted_persons"][5 + wantedPersonsScroll + 1] then wantedPersonsScroll = wantedPersonsScroll + 1 end
                end
            elseif page == 4 then 
                if core:isInSlot(posX + sx*0.005, posY + sy*0.1, sx*0.37, sy*0.49) then 
                    if clientMDCDatas["wanted_cars"][5 + wantedCarsScroll + 1] then wantedCarsScroll = wantedCarsScroll + 1 end
                end
            elseif page == 5 then 
                if core:isInSlot(posX + sx*0.005, posY + sy*0.1, sx*0.37, sy*0.49) then 
                    if clientMDCDatas["penalties"][penaltiesFaction][penaltiesListMaxCount + penaltiesScroll + 1] then penaltiesScroll = penaltiesScroll + 1 end
                end
            elseif page == 6 then 
                if core:isInSlot(posX + sx*0.005, posY + sy*0.1, sx*0.37, sy*0.49) then 
                    if clientMDCDatas["users"][12 + mdcUsersScroll + 1] then mdcUsersScroll = mdcUsersScroll + 1 end
                end
            elseif page == 7 then 
                if search_panelOthers[5 + searchScroll + 1] then searchScroll = searchScroll + 1 end
            end
        end
    end
end

function setMDCPage(mdc_page)
    if mdc_page == 6 then 
        if not (mdcAccountDatas["access"] >= 2) then return end
    end

    if mdcEditboxs[page] then 
        for k, v in ipairs(mdcEditboxs[page]) do 
            core:deleteEditbox(v.name)
        end
    end

    cAnimTick = getTickCount()
    cAlpha = 0

    page = mdc_page
    posX, posY, width, height = mdcPageDatas[page].posX * sx, mdcPageDatas[page].posY * sy, mdcPageDatas[page].width * sx, mdcPageDatas[page].height * sy

    cAnimTick = getTickCount()

    setTimer(function()
        if mdcEditboxs[page] then
            for k, v in ipairs(mdcEditboxs[page]) do 
                core:deleteEditbox(v.name)
            end

            createEditboxes()
        end
    end, 500, 1)
end

function createEditboxes()
    for k, v in ipairs(mdcEditboxs[page]) do 
        if page == 5 then 
            if k > 1 then 
                if not (mdcAccountDatas["access"] == 2) then return end
            end
        end

        if v.openType then 
            if (v.openType == openType) then 
                core:createEditbox(posX + sx * v.x, posY + sy * v.y, sx * v.w, sy * v.h, v.name, v.text, v.type, true, {30, 30, 30, 255}, v.maxFontScale)
            end
        else
            core:createEditbox(posX + sx * v.x, posY + sy * v.y, sx * v.w, sy * v.h, v.name, v.text, v.type, true, {30, 30, 30, 255}, v.maxFontScale)
        end

        if openType == "veh" then
            if page == 2 then 
                local unitNumber = getElementData(getPedOccupiedVehicle(localPlayer), "mdc:unitNumber")

                if string.len(unitNumber) > 0 then
                    core:setEditboxText("enumber", unitNumber)
                end
            end
        end
    end
end

local mdcOpenState = false
local mdcIsCloseing = false
function openMDC()
    if mdcOpenState then return end 

    triggerServerEvent("mdc > getMDCDatasFromServer", resourceRoot)
    
    mdcOpenState = true
    setMDCPage(1)



    cAnimTick = getTickCount()
    bgAnimTick = getTickCount()
    bgAnimState = "open"
    cAnimState = "open"

    addEventHandler("onClientRender", root, renderMDC)
    addEventHandler("onClientKey", root, keyMDC)
end

function closeMDC()
    if mdcIsCloseing then return end 

    mdcIsCloseing = true
    cAnimTick = getTickCount()
    bgAnimTick = getTickCount()
    bgAnimState = "close"
    cAnimState = "close"

    if mdcEditboxs[page] then 
        for k, v in ipairs(mdcEditboxs[page]) do 
            core:deleteEditbox(v.name)
        end
    end

    removeEventHandler("onClientKey", root, keyMDC)
    setTimer(function()
        removeEventHandler("onClientRender", root, renderMDC)
        mdcOpenState = false
        mdcIsCloseing = false
    end, 500, 1)

    if isElement(openedPC) then 
        setElementData(openedPC, "policePC:inUse", false)
        openedPC = nil
    end
end


function exitingVehicle(player, seat, door)
	if getElementData(source,"mdc:mdcInUse") then
        closeMDC()
        setElementData(source, "mdc:mdcInUse", false)
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), exitingVehicle)



addCommandHandler("mdc", function()
    local occupiedVeh = getPedOccupiedVehicle(localPlayer)
    if occupiedVeh then 
        if getPedOccupiedVehicleSeat(localPlayer) <= 1 then
            if getElementData(occupiedVeh, "veh:isFactionVehice") == 1 then
                if dashboard:getFactionType(getElementData(occupiedVeh, "veh:owner") or 0) == 1 then 
                    local faction = getElementData(localPlayer, "char:duty:faction") or 0

                    if faction > 0 then 
                        if dashboard:getFactionType(faction) == 1 then 
                            if not mdcOpenState then
                                openType = "veh"
                                if (getElementData(occupiedVeh, "mdc:mdcInUse") or false) then return end

                                local occupiedVehMDCDatas = getElementData(occupiedVeh, "mdc:vehicleLoginDatas") or false 

                                openMDC()
                                if occupiedVehMDCDatas then
                                    setMDCPage(2)
                                    mdcAccountDatas["user"] = occupiedVehMDCDatas[1]
                                    mdcAccountDatas["access"] = occupiedVehMDCDatas[2]
                                    mdcAccountDatas["faction"] = occupiedVehMDCDatas[3]
                                    mdcAccountDatas["id"] = occupiedVehMDCDatas[4]
                                end

                                setElementData(occupiedVeh, "mdc:mdcInUse", true)
                            else
                                closeMDC()
                                setElementData(occupiedVeh, "mdc:mdcInUse", false)
                            end
                        end
                    end
                end
            end
        end
    end
end)

addEventHandler("onClientClick", root, function(key, state, _, _, _, _, _, element)
    if key == "right" and state == "up" then 
        if isElement(element) then 
            if getElementData(element, "policePC") then 
                if core:getDistance(element, localPlayer) < 1.5 then 
                    local faction = getElementData(localPlayer, "char:duty:faction") or 0

                    if faction > 0 then 
                        if dashboard:getFactionType(faction) == 1 then 
                            if not getPedOccupiedVehicle(localPlayer) then
                                if isElement(getElementData(element, "policePC:inUse")) then 
                                    outputChatBox(core:getServerPrefix("red-dark", "PC", 2).."Ez a laptop jelenleg használatban van!", 255, 255, 255, true)
                                else
                                    setElementData(element, "policePC:inUse", localPlayer)
                                    openType = "obj"
                                    openedPC = element
                                    openMDC()
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)



addEventHandler("onClientResourceStop", resourceRoot, function()
    if mdcEditboxs[page] then 
        for k, v in ipairs(mdcEditboxs[page]) do 
            core:deleteEditbox(v.name)
        end
    end
end)

addEventHandler("onClientElementDataChange", root, function(data, old, new)
    if data == "mdc:unitState" then 
        local faction = getElementData(localPlayer, "char:duty:faction") or 0

        if faction > 0 then 
            if dashboard:getFactionType(faction) == 1 then 
                local unitNumber = getElementData(source, "mdc:unitNumber")
                if string.len(unitNumber) > 0 then 
                    outputChatBox(core:getServerPrefix("blue-light-2", "MDC", 2)..color..unitNumber.." #ffffffazonosítóval rendelkező egység megváltoztatta az állapotát: "..new[5]..new[1].."#ffffff.", 255, 255, 255, true)
                end
            end
        end
    end
end)

--exports.oAdmin:addAdminCMD("delmdcuser", 7, "MDC fiók törlése")
--exports.oAdmin:addAdminCMD("addmdcuser", 7, "MDC fiók létrehozása")

local valueGet = getTickCount()

function getMDCData(type, name)
    valueGet = getTickCount() 
    search_panelData = false
    search_panelOthers = false 
    searchScroll = 0

    triggerServerEvent("mdc > getData", resourceRoot, type, name)

end
--getMDCData("veh", "3XLV277")


addEvent("mdc > sendData", true)
addEventHandler("mdc > sendData", resourceRoot, function(data1, data2)
    search_panelData = data1[1]
    search_panelOthers = data2
end)

addCommandHandler("setmdcjaror", function()
    local unitNumber = getElementData(getPedOccupiedVehicle(localPlayer), "mdc:unitNumber")
    if string.len(unitNumber) > 0 then 
        setElementData(getPedOccupiedVehicle(localPlayer), "mdc:unitState", {"Járőr", 3, 140, 252, "#038cfc"})                            
    end
end)

addCommandHandler("setmdculdozes", function()
   local unitNumber = getElementData(getPedOccupiedVehicle(localPlayer), "mdc:unitNumber")
    if string.len(unitNumber) > 0 then 
        setElementData(getPedOccupiedVehicle(localPlayer), "mdc:unitState", {"Üldözés", 219, 42, 39, "#db2a27"})                            
    end
end)

addCommandHandler("setmdcerosites", function()
    local unitNumber = getElementData(getPedOccupiedVehicle(localPlayer), "mdc:unitNumber")
    if string.len(unitNumber) > 0 then 
        setElementData(getPedOccupiedVehicle(localPlayer), "mdc:unitState", {"Erősítés", 219, 42, 39, "#db2a27"})
    end
end)
