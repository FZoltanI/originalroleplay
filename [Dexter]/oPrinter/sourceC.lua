local screenX, screenY = guiGetScreenSize()
local panelW, panelH = 800, 500
local panelX, panelY = screenX/2 - panelW/2, screenY/2 - panelH/2
core = exports.oCore
color, r, g, b = core:getServerColor()

local font = dxCreateFont(":oAnims/Roboto.ttf", 14)
local myRenderTarget = dxCreateRenderTarget(600, 400, true)
paper = dxCreateTexture("paper.png")

local randomPosX = 0
local randomPosY = 0
local randomRotation = 0

local licenses = dxCreateTexture(":oLicenses/files/idcard.png")
local skin = dxCreateTexture(":oLicenses/files/avatars/1.png")
grayLicenses = dxCreateShader("blackwhite.fx")
grayLicenses2 = dxCreateShader("blackwhite.fx")
dxSetShaderValue(grayLicenses, "screenSource", licenses)
dxSetShaderValue(grayLicenses2, "screenSource", skin)

local cardCopyShowing = false

local fonts = {
    ["font-1"] = dxCreateFont(":oLicenses/files/SFUIText-Regular.ttf", 10),
    ["signature-1"] = dxCreateFont(":oLicenses/files/signature.ttf", 12),
}
local streamedPrinter = {}

addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),function()
    triggerServerEvent("requestPrinter", localPlayer)
    for k,v in ipairs(getElementsByType("object")) do 
        if getElementModel(v) == 2202 and getElementData(v, "object:isPrinter") then  
            streamedPrinter[v] = v
        end
    end
    
end)



addEventHandler( "onClientElementStreamIn", getRootElement(),
    function ( )
        if getElementType(source) == "object" and getElementModel(source) == 2202 and getElementData(source, "object:isPrinter") then 
            streamedPrinter[source] = source
        --    iprint(streamedPrinter)
        end
    end
)

addEventHandler( "onClientElementStreamOut", getRootElement(),
    function ( )
        if getElementType(source) == "object" and getElementModel(source) == 2202 and getElementData(source, "object:isPrinter") then 
            streamedPrinter[source] = nil
        end
    end
)

local renderTarget = dxCreateRenderTarget(200, 30)


addEventHandler("onClientRender", getRootElement(), function()

    


    local cameraPosX, cameraPosY, cameraPosZ = getCameraMatrix()
    local playerDimension = getElementDimension(localPlayer)
    for k,v in pairs(streamedPrinter) do 
        if isElement(v) and getElementData(v, "printer:isUsing") then
            local objectX, objectY, objectZ = getElementPosition(v)
            local objectDimension = getElementDimension(v)

            if objectDimension == playerDimension then
                setElementData(v, "printer:status", getElementData(v, "printer:status") + 0.5)
              --  if isLineOfSightClear(cameraPosX, cameraPosY, cameraPosZ, objectX, objectY, objectZ, true, false, false, true, false, false) then
                        
                    local screenPosX, screenPosY = getScreenFromWorldPosition(objectX, objectY+0.8, objectZ+1.8)
                    if screenPosX and screenPosY then
                        local distance = getDistanceBetweenPoints3D(cameraPosX, cameraPosY, cameraPosZ, objectX, objectY, objectZ)
                        if distance <= 8 then
                            local scaleFactor = 1 - distance / 16

                            local sx = 250 * 1 * scaleFactor
                            local sy = 30 * 1 * scaleFactor

                            local x = screenPosX - sx / 2
                            local y = screenPosY - sy / 2
                         --   dxDrawRectangle(x, y, sx, sy, tocolor(0, 0, 0, 200))
                           -- dxDrawRectangle(x-2, y-2, sx+4, sy+4, tocolor(0, 0, 0, 160))
                            --dxDrawRectangle(x, y, getElementData(v, "printer:status"), sy, tocolor(r, g, b, 160))
                           -- dxDrawText("Nyomtatás folyamatban", x, y, x + sx, y+sy,tocolor(255,255,255,255),0.65,font, "center", "center")
                        end
                    end
                --end
            end
        end
    end
end)


local selectedCard = {
    ["type"] = 1,
    ["name"] = "Fasz Janos",
    ["age"] = 0,
    ["sex"] = 1, 
    ["bornDate"] = "0000.00.00",
    ["createDate"] = "0000.00.00",
    ["expiryDate"] = "0000.00.00",
    ["nationality"] = "Amerikai",
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
}

