setElementData(localPlayer, "dashboard:inTrade", false)

sx, sy = guiGetScreenSize()
myX, myY = 1600, 900
local rel = ((sx/1920)+(sy/1080))/2

local bg

local activePage = 1
local icons = {}
local avatars = {}

local tick = getTickCount()
local pageNameTick = getTickCount()
local pageBgTick = getTickCount()
local adminPagePanelTick = getTickCount()
local vehicleDataPanelTick = getTickCount()

local pedRotating = false
local pedRotating_DefaultCursorPos = {}
local pedRotation = 180
local posnovekedes = 0

local Player3D 
local Player3dView
local Vehicle3D
local Vehicle3dView

local oldRot = 0

local dashShowing = false

local vehicleScroll = 0
local selectedVehLine = 0
local interiorScroll = 0

local mapVehicleBlip = false
local mapVehicleMarker = false

-- Option panel --
local sliderEditingVignette = 0

local crosshairColorButtons = {}

for i = 1, #crosshairColors do 
    table.insert(crosshairColorButtons, {"N", getTickCount(), 0})
end

local optionsScrolls = {
    ["graphic"] = 0,
    ["char"] = 0,
    ["other"] = 0,
}

crosshairDatas = {1, {255, 255, 255}}
------------------

-- Frakció panel --
local selectedFactionLine = 0
local factionPanelPage = 1

local selectedMemberLine = 0
local selectedRankLine = 0
local selectedDutyLine = 0
local selectedFactionVehLine = 1

local setPlayerRankTimer = false

local factionLeader_buttonPressNumbers = {0, 0, 0, 0, 0, 0}

local factionPanelMembersPointer = 0
local factionPanelRanksPointer = 0
local factionPanelDutysPointer = 0

local factionPanelDutyItemsPointer = 0
local factionPanelDutySkinsPointer = 0

local factionPanelSkinsPointer = 0

local factionPanelVehiclePointer = 0

local isDutySkinPreview = false
local dutySkinPreviewModel = false
local dutySkinPreviewModelID = 0

local factionDutyElements_temp = {
    ["items"] = {},
    ["skins"] = {},
}

local factionVehicles = {}

local factionAttachedDuty = 0

local isLeaderPanelShowing = false
local leaderMoneyTransactionCol = createColSphere(1680.5516357422,-1189.6547851562,23.837814331055, 6)

local factionLeaderOptionsPointer = 0
------------------

local slotPanelShowing = false
local slotPanelState = "int"

local slotPanelTick = getTickCount()
local slotPanelAnimState = "open"
local slotPanelAlpha = 0

--[[_dxDrawImage = dxDrawImage 
local ImageTextures = {}

local function dxDrawImage(x, y, w, h, image, rot, rotX, rotY, color, postGui)
	if type(image) == "string" then 
		if not ImageTextures[image] then 
			ImageTextures[image] = dxCreateTexture(image, "dxt5")
		end
		image = ImageTextures[image]
	end
	_dxDrawImage(x, y, w, h, image, rot, rotX, rotY, color, postGui)
end]]
-------------------

fonts = {
    ["condensed-bold"] = font:getFont("condensed", 12),
    ["condensed-bold-9"] = font:getFont("condensed", 9),
    ["condensed-bold-11"] = font:getFont("condensed", 11),
    ["condensed-bold-25"] = font:getFont("condensed", 25),
    ["bebasneue-18"] = font:getFont("bebasneue",18),
    ["bebasneue-25"] = font:getFont("bebasneue",25),
    ["bebasneue-20"] = font:getFont("bebasneue",20),

    ["fontawesome-15"] = font:getFont("fontawesome2", 15),
    ["fontawesome-25"] = font:getFont("fontawesome2", 40),

}

local vagyon = {
    ["vehicles"] = {},
    ["interiors"] = {},

    ["vehSlot"] = 0, 
    ["intSlot"] = 0,
}

local faction_datas = {
    factions = {},
    members = {},
}

local selectedEditbox = false

local editboxs = {
    ["faction_member_join"] = "",

    ["faction_rank_create"] = "",

    ["faction_rank_name"] = "",
    ["faction_rank_payment"] = "",

    ["faction_duty_create"] = "",

    ["faction_duty_name"] = "",

    ["faction_leader_description"] = "",
    ["faction_leader_bank_money"] = "0",
    ["faction_skins_adding"] = "0",
}

local selectedPremiumPanel = 1
local premiumPanelPointer = 0
local premiumPanelPointer2 = 0
local premiumPanelLastClickedElement = 0 

local carSellPanelShowing = true

local selledCar = false
local selledInt = false

local activeInteriorMarker = nil

addEventHandler("onClientMarkerHit", root, function(element, mdim)
    if (mdim and element == localPlayer) then 
        if getElementData(source, "isIntMarker") then 
            activeInteriorMarker = source
        end
    end
end)

addEventHandler("onClientMarkerLeave", root, function(element, mdim)
    if mdim and element == localPlayer then 
        if activeInteriorMarker == source then 
            activeInteriorMarker = nil
        end
    end
end)

addEventHandler("onClientResourceStart", getRootElement(), function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oDashboard" or getResourceName(res) == "oFont" or getResourceName(res) == "oInventory" or getResourceName(res) == "oPreview" or getResourceName(res) == "oAdmin" or getResourceName(res) == "oJob" or getResourceName(res) == "oInterface" or getResourceName(res) == "oVehicle" then  
        
        
        core = exports.oCore
        preview = exports.oPreview
        infobox = exports.oInfobox
        mysql = exports.oMysql
        inventory = exports.oInventory
        font = exports.oFont
        admin = exports.oAdmin
        job = exports.oJob
        interface = exports.oInterface
        vehicle = exports.oVehicle
        color, r, g, b = core:getServerColor()
        serverColor, r, g, b = core:getServerColor()
        moneyColor = "#7cc576"
    elseif res == getThisResource() then 
        setElementData(localPlayer, "dashboard:veh", false)
        moneyColor = "#7cc576"
	end
end)

local onlienPlayers = getElementsByType("player")
local callAdminTimer = false

local dailySpin = getTickCount()

local adminScrolls = {
    ["as"] = 0,
    ["ad"] = 0,
    ["ve"] = 0,
}

local onlineAdmins = {
    ["as"] = {},
    ["ad"] = {},
    ["ve"] = {},
}

local slotPanelNum = 0
local vehicleInfoScroll = 0

