local sx, sy = guiGetScreenSize() 
local myX, myY = 1600, 900

--sx, sy = 1360, 768

local page = 1

local factions = {
    ---- Id, Név, Típus, Engedélyezett dutyskinek, Engedélyezett dutyitemek, dutyk, játékosok, járművek, ranks, frakció számla, létrehozás dátuma
}

local renderedList = {}

local fonts = {
    ["condensed-11"] = font:getFont("condensed",11),
    ["condensed-12"] = font:getFont("condensed",12),
    ["condensed-14"] = font:getFont("condensed",14),
}

local textures = {
    ["logo"] = dxCreateTexture("files/logo.png"),

    ["faction-icon-1"] = dxCreateTexture("files/faction_icons/1.png"),
    ["faction-icon-2"] = dxCreateTexture("files/faction_icons/2.png"),
    ["faction-icon-3"] = dxCreateTexture("files/faction_icons/3.png"),
    ["faction-icon-4"] = dxCreateTexture("files/faction_icons/4.png"),
    ["faction-icon-5"] = dxCreateTexture("files/faction_icons/5.png"),

    ["more-icon-1"] = dxCreateTexture("files/admin_panel/more2.png"),
    ["more-icon-2"] = dxCreateTexture("files/admin_panel/more1.png"),
}

local tick = getTickCount()

local refresh_timer = false

local line_pointer = 0

local createFaction_Datas = {
    name = "",
    type = 1,
    dutySkins = {},
    dutyItems = {},
}

local dutySkinPointer = 0
local dutyItemPointer = 0

local moreMenuPointer = 0

local showing = false

local editedFactionDatas = {
    id = 0,
    name = "nan",
    type = "nan",
    dutyItems = {},
    dutySkins = {},
    dutyPos = {},
}

local positionTexts = {"X", "Y", "Z", "Dim", "Int"}