cardOptions = {
    { -- Személyi
        {"Név", "name"},
        {"Életkor", "age"},
        {"Neme", "sex"}, --
        {"Állampolgárság", "nationality"}, 
        {"Kiállítás dátuma", "createDate"}, --
        {"Érvényes", "expiryDate"}, --
    },

    { -- Vezetői engedély
        {"Név", "name"},
        {"Életkor", "age"}, --
        {"Állampolgárság", "nationality"},
        {"Engedély típusa", "l_type"},
        {"Kiállítás dátuma", "createDate"}, -- 
        {"Érvényes", "expiryDate"}, --
    },

    { -- fegyvertartási engedély
        {"Név", "name"}, --
        {"Kiállító szerv", "faction"}, --
        {"Engedély", "l_type"},
        {"Kiállítás dátuma", "createDate"}, --
        {"Érvényes", "expiryDate"}, --
    },

    { -- vadászati engedély
        {"Név", "name"}, --
        {"Kiállító szerv", "faction"}, --
        {"Engedély", "l_type"},
        {"Kiállítás dátuma", "createDate"}, --
        {"Érvényes", "expiryDate"}, --
    },

    { -- forglami
        {"VEHICLE TYPE", "veh_type"},
        {"PLATE TEXT", "plate_text"},
        {"VEHICLE NAME", "vehicle_name"},
        {"COLOR", "vehicle_colors"},
        {"ENGINE TUNINGS", "engine_tunings"},
        {"OTHER TUNINGS", "other_tunings"},
        {"OWNER", "owner_name"},
        {"DATE OF EXPIRY", "expiry_date"},
    },
}

function drawCopyPaper()
    --if getPlayerSerial(localPlayer) == "8B23EC8A49888EB7A5778CE0AF7D88A2" then 
    if cardCopyShowing then
        dxSetBlendMode("modulate_add")
            dxDrawRectangle(panelX, panelY, panelW, panelH, tocolor(255, 255, 255,255))
            dxDrawImage(panelX + 210 + randomPosX, panelY+150+ randomPosY, 392, 210, grayLicenses, 0, 0, 0, tocolor(255, 255, 255, 150))
            local y = panelY + 150
            for k, v in ipairs(cardOptions[selectedCard["type"]]) do
                dxDrawText(v[1] .. ": " .. selectedCard[v[2]], panelX + 210 + 60+randomPosX, y+40+randomPosY, 0, 0, tocolor(255, 255, 255, 255), 1/1600*screenX, fonts["font-1"])
                y = y + 23
            end
            dxDrawRectangle(panelX + 270+randomPosX, panelY + 150 + 175+randomPosY, 230, 30,tocolor(0, 0, 0, 100))
            dxDrawText(selectedCard["name"], panelX + 270+randomPosX, panelY+150 + 180+randomPosY, panelX + 270 + 230+randomPosX, panelY + 150 + 180 + 25+randomPosY, tocolor(255,255,255, 255), 1/1600*screenX, fonts["signature-1"], "center", "center")
            dxDrawImage(panelX + 500 + randomPosX, panelY+200 + randomPosY, 100, 100, grayLicenses2)
           -- dxDrawRectangle(sx*0.56, sy*0.43, 100/myX*sx, 100/myY*sy, tocolor(40, 40, 40, 200))
            --dxDrawImage(sx*0.56, sy*0.43, 100/myX*sx, 100/myY*sy, "files/avatars/"..selectedCard["skin"]..".png")
           -- dxDrawImage(panelX + 210, panelY+150, 393, 500, grayLicenses, 0, 0, 0, tocolor(255, 255, 255, 255))
            dxDrawImage(panelX, panelY, panelW, panelH, paper)
        dxSetBlendMode("blend")
        --dxDrawRectangle()
    end
end