function createRandomDailyGifts()
    local createdGifts = {}

    for i = 1, 6 do 

        table.insert(createdGifts, dailyGifts["small"][math.random(#dailyGifts["small"])])

        if i == 1 then

            createdGifts[i][20] = true
        else
            createdGifts[i][20] = false
        end
        createdGifts[i][21] = false

        local date = getRealTime()

        createdGifts[i][22] = getTimestamp(date.year + 1900, date.month + 1, date.monthday + (i - 1), date.hour, date.minute, date.second)
    end
    table.insert(createdGifts, dailyGifts["big"][math.random(#dailyGifts["big"])])
    createdGifts[7][20] = true
    createdGifts[7][21] = false
    createdGifts[7][22] = getTimestamp(date.year + 1900, date.month + 1, date.monthday + 6, date.hour, date.minute, date.second)

    return createdGifts
end

function render()
    local alpha_panel = interpolateBetween(0,0,0,1,0,0,(getTickCount()-tick)/500,"Linear")
    dxDrawImage(0,0,sx,sy,"files/bg.png",0,0,0,tocolor(255,255,255,255*alpha_panel))

    if core:isInSlot(sx*0.78, sy*0.13, sx*0.12, sy*0.07) then 
        dxDrawImage(0, 0, sx, sy,"files/bug.png", 0, 0, 0, tocolor(r, g, b, 255*alpha_panel))
    else
        dxDrawImage(0, 0, sx, sy,"files/bug.png", 0, 0, 0, tocolor(255, 255, 255, 255*alpha_panel))
    end

    dxDrawText(color.."Original#ffffffRoleplay",sx*0.15,sy*0.14,_,_,tocolor(255,255,255,255*alpha_panel),1/myX*sx,fonts["condensed-bold"],_,_,false,false,false,true)
    local alpha_pagename = interpolateBetween(0,0,0,1,0,0,(getTickCount()-pageNameTick)/500,"Linear")
    dxDrawText(pages[activePage][1],sx*0.15,sy*0.165,_,_,tocolor(255,255,255,255*alpha_pagename),0.9/myX*sx,fonts["condensed-bold"],_,_,false,false,false,true)

    local alpha_menuicon = interpolateBetween(0.5,0,0,1,0,0,(getTickCount()-pageNameTick)/350,"Linear")
    local hoverStart = sy*0.21
    for k,v in pairs(pages) do 
        if activePage == k then 
            dxDrawImage(0,0,sx,sy,icons[v[2]],0,0,0,tocolor(255, 255, 255, 255*alpha_panel))
        else
           -- if fileExists("files/icons/"..v[2]) then 
                --if core:isInSlot(sx*0.105,hoverStart,sx*0.03,sy*0.05) then 
                --  dxDrawImage(0,0,sx,sy,"files/icons/"..v[2],0,0,0,tocolor(r,g,b,255*alpha_panel))
                --else
                    dxDrawImage(0,0,sx,sy,icons[v[2]],0,0,0,tocolor(255, 255, 255, 150*alpha_panel))
                --end
           -- end
        end

        hoverStart = hoverStart + sy*0.072
    end
    
    local alpha_pagebg = interpolateBetween(0,0,0,1,0,0,(getTickCount()-pageNameTick)/250,"Linear")
    if activePage == 1 then 
        -- karakter statisztikák
            dxDrawRectangle(sx*0.165,sy*0.3,sx*0.27,sy*0.05,tocolor(27,27,27,220*alpha_pagebg))
                dxDrawText("Karakter Statisztikák",sx*0.165,sy*0.3,sx*0.165+sx*0.27,sy*0.3+sy*0.05,tocolor(255,255,255,255*alpha_pagebg),1/myX*sx,fonts["bebasneue-18"],"center","center")
            dxDrawRectangle(sx*0.165,sy*0.3+sy*0.05,sx*0.27,sy*0.4,tocolor(27,27,27,100*alpha_pagebg))

            local startY = sy*0.355
            for k, v in pairs(charStats) do 
                local color = tocolor(26,26,26,255*alpha_pagebg)

                if (k % 2) == 0 then 
                    color = tocolor(22,22,22,255*alpha_pagebg)
                end
                dxDrawRectangle(sx*0.165,startY, sx*0.27, sy*0.03, color)

                dxDrawText(v[1],sx*0.168,startY,sx*0.168+sx*0.26,startY+sy*0.03,tocolor(255,255,255,255*alpha_pagebg),1/myX*sx,fonts["condensed-bold-9"],"left","center")

                local data = getElementData(localPlayer,v[2])
                local utotag = ""

                if k == 2 then 
                    if data == 1 then 
                        data = "Nő"
                    elseif data == 2 then 
                        data = "Férfi"
                    else
                        data = "nan"
                    end
                elseif k == 3 then 
                    utotag = " éves"
                elseif k == 4 then 
                    utotag = " kg"
                elseif k == 5 then 
                    utotag = " cm"
                elseif k == 6 then 
                    data = getElementModel(localPlayer) or v[2]
                elseif k == 7 then 
                    if not data then 
                        data = "Munkanélküli"
                    else
                        if data > 0 then 
                            data = job:getJobName(data)
                        else
                            data = "Munkanélküli"
                        end
                    end
                elseif k == 8 then 
                    if not data then 
                        local factions = getPlayerAllFactions()
                        if #factions > 0 then 
                            data = #factions
                            utotag = " db"
                        else
                            data = "Nem vagy tagja szervezetnek"
                        end
                    end
                elseif k == 9 then 
                   utotag = " perc"
                elseif k == 10 then 
                    utotag = "$"
                elseif k == 11 then 
                    data = #vagyon["vehicles"]
                    utotag = " db"
                elseif k == 12 then 
                    data = #vagyon["interiors"]
                    utotag = " db"
                end
                dxDrawText(tostring(data):gsub("_"," ")..utotag,sx*0.168,startY,sx*0.168+sx*0.265,startY+sy*0.03,tocolor(r,g,b,255*alpha_pagebg),1/myX*sx,fonts["condensed-bold-9"],"right","center")

                startY = startY + sy*0.033
            end

        -- felhasználói információk
            dxDrawRectangle(sx*0.605,sy*0.3,sx*0.27,sy*0.05,tocolor(27,27,27,220*alpha_pagebg))
                dxDrawText("Felhasználói információk",sx*0.605,sy*0.3,sx*0.605+sx*0.27,sy*0.3+sy*0.05,tocolor(255,255,255,255*alpha_pagebg),1/myX*sx,fonts["bebasneue-18"],"center","center")
            dxDrawRectangle(sx*0.605,sy*0.3+sy*0.05,sx*0.27,sy*0.4,tocolor(27,27,27,100*alpha_pagebg))

            startY = sy*0.355
            for k, v in ipairs(userStats) do 
                local color = tocolor(26,26,26,255*alpha_pagebg)

                if (k % 2) == 0 then 
                    color = tocolor(22,22,22,255*alpha_pagebg)
                end
                dxDrawRectangle(sx*0.605,startY, sx*0.27, sy*0.03, color)

                dxDrawText(v[1],sx*0.608,startY,sx*0.608+sx*0.26,startY+sy*0.03,tocolor(255,255,255,255*alpha_pagebg),1/myX*sx,fonts["condensed-bold-9"],"left","center")

                local data = getElementData(localPlayer,v[2])
                local utotag = ""

                if k == 4 then 
                    data = exports.oAdmin:getAdminPrefix(data)
                elseif k == 10 then
                    data = data[1] .." óra "..data[2].." perc"
                elseif k == 7 or k == 8 or k == 9 then 
                    utotag = " db"
                    data = tostring(data[k-6])
                end
                dxDrawText(tostring(data):gsub("_"," ")..utotag,sx*0.608,startY,sx*0.608+sx*0.265,startY+sy*0.03,tocolor(r,g,b,255*alpha_pagebg),1/myX*sx,fonts["condensed-bold-9"],"right","center")

                startY = startY + sy*0.033
            end

            --dxDrawRectangle(sx*0.165, sy*0.705, sx*0.27, sy*0.05,tocolor(27,27,27,220*alpha_pagebg))
            --dxDrawRectangle(sx*0.165, sy*0.756, sx*0.27, sy*0.05,tocolor(27,27,27,220*alpha_pagebg))
            --dxDrawRectangle(sx*0.165, sy*0.807, sx*0.27, sy*0.05,tocolor(27,27,27,220*alpha_pagebg))
    elseif activePage == 2 then 
        dxDrawRectangle(sx*0.16,sy*0.22,sx*0.27,sy*0.04,tocolor(27,27,27,220*alpha_pagebg))
                dxDrawText("Járműveid",sx*0.16,sy*0.22,sx*0.16+sx*0.27,sy*0.22+sy*0.04,tocolor(255,255,255,200*alpha_pagebg),0.7/myX*sx,fonts["bebasneue-18"],"center","center")
        dxDrawRectangle(sx*0.16,sy*0.22+sy*0.04,sx*0.27,sy*0.3,tocolor(27,27,27,100*alpha_pagebg))

        local res = getResourceFromName("oVehicle") or false

        if res then 
            local szazalek = tonumber(#vagyon["vehicles"]/vagyon["vehSlot"])*100
            local textColor = color

            if szazalek < 25 then 
                textColor = "#6ba348"
            elseif szazalek >= 25 and szazalek < 75 then 
                textColor = color
            elseif szazalek >= 75 then 
                textColor = "#c21d1d"
            end 

            dxDrawText(textColor..#vagyon["vehicles"].."#ffffff/"..vagyon["vehSlot"], sx*0.16+5/myX*sx, sy*0.22, sx*0.16+5/myX*sx+sx*0.27, sy*0.22+sy*0.04, tocolor(255, 255, 255, 200*alpha_pagebg), 0.65/myX*sx, fonts["bebasneue-18"], "left", "center", false, false, false, true)
            
            if core:isInSlot(sx*0.33, sy*0.22, sx*0.1, sy*0.04) then
                dxDrawText("Jármű slot vásárlása", sx*0.16, sy*0.22, sx*0.16+sx*0.27-5/myX*sx, sy*0.22+sy*0.04, tocolor(255, 255, 255, 255*alpha_pagebg), 0.6/myX*sx, fonts["bebasneue-18"], "right", "center", false, false, false, true)
            else
                dxDrawText("Jármű slot vásárlása", sx*0.16, sy*0.22, sx*0.16+sx*0.27-5/myX*sx, sy*0.22+sy*0.04, tocolor(255, 255, 255, 200*alpha_pagebg), 0.6/myX*sx, fonts["bebasneue-18"], "right", "center", false, false, false, true)
            end

            if getResourceState(res) then
                if #vagyon["vehicles"] > 0 then 
                    local startY = sy*0.265
                    for i=1, 9 do 

                        if vagyon["vehicles"][i] then  

                            local color = tocolor(21,21,21,220*alpha_pagebg)
                            local color2 = tocolor(r,g,b,255*alpha_pagebg)

                            if (i+vehicleScroll)%2 == 0 then 
                                color = tocolor(28,28,28,220*alpha_pagebg)
                                color2 = tocolor(r,g,b,100*alpha_pagebg)
                            end

                            if vagyon["vehicles"][i+vehicleScroll][17] then 
                                color2 = tocolor(189, 49, 49, 255*alpha_pagebg)
                            end

                            if core:isInSlot(sx*0.16,startY,sx*0.265,sy*0.03) or selectedVehicleLine == i+vehicleScroll then 
                                dxDrawRectangle(sx*0.16,startY,sx*0.265,sy*0.03,tocolor(r,g,b,100))
                            else
                                dxDrawRectangle(sx*0.16,startY,sx*0.265,sy*0.03,color)
                            end

                            dxDrawRectangle(sx*0.16,startY,sx*0.001,sy*0.03,color2)

                            if vagyon["vehicles"][i+vehicleScroll][17] then 
                                dxDrawText("#e33030[Lefoglalva] #ffffff"..vagyon["vehicles"][i+vehicleScroll][1].." #e97619("..vagyon["vehicles"][i+vehicleScroll][2]..")",sx*0.165,startY,sx*0.165+sx*0.1,startY+sy*0.034,tocolor(220,220,220,255*alpha_pagebg),0.65/myX*sx,fonts["bebasneue-18"],"left","center",false,false,false,true)
                            else
                                if rareVehicles[vagyon["vehicles"][i+vehicleScroll][8]] then 
                                    dxDrawImage(sx*0.165, startY + sy*0.005, sy*0.02, sy*0.02, "files/premium.png", 0, 0, 0, tocolor(255, 255, 255, 255 * alpha_pagebg))
                                    dxDrawText(vagyon["vehicles"][i+vehicleScroll][1].." #e97619("..vagyon["vehicles"][i+vehicleScroll][2]..")",sx*0.18,startY,sx*0.18+sx*0.1,startY+sy*0.034,tocolor(220,220,220,255*alpha_pagebg),0.65/myX*sx,fonts["bebasneue-18"],"left","center",false,false,false,true)
                                else
                                    dxDrawText(vagyon["vehicles"][i+vehicleScroll][1].." #e97619("..vagyon["vehicles"][i+vehicleScroll][2]..")",sx*0.165,startY,sx*0.165+sx*0.1,startY+sy*0.034,tocolor(220,220,220,255*alpha_pagebg),0.65/myX*sx,fonts["bebasneue-18"],"left","center",false,false,false,true)
                                end
                            end

                            dxDrawText("Rendszám:#e97619 "..vagyon["vehicles"][i+vehicleScroll][5],sx*0.165,startY,sx*0.165+sx*0.257,startY+sy*0.034,tocolor(220,220,220,255*alpha_pagebg),0.65/myX*sx,fonts["bebasneue-18"],"right","center",false,false,false,true)

                            startY = startY + sy*0.0325

                        end
                    end

                    local lineHossz = 9/#vagyon["vehicles"]

                    if #vagyon["vehicles"] <= 9 then 
                        lineHossz = 1
                    end

                    dxDrawRectangle(sx*0.426, sy*0.265, sx*0.002, (sy*0.29),tocolor(r, g, b, 100*alpha_pagebg))
                    dxDrawRectangle(sx*0.426,sy*0.265+(sy*0.29*(lineHossz*vehicleScroll/9)),sx*0.002,(sy*0.29)*lineHossz,tocolor(r, g, b, 255*alpha_pagebg))
                else
                    dxDrawText("Nincs egyetlen járműved sem!",sx*0.16,sy*0.22+sy*0.04,sx*0.16+sx*0.27,sy*0.22+sy*0.04+sy*0.3,tocolor(220, 220, 220,255*alpha_pagebg),1/myX*sx,fonts["bebasneue-18"],"center","center")
                end

            else
                dxDrawText("Nem lehetséges az adatok lekérése!",sx*0.16,sy*0.22+sy*0.04,sx*0.16+sx*0.27,sy*0.22+sy*0.04+sy*0.3,tocolor(227, 98, 84,255*alpha_pagebg),1/myX*sx,fonts["bebasneue-18"],"center","center")
            end
        else
            dxDrawText("Nem lehetséges az adatok lekérése!",sx*0.16,sy*0.22+sy*0.04,sx*0.16+sx*0.27,sy*0.22+sy*0.04+sy*0.3,tocolor(227, 98, 84,255*alpha_pagebg),1/myX*sx,fonts["bebasneue-18"],"center","center")
        end

        if (tonumber(selectedVehicleLine) or 0) > 0 then 
            local vehDataPanelAlpha = interpolateBetween(0,0,0,1,0,0,(getTickCount()-vehicleDataPanelTick)/500,"Linear")
            dxDrawRectangle(sx*0.72,sy*0.39,sx*0.174,sy*0.04,tocolor(27,27,27,220*vehDataPanelAlpha))
            dxDrawText("Járműved adatai",sx*0.72,sy*0.39,sx*0.72+sx*0.174,sy*0.4+sy*0.04,tocolor(255,255,255,200*vehDataPanelAlpha),0.7/myX*sx,fonts["bebasneue-18"],"center","center")
            dxDrawRectangle(sx*0.72,sy*0.39+sy*0.04,sx*0.174,(sy*0.033)*13,tocolor(27,27,27,100*vehDataPanelAlpha))

            local startY = sy*0.39+sy*0.045
            for i=1, 13 do 
                local data = vehicleDatas[i + vehicleInfoScroll]
                local color = tocolor(21,21,21,220*vehDataPanelAlpha)

                if (i)%2 == 0 then 
                    color = tocolor(28,28,28,220*vehDataPanelAlpha)
                end

                --dxDrawRectangle(sx*0.72,startY,sx*0.170,sy*0.03,color)
                if core:isInSlot(sx*0.72,startY,sx*0.168,sy*0.03) then
                    dxDrawRectangle(sx*0.72,startY,sx*0.168,sy*0.03,tocolor(r,g,b,150*alpha_pagebg))
                else
                    dxDrawRectangle(sx*0.72,startY,sx*0.168,sy*0.03,color)
                end

                
                dxDrawText(data[1],sx*0.723,startY,sx*0.723+sx*0.1,startY+sy*0.03,tocolor(220,220,220,255*vehDataPanelAlpha),1/myX*sx,fonts["condensed-bold-9"],"left","center",false,false,false,true)

                if data[2] == 12 then 
                    local index = 0

                    if vagyon["vehicles"][selectedVehicleLine][data[2]] then 
                            index = index + 1
                            if string.match(toJSON(vagyon["vehicles"][selectedVehicleLine][data[2]]), data[3]) then 
                                --local tuningCat = tostring(v:gsub(vehicleDatas[i][3], ""):gsub("-", ""))
                                --tuningCat = tonumber(tuningCat)

                                local type = 0

                                for k, v in ipairs(vagyon["vehicles"][selectedVehicleLine][data[2]]) do 
                                    if string.match(v, data[3]) then 
                                        local tuningCat = tostring(v:gsub(data[3], ""):gsub("-", ""))
                                        type = tonumber(tuningCat)
                                    end
                                end

                                --print(toJSON(tuning_categories))
                                dxDrawText(tuning_categories[type],sx*0.721,startY,sx*0.721+sx*0.165,startY+sy*0.03,tocolor(r,g,b,255*vehDataPanelAlpha),1/myX*sx,fonts["condensed-bold-9"],"right","center",false,false,false,true)
                            else
                                dxDrawText("Gyári",sx*0.721,startY,sx*0.721+sx*0.165,startY+sy*0.03,tocolor(227, 98, 84,255*vehDataPanelAlpha),1/myX*sx,fonts["condensed-bold-9"],"right","center",false,false,false,true)
                            end
                    else
                        dxDrawText("Gyári",sx*0.721,startY,sx*0.721+sx*0.165,startY+sy*0.03,tocolor(227, 98, 84,255*vehDataPanelAlpha),1/myX*sx,fonts["condensed-bold-9"],"right","center",false,false,false,true)
                        --startY = startY + sy*0.0325
                    end
                else
                    if data[2] > 0 then
                        dxDrawText(vagyon["vehicles"][selectedVehicleLine][data[2]],sx*0.721,startY,sx*0.721+sx*0.165,startY+sy*0.03,tocolor(r,g,b,255*vehDataPanelAlpha),1/myX*sx,fonts["condensed-bold-9"],"right","center",false,false,false,true)
                    else
                        dxDrawText("Nincs adat",sx*0.721,startY,sx*0.721+sx*0.165,startY+sy*0.03,tocolor(227, 98, 84,255*vehDataPanelAlpha),1/myX*sx,fonts["condensed-bold-9"],"right","center",false,false,false,true)
                    end
                    --startY = startY + sy*0.0325
                end

                startY = startY + sy*0.0325
            end

           -- if #vehicleDatas <= 13 then 
            --    lineHossz = 1
            --end
            local scrollY = ((sy*0.0322)*13) / 13
            if #vehicleDatas > 13 then
                local listSize = scrollY * 13
                dxDrawRectangle(sx*0.72+sx*0.1701,sy*0.39+sy*0.045, sx*0.002, listSize,tocolor(r, g, b, 100*alpha_pagebg))
                dxDrawRectangle(sx*0.72+sx*0.1701,sy*0.39+sy*0.045+(listSize / #vehicleDatas) * math.min(vehicleInfoScroll, #vehicleDatas - 13), sx*0.002, (listSize / #vehicleDatas) * 13,tocolor(r, g, b, 255*alpha_pagebg))
            end
            --dxDrawRectangle(sx*0.72+sx*0.174,sy*0.39+sy*0.045, sx*0.002, (sy*0.0325)*13,tocolor(r, g, b, 100*alpha_pagebg))
            --dxDrawRectangle(sx*0.72+sx*0.174,sy*0.435+(sy*0.0325*lineHossz*vehicleInfoScroll/13), sx*0.002, (sy*0.0325)*lineHossz,tocolor(r, g, b, 255*alpha_pagebg))
                --dxDrawRectangle(sx*0.72+sx*0.174,sy*0.39+sy*0.045, sx*0.002, (sy*0.022)*13,tocolor(r, g, b, 100*alpha_pagebg))

            if core:isInSlot(sx*0.87,sy*0.396,sx*0.0156,sy*0.027) then 
                dxDrawImage(sx*0.87,sy*0.396,sx*0.0156,sy*0.027,"files/icons/placeholder.png",0,0,0,tocolor(r,g,b,255*vehDataPanelAlpha))
            else
                dxDrawImage(sx*0.87,sy*0.396,sx*0.0156,sy*0.027,"files/icons/placeholder.png",0,0,0,tocolor(220,220,220,255*vehDataPanelAlpha))
            end

            if core:isInSlot(sx*0.725,sy*0.396,sx*0.0156,sy*0.027) then 
                dxDrawImage(sx*0.725,sy*0.396,sx*0.0156,sy*0.027,"files/icons/sell.png",0,0,0,tocolor(r,g,b,255*vehDataPanelAlpha))
            else
                dxDrawImage(sx*0.725,sy*0.396,sx*0.0156,sy*0.027,"files/icons/sell.png",0,0,0,tocolor(220,220,220,255*vehDataPanelAlpha))
            end
        end

        dxDrawRectangle(sx*0.16,sy*0.6,sx*0.27,sy*0.04,tocolor(27,27,27,220*alpha_pagebg))
                dxDrawText("Ingatlanjaid",sx*0.16,sy*0.6,sx*0.16+sx*0.27,sy*0.6+sy*0.04,tocolor(255,255,255,200*alpha_pagebg),0.7/myX*sx,fonts["bebasneue-18"],"center","center")
        dxDrawRectangle(sx*0.16,sy*0.6+sy*0.04,sx*0.27,sy*0.203,tocolor(27,27,27,100*alpha_pagebg))

        local res = getResourceFromName("oInteriors") or false
        if res then 
            local szazalek = tonumber(#vagyon["interiors"]/vagyon["intSlot"])*100
            local textColor = color
            local ingatlanCount = #vagyon["interiors"]

            if szazalek < 25 then 
                textColor = "#6ba348"
            elseif szazalek >= 25 and szazalek < 75 then 
                textColor = color
            elseif szazalek >= 75 then 
                textColor = "#c21d1d"
            end 

            if getElementData(localPlayer,"hasContainer") then 
                ingatlanCount = ingatlanCount - 1
            end 

            dxDrawText(textColor..ingatlanCount.."#ffffff/"..vagyon["intSlot"], sx*0.16+5/myX*sx, sy*0.6, sx*0.16+5/myX*sx+sx*0.27, sy*0.6+sy*0.04, tocolor(255, 255, 255, 200*alpha_pagebg), 0.65/myX*sx, fonts["bebasneue-18"], "left", "center", false, false, false, true)

            if core:isInSlot(sx*0.33, sy*0.6, sx*0.1, sy*0.04) then 
                dxDrawText("Ingatlan slot vásárlása", sx*0.16, sy*0.6, sx*0.16+sx*0.27-5/myX*sx, sy*0.6+sy*0.04, tocolor(255, 255, 255, 255*alpha_pagebg), 0.6/myX*sx, fonts["bebasneue-18"], "right", "center", false, false, false, true)
            else
                dxDrawText("Ingatlan slot vásárlása", sx*0.16, sy*0.6, sx*0.16+sx*0.27-5/myX*sx, sy*0.6+sy*0.04, tocolor(255, 255, 255, 200*alpha_pagebg), 0.6/myX*sx, fonts["bebasneue-18"], "right", "center", false, false, false, true)
            end
            if #vagyon["interiors"] > 0 then 
                local startY = sy*0.645
                for i=1, 6 do 

                    if vagyon["interiors"][i+interiorScroll] then  

                        local color = tocolor(21,21,21,220*alpha_pagebg)
                        local color2 = tocolor(r,g,b,255*alpha_pagebg)

                        if (i+interiorScroll)%2 == 0 then 
                            color = tocolor(28,28,28,220*alpha_pagebg)
                            color2 = tocolor(r,g,b,100*alpha_pagebg)
                        end

                        if core:isInSlot(sx*0.16,startY,sx*0.265,sy*0.03) then 
                            dxDrawRectangle(sx*0.16,startY,sx*0.265,sy*0.03,tocolor(r,g,b,100))
                        else
                            dxDrawRectangle(sx*0.16,startY,sx*0.265,sy*0.03,color)
                        end

                        dxDrawRectangle(sx*0.16,startY,sx*0.001,sy*0.03,color2)

                        dxDrawText(vagyon["interiors"][i+interiorScroll][1].." #e97619("..vagyon["interiors"][i+interiorScroll][2]..")",sx*0.165,startY,sx*0.165+sx*0.1,startY+sy*0.034,tocolor(220,220,220,255*alpha_pagebg),0.65/myX*sx,fonts["bebasneue-18"],"left","center",false,false,false,true)                        
                        dxDrawText("Elhelyezkedés:#e97619 "..vagyon["interiors"][i+interiorScroll][4],sx*0.165,startY,sx*0.165+sx*0.228,startY+sy*0.034,tocolor(220,220,220,255*alpha_pagebg),0.6/myX*sx,fonts["bebasneue-18"],"right","center",false,false,false,true)

                        if vagyon["interiors"][i+interiorScroll][3] == 1 then
                            dxDrawImage(sx*0.395, startY+3/myY*sy, 20/myX*sx, 20/myY*sy, "files/icons/lock.png", 0, 0, 0, tocolor(189, 49, 49, 255*alpha_pagebg))
                        else
                            dxDrawImage(sx*0.395, startY+3/myY*sy, 20/myX*sx, 20/myY*sy, "files/icons/unlock.png", 0, 0, 0, tocolor(76, 173, 88, 255*alpha_pagebg))
                        end

                        if not (vagyon["interiors"][i+interiorScroll][5] == 5) then 
                            if core:isInSlot(sx*0.41, startY+3/myY*sy, 20/myX*sx, 20/myY*sy) then
                                dxDrawImage(sx*0.41, startY+3/myY*sy, 20/myX*sx, 20/myY*sy, "files/icons/sell.png", 0, 0, 0, tocolor(r, g, b, 255*alpha_pagebg))
                            else
                                dxDrawImage(sx*0.41, startY+3/myY*sy, 20/myX*sx, 20/myY*sy, "files/icons/sell.png", 0, 0, 0, tocolor(255, 255, 255, 255*alpha_pagebg))
                            end
                        else
                            dxDrawImage(sx*0.41, startY+3/myY*sy, 20/myX*sx, 20/myY*sy, "files/rent.png", 0, 0, 0, tocolor(r, g, b, 255*alpha_pagebg))

                            if core:isInSlot(sx*0.41, startY+3/myY*sy, 20/myX*sx, 20/myY*sy) then 
                                local cx, cy = getCursorPosition()
                                cx, cy = cx* sx, cy*sy 

                                local remaining = math.floor((vagyon["interiors"][i+interiorScroll][6]  - getRealTime().timestamp) % (60 * 60 * 24) / 3600) + 1
                                local rentText = serverColor..remaining.." #ffffffóra múlva jár le."
                                local textWidth = dxGetTextWidth(rentText, 0.8/myX*sx, fonts["condensed-bold-9"], true) + sx*0.01

                                dxDrawRectangle(cx - textWidth/2, cy + sy*0.015, textWidth, sy*0.025, tocolor(30, 30, 30, 255), true)

                                dxDrawText(rentText, cx - textWidth/2, cy + sy*0.015, cx - textWidth/2 + textWidth, cy + sy*0.015 + sy*0.025, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["condensed-bold-9"], "center", "center", false, false, true, true)
                            end
                        end
                        

                        startY = startY + sy*0.0325
                    end
                end

                local lineHossz = 6/#vagyon["interiors"]

                if #vagyon["interiors"] <= 6 then 
                    lineHossz = 1
                end

                dxDrawRectangle(sx*0.426, sy*0.645, sx*0.002, (sy*0.192), tocolor(r, g, b, 100*alpha_pagebg))
                dxDrawRectangle(sx*0.426, sy*0.645+(sy*0.192*(lineHossz*interiorScroll/6)), sx*0.002, (sy*0.192)*lineHossz, tocolor(r, g, b, 255*alpha_pagebg))
            else
                dxDrawText("Nincs egyetlen ingatlanod sem!",sx*0.16,sy*0.6+sy*0.04,sx*0.16+sx*0.27,sy*0.6+sy*0.04+sy*0.2,tocolor(220, 220, 220,255*alpha_pagebg),1/myX*sx,fonts["bebasneue-18"],"center","center")
            end
        else
            dxDrawText("Nem lehetséges az adatok lekérése!",sx*0.16,sy*0.6+sy*0.04,sx*0.16+sx*0.27,sy*0.6+sy*0.04+sy*0.2,tocolor(227, 98, 84,255*alpha_pagebg),1/myX*sx,fonts["bebasneue-18"],"center","center")
        end

        dxDrawRectangle(sx*0.435,sy*0.22,sx*0.46,sy*0.04,tocolor(27,27,27,220*alpha_pagebg))
        dxDrawText("Vagyon tárgyaid",sx*0.435,sy*0.22,sx*0.435+sx*0.46,sy*0.22+sy*0.04,tocolor(255,255,255,200*alpha_pagebg),0.7/myX*sx,fonts["bebasneue-18"],"center","center")
        dxDrawRectangle(sx*0.435,sy*0.22+sy*0.04,sx*0.46,sy*0.103,tocolor(27,27,27,100*alpha_pagebg))

        local startY = sy*0.265
        for i=1, #vagyonTargyak do 
            local color = tocolor(21,21,21,220*alpha_pagebg)
            local color2 = tocolor(r,g,b,255*alpha_pagebg)

            if (i)%2 == 0 then 
                color = tocolor(28,28,28,220*alpha_pagebg)
                color2 = tocolor(r,g,b,100*alpha_pagebg)
            end

            dxDrawRectangle(sx*0.435,startY,sx*0.458,sy*0.03,color)
            dxDrawRectangle(sx*0.435,startY,sx*0.001,sy*0.03,color2)

            local elotag = "$"
            local utotag = ""
            local color3 = moneyColor
            local type = 1
            local numbers = 15

            if i == 2 then 
                elotag = ""
                utotag = " cc"
                color3 = "#e97619"                
            end
            if i == 4 then 
                elotag = ""
                utotag = " PP"
                color3 = "#3d7abc"  
            end

            dxDrawText(vagyonTargyak[i][1],sx*0.44,startY,sx*0.435+sx*0.458,startY+sy*0.03,tocolor(220,220,220,255*alpha_pagebg),0.65/myX*sx,fonts["bebasneue-18"],"left","center")

            if i == 3 then 
                dxDrawText(color3..elotag.." #ffffff"..convertNumber(exports.oBank:getPlayerAllBankMoney(),numbers,color3)[2]..utotag,sx*0.44,startY,sx*0.435+sx*0.454,startY+sy*0.03,tocolor(220,220,220,255*alpha_pagebg),0.65/myX*sx,fonts["bebasneue-18"],"right","center",false,false,false,true)
            else
                dxDrawText(color3..elotag.." #ffffff"..convertNumber(getElementData(localPlayer,vagyonTargyak[i][2]),numbers,color3)[2]..utotag,sx*0.44,startY,sx*0.435+sx*0.454,startY+sy*0.03,tocolor(220,220,220,255*alpha_pagebg),0.65/myX*sx,fonts["bebasneue-18"],"right","center",false,false,false,true)
            end

            startY = startY + sy*0.0325
        end

        if slotPanelShowing then             
            if slotPanelAnimState == "open" then
                slotPanelAlpha = interpolateBetween(slotPanelAlpha, 0, 0, 1, 0, 0, (getTickCount() - slotPanelTick) / 300, "Linear")
            else
                slotPanelAlpha = interpolateBetween(slotPanelAlpha, 0, 0, 0, 0, 0, (getTickCount() - slotPanelTick) / 300, "Linear")
            end

            if slotPanelState == "int" then 
                core:drawWindow(sx*0.4, sy*0.4, sx*0.2, sy*0.15, "Ingatlan Slot Vásárlás", slotPanelAlpha)
            elseif slotPanelState == "veh" then 
                core:drawWindow(sx*0.4, sy*0.4, sx*0.2, sy*0.15, "Jármű Slot Vásárlás", slotPanelAlpha)
            end

            if core:isInSlot(sx*0.43, sy*0.445, 20/myX*sx, 20/myX*sx) then 
                dxDrawImage(sx*0.43, sy*0.445, 20/myX*sx, 20/myX*sx, "files/admin_panel/minus.png", 0, 0, 0, tocolor(r, g, b, 255 * slotPanelAlpha))
            else
                dxDrawImage(sx*0.43, sy*0.445, 20/myX*sx, 20/myX*sx, "files/admin_panel/minus.png", 0, 0, 0, tocolor(255, 255, 255, 255 * slotPanelAlpha))
            end

            if core:isInSlot(sx*0.57 - 20/myX*sx, sy*0.445, 20/myX*sx, 20/myX*sx) then 
                dxDrawImage(sx*0.57 - 20/myX*sx, sy*0.445, 20/myX*sx, 20/myX*sx, "files/admin_panel/plus.png", 0, 0, 0, tocolor(r, g, b, 255 * slotPanelAlpha))
            else
                dxDrawImage(sx*0.57 - 20/myX*sx, sy*0.445, 20/myX*sx, 20/myX*sx, "files/admin_panel/plus.png", 0, 0, 0, tocolor(255, 255, 255, 255 * slotPanelAlpha))
            end

            dxDrawText(slotPanelNum, sx*0.4, sy*0.4, sx*0.4 + sx*0.2, sy*0.4 + sy*0.12, tocolor(r, g, b, 255 * slotPanelAlpha), 0.85/myX*sx, fonts["condensed-bold-25"], "center", "center")
            dxDrawText("Slot Vásárlás: #497ff5" .. slotPanelNum * 100 .. "#ffffffPP", sx*0.4, sy*0.4, sx*0.4 + sx*0.2, sy*0.4 + sy*0.17, tocolor(255, 255, 255, 255 * slotPanelAlpha), 0.8/myX*sx, fonts["condensed-bold-11"], "center", "center", false, false, false, true)

            core:dxDrawButton(sx*0.4+6/myX*sx, sy*0.51, sx*0.1-12/myX*sx, sy*0.03, 76, 173, 88, 150 * slotPanelAlpha, "Vásárlás", tocolor(255, 255, 255, 255 * slotPanelAlpha), 0.8/myX*sx, fonts["condensed-bold-11"], true, tocolor(0, 0, 0, 100 * slotPanelAlpha))
            core:dxDrawButton(sx*0.5+6/myX*sx, sy*0.51, sx*0.1-12/myX*sx, sy*0.03, 189, 49, 49, 150 * slotPanelAlpha, "Mégsem", tocolor(255, 255, 255, 255 * slotPanelAlpha), 0.8/myX*sx, fonts["condensed-bold-11"], true, tocolor(0, 0, 0, 100 * slotPanelAlpha))
        end
    elseif activePage == 3 then 
        if core:isInSlot(sx*0.675, sy*0.805, sx*0.21, sy*0.05) then 
            dxDrawImage(0,0,sx,sy,"files/adminHelp.png",0,0,0,tocolor(r, g, b, 255*alpha_panel))
        else
            dxDrawImage(0,0,sx,sy,"files/adminHelp.png",0,0,0,tocolor(255, 255, 255, 255*alpha_panel))
        end

        local oldOnlineAdmins = onlineAdmins

        onlineAdmins = {
            ["as"] = {},
            ["ad"] = {},
            ["ve"] = {},
        }

        for k, v in ipairs(onlienPlayers) do 
            local alevel = (getElementData(v, "user:admin") or 0)
            if alevel == 1  then 
                table.insert(onlineAdmins["as"], v)
            elseif getElementData(v, "user:idgAs") then 
                table.insert(onlineAdmins["as"], v)
            elseif alevel >= 2 and alevel <= 6 then 
                table.insert(onlineAdmins["ad"], v)
            elseif alevel >= 7 then 
                table.insert(onlineAdmins["ve"], v)
            end
        end

        if not (oldOnlineAdmins == onlineAdmins) then 
            if math.abs(#onlineAdmins["as"] - #oldOnlineAdmins["as"]) > 0 then 
                adminScrolls["as"] = 0
            end

            if math.abs(#onlineAdmins["ad"] - #oldOnlineAdmins["ad"]) > 0 then 
                adminScrolls["ad"] = 0
            end

            if math.abs(#onlineAdmins["ve"] - #oldOnlineAdmins["ve"]) > 0 then 
                adminScrolls["ve"] = 0
            end
        end

        dxDrawRectangle(sx*0.147, sy*0.215, sx*0.22, sy*0.05,tocolor(27, 27, 27, 220*alpha_pagebg))
        dxDrawText("Adminsegéd Lista", sx*0.147,sy*0.215, sx*0.147+sx*0.22, sy*0.215+sy*0.05,tocolor(255,255,255,255*alpha_pagebg),1/myX*sx, fonts["bebasneue-18"],"center","center")
        dxDrawRectangle(sx*0.147, sy*0.215+sy*0.05, sx*0.22, sy*0.59, tocolor(27, 27, 27, 100*alpha_pagebg))

        dxDrawRectangle(sx*0.361, sy*0.215+sy*0.055, sx*0.002, sy*0.58, tocolor(r, g, b, 50*alpha_pagebg))
        local lineHeight = math.min(11 / (#onlineAdmins["as"] or 0), 1)
        dxDrawRectangle(sx*0.361, sy*0.215+sy*0.055 + (sy*0.58 * (lineHeight * adminScrolls["as"]/11)), sx*0.002, sy*0.58 * lineHeight, tocolor(r, g, b, 200*alpha_pagebg))

        local starty = sy*0.215+sy*0.055
        local alpha = 220
        for i = 1, 11 do 
            
            if i%2 == 0 then 
                alpha = 220
            else
                alpha = 150
            end

            dxDrawRectangle(sx*0.147, starty, sx*0.21, sy*0.05, tocolor(30, 30, 30, alpha*alpha_pagebg))

            local v = onlineAdmins["as"][i + adminScrolls["as"]]
            if v then 
                dxDrawText(getElementData(v, "char:name"):gsub("_", " "), sx*0.18, starty, sx*0.18+sx*0.3, starty+sy*0.035, tocolor(255, 255, 255, 255*alpha_pagebg), 0.8/myX*sx, fonts["bebasneue-18"], "left", "center", false, false, false, true)
                local adminColor = {hexToRGB(admin:getAdminColor(getElementData(v, "user:admin")))}
                if getElementData(v, "user:idgAs") then
                    dxDrawText("Ideiglenes AdminSegéd", sx*0.18, starty + sy*0.03, sx*0.18+sx*0.3, starty+sy*0.045, tocolor(adminColor[1], adminColor[2], adminColor[3], 150*alpha_pagebg), 0.7/myX*sx, fonts["condensed-bold"], "left", "center", false, false, false, true)
                else 
                    dxDrawText(admin:getAdminPrefix(getElementData(v, "user:admin")), sx*0.18, starty + sy*0.03, sx*0.18+sx*0.3, starty+sy*0.045, tocolor(adminColor[1], adminColor[2], adminColor[3], 150*alpha_pagebg), 0.7/myX*sx, fonts["condensed-bold"], "left", "center", false, false, false, true)
                end
                dxDrawRectangle(sx*0.147, starty, sx*0.001, sy*0.05, tocolor(adminColor[1], adminColor[2], adminColor[3], alpha*alpha_pagebg))

                dxDrawImage(sx*0.151, starty + sy*0.004, 38/myX*sx, 38/myY*sy, avatars[v], 0, 0, 0, tocolor(255, 255, 255, 255*alpha_pagebg))

                dxDrawText("/pm "..getElementData(v, "playerid"), sx*0.147, starty, sx*0.147+sx*0.20, starty+sy*0.05, tocolor(adminColor[1], adminColor[2], adminColor[3], 150*alpha_pagebg), 0.8/myX*sx, fonts["bebasneue-18"], "right", "center", false, false, false, true)
            end
            starty = starty + sy*0.053
        end

        dxDrawRectangle(sx*0.37, sy*0.215, sx*0.3, sy*0.05,tocolor(27, 27, 27, 220*alpha_pagebg))
        dxDrawText("Adminisztrátor Lista", sx*0.37, sy*0.215, sx*0.37+sx*0.3, sy*0.215+sy*0.05,tocolor(255,255,255,255*alpha_pagebg),1/myX*sx, fonts["bebasneue-18"],"center","center")
        dxDrawRectangle(sx*0.37, sy*0.215+sy*0.05, sx*0.3, sy*0.59, tocolor(27, 27, 27, 100*alpha_pagebg))

        dxDrawRectangle(sx*0.664, sy*0.215+sy*0.055, sx*0.002, sy*0.58, tocolor(r, g, b, 50*alpha_pagebg))
        local lineHeight = math.min(11 / (#onlineAdmins["ad"] or 0), 1)
        dxDrawRectangle(sx*0.664, sy*0.215+sy*0.055 + (sy*0.58 * (lineHeight * adminScrolls["ad"]/11)), sx*0.002, sy*0.58 * lineHeight, tocolor(r, g, b, 200*alpha_pagebg))

        local starty = sy*0.215+sy*0.055
        local alpha = 220
        for i = 1, 11 do 
            
            if i%2 == 0 then 
                alpha = 220
            else
                alpha = 150
            end

            dxDrawRectangle(sx*0.37, starty, sx*0.29, sy*0.05, tocolor(30, 30, 30, alpha*alpha_pagebg))

            local v = onlineAdmins["ad"][i + adminScrolls["ad"]]
            if v then 
                dxDrawText(getElementData(v, "user:adminnick"):gsub("_", " "), sx*0.403, starty, sx*0.403+sx*0.3, starty+sy*0.035, tocolor(255, 255, 255, 255*alpha_pagebg), 0.8/myX*sx, fonts["bebasneue-18"], "left", "center", false, false, false, true)
                local adminColor = {hexToRGB(admin:getAdminColor(getElementData(v, "user:admin")))}
                dxDrawText(admin:getAdminPrefix(getElementData(v, "user:admin")), sx*0.403, starty + sy*0.03, sx*0.403+sx*0.3, starty+sy*0.045, tocolor(adminColor[1], adminColor[2], adminColor[3], 150*alpha_pagebg), 0.7/myX*sx, fonts["condensed-bold"], "left", "center", false, false, false, true)
                dxDrawRectangle(sx*0.37, starty, sx*0.001, sy*0.05, tocolor(adminColor[1], adminColor[2], adminColor[3], alpha*alpha_pagebg))

                dxDrawImage(sx*0.374, starty + sy*0.004, 38/myX*sx, 38/myY*sy, avatars[v], 0, 0, 0, tocolor(255, 255, 255, 255*alpha_pagebg))

                local aduty = getElementData(v, "user:aduty") or false
                local hadmin = getElementData(v, "user:hadmin") or false
                if aduty and not hadmin then 
                    dxDrawText("/pm "..getElementData(v, "playerid"), sx*0.37, starty, sx*0.37+sx*0.28, starty+sy*0.05, tocolor(adminColor[1], adminColor[2], adminColor[3], 150*alpha_pagebg), 0.8/myX*sx, fonts["bebasneue-18"], "right", "center", false, false, false, true)
                else
                    dxDrawText("Nincs szolgálatban!", sx*0.37, starty, sx*0.37+sx*0.28, starty+sy*0.05, tocolor(adminColor[1], adminColor[2], adminColor[3], 150*alpha_pagebg), 0.7/myX*sx, fonts["bebasneue-18"], "right", "center", false, false, false, true)
                end
            end
            starty = starty + sy*0.053
        end

        dxDrawRectangle(sx*0.673, sy*0.215, sx*0.22, sy*0.05,tocolor(27, 27, 27, 220*alpha_pagebg))
        dxDrawText("Vezetőségi Tagok", sx*0.673, sy*0.215, sx*0.673+sx*0.22, sy*0.215+sy*0.05,tocolor(255,255,255,255*alpha_pagebg),1/myX*sx, fonts["bebasneue-18"],"center","center")
        dxDrawRectangle(sx*0.673, sy*0.215+sy*0.05, sx*0.22, sy*0.537, tocolor(27, 27, 27, 100*alpha_pagebg))

        dxDrawRectangle(sx*0.887, sy*0.215+sy*0.055, sx*0.002, sy*0.525, tocolor(r, g, b, 50*alpha_pagebg))
        local lineHeight = math.min(10 / (#onlineAdmins["ve"] or 0), 1)
        dxDrawRectangle(sx*0.887, sy*0.215+sy*0.055 + (sy*0.525 * (lineHeight * adminScrolls["ve"]/10)), sx*0.002, sy*0.525 * lineHeight, tocolor(r, g, b, 200*alpha_pagebg))

        local starty = sy*0.215+sy*0.055
        local alpha = 220
        for i = 1, 10 do 
            
            if i%2 == 0 then 
                alpha = 220
            else
                alpha = 150
            end

            dxDrawRectangle(sx*0.673, starty, sx*0.21, sy*0.05, tocolor(30, 30, 30, alpha*alpha_pagebg))

            local v = onlineAdmins["ve"][i + adminScrolls["ve"]]
            if v then 
                dxDrawText(getElementData(v, "user:adminnick"):gsub("_", " "), sx*0.706, starty, sx*0.706+sx*0.3, starty+sy*0.035, tocolor(255, 255, 255, 255*alpha_pagebg), 0.8/myX*sx, fonts["bebasneue-18"], "left", "center", false, false, false, true)
                local adminColor = {hexToRGB(admin:getAdminColor(getElementData(v, "user:admin")))}
                dxDrawText(admin:getAdminPrefix(getElementData(v, "user:admin")), sx*0.706, starty + sy*0.03, sx*0.706+sx*0.3, starty+sy*0.045, tocolor(adminColor[1], adminColor[2], adminColor[3], 150*alpha_pagebg), 0.7/myX*sx, fonts["condensed-bold"], "left", "center", false, false, false, true)
                dxDrawRectangle(sx*0.673, starty, sx*0.001, sy*0.05, tocolor(adminColor[1], adminColor[2], adminColor[3], alpha*alpha_pagebg))

                dxDrawImage(sx*0.677, starty + sy*0.004, 38/myX*sx, 38/myY*sy, ":oAccount/avatars/"..(getElementData(v, "char:avatarID") or 1)..".png", 0, 0, 0, tocolor(255, 255, 255, 255*alpha_pagebg))

                local aduty = getElementData(v, "user:aduty") or false
                local hadmin = getElementData(v, "user:hadmin") or false
                if aduty and not hadmin then 
                    dxDrawText("/pm "..getElementData(v, "playerid"), sx*0.673, starty, sx*0.673+sx*0.2, starty+sy*0.05, tocolor(adminColor[1], adminColor[2], adminColor[3], 150*alpha_pagebg), 0.8/myX*sx, fonts["bebasneue-18"], "right", "center", false, false, false, true)
                else
                    dxDrawText("Nincs szolgálatban!", sx*0.673, starty, sx*0.673+sx*0.2, starty+sy*0.05, tocolor(adminColor[1], adminColor[2], adminColor[3], 150*alpha_pagebg), 0.7/myX*sx, fonts["bebasneue-18"], "right", "center", false, false, false, true)
                end
            end
            starty = starty + sy*0.053
        end
    elseif activePage == 4 then 
        renderPanel_options(alpha_pagebg)
    elseif activePage == 5 then 
        if #faction_datas.factions > 0 then 
            dxDrawRectangle(sx*0.15,sy*0.22,sx*0.15,sy*0.04,tocolor(27,27,27,220*alpha_pagebg))
                dxDrawText("Szervezeteid",sx*0.15,sy*0.22,sx*0.15+sx*0.15,sy*0.22+sy*0.04,tocolor(255,255,255,255*alpha_pagebg),0.7/myX*sx,fonts["bebasneue-18"],"center","center")
            dxDrawRectangle(sx*0.15,sy*0.22+sy*0.04,sx*0.15,sy*0.59,tocolor(27,27,27,100*alpha_pagebg))
            
            local startY = sy*0.22+sy*0.045
            for k, v in ipairs(faction_datas.factions) do 
                local color = tocolor(21,21,21,220*alpha_pagebg)
                local color2 = tocolor(r,g,b,255*alpha_pagebg)

                if (k)%2 == 0 then 
                    color = tocolor(28,28,28,220*alpha_pagebg)
                    color2 = tocolor(r,g,b,100*alpha_pagebg)
                end

                if core:isInSlot(sx*0.15,startY,sx*0.15,sy*0.03) or selectedFactionLine == k then 
                   dxDrawRectangle(sx*0.15,startY,sx*0.15,sy*0.03,tocolor(r,g,b, 100*alpha_pagebg))
                else
                    dxDrawRectangle(sx*0.15,startY,sx*0.15,sy*0.03,color)
                end

                dxDrawRectangle(sx*0.15,startY,sx*0.001,sy*0.03,color2)
                if getElementData(localPlayer, "char:mainFaction") == v then
                    dxDrawText(client_faction_list[v][2],sx*0.155,startY,sx*0.155+sx*0.1,startY+sy*0.03,tocolor(255,255,255,255*alpha_pagebg),1/myX*sx,fonts["condensed-bold-9"],"left","center",false,false,false,true)
                    dxDrawImage(sx*0.155+dxGetTextWidth(client_faction_list[v][2], 1/myX*sx,fonts["condensed-bold-9"]),startY+sy*0.002, 24/myX*sx,24/myX*sx,"files/verified.png",0, 0, 0, tocolor(255,255,255,255*alpha_pagebg))
                else 
                    dxDrawText(client_faction_list[v][2],sx*0.155,startY,sx*0.155+sx*0.1,startY+sy*0.03,tocolor(255,255,255,255*alpha_pagebg),1/myX*sx,fonts["condensed-bold-9"],"left","center",false,false,false,true)
                end
                startY = startY + sy*0.0325
            end

            if selectedFactionLine > 0 then 
                local startX = sx*0.3
                for k, v in ipairs(factionPages) do 

                    local menu_color = tocolor(255, 255, 255, 220*alpha_pagebg)
                    if factionPanelPage == k or core:isInSlot(startX, sy*0.8, sx*0.065, sy*0.05) then 
                        menu_color = tocolor(r, g, b, 220*alpha_pagebg)
                    end 

                    dxDrawText(v[1], startX+40/myX*sx, sy*0.8, startX+40/myX*sx+sx*0.075, sy*0.8+sy*0.05, menu_color, 1/myX*sx, fonts["condensed-bold-9"], "left", "center")
                    dxDrawImage(startX+10/myX*sx, sy*0.8+7/myY*sy, 25/myX*sx, 25/myY*sy, "files/faction_panel/"..v[2]..".png", 0, 0, 0, menu_color)

                    startX = startX + sx*0.1
                end

                if factionPanelPage == 1 then 
                    
                    --if isPlayerLeader(faction_datas.factions[selectedFactionLine]) then
                    --else 

                        dxDrawRectangle(sx*0.3 + 5/myX*sx, sy*0.22, sx*0.14, sy*0.04, tocolor(27,27,27,220*alpha_pagebg))
                            dxDrawText("Szervezet áttekintése", sx*0.3 + 5/myX*sx, sy*0.22, sx*0.3+5/myX*sx+sx*0.14, sy*0.22+sy*0.04,tocolor(255,255,255,255*alpha_pagebg),0.7/myX*sx,fonts["bebasneue-18"],"center","center")
                        dxDrawRectangle(sx*0.3 + 5/myX*sx, sy*0.22+sy*0.04, sx*0.14, (sy*0.045)*#factionHomepageInfos, tocolor(27,27,27,100*alpha_pagebg))

                        local startY = sy*0.22+sy*0.045
                        for k, v in ipairs(factionHomepageInfos) do 
                            local color = tocolor(21,21,21,220*alpha_pagebg)
                            local color2 = tocolor(r,g,b,255*alpha_pagebg)
            
                            if (k)%2 == 0 then 
                                color = tocolor(28,28,28,220*alpha_pagebg)
                                color2 = tocolor(r,g,b,100*alpha_pagebg)
                            end
            
                            dxDrawRectangle(sx*0.3+5/myX*sx,startY,sx*0.14,sy*0.04,color)
            
                            dxDrawRectangle(sx*0.3+5/myX*sx,startY,sx*0.001,sy*0.04,color2)
            
                            dxDrawText(v[1], sx*0.305 + 5/myX*sx, startY, sx*0.305+5/myX*sx+sx*0.1, startY+sy*0.04, tocolor(255,255,255,255*alpha_pagebg),0.9/myX*sx,fonts["condensed-bold-11"],"left","center",false,false,false,true)

                            local data 
                            if k == 1 then 
                                data = (#client_factionMember_list[faction_datas.factions[selectedFactionLine] ] or "0" )
                            else
                                data = (#client_faction_list[faction_datas.factions[selectedFactionLine] ][v[2] ] or "false")
                            end

                            if k == 2 then 
                                data = #factionVehicles or 0
                            end

                            dxDrawText(data, sx*0.305 + 5/myX*sx, startY, sx*0.305+5/myX*sx+sx*0.13, startY+sy*0.04, tocolor(r, g, b, 255*alpha_pagebg), 1/myX*sx,fonts["condensed-bold-11"],"right","center",false,false,false,true)
            
                            startY = startY + sy*0.04 + 3/myY*sy
                        end

                        -- Diagramm 

                        dxDrawRectangle(sx*0.445, sy*0.22, sx*0.45, sy*0.57, tocolor(40, 40, 40, 220*alpha_pagebg))

                        local startX = sx*0.445
                        local allRank = #client_faction_list[faction_datas.factions[selectedFactionLine]][7] 
                        local allPlayer = #client_factionMember_list[faction_datas.factions[selectedFactionLine]]
                        for k, v in pairs(client_faction_list[faction_datas.factions[selectedFactionLine]][7]) do 
                            dxDrawText(v[1], startX, sy*0.76, startX+sx*0.45/allRank, sy*0.76+sy*0.03, tocolor(255, 255, 255, 255*alpha_pagebg), 1/myX*sx - (allRank*(0.025/myX*sx)), fonts["condensed-bold-9"], "center", "center", false, true)

                            local color = tocolor(r, g, b, 220*alpha_pagebg)
                            local color2 = tocolor(30, 30, 30, 100*alpha_pagebg)
                            if k%2 == 0 then 
                                color = tocolor(r, g, b, 150*alpha_pagebg)
                                color2 = tocolor(30, 30, 30, 150*alpha_pagebg)
                            end

                            dxDrawRectangle(startX, sy*0.76, sx*0.45/allRank, (0-sy*0.54), color2)

                            local playerInRanks = getAllPlayerInRank(faction_datas.factions[selectedFactionLine], k)
                            dxDrawRectangle(startX, sy*0.76, sx*0.45/allRank, (0-sy*0.54)*(playerInRanks/allPlayer)*alpha_pagebg, color)

                            dxDrawText(playerInRanks.." tag", startX, sy*0.76, startX+sx*0.45/allRank, sy*0.76+(0-sy*0.54)*(playerInRanks/allPlayer)*alpha_pagebg, tocolor(220, 220, 220, 255*alpha_pagebg), 1/myX*sx - (allRank*(0.025/myX*sx)), fonts["condensed-bold-11"], "center", "center")

                            startX = startX + sx*0.45/allRank
                        end
                        
                        if isPlayerLeader(faction_datas.factions[selectedFactionLine]) then
                            dxDrawRectangle(sx*0.3 + 5/myX*sx, sy*0.58, sx*0.14, sy*0.04, tocolor(27,27,27,220*alpha_pagebg))
                                dxDrawText("Szervezet leírása", sx*0.3 + 5/myX*sx, sy*0.58, sx*0.3+5/myX*sx+sx*0.14, sy*0.58+sy*0.04,tocolor(255,255,255,255*alpha_pagebg),0.7/myX*sx,fonts["bebasneue-18"],"center","center")
                            dxDrawRectangle(sx*0.3 + 5/myX*sx, sy*0.58+sy*0.04, sx*0.14, sy*0.1, tocolor(27,27,27,100*alpha_pagebg))

                            dxDrawText(client_faction_list[faction_datas.factions[selectedFactionLine]][12], sx*0.3 + 8/myX*sx, sy*0.58+sy*0.04+3/myY*sy, sx*0.3 + 8/myX*sx+sx*0.14, sy*0.58+sy*0.04+sy*0.1+3/myY*sy, tocolor(255, 255, 255, 255*alpha_pagebg), 0.9/myX*sx, fonts["condensed-bold-11"], "left", "top", false, true)
                        else
                            dxDrawRectangle(sx*0.3 + 5/myX*sx, sy*0.65, sx*0.14, sy*0.04, tocolor(27,27,27,220*alpha_pagebg))
                                dxDrawText("Szervezet leírása", sx*0.3 + 5/myX*sx, sy*0.65, sx*0.3+5/myX*sx+sx*0.14, sy*0.65+sy*0.04,tocolor(255,255,255,255*alpha_pagebg),0.7/myX*sx,fonts["bebasneue-18"],"center","center")
                            dxDrawRectangle(sx*0.3 + 5/myX*sx, sy*0.65+sy*0.04, sx*0.14, sy*0.1, tocolor(27,27,27,100*alpha_pagebg))

                            dxDrawText(client_faction_list[faction_datas.factions[selectedFactionLine]][12], sx*0.3 + 8/myX*sx, sy*0.65+sy*0.04+3/myY*sy, sx*0.3 + 8/myX*sx+sx*0.14, sy*0.65+sy*0.04+sy*0.1+3/myY*sy, tocolor(255, 255, 255, 255*alpha_pagebg), 0.9/myX*sx, fonts["condensed-bold-11"], "left", "top", false, true)
                        end
                        -- elsődleges
                        if core:isInSlot(sx*0.3025, sy*0.45, sx*0.14, sy*0.05) then 
                            dxDrawRectangle(sx*0.3025, sy*0.45, sx*0.14, sy*0.05, tocolor(r, g, b, 220*alpha_pagebg))
                        else 
                            dxDrawRectangle(sx*0.3025, sy*0.45, sx*0.14, sy*0.05, tocolor(r, g, b, 150*alpha_pagebg))
                        end

                        dxDrawText("Elsődleges frakció beállítása", sx*0.3025, sy*0.45, sx*0.3025+sx*0.14, sy*0.45+sy*0.053, tocolor(255, 255, 255, 255*alpha_pagebg), 0.8/myX*sx, fonts["bebasneue-18"], "center", "center")
                        -- Leader panel

                        if isPlayerLeader(faction_datas.factions[selectedFactionLine]) then
                            if core:isInSlot(sx*0.3025, sy*0.73, sx*0.14, sy*0.05) then 
                                dxDrawRectangle(sx*0.3025, sy*0.73, sx*0.14, sy*0.05, tocolor(r, g, b, 220*alpha_pagebg))
                            else
                                dxDrawRectangle(sx*0.3025, sy*0.73, sx*0.14, sy*0.05, tocolor(r, g, b, 150*alpha_pagebg))
                            end

                            dxDrawText("Leader opciók megnyitása", sx*0.3025, sy*0.73, sx*0.3025+sx*0.14, sy*0.73+sy*0.053, tocolor(255, 255, 255, 255*alpha_pagebg), 0.8/myX*sx, fonts["bebasneue-18"], "center", "center")

                            if isLeaderPanelShowing then 
                                blur:createBlur(0, 0, sx, sy, 230)

                                dxDrawRectangle(sx*0.4, sy*0.3, sx*0.2, sy*0.4, tocolor(40, 40, 40, 255))

                                dxDrawText("Frakció leírása", sx*0.4, sy*0.31, sx*0.4+sx*0.2, sy*0.31+sy*0.4, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-bold-11"], "center", "top")
                                dxDrawRectangle(sx*0.4+4/myX*sx, sy*0.34, sx*0.2-8/myX*sx, sy*0.1, tocolor(35, 35, 35, 255))

                                if core:isInSlot(sx*0.4+4/myX*sx, sy*0.34, sx*0.2-8/myX*sx, sy*0.1) then 
                                    dxDrawText(editboxs["faction_leader_description"], sx*0.4+8/myX*sx, sy*0.34+4/myY*sy, sx*0.4+8/myX*sx+sx*0.2-8/myX*sx, sy*0.34+sy*0.1, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["condensed-bold-11"], "left", "top", false, true)
                                else
                                    dxDrawText(editboxs["faction_leader_description"], sx*0.4+8/myX*sx, sy*0.34+4/myY*sy, sx*0.4+8/myX*sx+sx*0.2-8/myX*sx, sy*0.34+sy*0.1, tocolor(255, 255, 255, 220), 0.9/myX*sx, fonts["condensed-bold-11"], "left", "top", false, true)
                                end

                                if selectedEditbox == "faction_leader_description" then 
                                    dxDrawText(color..string.len(editboxs["faction_leader_description"]).."#ffffff/220", sx*0.4+8/myX*sx, sy*0.34+4/myY*sy, sx*0.4+8/myX*sx+sx*0.2-15/myX*sx, sy*0.34+sy*0.1, tocolor(255, 255, 255, 220), 0.9/myX*sx, fonts["condensed-bold-11"], "right", "bottom", false, false, false, true)
                                end

                                if core:isInSlot(sx*0.4+4/myX*sx, sy*0.443, sx*0.2-8/myX*sx, sy*0.03) then 
                                    dxDrawRectangle(sx*0.4+4/myX*sx, sy*0.443, sx*0.2-8/myX*sx, sy*0.03, tocolor(76, 173, 88, 255))
                                else
                                    dxDrawRectangle(sx*0.4+4/myX*sx, sy*0.443, sx*0.2-8/myX*sx, sy*0.03, tocolor(35, 35, 35, 255))
                                end
                                dxDrawText("Mentés", sx*0.4+4/myX*sx, sy*0.443, sx*0.4+4/myX*sx+sx*0.2-8/myX*sx, sy*0.443+sy*0.033, tocolor(255, 255, 255, 255*alpha_pagebg), 0.75/myX*sx, fonts["bebasneue-18"], "center", "center")

                                --if not (getFactionType(faction_datas.factions[selectedFactionLine]) == 4 or getFactionType(faction_datas.factions[selectedFactionLine]) == 5) then 
                                    dxDrawText("Frakció számla kezelése", sx*0.4, sy*0.48, sx*0.4+sx*0.2, sy*0.48+sy*0.4, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-bold-11"], "center", "top")
                                    dxDrawRectangle(sx*0.4+4/myX*sx, sy*0.5, sx*0.2-8/myX*sx, sy*0.03, tocolor(35, 35, 35, 255))
                                    dxDrawText("Bankszámla egyenlege: "..client_faction_list[faction_datas.factions[selectedFactionLine]][9]..color.."$", sx*0.4+10/myX*sx, sy*0.5, sx*0.4+sx*0.2+10/myX*sx, sy*0.5+sy*0.03, tocolor(255, 255, 255, 255), 0.85/myX*sx, fonts["condensed-bold-11"], "left", "center", false, false, false, true)

                                    if isElementWithinColShape(localPlayer, leaderMoneyTransactionCol) then 
                                        dxDrawRectangle(sx*0.4+4/myX*sx, sy*0.535, sx*0.2-8/myX*sx, sy*0.04, tocolor(35, 35, 35, 255))
                                        dxDrawText("Összeg: "..editboxs["faction_leader_bank_money"]..color.."$", sx*0.4+10/myX*sx, sy*0.535, sx*0.4+sx*0.2+10/myX*sx, sy*0.535+sy*0.04, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["condensed-bold-11"], "left", "center", false, false, false, true)

                                        if core:isInSlot(sx*0.4+4/myX*sx, sy*0.58, sx*0.2-8/myX*sx, sy*0.03) then 
                                            dxDrawRectangle(sx*0.4+4/myX*sx, sy*0.58, sx*0.2-8/myX*sx, sy*0.03, tocolor(189, 49, 49, 255))
                                        else
                                            dxDrawRectangle(sx*0.4+4/myX*sx, sy*0.58, sx*0.2-8/myX*sx, sy*0.03, tocolor(35, 35, 35, 255))
                                        end
                                        dxDrawText("Pénz kivétele", sx*0.4+4/myX*sx, sy*0.58, sx*0.4+4/myX*sx+sx*0.2-8/myX*sx, sy*0.58+sy*0.033, tocolor(255, 255, 255, 255*alpha_pagebg), 0.65/myX*sx, fonts["bebasneue-18"], "center", "center")

                                        if core:isInSlot(sx*0.4+4/myX*sx, sy*0.615, sx*0.2-8/myX*sx, sy*0.03) then 
                                            dxDrawRectangle(sx*0.4+4/myX*sx, sy*0.615, sx*0.2-8/myX*sx, sy*0.03, tocolor(76, 173, 88, 255))
                                        else
                                            dxDrawRectangle(sx*0.4+4/myX*sx, sy*0.615, sx*0.2-8/myX*sx, sy*0.03, tocolor(35, 35, 35, 255))
                                        end
                                        dxDrawText("Pénz berakása", sx*0.4+4/myX*sx, sy*0.615, sx*0.4+4/myX*sx+sx*0.2-8/myX*sx, sy*0.615+sy*0.033, tocolor(255, 255, 255, 255*alpha_pagebg), 0.65/myX*sx, fonts["bebasneue-18"], "center", "center")
                                    else
                                        dxDrawText("Csak a bankban tudod kezelni a frakció számlát!", sx*0.4, sy*0.54, sx*0.4+sx*0.2, sy*0.54+sy*0.1, tocolor(189, 49, 49, 220), 1/myX*sx, fonts["bebasneue-18"], "center", "center", false, true)
                                    end
                                --end

                                if core:isInSlot(sx*0.4+4/myX*sx, sy*0.7-4/myY*sy-sy*0.04, sx*0.2-8/myX*sx, sy*0.04) then 
                                    dxDrawRectangle(sx*0.4+4/myX*sx, sy*0.7-4/myY*sy-sy*0.04, sx*0.2-8/myX*sx, sy*0.04, tocolor(189, 49, 49, 255))
                                else
                                    dxDrawRectangle(sx*0.4+4/myX*sx, sy*0.7-4/myY*sy-sy*0.04, sx*0.2-8/myX*sx, sy*0.04, tocolor(35, 35, 35, 255))
                                end
                                dxDrawText("Bezárás", sx*0.4+4/myX*sx, sy*0.7-4/myY*sy-sy*0.04, sx*0.4+4/myX*sx+sx*0.2-8/myX*sx, sy*0.7-4/myY*sy-sy*0.04+sy*0.043, tocolor(255, 255, 255, 255*alpha_pagebg), 0.8/myX*sx, fonts["bebasneue-18"], "center", "center")
                            end
                        end
                    --end
                elseif factionPanelPage == 2 then 
                    dxDrawRectangle(sx*0.31,sy*0.22,sx*0.35,sy*0.04,tocolor(27,27,27,220*alpha_pagebg))
                        dxDrawText("Tagok",sx*0.31,sy*0.22,sx*0.31+sx*0.35,sy*0.22+sy*0.04,tocolor(255,255,255,255*alpha_pagebg),0.7/myX*sx,fonts["bebasneue-18"],"center","center")
                    dxDrawRectangle(sx*0.31,sy*0.22+sy*0.04,sx*0.35,sy*0.53,tocolor(27,27,27,100*alpha_pagebg))

                    local startY = sy*0.22+sy*0.045
                    for i = 1, 16 do 
                        local v = client_factionMember_list[faction_datas.factions[selectedFactionLine]][i+factionPanelMembersPointer]
                    
                        local color = tocolor(23,23,23,220*alpha_pagebg)
                        local color2 = tocolor(r,g,b,255*alpha_pagebg)
        
                        if (i)%2 == 0 then 
                            color = tocolor(28,28,28,220*alpha_pagebg)
                            color2 = tocolor(r,g,b,100*alpha_pagebg)
                        end
        
                        if core:isInSlot(sx*0.31, startY, sx*0.35, sy*0.03) or selectedMemberLine == i+factionPanelMembersPointer then 
                            dxDrawRectangle(sx*0.31, startY, sx*0.35, sy*0.03, tocolor(r, g, b, 50*alpha_pagebg))
                        else
                            dxDrawRectangle(sx*0.31, startY, sx*0.35, sy*0.03, color)
                        end
        
                        if v then 

                            dxDrawRectangle(sx*0.31, startY, sx*0.001, sy*0.03, color2)
            
                            local rank = client_faction_list[faction_datas.factions[selectedFactionLine]][7][v[2]]

                            if client_factionMember_list[faction_datas.factions[selectedFactionLine]][i+factionPanelMembersPointer][3] then
                                dxDrawText(serverColor.."["..rank[1].."]#ffffff "..v[4]:gsub("_", " "), sx*0.315, startY, sx*0.315+sx*0.35, startY+sy*0.03,tocolor(255,255,255,255*alpha_pagebg),1/myX*sx,fonts["condensed-bold-9"],"left","center",false,false,false,true)
                                --dxDrawRectangle(sx*0.315+dxGetTextWidth("["..rank[1].."] "..v[4]:gsub("_", " "), 1/myX*sx, fonts["condensed-bold-9"])+5/myY*sy, startY, 26/myX*sx, 26/myY*sy)
                                dxDrawImage(sx*0.315+dxGetTextWidth("["..rank[1].."] "..v[4]:gsub("_", " "), 1/myX*sx, fonts["condensed-bold-9"])+5/myX*sx, startY+3/myY*sy, 20/myX*sx, 20/myY*sy, "files/icons/crown.png", 0, 0, 0, tocolor(r, g, b, 255*alpha_pagebg))
                            else
                                if rank then 
                                    local name = serverColor.."["..(rank[1] or "###").."]#ffffff "..tostring(v[4]):gsub("_", " ")
                                    dxDrawText(name, sx*0.315, startY, sx*0.315+sx*0.35, startY+sy*0.03,tocolor(255,255,255,255*alpha_pagebg),1/myX*sx,fonts["condensed-bold-9"],"left","center",false,false,false,true)
                                end
                            end

                            if v[6] then 
                                --dxDrawImage(sx*0.645, startY+3/myY*sy, 20/myX*sx, 20/myY*sy, "files/icons/online.png", 0, 0, 0, tocolor(76, 173, 88, 255*alpha_pagebg))
                                dxDrawText("#4cad58Online", sx*0.305, startY, sx*0.305+sx*0.35, startY+sy*0.03, tocolor(255,255,255,255*alpha_pagebg), 1/myX*sx, fonts["condensed-bold-9"], "right", "center", false, false, false, true)
                            else 
                                --dxDrawImage(sx*0.645, startY+3/myY*sy, 20/myX*sx, 20/myY*sy, "files/icons/online.png", 0, 0, 0, tocolor(189, 49, 49, 255*alpha_pagebg))
                                dxDrawText("#bd3131Offline", sx*0.305, startY, sx*0.305+sx*0.35, startY+sy*0.03, tocolor(255,255,255,255*alpha_pagebg), 1/myX*sx, fonts["condensed-bold-9"], "right", "center", false, false, false, true)
                            end
                        end

                        startY = startY + sy*0.0325
                    end

                    if selectedMemberLine > 0 then 
                        dxDrawRectangle(sx*0.67,sy*0.22,sx*0.225,sy*0.04,tocolor(27,27,27,220*alpha_pagebg))
                            dxDrawText(serverColor.."Információk #ffffff- "..tostring(client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][4]):gsub("_", " "),sx*0.67, sy*0.22, sx*0.67+sx*0.225, sy*0.22+sy*0.04,tocolor(255,255,255,255*alpha_pagebg),0.7/myX*sx,fonts["bebasneue-18"],"center","center", false, false, false, true)
                        dxDrawRectangle(sx*0.67,sy*0.22+sy*0.04,sx*0.225,sy*0.235,tocolor(27,27,27,100*alpha_pagebg))

                        local startY = sy*0.22+sy*0.045

                        for k, v in ipairs(factionMemberInformations) do 
                            local color = tocolor(21,21,21,220*alpha_pagebg)
                            local color2 = tocolor(r,g,b,255*alpha_pagebg)
            
                            if (k)%2 == 0 then 
                                color = tocolor(28,28,28,220*alpha_pagebg)
                                color2 = tocolor(r,g,b,100*alpha_pagebg)
                            end
            
                            dxDrawRectangle(sx*0.67, startY, sx*0.225, sy*0.03, color)
            
                            dxDrawRectangle(sx*0.67, startY, sx*0.0015, sy*0.03, color2)
            
                            local text = client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][v[2]] or "NaN"

                            if not (text == "NaN") then 
                                if k == 1 then 
                                    text = tostring(text):gsub("_", " ")
                                elseif k == 2 then
                                    text = client_faction_list[faction_datas.factions[selectedFactionLine]][7][client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][v[2]]][1]
                                elseif k == 3 then 
                                    if text then 
                                        text = "#4cad58Igen"
                                    else
                                        text = "#bd3131Nem"
                                    end
                                elseif k == 4 then 
                                    local online, player = isPlayerOnline(client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][1]) 
                                    if online then                         
                                        if getElementData(player, "char:duty:faction") == faction_datas.factions[selectedFactionLine] then 
                                            text = "#4cad58Igen"
                                        else
                                            text = "#bd3131Nem"
                                        end
                                    else
                                        text = "#bd3131Nem"
                                    end
                                end
                            else
                                if k == 3 then 
                                    text = "#bd3131Nem"
                                elseif k == 5 then 
                                    text = "A felvétele óta nem állt szolgálatba"
                                elseif k == 7 then 
                                    text = "0"
                                else
                                    text = "NaN (Error Code: F_L_01)"
                                end
                            end

                            if tostring(text) == "nil" then 
                                if k == 7 then 
                                    text = "0"
                                else
                                    text = "Nincs adat"
                                end
                            end

                            local utotag = " #ffffff" .. (v[3] or "")

                            dxDrawText(v[1]..": "..serverColor..tostring(text)..utotag, sx*0.675, startY, sx*0.675+sx*0.225, startY+sy*0.03,tocolor(255,255,255,255*alpha_pagebg),1/myX*sx,fonts["condensed-bold-9"],"left","center",false,false,false,true)
            
                            startY = startY + sy*0.0325
                        end

                        if isPlayerLeader(faction_datas.factions[selectedFactionLine]) then 
                            dxDrawRectangle(sx*0.67,sy*0.51,sx*0.225,sy*0.04,tocolor(27,27,27,220*alpha_pagebg))
                                dxDrawText("#bd3131Tag kezelése #ffffff- "..tostring(client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][4]):gsub("_", " "),sx*0.67, sy*0.51, sx*0.67+sx*0.225, sy*0.51+sy*0.04,tocolor(255,255,255,255*alpha_pagebg),0.7/myX*sx,fonts["bebasneue-18"],"center","center", false, false, false, true)
                            dxDrawRectangle(sx*0.67,sy*0.51+sy*0.04,sx*0.225, sy*0.17, tocolor(27,27,27,100*alpha_pagebg))

                            local startY = sy*0.51+sy*0.045
                            for i = 1, 5 do 

                                v = factionLeaderOptions[i + factionLeaderOptionsPointer]
                                local color = tocolor(21, 21, 21, 220*alpha_pagebg)
                                local color2 = tocolor(189, 49, 49, 255*alpha_pagebg)
                
                                if i % 2 == 0 then 
                                    color = tocolor(28, 28, 28, 220*alpha_pagebg)
                                    color2 = tocolor(189, 49, 49, 100*alpha_pagebg)
                                end
                
                                if core:isInSlot(sx*0.67, startY, sx*0.22, sy*0.03) then 
                                    dxDrawRectangle(sx*0.67, startY, sx*0.22, sy*0.03, color2)
                                else
                                    dxDrawRectangle(sx*0.67, startY, sx*0.22, sy*0.03, color)
                                end
                
                                dxDrawRectangle(sx*0.67, startY, sx*0.0015, sy*0.03, color2)

                                local text = v[1]
                                if i + factionLeaderOptionsPointer == 3 then 
                                    if factionLeader_buttonPressNumbers[i + factionLeaderOptionsPointer] == 1 then 
                                        if client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][3] then 
                                            text = "Biztosan el szeretnéd venni a játékos leader jogosultságát?"
                                        else
                                            text = "Biztosan leader jogosultságot szeretnél adni a játékosnak?"
                                        end
                                    else
                                        if client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][3] then 
                                            text = "Leader jog elvétele"
                                        else
                                            text = "Leader jog adása"
                                        end
                                    end
                                elseif i + factionLeaderOptionsPointer == 4 then 
                                    if factionLeader_buttonPressNumbers[i + factionLeaderOptionsPointer] == 1 then 
                                        text = "Biztosan ki szeretnéd rúgni a frakcióból?"
                                    else
                                        text = v[1]
                                    end
                                end
                
                                dxDrawText(text, sx*0.67, startY, sx*0.67+sx*0.22, startY+sy*0.03,tocolor(255,255,255,255*alpha_pagebg),1/myX*sx,fonts["condensed-bold-9"],"center","center",false,false,false,true)
                
                                startY = startY + sy*0.0325
                            end

                            local lineHeight = math.min(5 / #factionLeaderOptions, 1)
                            dxDrawRectangle(sx*0.892, sy*0.51+sy*0.045, sx*0.0013, sy*0.16, tocolor(189, 49, 49, 100*alpha_pagebg))
                            dxDrawRectangle(sx*0.892, sy*0.51+sy*0.045 + (sy*0.16 * (lineHeight * factionLeaderOptionsPointer/5)), sx*0.0013, sy*0.16 * lineHeight, tocolor(189, 49, 49, 200*alpha_pagebg))
                        end
                    end

                    if isPlayerLeader(faction_datas.factions[selectedFactionLine]) then  
                        dxDrawRectangle(sx*0.67, sy*0.735, sx*0.225, sy*0.055, tocolor(30, 30, 30, 220*alpha_pagebg))
                        dxDrawRectangle(sx*0.67, sy*0.735, sx*0.0015, sy*0.055, tocolor(r, g, b, 220*alpha_pagebg))
                        dxDrawText("Játékos felvétele: (ID/Név)", sx*0.675, sy*0.74, sx*0.675+sx*0.225, sy*0.74+sy*0.04, tocolor(255, 255, 255, 150*alpha_pagebg), 0.7/myX*sx, fonts["bebasneue-18"], "left", "top")
                        dxDrawText(editboxs["faction_member_join"], sx*0.675, sy*0.74, sx*0.675+sx*0.225, sy*0.74+sy*0.05, tocolor(255, 255, 255, 255*alpha_pagebg), 0.8/myX*sx, fonts["bebasneue-18"], "left", "bottom")

                        if core:isInSlot(sx*0.87, sy*0.745, 33/myX*sx, 33/myY*sy) then 
                            dxDrawImage(sx*0.87, sy*0.745, 33/myX*sx, 33/myY*sy, "files/faction_panel/addmember.png", 0, 0, 0, tocolor(r, g, b, 255*alpha_pagebg))
                        else
                            dxDrawImage(sx*0.87, sy*0.745, 33/myX*sx, 33/myY*sy, "files/faction_panel/addmember.png", 0, 0, 0, tocolor(255, 255, 255, 200*alpha_pagebg))
                        end
                    end
                elseif factionPanelPage == 3 then 
                    dxDrawRectangle(sx*0.31,sy*0.22,sx*0.585,sy*0.04,tocolor(27,27,27,220*alpha_pagebg))
                        dxDrawText("Járművek",sx*0.31,sy*0.22,sx*0.31+sx*0.585,sy*0.22+sy*0.04,tocolor(255,255,255,255*alpha_pagebg),0.7/myX*sx,fonts["bebasneue-18"],"center","center")
                    dxDrawRectangle(sx*0.31,sy*0.22+sy*0.04,sx*0.585,sy*0.43,tocolor(27,27,27,100*alpha_pagebg))

                    local startY = sy*0.267
                    for i = 1, 7 do 
                        local v = factionVehicles[i+factionPanelVehiclePointer]
                    
                        if v then 
                            if not isElement(v) then 
                                table.remove(factionVehicles, i+factionPanelVehiclePointer)
                                selectedFactionVehLine = 0
                            end

                            local color = tocolor(21,21,21,220*alpha_pagebg)
                            local color2 = tocolor(r,g,b,255*alpha_pagebg)
            
                            if (i)%2 == 0 then 
                                color = tocolor(28,28,28,220*alpha_pagebg)
                                color2 = tocolor(r,g,b,100*alpha_pagebg)
                            end

                            --dxDrawRectangle(sx*0.31, startY, sx*0.585, sy*0.055, color)
                            if selectedFactionVehLine == i + factionPanelVehiclePointer then 
                                dxDrawRectangle(sx*0.31, startY, sx*0.584, sy*0.055, tocolor(r, g, b, 50))
                            else
                                dxDrawRectangle(sx*0.31, startY, sx*0.584, sy*0.055, color)
                            end

                            dxDrawRectangle(sx*0.31, startY, sx*0.001, sy*0.055, color2)

                            local carName = getVehicleName(v) 
            
                            if vehicle:getModdedVehName(getElementModel(v)) then 
                                carName = vehicle:getModdedVehName(getElementModel(v))
                            end 

                            dxDrawText(carName..serverColor.." (ID: "..getElementData(v, "veh:id")..")", sx*0.35, startY+6/myY*sy, sx*0.35+sx*0.1, startY+6/myY*sy+sy*0.025, tocolor(255, 255, 255, 255*alpha_pagebg), 1/myX*sx, fonts["condensed-bold-11"], "left", "center", false, false, false, true)
                            dxDrawText(vehicleTypes[getVehicleType(v)], sx*0.35, startY+6/myY*sy+sy*0.025, sx*0.35+sx*0.1, startY+6/myY*sy+sy*0.025+sy*0.01, tocolor(255, 255, 255, 200*alpha_pagebg), 0.8/myX*sx, fonts["condensed-bold-11"], "left", "center", false, false, false, true)

                            dxDrawImage(sx*0.315+10/myX*sx, startY+10/myY*sy, 30/myX*sx, 30/myY*sy, "files/faction_panel/"..string.lower(getVehicleType(v)):gsub(" ", "")..".png", 0, 0, 0, tocolor(255, 255, 255, 200*alpha_pagebg))

                            local vehPos = Vector3(getElementPosition(v))
                            dxDrawText("Elhelyezkedés: "..serverColor..getZoneName(vehPos.x, vehPos.y, vehPos.z), sx*0.31, startY, sx*0.31+sx*0.58, startY+sy*0.055, tocolor(255, 255, 255, 100*alpha_pagebg), 0.8/myX*sx, fonts["bebasneue-18"], "right", "center", false, false, false, true)

                            startY = startY + sy*0.06
                        end
                    end

                    if selectedFactionVehLine > 0 then 
                        dxDrawRectangle(sx*0.31, sy*0.695, sx*0.585, sy*0.105, tocolor(27, 27, 27, 100*alpha_pagebg))
                        dxDrawRectangle(sx*0.31+4/myX*sx, sy*0.695+4/myY*sy, sx*0.15, sy*0.105-8/myY*sy, tocolor(27, 27, 27, 200*alpha_pagebg))

                        local carName = getVehicleName(factionVehicles[selectedFactionVehLine]) 
            
                        if vehicle:getModdedVehName(getElementModel(factionVehicles[selectedFactionVehLine])) then 
                            carName = vehicle:getModdedVehName(getElementModel(factionVehicles[selectedFactionVehLine]))
                        end 

                        dxDrawText(carName..serverColor.." (ID: "..getElementData(factionVehicles[selectedFactionVehLine], "veh:id")..")", sx*0.31+4/myX*sx, sy*0.695+4/myY*sy, sx*0.31+4/myX*sx+sx*0.15, sy*0.695+4/myY*sy+sy*0.105-35/myY*sy, tocolor(255, 255, 255, 255*alpha_pagebg), 1/myX*sx, fonts["condensed-bold-11"], "center", "center", false, false, false, true)
                        dxDrawText(vehicleTypes[getVehicleType(factionVehicles[selectedFactionVehLine])], sx*0.31+4/myX*sx, sy*0.695+4/myY*sy, sx*0.31+4/myX*sx+sx*0.15, sy*0.695+4/myY*sy+sy*0.105+25/myY*sy, tocolor(255, 255, 255, 150*alpha_pagebg), 1/myX*sx, fonts["condensed-bold-11"], "center", "center", false, false, false, true)
                    
                        --dxDrawRectangle(sx*0.795, sy*0.7, sx*0.1, sy*0.05)
                        dxDrawText("Állapot: "..math.floor(getElementHealth(factionVehicles[selectedFactionVehLine])/10).."%", sx*0.795, sy*0.7, sx*0.795+sx*0.1, sy*0.7+sy*0.05, tocolor(189, 49, 49, 150*alpha_pagebg), 1/myX*sx, fonts["bebasneue-18"], "center", "center")

                        if isPlayerLeader(faction_datas.factions[selectedFactionLine]) then 
                            --[[if core:isInSlot(sx*0.7925, sy*0.755, sx*0.1, sy*0.04) then 
                                dxDrawRectangle(sx*0.7925, sy*0.755, sx*0.1, sy*0.04, tocolor(76, 173, 88, 220*alpha_pagebg))
                            else
                                dxDrawRectangle(sx*0.7925, sy*0.755, sx*0.1, sy*0.04, tocolor(30, 30, 30, 220*alpha_pagebg))
                            end]]

                            --dxDrawRectangle(sx*0.31+4/myX*sx+sx*0.155, sy*0.695+4/myY*sy, sx*0.32, sy*0.105-8/myY*sy)
                            local doorState = getElementData(factionVehicles[selectedFactionVehLine], "veh:locked")
                            local lightState = getElementData(factionVehicles[selectedFactionVehLine], "veh:lamp")
                            local tunings = getElementData(factionVehicles[selectedFactionVehLine], "veh:engineTunings")

                            if doorState then 
                                doorState = "Zárva"
                            else
                                doorState = "Nyitva"
                            end

                            if lightState then 
                                lightState = "Felkapcsolva"
                            else
                                lightState = "Lekapcsolva"
                            end

                            local tuningText = ""
 
                            if tunings then 
                                for k, v in ipairs(tunings) do
                                    if vehicleTunings[v] then 
                                        tuningText = tuningText .. vehicleTunings[v]

                                        if not (k == #tunings) then 
                                            tuningText = tuningText .. ", "
                                            if k % 3 == 0 then 
                                                tuningText = tuningText .. '\n'
                                            end
                                        end
                                    end
                                end
                            end

                            if string.len(tuningText) > 0 then 
                                dxDrawText("Ajtók állapota: "..serverColor..tostring(doorState).."#ffffff\n Lámpák állapota: "..serverColor..tostring(lightState).."#ffffff\n "..tuningText, sx*0.31+4/myX*sx+sx*0.155, sy*0.695+4/myY*sy, sx*0.31+4/myX*sx+sx*0.155+sx*0.32, sy*0.695+4/myY*sy+sy*0.105-8/myY*sy, tocolor(255, 255, 255, 255*alpha_pagebg), 1/myX*sx, fonts["condensed-bold-11"], "center", "center", false, false, false, true)
                            else
                                dxDrawText("Ajtók állapota: "..serverColor..tostring(doorState).."#ffffff\n Lámpák állapota: "..serverColor..tostring(lightState), sx*0.31+4/myX*sx+sx*0.155, sy*0.695+4/myY*sy, sx*0.31+4/myX*sx+sx*0.155+sx*0.32, sy*0.695+4/myY*sy+sy*0.105-8/myY*sy, tocolor(255, 255, 255, 255*alpha_pagebg), 1/myX*sx, fonts["condensed-bold-11"], "center", "center", false, false, false, true)
                            end

                            if core:isInSlot(sx*0.862, sy*0.75, 30/myX*sx, 30/myY*sy) then 
                                dxDrawImage(sx*0.862, sy*0.75, 30/myX*sx, 30/myY*sy, "files/icons/key.png", 0, 0, 0, tocolor(r, g, b, 200*alpha_pagebg))
                            else
                                dxDrawImage(sx*0.862, sy*0.75, 30/myX*sx, 30/myY*sy, "files/icons/key.png", 0, 0, 0, tocolor(255, 255, 255, 200*alpha_pagebg))
                            end

                            if core:isInSlot(sx*0.84, sy*0.75, 30/myX*sx, 30/myY*sy) then 
                                dxDrawImage(sx*0.84, sy*0.75, 30/myX*sx, 30/myY*sy, "files/icons/sell.png", 0, 0, 0, tocolor(r, g, b, 200*alpha_pagebg))
                            else
                                dxDrawImage(sx*0.84, sy*0.75, 30/myX*sx, 30/myY*sy, "files/icons/sell.png", 0, 0, 0, tocolor(255, 255, 255, 200*alpha_pagebg))
                            end
                        end
                    end

                    if #factionVehicles > 0 then 
                        local lineHossz = (7/#factionVehicles)

                        if lineHossz > 1 then 
                            lineHossz = 1
                        end

                        dxDrawRectangle(sx*0.31+sx*0.585-2/myX*sx, sy*0.22+sy*0.04, sx*0.0005, (sy*0.43),tocolor(r,g,b,100*alpha_pagebg))
                        dxDrawRectangle(sx*0.31+sx*0.585-2/myX*sx, sy*0.22+sy*0.04 + (sy*0.43*lineHossz*factionPanelVehiclePointer/7), sx*0.001, (sy*0.43)*lineHossz,tocolor(r,g,b,255*alpha_pagebg))
                    end
                elseif factionPanelPage == 4 then 
                    dxDrawRectangle(sx*0.31,sy*0.22,sx*0.35,sy*0.04,tocolor(27,27,27,220*alpha_pagebg))
                        dxDrawText("Rangok",sx*0.31,sy*0.22,sx*0.31+sx*0.35,sy*0.22+sy*0.04,tocolor(255,255,255,255*alpha_pagebg),0.7/myX*sx,fonts["bebasneue-18"],"center","center")
                    dxDrawRectangle(sx*0.31,sy*0.22+sy*0.04,sx*0.35,sy*0.53,tocolor(27,27,27,100*alpha_pagebg))

                    local startY = sy*0.22+sy*0.045
                    for i = 1, 16 do 
                        local v = client_faction_list[faction_datas.factions[selectedFactionLine]][7][i+factionPanelRanksPointer]
                        local color = tocolor(21,21,21,220*alpha_pagebg)
                        local color2 = tocolor(r,g,b,255*alpha_pagebg)
        
                        if (i)%2 == 0 then 
                            color = tocolor(28,28,28,220*alpha_pagebg)
                            color2 = tocolor(r,g,b,100*alpha_pagebg)
                        end
        
                        if core:isInSlot(sx*0.31, startY, sx*0.35, sy*0.03) or selectedRankLine == i+factionPanelRanksPointer then 
                            dxDrawRectangle(sx*0.31, startY, sx*0.35, sy*0.03, tocolor(r, g, b, 100*alpha_pagebg))
                        else
                            dxDrawRectangle(sx*0.31, startY, sx*0.35, sy*0.03, color)
                        end
                    
                        if v then 
                            dxDrawText(v[1]:gsub("_", " "), sx*0.315, startY, sx*0.315+sx*0.35, startY+sy*0.03,tocolor(255,255,255,255*alpha_pagebg),1/myX*sx,fonts["condensed-bold-9"],"left","center",false,false,false,true)
                            if getFactionType(faction_datas.factions[selectedFactionLine]) == 4 or getFactionType(faction_datas.factions[selectedFactionLine]) == 5 then 
                            else
                                dxDrawText("#4cad58"..v[2].."$", sx*0.305, startY, sx*0.305+sx*0.35, startY+sy*0.03, tocolor(255,255,255,200*alpha_pagebg), 1/myX*sx, fonts["condensed-bold-9"], "right", "center", false, false, false, true)
                            end

                            dxDrawRectangle(sx*0.31, startY, sx*0.001, sy*0.03, color2)
                        end

                        startY = startY + sy*0.0325
                    end

                    if selectedRankLine > 0 then 
                        dxDrawRectangle(sx*0.67,sy*0.22,sx*0.225,sy*0.04,tocolor(27,27,27,220*alpha_pagebg))
                            dxDrawText(serverColor.."Rang Információk #ffffff- "..client_faction_list[faction_datas.factions[selectedFactionLine]][7][selectedRankLine][1]:gsub("_", " "),sx*0.67, sy*0.22, sx*0.67+sx*0.225, sy*0.22+sy*0.04,tocolor(255,255,255,255*alpha_pagebg),0.7/myX*sx,fonts["bebasneue-18"],"center","center", false, false, false, true)
                        dxDrawRectangle(sx*0.67,sy*0.22+sy*0.04,sx*0.225,sy*0.2,tocolor(27,27,27,100*alpha_pagebg))

                        local startY = sy*0.22+sy*0.045
                        for k, v in ipairs(factionRankInformations) do 
                            local color = tocolor(21,21,21,220*alpha_pagebg)
                            local color2 = tocolor(r,g,b,255*alpha_pagebg)
            
                            if (k)%2 == 0 then 
                                color = tocolor(28,28,28,220*alpha_pagebg)
                                color2 = tocolor(r,g,b,100*alpha_pagebg)
                            end
            
                            dxDrawRectangle(sx*0.67, startY, sx*0.225, sy*0.03, color)
            
                            dxDrawRectangle(sx*0.67, startY, sx*0.0015, sy*0.03, color2)
            
                            local text = client_faction_list[faction_datas.factions[selectedFactionLine]][7][selectedRankLine][v[2]] or "false"
                            local utotag = ""
                            local elotag = ""

                            if k == 2 then
                                utotag = "#ffffff$"
                            elseif k == 3 then 
                                elotag = "#"
                            elseif k == 4 then 
                                text = getAllPlayerInRank(client_faction_list[faction_datas.factions[selectedFactionLine]][1], selectedRankLine)
                                utotag = "#ffffff tag"
                            end

                            dxDrawText(v[1]..": "..serverColor..elotag..text..utotag, sx*0.675, startY, sx*0.675+sx*0.225, startY+sy*0.03,tocolor(255,255,255,255*alpha_pagebg),1/myX*sx,fonts["condensed-bold-9"],"left","center",false,false,false,true)
            
                            startY = startY + sy*0.0325
                        end

                        if isPlayerLeader(faction_datas.factions[selectedFactionLine]) then   
                            dxDrawRectangle(sx*0.67,sy*0.47,sx*0.225,sy*0.04,tocolor(27,27,27,220*alpha_pagebg))
                                dxDrawText("#bd3131Rang kezelése #ffffff- "..client_faction_list[faction_datas.factions[selectedFactionLine]][7][selectedRankLine][1]:gsub("_", " "),sx*0.67, sy*0.47, sx*0.67+sx*0.225, sy*0.47+sy*0.04,tocolor(255,255,255,255*alpha_pagebg),0.7/myX*sx,fonts["bebasneue-18"],"center","center", false, false, false, true)
                            dxDrawRectangle(sx*0.67,sy*0.47+sy*0.04,sx*0.225, sy*0.218, tocolor(27,27,27,100*alpha_pagebg))

                            local starty = sy*0.516
                            for i = 1, 5 do 
                                local color = tocolor(21,21,21,220*alpha_pagebg)
                                local color2 = tocolor(189, 49, 49,255*alpha_pagebg)
                
                                if (i)%2 == 0 then 
                                    color = tocolor(28,28,28,220*alpha_pagebg)
                                    color2 = tocolor(189, 49, 49,100*alpha_pagebg)
                                end

                                local size = sy*0.04

                                if i == 4 then 
                                    size = sy*0.03
                                end

                                if core:isInSlot(sx*0.67, starty, sx*0.225, size) then  
                                    dxDrawRectangle(sx*0.67, starty, sx*0.225, size, color2)
                                else
                                    dxDrawRectangle(sx*0.67, starty, sx*0.225, size, color)
                                end
                                dxDrawRectangle(sx*0.67, starty, sx*0.0015, size, color2)

                                if i == 1 then 
                                    dxDrawText("Rang neve:", sx*0.675, starty, sx*0.675+sx*0.225, starty+size, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-bold-9"], "left", "center", false, false, false, true)
                                    dxDrawText(editboxs["faction_rank_name"], sx*0.665, starty, sx*0.665+sx*0.225, starty+size, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-bold-9"], "right", "center", false, false, false, true)
                                elseif i == 2 then 
                                    if getFactionType(faction_datas.factions[selectedFactionLine]) == 4 or getFactionType(faction_datas.factions[selectedFactionLine]) == 5 then 
                                        dxDrawText("Ez a funkció nem érhető el", sx*0.67, starty, sx*0.67+sx*0.225, starty+size, tocolor(255, 255, 255, 100), 1/myX*sx, fonts["condensed-bold-9"], "center", "center", false, false, false, true)
                                    else
                                        dxDrawText("Rang fizetése: ", sx*0.675, starty, sx*0.675+sx*0.225, starty+size, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-bold-9"], "left", "center", false, false, false, true)
                                        dxDrawText(serverColor..editboxs["faction_rank_payment"].."#ffffff$", sx*0.665, starty, sx*0.665+sx*0.225, starty+size, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-bold-9"], "right", "center", false, false, false, true)
                                    end
                                elseif i == 3 then
                                    if getFactionType(faction_datas.factions[selectedFactionLine]) == 4 or getFactionType(faction_datas.factions[selectedFactionLine]) == 5 then 
                                        dxDrawText("Ez a funkció nem érhető el", sx*0.67, starty, sx*0.67+sx*0.225, starty+size, tocolor(255, 255, 255, 100), 1/myX*sx, fonts["condensed-bold-9"], "center", "center", false, false, false, true)
                                    else
                                        dxDrawText("Ranghoz hozzárendelt duty: ", sx*0.675, starty, sx*0.675+sx*0.225, starty+size, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-bold-9"], "left", "center", false, false, false, true)

                                        if factionAttachedDuty > 0 then 
                                            dxDrawText(client_faction_list[faction_datas.factions[selectedFactionLine]][8][factionAttachedDuty][1], sx*0.665, starty, sx*0.665+sx*0.225, starty+size, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-bold-9"], "right", "center", false, false, false, true)
                                        else
                                            dxDrawText("Nincs hozzárendelt duty", sx*0.665, starty, sx*0.665+sx*0.225, starty+size, tocolor(255, 255, 255, 100), 1/myX*sx, fonts["condensed-bold-9"], "right", "center", false, false, false, true)
                                        end
                                    end
                                elseif i == 4 then 
                                    if factionLeader_buttonPressNumbers[5] == 1 then 
                                        dxDrawText("Biztosan ki szeretnéd törölni ezt a rangot?", sx*0.67, starty, sx*0.67+sx*0.225, starty+size, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-bold-9"], "center", "center", false, false, false, true)
                                    else
                                        dxDrawText("Rang Törlése", sx*0.67, starty, sx*0.67+sx*0.225, starty+size, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-bold-9"], "center", "center", false, false, false, true)
                                    end
                                elseif i == 5 then 
                                    dxDrawText("Rang Mentése", sx*0.67, starty, sx*0.67+sx*0.225, starty+size, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-bold-9"], "center", "center", false, false, false, true)
                                end

                                if i == 4 then 
                                    starty = starty + sy*0.034
                                else
                                    starty = starty + sy*0.044
                                end
                            end
                        end
                    end

                    if isPlayerLeader(faction_datas.factions[selectedFactionLine]) then  
                        dxDrawRectangle(sx*0.67, sy*0.735, sx*0.225, sy*0.055, tocolor(30, 30, 30, 220*alpha_pagebg))
                        dxDrawRectangle(sx*0.67, sy*0.735, sx*0.0015, sy*0.055, tocolor(r, g, b, 220*alpha_pagebg))
                        dxDrawText("Rang létrehozása: ", sx*0.675, sy*0.74, sx*0.675+sx*0.225, sy*0.74+sy*0.04, tocolor(255, 255, 255, 150*alpha_pagebg), 0.7/myX*sx, fonts["bebasneue-18"], "left", "top")
                        dxDrawText(editboxs["faction_rank_create"], sx*0.675, sy*0.74, sx*0.675+sx*0.225, sy*0.74+sy*0.05, tocolor(255, 255, 255, 255*alpha_pagebg), 0.8/myX*sx, fonts["bebasneue-18"], "left", "bottom")

                        if core:isInSlot(sx*0.87, sy*0.745, 33/myX*sx, 33/myY*sy) then 
                            dxDrawImage(sx*0.87, sy*0.745, 33/myX*sx, 33/myY*sy, "files/faction_panel/addrank.png", 0, 0, 0, tocolor(r, g, b, 255*alpha_pagebg))
                        else
                            dxDrawImage(sx*0.87, sy*0.745, 33/myX*sx, 33/myY*sy, "files/faction_panel/addrank.png", 0, 0, 0, tocolor(255, 255, 255, 200*alpha_pagebg))
                        end
                    end
                elseif factionPanelPage == 5 then 
                    if getFactionType(faction_datas.factions[selectedFactionLine]) == 4 or getFactionType(faction_datas.factions[selectedFactionLine]) == 5 then 
                        dxDrawText("Ez a funkció nem érhető el!", sx*0.31, sy*0.22, sx*0.31+sx*0.59, sy*0.22+sy*0.56, tocolor(255, 255, 255, 100*alpha_pagebg),1/myX*sx,fonts["bebasneue-25"],"center","center")
                    else 
                        if isPlayerLeader(faction_datas.factions[selectedFactionLine]) then
                            dxDrawRectangle(sx*0.31,sy*0.22,sx*0.25,sy*0.04,tocolor(27,27,27,220*alpha_pagebg))
                            dxDrawText("Dutyk",sx*0.31,sy*0.22,sx*0.31+sx*0.25,sy*0.22+sy*0.04,tocolor(255,255,255,255*alpha_pagebg),0.7/myX*sx,fonts["bebasneue-18"],"center","center")
                            dxDrawRectangle(sx*0.31,sy*0.22+sy*0.04,sx*0.25,sy*0.48,tocolor(27,27,27,100*alpha_pagebg))

                            local startY = sy*0.22+sy*0.045
                            for i = 1, 16 do 
                                local v = client_faction_list[faction_datas.factions[selectedFactionLine]][8][i+factionPanelDutysPointer]
                                if v then 
                                    local color = tocolor(21,21,21,220*alpha_pagebg)
                                    local color2 = tocolor(r,g,b,255*alpha_pagebg)
                    
                                    if (i)%2 == 0 then 
                                        color = tocolor(28,28,28,220*alpha_pagebg)
                                        color2 = tocolor(r,g,b,100*alpha_pagebg)
                                    end
                    
                                    if core:isInSlot(sx*0.31, startY, sx*0.25, sy*0.03) or selectedDutyLine == i+factionPanelDutysPointer then 
                                        dxDrawRectangle(sx*0.31, startY, sx*0.25, sy*0.03, tocolor(r, g, b, 100*alpha_pagebg))
                                    else
                                        dxDrawRectangle(sx*0.31, startY, sx*0.25, sy*0.03, color)
                                    end
                    
                                    dxDrawRectangle(sx*0.31, startY, sx*0.001, sy*0.03, color2)
                    
                                    dxDrawText(v[1]:gsub("_", " "), sx*0.315, startY, sx*0.315+sx*0.25, startY+sy*0.03,tocolor(255,255,255,255*alpha_pagebg),1/myX*sx,fonts["condensed-bold-9"],"left","center",false,false,false,true)
                                
                                    startY = startY + sy*0.0325
                                end
                            end     

                            dxDrawRectangle(sx*0.31, sy*0.75, sx*0.25, sy*0.05, tocolor(30, 30, 30, 220*alpha_pagebg))
                            dxDrawRectangle(sx*0.31, sy*0.75, sx*0.0015, sy*0.05, tocolor(r, g, b, 220*alpha_pagebg))
                            dxDrawText("Duty létrehozása: ", sx*0.315, sy*0.75, sx*0.315+sx*0.225, sy*0.75+sy*0.03, tocolor(255, 255, 255, 150*alpha_pagebg), 0.6/myX*sx, fonts["bebasneue-18"], "left", "center")
                            dxDrawText(editboxs["faction_duty_create"], sx*0.315, sy*0.75, sx*0.315+sx*0.225, sy*0.75+sy*0.05, tocolor(255, 255, 255, 255*alpha_pagebg), 0.7/myX*sx, fonts["bebasneue-18"], "left", "bottom")
    
                            if core:isInSlot(sx*0.535, sy*0.758, 33/myX*sx, 33/myY*sy) then 
                                dxDrawImage(sx*0.535, sy*0.758, 33/myX*sx, 33/myY*sy, "files/faction_panel/addrank.png", 0, 0, 0, tocolor(r, g, b, 255*alpha_pagebg))
                            else
                                dxDrawImage(sx*0.535, sy*0.758, 33/myX*sx, 33/myY*sy, "files/faction_panel/addrank.png", 0, 0, 0, tocolor(255, 255, 255, 200*alpha_pagebg))
                            end

                            if selectedDutyLine > 0 then 

                                dxDrawRectangle(sx*0.67,sy*0.62,sx*0.225,sy*0.04,tocolor(27,27,27,220*alpha_pagebg))
                                    dxDrawText("#bd3131Duty kezelése #ffffff- "..client_faction_list[faction_datas.factions[selectedFactionLine]][8][selectedDutyLine][1], sx*0.67, sy*0.62, sx*0.67+sx*0.225, sy*0.62+sy*0.04,tocolor(255,255,255,255*alpha_pagebg),0.7/myX*sx,fonts["bebasneue-18"],"center","center", false, false, false, true)
                                dxDrawRectangle(sx*0.67,sy*0.62+sy*0.04,sx*0.225, sy*0.128, tocolor(27,27,27,100*alpha_pagebg))

                                local starty = sy*0.665
                                for i = 1, 3 do 
                                    local color = tocolor(21,21,21,220*alpha_pagebg)
                                    local color2 = tocolor(189, 49, 49,255*alpha_pagebg)
                    
                                    if (i)%2 == 0 then 
                                        color = tocolor(28,28,28,220*alpha_pagebg)
                                        color2 = tocolor(189, 49, 49,100*alpha_pagebg)
                                    end

                                    local size = sy*0.04

                                    if i == 2 then 
                                        size = sy*0.03
                                    end

                                    if core:isInSlot(sx*0.67, starty, sx*0.225, size) then  
                                        dxDrawRectangle(sx*0.67, starty, sx*0.225, size, color2)
                                    else
                                        dxDrawRectangle(sx*0.67, starty, sx*0.225, size, color)
                                    end
                                    dxDrawRectangle(sx*0.67, starty, sx*0.0015, size, color2)

                                    if i == 1 then 
                                        dxDrawText("Duty neve:", sx*0.675, starty, sx*0.675+sx*0.225, starty+size, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-bold-9"], "left", "center", false, false, false, true)
                                        dxDrawText(editboxs["faction_duty_name"], sx*0.665, starty, sx*0.665+sx*0.225, starty+size, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-bold-9"], "right", "center", false, false, false, true)
                                    elseif i == 2 then 
                                        if factionLeader_buttonPressNumbers[6] == 1 then 
                                            dxDrawText("Biztosan ki szeretnéd törölni ezt a dutyt?", sx*0.67, starty, sx*0.67+sx*0.225, starty+size, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-bold-9"], "center", "center", false, false, false, true)
                                        else
                                            dxDrawText("Duty Törlése", sx*0.67, starty, sx*0.67+sx*0.225, starty+size, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-bold-9"], "center", "center", false, false, false, true)
                                        end
                                    elseif i == 3 then 
                                        dxDrawText("Duty Mentése", sx*0.67, starty, sx*0.67+sx*0.225, starty+size, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-bold-9"], "center", "center", false, false, false, true)
                                    end

                                    if i == 2 then 
                                        starty = starty + sy*0.034
                                    else
                                        starty = starty + sy*0.044
                                    end
                                end

                                dxDrawRectangle(sx*0.565, sy*0.22, sx*0.1, sy*0.04, tocolor(27,27,27,220*alpha_pagebg))
                                    dxDrawText("Duty Skinek", sx*0.565, sy*0.22, sx*0.565+sx*0.1, sy*0.22+sy*0.04, tocolor(255,255,255,255*alpha_pagebg), 0.7/myX*sx, fonts["bebasneue-18"], "center", "center")
                                dxDrawRectangle(sx*0.565, sy*0.22+sy*0.04, sx*0.1, sy*0.268, tocolor(27,27,27,100*alpha_pagebg))

                                local startY = sy*0.22+sy*0.045
                                for i = 1, 8 do 
                                    local v = client_faction_list[faction_datas.factions[selectedFactionLine]][4][i+factionPanelDutySkinsPointer]
                                    if v then 

                                        local active = tableContains(factionDutyElements_temp["skins"], tonumber(v)) or false 

                                        local color = tocolor(21,21,21,220*alpha_pagebg)
                                        local color2 = tocolor(r,g,b,255*alpha_pagebg)
                        
                                        if (i)%2 == 0 then 
                                            color = tocolor(28,28,28,220*alpha_pagebg)
                                            color2 = tocolor(r,g,b,100*alpha_pagebg)
                                        end
                        
                                        if core:isInSlot(sx*0.565, startY, sx*0.1, sy*0.03) then 
                                            dxDrawRectangle(sx*0.565, startY, sx*0.1, sy*0.03, tocolor(r, g, b, 100*alpha_pagebg))
                                        else
                                            dxDrawRectangle(sx*0.565, startY, sx*0.1, sy*0.03, color)
                                        end
                        
                                        dxDrawRectangle(sx*0.565, startY, sx*0.0013, sy*0.03, color2)

                                        if core:isInSlot(sx*0.642, startY-sy*0.002, 30/myX*sx, 30/myY*sy) then 
                                            dxDrawImage(sx*0.642, startY-sy*0.002, 30/myX*sx, 30/myY*sy, "files/admin_panel/view.png", 0, 0, 0, tocolor(r, g, b, 255*alpha_pagebg))
                                        else
                                            dxDrawImage(sx*0.642, startY-sy*0.002, 30/myX*sx, 30/myY*sy, "files/admin_panel/view.png", 0, 0, 0, tocolor(255, 255, 255, 255*alpha_pagebg))
                                        end
                                        
                        
                                        if active then 
                                            dxDrawText(v, sx*0.57, startY, sx*0.57+sx*0.1, startY+sy*0.03,tocolor(255,255,255,255*alpha_pagebg),1/myX*sx,fonts["condensed-bold-9"],"left","center",false,false,false,true)
                                        else
                                            dxDrawText(v, sx*0.57, startY, sx*0.57+sx*0.1, startY+sy*0.03,tocolor(255,255,255,100*alpha_pagebg),1/myX*sx,fonts["condensed-bold-9"],"left","center",false,false,false,true)
                                        end
                                    
                                        startY = startY + sy*0.0325
                                    end
                                end     

                                dxDrawRectangle(sx*0.565, sy*0.55, sx*0.1, sy*0.04, tocolor(27,27,27,220*alpha_pagebg))
                                    dxDrawText("Skin előnézet", sx*0.565, sy*0.55, sx*0.565+sx*0.1, sy*0.55+sy*0.04, tocolor(255,255,255,255*alpha_pagebg), 0.7/myX*sx, fonts["bebasneue-18"], "center", "center")
                                dxDrawRectangle(sx*0.565, sy*0.55+sy*0.04, sx*0.1, sy*0.2, tocolor(27,27,27,100*alpha_pagebg))

                                dxDrawRectangle(sx*0.67,sy*0.22,sx*0.225,sy*0.04,tocolor(27,27,27,220*alpha_pagebg))
                                    dxDrawText("Duty Itemek", sx*0.67, sy*0.22, sx*0.67+sx*0.225, sy*0.22+sy*0.04,tocolor(255,255,255,255*alpha_pagebg),0.7/myX*sx,fonts["bebasneue-18"],"center","center", false, false, false, true)
                                dxDrawRectangle(sx*0.67,sy*0.22+sy*0.04,sx*0.225, sy*0.324, tocolor(27,27,27,100*alpha_pagebg))

                                local startY = sy*0.22+sy*0.045
                                local realIndex = 0
                                for i = 1, 6 do 
                                    local v = client_faction_list[faction_datas.factions[selectedFactionLine]][5][i+factionPanelDutyItemsPointer]
                                    if v then 

                                        local active = false
                                        local itemCount = 0
                                        for i = 1, #factionDutyElements_temp["items"] do 
                                            if tonumber(factionDutyElements_temp["items"][i][1]) == tonumber(v) then 
                                                active = true 
                                                itemCount = tonumber(factionDutyElements_temp["items"][i][2])
                                                break
                                            end
                                        end

                                        local color = tocolor(21,21,21,220*alpha_pagebg)
                                        local color2 = tocolor(r,g,b,255*alpha_pagebg)
                        
                                        if (i)%2 == 0 then 
                                            color = tocolor(28,28,28,220*alpha_pagebg)
                                            color2 = tocolor(r,g,b,100*alpha_pagebg)
                                        end
                        
                                        if core:isInSlot(sx*0.67, startY, sx*0.25, sy*0.05) then 
                                            dxDrawRectangle(sx*0.67, startY, sx*0.225, sy*0.05, tocolor(r, g, b, 100*alpha_pagebg))
                                        else
                                            dxDrawRectangle(sx*0.67, startY, sx*0.225, sy*0.05, color)
                                        end
                        
                                        dxDrawRectangle(sx*0.67, startY, sx*0.0013, sy*0.05, color2)

                        
                                        if active then 
                                            dxDrawText(inventory:getItemName(tonumber(v)), sx*0.7, startY, sx*0.7+sx*0.25, startY+sy*0.05,tocolor(255,255,255,255*alpha_pagebg),1/myX*sx,fonts["condensed-bold-9"],"left","center",false,false,false,true)
                                            dxDrawImage(sx*0.674, startY+sy*0.005, 35/myX*sx, 35/myY*sy, inventory:getItemImage(tonumber(v)), 0, 0, 0, tocolor(255, 255, 255, 255*alpha_pagebg))

                                            if inventory:getItemStackable(tonumber(v)) then 
                                                realIndex = realIndex + 1
                                                dxDrawText(itemCount, sx*0.843, startY, sx*0.843+sx*0.03, startY+sy*0.05, tocolor(255,255,255,255*alpha_pagebg),1/myX*sx,fonts["condensed-bold-9"], "center","center",false,false,false,true)

                                                if core:isInSlot(sx*0.83, startY+10/myY*sy, 25/myX*sx, 25/myY*sy) then
                                                    dxDrawImage(sx*0.83, startY+10/myY*sy, 25/myX*sx, 25/myY*sy, "files/admin_panel/plus.png", 0, 0, 0, tocolor(r, g, b, 220*alpha_pagebg))
                                                else
                                                    dxDrawImage(sx*0.83, startY+10/myY*sy, 25/myX*sx, 25/myY*sy, "files/admin_panel/plus.png", 0, 0, 0, tocolor(255, 255, 255, 220*alpha_pagebg))
                                                end

                                                if core:isInSlot(sx*0.8715, startY+10/myY*sy, 25/myX*sx, 25/myY*sy) then 
                                                    dxDrawImage(sx*0.8715, startY+10/myY*sy, 25/myX*sx, 25/myY*sy, "files/admin_panel/minus.png", 0, 0, 0, tocolor(r, g, b, 220*alpha_pagebg))
                                                else
                                                    dxDrawImage(sx*0.8715, startY+10/myY*sy, 25/myX*sx, 25/myY*sy, "files/admin_panel/minus.png", 0, 0, 0, tocolor(255, 255, 255, 220*alpha_pagebg))
                                                end
                                            end
                                        else
                                            dxDrawText(inventory:getItemName(tonumber(v)), sx*0.7, startY, sx*0.7+sx*0.25, startY+sy*0.05,tocolor(255,255,255,100*alpha_pagebg),1/myX*sx,fonts["condensed-bold-9"],"left","center",false,false,false,true)
                                            dxDrawImage(sx*0.674, startY+sy*0.005, 35/myX*sx, 35/myY*sy, inventory:getItemImage(tonumber(v)), 0, 0, 0, tocolor(255, 255, 255, 100*alpha_pagebg))
                                        end
                                    
                                        startY = startY + sy*0.0525
                                    end
                                end     
                            end
                        else 
                            dxDrawText("Nincs jogosultságod az oldal megtekintéséhez!", sx*0.31, sy*0.22, sx*0.31+sx*0.59, sy*0.22+sy*0.56, tocolor(227, 98, 84, 100*alpha_pagebg),1/myX*sx,fonts["bebasneue-25"],"center","center")
                        end
                    end
                elseif factionPanelPage == 6 then
                    if getFactionType(faction_datas.factions[selectedFactionLine]) == 4 or getFactionType(faction_datas.factions[selectedFactionLine]) == 5 then 
                        dxDrawText("Ez a funkció nem érhető el!", sx*0.31, sy*0.22, sx*0.31+sx*0.59, sy*0.22+sy*0.56, tocolor(255, 255, 255, 100*alpha_pagebg),1/myX*sx,fonts["bebasneue-25"],"center","center")
                    else 

                    end 
                end

            end
        else
            dxDrawText("Nem vagy egyetlen szervezet tagja sem! :(", sx*0.14, sy*0.2, sx*0.14+sx*0.765, sy*0.2+sy*0.67, tocolor(227, 98, 84,255*alpha_pagebg),1/myX*sx,fonts["bebasneue-25"],"center","center")
        end
    elseif activePage == 6 then
        dxDrawRectangle(sx*0.15, sy*0.225, sx*0.385, sy*0.05, tocolor(27, 27, 27, 220*alpha_pagebg))
            dxDrawText("Prémium Item Shop", sx*0.15, sy*0.225, sx*0.15+sx*0.385, sy*0.225+sy*0.05, tocolor(255,255,255,255*alpha_pagebg), 1/myX*sx, fonts["bebasneue-18"], "center", "center")
        dxDrawRectangle(sx*0.15, sy*0.225+sy*0.05, sx*0.385, sy*0.62-sy*0.05, tocolor(27, 27, 27, 100*alpha_pagebg))

        dxDrawRectangle(sx*0.15, sy*0.225+sy*0.06, sx*0.385, sy*0.04, tocolor(27, 27, 27, 220*alpha_pagebg))
        --dxDrawRectangle(sx*0.15, sy*0.225+sy*0.06, sx*0.385/2, sy*0.04, tocolor(27, 255, 27, 220*alpha_pagebg))

        local menuStartX = sx*0.15
        local oneMenuWidth = sx*0.385 / (#premiumCategories)
        local menuItems = (#premiumCategories)

        for i = 1, menuItems do
            local alpha = 200 * alpha_pagebg
            if (i % 2) == 0 then 
                alpha = 240 * alpha_pagebg
            end

            dxDrawRectangle(menuStartX, sy*0.255 + sy*0.03, oneMenuWidth, sy*0.04, tocolor(20, 20, 20, alpha))
            if selectedPremiumPanel == i then
                dxDrawText(premiumCategories[i].name, menuStartX, sy*0.255 + sy*0.03, menuStartX + oneMenuWidth, sy*0.255 + sy*0.03 + sy*0.04, tocolor(r, g, b, 255 * alpha_pagebg), 1/myX*sx,fonts["condensed-bold-9"], "center","center")
            else
                dxDrawText(premiumCategories[i].name, menuStartX, sy*0.255 + sy*0.03, menuStartX + oneMenuWidth, sy*0.255 + sy*0.03 + sy*0.04, tocolor(255, 255, 255, 255 * alpha_pagebg), 1/myX*sx,fonts["condensed-bold-9"], "center","center")
            end
            menuStartX = menuStartX + oneMenuWidth 
        end
        --[[if selectedPremiumPanel == 1 then 
            dxDrawText("Itemek", sx*0.15, sy*0.225+sy*0.06, sx*0.15+sx*0.385/2, sy*0.225+sy*0.06+sy*0.042, tocolor(r, g, b, 255*alpha_pagebg), 0.75/myX*sx, fonts["bebasneue-18"], "center", "center")
            dxDrawText("Csomagok", sx*0.15+sx*0.385/2, sy*0.225+sy*0.06, sx*0.15+sx*0.385, sy*0.225+sy*0.06+sy*0.042, tocolor(255, 255, 255, 255*alpha_pagebg), 0.75/myX*sx, fonts["bebasneue-18"], "center", "center")
        elseif selectedPremiumPanel == 2 then 
            dxDrawText("Itemek", sx*0.15, sy*0.225+sy*0.06, sx*0.15+sx*0.385/2, sy*0.225+sy*0.06+sy*0.042, tocolor(255, 255, 255, 255*alpha_pagebg), 0.75/myX*sx, fonts["bebasneue-18"], "center", "center")
            dxDrawText("Csomagok", sx*0.15+sx*0.385/2, sy*0.225+sy*0.06, sx*0.15+sx*0.385, sy*0.225+sy*0.06+sy*0.042, tocolor(r, g, b, 255*alpha_pagebg), 0.75/myX*sx, fonts["bebasneue-18"], "center", "center")
        end]]

        if selectedPremiumPanel < #premiumCategories then 
            local starty = sy*0.33

            for i = 1, 11 do 
                local v = premiumCategories[selectedPremiumPanel].items[i+premiumPanelPointer]

                if v then 
                    local bgColor = tocolor(30, 30, 30, 220*alpha_pagebg)
                    local lineColor = tocolor(r, g, b, 220*alpha_pagebg)

                    if (i+premiumPanelPointer) % 2 == 0 then 
                        bgColor = tocolor(30, 30, 30, 120*alpha_pagebg)
                        lineColor = tocolor(r, g, b, 120*alpha_pagebg)
                    end
                    dxDrawRectangle(sx*0.15, starty, sx*0.385, sy*0.04, bgColor)
                    dxDrawRectangle(sx*0.15, starty, sx*0.001, sy*0.04, lineColor)

                    if v.id then 
                        dxDrawImage(sx*0.15+5/myX*sx, starty+3/myY*sy, 30/myX*sx, 30/myY*sy, exports.oInventory:getItemImage(v.id, v.value), 0, 0, 0, tocolor(255, 255, 255, 255*alpha_pagebg))
                        --dxDrawRectangle(sx*0.175, starty, sx*0.1, sy*0.02)
                        dxDrawText(exports.oInventory:getItemName(v.id, v.value)..serverColor.." ("..v.count.."db)", sx*0.175, starty, sx*0.175+sx*0.1, starty+sy*0.042, tocolor(255, 255, 255, 255*alpha_pagebg), 0.8/myX*sx, fonts["condensed-bold"], "left", "center", false, false, false, true)
                    else
                        dxDrawImage(sx*0.15+5/myX*sx, starty+3/myY*sy, 30/myX*sx, 30/myY*sy, "files/icons/money/dollar"..v.icon..".png", 0, 0, 0, tocolor(255, 255, 255, 255*alpha_pagebg))
                        dxDrawText(comma_value(v.count).."$", sx*0.175, starty, sx*0.175+sx*0.1, starty+sy*0.042, tocolor(255, 255, 255, 255*alpha_pagebg), 0.8/myX*sx, fonts["condensed-bold"], "left", "center", false, false, false, true)
                    end

                    --dxDrawRectangle(sx*0.41, starty, sx*0.05, sy*0.04)
                    dxDrawText(comma_value(v.price).."PP", sx*0.41, starty, sx*0.41+sx*0.05, starty+sy*0.04, tocolor(r, g, b, 255*alpha_pagebg), 0.8/myX*sx, fonts["condensed-bold"], "right", "center")
                    
                   
                    if premiumPanelLastClickedElement == (i+premiumPanelPointer) then 
                        core:dxDrawButton(sx*0.465-5/myX*sx, starty+4/myY*sy, sx*0.07, sy*0.04-8/myY*sy, r, g, b, 220 * alpha_pagebg, "Biztosan?", tocolor(255, 255, 255, 255 * alpha_pagebg), 0.8/myX*sx, fonts["condensed-bold"], true, tocolor(0, 0, 0, 150 * alpha_pagebg))
                    else
                        core:dxDrawButton(sx*0.465-5/myX*sx, starty+4/myY*sy, sx*0.07, sy*0.04-8/myY*sy, r, g, b, 220 * alpha_pagebg, "Vásárlás", tocolor(255, 255, 255, 255 * alpha_pagebg), 0.8/myX*sx, fonts["condensed-bold"], true, tocolor(0, 0, 0, 150 * alpha_pagebg))
                    end

                    starty = starty + sy*0.047
                end
            end

            local lineHossz = 11/#premiumCategories[selectedPremiumPanel].items

            if #premiumCategories[selectedPremiumPanel].items <= 11 then 
                lineHossz = 1 
            end

            dxDrawRectangle(sx*0.534, sy*0.33, sx*0.0005, sy*0.514, tocolor(r, g, b, 100*alpha_pagebg))
            dxDrawRectangle(sx*0.534, sy*0.33+(sy*0.514*(lineHossz*premiumPanelPointer/11)), sx*0.001, sy*0.514*lineHossz, tocolor(r, g, b, 255*alpha_pagebg))
        elseif selectedPremiumPanel == #premiumCategories then 
            local starty = sy*0.33

            for i = 1, 6 do 
                local v = premiumItemPackages[i+premiumPanelPointer2]

                if v then 
                    local bgColor = tocolor(30, 30, 30, 220*alpha_pagebg)
                    local lineColor = tocolor(r, g, b, 220*alpha_pagebg)

                    if (i+premiumPanelPointer2) % 2 == 0 then 
                        bgColor = tocolor(30, 30, 30, 120*alpha_pagebg)
                        lineColor = tocolor(r, g, b, 120*alpha_pagebg)
                    end
                    dxDrawRectangle(sx*0.15, starty, sx*0.385, sy*0.08, bgColor)
                    dxDrawRectangle(sx*0.15, starty, sx*0.385, sy*0.04, bgColor)
                    dxDrawRectangle(sx*0.15, starty, sx*0.001, sy*0.08, lineColor)

                    --dxDrawImage(sx*0.15+5/myX*sx, starty+3/myY*sy, 30/myX*sx, 30/myY*sy, inventory:getItemImage(v.id))
                    dxDrawText(v.name, sx*0.155, starty, sx*0.155+sx*0.1, starty+sy*0.042, tocolor(255, 255, 255, 255*alpha_pagebg), 0.8/myX*sx, fonts["condensed-bold"], "left", "center", false, false, false, true)

                    dxDrawText(comma_value(v.price).."PP", sx*0.41, starty, sx*0.41+sx*0.05, starty+sy*0.04, tocolor(r, g, b, 255*alpha_pagebg), 0.8/myX*sx, fonts["condensed-bold"], "right", "center")
                    

                    if premiumPanelLastClickedElement == (i+premiumPanelPointer2) then 
                        core:dxDrawButton(sx*0.465-5/myX*sx, starty+4/myY*sy, sx*0.07, sy*0.04-8/myY*sy, r, g, b, 220 * alpha_pagebg, "Biztosan?", tocolor(255, 255, 255, 255 * alpha_pagebg), 0.8/myX*sx, fonts["condensed-bold"], true, tocolor(0, 0, 0, 150 * alpha_pagebg))
                    else
                        core:dxDrawButton(sx*0.465-5/myX*sx, starty+4/myY*sy, sx*0.07, sy*0.04-8/myY*sy, r, g, b, 220 * alpha_pagebg, "Vásárlás", tocolor(255, 255, 255, 255 * alpha_pagebg), 0.8/myX*sx, fonts["condensed-bold"], true, tocolor(0, 0, 0, 150 * alpha_pagebg))
                    end


                    local startx = sx*0.155
                    for k2, v2 in ipairs(v.items) do 
                        dxDrawImage(startx, starty+sy*0.038+3/myY*sy, 30/myX*sx, 30/myY*sy, inventory:getItemImage(v2.id), 0, 0, 0, tocolor(255, 255, 255, 255*alpha_pagebg))

                        --dxDrawRectangle(startx+33/myX*sx, starty+sy*0.038, sx*0.03, sy*0.04)
                        dxDrawText(v2.count.."db", startx+36/myX*sx, starty+sy*0.038, startx+36/myX*sx+sx*0.025, starty+sy*0.038+sy*0.04, tocolor(255, 255, 255, 255*alpha_pagebg), 0.8/myX*sx, fonts["condensed-bold"], "left", "center")

                        startx = startx + sx*0.025 + 33/myX*sx
                    end

                    starty = starty + sy*0.086
                end
            end

            local lineHossz = 6/#premiumItemPackages

            if #premiumItemPackages <= 6 then 
                lineHossz = 1 
            end

            dxDrawRectangle(sx*0.534, sy*0.33, sx*0.0005, sy*0.514, tocolor(r, g, b, 100*alpha_pagebg))
            dxDrawRectangle(sx*0.534, sy*0.33+(sy*0.514*(lineHossz*premiumPanelPointer2/6)), sx*0.001, sy*0.514*lineHossz, tocolor(r, g, b, 255*alpha_pagebg))
        end

        dxDrawRectangle(sx*0.54, sy*0.225, sx*0.35, sy*0.05, tocolor(27, 27, 27, 220*alpha_pagebg))
            dxDrawText("Prémium Információk", sx*0.54, sy*0.225, sx*0.54+sx*0.35, sy*0.225+sy*0.05, tocolor(255,255,255,255*alpha_pagebg), 1/myX*sx, fonts["bebasneue-18"], "center", "center")
        dxDrawRectangle(sx*0.54, sy*0.225+sy*0.05, sx*0.35, sy*0.58-sy*0.05, tocolor(27, 27, 27, 100*alpha_pagebg))
        dxDrawRectangle(sx*0.54, sy*0.813, sx*0.35, sy*0.03, tocolor(27, 27, 27, 100*alpha_pagebg))
        dxDrawText("Prémium egyenleged: "..color..comma_value(getElementData(localPlayer, "char:pp")).."#ffffffPP", sx*0.54, sy*0.813, sx*0.54+sx*0.345, sy*0.813+sy*0.03, tocolor(255, 255, 255, 255*alpha_pagebg), 0.8/myX*sx, fonts["condensed-bold"], "right", "center", false, false, false, true)

        local starty = sy*0.225+sy*0.06

        local playerCharID = getElementData(localPlayer, "char:id")
        for k, v in ipairs(premiumInfos) do
            local height = #v.texts*(sy*0.0225) + sy*0.04

            local alpha = 220 * alpha_pagebg

            if k % 2 == 0 then 
                alpha = 110 * alpha_pagebg 
            end

            dxDrawRectangle(sx*0.54, starty, sx*0.35, height, tocolor(30, 30, 30, alpha))
            dxDrawRectangle(sx*0.54, starty, sx*0.0015, height, tocolor(r, g, b, alpha))

            dxDrawText(v.title, sx*0.545, starty, sx*0.545+sx*0.1, starty+sy*0.04, tocolor(255, 255, 255, 255*alpha_pagebg), 0.7/myX*sx, fonts["bebasneue-18"], "left", "center")

            local texty = starty + sy*0.03

            for k2, v2 in ipairs(v.texts) do 
                dxDrawText(v2:gsub("{#charid}", playerCharID), sx*0.545, texty, sx*0.545+sx*0.1, texty+sy*0.025, tocolor(255, 255, 255, 180*alpha_pagebg), 0.75/myX*sx, fonts["condensed-bold"], "left", "center", false, false, false, true)

                texty = texty + sy*0.0225
            end

            starty = starty + height + sy*0.005
        end
    elseif activePage == 7 then 
        local startX = sx*0.33
        local startY = sy*0.308 

        dxDrawText("CASE SHOP", startX, sy*0.21, startX + sx*0.377, sy*0.3, tocolor(255, 255, 255, 255 * alpha_pagebg), 0.9/myX*sx, fonts["bebasneue-25"], "center", "center")
        dxDrawText("Eventek, prémium fegyverek, itemek. Ingyen vagy prémium pontért.", startX, sy*0.26, startX + sx*0.377, sy*0.3, tocolor(255, 255, 255, 100 * alpha_pagebg), 0.7/myX*sx, fonts["condensed-bold"], "center", "center")

        dxDrawRectangle(startX, startY, 300/myX*sx, 300/myY*sy, tocolor(35, 35, 35, 120*alpha_pagebg))
        dxDrawImage(startX + 37.5/myX*sx, startY + 40/myY*sy, 450/myX*sx * 0.5, 317/myY*sy * 0.5, "files/cases/"..creates[1].icon..".png", 0, 0, 0, tocolor(255, 255, 255, 255 * alpha_pagebg))
        
        if creates[1].specialtag then 
            core:dxDrawRoundedRectangle(startX + 4/myX*sx, startY + 4/myY*sy, dxGetTextWidth(creates[1].specialtag, 0.7/myX*sx, fonts["condensed-bold"]) + 12/myX*sx, 20/myY*sy, tocolor(creates[1].tagcolor[1], creates[1].tagcolor[2], creates[1].tagcolor[3], 100 * alpha_pagebg))
            dxDrawText(creates[1].specialtag, startX + 10/myX*sx, startY + 4/myY*sy, 0, startY + 4/myY*sy+20/myY*sy, tocolor(255, 255, 255, 255 * alpha_pagebg), 0.7/myX*sx, fonts["condensed-bold"], "left", "center")
        end 

        dxDrawText(creates[1].name, startX, startY + 215/myY*sy, startX+300/myX*sx, startY + 215/myY*sy, tocolor(255, 255, 255, 255 * alpha_pagebg), 0.9/myX*sx, fonts["bebasneue-18"], "center", "center")
        
        local currentTimestamp = getTimestamp(core:getDate("year"), core:getDate("month"), core:getDate("monthday"), core:getDate("hour"), core:getDate("minute"), core:getDate("second"))
        local kulonbseg = creates[1].expire - currentTimestamp
        local day = math.floor(kulonbseg/86400)
        local hour = math.floor((kulonbseg/3600) - (day * 24))

        if kulonbseg > 0 then
            dxDrawText(day .. " nap "..hour.." óra", startX, startY + 235/myY*sy, startX+300/myX*sx, startY + 235/myY*sy, tocolor(255, 255, 255, 100 * alpha_pagebg), 0.7/myX*sx, fonts["condensed-bold"], "center", "center")
            
            local lastDailyOpenedTime = getElementData(localPlayer, "dailyGift:bigGift:lastOpenTime") or 0
            local openDifference = (getElementData(root, "dash:timestamp") - lastDailyOpenedTime) / 60 / 60
            --print(openDifference/60/60)
            if ((getElementData(root, "dash:timestamp") - lastDailyOpenedTime) < 23*60*60) then
                local remainTime = (23*60*60) - (getElementData(root,"dash:timestamp") - lastDailyOpenedTime) --math.floor(23 - openDifference)
                remainTime = remainTime / 60 / 60
                remainTime = math.floor(remainTime)

                core:dxDrawButton(startX + 10/myX*sx, startY + 250/myY*sy, 280/myX*sx, 40/myY*sy, creates[1].tagcolor[1], creates[1].tagcolor[2], creates[1].tagcolor[3], 100 * alpha_pagebg, remainTime .. " ÓRA", tocolor(255, 255, 255, 100 * alpha_pagebg), 0.7/myX*sx, fonts["condensed-bold"], true, tocolor(0, 0, 0, 20 * alpha_pagebg))
            else
                core:dxDrawButton(startX + 10/myX*sx, startY + 250/myY*sy, 280/myX*sx, 40/myY*sy, creates[1].tagcolor[1], creates[1].tagcolor[2], creates[1].tagcolor[3], 200 * alpha_pagebg, "INGYENES", tocolor(255, 255, 255, 255 * alpha_pagebg), 0.7/myX*sx, fonts["condensed-bold"], true, tocolor(0, 0, 0, 100 * alpha_pagebg))
            end
        else
            dxDrawText("Nem elérhető!", startX, startY + 235/myY*sy, startX+300/myX*sx, startY + 235/myY*sy, tocolor(255, 255, 255, 100 * alpha_pagebg), 0.7/myX*sx, fonts["condensed-bold"], "center", "center")
            core:dxDrawButton(startX + 10/myX*sx, startY + 250/myY*sy, 280/myX*sx, 40/myY*sy, creates[1].tagcolor[1], creates[1].tagcolor[2], creates[1].tagcolor[3], 100 * alpha_pagebg, "INGYENES", tocolor(255, 255, 255, 100 * alpha_pagebg), 0.7/myX*sx, fonts["condensed-bold"], true, tocolor(0, 0, 0, 20 * alpha_pagebg))
        end

        startX = startX + 304/myX*sx


        dxDrawRectangle(startX, startY, 300/myX*sx, 148/myY*sy, tocolor(35, 35, 35, 120*alpha_pagebg))
        dxDrawImage(startX + 5/myX*sx, startY + 50/myY*sy, 450/myX*sx * 0.3, 317/myY*sy * 0.3, "files/cases/easter.png", 0, 0, 0, tocolor(255, 255, 255, 255 * alpha_pagebg))
        dxDrawText("DAILY FREE BOX", startX + 10/myX*sx, startY + 25/myY*sy, startX+300/myX*sx+ 10/myX*sx, startY + 25/myY*sy, tocolor(255, 255, 255, 255 * alpha_pagebg), 0.9/myX*sx, fonts["bebasneue-18"], "left", "center")
        dxDrawRectangle( startX + 10/myX*sx, startY + 37/myY*sy, 280/myX*sx, sy*0.005, tocolor(30, 30, 30, 100 * alpha_pagebg))

        local openCount = getElementData(localPlayer,  "dailyGift:openCount") or 0
        dxDrawRectangle( startX + 10/myX*sx, startY + 37/myY*sy, 280/myX*sx * (openCount / 7), sy*0.005, tocolor(r, g, b, 200 * alpha_pagebg))
        dxDrawText("SUPERBOX \n"..(7 - openCount).." nap múlva", startX + 10/myX*sx, startY + 15/myY*sy, startX+293/myX*sx, startY + 25/myY*sy, tocolor(255, 255, 255, 100 * alpha_pagebg), 0.6/myX*sx, fonts["condensed-bold"], "right", "center")
        
        local lastDailyOpenedTime = getElementData(localPlayer, "dailyGift:lastOpenTime") or 0
        local openDifference = (getElementData(root, "dash:timestamp") - lastDailyOpenedTime) / 60 / 60
        if ((getElementData(root, "dash:timestamp") - lastDailyOpenedTime) < 23*60*60) then
            local remainTime = (23*60*60) - (getElementData(root,"dash:timestamp") - lastDailyOpenedTime) --math.floor(23 - openDifference)
            remainTime = remainTime / 60 / 60
            remainTime = math.floor(remainTime)

            core:dxDrawButton(startX + 150/myX*sx, startY + 100/myY*sy, 140/myX*sx, 40/myY*sy, r, g, b, 100 * alpha_pagebg,  remainTime .. " ÓRA", tocolor(255, 255, 255, 100 * alpha_pagebg), 0.7/myX*sx, fonts["condensed-bold"], true, tocolor(0, 0, 0, 20 * alpha_pagebg))
        else
            core:dxDrawButton(startX + 150/myX*sx, startY + 100/myY*sy, 140/myX*sx, 40/myY*sy, r, g, b, 200 * alpha_pagebg, "INGYENES", tocolor(255, 255, 255, 255 * alpha_pagebg), 0.7/myX*sx, fonts["condensed-bold"], true, tocolor(0, 0, 0, 100 * alpha_pagebg))
        end

        startY = startY + 152/myY*sy
       

        for i = 1, 6 do 
            dxDrawRectangle(startX, startY, 148/myX*sx, 148/myY*sy, tocolor(35, 35, 35, 120*alpha_pagebg))

            if creates[1 + i] then
                dxDrawImage(startX + 5/myX*sx, startY + 15/myY*sy, 450/myX*sx * 0.3, 317/myY*sy * 0.3, "files/cases/"..creates[1 + i].icon..".png", 0, 0, 0, tocolor(255, 255, 255, 255 * alpha_pagebg))
                dxDrawText(creates[1 + i].name, startX, startY + 5/myY*sy, startX + 148/myX*sx, startY + 5/myY*sy + 148/myY*sy, tocolor(255, 255, 255, 200 * alpha_pagebg),  0.7/myX*sx, fonts["condensed-bold"], "center", "top", false, false, false, false, false, 0)
                core:dxDrawButton(startX + 10/myX*sx, startY + 115/myY*sy, 128/myX*sx, 25/myY*sy, r, g, b, 200 * alpha_pagebg, creates[1 + i].price.."PP", tocolor(255, 255, 255, 255 * alpha_pagebg), 0.7/myX*sx, fonts["condensed-bold"], true, tocolor(0, 0, 0, 100 * alpha_pagebg))
            else
                dxDrawText("COMING SOON", startX, startY, startX + 148/myX*sx, startY + 148/myY*sy, tocolor(255, 255, 255, 200 * alpha_pagebg),  0.9/myX*sx, fonts["bebasneue-25"], "center", "center", false, false, false, false, false, 45)
            end

            if i == 1 then 
                startX = startX + 152/myX*sx
            elseif i == 2 then 
                startY = startY + 152/myY*sy
                startX = sx*0.33
            elseif i > 2 then
                startX = startX + 152/myX*sx
            end
        end
    end
    --dxDrawRectangle(sx*0.14,sy*0.2,sx*0.765,sy*0.67, tocolor(255, 255, 255, 100)) -- középső terület
end

local buyPanelState = "car"
local buyPanelType = "sell"

local buyPanelEditboxs = {
    ["buypanel-name"] = "",
    ["buypanel-price"] = 0,
}
local activeBuyPanelEditbox = false
local inVehTrade = false

local traderPlayer = false
local tradePrice = 0
local tradeVeh = false
local tradeInt = false

function renderCarBuyPanel()
    if buyPanelState == "car" then
        if buyPanelType == "sell" then 
            core:drawWindow(sx*0.4, sy*0.45, sx*0.2, sy*0.15, "Jármű eladás", 1)

            dxDrawRectangle(sx*0.4+6/myX*sx, sy*0.48, sx*0.2-12/myX*sx, sy*0.03, tocolor(27, 27, 27, 200))
            dxDrawText("Személy ID: ", sx*0.405+6/myX*sx, sy*0.48, sx*0.405+6/myX*sx+sx*0.2-12/myX*sx, sy*0.48+sy*0.03, tocolor(255, 255, 255, 255), 0.75/myX*sx, fonts["condensed-bold-11"], "left", "center")
            dxDrawText(color..buyPanelEditboxs["buypanel-name"], sx*0.395+6/myX*sx, sy*0.48, sx*0.395+6/myX*sx+sx*0.2-12/myX*sx, sy*0.48+sy*0.03, tocolor(255, 255, 255, 255), 0.75/myX*sx, fonts["condensed-bold-11"], "right", "center", false, false, false, true)

            dxDrawRectangle(sx*0.4+6/myX*sx, sy*0.52, sx*0.2-12/myX*sx, sy*0.03, tocolor(27, 27, 27, 200))
            dxDrawText("Jármű ára: ", sx*0.405+6/myX*sx, sy*0.52, sx*0.405+6/myX*sx+sx*0.2-12/myX*sx, sy*0.52+sy*0.03, tocolor(255, 255, 255, 255), 0.75/myX*sx, fonts["condensed-bold-11"], "left", "center")
            dxDrawText(color..buyPanelEditboxs["buypanel-price"].."#ffffff$", sx*0.395+6/myX*sx, sy*0.52, sx*0.395+6/myX*sx+sx*0.2-12/myX*sx, sy*0.52+sy*0.03, tocolor(255, 255, 255, 255), 0.75/myX*sx, fonts["condensed-bold-11"], "right", "center", false, false, false, true)
            
            core:dxDrawButton(sx*0.4+6/myX*sx, sy*0.56, sx*0.1-12/myX*sx, sy*0.03, 76, 173, 88, 150, "Eladás", tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["condensed-bold-11"], true, tocolor(0, 0, 0, 100))
            core:dxDrawButton(sx*0.4+6/myX*sx + sx*0.1, sy*0.56, sx*0.1-12/myX*sx, sy*0.03, 189, 49, 49, 150, "Mégsem", tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["condensed-bold-11"], true, tocolor(0, 0, 0, 100))
        elseif buyPanelType == "buy" then 
            core:drawWindow(sx*0.4, sy*0.5 - sy*0.23/2, sx*0.2, sy*0.32, "Jármű vásárlás", 1)

            local tunings = getElementData(tradeVeh, "veh:engineTunings")

            local tuningList = {"engine", "gear", "brake", "turbo", "ecu", "wloss"}
            local tuningNamesList = {"Motor", "Váltó", "Fékek", "Turbó", "ECU", "Súlycsökkentés"}

            local tuningVehList = {}
            local listStartY = sy*0.48

            dxDrawText(color..getPlayerName(traderPlayer):gsub("_", " ").." #ffffffel szeretne neked adni egy \n "..color..vehicle:getModdedVehicleName(tradeVeh).." #fffffftípusú járművet \n #98e396"..tradePrice.."#ffffff$-ért.", sx*0.4, sy*0.5 - sy*0.23/2, sx*0.6, (sy*0.5 - sy*0.23/2)  + sy*0.12, tocolor(255, 255, 255, 255), 0.85/myX*sx, fonts["condensed-bold-11"], "center", "center", false, false, false, true)

            for i = 1, #tuningList do
                local barAlpha = 200

                if (i % 2) == 0 then
                    barAlpha = 150
                end

                dxDrawRectangle(sx*0.4+6/myX*sx, listStartY, sx*0.2-12/myX*sx, sy*0.03, tocolor(27, 27, 27, barAlpha))
                dxDrawText(tuningNamesList[i]..":", sx*0.4+10/myX*sx, listStartY, sx*0.4+10/myX*sx+sx*0.2-12/myX*sx, listStartY+sy*0.03, tocolor(255, 255, 255, 255), 0.75/myX*sx, fonts["condensed-bold-11"], "left", "center")

                if string.match(toJSON(tunings), tuningList[i]) then 
                    local type = 0

                    for k, v in ipairs(tunings) do 
                        if string.match(v, tuningList[i]) then 
                            local tuningCat = tostring(v:gsub(tuningList[i], ""):gsub("-", ""))
                            type = tonumber(tuningCat)
                        end
                    end

                    table.insert(tuningVehList, tuning_categories[type])
                    if type == 4 then 
                        dxDrawText("#499cf5"..tuning_categories[type], sx*0.4+2/myX*sx, listStartY, sx*0.4+2/myX*sx+sx*0.2-12/myX*sx, listStartY+sy*0.03, tocolor(r, g, b, 255), 0.75/myX*sx, fonts["condensed-bold-11"], "right", "center", false, false, false, true)
                    else
                        dxDrawText(tuning_categories[type], sx*0.4+2/myX*sx, listStartY, sx*0.4+2/myX*sx+sx*0.2-12/myX*sx, listStartY+sy*0.03, tocolor(r, g, b, 255), 0.75/myX*sx, fonts["condensed-bold-11"], "right", "center")
                    end
                else
                    table.insert(tuningVehList, "Gyári")
                    dxDrawText("#f54949Gyári", sx*0.4+2/myX*sx, listStartY, sx*0.4+2/myX*sx+sx*0.2-12/myX*sx, listStartY+sy*0.03, tocolor(r, g, b, 255), 0.75/myX*sx, fonts["condensed-bold-11"], "right", "center", false, false, false, true)
                end

                listStartY = listStartY + sy*0.03
            end


            core:dxDrawButton(sx*0.4+6/myX*sx, sy*0.665, sx*0.1-12/myX*sx, sy*0.03, 76, 173, 88, 150, "Vásárlás", tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["condensed-bold-11"], true, tocolor(0, 0, 0, 100))
            core:dxDrawButton(sx*0.5+6/myX*sx, sy*0.665, sx*0.1-12/myX*sx, sy*0.03, 189, 49, 49, 150, "Elutasítás", tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["condensed-bold-11"], true, tocolor(0, 0, 0, 100))
        end
    elseif buyPanelState == "int" then 
        if buyPanelType == "sell" then 
            core:drawWindow(sx*0.4, sy*0.45, sx*0.2, sy*0.15, "Ingatlan eladás", 1)

            dxDrawRectangle(sx*0.4+6/myX*sx, sy*0.48, sx*0.2-12/myX*sx, sy*0.03, tocolor(27, 27, 27, 200))
            dxDrawText("Személy ID: ", sx*0.405+6/myX*sx, sy*0.48, sx*0.405+6/myX*sx+sx*0.2-12/myX*sx, sy*0.48+sy*0.03, tocolor(255, 255, 255, 255), 0.75/myX*sx, fonts["condensed-bold-11"], "left", "center")
            dxDrawText(color..buyPanelEditboxs["buypanel-name"], sx*0.395+6/myX*sx, sy*0.48, sx*0.395+6/myX*sx+sx*0.2-12/myX*sx, sy*0.48+sy*0.03, tocolor(255, 255, 255, 255), 0.75/myX*sx, fonts["condensed-bold-11"], "right", "center", false, false, false, true)

            dxDrawRectangle(sx*0.4+6/myX*sx, sy*0.52, sx*0.2-12/myX*sx, sy*0.03, tocolor(27, 27, 27, 200))
            dxDrawText("Ingatlan ára: ", sx*0.405+6/myX*sx, sy*0.52, sx*0.405+6/myX*sx+sx*0.2-12/myX*sx, sy*0.52+sy*0.03, tocolor(255, 255, 255, 255), 0.75/myX*sx, fonts["condensed-bold-11"], "left", "center")
            dxDrawText(color..buyPanelEditboxs["buypanel-price"].."#ffffff$", sx*0.395+6/myX*sx, sy*0.52, sx*0.395+6/myX*sx+sx*0.2-12/myX*sx, sy*0.52+sy*0.03, tocolor(255, 255, 255, 255), 0.75/myX*sx, fonts["condensed-bold-11"], "right", "center", false, false, false, true)
            
            core:dxDrawButton(sx*0.4+6/myX*sx, sy*0.56, sx*0.1-12/myX*sx, sy*0.03, 76, 173, 88, 150, "Eladás", tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["condensed-bold-11"], true, tocolor(0, 0, 0, 100))
            core:dxDrawButton(sx*0.4+6/myX*sx + sx*0.1, sy*0.56, sx*0.1-12/myX*sx, sy*0.03, 189, 49, 49, 150, "Mégsem", tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["condensed-bold-11"], true, tocolor(0, 0, 0, 100))
        elseif buyPanelType == "buy" then 
            core:drawWindow(sx*0.4, sy*0.5 - sy*0.23/2, sx*0.2, sy*0.32, "Ingatlan vásárlás", 1)

            local dataList = {"inttype", "custom"}
            local tuningNamesList = {"Típus", "Szerkeszthető"}
            local intTypes = {
                [0] = "Ház",
                [1] = "Biznisz",
                [2] = "Önkormányzati ingatlan",
                [3] = "Bérház",
                [4] = "Garázs",
            }

            local tuningVehList = {}
            local listStartY = sy*0.48

            dxDrawText(color..getPlayerName(traderPlayer):gsub("_", " ").." #ffffffel szeretne neked adni egy \n "..color..getElementData(tradeInt, "name").." #ffffffnevű ingatlant \n #98e396"..tradePrice.."#ffffff$-ért.", sx*0.4, sy*0.5 - sy*0.23/2, sx*0.6, (sy*0.5 - sy*0.23/2)  + sy*0.12, tocolor(255, 255, 255, 255), 0.85/myX*sx, fonts["condensed-bold-11"], "center", "center", false, false, false, true)

            for i = 1, #dataList do
                local barAlpha = 200

                if (i % 2) == 0 then
                    barAlpha = 150
                end

                local dataValue = getElementData(tradeInt, dataList[i])

                if dataList[i] == "inttype" then 
                    dataValue = intTypes[dataValue]
                elseif dataList[i] == "custom" then 
                    if dataValue == 0 then 
                        dataValue = "Nem"
                    else
                        dataValue = dataValue .. "x" .. dataValue
                    end
                end

                dxDrawRectangle(sx*0.4+6/myX*sx, listStartY, sx*0.2-12/myX*sx, sy*0.03, tocolor(27, 27, 27, barAlpha))
                dxDrawText(tuningNamesList[i]..":", sx*0.4+10/myX*sx, listStartY, sx*0.4+10/myX*sx+sx*0.2-12/myX*sx, listStartY+sy*0.03, tocolor(255, 255, 255, 255), 0.75/myX*sx, fonts["condensed-bold-11"], "left", "center")
                dxDrawText(dataValue, sx*0.4+2/myX*sx, listStartY, sx*0.4+2/myX*sx+sx*0.2-12/myX*sx, listStartY+sy*0.03, tocolor(r, g, b, 255), 0.75/myX*sx, fonts["condensed-bold-11"], "right", "center")
    
                listStartY = listStartY + sy*0.03
            end


            core:dxDrawButton(sx*0.4+6/myX*sx, sy*0.665, sx*0.1-12/myX*sx, sy*0.03, 76, 173, 88, 150, "Vásárlás", tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["condensed-bold-11"], true, tocolor(0, 0, 0, 100))
            core:dxDrawButton(sx*0.5+6/myX*sx, sy*0.665, sx*0.1-12/myX*sx, sy*0.03, 189, 49, 49, 150, "Elutasítás", tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["condensed-bold-11"], true, tocolor(0, 0, 0, 100))
        end
    end
end

local buypanelShiftState = false
function keyCarBuyPanel(key, state)
    if key == "mouse1" then 
        if state then 
            if buyPanelType == "sell" then 
                if core:isInSlot(sx*0.4+6/myX*sx, sy*0.48, sx*0.2-12/myX*sx, sy*0.03) then 
                    activeBuyPanelEditbox = "buypanel-name"
                elseif core:isInSlot(sx*0.4+6/myX*sx, sy*0.52, sx*0.2-12/myX*sx, sy*0.03) then 
                    activeBuyPanelEditbox = "buypanel-price"
                else
                    activeBuyPanelEditbox = false
                end

                if core:isInSlot(sx*0.4+6/myX*sx + sx*0.1, sy*0.56, sx*0.1-12/myX*sx, sy*0.03) then 
                    removeEventHandler("onClientRender", root, renderCarBuyPanel)
                    removeEventHandler("onClientKey", root, keyCarBuyPanel)

                    buyPanelEditboxs = {
                        ["buypanel-name"] = "",
                        ["buypanel-price"] = 0,
                    }
                end

                if core:isInSlot(sx*0.4+6/myX*sx, sy*0.56, sx*0.1-12/myX*sx, sy*0.03) then 
                    local target = false
                    if tonumber(buyPanelEditboxs["buypanel-name"]) then 
                        target = core:getPlayerFromPartialName(localPlayer, tonumber(buyPanelEditboxs["buypanel-name"]))
                    else
                        target = core:getPlayerFromPartialName(localPlayer, buyPanelEditboxs["buypanel-name"]:gsub(" ", "_"))
                    end

                    if target then 
                        if not (target == localPlayer) then 
                            if core:getDistance(target, localPlayer) < 5 then 
                                if not getElementData(target, "dashboard:inTrade") then
                                    if tonumber(buyPanelEditboxs["buypanel-price"]) > 0 then 
                                        inVehTrade = target

                                        if buyPanelState == "car" then
                                            triggerServerEvent("buypanel > startVehSell", resourceRoot, target, tonumber(buyPanelEditboxs["buypanel-price"]), selledCar)
                                            selectedVehicleLine = 0
                                            vehicleScroll = 0
                                        elseif buyPanelState == "int" then
                                            triggerServerEvent("buypanel > startIntSell", resourceRoot, target, tonumber(buyPanelEditboxs["buypanel-price"]), selledInt)
                                            interiorScroll = 0
                                        end

                                        removeEventHandler("onClientRender", root, renderCarBuyPanel)
                                        removeEventHandler("onClientKey", root, keyCarBuyPanel)

                                        buyPanelEditboxs = {
                                            ["buypanel-name"] = "",
                                            ["buypanel-price"] = 0,
                                        }
                                    else
                                        infobox:outputInfoBox("Legalább 1$-ért kell el adnod.", "error")
                                    end
                                else
                                    infobox:outputInfoBox("Ez a játékos éppen vásárol/elad.", "error")
                                end
                            else
                                infobox:outputInfoBox("Ez a játékos túl messze van tőled.", "error")
                            end
                        else
                            infobox:outputInfoBox("Magadnak nem adhatod el.", "error")
                        end
                    else
                        infobox:outputInfoBox("Nem található játékos "..buyPanelEditboxs["buypanel-name"].." névrészlettel.", "error")
                    end
                end    
            elseif buyPanelType == "buy" then 
                if core:isInSlot(sx*0.4+6/myX*sx, sy*0.665, sx*0.1-12/myX*sx, sy*0.03) then 
                    if getElementData(localPlayer, "char:money") >= tradePrice then 
                        if buyPanelState == "car" then
                            getPlayerAllOwnedVehicle()
                            if (#vagyon["vehicles"] + 1) <= getElementData(localPlayer, "char:vehSlot") then 
                                tradeEnd(2)
                            else
                                tradeEnd(5)
                            end
                        elseif buyPanelState == "int" then
                            getPlayerAllOwnedInterior()
                            if (#vagyon["interiors"] + 1) <= getElementData(localPlayer, "char:intSlot") then 
                                tradeEnd(2)
                            else
                                tradeEnd(5)
                            end
                        end
                    else
                        tradeEnd(3)
                    end
                end    

                if core:isInSlot(sx*0.5+6/myX*sx, sy*0.665, sx*0.1-12/myX*sx, sy*0.03) then
                    tradeEnd(4)
                end
            end
        end
    else
        if key == "lshift" or key == "rshift" then 
            buypanelShiftState = state
        else
            if state then 
                if activeBuyPanelEditbox then 
                    cancelEvent()
                    key = key:gsub("num_", "")

                    if buypanelShiftState then 
                        key = string.upper(key)
                    end

                    if not tiltott_keys[key] then 
                        if string.len(tostring(buyPanelEditboxs[activeBuyPanelEditbox])) <= 30 then
                            if activeBuyPanelEditbox == "buypanel-price" or activeBuyPanelEditbox == "buypanel-name" then
                                if not tonumber(key) then return end 

                                if tonumber(buyPanelEditboxs[activeBuyPanelEditbox]) == 0 then 
                                    buyPanelEditboxs[activeBuyPanelEditbox] = key 
                                else
                                    buyPanelEditboxs[activeBuyPanelEditbox] = buyPanelEditboxs[activeBuyPanelEditbox]..key 
                                end
                            else
                                buyPanelEditboxs[activeBuyPanelEditbox] = buyPanelEditboxs[activeBuyPanelEditbox]..key 
                            end
                        end
                    elseif key == "backspace" then 
                        buyPanelEditboxs[activeBuyPanelEditbox] = tostring(buyPanelEditboxs[activeBuyPanelEditbox])
                        buyPanelEditboxs[activeBuyPanelEditbox] = buyPanelEditboxs[activeBuyPanelEditbox]:gsub("[^\128-\191][\128-\191]*$", "")

                        if activeBuyPanelEditbox == "buypanel-price" then
                            if string.len(buyPanelEditboxs[activeBuyPanelEditbox]) == 0 then 
                                buyPanelEditboxs[activeBuyPanelEditbox] = 0
                            end
                        end
                    elseif key == "space" then 
                        buyPanelEditboxs[activeBuyPanelEditbox] = buyPanelEditboxs[activeBuyPanelEditbox].." " 
                    end
                end
            end
        end
    end
end

local checkTimer = false

addEvent("buypanel > startbuy", true)
addEventHandler("buypanel > startbuy", root, function(player, price, veh)
    traderPlayer = player
    tradePrice = price
    tradeVeh = veh
    showBuyPanel("buy", "car")

    checkTimer = setTimer(function()
        if core:getDistance(localPlayer, traderPlayer) > 7 then 
            tradeEnd(1)
        end
    end, 150, 0)
end)

addEvent("buypanel > startbuy > int", true)
addEventHandler("buypanel > startbuy > int", root, function(player, price, veh)
    traderPlayer = player
    tradePrice = price
    tradeInt = veh
    showBuyPanel("buy", "int")

    checkTimer = setTimer(function()
        if core:getDistance(localPlayer, traderPlayer) > 7 then 
            tradeEnd(1)
        end
    end, 150, 0)
end)

function tradeEnd(type)
    if isTimer(checkTimer) then 
        killTimer(checkTimer)
    end

    removeEventHandler("onClientRender", root, renderCarBuyPanel)
    removeEventHandler("onClientKey", root, keyCarBuyPanel)

    if type == 1 then 
        infobox:outputInfoBox("Túl messzire mentél az eladótól, így a vásárlás megszakadt.", "warning")
    elseif type == 2 then 
        infobox:outputInfoBox("Sikeres vásárlás.", "success")
    elseif type == 3 then 
        infobox:outputInfoBox("Nincs elegendő pénzed a vásárláshoz.", "error")
    elseif type == 4 then 
        infobox:outputInfoBox("Elutasítottad az ajánlatot.", "success")
    elseif type == 5 then 
        infobox:outputInfoBox("Nincs elegendő slotod a vásárláshoz.", "error")
    end

    if buyPanelState == "car" then
        triggerServerEvent("buypanel > endVehSell", resourceRoot, traderPlayer, type, tradeVeh, tradePrice)
    elseif buyPanelState == "int" then
        triggerServerEvent("buypanel > endIntSell", resourceRoot, traderPlayer, type, tradeInt, tradePrice)
    end

    traderPlayer = false
    tradePrice = false
end

function showBuyPanel(type, state)
    buyPanelType = type
    buyPanelState = state
    addEventHandler("onClientRender", root, renderCarBuyPanel)
    addEventHandler("onClientKey", root, keyCarBuyPanel)
end

function pedRot( _, _, x, y )               
    local cX, cY = getCursorPosition()
    local defX, defY = pedRotating_DefaultCursorPos

    if cX > 0.5 then 
        if cX < posnovekedes then 
            pedRotation = pedRotation - 2
        else
            pedRotation = pedRotation + 2
        end
    else 
        if cX > posnovekedes then 
            pedRotation = pedRotation + 2
        else
            pedRotation = pedRotation - 2
        end
    end
    posnovekedes = cX 

    cX = cX*2

    if not oldRot ~= rotation then
        if not rotation ~= rotation then 
            preview:setRotation(Player3dView,0,0,tonumber(pedRotation))
        end
    end
end

local useShist = false

local lastDashFactionVehInteraction = 0

function click(key,state)
    if state then 
        if editboxs[selectedEditbox] then 
            cancelEvent()
            if not tiltott_keys[key] then 
                key = key:gsub("num_", "")
      
                if selectedEditbox == "faction_member_join" then 
                    if tonumber(key) or tostring(key) then 
                        if string.len(tostring(editboxs[selectedEditbox])) < 30 then 
                            editboxs[selectedEditbox] = editboxs[selectedEditbox]..key
                        end
                    end
                elseif selectedEditbox == "faction_rank_create" then 
                    if string.len(tostring(editboxs[selectedEditbox])) < 30 then 
                        if tonumber(editboxs[selectedEditbox]) == 0 then 
                            editboxs[selectedEditbox] = key
                        else 
                            editboxs[selectedEditbox] =  editboxs[selectedEditbox]..key
                        end
                    end
                elseif selectedEditbox == "faction_duty_create" then 
                    if string.len(tostring(editboxs[selectedEditbox])) < 30 then 
                        if tonumber(editboxs[selectedEditbox]) == 0 then 
                            editboxs[selectedEditbox] = key
                        else 
                            editboxs[selectedEditbox] =  editboxs[selectedEditbox]..key
                        end
                    end
                elseif selectedEditbox == "faction_rank_payment" then 
                    if tonumber(key) then 
                        if string.len(tostring(editboxs[selectedEditbox])) < 7 then 
                            if tonumber(editboxs[selectedEditbox]) == 0 then 
                                editboxs[selectedEditbox] = key
                            else 
                                editboxs[selectedEditbox] =  editboxs[selectedEditbox]..key
                            end
                        end
                    end
                elseif selectedEditbox == "faction_leader_bank_money" then 
                    if tonumber(key) then 
                        if string.len(tostring(editboxs[selectedEditbox])) < 10 then 
                            if tonumber(editboxs[selectedEditbox]) == 0 then 
                                editboxs[selectedEditbox] = key
                            else 
                                editboxs[selectedEditbox] =  editboxs[selectedEditbox]..key
                            end
                        end
                    end
                elseif selectedEditbox == "faction_leader_description" then 
                    if string.len(tostring(editboxs[selectedEditbox])) < 220 then 
                        if useShift then 
                            key = string.upper(key)
                        end
                        if custom_keys[key] then
                            editboxs[selectedEditbox] = editboxs[selectedEditbox]..custom_keys[key] 
                        else
                            editboxs[selectedEditbox] = editboxs[selectedEditbox]..key
                        end
                    end
                else
                    if useShift then 
                        key = string.upper(key)
                    end
                    if custom_keys[key] then
                        editboxs[selectedEditbox] = editboxs[selectedEditbox]..custom_keys[key] 
                    else
                        editboxs[selectedEditbox] = editboxs[selectedEditbox]..key
                    end
                end
            elseif key == "backspace" then
                editboxs[selectedEditbox] = tostring(editboxs[selectedEditbox])
                editboxs[selectedEditbox] = editboxs[selectedEditbox]:gsub("[^\128-\191][\128-\191]*$", "")

                if selectedEditbox == "faction_leader_bank_money" then 
                    if string.len(tostring(editboxs[selectedEditbox])) == 0 then 
                        editboxs[selectedEditbox] =  "0"
                    end
                end
            elseif key == "space" then 
                editboxs[selectedEditbox] = editboxs[selectedEditbox] .. " "
            end
        end
    end 

    if key == "lshift" or key == "rshift" then 
        useShift = state
    end

    if key == "mouse1" then 
        if core:isInSlot(sx*0.78, sy*0.13, sx*0.12, sy*0.07) then 
            openBugReportMenu()
            closeDash()
        end
    
        if activePage == 1 then 
            if state then 
                if core:isInSlot(sx*0.45,sy*0.3,sx*0.11,sy*0.5) then 
                    local cx, cy = getCursorPosition()
                    pedRotating_DefaultCursorPos = {cx,cy}
                    posnovekedes = 0
                    addEventHandler("onClientCursorMove", root, pedRot)
                end
            else
                posnovekedes = 0
                removeEventHandler( "onClientCursorMove", root, pedRot)
            end
        end

        if state then 
            local hoverStart = sy*0.21
            for k,v in ipairs(pages) do 
                if core:isInSlot(sx*0.105,hoverStart,sx*0.03,sy*0.05) then 
                    if not (tonumber(activePage) == tonumber(k)) then
                        setDashboardPage(activePage, k)
                        activePage = k 
                    end
                end
                hoverStart = hoverStart + sy*0.072
            end

            if activePage == 2 then 
                if isCursorShowing() then 

                    if not slotPanelShowing then
                        if core:isInSlot(sx*0.33, sy*0.6, sx*0.1, sy*0.04) then 
                            slotPanelShowing = not slotPanelShowing
                            slotPanelState = "int"
                            slotPanelNum = 0
                            slotPanelTick = getTickCount()
                            slotPanelAnimState = "open"
                        end

                        if core:isInSlot(sx*0.33, sy*0.22, sx*0.1, sy*0.04) then
                            slotPanelShowing = not slotPanelShowing
                            slotPanelState = "veh"
                            slotPanelNum = 0
                            slotPanelTick = getTickCount()
                            slotPanelAnimState = "open"
                        end
                    end

                    if slotPanelShowing then 
                        if core:isInSlot(sx*0.4+6/myX*sx, sy*0.51, sx*0.1-12/myX*sx, sy*0.03) then 
                            if slotPanelNum > 0 then
                                if getElementData(localPlayer, "char:pp") >= slotPanelNum * 100 then 
                                    infobox:outputInfoBox("Sikeres vásárlás!", "success")
                                    triggerServerEvent("slot > buySlot", resourceRoot, slotPanelState, slotPanelNum)

                                    slotPanelTick = getTickCount()
                                    slotPanelAnimState = "close"

                                    setTimer(function()
                                        slotPanelShowing = false
                                    end, 300, 1)
                                else
                                    infobox:outputInfoBox("Nincs elegendő prémium pontod a vásárláshoz! ("..(slotPanelNum*100).."PP)", "error")
                                end
                            end
                        end
            
                        if core:isInSlot(sx*0.5+6/myX*sx, sy*0.51, sx*0.1-12/myX*sx, sy*0.03) then 
                            if slotPanelAnimState == "open" then 
                                slotPanelTick = getTickCount()
                                slotPanelAnimState = "close"

                                setTimer(function()
                                    slotPanelShowing = false
                                end, 300, 1)
                            end
                        end

                        if core:isInSlot(sx*0.43, sy*0.445, 20/myX*sx, 20/myX*sx) then 
                            if slotPanelNum > 0 then 
                                slotPanelNum = slotPanelNum - 1
                            end
                        end
            
                        if core:isInSlot(sx*0.57 - 20/myX*sx, sy*0.445, 20/myX*sx, 20/myX*sx) then 
                            if slotPanelNum < 999 then 
                                slotPanelNum = slotPanelNum + 1
                            end
                        end
                    end

                    if slotPanelShowing == false then
                        if core:isInSlot(sx*0.16,sy*0.22+sy*0.04,sx*0.27,sy*0.3) then 
                            --if slotPanelShowing == false then
                                local startY = sy*0.265
                                local volt = false
                                for i=1, 9 do 
                                    if vagyon["vehicles"][i] then  
                                        if core:isInSlot(sx*0.16,startY,sx*0.268,sy*0.03) then 
                                            if not (selectedVehicleLine == i+vehicleScroll) then 
                                                if not vagyon["vehicles"][i+vehicleScroll][17] then
                                                    if getElementData(localPlayer,"dashboard:veh") then 
                                                        update3dveh(vagyon["vehicles"][i+vehicleScroll][8],vagyon["vehicles"][i+vehicleScroll][7][1],vagyon["vehicles"][i+vehicleScroll][7][2],vagyon["vehicles"][i+vehicleScroll][7][3], vagyon["vehicles"][i+vehicleScroll][14], vagyon["vehicles"][i+vehicleScroll][18])
                                                    else
                                                        create3dveh(vagyon["vehicles"][i+vehicleScroll][8],vagyon["vehicles"][i+vehicleScroll][7][1],vagyon["vehicles"][i+vehicleScroll][7][2],vagyon["vehicles"][i+vehicleScroll][7][3], vagyon["vehicles"][i+vehicleScroll][14], vagyon["vehicles"][i+vehicleScroll][18])
                                                    end

                                                    playSound("files/sounds/hover.wav")
                                                    vehicleDataPanelTick = getTickCount()
                                                    selectedVehicleLine = i+vehicleScroll
                                                end
                                            end
                                            volt = true
                                        end

                                        startY = startY + sy*0.0325
                                    end
                                end
                            --end

                            if not volt then 
                                selectedVehicleLine = 0
                                destroy3dveh()
                            end
                        end
                    end

                    if (tonumber(selectedVehicleLine) or 0) > 0 then 
                        if core:isInSlot(sx*0.87,sy*0.396,sx*0.0156,sy*0.027) then 
                            if mapVehicleBlip then 
                                destroyElement(mapVehicleBlip) 
                                destroyElement(mapVehicleMarker)
                                mapVehicleBlip = false
                                mapVehicleMarker = false
                                infobox:outputInfoBox("A járműved megjelölése törölve lett a térképről!","success")
                            else
                                infobox:outputInfoBox("A járműved meg lett jelölve a térképen!","success")
                                --mapVehicleBlip = createBlip(vagyon["vehicles"][selectedVehicleLine][6][1],vagyon["vehicles"][selectedVehicleLine][6][2],vagyon["vehicles"][selectedVehicleLine][6][3],3)
                                vehicleElement = vagyon["vehicles"][selectedVehicleLine][13]
                                mapVehicleBlip = createBlipAttachedTo(vehicleElement, 3)
                                setElementData(mapVehicleBlip, "blip:name", "Járműved")
                                mapVehicleMarker = createMarker(vagyon["vehicles"][selectedVehicleLine][6][1],vagyon["vehicles"][selectedVehicleLine][6][2],vagyon["vehicles"][selectedVehicleLine][6][3],"checkpoint",3.0,r,g,b)
                                setElementData(mapVehicleMarker, "vehmapmarker", true)
                                attachElements(mapVehicleMarker, vehicleElement)
                                --createMarkerAttachedTo()
                            end
                        end

                        if core:isInSlot(sx*0.725,sy*0.396,sx*0.0156,sy*0.027) then 
                            if not getElementData(localPlayer, "dashboard:vehicleBuy") then 
                                if not getElementData(localPlayer, "dashboard:inTrade") then
                                    if core:getDistance(vagyon["vehicles"][selectedVehicleLine][13], localPlayer) < 8 then
                                        selledCar = vagyon["vehicles"][selectedVehicleLine][13]
                                        closeDash()
                                        showBuyPanel("sell", "car")
                                    else
                                        infobox:outputInfoBox("A jármű túl messze van tőled!", "error")
                                    end
                                else
                                    infobox:outputInfoBox("Jelenleg már folyamatban van egy vásárlás/eladás!", "error")
                                end
                            end
                        end
                    end

                    if #vagyon["interiors"] > 0 then 
                        local startY = sy*0.645
                        for i=1, 6 do 
                            if vagyon["interiors"][i+interiorScroll] then  
                                if not (vagyon["interiors"][i+interiorScroll][5] == 5) then 
                                    if core:isInSlot(sx*0.41, startY+3/myY*sy, 20/myX*sx, 20/myY*sy) then
                                        if not getElementData(localPlayer, "dashboard:inTrade") then
                                            if (getElementData(activeInteriorMarker, "dbid") or 0) == vagyon["interiors"][i+interiorScroll][2] then 
                                                showBuyPanel("sell", "int")
                                                selledInt = activeInteriorMarker
                                                closeDash()
                                            else
                                                infobox:outputInfoBox("Nem állsz az interior markerben!", "error")
                                            end
                                        else
                                            infobox:outputInfoBox("Jelenleg már folyamatban van egy vásárlás/eladás!", "error")
                                        end
                                    end
                                end
                                
        
                                startY = startY + sy*0.0325
                            end
                        end
                    end
                end
            elseif activePage == 3 then 
                if core:isInSlot(sx*0.675, sy*0.805, sx*0.21, sy*0.05) then 
                    local admincount = 0
                    for k, v in ipairs(onlienPlayers) do 
                        local alevel = getElementData(v, "user:admin") or 0

                        if (alevel >= 2 and alevel <= 8) then 
                            if getElementData(v, "user:aduty") then 
                                admincount = admincount + 1
                            end
                        end
                    end

                    if admincount == 0 then 
                        if not isTimer(callAdminTimer) then 
                            infobox:outputInfoBox("Sikeresen értesítetted az adminisztrátorokat!", "success")
                            triggerServerEvent("dash > admin > callAdmins", resourceRoot)
                            callAdminTimer = setTimer(function()
                                if isTimer(callAdminTimer) then
                                    killTimer(callAdminTimer) 
                                end
                            end, core:minToMilisec(5), 1)
                        else
                            infobox:outputInfoBox("Csak 5 percenként kérhetsz adminisztrátori segítséget!", "warning")
                        end
                    else
                        infobox:outputInfoBox("Jelenleg van adminisztrátor szolgálatban!", "warning")
                    end
                end
            elseif activePage == 4 then 
                keyPanel_options(key, state)
            elseif activePage == 5 then 
                if #faction_datas.factions > 0 then 
                    local startY = sy*0.22+sy*0.045
                    for k, v in ipairs(faction_datas.factions) do 
                        if core:isInSlot(sx*0.15,startY,sx*0.15,sy*0.03) then 
                            if not (tonumber(k) == tonumber(selectedFactionLine)) then 
                                isLeaderPanelShowing = false
                                factionPanelPage = 1
                                selectedFactionLine = k
                                selectedFactionVehLine = 0
                                getFactionVehicles()
                                factionPanelVehiclePointer = 0
                                selectedMemberLine = 0
                                selectedRankLine = 0
                                setAllLeaderButtonStateToDefault()
                                factionPanelMembersPointer = 0
                                factionPanelRanksPointer = 0

                                if factionPanelPage == 5 then 
                                    destroyDutySkinPreview()
                                    isDutySkinPreview = false
                                end

                                playSound("files/sounds/hover.wav")

                                break
                            end
                        end

                        startY = startY + sy*0.0325
                    end
                end

                if selectedFactionLine > 0 then 
                    local startX = sx*0.3
                    for k, v in ipairs(factionPages) do      
                        if core:isInSlot(startX, sy*0.8, sx*0.065, sy*0.05) then 
                            if not (factionPanelPage == k) then
                                factionPanelPage = k

                                if factionPanelPage == 3 then 
                                    getFactionVehicles()
                                    selectedFactionVehLine = 0
                                end

                                factionPanelVehiclePointer = 0

                                destroyDutySkinPreview()
                                isDutySkinPreview = false
                                isLeaderPanelShowing = false
                                selectedEditbox = false
                                setAllLeaderButtonStateToDefault()
                                playSound("files/sounds/hover.wav")
                                break 
                            end
                        end 

                        startX = startX + sx*0.1
                    end
                end

                if selectedFactionLine > 0 then 
                    if factionPanelPage == 1 then
                        if core:isInSlot(sx*0.3025, sy*0.45, sx*0.14, sy*0.05) and not isLeaderPanelShowing then 
                            fkId = faction_datas.factions[selectedFactionLine]
                            triggerServerEvent("mainFactionSettings", localPlayer, localPlayer, fkId, getFactionName(fkId))
                        end
                        if isPlayerLeader(faction_datas.factions[selectedFactionLine]) then
                            if core:isInSlot(sx*0.3025, sy*0.73, sx*0.14, sy*0.05) then 
                                isLeaderPanelShowing = true 
                                playSound("files/sounds/hover.wav")
                                editboxs["faction_leader_description"] = client_faction_list[faction_datas.factions[selectedFactionLine]][12]
                            end
        
                            if isLeaderPanelShowing then
                                if core:isInSlot(sx*0.4+4/myX*sx, sy*0.34, sx*0.2-8/myX*sx, sy*0.1) then -- desc
                                    selectedEditbox = "faction_leader_description"
                                end
                        
                                if core:isInSlot(sx*0.4+4/myX*sx, sy*0.443, sx*0.2-8/myX*sx, sy*0.03) then -- desc save
                                    if not ( editboxs["faction_leader_description"] == client_faction_list[faction_datas.factions[selectedFactionLine]][12] ) then 
                                        selectedEditbox = false
                                        triggerServerEvent("faction > leader > editFactionDesc", resourceRoot, faction_datas.factions[selectedFactionLine], editboxs["faction_leader_description"])
                                        infobox:outputInfoBox("Sikeresen módosítottad a frakció leírását!", "success")
                                    else
                                        infobox:outputInfoBox("Nem változott a frakció leírása!", "warning")
                                    end
                                end

                                --if not (getFactionType(faction_datas.factions[selectedFactionLine]) == 4 or getFactionType(faction_datas.factions[selectedFactionLine]) == 5) then 
                                    if core:isInSlot(sx*0.4+4/myX*sx, sy*0.535, sx*0.2-8/myX*sx, sy*0.04) then 
                                        selectedEditbox = "faction_leader_bank_money"
                                    end

                                    if isElementWithinColShape(localPlayer, leaderMoneyTransactionCol) then 
                                        if core:isInSlot(sx*0.4+4/myX*sx, sy*0.58, sx*0.2-8/myX*sx, sy*0.03) then -- money out
                                            if tonumber(editboxs["faction_leader_bank_money"]) > 0 then 
                                                triggerServerEvent("faction > leader > bankTransaction", resourceRoot, faction_datas.factions[selectedFactionLine], tonumber(editboxs["faction_leader_bank_money"]), 1)
                                                isLeaderPanelShowing = false
                                            end
                                            editboxs["faction_leader_bank_money"] = "0"
                                            playSound("files/sounds/hover.wav")
                                            selectedEditbox = false
                                        end

                                        if core:isInSlot(sx*0.4+4/myX*sx, sy*0.615, sx*0.2-8/myX*sx, sy*0.03) then -- money in
                                            if tonumber(editboxs["faction_leader_bank_money"]) > 0 then 
                                                triggerServerEvent("faction > leader > bankTransaction", resourceRoot, faction_datas.factions[selectedFactionLine], tonumber(editboxs["faction_leader_bank_money"]), 2)
                                                isLeaderPanelShowing = false
                                            end
                                            editboxs["faction_leader_bank_money"] = "0"
                                            playSound("files/sounds/hover.wav")
                                            selectedEditbox = false
                                        end
                                    end
                                --end

                                if core:isInSlot(sx*0.4+4/myX*sx, sy*0.7-4/myY*sy-sy*0.04, sx*0.2-8/myX*sx, sy*0.04) then 
                                    isLeaderPanelShowing = false
                                    selectedEditbox = false
                                --    deleteEditbox(getEditboxFromName("faction-skins-selected"))
                                    editboxs["faction_leader_bank_money"] = "0"
                                    playSound("files/sounds/hover.wav")
                                end
                            end
                        end
                    elseif factionPanelPage == 2 then 
                        local startY = sy*0.22+sy*0.045
                        for i = 1, 16 do 
                            local v = client_factionMember_list[faction_datas.factions[selectedFactionLine]][i+factionPanelMembersPointer]
                            if v then 
                                if core:isInSlot(sx*0.31, startY, sx*0.35, sy*0.03) then 
                                    if not (selectedMemberLine == i+factionPanelMembersPointer ) then 
                                        selectedMemberLine = i+factionPanelMembersPointer
                                        setAllLeaderButtonStateToDefault()
                                        playSound("files/sounds/hover.wav")
                                        break
                                    end                            
                                end
                                startY = startY + sy*0.0325
                            end
                        end

                        if selectedMemberLine > 0 then 
                            if isPlayerLeader(faction_datas.factions[selectedFactionLine]) then 
                                local startY = sy*0.51+sy*0.045

                                for i = 1, 5 do 

                                    v = factionLeaderOptions[i + factionLeaderOptionsPointer]
                                    k = i + factionLeaderOptionsPointer

                                    if core:isInSlot(sx*0.67, startY, sx*0.22, sy*0.03) then 
                                        factionLeader_buttonPressNumbers[k] = factionLeader_buttonPressNumbers[k] + 1

                                        if not isTimer(setPlayerRankTimer) then 
                                            if k == 1 then 
                                                if client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][2] < #client_faction_list[faction_datas.factions[selectedFactionLine]][7] then 
                                                    triggerServerEvent("faction > leader > setPlayerRank", resourceRoot, faction_datas.factions[selectedFactionLine], client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][1], client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][2]+1)
                                                    selectedMemberLine = 0
                                                else 
                                                    infobox:outputInfoBox("Ez a játékos már a maximum rangon van!", "error")
                                                end
                                            elseif k == 2 then
                                                if client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][2] > 1 then 
                                                    triggerServerEvent("faction > leader > setPlayerRank", resourceRoot, faction_datas.factions[selectedFactionLine], client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][1], client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][2]-1)
                                                    selectedMemberLine = 0
                                                else 
                                                    infobox:outputInfoBox("Ez a játékos már a minimum rangon van!", "error")
                                                end
                                            elseif k == 3 then 
                                                if factionLeader_buttonPressNumbers[k] >= 2 then 
                                                    if not (client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][1] == getElementData(localPlayer, "char:id")) then 
                                                        if client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][3] then 
                                                            outputChatBox(core:getServerPrefix("green-dark", "Frakció", 3).."Sikeresen elvetted a leader jososultságot "..color..client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][4]:gsub("_", " ").." #ffffffnevű játékostól.", 255, 255, 255, true)
                                                            infobox:outputInfoBox("Sikeresen elvetted a leader jogosultságát "..client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][4]:gsub("_", " ").." nevű játékostól.", "success")
                                                            triggerServerEvent("faction > leader > setleader", resourceRoot, faction_datas.factions[selectedFactionLine], client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][1], false)
                                                        else
                                                            outputChatBox(core:getServerPrefix("green-dark", "Frakció", 3).."Sikeresen leader jososultságot adtál "..color..client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][4]:gsub("_", " ").." #ffffffnevű játékosnak.", 255, 255, 255, true)
                                                            infobox:outputInfoBox("Sikeresen leader jogosultságot adtál"..client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][4]:gsub("_", " ").." nevű játékosnak.", "success")
                                                            triggerServerEvent("faction > leader > setleader", resourceRoot, faction_datas.factions[selectedFactionLine], client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][1], true)
                                                        end
                                                    else
                                                        outputChatBox(core:getServerPrefix("red-dark", "Frakció", 3).."Saját magadattól nem veheted el a leader jogosultságot.", 255, 255, 255, true)
                                                        infobox:outputInfoBox("Saját magadattól nem veheted el a leader jogosultságot.", "error")
                                                    end
                                                    factionLeader_buttonPressNumbers[k] = 0
                                                end
                                            elseif k == 4 then 
                                                if factionLeader_buttonPressNumbers[k] >= 2 then 
                                                    if not (client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][1] == getElementData(localPlayer, "char:id")) then 
                                                        outputChatBox(core:getServerPrefix("green-dark", "Frakció", 3).."Sikeresen kirúgtad a frakcióból "..color..tostring(client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][4]):gsub("_", " ").." #ffffffnevű játékost.", 255, 255, 255, true)
                                                        infobox:outputInfoBox("Sikeresen kirúgtad a frakcióból "..tostring(client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][4]):gsub("_", " ").." nevű játékost.", "success")

                                                        triggerServerEvent("faction > leader > fire", resourceRoot, faction_datas.factions[selectedFactionLine], client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][1])

                                                        selectedMemberLine = 0
                                                    else
                                                        outputChatBox(core:getServerPrefix("red-dark", "Frakció", 3).."Saját magadat nem rúghatod ki a frakcióból.", 255, 255, 255, true)
                                                        infobox:outputInfoBox("Saját magadat nem rúghatod ki a frakcióból!", "error")
                                                    end
                                                    factionLeader_buttonPressNumbers[k] = 0
                                                end
                                            elseif k == 5 then 
                                                if client_faction_list[faction_datas.factions[selectedFactionLine]][3] <= 3 then
                                                    if (client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][9] or 0) > 0 then 
                                                        triggerServerEvent("faction > leader > resetPlayerDutyTime", resourceRoot, faction_datas.factions[selectedFactionLine], client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][1])
                                                    else
                                                        infobox:outputInfoBox("Csak akkor nullázhatod a szolgálati időt, ha az eléri az 1 percet!", "error")
                                                    end
                                                else
                                                    infobox:outputInfoBox("Ez a funkció csak LEGÁLIS frakciók számára érhető el!", "warning")
                                                end
                                            elseif k == 6 then 
                                                if client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][6] then 
                                                    if client_faction_list[faction_datas.factions[selectedFactionLine]][3] <= 3 then
                                                        triggerServerEvent("faction > leader > giveBadgeToPlayer", resourceRoot, faction_datas.factions[selectedFactionLine], client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][1], client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][2])
                                                    else
                                                        infobox:outputInfoBox("Ez a funkció csak LEGÁLIS frakciók számára érhető el!", "warning")
                                                    end
                                                    --print(client_factionMember_list[faction_datas.factions[selectedFactionLine]][selectedMemberLine][1])
                                                else 
                                                    infobox:outputInfoBox("Csak ONLINE tagnak adhatsz jelvényt!", "error")
                                                end
                                            end

                                            setPlayerRankTimer = setTimer(function() 
                                                if isTimer(setPlayerRankTimer) then 
                                                    killTimer(setPlayerRankTimer)
                                                end
                                            end, 250, 1)
                                        end

                                        break
                                    end

                                    startY = startY + sy*0.0325
                                end
                            end
                        end
                        
                        if isPlayerLeader(faction_datas.factions[selectedFactionLine]) then 
                            if core:isInSlot(sx*0.67, sy*0.735, sx*0.225, sy*0.055) then 
                                selectedEditbox = "faction_member_join"
                            else
                                selectedEditbox = false
                            end
        
                            if core:isInSlot(sx*0.87, sy*0.745, 33/myX*sx, 33/myY*sy) then 
                                if editboxs["faction_member_join"] then 
                                    triggerServerEvent("faction > leader > addmember", resourceRoot, faction_datas.factions[selectedFactionLine], editboxs["faction_member_join"])
                                end
                                editboxs["faction_member_join"] = ""
                                selectedEditbox = false
                            end
                        end
                    elseif factionPanelPage == 3 then 
                        -- vehicle panel
                        local startY = sy*0.267
                        for i = 1, 7 do 
                            local v = factionVehicles[i+factionPanelVehiclePointer]
                        
                            if v then 
                                if core:isInSlot(sx*0.31, startY, sx*0.585, sy*0.055) then 
                                    if not (selectedFactionVehLine == i+factionPanelVehiclePointer) then 
                                        selectedFactionVehLine = i+factionPanelVehiclePointer
                                        playSound("files/sounds/hover.wav")
                                    end
                                end
    
                                startY = startY + sy*0.06
                            end
                        end

                        if selectedFactionVehLine > 0 then 
                            if isPlayerLeader(faction_datas.factions[selectedFactionLine]) then 
                                if core:isInSlot(sx*0.862, sy*0.75, 30/myX*sx, 30/myY*sy) then 
                                    if lastDashFactionVehInteraction + 1000 < getTickCount() then 
                                        lastDashFactionVehInteraction = getTickCount()
                                        triggerServerEvent("faction > giveVehicleKeyToLeader", resourceRoot, getElementData(factionVehicles[selectedFactionVehLine], "veh:id"))
                                        infobox:outputInfoBox("Sikeresen adtál magadnak egy járműkulcsot. (Jármű azonosító: "..getElementData(factionVehicles[selectedFactionVehLine], "veh:id")..")", "success")
                                        --print("kulcs", getElementData(factionVehicles[selectedFactionVehLine], "veh:id"))
                                    end
                                end
    
                                if core:isInSlot(sx*0.84, sy*0.75, 30/myX*sx, 30/myY*sy) then 
                                    if lastDashFactionVehInteraction + 1000 < getTickCount() then 
                                        lastDashFactionVehInteraction = getTickCount()
                                        print("sell")
                                    end
                                end
                            end
                        end
                    elseif factionPanelPage == 4 then 
                        local startY = sy*0.22+sy*0.045
                        for i = 1, 16 do 
                            local v = client_faction_list[faction_datas.factions[selectedFactionLine]][7][i+factionPanelRanksPointer]
                            if v then 
                                if core:isInSlot(sx*0.31, startY, sx*0.35, sy*0.03) then 
                                    if not (selectedRankLine == i+factionPanelRanksPointer ) then 
                                        selectedRankLine = i+factionPanelRanksPointer
                                        selectedEditbox = false
                                        editboxs["faction_rank_name"] = client_faction_list[faction_datas.factions[selectedFactionLine]][7][selectedRankLine][1]
                                        editboxs["faction_rank_payment"] = client_faction_list[faction_datas.factions[selectedFactionLine]][7][selectedRankLine][2]
                                        factionAttachedDuty = client_faction_list[faction_datas.factions[selectedFactionLine]][7][selectedRankLine][3]
                                        setAllLeaderButtonStateToDefault()
                                        playSound("files/sounds/hover.wav")
                                        break
                                    end                            
                                end
                                startY = startY + sy*0.0325
                            end
                        end

                        if isPlayerLeader(faction_datas.factions[selectedFactionLine]) then 
                            if core:isInSlot(sx*0.67, sy*0.735, sx*0.225, sy*0.055) then 
                                selectedEditbox = "faction_rank_create"
                            end
        
                            if core:isInSlot(sx*0.87, sy*0.745, 33/myX*sx, 33/myY*sy) then 
                                if string.len(editboxs["faction_rank_create"]) > 2 then 
                                    if #client_faction_list[faction_datas.factions[selectedFactionLine]][7] < 25 then 
                                        triggerServerEvent("faction > leader > createRank", resourceRoot, faction_datas.factions[selectedFactionLine], editboxs["faction_rank_create"])
                                    else
                                        infobox:outputInfoBox("Nem hozhatsz létre 25-nél több rangot!", "warning")
                                    end
                                end
                                editboxs["faction_rank_create"] = ""
                                selectedEditbox = false
                            end
                        end

                        if selectedRankLine > 0 then 
                            if isPlayerLeader(faction_datas.factions[selectedFactionLine]) then   
                                local starty = sy*0.516
                                for i = 1, 5 do 
                                    local size = sy*0.04

                                    if i == 4 then 
                                        size = sy*0.03
                                    end

                                    --selectedEditbox = false

                                    if core:isInSlot(sx*0.67, starty, sx*0.225, size) then  
                                        if i == 1 then 
                                            selectedEditbox = "faction_rank_name"
                                        elseif i == 2 then 
                                            if not (getFactionType(faction_datas.factions[selectedFactionLine]) == 4 or getFactionType(faction_datas.factions[selectedFactionLine]) == 5) then 
                                                selectedEditbox = "faction_rank_payment"
                                            end
                                        elseif i == 3 then
                                            if factionAttachedDuty < #client_faction_list[faction_datas.factions[selectedFactionLine]][8] then 
                                                factionAttachedDuty = factionAttachedDuty + 1
                                            else
                                                factionAttachedDuty = 0
                                            end
                                        elseif i == 4 then 
                                            factionLeader_buttonPressNumbers[5] = factionLeader_buttonPressNumbers[5] + 1
                                            if factionLeader_buttonPressNumbers[5] >= 2 then 
                                                if getAllPlayerInRank(client_faction_list[faction_datas.factions[selectedFactionLine]][1], selectedRankLine) > 0 then 
                                                    infobox:outputInfoBox("Csak akkor törölhetsz rangot ha nincs olyan rangal rendelkező tag!", "warning")
                                                else
                                                    if selectedRankLine == #client_faction_list[faction_datas.factions[selectedFactionLine]][7] then 
                                                        triggerServerEvent("faction > leader > delRank", resourceRoot, faction_datas.factions[selectedFactionLine], selectedRankLine)
                                                        selectedRankLine = 0
                                                        infobox:outputInfoBox("Sikeresen töröltél egy rangot!", "success")
                                                    else 
                                                        infobox:outputInfoBox("Ez a rang nem törölhető!", "warning")
                                                    end
                                                end
                                                factionLeader_buttonPressNumbers[5] = 0
                                            end
                                        elseif i == 5 then 
                                            if string.len(tostring(editboxs["faction_rank_payment"])) == 0 then 
                                                editboxs["faction_rank_payment"] = "0"
                                            end

                                            if string.len(tostring(editboxs["faction_rank_name"])) >= 3 then 


                                                if (tonumber(editboxs["faction_rank_payment"]) == tonumber(client_faction_list[faction_datas.factions[selectedFactionLine]][7][selectedRankLine][2])) and (tostring(editboxs["faction_rank_name"]) == tostring(client_faction_list[faction_datas.factions[selectedFactionLine]][7][selectedRankLine][1])) and (tonumber(factionAttachedDuty) == tonumber(client_faction_list[faction_datas.factions[selectedFactionLine]][7][selectedRankLine][3])) then 
                                                    infobox:outputInfoBox("Nem történt változtatás!", "warning")
                                                else
                                                    triggerServerEvent("faction > leader > editRank", resourceRoot, faction_datas.factions[selectedFactionLine], selectedRankLine, tostring(editboxs["faction_rank_name"]), tonumber(editboxs["faction_rank_payment"]), tonumber(factionAttachedDuty))
                                                end
                                            else
                                                infobox:outputInfoBox("A rang nevének minimum 3 karakterből kell állnia!", "warning")
                                            end
                                        end
                                    end

                                    if i == 4 then 
                                        starty = starty + sy*0.034
                                    else
                                        starty = starty + sy*0.044
                                    end
                                end
                            end
                        end
                    elseif factionPanelPage == 5 then 
                        if isPlayerLeader(faction_datas.factions[selectedFactionLine]) then
                            if core:isInSlot(sx*0.31, sy*0.75, sx*0.25, sy*0.05) then 
                                selectedEditbox = "faction_duty_create"
                            else
                                --selectedEditbox = false
                            end

                            if core:isInSlot(sx*0.535, sy*0.758, 33/myX*sx, 33/myY*sy) then 
                                if string.len(editboxs["faction_duty_create"]) >= 3 then  
                                    --selectedEditbox = false 

                                    if #client_faction_list[faction_datas.factions[selectedFactionLine]][8] < 25 then 
                                        triggerServerEvent("faction > leader > createDuty", resourceRoot, faction_datas.factions[selectedFactionLine], editboxs["faction_duty_create"])
                                        editboxs["faction_duty_create"] = ""
                                        infobox:outputInfoBox("Sikeresen létrehoztál egy dutyt!", "success")
                                    else
                                        infobox:outputInfoBox("Nem hozhatsz létre 25-nél több dutyt!", "warning")
                                    end
                                else
                                    infobox:outputInfoBox("A duty nevének minimum 3 karakterből kell állnia!", "warning")
                                end
                            end

                            local startY = sy*0.22+sy*0.045
                            for i = 1, 16 do 
                                local v = client_faction_list[faction_datas.factions[selectedFactionLine]][8][i+factionPanelDutysPointer]
                                if v then 
                                    if core:isInSlot(sx*0.31, startY, sx*0.25, sy*0.03) then 
                                        selectedDutyLine = i
                                        factionDutyElements_temp["items"] = client_faction_list[faction_datas.factions[selectedFactionLine]][8][selectedDutyLine][2]
                                        factionDutyElements_temp["skins"] = client_faction_list[faction_datas.factions[selectedFactionLine]][8][selectedDutyLine][3]
                                        editboxs["faction_duty_name"] = client_faction_list[faction_datas.factions[selectedFactionLine]][8][selectedDutyLine][1]
                                        setAllLeaderButtonStateToDefault()
                                        playSound("files/sounds/hover.wav")
                                    end
                                    startY = startY + sy*0.0325
                                end
                            end 
                            
                            local startY = sy*0.22+sy*0.045
                            for i = 1, 8 do 
                                local v = client_faction_list[faction_datas.factions[selectedFactionLine]][4][i+factionPanelDutySkinsPointer]
                                if v then 

                                    local active = tableContains(factionDutyElements_temp["skins"], tonumber(v)) or false 

                                    if core:isInSlot(sx*0.565, startY, sx*0.07, sy*0.03) then 
                                        if active then      
                                            for key, value in ipairs(factionDutyElements_temp["skins"]) do 
                                                if tonumber(value) == tonumber(v) then 
                                                    table.remove(factionDutyElements_temp["skins"], key)
                                                    break 
                                                end
                                            end
                                        else
                                            table.insert(factionDutyElements_temp["skins"], #factionDutyElements_temp["skins"]+1, tonumber(v))
                                        end
                                    end
                    


                                    if core:isInSlot(sx*0.642, startY-sy*0.002, 30/myX*sx, 30/myY*sy) then 
                                        if isDutySkinPreview then 
                                            destroyDutySkinPreview()
                                            isDutySkinPreview = false 
                                        else
                                            isDutySkinPreview = true
                                            dutySkinPreviewModelID = tonumber(v)
                                            createDutySkinPreview()
                                        end
                                    end
                                    
                                    startY = startY + sy*0.0325
                                end
                            end   

                            local realIndex = 1
                            local startY = sy*0.22+sy*0.045
                            for i = 1, 6 do 
                                local v = client_faction_list[faction_datas.factions[selectedFactionLine]][5][i+factionPanelDutyItemsPointer]
                                if v then 

                                    local active = tableContains2(factionDutyElements_temp["items"], tonumber(v)) or false
                                    local itemCount = 0
                                    if core:isInSlot(sx*0.67, startY, sx*0.15, sy*0.05) then 
                                        if active then 
                                            for key, value in ipairs(factionDutyElements_temp["items"]) do 
                                                if tonumber(value[1]) == tonumber(v) then 
                                                    table.remove(factionDutyElements_temp["items"], key)
                                                    itemCount = value[2]
                                                    break 
                                                end
                                            end
                                        else
                                            table.insert(factionDutyElements_temp["items"], #factionDutyElements_temp["items"]+1, {tonumber(v), 1})
                                        end
                                    end

                                    if active then 
                                        if  inventory:getItemStackable(tonumber(v)) then 
                                            for key, value in ipairs(factionDutyElements_temp["items"]) do 
                                                if tonumber(value[1]) == tonumber(v) then 
                                                    if core:isInSlot(sx*0.83, startY+10/myY*sy, 25/myX*sx, 25/myY*sy) then
                                                        factionDutyElements_temp["items"][key][2] =  factionDutyElements_temp["items"][key][2] + 1 
                                                    end
                
                                                    if core:isInSlot(sx*0.8715, startY+10/myY*sy, 25/myX*sx, 25/myY*sy) then 
                                                        if factionDutyElements_temp["items"][key][2] > 1 then 
                                                            factionDutyElements_temp["items"][key][2] = factionDutyElements_temp["items"][key][2] - 1 
                                                        end
                                                    end

                                                    break
                                                end
                                            end
                                            realIndex = realIndex + 1
                                        end 
                                    end
                                
                                    startY = startY + sy*0.0525
                                end
                            end
                            
                            local starty = sy*0.665
                            for i = 1, 3 do
                                local size = sy*0.04

                                if i == 2 then 
                                    size = sy*0.03
                                end

                                --selectedEditbox = false

                                if core:isInSlot(sx*0.67, starty, sx*0.225, size) then  
                                    if i == 1 then 
                                        --print("asd")
                                        selectedEditbox = "faction_duty_name"
                                    elseif i == 2 then 
                                        if selectedDutyLine == #client_faction_list[faction_datas.factions[selectedFactionLine]][8] then 
                                            factionLeader_buttonPressNumbers[6] = factionLeader_buttonPressNumbers[6] + 1
                                            if factionLeader_buttonPressNumbers[6] == 2 then 
                                                triggerServerEvent("faction > leader > delDuty", resourceRoot, faction_datas.factions[selectedFactionLine], selectedDutyLine)
                                                selectedDutyLine = 0
                                                factionLeader_buttonPressNumbers[6] = 0
                                            end
                                        else
                                            infobox:outputInfoBox("Ez a duty nem törölhető!", "warning")
                                        end
                                    elseif i == 3 then  -- BELE KELL RAKNI AZT, HOGY A FOLYAMATOS MENTÉSSEL NE TUDJA KIFAGYASZTANI A SZERVERT
                                        --if (editboxs["faction_duty_name"] == client_faction_list[faction_datas.factions[selectedFactionLine]][8][selectedDutyLine][1]) then
                                        --    infobox:outputInfoBox("Nem történt változtatás!", "warning")
                                        --else
                                            triggerServerEvent("faction > leader > editDuty", resourceRoot, faction_datas.factions[selectedFactionLine], selectedDutyLine, editboxs["faction_duty_name"], factionDutyElements_temp["skins"], factionDutyElements_temp["items"])
                                        --end
                                    end
                                    return
                                end
                                
                                if i == 2 then 
                                    starty = starty + sy*0.034
                                else
                                    starty = starty + sy*0.044
                                end
                            end
                        end
                    end
                end

            elseif activePage == 6 then 
                local menuStartX = sx*0.15
                local oneMenuWidth = sx*0.385 / (#premiumCategories)
                local menuItems = (#premiumCategories)

                for i = 1, menuItems do
                    if core:isInSlot(menuStartX, sy*0.255 + sy*0.03, oneMenuWidth, sy*0.04) then 
                        if not (selectedPremiumPanel == i) then
                            selectedPremiumPanel = i 
                            premiumPanelLastClickedElement = 0
                            premiumPanelPointer = 0
                            playSound("files/sounds/hover.wav")
                            break
                        end
                    end
                    menuStartX = menuStartX + oneMenuWidth 
                end

                --#premiumCategories[selectedPremiumPanel].items

                if selectedPremiumPanel < #premiumCategories then
                    local starty = sy*0.33

                    for i = 1, 11 do 
                        local v = premiumCategories[selectedPremiumPanel].items[i+premiumPanelPointer]

                        if v then     
                            if core:isInSlot(sx*0.465-5/myX*sx, starty+4/myY*sy, sx*0.07, sy*0.04-8/myY*sy) then 
                                playSound("files/sounds/hover.wav")
                                if premiumPanelLastClickedElement == (i+premiumPanelPointer) then 
                                    if getElementData(localPlayer, "char:pp") >= v.price then 
                                        if v.id then 
                                            triggerServerEvent("premiumShop > buyPremiumItem", resourceRoot, {v.id, v.price, v.count, v.value})
                                        else
                                            triggerServerEvent("premiumShop > buyPremiumMoney", resourceRoot, {v.icon, v.price, v.count})
                                        end
                                    else
                                        infobox:outputInfoBox("Nincs elegendő prémium pontod a vásárláshoz!", "error")
                                        premiumPanelLastClickedElement = 0
                                    end
                                    premiumPanelLastClickedElement = 0
                                else
                                    premiumPanelLastClickedElement = i + premiumPanelPointer
                                end
                            end

                            starty = starty + sy*0.047
                        end
                    end
                elseif selectedPremiumPanel == #premiumCategories then 
                    local starty = sy*0.33

                    for i = 1, 6 do 
                        local v = premiumItemPackages[i+premiumPanelPointer2]

                        if v then                             
                            if core:isInSlot(sx*0.465-5/myX*sx, starty+4/myY*sy, sx*0.07, sy*0.04-8/myY*sy) then 
                                playSound("files/sounds/hover.wav")
                                if premiumPanelLastClickedElement == (i+premiumPanelPointer2) then 
                                    if getElementData(localPlayer, "char:pp") >= v.price then
                                        triggerServerEvent("premiumShop > buyPremiumPackage", resourceRoot, {v.name, v.price, v.items})
                                        premiumPanelLastClickedElement = 0
                                    else
                                        infobox:outputInfoBox("Nincs elegendő prémium pontod a vásárláshoz!", "error")
                                        premiumPanelLastClickedElement = 0
                                    end
                                else
                                    premiumPanelLastClickedElement = i + premiumPanelPointer2
                                end
                            end

                            starty = starty + sy*0.086
                        end
                    end
                end
            elseif activePage == 7 then
                local startX = sx*0.33
                local startY = sy*0.308 

                function _openSelectedCreate(name, icon, items)
                    closeDash()
                    local ret = openSelectedCreate(name, icon, items)
                    showChat(false)
                    interface:toggleHud(true)
                    return ret
                end

                if core:isInSlot(startX + 10/myX*sx, startY + 250/myY*sy, 280/myX*sx, 40/myY*sy) then -- nagy ablak
                    local currentTimestamp = getTimestamp(core:getDate("year"), core:getDate("month"), core:getDate("monthday"), core:getDate("hour"), core:getDate("minute"), core:getDate("second"))
                    local kulonbseg = creates[1].expire - currentTimestamp
                    local day = math.floor(kulonbseg/86400)
                    local hour = math.floor((kulonbseg/3600) - (day * 24))
            
                    if kulonbseg > 0 then
                        local lastDailyOpenedTime = getElementData(localPlayer, "dailyGift:bigGift:lastOpenTime") or 0
                        if ((getElementData(root, "dash:timestamp") - lastDailyOpenedTime) < 23*60*60) then
                            local remainTime = (23*60*60) - (getElementData(root,"dash:timestamp") - lastDailyOpenedTime) --math.floor(23 - openDifference)
                            remainTime = remainTime / 60 / 60
                            remainTime = math.floor(remainTime)

                            infobox:outputInfoBox("Az elmúlt {#colorcode}"..remainTime.." #ffffffórában már kinyitottad a különleges dobozt!", "warning")
                        else
                            if _openSelectedCreate(creates[1].name, creates[1].icon, creates[1].gifts) then 
                                setElementData(localPlayer, "dailyGift:bigGift:lastOpenTime", getElementData(root, "dash:timestamp"))
                            end
                        end
                    else
                        infobox:outputInfoBox("Ez az ajánlat nem érhető el!", "error") 
                    end
                end
                
                startX = startX + 304/myX*sx

                if core:isInSlot(startX + 150/myX*sx, startY + 100/myY*sy, 140/myX*sx, 40/myY*sy) then -- daily
                    local lastDailyOpenedTime = getElementData(localPlayer, "dailyGift:lastOpenTime") or 0
                    local openCount = getElementData(localPlayer, "dailyGift:openCount") or 0

                    if ((getElementData(root, "dash:timestamp") - lastDailyOpenedTime) < 23*60*60) then
                        local remainTime = (23*60*60) - (getElementData(root,"dash:timestamp") - lastDailyOpenedTime) --math.floor(23 - openDifference)
                        remainTime = remainTime / 60 / 60
                        remainTime = math.floor(remainTime)
                        infobox:outputInfoBox("Az elmúlt {#colorcode}"..remainTime.." #ffffffórában már kinyitottad a napi ajándékodat!", "warning")
                    else
                        if openCount == 7 then 
                            if _openSelectedCreate("DAILY SUPER BOX", "easter", dailyBoxRewards["super"]) then 
                                setElementData(localPlayer, "dailyGift:openCount", 0)
                                setElementData(localPlayer, "dailyGift:lastOpenTime", getElementData(root, "dash:timestamp"))
                            end
                        else
                            if _openSelectedCreate("DAILY FREE BOX", "easter", dailyBoxRewards["normal"]) then 
                                setElementData(localPlayer, "dailyGift:openCount", openCount + 1)
                                setElementData(localPlayer, "dailyGift:lastOpenTime", getElementData(root, "dash:timestamp"))
                            end
                        end
                    end
                end

                startY = startY + 152/myY*sy

                for i = 1, 6 do -- kicsik
                    if core:isInSlot(startX + 10/myX*sx, startY + 115/myY*sy, 128/myX*sx, 25/myY*sy) then 
                        if getElementData(localPlayer, "char:pp") >= creates[1 + i].price then 
                            if _openSelectedCreate(creates[1 + i].name, creates[1 + i].icon, creates[1 + i].gifts) then 
                                setElementData(localPlayer, "char:pp", getElementData(localPlayer, "char:pp") - creates[1 + i].price)
                                infobox:outputInfoBox("Sikeresen vásároltál egy {#colorcode}"..creates[1 + i].name.."#ffffff boxot. ", "success")
                                outputChatBox(core:getServerPrefix("green-dark", "Case shop", 2).."Sikeresen vásároltál "..color..creates[1 + i].price.."PP#ffffff-ért egy "..color..creates[1 + i].name.." #ffffffboxot. ", 255, 255, 255, true)
                            end
                        else
                            infobox:outputInfoBox("Nincs elegendő prémium pontod a vásárláshoz! {#colorcode}("..creates[1 + i].price.."PP)", "error")
                        end
                    end
        
                    if i == 1 then 
                        startX = startX + 152/myX*sx
                    elseif i == 2 then 
                        startY = startY + 152/myY*sy
                        startX = sx*0.33
                    elseif i > 2 then
                        startX = startX + 152/myX*sx
                    end
                end
        
            end
        else
            if sliderEditing > 0 then
                triggerEvent(options["graphics"][sliderEditing][5], root, options["graphics"][sliderEditing][6]) 
                sliderEditing = 0
            end

            if sliderEditingVignette > 0 then 
                exports.oShader_Vignette:setShaderValues(vignetteSetup[1][6], vignetteSetup[2][6])
                sliderEditingVignette = 0
            end
        end
    end

    if activePage == 2 then 
        if core:isInSlot(sx*0.16,sy*0.22+sy*0.04,sx*0.27,sy*0.3) then 
            if key == "mouse_wheel_down" then
                if vehicleScroll +9 < #vagyon["vehicles"] then 
                    vehicleScroll = vehicleScroll + 1
                end
            end

            if key == "mouse_wheel_up" then
                if vehicleScroll > 0 then 
                    vehicleScroll = vehicleScroll - 1
                end
            end
        end

        if core:isInSlot(sx*0.16,sy*0.6+sy*0.04,sx*0.27,sy*0.203) then 
            if key == "mouse_wheel_down" then
                if interiorScroll +6 < #vagyon["interiors"] then 
                    interiorScroll = interiorScroll + 1
                end
            end

            if key == "mouse_wheel_up" then
                if interiorScroll > 0 then 
                    interiorScroll = interiorScroll - 1
                end
            end
        end

        if core:isInSlot(sx*0.72,sy*0.39+sy*0.04,sx*0.174,(sy*0.033)*#vehicleDatas) then
            if key == "mouse_wheel_down" then
                if vehicleInfoScroll < #vehicleDatas - 13 then 
                    vehicleInfoScroll = vehicleInfoScroll + 1
                end
            end

            if key == "mouse_wheel_up" then
                if vehicleInfoScroll > 0 then 
                    vehicleInfoScroll = vehicleInfoScroll - 1
                end
            end
        end
    elseif activePage == 3 then 
        if core:isInSlot(sx*0.147, sy*0.215+sy*0.05, sx*0.22, sy*0.59) then 
            if key == "mouse_wheel_down" then
                if adminScrolls["as"] + 11 < #onlineAdmins["as"] then 
                    adminScrolls["as"] =  adminScrolls["as"] + 1
                end
            end

            if key == "mouse_wheel_up" then
                if adminScrolls["as"] > 0 then 
                    adminScrolls["as"] =  adminScrolls["as"] - 1
                end
            end
        end

        if core:isInSlot(sx*0.37, sy*0.215+sy*0.05, sx*0.3, sy*0.59) then 
            if key == "mouse_wheel_down" then
                if adminScrolls["ad"] + 11 < #onlineAdmins["ad"] then 
                    adminScrolls["ad"] =  adminScrolls["ad"] + 1
                end
            end

            if key == "mouse_wheel_up" then
                if adminScrolls["ad"] > 0 then 
                    adminScrolls["ad"] =  adminScrolls["ad"] - 1
                end
            end
        end

        if core:isInSlot(sx*0.673, sy*0.215+sy*0.05, sx*0.22, sy*0.537) then 
            if key == "mouse_wheel_down" then
                if adminScrolls["ve"] + 10 < #onlineAdmins["ve"] then 
                    adminScrolls["ve"] =  adminScrolls["ve"] + 1
                end
            end

            if key == "mouse_wheel_up" then
                if adminScrolls["ve"] > 0 then 
                    adminScrolls["ve"] =  adminScrolls["ve"] - 1
                end
            end
        end
    elseif activePage == 4 then 
        if core:isInSlot(sx*0.665, sy*0.605+sy*0.05, sx*0.225, sy*0.182) then 
            if key == "mouse_wheel_down" then
                if options["other"][optionsScrolls["other"]+5] then 
                    optionsScrolls["other"] = optionsScrolls["other"] + 1
                end
            end

            if key == "mouse_wheel_up" then
                if optionsScrolls["other"] > 0 then 
                    optionsScrolls["other"] = optionsScrolls["other"] - 1
                end
            end
        end 
        
    elseif activePage == 5 then 
        if factionPanelPage == 2 then 
            if core:isInSlot(sx*0.31,sy*0.22+sy*0.04,sx*0.35,sy*0.53) then 
                if key == "mouse_wheel_down" then
                    if factionPanelMembersPointer + 16 < #client_factionMember_list[faction_datas.factions[selectedFactionLine]] then 
                        factionPanelMembersPointer = factionPanelMembersPointer + 1
                    end
                end
    
                if key == "mouse_wheel_up" then
                    if factionPanelMembersPointer > 0 then 
                        factionPanelMembersPointer = factionPanelMembersPointer - 1
                    end
                end
            end 

            if core:isInSlot(sx*0.67,sy*0.51+sy*0.04,sx*0.225, sy*0.17) then 
                if key == "mouse_wheel_down" then
                    if factionLeaderOptions[factionLeaderOptionsPointer + 6] then 
                        factionLeaderOptionsPointer = factionLeaderOptionsPointer + 1
                    end
                end
    
                if key == "mouse_wheel_up" then
                    if factionLeaderOptionsPointer > 0 then 
                        factionLeaderOptionsPointer = factionLeaderOptionsPointer - 1
                    end
                end
            end 
        elseif factionPanelPage == 3 then 
            if core:isInSlot(sx*0.31,sy*0.22+sy*0.04,sx*0.585,sy*0.43) then 
                if key == "mouse_wheel_down" then
                    if factionPanelVehiclePointer + 7 < #factionVehicles then 
                        factionPanelVehiclePointer = factionPanelVehiclePointer + 1
                    end
                end
    
                if key == "mouse_wheel_up" then
                    if factionPanelVehiclePointer > 0 then 
                        factionPanelVehiclePointer = factionPanelVehiclePointer - 1
                    end
                end
            end 
        elseif factionPanelPage == 4 then 
            if core:isInSlot(sx*0.31,sy*0.22+sy*0.04,sx*0.35,sy*0.53) then 
                if key == "mouse_wheel_down" then
                    if factionPanelRanksPointer + 16 < #client_faction_list[faction_datas.factions[selectedFactionLine]][7] then 
                        factionPanelRanksPointer = factionPanelRanksPointer + 1
                    end
                end
    
                if key == "mouse_wheel_up" then
                    if factionPanelRanksPointer > 0 then 
                        factionPanelRanksPointer = factionPanelRanksPointer - 1
                    end
                end
            end 
        elseif factionPanelPage == 5 then 
            if core:isInSlot(sx*0.31,sy*0.22+sy*0.04,sx*0.25,sy*0.48) then 
                if key == "mouse_wheel_down" then
                    if factionPanelDutysPointer + 16 < #client_faction_list[faction_datas.factions[selectedFactionLine]][8] then 
                        factionPanelDutysPointer = factionPanelDutysPointer + 1
                    end
                end
    
                if key == "mouse_wheel_up" then
                    if factionPanelDutysPointer > 0 then 
                        factionPanelDutysPointer = factionPanelDutysPointer - 1
                    end
                end
            end 

            if core:isInSlot(sx*0.67,sy*0.22+sy*0.04,sx*0.225, sy*0.324) then 
                if key == "mouse_wheel_down" then
                    if factionPanelDutyItemsPointer + 6 < #client_faction_list[faction_datas.factions[selectedFactionLine]][5] then 
                        factionPanelDutyItemsPointer = factionPanelDutyItemsPointer + 1
                    end
                end
    
                if key == "mouse_wheel_up" then
                    if factionPanelDutyItemsPointer > 0 then 
                        factionPanelDutyItemsPointer = factionPanelDutyItemsPointer - 1
                    end
                end
            end

            if core:isInSlot(sx*0.565, sy*0.22+sy*0.04, sx*0.1, sy*0.268) then 
                if key == "mouse_wheel_down" then
                    if factionPanelDutySkinsPointer + 8 < #client_faction_list[faction_datas.factions[selectedFactionLine]][4] then 
                        factionPanelDutySkinsPointer = factionPanelDutySkinsPointer + 1
                    end
                end
    
                if key == "mouse_wheel_up" then
                    if factionPanelDutySkinsPointer > 0 then 
                        factionPanelDutySkinsPointer = factionPanelDutySkinsPointer - 1
                    end
                end
            end
        end
    elseif activePage == 6 then 
        if core:isInSlot(sx*0.15, sy*0.225+sy*0.05, sx*0.385, sy*0.62-sy*0.05) then 
            if selectedPremiumPanel < #premiumCategories then 
                if key == "mouse_wheel_down" then
                    if premiumPanelPointer + 11 < #premiumCategories[selectedPremiumPanel].items then 
                        premiumPanelPointer = premiumPanelPointer + 1
                    end
                end

                if key == "mouse_wheel_up" then
                    if premiumPanelPointer > 0 then 
                        premiumPanelPointer = premiumPanelPointer - 1
                    end
                end
            elseif selectedPremiumPanel == #premiumCategories then 
                if key == "mouse_wheel_down" then
                    if premiumPanelPointer2 + 6 < #premiumItemPackages then 
                        premiumPanelPointer2 = premiumPanelPointer2 + 1
                    end
                end

                if key == "mouse_wheel_up" then
                    if premiumPanelPointer2 > 0 then 
                        premiumPanelPointer2 = premiumPanelPointer2 - 1
                    end
                end
            end
        end
    end
end

function getDashboardSettingsValue(type, id)
    if not options[type][id] then
        return false 
    end
    
    if options[type][id][6] then
        return options[type][id][6]
    else
        return false
    end
end

function elementDataChange(key,old,new)
    if key == "player:skin" then 
        if activePage == 1 then 
            update3dped()
        end
    end
end

bindKey("pgup","up",function()
    if dashShowing then
        if activePage > 1 then 
            setDashboardPage(activePage, activePage - 1)
            activePage = activePage - 1
        end
    end
end)

bindKey("pgdn","up",function()
    if dashShowing then
        if activePage < #pages then 
            setDashboardPage(activePage, activePage + 1)
            activePage = activePage + 1
        end
    end
end)


function setDashboardPage(oldpage, newpage)
    pageNameTick = getTickCount()
    pageBgTick = getTickCount()
    vehicleDataPanelTick = getTickCount()
    
    playSound("files/sounds/select.wav")

    selectedEditbox = false

    if oldpage == 1 then 
        destroy3dped()
    elseif oldpage == 2 then 
        destroy3dveh()
    elseif oldpage == 5 then 
        if factionPanelPage == 5 then 
            destroyDutySkinPreview()
            isDutySkinPreview = false
        elseif factionPanelPage == 1 then 
            isLeaderPanelShowing = false
        end
    end

    if newpage == 1 then 
        create3dped()
    elseif newpage == 2 then 
        getPlayerAllOwnedVehicle()
        getPlayerAllOwnedInterior()

        getPlayerSlots()
        if (tonumber(selectedVehicleLine) or 0) > 0 then 
            create3dveh(vagyon["vehicles"][selectedVehicleLine][8],vagyon["vehicles"][selectedVehicleLine][7][1],vagyon["vehicles"][selectedVehicleLine][7][2],vagyon["vehicles"][selectedVehicleLine][7][3], vagyon["vehicles"][selectedVehicleLine][14], vagyon["vehicles"][selectedVehicleLine][18])
        end
    elseif newoage == 3 then 
        onlienPlayers = getElementsByType("player")
    elseif newpage == 5 then 
        getPlayerFactionDatas()

        if selectedFactionLine > 0 then 
            if factionPanelPage == 3 then 
                getFactionVehicles()
            end
        end
    elseif newpage == 7 then 
        dailySpin = getTickCount()

        --sx*0.75, sy*0.75, sx*0.12, sy*0.04
    end
end

for k,v in pairs(pages) do 
    icons[v[2]] = dxCreateTexture("files/icons/"..v[2])
end

function openDash()

    dashShowing = true
    tick = getTickCount()
    pageNameTick = getTickCount()
    pageBgTick = getTickCount()
    adminPagePanelTick = getTickCount()
    vehicleDataPanelTick = getTickCount()
    addEventHandler("onClientRender",getRootElement(),render, true, "low-9999")
    addEventHandler("onClientKey",root,click)
    addEventHandler("onClientElementDataChange", root, elementDataChange)
    getPlayerAllOwnedVehicle()
    getPlayerAllOwnedInterior()

    getPlayerSlots()
    selectedEditbox = false

    playSound("files/sounds/open.wav")

    showChat(false)
    for k, v in ipairs(faction_datas.factions) do 
        if getElementData(localPlayer, "char:mainFaction") == v then 
            selectedFactionLine = k
        end
    end

    onlienPlayers = getElementsByType("player")
    for k,v in ipairs(onlienPlayers) do 
        avatars[v] = dxCreateTexture(":oAccount/avatars/"..(getElementData(v, "char:avatarID") or 1)..".png")
    end
    interface:toggleHud(true)
    
    selectedFactionVehLine = 0

    if activePage == 1 then 
        create3dped()
    elseif activePage == 2 then 

        if (tonumber(selectedVehicleLine) or 0) > 0 then 
            create3dveh(vagyon["vehicles"][selectedVehicleLine][8],vagyon["vehicles"][selectedVehicleLine][7][1],vagyon["vehicles"][selectedVehicleLine][7][2],vagyon["vehicles"][selectedVehicleLine][7][3], vagyon["vehicles"][selectedVehicleLine][14])
        end
    elseif activePage == 5 then 
        
        getPlayerFactionDatas()
        --selectedFactionLine = 0
        if selectedFactionLine > 0 then 
            if factionPanelPage == 3 then 
                getFactionVehicles()
            end
        end
    end

    triggerServerEvent("premium > checkPending", localPlayer)
end


function closeDash()
    dashShowing = false
    removeEventHandler("onClientRender",root,render)
    removeEventHandler("onClientKey",root,click)
    removeEventHandler("onClientElementDataChange", root, elementDataChange)
    playSound("files/sounds/close.wav")

    showChat(true)

    interface:toggleHud(false)

    selectedFactionVehLine = 0
    --deleteEditbox(getEditboxFromName("faction-skins-selected"))
    
    if activePage == 1 then 
        destroy3dped()
    elseif activePage == 2 then 
        destroy3dveh()
    elseif activePage == 5 then 
        if factionPanelPage == 5 then 
            destroyDutySkinPreview()
            isDutySkinPreview = false
        elseif factionPanelPage == 1 then 
            isLeaderPanelShowing = false
        end
    end

    for k, v in pairs(avatars) do 
        if isElement(v) then
            destroyElement(v)
        end
        --outputChatBox("asd")
    end
    --[[
    for k, v in pairs(ImageTextures) do 
        if v then
            destroyElement(v)
            ImageTextures[k] = false
        end
    end]]
end

addEventHandler("onClientKey", getRootElement(), function(button, press)
    if press then
        if (button == "home" or button == "F6" or button == "F3") then
            cancelEvent()

            if not getElementData(localPlayer, "user:loggedin") then return end
            if not dashShowing then 
                if button == "F3" then activePage = 5 end
                openDash()
                dashShowing = true
            else
                closeDash()
                dashShowing = false
            end
        end
	end
end)

-- Frissítések --

addEventHandler("onClientElementDataChange", root, function(key, old, new)
    if source == localPlayer then 
        if key == "char:factions" then 
            getPlayerFactionDatas()

            triggerServerEvent("faction > getServerFactionList", resourceRoot)
        end

        if key == "char:vehSlot" then 
            vagyon["vehSlot"] = new
        elseif key == "char:intSlot" then 
            vagyon["intSlot"] = new
        elseif key == "char:fightStyle" or key == "char:walkStyle" then 
            triggerServerEvent("dashboad > setPlayer > "..key:gsub("char:", ""), resourceRoot, new)
        elseif key == "user:loggedin" then 
            local lastDailyOpenedTime = getElementData(localPlayer, "dailyGift:lastOpenTime") or 0
            local openCount = getElementData(localPlayer, "dailyGift:openCount") or 0

            if ((getElementData(root, "dash:timestamp") - lastDailyOpenedTime) > (24*60*60*2)) then
                setElementData(localPlayer, "dailyGift:openCount", 0)
            end
        end
    end
end)

addEventHandler("onClientPlayerQuit", root, function()
    onlienPlayers = getElementsByType("player")
    
    if source == localPlayer then 
        saveDashboardOptions()
    end
end)

-- Beállítások mentése -- 
addEventHandler("onClientResourceStart", resourceRoot, function()

    local data = exports.oJSON:loadDataFromJSONFile("dashboardOptions", true)

    if data then 
        for k, v in pairs(data["graphic"]) do 
            if not (type(k) == "string") then 
                options["graphics"][k][6] = v
            end
        end

        for k, v in pairs(data["xmas"]) do 
            if not (type(k) == "string") then 
                options["xmas"][k][6] = v
            end
        end

        for k, v in pairs(data["other"]) do 
            if not (type(k) == "string") then 
                options["other"][k][6] = v
            end
        end

        for k, v in pairs(options["graphics"]) do 
            if not (type(k) == "string") then
                if (k) > 1 then 
                    if getResourceFromName(v[5]) then 
                        exports[v[5]]:switchShader(v[6])
                    end
                else
                    triggerEvent(v[5], root, v[6]) 
                end
            end
        end 

        for k, v in pairs(options["xmas"]) do 
            if not (type(k) == "string") then
                if k == 1 then 
                    if getResourceFromName(v[5]) then 
                        if (type(v[6]) == "boolean") then 
                            exports[v[5]]:switchShader(v[6])
                        end
                    end
                else
                    triggerEvent(v[5], root, v[6]) 
                end
            end
        end 
    end

    crosshairDatas = (exports.oJSON:loadDataFromJSONFile("crosshairData", true) or {1, {255, 255, 255}})
    setElementData(localPlayer, "char:crosshairID", crosshairDatas[1])
    setElementData(localPlayer, "char:crosshairCOLOR", crosshairDatas[2])

    vignetteDatas = exports.oJSON:loadDataFromJSONFile("vignetteDatas", true)
    for k, v in pairs(vignetteDatas) do 
        vignetteSetup[k][6] = v
    end
    exports.oShader_Vignette:setShaderValues(vignetteSetup[1][6], vignetteSetup[2][6])
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    saveDashboardOptions()
end)

function saveDashboardOptions()
    exports.oJSON:saveDataToJSONFile(crosshairDatas, "crosshairData", true)

    local savedOptions = {
        ["graphic"] = {},
        ["character"] = {},
        ["other"] = {},
        ["xmas"] = {},
    }

    print(toJSON(options["graphics"]))

    for k, v in pairs(options["graphics"]) do 
        if not (type(k) == "string") then 
            table.insert(savedOptions["graphic"], k, v[6])
        end
    end

    for k, v in pairs(options["char"]) do 
        if not (type(k) == "string") then 
            table.insert(savedOptions["character"], k, v[6])
        end
    end

    for k, v in pairs(options["other"]) do 
        if not (type(k) == "string") then 
            table.insert(savedOptions["other"], k, v[6])
        end
    end

    for k, v in pairs(options["xmas"]) do 
        if not (type(k) == "string") then 
            table.insert(savedOptions["xmas"], k, v[6])
        end
    end

    vignetteDatas = {}
    for k, v in pairs(vignetteSetup) do 
        table.insert(vignetteDatas, v[6])
    end
    exports.oJSON:saveDataToJSONFile(vignetteDatas, "vignetteDatas", true)

    exports.oJSON:saveDataToJSONFile(savedOptions, "dashboardOptions", true)
end

function getPlayerFactionDatas() 
    faction_datas.factions = getPlayerAllFactions()

    if #faction_datas.factions > 0 then 
        faction_datas.members = {}

        for k, v in ipairs(faction_datas.factions) do 
            table.insert(faction_datas.members, v, {})
            for k2, player in ipairs(getElementsByType("player")) do 
                local playerFactions = getElementData(player, "char:factions") or {}
                --print("asd")
                --print(k)

                if #playerFactions > 0 then 
                    if tableContains(playerFactions, v) then 
                        table.insert(faction_datas.members[v], #faction_datas.members[v], player)
                    end
                   
                end
            end
        end
    end
    
    -- jelenleg elérhető játékosok beállítása
    for key, members in pairs(client_factionMember_list) do 
        if members then 
            for key, data in pairs(members) do 
                data[6] = isPlayerOnline(data[1])
            end 
        end
    end
end
addEvent("resetPlayerFactionDatas", true)
addEventHandler("resetPlayerFactionDatas", root, getPlayerFactionDatas)

-----------------

-- Jármű keresés --

addEventHandler("onClientMarkerHit", resourceRoot, function(player,mdim)
    if mdim then 
        if source == mapVehicleMarker then 
            destroyElement(mapVehicleMarker)
            destroyElement(mapVehicleBlip)
            mapVehicleBlip = false 
            mapVehicleMarker = false 
            infobox:outputInfoBox("Megtaláltad a járműved!","success")
        end
    end
end)


------------------

function create3dped()
    destroy3dped()

    Player3D = createPed(getElementModel(localPlayer),0,0,0)
    setElementDimension(Player3D, getElementDimension(localPlayer))
    setElementInterior(Player3D, getElementInterior(localPlayer))
    Player3dView = preview:createObjectPreview(Player3D, 0, 0, 180, sx*0.358, sy*0.2, 600*rel, 650*rel, false, true)
    setElementData(localPlayer,"dashboard:ped",Player3D)

    preview:setRotation(Player3dView,0,0, (tonumber(pedRotation) or 0))
end

function update3dped()
    destroy3dped()
    create3dped()
end

function destroy3dped()
    if getElementData(localPlayer,"dashboard:ped") then 
        preview:destroyObjectPreview(getElementData(localPlayer,"dashboard:ped"))
        destroyElement(getElementData(localPlayer,"dashboard:ped"))
        setElementData(localPlayer,"dashboard:ped",false)
    end
end

setTimer(
    function()
        if not dashShowing then 
            destroy3dped()
        end 
    end, 1500, 0
)

function create3dveh(model,r,g,b, otherTunings, variant)
    Vehicle3D = createVehicle(model,0,0,0,0,0,0)
    setElementCollisionsEnabled(Vehicle3D, false)
    setVehicleColor(Vehicle3D,r,g,b)
    setElementDimension(Vehicle3D, getElementDimension(localPlayer))
    setElementInterior(Vehicle3D, getElementInterior(localPlayer))
    Vehicle3dView = preview:createObjectPreview(Vehicle3D, 0, 0, 160, sx*0.44,sy*0.3, 600*rel, 650*rel, false, true)
    setElementData(localPlayer,"dashboard:veh",Vehicle3D)

    if otherTunings then 
        for k, v in ipairs(otherTunings) do 
            addVehicleUpgrade(Vehicle3D, v)
        end
    end
    if variant then 
        setVehicleVariant(Vehicle3D, unpack(variant))
    end
end

function destroy3dveh()
    if (getElementData(localPlayer,"dashboard:veh") or false ) then 
        --outputChatBox("asd")
        preview:destroyObjectPreview(getElementData(localPlayer,"dashboard:veh"))
        destroyElement(getElementData(localPlayer,"dashboard:veh"))
        setElementData(localPlayer,"dashboard:veh",false)
    end
end

function update3dveh(model,r,g,b, otherTunings, variant)
    destroy3dveh()
    create3dveh(model,r,g,b, otherTunings, variant)
end

-----/vagyon funkciók/-----
function getPlayerAllOwnedVehicle()
    vagyon["vehicles"] = {}
    for k, v in ipairs(getElementsByType("vehicle")) do 
        if getElementData(v, "veh:isFactionVehice") == 0 then 
            if getElementData(v, "veh:owner") == getElementData(localPlayer,"char:id") then 
                local posX, posY, posZ = getElementPosition(v)
                local cR, cG, cB = getVehicleColor(v,true)
                --vehName,vehId,vehDoorState,vehEngineState,vehPlateText,Pos{x,y,z},color{r,g,b},vehModelId,vehZoneName(x,y,z),vehHp,vehLampState, tunings, veh,  paintjob, veh:distanceToOilChange
                --    1     2         3            4              5            6       7              8            9             10     11            12    13      14              15

                local vehDoorState = getElementData(v,"veh:locked") 
                local vehEngineState = getElementData(v,"veh:engine")
                local vehLampState = "nan"

                if vehDoorState == true then 
                    vehDoorState = "Zárva"
                else
                    vehDoorState = "Nyitva"
                end

                if vehEngineState == true then 
                    vehEngineState = "Elindítva"
                else
                    vehEngineState = "Leállítva"
                end

                if areVehicleLightsOn(v) == true then 
                    vehLampState = "Felkapcsolva"
                else
                    vehLampState = "Lekapcsolva"
                end

                local otherTunings = {}

                local opticTuningList = {"veh:tuningWheel", "veh:tuning:exhaust", "veh:tuning:roof", "veh:tuning:spoiler", "veh:tuning:rear_bumper", "veh:tuning:front_bumper", "veh:tuning:skirt"}
                for key, value in ipairs(opticTuningList) do 
                    table.insert(otherTunings, (getElementData(v, value) or 0))
                end

                local fuelLevel = math.floor(getElementData(v, "veh:fuel")).." #ffffff/ "..getElementData(v, "veh:maxFuel")
                local fuelType = fuelTypes[getElementData(v, "veh:fuelType")] or "Nincs adat!"
                local oilState = math.floor(getElementData(v, "veh:distanceToOilChange")) or 0

                local isBooked = getElementData(v, "vehIsBooked") or false

                if isBooked == 0 then 
                    isBooked = false
                else
                    isBooked = true
                end

                local variant = getElementData(v, "tuning:vehVariant") or {255, 255}

                table.insert(vagyon["vehicles"],#vagyon["vehicles"]+1,{exports.oVehicle:getModdedVehName(getElementModel(v)),getElementData(v,"veh:id"),vehDoorState,vehEngineState,getVehiclePlateText(v),{posX,posY,posZ},{cR, cG, cB},getElementModel(v),getZoneName(posX,posY,posZ),tostring(math.floor((getElementHealth(v)/10))).."%",vehLampState, getElementData(v, "veh:engineTunings"), v, otherTunings, fuelLevel, fuelType, isBooked, variant, oilState.." km"})
            end
        end
    end
end

function getPlayerAllOwnedInterior()
    vagyon["interiors"] = {}
    for k, v in ipairs(getElementsByType("marker")) do 
        if getElementData(v, "isIntMarker") then 
            if getElementData(v, "owner") == getElementData(localPlayer, "char:id") then 

                --interiorName,interiorID,doorState, location
                --    1           2         3            4

                local interiorName = getElementData(v, "name") 
                local interiorID = getElementData(v, "dbid")
                local doorState = getElementData(v, "locked")
                local location = "Los Santos"

                local markX, markY, markZ = getElementPosition(v)
                location = getZoneName(markX, markY, markZ) or "Los Santos"

                table.insert(vagyon["interiors"], #vagyon["interiors"]+1, {interiorName, interiorID, doorState, location, getElementData(v, "inttype"), getElementData(v, "renewalTime")})
            end
        elseif getElementData(v,"marker:cont:main") then 
            if getElementData(v,"marker:cont:owner") == getElementData(localPlayer,"user:id") then 


                local interiorName = getElementData(v,"marker:cont:ownerName")
                local interiorID = getElementData(v,"marker:cont:id")
                local doorState = getElementData(v,"marker:cont:locked")
                local location = "Los Santos"

                if doorState == 1 then doorState = true else doorState = false end

                local markX, markY, markZ = getElementPosition(v)
                location = getZoneName(markX, markY, markZ) or "Los Santos"

                table.insert(vagyon["interiors"], #vagyon["interiors"]+1, {interiorName, interiorID, doorState, location, "Konténer", getElementData(v, "marker:cont:renttime")})
            end 
        end
    end
end

function getPlayerSlots()
    vagyon["vehSlot"] = getElementData(localPlayer, "char:vehSlot")
    vagyon["intSlot"] = getElementData(localPlayer, "char:intSlot")
end

-- / farki panel / -- 
function setAllLeaderButtonStateToDefault()
    for k, v in ipairs(factionLeader_buttonPressNumbers) do 
        factionLeader_buttonPressNumbers[k] = 0
    end
end

local dutySkinPrev
function createDutySkinPreview()
    dutySkinPreviewModel = createPed(dutySkinPreviewModelID, 0, 0, 0)
    setElementDimension(dutySkinPreviewModel, getElementDimension(localPlayer))
    setElementInterior(dutySkinPreviewModel, getElementInterior(localPlayer))
    dutySkinPrev = preview:createObjectPreview(dutySkinPreviewModel, 0, 0, 180, sx*0.565, sy*0.55+sy*0.04, sx*0.1, sy*0.2, false, true)
end

function destroyDutySkinPreview() 
    if isElement(dutySkinPrev) then 
        preview:destroyObjectPreview(dutySkinPrev)
        destroyElement(dutySkinPreviewModel)
        dutySkinPreviewModel = false 
        dutySkinPrev = false
        dutySkinPreviewModelID = 0
    end
end

function getFactionVehicles()
    factionVehicles = {}

    for k, v in ipairs(getElementsByType("vehicle")) do 
        if getElementData(v, "veh:isFactionVehice") == 1 then 
            if getElementData(v, "veh:owner") == faction_datas.factions[selectedFactionLine] then 
                table.insert(factionVehicles, #factionVehicles+1, v)
            end
        end
    end
end

--- useful ---
function convertNumber(num, maxnull, color)
    local num = num or 0
    local actualNum = maxnull - string.len(tostring(num))
    local str = ""
             
    for i = 0, actualNum, 1 do
        str = str.."0"
    end

    if num == 0 then color = "" end
 
    return {str..num, str..color..num}
end

function tableContains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function tableContains2(table, element)
    for _, value in pairs(table) do
        if value[1] == element then
            return true
        end
    end
    return false
end
---------------------------

function tableSortRanks(a, b)
    if (a[2] and b[2]) then 
        if (a[2] > b[2]) then
            return true
        elseif (a[2] < b[2]) then
            return false
        end
    else
        return false 
    end
end
 
function comma_value(amount)
    local formatted = amount
    while true do  
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
      if (k==0) then
        break
      end
    end
    return formatted
end
 
function hexToRGB(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end