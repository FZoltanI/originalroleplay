local sx,sy = guiGetScreenSize()
local myX,myY = 1600,900

local interaction = false
local tick = getTickCount()
local animTime = 250

local type
local utotag = ""
selectedElement = false

local showing = false

local font1 = font:getFont("condensed",10)
local font2 = font:getFont("condensed",12)

local menus = {}

local checkNeed = false

local text = ""
local openType = "player"

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oFont" or getResourceName(res) == "oInteraction" or getResourceName(res) == "oInventory" then  
        core = exports.oCore
        font = exports.oFont
        inv = exports.oInventory

        color, r, g, b = core:getServerColor()
        colorizePed = {r/255, g/255, b/255, 1}
	end
end)

function render()
    if selectedElement then 
        if checkNeed then 
            if not isElement(selectedElement) then 
                removeEventHandler("onClientRender", root, render)
                return
            end

            if (core:getDistance(selectedElement, localPlayer) > 4) then 
                closePanel()
                checkNeed = false
            end
        end
    end

    local position = Vector3(getElementPosition(selectedElement))

    mx, my = getScreenFromWorldPosition(position.x, position.y, position.z)

    if not mx or not my then return end

    mx = mx/sx
    my = my/sy

    mx = mx - 0.13/2
    my = my - (0.05+((0.03)*(#menus+1))/2)

    local alpha = 1
    if interaction then 
        alpha = interpolateBetween(0,0,0,1,0,0,(getTickCount()-tick)/animTime,"Linear")
    else
        alpha = interpolateBetween(1,0,0,0,0,0,(getTickCount()-tick)/animTime,"Linear")
    end

    dxDrawRectangle(sx*mx, sy*my, sx*0.13, sy*0.05+((sy*0.03)*(#menus+1)),tocolor(35, 35, 35, 255*alpha))
    dxDrawRectangle(sx*mx, sy*my, sx*0.13, sy*0.04, tocolor(30, 30, 30, 255*alpha))

    dxDrawText(text,sx*mx,sy*my,sx*mx+sx*0.13,sy*my+sy*0.04,tocolor(r,g,b,255*alpha),1/myX*sx,font2,"center","center", false, false, false, true)

    local starty = sy*my+sy*0.045

    for i = 1, #menus+1 do 

        local color = tocolor(30, 30, 30, 255*alpha) 
        local color2 = tocolor(r, g, b, 220*alpha) 

        if i % 2 == 0 then 
            color = tocolor(32, 32, 32, 255*alpha) 
            color2 = tocolor(r, g, b, 150*alpha) 
        end

        if i == #menus+1 then 
            dxDrawRectangle(sx*mx, starty, sx*0.13, sy*0.03, color)
            dxDrawRectangle(sx*mx, starty, sx*0.0015, sy*0.03, color2)
            if core:isInSlot(sx*mx,starty,sx*0.13,sy*0.03) then 
                dxDrawText("Bezárás",sx*mx,starty,sx*mx+sx*0.125,starty+sy*0.03,tocolor(204, 55, 45,255*alpha), 0.9/myX*sx,font1,"right","center")
                dxDrawImage(sx*mx+sx*0.008,starty+5/myY*sy, 14/myX*sx, 14/myY*sy,"files/close.png",0,0,0,tocolor(204, 55, 45,255*alpha))
            else
                dxDrawImage(sx*mx+sx*0.008,starty+5/myY*sy, 14/myX*sx, 14/myY*sy,"files/close.png",0,0,0,tocolor(255,255,255,255*alpha))
                dxDrawText("Bezárás",sx*mx,starty,sx*mx+sx*0.125,starty+sy*0.03,tocolor(255,255,255,255*alpha), 0.9/myX*sx,font1,"right","center")
            end
            starty = starty + sy*0.03
        else
            local v = menus[i]

            if v.title == "Inventory" then
                dxDrawRectangle(sx*mx, starty, sx*0.13, sy*0.06, color)
                dxDrawRectangle(sx*mx, starty, sx*0.0015, sy*0.06, color2)
                
                local items = getElementData(selectedElement, v.itemsElementData)

                local startX = sx*mx + sx*0.006
                for i = 1, 4 do 
                    dxDrawRectangle(startX, starty+sy*0.0075, 40/myX*sx, 40/myY*sy, tocolor(35, 35, 35, 255*alpha))

                    if items[i] then 
                        v = items[i]
                        if v[2] > 0 then 
                            dxDrawImage(startX, starty+sy*0.0075, 40/myX*sx, 40/myY*sy, inv:getItemImage(v[1]), 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
                            dxDrawText(v[2], startX, starty+sy*0.0075, startX+40/myX*sx, starty+sy*0.0075+40/myY*sy, tocolor(255, 255, 255, 200*alpha), 1/myX*sx, font2, "center", "center")
                        else
                            dxDrawImage(startX, starty+sy*0.0075, 40/myX*sx, 40/myY*sy, inv:getItemImage(v[1]), 0, 0, 0, tocolor(255, 255, 255, 100*alpha))
                        end
                    end

                    startX = startX + 50/myX*sx
                end

                starty = starty + sy*0.06
            elseif v.title == "Status" then 
                dxDrawText("Állapot:",sx*mx,starty,sx*mx+sx*0.125,starty+sy*0.02,tocolor(r,g,b,255*alpha), 0.9/myX*sx,font1,"center","center")
                starty = starty + sy*0.02
                dxDrawRectangle(sx*mx, starty, sx*0.13, sy*0.02, color)
                
                --dxDrawRectangle(sx*mx, starty, sx*0.0015, sy*0.02, color2)
                dxDrawRectangle(sx*mx+2.5, starty+2.5, sx*0.13*(getElementData(selectedElement, v.elementData)/100)-(5), sy*0.02-5, color2)
                dxDrawText(math.floor(getElementData(selectedElement, v.elementData)).."%",sx*mx,starty,sx*mx+sx*0.125,starty+sy*0.0228,tocolor(255,255,255,255*alpha), 0.9/myX*sx,font1,"center","center")

                starty = starty + sy*0.03
            else
                dxDrawRectangle(sx*mx, starty, sx*0.13, sy*0.03, color)
                dxDrawRectangle(sx*mx, starty, sx*0.0015, sy*0.03, color2)
                if core:isInSlot(sx*mx,starty,sx*0.13,sy*0.03) then 
                    dxDrawText(v.title,sx*mx,starty,sx*mx+sx*0.125,starty+sy*0.03,tocolor(r,g,b,255*alpha), 0.9/myX*sx,font1,"right","center")
                    dxDrawImage(sx*mx+sx*0.008,starty+3.5/myY*sy, 20/myX*sx, 20/myY*sy,"files/"..v.icon,0,0,0,tocolor(r, g, b, 255*alpha))
                else
                    dxDrawText(v.title,sx*mx,starty,sx*mx+sx*0.125,starty+sy*0.03,tocolor(255,255,255,255*alpha), 0.9/myX*sx,font1,"right","center")
                    dxDrawImage(sx*mx+sx*0.008,starty+3.5/myY*sy, 20/myX*sx, 20/myY*sy,"files/"..v.icon,0,0,0,tocolor(255, 255, 255, 255*alpha))
                end
                starty = starty + sy*0.03
            end
        end
    end
end

local lastelement

addEventHandler("onClientClick", root, 
    function(button, state, _, _, _, _, _, element)

        if element then 
            --createElementOutlineEffect(element, true)
            if button == "right" and state == "up" then
                if selectedElement then return end 
                
                if core:getDistance(localPlayer,element) < 4 then 
                    if getElementType(element) == "vehicle" then 
                        if element == getPedOccupiedVehicle(localPlayer) then return end
                        if element == localPlayer then return end
                        if getVehicleType(element) == "BMX" then return end
                        if getElementModel(element) == 572 then return end

                        utotag = ""
                        selectedElement = false

                        if lastelement then 
                            core:destroyOutline(lastelement)
                            lastelement = false
                        end
                        core:createOutline(element)

                        lastelement = element
                        
                        if not interaction then 
                            addEventHandler("onClientRender", root, render)
                            addEventHandler("onClientKey", root, panelkey)

                            showing = true
                        end

                        interaction = true
                        mx,my = getCursorPosition()
                        tick = getTickCount()
                        type = getElementType(element)

                        text = "Jármű"

                        local vehModel = getElementModel(element)

                        if vehModel == 611 then 
                            text = "Trailer"

                            menus = {{title = "Összeakasztás/Szétakasztás", icon = "girth.png", func = "AttachTrailer"}}
                        end                     

                        if not (nonTrunkVehicles[vehModel]) then 
                            menus = {{title = "Csomagtartó", icon = "csomagtarto.png", func = "openVehInv"}}
                        end

                        if getElementData(localPlayer,"char:duty:faction") == 1 then
                            if getElementData(element, "veh:isFactionVehice") == 0 then 
                                table.insert(menus, {title = "Kézifék kiengedése", icon = "girth.png", func = "handBrake"})
                            end
                        end  

                        if policeCars[vehModel] then 
                            text = "Rendőrautó"
                            if (policeCars[vehModel].stingerAllowed or false) then 
                                table.insert(menus, {title = "Szögesdrót kivétele", icon = "wire.png", func = "stingerOut"})
                                table.insert(menus, {title = "Traffipax kivétele", icon = "speedcam.png", func = "speedcamOut"})
                            end

                            if (policeCars[vehModel].rbsAllowed or false)then 
                                table.insert(menus, {title = "Roadblock kivétele", icon = "rbs.png", func = "showRBSPanel"})
                            end
                        end

                        if getElementData(localPlayer, "teslaChargerInHand") then 
                            if getElementData(element, "veh:fuelType") == "electric" then 
                                if not getElementData(element, "vehicleInTeslaCharger") then 
                                    table.insert(menus, {title = "Töltés", icon = "tesla.png", func = "addTeslaChargerToVeh"})
                                end
                            end
                        end

                        if getElementData(element, "vehicleInTeslaCharger") then 
                            if not getElementData(localPlayer, "teslaChargerInHand") then 
                                table.insert(menus, {title = "Levétel a töltőről", icon = "tesla.png", func = "removeTeslaChargerToVeh"})
                            end
                        end

                        if getElementModel(element) == 544 then 
                            if getElementData(element, "veh:ConnectedToFireHidrant") then 
                                table.insert(menus, {title = "Tömlő szétcsatlakoztatása", icon = "hose.png", func = "unConnectHoseFromVeh"})
                            else
                                table.insert(menus, {title = "Tömlő csatlakoztatása", icon = "hose.png", func = "connectHoseToVeh"})
                            end
                        end

                        if getElementModel(element) == 416 then 
                            if getElementData(element, "veh:isFactionVehice") == 1 then     
                                if getElementData(element, "veh:Stretcher") then 
                                    table.insert(menus, {title = "Hordágy kivétele", icon = "strecher.png", func = "strecher.CreateStrecher"})
                                else
                                    table.insert(menus, {title = "Hordágy visszarakása", icon = "strecher.png", func = "strecher.DeleteStrecher"})
                                end
                            end
                        end
                        
                        if getElementData(element, "veh:stealedCar") then
                            if getElementData(element, "veh:locked") then 
                                table.insert(menus, {title = "Jármű feltörés", icon = "strecher.png", func = "vehicleLockPick"})
                            end
                        end

                        checkNeed = true
                        selectedElement = element
                    elseif getElementType(element) == "object" then 
                        if getElementData(element, "pdIsRBS") then 
                            local pFaction = getElementData(localPlayer, "char:duty:faction") or 0

                            local allowed = false
                            if getElementData(localPlayer, "user:aduty") then
                                allowed = true
                                openType = "admin"
                            elseif (pFaction > 0 ) then 
                                if exports.oDashboard:getFactionType(pFaction or 0) == 1 or pFaction == 4 then 
                                    allowed = true
                                    openType = "player"
                                end
                            end

                            if allowed then 
                                text = "Roadblock"
                                utotag = ""
        
                                menus = {{title = "Felvétel", icon = "up.png", func = "pickUpRBS"}}
                            else
                                return
                            end
                        elseif getElementData(element, "isPlantPot") then 
                            text = "Cserép"
                            utotag = ""

                            menus = {
                                {title = "Felvétel", icon = "up.png", func = "pickUpPlantPot"},
                            }

                            if getElementData(element, "pot:plant") then 
                                table.insert(menus, {title = "Növény szüretelése", icon = "collect.png", func = "collectDrugPlant"})
                                table.insert(menus,  {title = "Locsolás", icon = "watering.png", func = "wateringPlant"})
                            else
                                table.insert(menus, {title = "Marihuana ültetése", icon = "marihuana.png", func = "plantMarijuana"})
                                table.insert(menus, {title = "Kokain ültetése", icon = "cocaine.png", func = "plantCocaine"})
                            end 
                        elseif getElementData(element, "fireHidrantObj") then
                            element = getElementData(element, "fireHidrantObj")
                            
                            text = "Tűzcsap"
                            utotag = ""
                            

                            if getElementData(localPlayer, "hoseInHand") then
                                menus = {
                                    {title = "Tömlő szétcsatlakoztatása", icon = "hose.png", func = "unConnectHose"},
                                }
                            else
                                menus = {
                                    {title = "Tömlő csatlakoztatása", icon = "hose.png", func = "connectHose"},
                                }
                            end

                        elseif getElementData(element, "strecher.isObject") then 
                            element = getElementData(element, "strecher.isObject")
                            text = "Hordágy"
                            utotag = ""
                            
                            if not getElementData(localPlayer, "strecher.objectAttached") then
                                if not getElementData(element, "stretcher.attachedPlayer") then
                                    menus = {{title = "Hordágy felvétele", icon = "strecher.png", func = "strecher.pickup"},{title = "Hordágyra felsegítés", icon = "strecher.png", func = "strecher.helpPlayerUp"}}
                                else
                                    menus = {{title = "Hordágy felvétele", icon = "strecher.png", func = "strecher.pickup"},{title = "Hordágyról lesegítés", icon = "strecher.png", func = "strecher.helpPlayerDown"}}
                                end
                            else
                                menus = {{title = "Hordágy lerakása", icon = "strecher.png", func = "strecher.dropDown"}} 
                            end
                        elseif getElementData(element, "isMechanicDolly") then 
                            if getElementData(localPlayer, "char:duty:faction") == exports.oFactionScripts:getMechanicFactionID() then 
                                if not getElementData(element, "dollyAttachedPlayer") then
                                    text = "Dolly"
                                    utotag = ""


                                        menus = {{title = "Dolly mozgatása", icon = "dolly.png", func = "dollyPickUp"}} 
                                else
                                    return
                                end
                            else
                                return 
                            end
                        elseif getElementData(element, "isOilDrum") then 
                            if getElementData(localPlayer, "char:duty:faction") == exports.oFactionScripts:getMechanicFactionID() then 
                                text = "Olajos Hordó "..getElementData(element,"drum:oilLevel").."%"
                                utotag = ""

                                if getElementData(element, "drum:inUse") then  
                                    menus = {{title = "Hordó lerakása", icon = "barrel.png", func = "drumTakeDown"}} 
                                else
                                    if getElementData(localPlayer, "dollyUsedByPlayer") then 
                                        dolly = getElementData(localPlayer,"dollyUsedByPlayer")
                                        if not getElementData(dolly,"dolly:useDrum") then 
                                            menus = {{title = "Hordó felvétele", icon = "barrel.png", func = "drumPickup"}} 
                                        end 
                                    end
                                end
                            end
                        elseif getElementData(element, "isFuelDrum") then 
                            if getElementData(localPlayer, "char:duty:faction") == exports.oFactionScripts:getMechanicFactionID() then 
                                text = "Üzemanyag Hordó "..getElementData(element,"drum:fuelLevel").."%"
                                utotag = ""

                                if getElementData(element, "Fueldrum:inUse") then  
                                    menus = {{title = "Hordó lerakása", icon = "barrel.png", func = "FueldrumTakeDown"}} 
                                else
                                    if getElementData(localPlayer, "dollyUsedByPlayer") then 
                                        dolly = getElementData(localPlayer,"dollyUsedByPlayer")
                                        if not getElementData(dolly,"dolly:useDrum") then 
                                            menus = {{title = "Hordó felvétele", icon = "barrel.png", func = "FueldrumPickup"}} 
                                        end 
                                    end
                                end
                            end
                        elseif getElementData(element, "isApiary") then 
                            menus = {}
                            --if getElementData(element, "apiary:owner") == getElementData(localPlayer, "char:id") then
                                status = "Nyitva"
                                if getElementData(element, "apiary:locked") == 1 then 
                                    status = "Zárva"
                                else
                                    status = "Nyitva"
                                end
                                text = "Kaptár (" .. status ..")"
                                utotag = ""
                                if getElementData(element, "apiary:haveBee") == "N" then 
                                    table.insert(menus, {title = "Méhcsalád vásárlása", icon = "collect.png", func = "apiaryBeeBuy"})
                                elseif getElementData(element, "apiary:haveBee") == "Y" then 
                                    table.insert(menus, {title = "Status", icon = "collect.png", func = "", elementData = "apiary:health"})
                                    table.insert(menus, {title = "Méz begyűjtése", icon = "collect.png", func = "apiaryCollect"})
                                    table.insert(menus, {title = "Kaptár tisztítása", icon = "collect.png", func = "apiaryCleaning"})
                                end
                                if getElementData(element, "apiary:locked") == 1 then 
                                    table.insert(menus, {title = "Kaptár nyitása", icon = "collect.png", func = "apiaryLockedHandler"})
                                else
                                    table.insert(menus, {title = "Kaptár zárása", icon = "collect.png", func = "apiaryLockedHandler"})
                                end
                                table.insert(menus, {title = "Kaptár felvétele", icon = "collect.png", func = "apiaryUp"})
                           -- else 
                              --  outputChatBox("Nem te vagy a tulaja")
                            --end
                        elseif getElementData(element, "garageBid:pickupObject:loottable") then 
                            menus = {}
                            text = getElementData(element, "garageBid:pickupObject:name")
                            utotag = ""
                            table.insert(menus, {title = "Tárgyak keresése", icon = "frisk.png", func = "garageBidSearch"})
                        else
                            return
                        end

                        selectedElement = false
    
                        if lastelement then 
                            core:destroyOutline(lastelement)
                            lastelement = false
                        end
                        core:createOutline(element)

                        lastelement = element

                        if not interaction then 
                            --removeEventHandler("onClientRender", root, render)
                            addEventHandler("onClientRender", root, render)
                            addEventHandler("onClientKey", root, panelkey)

                            showing = true
                        end 

                        interaction = true
                        mx,my = getCursorPosition()
                        tick = getTickCount()
                        type = getElementType(element)

                        checkNeed = true
                        selectedElement = element
                    elseif getElementType(element) == "player" then 
                        if core:getDistance(localPlayer,element) < 2 then 
                            if element == localPlayer then return end
                            text = getPlayerName(element):gsub("_", " ")
                            utotag = ""
                            selectedElement = false

                            if lastelement then 
                                core:destroyOutline(lastelement)
                                lastelement = false
                            end
                            core:createOutline(element)

                            lastelement = element
                            selectedElement = element
                            
                            if not interaction then 
                                addEventHandler("onClientRender", root, render)
                                addEventHandler("onClientKey", root, panelkey)

                                showing = true
                            end

                            interaction = true
                            mx,my = getCursorPosition()
                            tick = getTickCount()
                            type = getElementType(element)

                            local pFaction = getElementData(localPlayer, "char:duty:faction") or 0

                            local allowed = false
                            if getElementData(localPlayer, "user:aduty") then
                                allowed = true
                                openType = "admin"
                            elseif (pFaction > 0 ) then 
                                if exports.oDashboard:getFactionType(pFaction or 0) == 1 or exports.oDashboard:getFactionType(pFaction or 0) == 2 then 
                                    allowed = true
                                    openType = "player"
                                end
                            end

                            menus = {{title = "Felsegítés", icon = "felsegit.png", func = "revivificationPlayer"}}
                            if allowed then
                                if getElementData(selectedElement, "cuff:cuffed") then
                                    table.insert(menus, {title = "Bilincs leszedése", icon = "cuff.png", func = "unCuffPlayer"})

                                    if selectedElement == (getElementData(localPlayer, "carry:carryedPlayer") or false) then 
                                        table.insert(menus, {title = "Elenged", icon = "grab.png", func = "unleashPlayer"})
                                    else
                                        table.insert(menus, {title = "Visz", icon = "grab.png", func = "grabPlayer"})
                                    end
                                else    
                                    table.insert(menus, {title = "Megbilincselés", icon = "cuff.png", func = "cuffPlayer"})
                                end
                                table.insert(menus, {title = "Szondáztatás", icon = "probe.png", func = "alcoholsonda"})
                                table.insert(menus, {title = "Járműbe segítés", icon = "csomagtarto.png", func = "vehicledetain"})
                                table.insert(menus, {title = "Vértasak használata", icon = "felsegit.png", func = "useblood"})
                                table.insert(menus, {title = "Sérülések vizsgálata", icon = "felsegit.png", func = "checkHit"})
                            end

                            table.insert(menus, {title = "Motozás", icon = "frisk.png", func = "friskPlayer"})
                            
                            if not getElementData(element,"player:bag") then 
                                table.insert(menus, {title = "Zsák húzás a fejére", icon = "bag.png", func = "bagPlayer"})
                                
                            else

                                if selectedElement == (getElementData(localPlayer, "carry:carryedPlayer") or false) then 
                                    table.insert(menus, {title = "Elenged", icon = "grab.png", func = "unleashPlayer"})
                                else
                                    table.insert(menus, {title = "Visz", icon = "grab.png", func = "grabPlayer"})
                                --    table.insert(menus, {title = "Járműbe rakás", icon = "csomagtarto.png", func = "vehicledetain"})
                                end

                                table.insert(menus, {title = "Zsák levétele", icon = "bag.png", func = "removeBagPlayer"})
                            end 

                            checkNeed = true
                            selectedElement = element
                        end
                    elseif getElementType(element) == "ped" then 
                        if getElementData(element, "animal:diedAnimal") then 
                           --if getElementHealth(element) <= 0 then
                                text = getElementData(element, "ped:name")
                                utotag = ""
                                selectedElement = false
        
                                if lastelement then 
                                    core:destroyOutline(lastelement)
                                    lastelement = false
                                end
                                core:createOutline(element)
        
                                lastelement = element
                                selectedElement = element
                                
                                if not interaction then 
                                    addEventHandler("onClientRender", root, render)
                                    addEventHandler("onClientKey", root, panelkey)

                                    showing = true
                                end
        
                                interaction = true
                                mx,my = getCursorPosition()
                                tick = getTickCount()
                                type = getElementType(element)
        
                                menus = {
                                    {title = "Inventory", icon = "rbs.png", func = "", itemsElementData = "animal:loot"},
                                    {title = "Trófea készítése", icon = "bear.png", func = "createAnimalTrophy"},
                                    {title = "Megnyúzás", icon = "leather.png", func = "animalSkin"},
                                }

                                checkNeed = true
                                selectedElement = element
                            --end 
                        elseif getElementData(element,"pet") then 
                            text = getElementData(element, "ped:name").." [Kisállat]"
                                utotag = ""
                                selectedElement = false
        
                                if lastelement then 
                                    core:destroyOutline(lastelement)
                                    lastelement = false
                                end
                                core:createOutline(element)
        
                                lastelement = element
                                selectedElement = element
                                
                                if not interaction then 
                                    addEventHandler("onClientRender", root, render)
                                    addEventHandler("onClientKey", root, panelkey)

                                    showing = true
                                end
        
                                interaction = true
                                mx,my = getCursorPosition()
                                tick = getTickCount()
                                type = getElementType(element)
        
                                menus = {
                                    {title = "Sebek ellátása", icon = "felsegit.png", func = "revivePet", element = element},
                                    {title = "Etetés Vegán Táppal", icon = "dogfood.png", func = "feedPet", element = element, foodType = 1},
                                    {title = "Etetés Marhahúsos Táppal", icon = "dogfood.png", func = "feedPet", element = element, foodType = 2},
                                    {title = "Etetés Sertéshúsos Táppal", icon = "dogfood.png", func = "feedPet", element = element, foodType = 3},
                                    {title = "Etetés Csírkehúsos Táppal", icon = "dogfood.png", func = "feedPet", element = element, foodType = 4},
                                    {title = "Itatás", icon = "dogdrink.png", func = "wateringPet", element = element},
                                }

                                if getElementData(element,"pet:owner") == getElementData(localPlayer,"user:id") then
                                    if getElementData(element,"petIsIdle") then 
                                        table.insert(menus, {title = "Követ", icon = "grab.png", func = "setPetIdle", element = element})
                                    else 
                                        table.insert(menus, {title = "Marad", icon = "grab.png", func = "setPetIdle", element = element})
                                    end 
                                end

                                checkNeed = true
                                selectedElement = element
                        end
                    else
                        closePanel()
                    end
                end
            else
                --closePanel()
            end
        end
    end 
)

function panelkey(key, state)
    if showing then 
        if key == "mouse1" then 
            if state then 
                local starty = sy*my+sy*0.045
                for i = 1, #menus+1 do 
                    if i == #menus+1 then 
                        if core:isInSlot(sx*mx,starty,sx*0.13,sy*0.03) then 
                            closePanel()
                        end

                        starty = starty + sy*0.03
                    else
                        local v = menus[i]
                       -- if not (v.title == "Inventory") then 
                            if core:isInSlot(sx*mx,starty,sx*0.13,sy*0.03) then 
                                if not (v.title == "Inventory" or v.title == "Status") then 
                                    if selectedElement then 
                                        useButton(v)
                                        closePanel() 
                                    end
                                end
                            end
                        --end

                        if v.title == "Inventory" then 
                            starty = starty + sy*0.06
                        elseif v.title == "Status" then 
                            starty = starty + sy*0.05
                        else
                            starty = starty + sy*0.03
                        end
                    end
                end
            end
        end
    end
end

function closePanel()
    core:destroyOutline(lastelement)
    tick = getTickCount()
    interaction = false
    showing = false

    removeEventHandler("onClientKey", root, panelkey)

    setTimer(function() 
        removeEventHandler("onClientRender", root, render) 
        selectedElement = false
    end, animTime, 1)
end


function doAmbulanceBedPlacePlayer(element)

end