function openCopyCard(id, value, cardnumber)
    validValue = fromJSON(value)[1]
    if isElement(licenses) then 
        destroyElement(licenses) 
    end    
    if isElement(skin) then 
        destroyElement(skin) 
    end
    addEventHandler("onClientRender", getRootElement(), drawCopyPaper, true, "low-9999")
    if id == 209 and validValue[1] == 1 then 
        licenses = dxCreateTexture(":oLicenses/files/idcard.png")
        dxSetShaderValue(grayLicenses, "screenSource", licenses)
        selectedCard["type"] = 1
        selectedCard["createDate"] = string.sub(validValue[2],1,4).."."..string.sub(validValue[2],5,6).."."..string.sub(validValue[2],7,8)..". "
        selectedCard["expiryDate"] = string.sub(validValue[3],1,4).."."..string.sub(validValue[3],5,6).."."..string.sub(validValue[3],7,8)..". "
        selectedCard["skin"] = tonumber(validValue[4])
        if validValue[5] == 0 then 
            nem = "Nő"
        else
            nem = "Férfi"
        end
        selectedCard["sex"] = nem
        selectedCard["age"] = validValue[6]
        selectedCard["name"] = validValue[7]
        skin = dxCreateTexture(":oLicenses/files/avatars/"..selectedCard["skin"]..".png")
        dxSetShaderValue(grayLicenses2, "screenSource", skin)
    elseif id == 209 and validValue[1] == 2 then
        licenses = dxCreateTexture(":oLicenses/files/driving_license.png")
        dxSetShaderValue(grayLicenses, "screenSource", licenses)
        selectedCard["type"] = 2
        selectedCard["createDate"] = string.sub(validValue[2],1,4).."."..string.sub(validValue[2],5,6).."."..string.sub(validValue[2],7,8)..". "
        selectedCard["expiryDate"] = string.sub(validValue[3],1,4).."."..string.sub(validValue[3],5,6).."."..string.sub(validValue[3],7,8)..". "
        selectedCard["skin"] = tonumber(validValue[4])
        selectedCard["age"] = validValue[6]
        selectedCard["name"] = validValue[7]
        selectedCard["l_type"] = "B kategória"  
        skin = dxCreateTexture(":oLicenses/files/avatars/"..selectedCard["skin"]..".png")
        dxSetShaderValue(grayLicenses2, "screenSource", skin)  
    elseif id == 209 and validValue[1] == 3 then
        licenses = dxCreateTexture(":oLicenses/files/weapons_license.png")
        dxSetShaderValue(grayLicenses, "screenSource", licenses)
        selectedCard["type"] = 3
        selectedCard["createDate"] = string.sub(validValue[2],1,4).."."..string.sub(validValue[2],5,6).."."..string.sub(validValue[2],7,8)..". "
        selectedCard["expiryDate"] = string.sub(validValue[3],1,4).."."..string.sub(validValue[3],5,6).."."..string.sub(validValue[3],7,8)..". "
        selectedCard["skin"] = tonumber(validValue[4])
        selectedCard["name"] = validValue[7]
        selectedCard["l_type"] = "Colt-45/Shotgun"
        selectedCard["faction"] = "LSPD"    
        --outputChatBox(validValue[4])
        skin = dxCreateTexture(":oLicenses/files/avatars/"..selectedCard["skin"]..".png")
        dxSetShaderValue(grayLicenses2, "screenSource", skin)
    elseif id == 209 and validValue[1] == 4 then
        licenses = dxCreateTexture(":oLicenses/files/hunting_license.png")
        dxSetShaderValue(grayLicenses, "screenSource", licenses)
        selectedCard["type"] = 4
        selectedCard["createDate"] = string.sub(validValue[2],1,4).."."..string.sub(validValue[2],5,6).."."..string.sub(validValue[2],7,8)..". "
        selectedCard["expiryDate"] = string.sub(validValue[3],1,4).."."..string.sub(validValue[3],5,6).."."..string.sub(validValue[3],7,8)..". "
        selectedCard["skin"] = tonumber(validValue[4])
        selectedCard["name"] = validValue[7]
        selectedCard["l_type"] = "Róka/Medve"
        selectedCard["faction"] = "LSSD"
        skin = dxCreateTexture(":oLicenses/files/avatars/"..selectedCard["skin"]..".png")
        dxSetShaderValue(grayLicenses2, "screenSource", skin)
    end
    randomPosX = validValue[8]
    randomPosY = validValue[9]
    cardCopyShowing = true
    playSound(":oLicenses/files/license.wav")
end

function toggleCopyCard(id, value, itemid) 
    if cardCopyShowing then 
        closeCopyCard() 
        return false
    else
        openCopyCard(id, value, itemid) 
        return true
    end
end

function closeCopyCard()
    cardCopyShowing = false
    removeEventHandler("onClientRender", getRootElement(), drawCopyPaper, true, "low-9999")
    playSound(":oLicenses/files/license.wav")
end

addCommandHandler("asd", function()
    data = {1, 20210428, 20210430, 0, 2, 30, getPlayerName(localPlayer), math.random(-100,100),math.random(-80,80)}
    exports["oInventory"]:giveItem(209, toJSON({data}), 1, 0)
end)

