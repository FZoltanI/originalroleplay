local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oFont" or getResourceName(res) == "oInventory" or getResourceName(res) == "oInfobox" then
		preview = exports.oPreview
        core = exports.oCore
        color, r, g, b = core:getServerColor()
        font = exports.oFont
        inventory = exports.oInventory
        infobox = exports.oInfobox
	end
end)

function createLicensePeds()
    for k, v in pairs(peds) do
        local ped = createPed(v[5], v[3].x, v[3].y, v[3].z, v[4])
        setElementFrozen(ped, true)

        setElementData(ped, "isLicensesPed", true)

        setElementData(ped, "ped:name", v[1])
        setElementData(ped, "ped:prefix", v[2])
    end

    local ped = createPed(91, 1486.7756347656,-1778.3895263672,25.5234375, 90)
    setElementFrozen(ped, true)
    setElementData(ped, "isLicensesPed_2", true)
    setElementData(ped, "ped:name", "Laura White")
    setElementData(ped, "ped:prefix", "Személyi Igazolvány megújítása")
end
createLicensePeds()

local cardSize = 1
local cardX, cardY, cardW, cardH = 0.38, 0.385, (393/myX*sx)*cardSize, (210/myY*sy)*cardSize

local fonts = {
    ["font-1"] = dxCreateFont("files/SFUIText-Regular.ttf", 10),
    ["font-2"] = dxCreateFont("files/times.ttf", 10),
    ["signature-1"] = dxCreateFont("files/signature.ttf", 12),
}

local selectedCard = {
    ["type"] = 1,
    ["name"] = "nan",
    ["age"] = 0,
    ["sex"] = 1,
    ["bornDate"] = "0000.00.00",
    ["createDate"] = "0000.00.00",
    ["expiryDate"] = "0000.00.00",
    ["nationality"] = "Magyar",
    ["skin"] = 1,
    ["l_type"] = "nan",
    ["faction"] = "nan",
    ["cardnum"] = 0,


    -- Forgalmi
    ["veh_type"] = "Automobile",
    ["vehicle_name"] = "Ford Crown Victoria",
    ["plate_text"] = "25CBX36",
    ["vehicle_colors"] = "#00aaffCOLOR1 #000000COLOR2",
    ["engine_tunings"] = {1, 1, 1, 1, 1, 1, 1},
    ["other_tunings"] = "SPOILER, NEON",
    ["owner_name"] = "Carlos White",
    ["expiry_date"] = "2021.06.23",

		--horgászat
		["fishingarea"] = "Ocean,Rivers"
}

function dxDrawText2(text, x, y, w, h, ...)
    dxDrawText(text, x, y, x + w, y + h, ...)
end