function renderPanel()

    local a = interpolateBetween(0,0,0,1,0,0,(getTickCount()-tick)/500,"Linear")

    if page == 1 then 
        dxDrawRectangle(sx*0.35,sy*0.25,sx*0.3,sy*0.48,tocolor(40,40,40,240*a))
        dxDrawImage(0+(200/myX*sx),0+(140/myY*sy),sx-(400/myX*sx),sy-(280/myY*sy),textures["logo"],0,0,0,tocolor(255,255,255,50*a))

        if core:isInSlot(sx*0.355, sy*0.258, sx*0.08, sy*0.02) then 
            dxDrawText("Frakció Létrehozása", sx*0.355, sy*0.258, _, _, tocolor(138, 219, 125,255*a),0.9/myX*sx,fonts["condensed-11"])
        else
            dxDrawText("Frakció Létrehozása", sx*0.355, sy*0.258, _, _, tocolor(255,255,255,255*a),0.9/myX*sx,fonts["condensed-11"])
        end

        dxDrawText("Rádió Frekvencia Levédése", sx*0.45, sy*0.258, _, _, tocolor(255,255,255,255*a),0.9/myX*sx,fonts["condensed-11"])


        if core:isInSlot(sx*0.615,sy*0.258,sx*0.032,sy*0.025) then 
            dxDrawText("Frissítés", sx*0.615, sy*0.258, _, _, tocolor(r,g,b,255*a),0.9/myX*sx,fonts["condensed-11"])
        else
            dxDrawText("Frissítés", sx*0.615, sy*0.258, _, _, tocolor(255,255,255,255*a),0.9/myX*sx,fonts["condensed-11"])
        end

        local starty = 0.29
        local index = 0
        
        for k, v in pairs(renderedList) do 
            local v = renderedList[k+line_pointer]
            if v then 
                if index < 11 then 
                    if core:isInSlot(sx*0.353, sy*starty, sx*0.295, sy*0.035) then 
                        dxDrawRectangle(sx*0.353, sy*starty, sx*0.295, sy*0.035, tocolor(45,45,45,240*a))
                    else
                        dxDrawRectangle(sx*0.353, sy*starty, sx*0.295, sy*0.035, tocolor(50,50,50,240*a))
                    end

                    dxDrawText(v[2]..color.." ("..v[1]..")", sx*0.375, sy*starty, _, sy*starty+sy*0.035, tocolor(220,220,220,255*a), 1/myX*sx, fonts["condensed-11"], "left", "center", false, false, false, true)

                    dxDrawImage(sx*0.3545,sy*starty+sy*0.003,25/myX*sx,25/myY*sy,textures["faction-icon-"..v[3]],0,0,0,tocolor(r,g,b,255*a))

                    if core:isInSlot(sx*0.625,sy*starty,30/myX*sx,30/myY*sy) or moreMenuPointer == k+line_pointer then 
                        dxDrawImage(sx*0.625,sy*starty,30/myX*sx,30/myY*sy,textures["more-icon-1"],0,0,0,tocolor(r,g,b,255*a))
                    else
                        dxDrawImage(sx*0.625,sy*starty,30/myX*sx,30/myY*sy,textures["more-icon-2"],0,0,0,tocolor(220,220,220,255*a))
                    end

                    if moreMenuPointer == k+line_pointer then 
                        dxDrawRectangle(sx*0.655,sy*starty,sx*0.05,sy*0.035, tocolor(50,50,50,255*a))

                        if core:isInSlot(sx*0.688, sy*starty+2/myY*sy, 26/myX*sx, 26/myY*sy) then 
                            dxDrawImage(sx*0.688, sy*starty+2/myY*sy, 26/myX*sx, 26/myY*sy, "files/admin_panel/delete.png", 0, 0, 0, tocolor(212, 61, 61, 255*a))
                        else
                            dxDrawImage(sx*0.688, sy*starty+2/myY*sy, 26/myX*sx, 26/myY*sy, "files/admin_panel/delete.png", 0, 0, 0, tocolor(220, 220, 220, 255*a))
                        end

                        --dxDrawImage(sx*0.675, sy*starty+2/myY*sy, 26/myX*sx, 26/myY*sy, "files/admin_panel/radio.png", 0, 0, 0, tocolor(220, 220, 220, 255*a))

                        if core:isInSlot(sx*0.66, sy*starty+2/myY*sy, 26/myX*sx, 26/myY*sy) then 
                            dxDrawImage(sx*0.66, sy*starty+2/myY*sy, 26/myX*sx, 26/myY*sy, "files/admin_panel/edit.png", 0, 0, 0, tocolor(r, g, b, 255*a))
                        else
                            dxDrawImage(sx*0.66, sy*starty+2/myY*sy, 26/myX*sx, 26/myY*sy, "files/admin_panel/edit.png", 0, 0, 0, tocolor(220, 220, 220, 255*a))
                        end
                    end
                    
                    starty = starty + 0.04
                    index = index + 1
                end
            end
        end

    elseif page == 2 then 
        dxDrawText("Frakció létrehozása",sx*0.3,sy*0.23,sx*0.3+sx*0.4,sy*0.23+sy*0.005, tocolor(220, 220, 220, 255*a), 1/myX*sx, fonts["condensed-14"], "center", "center")
        dxDrawRectangle(sx*0.3,sy*0.25,sx*0.4,sy*0.48,tocolor(40,40,40,240*a))
        dxDrawImage(0+(200/myX*sx),0+(140/myY*sy),sx-(400/myX*sx),sy-(280/myY*sy),"files/logo.png",0,0,0,tocolor(255,255,255,50*a)) 

        dxDrawText("Típus:",sx*0.31,sy*0.31,_,_,tocolor(r,g,b,255*a), 1/myX*sx, fonts["condensed-12"])

        local startY = 0.34
        for k, v in ipairs(faction_types) do 
            if createFaction_Datas.type == k then 
                dxDrawText(v, sx*0.31, sy*startY, _, _, tocolor(r,g,b,200*a), 1/myX*sx, fonts["condensed-11"])
            else
                if core:isInSlot(sx*0.31, sy*startY, sx*0.06, sy*0.02) then 
                    dxDrawText(v, sx*0.31, sy*startY, _, _, tocolor(r,g,b,150*a), 1/myX*sx, fonts["condensed-11"])
                else
                    dxDrawText(v, sx*0.31, sy*startY, _, _, tocolor(220,220,220,255*a), 1/myX*sx, fonts["condensed-11"])
                end
            end

            startY = startY + 0.025

        end
        -- duty skin
        
            dxDrawRectangle(sx*0.39,sy*0.35,sx*0.13,sy*0.375,tocolor(40,40,40,240*a))
            dxDrawImage(sx*0.523,sy*0.32,20/myX*sx,20/myY*sy, "files/admin_panel/plus.png", 0,0,0, tocolor(220,220,220,220))

            local startY = 0.355

            for i = 1, 10 do 
                if createFaction_Datas.dutySkins[i+dutySkinPointer] then 
                    dxDrawRectangle(sx*0.393, sy*startY, sx*0.124, sy*0.035, tocolor(45,45,45,250*a))
                    dxDrawText(createFaction_Datas.dutySkins[i+dutySkinPointer],sx*0.395, sy*startY, _, sy*(startY+0.035), tocolor(220,220,220,255*a), 1/myX*sx, fonts["condensed-11"], _, "center")

                    if core:isInSlot(sx*0.503,sy*(startY+0.006), 20/myX*sx, 20/myX*sx) then 
                        dxDrawImage(sx*0.503,sy*(startY+0.006), 20/myX*sx, 20/myX*sx, "files/admin_panel/delete.png",0,0,0, tocolor(212, 61, 61,255*a))
                    else
                        dxDrawImage(sx*0.503,sy*(startY+0.006), 20/myX*sx, 20/myX*sx, "files/admin_panel/delete.png",0,0,0, tocolor(220,220,220,255*a))
                    end
                end

                startY = startY + 0.0365
            end
        if createFaction_Datas.type == 1 or createFaction_Datas.type == 2 or createFaction_Datas.type == 3 then 
            dxDrawRectangle(sx*0.54,sy*0.35,sx*0.13,sy*0.375,tocolor(40,40,40,240*a))
            dxDrawImage(sx*0.675,sy*0.32,20/myX*sx,20/myY*sy, "files/admin_panel/plus.png", 0,0,0, tocolor(220,220,220,220))

            startY = 0.355
        
            for i = 1, 9 do 
                if createFaction_Datas.dutyItems[i+dutyItemPointer] then 
                    dxDrawRectangle(sx*0.543, sy*startY, sx*0.124, sy*0.039, tocolor(45,45,45,250*a))
                    dxDrawText(inventory:getItemName(tonumber(createFaction_Datas.dutyItems[i+dutyItemPointer]),1),sx*0.57, sy*startY, _, sy*(startY+0.035), tocolor(220,220,220,255*a), 1/myX*sx, fonts["condensed-11"], _, "center")

                    dxDrawImage(sx*0.544, sy*(startY+0.003), 30/myX*sx, 30/myY*sy, inventory:getItemImage(tonumber(editedFactionDatas.dutyItems[i+dutyItemPointer]), 1))

                    if core:isInSlot(sx*0.653,sy*(startY+0.006), 20/myX*sx, 20/myX*sx) then 
                        dxDrawImage(sx*0.653,sy*(startY+0.006), 20/myX*sx, 20/myX*sx, "files/admin_panel/delete.png",0,0,0, tocolor(212, 61, 61,255*a))
                    else
                        dxDrawImage(sx*0.653,sy*(startY+0.006), 20/myX*sx, 20/myX*sx, "files/admin_panel/delete.png",0,0,0, tocolor(220,220,220,255*a))
                    end
                end

                startY = startY + 0.0405
            end
        end

        if isFactionCreateAllowed() then 
            if core:isInSlot(sx*0.675, sy*0.68, 30/myX*sx, 30/myY*sy) then 
                dxDrawImage(sx*0.675, sy*0.68, 30/myX*sx, 30/myY*sy, "files/admin_panel/tick.png", 0,0,0, tocolor(138, 219, 125, 150))
            else
                dxDrawImage(sx*0.675, sy*0.68, 30/myX*sx, 30/myY*sy, "files/admin_panel/tick.png", 0,0,0, tocolor(220,220,220, 150))
            end
        else
            dxDrawImage(sx*0.675, sy*0.68, 30/myX*sx, 30/myY*sy, "files/admin_panel/tick.png", 0,0,0, tocolor(220,220,220, 100))
        end

        if core:isInSlot(sx*0.305, sy*0.68, 30/myX*sx, 30/myY*sy) then 
            dxDrawImage(sx*0.305, sy*0.68, 30/myX*sx, 30/myY*sy, "files/admin_panel/return.png", 0,0,0, tocolor(61, 149, 212, 150))
        else
            dxDrawImage(sx*0.305, sy*0.68, 30/myX*sx, 30/myY*sy, "files/admin_panel/return.png", 0,0,0, tocolor(220,220,220, 150))
        end

        createFaction_Datas.name = getEditboxValue(getEditboxFromName("faction-name")) or ""
    elseif page == 3 then 
        dxDrawText("Frakció szerkesztése - "..color..editedFactionDatas.name,sx*0.3,sy*0.23,sx*0.3+sx*0.4,sy*0.23+sy*0.005, tocolor(220, 220, 220, 255*a), 1/myX*sx, fonts["condensed-14"], "center", "center", false, false, false, true)
        dxDrawRectangle(sx*0.3,sy*0.25,sx*0.4,sy*0.48,tocolor(40,40,40,240*a))
        dxDrawImage(0+(200/myX*sx),0+(140/myY*sy),sx-(400/myX*sx),sy-(280/myY*sy),"files/logo.png",0,0,0,tocolor(255,255,255,50*a)) 

        dxDrawText("Típus:",sx*0.31,sy*0.31,_,_,tocolor(r,g,b,255*a), 1/myX*sx, fonts["condensed-12"])

        local startY = 0.34
        for k, v in ipairs(faction_types) do 
            if editedFactionDatas.type == k then 
                dxDrawText(v .. " | " ..editedFactionDatas.type, sx*0.31, sy*startY, _, _, tocolor(220, 220, 220, 255*a), 1/myX*sx, fonts["condensed-11"])
            end
        end

        
            dxDrawRectangle(sx*0.39,sy*0.35,sx*0.13,sy*0.375,tocolor(40,40,40,240*a))
            dxDrawImage(sx*0.523,sy*0.32,20/myX*sx,20/myY*sy, "files/admin_panel/plus.png", 0,0,0, tocolor(220,220,220,220))

            local startY = 0.355

            for i = 1, 10 do 
                if editedFactionDatas.dutySkins[i+dutySkinPointer] then 
                    dxDrawRectangle(sx*0.393, sy*startY, sx*0.124, sy*0.035, tocolor(45,45,45,250*a))
                    dxDrawText(editedFactionDatas.dutySkins[i+dutySkinPointer],sx*0.395, sy*startY, _, sy*(startY+0.035), tocolor(220,220,220,255*a), 1/myX*sx, fonts["condensed-11"], _, "center")

                    if core:isInSlot(sx*0.503,sy*(startY+0.006), 20/myX*sx, 20/myX*sx) then 
                        dxDrawImage(sx*0.503,sy*(startY+0.006), 20/myX*sx, 20/myX*sx, "files/admin_panel/delete.png",0,0,0, tocolor(212, 61, 61,255*a))
                    else
                        dxDrawImage(sx*0.503,sy*(startY+0.006), 20/myX*sx, 20/myX*sx, "files/admin_panel/delete.png",0,0,0, tocolor(220,220,220,255*a))
                    end
                end

                startY = startY + 0.0365
            end
        if editedFactionDatas.type == 1 or editedFactionDatas.type == 2 or editedFactionDatas.type == 3 then 
            dxDrawRectangle(sx*0.54,sy*0.35,sx*0.13,sy*0.375,tocolor(40,40,40,240*a))
            dxDrawImage(sx*0.675,sy*0.32,20/myX*sx,20/myY*sy, "files/admin_panel/plus.png", 0,0,0, tocolor(220,220,220,220))

            startY = 0.355

            for i = 1, 9 do 
                if editedFactionDatas.dutyItems[i+dutyItemPointer] then 
                    dxDrawRectangle(sx*0.543, sy*startY, sx*0.124, sy*0.039, tocolor(45,45,45,250*a))
                    dxDrawText(inventory:getItemName(tonumber(editedFactionDatas.dutyItems[i+dutyItemPointer]),1),sx*0.57, sy*startY, _, sy*(startY+0.035), tocolor(220,220,220,255*a), 0.8/myX*sx, fonts["condensed-11"], _, "center")

                    dxDrawImage(sx*0.544, sy*(startY+0.003), 30/myX*sx, 30/myY*sy, inventory:getItemImage(tonumber(editedFactionDatas.dutyItems[i+dutyItemPointer]), 1))

                    if core:isInSlot(sx*0.653,sy*(startY+0.006), 20/myX*sx, 20/myX*sx) then 
                        dxDrawImage(sx*0.653,sy*(startY+0.006), 20/myX*sx, 20/myX*sx, "files/admin_panel/delete.png",0,0,0, tocolor(212, 61, 61,255*a))
                    else
                        dxDrawImage(sx*0.653,sy*(startY+0.006), 20/myX*sx, 20/myX*sx, "files/admin_panel/delete.png",0,0,0, tocolor(220,220,220,255*a))
                    end
                end

                startY = startY + 0.0405
            end

            dxDrawText("Duty Pozíció:",sx*0.31,sy*0.38,_,_,tocolor(r,g,b,255*a), 1/myX*sx, fonts["condensed-12"])

            local starty = sy*0.45
            if #editedFactionDatas.dutyPos > 0 then 
                for k, v in ipairs(editedFactionDatas.dutyPos) do 
                    dxDrawText(positionTexts[k]..": "..color..v, sx*0.31, starty, _, _, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["condensed-11"], _, _, false, false, false, true)
                    starty = starty + sy*0.03
                end
            end

            dxDrawRectangle(sx*0.31, sy*0.41, sx*0.07, sy*0.03, tocolor(30, 30, 30, 255*a))

            if core:isInSlot(sx*0.31, sy*0.41, sx*0.07, sy*0.03) then 
                dxDrawText("Beállítás", sx*0.31, sy*0.41, sx*0.31+sx*0.07, sy*0.41+sy*0.03, tocolor(r, g, b, 255*a), 1/myX*sx, fonts["condensed-11"], "center", "center")
            else
                dxDrawText("Beállítás", sx*0.31, sy*0.41, sx*0.31+sx*0.07, sy*0.41+sy*0.03, tocolor(220, 220, 220, 255*a), 1/myX*sx, fonts["condensed-11"], "center", "center")
            end
        end

        if core:isInSlot(sx*0.305, sy*0.68, 30/myX*sx, 30/myY*sy) then 
            dxDrawImage(sx*0.305, sy*0.68, 30/myX*sx, 30/myY*sy, "files/admin_panel/return.png", 0,0,0, tocolor(61, 149, 212, 150))
        else
            dxDrawImage(sx*0.305, sy*0.68, 30/myX*sx, 30/myY*sy, "files/admin_panel/return.png", 0,0,0, tocolor(220,220,220, 150))
        end

        if isFactionSaveAllowed() then 
            if core:isInSlot(sx*0.675, sy*0.68, 30/myX*sx, 30/myY*sy) then 
                dxDrawImage(sx*0.675, sy*0.68, 30/myX*sx, 30/myY*sy, "files/admin_panel/tick.png", 0,0,0, tocolor(138, 219, 125, 150))
            else
                dxDrawImage(sx*0.675, sy*0.68, 30/myX*sx, 30/myY*sy, "files/admin_panel/tick.png", 0,0,0, tocolor(220,220,220, 150))
            end
        else
            dxDrawImage(sx*0.675, sy*0.68, 30/myX*sx, 30/myY*sy, "files/admin_panel/tick.png", 0,0,0, tocolor(220,220,220, 100))
        end
    end
