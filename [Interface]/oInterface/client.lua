local sx,sy = guiGetScreenSize()
local myX,myY = 1600, 900 

---[ Változók ]---
local moveNowId = 0
local sizeingNowId = 0
local sizeingNowType = "width"
local clickX, clickY = 0,0

local isHudEditing = false

local logoAlpha = 0
local logoAnimTick = getTickCount()

local font = dxCreateFont("files/font.ttf", 13)

local interfaceAlpha = 0
local interfaceTick = getTickCount()
local interfaceAnimType = 1
local bgCloseTimer = false
local backgorundShowAnimTime = 500

local toghud = false

local showPanel_addInterfaceElement = false
local nonRenderedElements = {}

local _dxDrawImage = dxDrawImage
local textures = {}

local textureName = {"arrow", "bin", "logo1", "minus", "plus", "reset", "sotet"}

local function dxDrawImage(x, y, w, h, image, rot, rotX, rotY, color)
    if type(image) == "string" then 
        image = textures[image]
    end
    _dxDrawImage(x, y, w, h, image, rot, rotX, rotY, color)
end


local settingsTable = {
    ["hudType"] = 1
}

------------------

function getInterfaceSettings(settingValue)
    return settingsTable[settingValue]
end

addEventHandler("onClientResourceStart", root, function(res)
    if getResourceName(res) == "oCore" or getResourceName(res) == "oInterface" then  
        core = exports.oCore
        color, r, g, b = core:getServerColor()
        serverName = core:getServerName()     
    end
    
    exports.oInventory:bindActionbarSlots()
    for k,v in pairs(textureName) do 
        if not textures["files/".. v..".png"] then 
            textures["files/".. v..".png"] = dxCreateTexture("files/".. v..".png", "dxt5", true)
        end
    end
end)

addEventHandler("onClientElementDataChange", root, function(data, old, new)
    if source == localPlayer then
        if data == "user:loggedin" then 
            exports.oInventory:bindActionbarSlots()
        end
    end
end)

setPlayerHudComponentVisible("all", false)
setPlayerHudComponentVisible("crosshair", true)

function renderHudeditorBg()
    if interfaceAnimType == 1 then 
        interfaceAlpha = interpolateBetween(0,0,0,1,0,0,(getTickCount()-interfaceTick)/backgorundShowAnimTime, "Linear")
    else
        interfaceAlpha = interpolateBetween(1,0,0,0,0,0,(getTickCount()-interfaceTick)/backgorundShowAnimTime, "Linear")
    end
   -- outputChatBox("a")
    dxDrawRectangle(0,0,sx,sy,tocolor(30,30,30,200*interfaceAlpha))
    dxDrawImage(0,0,sx,sy,"files/sotet.png",0,0,0,tocolor(30,30,30,255*interfaceAlpha))
end