function renderCard()
    if selectedCard["type"] == 1 then     -- Személyi
        dxDrawImage(sx*cardX, sy*cardY, cardW, cardH, "files/idcard.png")
    elseif selectedCard["type"] == 2 then -- Vezetői engedély
        dxDrawImage(sx*cardX, sy*cardY, cardW, cardH, "files/driving_license.png")
    elseif selectedCard["type"] == 3 then -- Fegyvertartási engedély
        dxDrawImage(sx*cardX, sy*cardY, cardW, cardH, "files/weapons_license.png")
    elseif selectedCard["type"] == 4 then -- Vadászati engedély
        dxDrawImage(sx*cardX, sy*cardY, cardW, cardH, "files/hunting_license.png")
    elseif selectedCard["type"] == 5 then -- forgalmi engedély
        dxDrawImage(sx/2 - 350/myX*sx /2, sy/2 - 420/myY*sy/2, 350/myX*sx, 420/myX*sx, "files/forgalmi.png")
	elseif selectedCard["type"] == 6 then -- horgász engedély
			dxDrawImage(sx*cardX, sy*cardY, cardW, cardH, "files/horgasz.png")
    end

    if not (selectedCard["type"] == 5) then
        local starty = sy*0.435
        for k, v in ipairs(cardOptions[selectedCard["type"]]) do
            if v[2] == "sex" then
                if selectedCard[v[2]] == 2 then
                    dxDrawText(v[1]..": "..colors[selectedCard["type"]].."Férfi", sx*0.415, starty, sx*0.415+sx*0.15, starty+sy*0.02, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["font-1"], "left", "center", false, false, false, true)
                elseif selectedCard[v[2]] == 1 then
                    dxDrawText(v[1]..": "..colors[selectedCard["type"]].."Nő", sx*0.415, starty, sx*0.415+sx*0.15, starty+sy*0.02, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["font-1"], "left", "center", false, false, false, true)
                end
            else
                dxDrawText(v[1]..": "..colors[selectedCard["type"]]..selectedCard[v[2]], sx*0.415, starty, sx*0.415+sx*0.15, starty+sy*0.02, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["font-1"], "left", "center", false, false, false, true)
            end

            starty = starty + sy*0.025
        end

        dxDrawRectangle(sx*0.415, sy*0.582, sx*0.15, sy*0.03, tocolor(40, 40, 40, 200))
        dxDrawText(selectedCard["name"], sx*0.415, sy*0.582, sx*0.415+sx*0.15, sy*0.582+sy*0.03, tocolor(53, 143, 232, 255), 1/myX*sx, fonts["signature-1"], "center", "center")

        dxDrawRectangle(sx*0.56, sy*0.43, 100/myX*sx, 100/myY*sy, tocolor(40, 40, 40, 200))
        dxDrawImage(sx*0.56, sy*0.43, 100/myX*sx, 100/myY*sy, "files/avatars/"..selectedCard["skin"]..".png")

        -- UPDATE V1.0.1
        --dxDrawText(colors[selectedCard["type"]].."#"..selectedCard["cardnum"], sx*0.56, sy*0.43, sx*0.56 + 100/myX*sx, sy*0.43 + 114/myY*sy, tocolor(53, 143, 232, 255), 0.9/myX*sx, fonts["font-1"], "center", "bottom", false, false, false, true)
    else
        local forgalmiX, forgalmiY = sx/2 - 350/myX*sx/2, sy/2 - 420/myY*sy/2
        --dxDrawRectangle(forgalmiX + sx*0.006, forgalmiY + sy*0.345, sx*0.1, sy*0.03, tocolor(255, 0, 0))
        --dxDrawRectangle(forgalmiX + sx*0.075, forgalmiY + sy*0.435, sx*0.1, sy*0.03, tocolor(255, 0, 0))
        if selectedCard["veh_type"] == "Automobile" then
            selectedCard["veh_type"] = "Gépjármű"
        end
        dxDrawText2((selectedCard["veh_type"]), forgalmiX + sx*0.01, forgalmiY + sy*0.065, sx*0.1, sy*0.03, tocolor(87, 53, 9, 180), 1/myX*sx, fonts["font-2"], "left", "center")
        dxDrawText2(string.upper(selectedCard["plate_text"]), forgalmiX + sx*0.15, forgalmiY + sy*0.065, sx*0.06, sy*0.03, tocolor(87, 53, 9, 180), 1/myX*sx, fonts["font-2"], "right", "center")
        dxDrawText2((selectedCard["vehicle_name"]), forgalmiX + sx*0.01, forgalmiY + sy*0.10, sx*0.1, sy*0.03, tocolor(87, 53, 9, 180), 1/myX*sx, fonts["font-2"], "left", "center")
        dxDrawText2((selectedCard["vehicle_colors"]), forgalmiX + sx*0.01, forgalmiY + sy*0.135, sx*0.1, sy*0.03, tocolor(87, 53, 9, 180), 1/myX*sx, fonts["font-2"], "left", "center", false, false, false, true)
        dxDrawText2((selectedCard["owner_name"]), forgalmiX + sx*0.01, forgalmiY + sy*0.17, sx*0.1, sy*0.03, tocolor(87, 53, 9, 180), 1/myX*sx, fonts["font-2"], "left", "center")

        -- Motortuningok
        local startX, startY = forgalmiX + sx*0.01, forgalmiY + sy*0.255
        for k, v in ipairs(engine_tunings) do
            dxDrawText2((v) .. ": "..selectedCard["engine_tunings"][k] .. "x", startX, startY, sx*0.1, sy*0.03, tocolor(87, 53, 9, 180), 1/myX*sx, fonts["font-2"], "left", "center")

            if k == 4 then
                startY = forgalmiY + sy*0.255
                startX = startX + sx*0.1
            else
                startY = startY + sy*0.0235
            end
        end

        dxDrawText2((selectedCard["other_tunings"]), forgalmiX + sx*0.01, forgalmiY + sy*0.39, sx*0.1, sy*0.03, tocolor(87, 53, 9, 180), 1/myX*sx, fonts["font-2"], "left", "center", false, false, false, true)

        dxDrawText2(string.upper(selectedCard["expiry_date"]), forgalmiX + sx*0.067, forgalmiY + sy*0.431, sx*0.1, sy*0.025, tocolor(87, 53, 9, 180), 0.9/myX*sx, fonts["font-2"], "left", "center")
    end