end

function onKey(key, state)
    if key == "mouse1" then 
        if state then 
            if page == 1 then 
                if core:isInSlot(sx*0.615,sy*0.258,sx*0.032,sy*0.025) then 
                    if isTimer(refresh_timer) then 
                        outputChatBox(core:getServerPrefix("red-dark","Frakció", 2).. "Csak "..color..allowed_refresh_time.." #ffffffmásodpercenként frissítheted a frakciólistát!",255,255,255,true)
                    else
                        refresh_timer = setTimer(function() 
                            if isTimer(refresh_timer) then 
                                killTimer(refresh_timer)
                            end
                        end, allowed_refresh_time*1000, 1)

                        refreshFactionList()
                        outputChatBox(core:getServerPrefix("green-dark","Frakció", 2).. "Frakciólista frissítve!",255,255,255,true)
                        return
                    end
                end 

                if core:isInSlot(sx*0.355, sy*0.258, sx*0.08, sy*0.02) then 
                    setAdminPanelPage(2)
                    return
                end

                local starty = 0.29
                local index = 0
                
                for k, v in pairs(renderedList) do 
                    local v = renderedList[k+line_pointer]
                    if index < 11 then 
                        if core:isInSlot(sx*0.625,sy*starty,30/myX*sx,30/myY*sy) then 
                            if moreMenuPointer == k+line_pointer then 
                                moreMenuPointer = false
                            else
                                moreMenuPointer = k+line_pointer
                            end
                        end

                        if moreMenuPointer == k+line_pointer then 
                            if core:isInSlot(sx*0.688, sy*starty+2/myY*sy, 26/myX*sx, 26/myY*sy) then 
                                --triggerServerEvent("faction_admin > delFaction", resourceRoot, v[1])
                                outputChatBox(core:getServerPrefix("red-dark","Frakció", 2).. "Ez a funkció jelenleg nem elérhető!",255,255,255,true)
                            end
        
                            if core:isInSlot(sx*0.66, sy*starty+2/myY*sy, 26/myX*sx, 26/myY*sy) then 
                                setAdminPanelPage(3)