function renderHudEditor() 
    setCursorAlpha(255)
    if not isCursorShowing() then 
        togHudEditing()
    end

    logoAlpha = interpolateBetween(0,0,0,1,0,0,(getTickCount()-logoAnimTick)/3500,"CosineCurve")

    dxDrawImage(0,0,sx,sy,"files/logo1.png",0,0,0,tocolor(225,255,255,150*logoAlpha))

    if core:isInSlot(sx*0.005,sy*0.01,sx*0.13,sy*0.04) then 
        dxDrawImage(sx*0.005,sy*0.01,35/myX*sx,35/myY*sy,"files/reset.png",0,0,0,tocolor(blueR, blueG, blueB,255))
        dxDrawText("Interface visszaállítása", sx*0.03,sy*0.02,sx*0.03+sx*0.1,sy*0.02+sy*0.02, tocolor(blueR, blueG, blueB,255),0.8/myX*sx,font,"left","center")
    else
        dxDrawImage(sx*0.005,sy*0.01,35/myX*sx,35/myY*sy,"files/reset.png",0,0,0,tocolor(220,220,220,255))
        dxDrawText("Interface visszaállítása", sx*0.03,sy*0.02,sx*0.03+sx*0.1,sy*0.02+sy*0.02, tocolor(220,220,220,255),0.8/myX*sx,font,"left","center")
    end

    if core:isInSlot(sx*0.005,sy*0.055,sx*0.13,sy*0.04) then 
        dxDrawImage(sx*0.005,sy*0.055,35/myX*sx,35/myY*sy,"files/plus.png",0,0,0,tocolor(greenR, greenG, greenB ,255))
        dxDrawText("Interface elem hozzáadása", sx*0.03,sy*0.065,sx*0.03+sx*0.1,sy*0.065+sy*0.02, tocolor(greenR, greenG, greenB ,255),0.8/myX*sx,font,"left","center")
    else
        dxDrawImage(sx*0.005,sy*0.055,35/myX*sx,35/myY*sy,"files/plus.png",0,0,0,tocolor(220,220,220,255))
        dxDrawText("Interface elem hozzáadása", sx*0.03,sy*0.065,sx*0.03+sx*0.1,sy*0.065+sy*0.02, tocolor(220,220,220,255),0.8/myX*sx,font,"left","center")
    end

    for k,v in ipairs(widgets) do 

        if v[7] then 

            if moveNowId == k then 
                if v[1] == "Actionbar" then 
                    dxDrawRectangle(sx*v[2],sy*v[3],sx*(v[4]*actionBarSlotCount),sy*v[5],tocolor(r,g,b,100))
                else
                    dxDrawRectangle(sx*v[2],sy*v[3],sx*v[4],sy*v[5],tocolor(r,g,b,100))
                end
            else 
                if v[1] == "Actionbar" then 
                    dxDrawRectangle(sx*v[2],sy*v[3],sx*(v[4]*actionBarSlotCount),sy*v[5],tocolor(30,30,30,200))
                else
                    dxDrawRectangle(sx*v[2],sy*v[3],sx*v[4],sy*v[5],tocolor(30,30,30,200))
                end
            end


            if v[1] == "Actionbar" then 
                if actionBarSlotCount >= 3 then 
                    dxDrawText(v[1],sx*v[2],sy*v[3],sx*v[2]+sx*v[4]*actionBarSlotCount,sy*v[3]+sy*v[5],tocolor(220,220,220,255),1/myX*sx,font,"center","center")
                end
            else
                dxDrawText(v[1],sx*v[2],sy*v[3],sx*v[2]+sx*v[4],sy*v[3]+sy*v[5],tocolor(220,220,220,255),1/myX*sx,font,"center","center")
            end

            if core:isInSlot(sx*v[2]+sx*0.003,sy*v[3]+sy*0.003,20/myX*sx,20/myY*sy) then 
                dxDrawImage(sx*v[2]+sx*0.003,sy*v[3]+sy*0.003,20/myX*sx,20/myY*sy,"files/reset.png",0,0,0,tocolor(blueR, blueG, blueB,255), true)
            else
                dxDrawImage(sx*v[2]+sx*0.003,sy*v[3]+sy*0.003,20/myX*sx,20/myY*sy,"files/reset.png",0,0,0,tocolor(220,220,220,255), true)
            end

            if v[8] then 
                if core:isInSlot(sx*v[2]+sx*0.003+20/myX*sx,sy*v[3]+sy*0.003,20/myX*sx,20/myY*sy) then 
                    dxDrawImage(sx*v[2]+sx*0.003+20/myX*sx,sy*v[3]+sy*0.003,20/myX*sx,20/myY*sy,"files/bin.png",0,0,0,tocolor(redR, redG, redB,255), true)
                else
                    dxDrawImage(sx*v[2]+sx*0.003+20/myX*sx,sy*v[3]+sy*0.003,20/myX*sx,20/myY*sy,"files/bin.png",0,0,0,tocolor(220,220,220,255), true)
                end
            end


            if v[1] == "Actionbar" then  -- Actionbar slot +/- és forgatás
                if core:isInSlot(sx*v[2]+sx*v[4]*actionBarSlotCount,sy*v[3]+sy*0.001,12/myX*sx,12/myY*sy) then 
                    dxDrawImage(sx*v[2]+sx*v[4]*actionBarSlotCount,sy*v[3]+sy*0.001,12/myX*sx,12/myY*sy,"files/plus.png",0,0,0,tocolor(blueR, blueG, blueB,255))
                else
                    dxDrawImage(sx*v[2]+sx*v[4]*actionBarSlotCount,sy*v[3]+sy*0.001,12/myX*sx,12/myY*sy,"files/plus.png",0,0,0,tocolor(220,220,220,255))
                end

                if core:isInSlot(sx*v[2]+sx*v[4]*actionBarSlotCount,sy*v[3]+sy*0.001+12/myY*sy,12/myX*sx,12/myY*sy) then 
                    dxDrawImage(sx*v[2]+sx*v[4]*actionBarSlotCount,sy*v[3]+sy*0.001+12/myY*sy,12/myX*sx,12/myY*sy,"files/minus.png",0,0,0,tocolor(blueR, blueG, blueB,255))
                else
                    dxDrawImage(sx*v[2]+sx*v[4]*actionBarSlotCount,sy*v[3]+sy*0.001+12/myY*sy,12/myX*sx,12/myY*sy,"files/minus.png",0,0,0,tocolor(220,220,220,255))
                end
            end

            if v[6] then 
                if core:isInSlot(sx*v[2]+sx*v[4]-sx*0.01,sy*v[3],sx*0.01,sy*v[5]) then 
                    setCursorAlpha(0)

                    local cx, cy = getCursorPosition() 
                    dxDrawImage(sx*cx,sy*cy,20/myX*sx,20/myY*sy,"files/arrow.png",0,0,0,tocolor(220,220,220,255))
                end

                if core:isInSlot(sx*v[2],sy*v[3]+sy*v[5]-sy*0.02,sx*v[4],sy*0.02) then 
                    if not v[14] then
                        setCursorAlpha(0)

                        local cx, cy = getCursorPosition() 
                        dxDrawImage(sx*cx,sy*cy,20/myX*sx,20/myY*sy,"files/arrow.png",90,0,0,tocolor(220,220,220,255))
                    end
                end
            end

            if k == moveNowId then 
                local cX, cY = getCursorPosition()
                cX, cY = cX-clickX, cY-clickY
                v[2] = cX 
                v[3] = cY

            end

            if k == sizeingNowId then 
                if core:isInSlot(sx*v[2],sy*v[3],sx*v[4]+sx*0.05,sy*v[5]+sy*0.05) then 
                    if sizeingNowType == "width" then 
                        local cX, cY = getCursorPosition()
                        if (cX - clickX) <= v[9] and (cX - clickX) >= v[11] then 
                            v[4] = (cX - clickX)
                        end
                    elseif sizeingNowType == "height" then 
                        local cX, cY = getCursorPosition()
                        if (cY - clickY) <= v[10] and (cY - clickY) >= v[12] then 
                            v[5] = (cY - clickY)
                        end
                    end
                else
                    sizeingNowId = 0
                end
            end
        end
    end

    if showPanel_addInterfaceElement then 
        dxDrawRectangle(sx*0.005, sy*0.105, sx*0.13, ((sy*0.035)*#nonRenderedElements), tocolor(40, 40, 40, 255))

        local starty = sy*0.107
        for i = 1, #nonRenderedElements do 
            if nonRenderedElements[i] then 
                if core:isInSlot(sx*0.006, starty, sx*0.128, sy*0.03) then 
                    dxDrawRectangle(sx*0.006, starty, sx*0.128, sy*0.03, tocolor(r, g, b, 180))
                else
                    dxDrawRectangle(sx*0.006, starty, sx*0.128, sy*0.03, tocolor(35, 35, 35, 255))
                end
                dxDrawText(widgets[nonRenderedElements[i]][1], sx*0.006, starty, sx*0.006+sx*0.128, starty+sy*0.03, tocolor(220, 220, 220, 255), 0.8/myX*sx, font, "center", "center", false, true)
            end
            starty = starty + sy*0.035
        end
    end
end

function keyPress(key,state)
    if key == "mouse1" then
        if state then 

            if core:isInSlot(sx*0.005,sy*0.01,sx*0.13,sy*0.04) then 
                resethud()
            end

            if core:isInSlot(sx*0.005,sy*0.055,sx*0.13,sy*0.04) then 
                showPanel_addInterfaceElement = not showPanel_addInterfaceElement
            end

            if showPanel_addInterfaceElement then 
                local starty = sy*0.107
                for i = 1, #nonRenderedElements do 
                    if nonRenderedElements[i] then 
                        if core:isInSlot(sx*0.006, starty, sx*0.128, sy*0.03) then 
                            if widgets[nonRenderedElements[i]][1] == "HP" or widgets[nonRenderedElements[i]][1] == "Armor" or widgets[nonRenderedElements[i]][1] == "Étel/Ital" or widgets[nonRenderedElements[i]][1] == "Stamina" and exports["oHud"]:getHudType() == 2 then 
                                exports.oInfobox:outputInfoBox('A Hud 2 van kiválasztva előbb zárd be!','error')
                                --outputChatBox(core:getServerPrefix("server", "Interface", 3).."A Hud 2 van kiválasztva előbb zárd be!",255,255,255,true)
                                return
                            end
                            widgets[nonRenderedElements[i]][7] = true
                            --outputChatBox()
                            if widgets[nonRenderedElements[i]][1] == "Hud 2" then 
                                exports["oHud"]:setHudType(2)
                            end
                            getNonRenderedElements()
                            break
                        end
                    end
                    starty = starty + sy*0.035
                end
            end

            for k,v in ipairs(widgets) do 

                if v[7] then 

                    if v[6] then 
                        if core:isInSlot(sx*v[2]+sx*v[4]-sx*0.01,sy*v[3],sx*0.01,sy*v[5]) then 
                            sizeingNowId = k
                            sizeingNowType = "width"
                            clickX, clickY = getCursorPosition()
                            clickX = clickX - v[4]
                            clickY = clickY - v[5] 

                            return
                        end

                        if core:isInSlot(sx*v[2],sy*v[3]+sy*v[5]-sy*0.02,sx*v[4],sy*0.02) then 
                            if not v[14] then
                                sizeingNowId = k
                                sizeingNowType = "height"
                                clickX, clickY = getCursorPosition()
                                clickX = clickX - v[4]
                                clickY = clickY - v[5] 

                                return
                            end
                        end
                    end
                    
                    if core:isInSlot(sx*v[2]+sx*0.003,sy*v[3]+sy*0.003,20/myX*sx,20/myY*sy) then 
                        local fileDefault = fileOpen("widgets_default.json")
                        local file_size = fileGetSize(fileDefault) or 0
                        data = fromJSON(fileRead(fileDefault, file_size))
                        fileClose(fileDefault)
                        widgets[k] = data[k]

                        if not data[k][7] then 
                            widgets[k][7] = true 
                        end 

                        getNonRenderedElements()
                        --outputChatBox(defaultWidgets[k][2])
                        return
                    end

                    if core:isInSlot(sx*v[2]+sx*0.003+20/myX*sx,sy*v[3]+sy*0.003,20/myX*sx,20/myY*sy) then 
                        if v[8] then 
                            if v[1] == "Hud 2" then 
                                exports["oHud"]:setHudType(1)
                            end
                            v[7] = false
                            table.insert(nonRenderedElements, #nonRenderedElements+1, k)
                            --getNonRenderedElements()
                            return
                        end
                    end

                    if v[1] == "Actionbar" then  -- Actionbar slot +/- és forgatás
                        if core:isInSlot(sx*v[2]+sx*v[4]*actionBarSlotCount,sy*v[3]+sy*0.001,12/myX*sx,12/myY*sy) then -- +
                            if actionBarSlotCount < 9 then 
                                actionBarSlotCount = actionBarSlotCount + 1
                                --triggerEvent("inv > bindActionbarSlots")
                                --outputChatBox("bindelni kellene")
                                exports.oInventory:bindActionbarSlots()
                            end
                        end
            
                        if core:isInSlot(sx*v[2]+sx*v[4]*actionBarSlotCount,sy*v[3]+sy*0.001+12/myY*sy,12/myX*sx,12/myY*sy) then  -- -
                            if actionBarSlotCount > 1 then 
                                actionBarSlotCount = actionBarSlotCount - 1
                                --triggerEvent("inv > bindActionbarSlots")
                                --outputChatBox("bindelni kellene")
                                exports.oInventory:bindActionbarSlots()
                            end
                        end
                    end

                    if v[1] == "Actionbar" then
                        if core:isInSlot(sx*v[2],sy*v[3],sx*v[4]*actionBarSlotCount,sy*v[5]) then 
                            clickX, clickY = getCursorPosition()
                            clickX = clickX - (v[2])
                            clickY = clickY - (v[3]) 
                            moveNowId = k
                        end
                    else
                        if core:isInSlot(sx*v[2],sy*v[3],sx*v[4],sy*v[5]) then 
                            clickX, clickY = getCursorPosition()
                            clickX = clickX - (v[2])
                            clickY = clickY - (v[3]) 
                            moveNowId = k
                        end
                    end
                end
            end
        else
            moveNowId = 0
            sizeingNowId = 0
        end
    end
end

function resethud()
    moveNowId = 0
    sizeingNowId = 0
    actionBarSlotCount = 6
    local fileDefault = fileOpen("widgets_default.json")
    local file_size = fileGetSize(fileDefault) or 0
    widgets = fromJSON(fileRead(fileDefault, file_size))
    fileClose(fileDefault)
    outputChatBox(core:getServerPrefix("server", "Interface", 3).."Alaphelyzetbe állítottad az interfacet!",255,255,255,true)
    getNonRenderedElements()
end
addCommandHandler("resethud",resethud)
addCommandHandler("hudreset",resethud)

function toggleHud(state)
    if not state then 
        toghud = not toghud
    else
        toghud = state
    end
end

addCommandHandler("toghud", function()
    toghud = not toghud
    showChat(not isChatVisible())
end)

bindKey("F1", "up", function()
    toghud = not toghud
    showChat(not isChatVisible())
end)

function getInterfaceElementData(id, data) 
    local dataNeed = 1 

    if data == "name" then 
        dataNeed = 1 
    elseif data == "posX" then 
        dataNeed = 2 
    elseif data == "posY" then 
        dataNeed = 3
    elseif data == "width" then 
        dataNeed = 4
    elseif data == "height" then 
        dataNeed = 5 
    elseif data == "showing" then 
        dataNeed = 7
    end 

    if widgets[id] then 
        if data == "showing" then 
            if toghud or not getElementData(localPlayer, "user:loggedin") then 
                return false 
            else 
                return widgets[id][dataNeed] 
            end
        else
            return widgets[id][dataNeed]
        end
    else
        return outputDebugString("Nincs lekérhető adat. (Id:"..id.."; DataName:"..data..")",1)
    end
end

function setInterfaceElementData(id, data, value)
    local dataNeed = 1 

    if data == "name" then 
        dataNeed = 1 
    elseif data == "posX" then 
        dataNeed = 2 
    elseif data == "posY" then 
        dataNeed = 3
    elseif data == "width" then 
        dataNeed = 4
    elseif data == "height" then 
        dataNeed = 5 
    elseif data == "showing" then 
        dataNeed = 7
    end 
    if widgets[id] then 
        
        if data == "showing" then 
            if toghud or not getElementData(localPlayer, "user:loggedin") then 
                return false 
            else 
                widgets[id][dataNeed] = value 
                getNonRenderedElements()
            end
        else
            widgets[id][dataNeed] = value 
            getNonRenderedElements()
            
        end
    else
        return outputDebugString("Nincs lekérhető adat. (Id:"..id.."; DataName:"..data..")",1)
    end
end

function getActionBarSlotCount()
    return actionBarSlotCount
end

function getNonRenderedElements()
    nonRenderedElements = {}
    for k, v in ipairs(widgets) do 
        if not v[7] then 
            table.insert(nonRenderedElements, #nonRenderedElements+1, k)
        end
    end
end

function saveAllWidget()
    local file
    if fileExists("widgets.json") then 
        file = fileOpen("widgets.json")
    else
        file = fileCreate("widgets.json")

    end

    fileWrite(file, toJSON(widgets))
    fileClose(file)

    local file_actionbar
    if fileExists("actionbar.json") then 
        file_actionbar = fileOpen("actionbar.json")
    else
        file_actionbar = fileCreate("actionbar.json")
    end

    fileWrite(file_actionbar, toJSON(actionBarSlotCount))
    fileClose(file_actionbar)

    local file_settings
    if fileExists("settings.json") then
        file_settings = fileOpen("settings.json")
    else
        file_settings = fileCreate("settings.json")
    end
    fileWrite(file_settings, toJSON(settingsTable))
    fileClose(file_settings)
end
addEventHandler( "onClientResourceStop", resourceRoot,saveAllWidget)

function loadAllWidget()
    if fileExists("widgets_default.json") then 
        local default_file = fileOpen("widgets_default.json")
        fileWrite(default_file, toJSON(defaultWidgets))
        fileClose(default_file)
    else 
        local default_file = fileCreate("widgets_default.json") 

        fileWrite(default_file, toJSON(defaultWidgets))
        fileClose(default_file)
    end

    if fileExists("widgets.json") then 
        local file = fileOpen("widgets.json")
        local file_size = fileGetSize(file) or 0

        local file_data = fileRead(file, file_size) 
        widgets = fromJSON(file_data)
        fileClose(file)
    else
        local fileDefault = fileOpen("widgets_default.json")
        local file_size = fileGetSize(fileDefault) or 0
        widgets = fromJSON(fileRead(fileDefault, file_size))
        fileClose(fileDefault)
    end

    if not (#widgets == #defaultWidgets) then 
        for k, v in ipairs(defaultWidgets) do 
            if not widgets[k] then 
                table.insert(widgets, k, v)
            end
        end
    end

    local file_actionbar
    if fileExists("actionbar.json") then 
        file_actionbar = fileOpen("actionbar.json")   
        local file_size = fileGetSize(file_actionbar) or 0
        actionBarSlotCount = fromJSON(fileRead(file_actionbar, file_size))
        fileClose(file_actionbar) 
    end    
    
    local file_settings
    if fileExists("settings.json") then 
        file_settings = fileOpen("settings.json")   
        local file_size = fileGetSize(file_settings) or 0
        settingsValue = fromJSON(fileRead(file_settings, file_size))
        
        fileClose(file_settings) 
    end

    for k,v in pairs(settingsValue) do 
        settingsTable[k] = v
    end

end
addEventHandler( "onClientResourceStart", resourceRoot,loadAllWidget)

function togHudEditing()
    moveNowId = 0
    if isHudEditing then 
        isHudEditing = false 
        removeEventHandler("onClientKey",root,keyPress)
        removeEventHandler("onClientRender", root, renderHudEditor)
        bgCloseTimer = setTimer(function() 
            removeEventHandler("onClientHUDRender", root, renderHudeditorBg)
        end, backgorundShowAnimTime, 1)
        showChat(true)
        interfaceTick = getTickCount()
        interfaceAnimType = 2
        setCursorAlpha(255)
    else 
        getNonRenderedElements()
        if isTimer(bgCloseTimer) then 
            killTimer(bgCloseTimer)
            removeEventHandler("onClientHUDRender", root, renderHudeditorBg)
            bgCloseTimer = false
        end
        addEventHandler("onClientKey",root,keyPress)
        addEventHandler("onClientRender", root, renderHudEditor)
        addEventHandler("onClientHUDRender", root, renderHudeditorBg)
        showChat(false)
        isHudEditing = true
        logoAnimTick = getTickCount()
        interfaceTick = getTickCount()
        interfaceAnimType = 1
    end
end

addEventHandler("onClientKey", root, function(key, state) 
    if getElementData(localPlayer, "user:loggedin") then 
        if isCursorShowing() then 
            if key == "lctrl" then 
                togHudEditing()
            end
        end
    end
end)