end

local PED3D
local cardShowing = false



function openCard(id, value, cardNumber)
    if id == 65 then -- Személyi (Felépítés 12341212 12341212  123 1 13 asasdasdasdasasdasd) -- create     lejárat  skin nem életkor név
        selectedCard["type"] = 1
        selectedCard["createDate"] = string.sub(value,1,4).."."..string.sub(value,5,6).."."..string.sub(value,7,8)..". "
        selectedCard["expiryDate"] = string.sub(value,9,12).."."..string.sub(value,13,14).."."..string.sub(value,15,16)..". "
        selectedCard["skin"] = tonumber(string.sub(value,17,19))
        selectedCard["sex"] = tonumber(string.sub(value,20,20))
        selectedCard["age"] = tonumber(string.sub(value,21,22))
        selectedCard["name"] = string.sub(value,23):gsub("_", " ")
    elseif id == 66 then -- Jogsi (Felépítés 12341212 12341212 123 32 asdasdadsadsd)  --       create   lejárat skin életkor name
        selectedCard["type"] = 2
        selectedCard["createDate"] = string.sub(value,1,4).."."..string.sub(value,5,6).."."..string.sub(value,7,8)..". "
        selectedCard["expiryDate"] = string.sub(value,9,12).."."..string.sub(value,13,14).."."..string.sub(value,15,16)..". "
        selectedCard["skin"] = tonumber(string.sub(value,17,19))
        selectedCard["age"] = tonumber(string.sub(value,20,21))
        selectedCard["name"] = string.sub(value,22):gsub("_", " ")
        selectedCard["l_type"] = "B kategória"
    elseif id == 68 then -- Fegvyertartási (felépítés 12341212 12341212 123 asdasdasdasd)  -- create   lejárat  skin     name
        selectedCard["type"] = 3
        selectedCard["createDate"] = string.sub(value,1,4).."."..string.sub(value,5,6).."."..string.sub(value,7,8)..". "
        selectedCard["expiryDate"] = string.sub(value,9,12).."."..string.sub(value,13,14).."."..string.sub(value,15,16)..". "
        selectedCard["skin"] = tonumber(string.sub(value,17,19))
        selectedCard["name"] = string.sub(value,20):gsub("_", " ")
        selectedCard["l_type"] = "Colt-45/Shotgun"
        selectedCard["faction"] = "LSPD"
    elseif id == 79 then -- Vadászati engedély (felépítés 12341212 12341212 123 asdasdasdasd)  -- create   lejárat  skin     name
        selectedCard["type"] = 4
        selectedCard["createDate"] = string.sub(value,1,4).."."..string.sub(value,5,6).."."..string.sub(value,7,8)..". "
        selectedCard["expiryDate"] = string.sub(value,9,12).."."..string.sub(value,13,14).."."..string.sub(value,15,16)..". "
        selectedCard["skin"] = tonumber(string.sub(value,17,19))
        selectedCard["name"] = string.sub(value,20):gsub("_", " ")
        selectedCard["l_type"] = "Róka/Medve"
        selectedCard["faction"] = "LSSD"
    elseif id == 206 then -- FORGALMI ENGEDÉLY FELÉPÍTÉS (12 12 1 12 asdasdadsadsa adsadsadsadsa asdasdasdasd asdasd asdasd 1 1 1 1 1 1 1 12345678, asdasdasdasdasdasdad) -- veh type hossz, veh name hossz, plate text hossz, other tuning hossz, | veh type, veh name, plate text, color1, color2, tuning, tuning, tuning, tuning, tuning, tuning, tuning, egyéb tuningok, expiry date, owner name
        selectedCard["type"] = 5

        local vehTypeLength =  tonumber(string.sub(value,1,2)) - 1
        local vehNameLength =  tonumber(string.sub(value,3,4)) - 1
        local vehPlateTextLengt = tonumber(string.sub(value,5,5)) - 1
        local vehOtherTuningLength = tonumber(string.sub(value,6,7)) -1

        local nextStart = 8
        selectedCard["veh_type"] = string.sub(value,nextStart,nextStart+vehTypeLength)
        nextStart = nextStart + vehTypeLength + 1

        selectedCard["vehicle_name"] = string.sub(value,nextStart,nextStart+vehNameLength)
        nextStart = nextStart + vehNameLength + 1

        selectedCard["plate_text"] = string.sub(value,nextStart,nextStart+vehPlateTextLengt)
        nextStart = nextStart + vehPlateTextLengt + 1

        selectedCard["vehicle_colors"] = "#"..string.sub(value,nextStart,nextStart+5).."Szín 1 #"..string.sub(value,nextStart+6,nextStart+11).."Szín 2"
        nextStart = nextStart + 12

        selectedCard["engine_tunings"] = {string.sub(value,nextStart,nextStart), string.sub(value,nextStart + 1,nextStart + 1), string.sub(value,nextStart + 2,nextStart + 2), string.sub(value,nextStart + 3,nextStart + 3), string.sub(value,nextStart + 4,nextStart + 4), string.sub(value,nextStart + 5,nextStart + 5), string.sub(value,nextStart + 6,nextStart + 6)}
        nextStart = nextStart + 7

        selectedCard["other_tunings"] = string.sub(value,nextStart,nextStart+vehOtherTuningLength)
        nextStart = nextStart + vehOtherTuningLength + 1

        selectedCard["expiry_date"] = string.sub(value,nextStart,nextStart+3).."."..string.sub(value,nextStart+4,nextStart+5).."."..string.sub(value,nextStart+6,nextStart+7)..". "
        nextStart = nextStart + 8

        selectedCard["owner_name"] = string.sub(value,nextStart):gsub("_", " ")
		elseif id == 146 then -- Horgász engedély (Felépítés 12341212 12341212  123 1 13 asasdasdasdasasdasd) -- create     lejárat  skin nem életkor név
				selectedCard["type"] = 6
				selectedCard["createDate"] = string.sub(value,1,4).."."..string.sub(value,5,6).."."..string.sub(value,7,8)..". "
				selectedCard["expiryDate"] = string.sub(value,9,12).."."..string.sub(value,13,14).."."..string.sub(value,15,16)..". "
				selectedCard["skin"] = tonumber(string.sub(value,17,19))
				selectedCard["faction"] = "LSFG"
				selectedCard["age"] = tonumber(string.sub(value,21,22))
				selectedCard["name"] = string.sub(value,23):gsub("_", " ")
    end
    selectedCard["cardnum"] = cardNumber

    cardShowing = true

    addEventHandler("onClientRender", root, renderCard)
    playSound("files/license.wav")