--                                print(v[2])

                                editedFactionDatas.id = v[1]
                                editedFactionDatas.name = v[2]
                                editedFactionDatas.type = v[3]
                                editedFactionDatas.dutySkins = v[4]
                                editedFactionDatas.dutyItems = v[5]
                                editedFactionDatas.dutyPos = v[11]

                                setEditboxValue(getEditboxFromName("faction-name"), v[2])

                                if editedFactionDatas.type > 3 then 
                                    deleteEditbox(getEditboxFromName("faction-dutyitem"))
                                end
                            end
                        end
                        
                        starty = starty + 0.04
                        index = index + 1
                    end
                end

            elseif page == 2 then 

                local startY = 0.34
                for k, v in ipairs(faction_types) do 
                    if core:isInSlot(sx*0.31, sy*startY, sx*0.06, sy*0.02) then 
                        setFactionCreatePanelGroupType(createFaction_Datas.type, k)
                        createFaction_Datas.type = k
                    end

                    startY = startY + 0.025
                end

                
    
        
                    local startY = 0.355
        
                    for i = 1, 10 do 
                        if createFaction_Datas.dutySkins[i+dutySkinPointer] then 
                            if core:isInSlot(sx*0.503,sy*(startY+0.006), 20/myX*sx, 20/myX*sx) then 

                                table.remove(createFaction_Datas.dutySkins, i+dutySkinPointer)
                            end
                        end
                        startY = startY + 0.0365
                    end
        
                    if editedFactionDatas.type == 1 or editedFactionDatas.type == 2 or editedFactionDatas.type == 3 then 
                        startY = 0.355
            
                        for i = 1, 9 do 
                            if createFaction_Datas.dutyItems[i+dutyItemPointer] then 
                                if core:isInSlot(sx*0.653,sy*(startY+0.006), 20/myX*sx, 20/myX*sx) then 
                                    table.remove(createFaction_Datas.dutyItems, i+dutyItemPointer)
                                end
                            end
                            startY = startY + 0.0405
                        end
                    end

                    if core:isInSlot(sx*0.523,sy*0.32,20/myX*sx,20/myY*sy) then 
                        if string.len(getEditboxValue(getEditboxFromName("faction-dutyskin"))) >= 1 then 
                            if tonumber(getEditboxValue(getEditboxFromName("faction-dutyskin"))) then 
                                if skinIsRealSkin(getEditboxValue(getEditboxFromName("faction-dutyskin"))) then 
                                    table.insert(createFaction_Datas.dutySkins, #createFaction_Datas.dutySkins+1, getEditboxValue(getEditboxFromName("faction-dutyskin")))
                                end
                            end

                            setEditboxValue(getEditboxFromName("faction-dutyskin"), "")
                        end
                    end
                if createFaction_Datas.type == 1 or createFaction_Datas.type == 2 or createFaction_Datas.type == 3 then 
                    if core:isInSlot(sx*0.675,sy*0.32,20/myX*sx,20/myY*sy) then 
                        if string.len(getEditboxValue(getEditboxFromName("faction-dutyitem"))) >= 1 then 
                            if tonumber(getEditboxValue(getEditboxFromName("faction-dutyitem"))) then 
                                table.insert(createFaction_Datas.dutyItems, #createFaction_Datas.dutyItems+1, getEditboxValue(getEditboxFromName("faction-dutyitem")))
                            end

                            setEditboxValue(getEditboxFromName("faction-dutyitem"), "")
                        end
                    end
                end

                if isFactionCreateAllowed() then 
                    if core:isInSlot(sx*0.675, sy*0.68, 30/myX*sx, 30/myY*sy) then 
                        triggerServerEvent("faction_admin > createFaction", resourceRoot, localPlayer, {["name"] = createFaction_Datas.name, ["type"] = createFaction_Datas.type, ["allowedSkins"] = createFaction_Datas.dutySkins, ["allowedItems"] = createFaction_Datas.dutyItems})
                        setAdminPanelPage(1)
                        factions = client_faction_list
                    end
                end

                
                if core:isInSlot(sx*0.305, sy*0.68, 30/myX*sx, 30/myY*sy) then 
                    setAdminPanelPage(1)
                end
            elseif page == 3 then 
                
                    local startY = 0.355
                    for i = 1, 10 do 
                        if editedFactionDatas.dutySkins[i+dutySkinPointer] then 
                            if core:isInSlot(sx*0.503,sy*(startY+0.006), 20/myX*sx, 20/myX*sx) then 

                                table.remove(editedFactionDatas.dutySkins, i+dutySkinPointer)
                            end
                        end
                        startY = startY + 0.0365
                    end
                    if editedFactionDatas.type == 1 or editedFactionDatas.type == 2 or editedFactionDatas.type == 3 then 
                        local startY = 0.355
                        for i = 1, 9 do 
                            if editedFactionDatas.dutyItems[i+dutyItemPointer] then 
                                if core:isInSlot(sx*0.653,sy*(startY+0.006), 20/myX*sx, 20/myX*sx) then 
                                    table.remove(editedFactionDatas.dutyItems, i+dutyItemPointer)
                                end
                            end
                            startY = startY + 0.0405
                        end
                    end

                    if core:isInSlot(sx*0.523,sy*0.32,20/myX*sx,20/myY*sy) then 
                        if string.len(getEditboxValue(getEditboxFromName("faction-dutyskin"))) >= 1 then 
                            if tonumber(getEditboxValue(getEditboxFromName("faction-dutyskin"))) then 
                                if skinIsRealSkin(getEditboxValue(getEditboxFromName("faction-dutyskin"))) then 
                                    table.insert(editedFactionDatas.dutySkins, #editedFactionDatas.dutySkins+1, getEditboxValue(getEditboxFromName("faction-dutyskin")))
                                end
                            end

                            setEditboxValue(getEditboxFromName("faction-dutyskin"), "")
                        end
                    end
                if editedFactionDatas.type == 1 or editedFactionDatas.type == 2 or editedFactionDatas.type == 3 then 
                    if core:isInSlot(sx*0.675,sy*0.32,20/myX*sx,20/myY*sy) then 
                        if string.len(getEditboxValue(getEditboxFromName("faction-dutyitem"))) >= 1 then 
                            if tonumber(getEditboxValue(getEditboxFromName("faction-dutyitem"))) then 
                                table.insert(editedFactionDatas.dutyItems, #editedFactionDatas.dutyItems+1, getEditboxValue(getEditboxFromName("faction-dutyitem")))
                            end

                            setEditboxValue(getEditboxFromName("faction-dutyitem"), "")
                        end
                    end
                end

                if core:isInSlot(sx*0.31, sy*0.41, sx*0.07, sy*0.03) then 
                    local pos = Vector3(getElementPosition(localPlayer))
                    local dim = getElementDimension(localPlayer)
                    local int = getElementInterior(localPlayer)

                    editedFactionDatas.dutyPos = {pos.x, pos.y, pos.z, dim, int}
                end
                
                if core:isInSlot(sx*0.305, sy*0.68, 30/myX*sx, 30/myY*sy) then 
                    setAdminPanelPage(1)
                end

                if core:isInSlot(sx*0.675, sy*0.68, 30/myX*sx, 30/myY*sy) then 
                    if isFactionSaveAllowed() then 
                        editedFactionDatas.name = getEditboxValue(getEditboxFromName("faction-name"))
                        setAdminPanelPage(1)

                        
                        triggerServerEvent("faction > admin > modifyFactionDatas", resourceRoot, editedFactionDatas.id, editedFactionDatas.name, editedFactionDatas.dutyPos, editedFactionDatas.dutySkins, editedFactionDatas.dutyItems)
                    end
                end
            end
        end
    elseif key == "mouse_wheel_down" then 
        if state then 
            if page == 1 then 
                if core:isInSlot(sx*0.35,sy*0.25,sx*0.3,sy*0.48) then 
                    if renderedList[line_pointer+11+1] then
                        line_pointer = line_pointer + 1
                    end
                end
            elseif page == 2 then 
                if core:isInSlot(sx*0.39,sy*0.35,sx*0.13,sy*0.375) then 
                    if dutySkinPointer+10 < #createFaction_Datas.dutySkins then 
                        dutySkinPointer = dutySkinPointer + 1
                    end
                end

                if core:isInSlot(sx*0.54,sy*0.35,sx*0.13,sy*0.375) then 
                    if dutyItemPointer+9 < #createFaction_Datas.dutyItems then 
                        dutyItemPointer = dutyItemPointer + 1
                    end
                end
            elseif page == 3 then 
                if core:isInSlot(sx*0.39,sy*0.35,sx*0.13,sy*0.375) then 
                    if dutySkinPointer+10 < #editedFactionDatas.dutySkins then 
                        dutySkinPointer = dutySkinPointer + 1
                    end
                end

                if core:isInSlot(sx*0.54,sy*0.35,sx*0.13,sy*0.375) then 
                    if editedFactionDatas.dutyItems[dutyItemPointer + 10] then 
                        dutyItemPointer = dutyItemPointer + 1
                    end
                end
            end
        end
    elseif key == "mouse_wheel_up" then 
        if state then 
            if page == 1 then 
                if core:isInSlot(sx*0.35,sy*0.25,sx*0.3,sy*0.48) then 
                    if line_pointer > 0 then
                        line_pointer = line_pointer - 1
                    end
                end
            elseif page == 2 then 
                if core:isInSlot(sx*0.39,sy*0.35,sx*0.13,sy*0.375) then 
                    if dutySkinPointer > 0 then 
                        dutySkinPointer = dutySkinPointer - 1
                    end
                end

                if core:isInSlot(sx*0.54,sy*0.35,sx*0.13,sy*0.375) then 
                    if dutyItemPointer > 0 then 
                        dutyItemPointer = dutyItemPointer - 1
                    end
                end
            elseif page == 3 then 
                if core:isInSlot(sx*0.39,sy*0.35,sx*0.13,sy*0.375) then 
                    if dutySkinPointer > 0 then 
                        dutySkinPointer = dutySkinPointer - 1
                    end
                end

                if core:isInSlot(sx*0.54,sy*0.35,sx*0.13,sy*0.375) then 
                    if dutyItemPointer > 0 then 
                        dutyItemPointer = dutyItemPointer - 1
                    end
                end
            end
        end
    end 
end

function setAdminPanelPage(newPage)
    if page == 2 then 
        deleteEditbox(getEditboxFromName("faction-name"))
        deleteEditbox(getEditboxFromName("faction-dutyskin"))
        deleteEditbox(getEditboxFromName("faction-dutyitem"))

        createFaction_Datas = {
            name = "",
            type = 1,
            dutySkins = {},
            dutyItems = {},
        }
    elseif page == 3 then 
        deleteEditbox(getEditboxFromName("faction-name"))
        deleteEditbox(getEditboxFromName("faction-dutyskin"))
        deleteEditbox(getEditboxFromName("faction-dutyitem"))

        createFaction_Datas = {
            name = "",
            type = 1,
            dutySkins = {},
            dutyItems = {},
        }
    end

    page = newPage
    if page == 1 then 
    elseif page == 2 then 
        createEditbox("faction-name", "Frakció neve", 0.302, 0.255, 0.395, 0.04, fonts["condensed-11"], 1/myX*sx, tocolor(220,220,220,255), tocolor(50,50,50,240))

        createEditbox("faction-dutyskin", "Skin hozzáadása", 0.39, 0.315, 0.13, 0.035, fonts["condensed-11"], 1/myX*sx, tocolor(220,220,220,255), tocolor(50,50,50,240))

        createEditbox("faction-dutyitem", "Dutyitem hozzáadása", 0.54, 0.315, 0.13, 0.035, fonts["condensed-11"], 1/myX*sx, tocolor(220,220,220,255), tocolor(50,50,50,240))
    elseif page == 3 then 
        createEditbox("faction-name", "Frakció neve", 0.302, 0.255, 0.395, 0.04, fonts["condensed-11"], 1/myX*sx, tocolor(220,220,220,255), tocolor(50,50,50,240))

        createEditbox("faction-dutyskin", "Skin hozzáadása", 0.39, 0.315, 0.13, 0.035, fonts["condensed-11"], 1/myX*sx, tocolor(220,220,220,255), tocolor(50,50,50,240))

        createEditbox("faction-dutyitem", "Dutyitem hozzáadása", 0.54, 0.315, 0.13, 0.035, fonts["condensed-11"], 1/myX*sx, tocolor(220,220,220,255), tocolor(50,50,50,240))
    end
end

function setFactionCreatePanelGroupType(oldType, newType) 
    if oldType == 4 or oldType == 5 then 
        if newType >= 1 and newType <= 3 then 
            createEditbox("faction-dutyskin", "Skin hozzáadása", 0.39, 0.315, 0.13, 0.035, fonts["condensed-11"], 1/myX*sx, tocolor(220,220,220,255), tocolor(50,50,50,240))
            createEditbox("faction-dutyitem", "Dutyitem hozzáadása", 0.54, 0.315, 0.13, 0.035, fonts["condensed-11"], 1/myX*sx, tocolor(220,220,220,255), tocolor(50,50,50,240))
        end
    elseif oldType >= 1 and oldType <= 3 then 
        if newType == 4 or newType == 5 then 
        --    deleteEditbox(getEditboxFromName("faction-dutyskin"))
            deleteEditbox(getEditboxFromName("faction-dutyitem"))
        end
    end
end

function refreshFactionList()
    factions = {}
    factions = client_faction_list
        
    renderedList = {}

    for k, v in spairs(factions) do 
        table.insert(renderedList, #renderedList+1, v)
    end
end

function showFactionCreatorPanel()
    if getElementData(localPlayer,"user:admin") >= 7 then 
        if showing then 
            if page == 2 then 
                deleteEditbox(getEditboxFromName("faction-name"))
                deleteEditbox(getEditboxFromName("faction-dutyskin"))
                deleteEditbox(getEditboxFromName("faction-dutyitem"))
        
                createFaction_Datas = {
                    name = "",
                    type = 1,
                    dutySkins = {},
                    dutyItems = {},
                }
            elseif page == 3 then 
                deleteEditbox(getEditboxFromName("faction-name"))
                deleteEditbox(getEditboxFromName("faction-dutyskin"))
                deleteEditbox(getEditboxFromName("faction-dutyitem"))
        
                createFaction_Datas = {
                    name = "",
                    type = 1,
                    dutySkins = {},
                    dutyItems = {},
                }
            end
            
            showing = false 

            removeEventHandler("onClientKey", root, onKey)
            removeEventHandler("onClientRender", root, renderPanel)
        else
            showing = true

            setAdminPanelPage(1)
            refreshFactionList()
            addEventHandler("onClientKey", root, onKey)
            addEventHandler("onClientRender", root, renderPanel)

            if not isTimer(refresh_timer) then 
                factions = client_faction_list

                refresh_timer = setTimer(function() 
                    if isTimer(refresh_timer) then 
                        killTimer(refresh_timer)
                    end
                end, allowed_refresh_time*1000, 1)
            end 
        end
    end
end

--setTimer(showFactionCreatorPanel, 100, 1)

addCommandHandler("factionlist",showFactionCreatorPanel)
addCommandHandler("showfactions",showFactionCreatorPanel)

----- / EDITBOX / -----
local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900

local color, r, g, b = core:getServerColor()

local editboxs = {
    --name, data, active, def-name, x, y, w, h, font, fontsize, tick, textcolor, bgcolor
}

local dataNames = {"name", "showname", "x", "y", "w", "h", "font", "font_size"}

local tiltott_keys = {
    ["backspace"] = true,
	["tab"] = true,
	["-"] = true,
	["."] = true,
	[","] = true,
	["lctrl"] = true,
	["rctrl"] = true,
	["lalt"] = true,
	["mouse1"] = true,
	["mouse2"] = true,
	["mouse3"] = true,
	["F1"] = true,
	["F2"] = true,
	["F3"] = true,
	["F4"] = true,
	["F5"] = true,
	["F6"] = true,
	["F7"] = true,
	["F8"] = true,
	["F9"] = true,
	["F10"] = true,
	["F11"] = true,
	["F12"] = true,
	["lshift"] = true, 
	["rshift"] = true,
	["space"] = true,
	["pgdn"] = true,
	["num_div"] = true,
	["num_mul"] = true,
	["num_sub"] = true,
	["num_add"] = true,
	["num_sub"] = true,
	["escape"] = true,
	["insert"] = true,
	["home"] = true,
	["delete"] = true,
	["end"] = true,
	["pgup"] = true,
	["scroll"] = true,
	["pause"] = true,
	["ralt"] = true,
    ["enter"] = true,
    ["mouse_wheel_down"] = true,
    ["mouse_wheel_up"] = true,
    ["capslock"] = true,
    ["arrow_u"] = true,
    ["arrow_d"] = true,
    ["arrow_l"] = true,
    ["arrow_r"] = true,
}

local custom_keys = {
    ["["] = "ő",
    ["]"] = "ú",
    ["="] = "ó",
    ["/"] = "ü",
    ["'"] = "ö",
    ["#"] = "á",
    [";"] = "é",
}

local backspace_timer = false
local shift_state = false

function renderEditboxs()
    for k, v in ipairs(editboxs) do 

        dxDrawRectangle(sx*v[5], sy*v[6], sx*v[7], sy*v[8], v[13], true)

        if ((string.len(v[2]) > 0) or v[3]) then 

            if v[3] then 
                --if getTickCount()/10 % 2 == 0 then 
                --  dxDrawText(v[2].."|", sx*v[5], sy*v[6], sx*v[5]+sx*v[7], sy*v[6]+sy*v[8], tocolor(220,220,220, 255), v[10], v[9], "center", "center", false, false, false, true) 
                --else
                    dxDrawText(v[2], sx*v[5], sy*v[6], sx*v[5]+sx*v[7], sy*v[6]+sy*v[8], v[12], v[10], v[9], "center", "center", false, false, true, true) 
                --end
            else
                dxDrawText(v[2], sx*v[5], sy*v[6], sx*v[5]+sx*v[7], sy*v[6]+sy*v[8], v[12], v[10], v[9], "center", "center", false, false, true, true)
            end
        else
            dxDrawText(v[4], sx*v[5], sy*v[6], sx*v[5]+sx*v[7], sy*v[6]+sy*v[8], v[12], v[10], v[9], "center", "center", false, false, true, true)
        end

        if v[3] then 
            local hossz, alpha = interpolateBetween(0,1,0,v[7],0,0,(getTickCount()-v[11])/500,"Linear")
            dxDrawRectangle(sx*v[5], sy*v[6], sx*hossz, sy*v[8], tocolor(r,g,b,150*alpha), true)
        end
    end
end

function editboxClick(key, state) 
    if key == "mouse1" then 
        if state then 
            local volteditbox = false
            for k, v in ipairs(editboxs) do 

                if core:isInSlot(sx*v[5], sy*v[6], sx*v[7], sy*v[8]) then 
                    v[11] = getTickCount()
                    v[3] = true
                    setPedControlState(localPlayer, "chatbox", true)
                    volteditbox = true
                else
                    v[3] = false
                end

            end

            if not volteditbox then 
                setPedControlState(localPlayer, "chatbox", false)
            end
        end
    end

    local activebox = getActiveEditbox()
    if activebox and isCursorShowing() then 
        cancelEvent()
        if not tiltott_keys[key] then 
            if state then

                if custom_keys[key] then 
                    if shift_state then 
                        setEditboxValue(activebox, getEditboxValue(activebox) .. string.upper(custom_keys[key]))
                    else
                        setEditboxValue(activebox, getEditboxValue(activebox) .. custom_keys[key])
                    end
                else
                    if shift_state then 
                        setEditboxValue(activebox, getEditboxValue(activebox) .. string.upper(key:gsub("num_","")))
                    else
                        setEditboxValue(activebox, getEditboxValue(activebox) .. key:gsub("num_",""))
                    end
                end
                
            end
        else
            if key == "backspace" then 
                if state then 
                    backspace_timer = setTimer(
                        function() 
                            setEditboxValue(activebox, getEditboxValue(activebox):gsub("[^\128-\191][\128-\191]*$", ""))
                        end, 50, 0)
                else
                    if isTimer(backspace_timer) then 
                        killTimer(backspace_timer)
                    end
                end

            elseif key == "space" then 
                if state then 
                    setEditboxValue(activebox, getEditboxValue(activebox) .. " ")
                end
            elseif key == "lshift" or key == "rshift" then 
                shift_state = state
            end
        end
    else
        return
    end
end

function createEditbox(editbox_name, editbox_showname,editbox_x, editbox_y, editbox_w, editbox_h, editbox_font, editbox_font_size, textcolor, bgcolor)
    table.insert(editboxs, #editboxs+1, {editbox_name, "", false, editbox_showname, editbox_x, editbox_y, editbox_w, editbox_h, editbox_font, editbox_font_size, getTickCount(), textcolor, bgcolor})

    if #editboxs == 1 then 
        addEventHandler("onClientRender", root, renderEditboxs)
        addEventHandler("onClientKey", root, editboxClick)
    end
end

function getEditboxFromName(name)
    local editboxID = false
    for k, v in ipairs(editboxs) do 
        if v[1] == name then 
            editboxID = k
            break
        end
    end

    return editboxID
end

function deleteEditbox(id)
    if editboxs[id] then 
        table.remove(editboxs, id)

        if #editboxs == 0 then 
            removeEventHandler("onClientRender", root, renderEditboxs)
            removeEventHandler("onClientKey", root, editboxClick)
        end
    end
end

function getEditboxData(id, dataName)
    dataID = 0 

    for k, v in ipairs(dataNames) do 
        if v == dataName then 
            dataID = k 
            if dataID > 1 then 
                dataID = dataID + 2
            end 
            break 
        end
    end

    if dataID > 0 then 
        if editboxs[id] then 
            return editboxs[id][dataID]
        else
            return false
        end
    else
        return false
    end
end

function setEditboxData(id, dataName, newValue)
    dataID = 0 

    for k, v in ipairs(dataNames) do 
        if v == dataName then 
            dataID = k 
            if dataID > 1 then 
                dataID = dataID + 2
            end 
            break 
        end
    end

    if dataID > 0 then 
        if editboxs[id] then 
            editboxs[id][dataID] = newValue
        end
    else
        return false
    end
end

function setEditboxValue(id, value)
    if editboxs[id] then 
        editboxs[id][2] = tostring(value)
    end
end

function getEditboxValue(id)
    if editboxs[id] then 
        return editboxs[id][2]
    else
        return false
    end
end

function getActiveEditbox()
    local editboxID = false
    for k, v in ipairs(editboxs) do 
        if v[3] then 
            editboxID = k 
            break
        end
    end

    if editboxID then 
        return editboxID
    end
end

---- Faction create functions ----
function isFactionCreateAllowed()
    if string.len(createFaction_Datas.name) >= 4 then 
        if createFaction_Datas.type == 4 or createFaction_Datas.type == 5 then 
            return true
        else
            if #createFaction_Datas.dutySkins >= 1 then 
                if #createFaction_Datas.dutyItems >= 1 then 
                    return true
                else 
                    return false
                end
            else 
                return false
            end
        end 
    else
        return false
    end
end

function isFactionSaveAllowed()
    return true 

    -- a kikommentelt rész valamiért nem működik rendesen, de jó lenne majd valamikor rájönni, hogy miért 
    
    --[[if string.len(editedFactionDatas.name) >= 4 then 
        if editedFactionDatas.type == 4 or editedFactionDatas.type == 5 then 
            return true
        else
            if #editedFactionDatas.dutySkins >= 1 then 
                if #editedFactionDatas.dutyItems >= 1 then 
                    return true
                else 
                    return false
                end
            else 
                return false
            end
        end 
    else
        return false
    end]]
end

function skinIsRealSkin(skinID) 
    local realSkins = getValidPedModels()

    local volt = false 

    for k, v in ipairs(realSkins) do 
        if v == tonumber(skinID) then 
            volt = true 
            break 
        end
    end

    return volt
end

-- events --
--[[addEvent("faction > returnFactionListOnClient", true)
addEventHandler("faction > returnFactionListOnClient", root, function(list) 
    factions = list

    outputChatBox("faction > returnFactionListOnClient <- CLIENT")
end)]]

--[[exports.oAdmin:addAdminCMD("addplayertofaction", 6, "Játékos frakcióhoz adása.")
exports.oAdmin:addAdminCMD("giveplayerfaction", 6, "Játékos frakcióhoz adása.")
exports.oAdmin:addAdminCMD("addtofaction", 6, "Játékos frakcióhoz adása.")

exports.oAdmin:addAdminCMD("getplayerfactions", 4, "Játékos frakcióinak lekérése.")
exports.oAdmin:addAdminCMD("getfactions", 4, "Játékos frakcióinak lekérése.")

exports.oAdmin:addAdminCMD("removeplayerfromfaction", 6, "Játékos kivétele frakcióból.")
exports.oAdmin:addAdminCMD("removefromfaction", 6, "Játékos kivétele frakcióból.")

exports.oAdmin:addAdminCMD("removeplayerfromallfaction", 7, "Játékos kivétele az összes frakcióból.")
exports.oAdmin:addAdminCMD("removefromallfaction", 7, "Játékos kivétele az összes frakcióból.")

exports.oAdmin:addAdminCMD("setfactionleader", 7, "Frakció leaderének megadása.")

exports.oAdmin:addAdminCMD("factionlist", 7, "Frakció lista megtekintése.")
exports.oAdmin:addAdminCMD("showfactions", 7, "Frakció lista megtekintése.")

exports.oAdmin:addAdminCMD("givefactionmoney", 7, "Pénz adása frakció számára.")
exports.oAdmin:addAdminCMD("removefactionmoney", 7, "Pénz elvétele frakciótól.")]]