end


function closeCard()
    cardShowing = false
    removeEventHandler("onClientRender", root, renderCard)
    playSound("files/license.wav")
end

function toggleCard(id, value, itemid)
    if cardShowing then
        closeCard()
        return false
    else
        openCard(id, value, itemid)
        return true
    end
end

function playerHasValidLicense(licenseID)
    if exports.oInventory:hasItem(licenseID) then
        local has, item = exports.oInventory:hasItem(licenseID)
        if item.value then
            local value = item.value
            local checkedCard = {}

            if item.item == 65 then -- Személyi (Felépítés 12341212 12341212  123 1 13 asasdasdasdasasdasd) -- create     lejárat  skin nem életkor név
                checkedCard["expiryDate"] = {string.sub(value,9,12), string.sub(value,13,14), string.sub(value,15,16)}
                checkedCard["skin"] = tonumber(string.sub(value,17,19))
                checkedCard["name"] = string.sub(value,23):gsub("_", " ")
            elseif item.item == 66 then -- Jogsi (Felépítés 12341212 12341212 123 32 asdasdadsadsd)  --       create   lejárat skin életkor name
            --    print("josi")
                checkedCard["expiryDate"] = {string.sub(value,9,12), string.sub(value,13,14), string.sub(value,15,16)}
                checkedCard["skin"] = tonumber(string.sub(value,17,19))
                checkedCard["name"] = string.sub(value,22):gsub("_", " ")
            elseif item.item == 68 then -- Fegvyertartási (felépítés 12341212 12341212 123 asdasdasdasd)  -- create   lejárat  skin     name
                checkedCard["expiryDate"] = {string.sub(value,9,12), string.sub(value,13,14), string.sub(value,15,16)}
                checkedCard["skin"] = tonumber(string.sub(value,17,19))
                checkedCard["name"] = string.sub(value,20):gsub("_", " ")
            elseif item.item == 79 then -- Vadászati engedély (felépítés 12341212 12341212 123 asdasdasdasd)  -- create   lejárat  skin     name
                checkedCard["expiryDate"] = {string.sub(value,9,12), string.sub(value,13,14), string.sub(value,15,16)}
                checkedCard["skin"] = tonumber(string.sub(value,17,19))
                checkedCard["name"] = string.sub(value,20):gsub("_", " ")
						elseif item.item == 146 then -- Horgász engedély (Felépítés 12341212 12341212  123 1 13 asasdasdasdasasdasd) -- create     lejárat  skin nem életkor név
								checkedCard["expiryDate"] = {string.sub(value,9,12), string.sub(value,13,14), string.sub(value,15,16)}
								checkedCard["skin"] = tonumber(string.sub(value,17,19))
								checkedCard["name"] = string.sub(value,23):gsub("_", " ")
            end

            if (getElementData(localPlayer,"char:name"):gsub("_", " ") == checkedCard["name"]) then
                --if checkedCard["skin"] == getElementModel(localPlayer) then
                    local year, month, day = core:getDate("year"), core:getDate("month"), core:getDate("monthday")
                    --print("Jelenlegi", year, month, day)
                    --print("Lejárati", tonumber(checkedCard["expiryDate"][1]), tonumber(checkedCard["expiryDate"][2]), tonumber(checkedCard["expiryDate"][3]))

                    if tonumber(checkedCard["expiryDate"][1]) >= tonumber(year) then
                        if tonumber(checkedCard["expiryDate"][1]) > tonumber(year) then
                            return true
                        end

                        if tonumber(checkedCard["expiryDate"][2]) >= tonumber(month) then
                            if tonumber(checkedCard["expiryDate"][2]) > tonumber(month) then
                                return true
                            end

                            if tonumber(checkedCard["expiryDate"][3]) >= tonumber(day) then
                                return true
                            else
                                return false
                            end
                        else
                            return false
                        end
                    else
                        return false
                    end
            else
                return false
            end
        end
    end
end

--[[local file = fileCreate("asd.txt")
local text = ""

local skins = getValidPedModels ( )
for k, v in ipairs(skins) do
    text = text .. ' <file src = "files/avatars/'..v..'.png" /> '
end
fileWrite(file, text)
fileClose(file)]]
