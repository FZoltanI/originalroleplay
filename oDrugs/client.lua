local _dxDrawImage = dxDrawImage
local textures = {}
local function dxDrawImage(x, y, w, h, image, rot, rotX, rotY, color)
    if type(image) == "string" then 
        if not textures[image] then 
            textures[image] = dxCreateTexture(image, "dxt5", true)
        end

        image = textures[image]
    end
    _dxDrawImage(x, y, w, h, image, rot, rotX, rotY, color)
end

sx, sy = guiGetScreenSize()
myX, myY = 1600, 900
local activeDrugEffect = {nil, nil}

addEventHandler("onClientResourceStart", resourceRoot, function()
    resetGameValues()
end)

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oFont" or getResourceName(res) == "oDrugs" or getResourceName(res) == "oInventory" then  
        core = exports.oCore
        color, r, g, b = core:getServerColor()
        font = exports.oFont
        inventory = exports.oInventory
	end
end)

local useInProgress = false

function useDrug(drug)
    if useInProgress then return false end

    useInProgress = true
    if drug == "cocaine" then 
        setGameSpeed(math.random(70, 90)/100)
        activeDrugEffect = {"files/effects/1.png", {245, 206, 66}, {245, 78, 66}, getTickCount(), core:minToMilisec(math.random(5, 10))}
        addEventHandler("onClientRender", root, renderDrugEffect)

        local armor = getPlayerArmor(localPlayer)
        triggerServerEvent("drug > addArmor", resourceRoot, armor + math.random(35, 55))
    elseif drug == "joint" then 
        setGameSpeed(math.random(50, 80)/100)
        activeDrugEffect = {"files/effects/2.png", {135, 189, 94}, {58, 201, 14}, getTickCount(), core:minToMilisec(math.random(5, 10))}
        addEventHandler("onClientRender", root, renderDrugEffect)

        local armor = getPlayerArmor(localPlayer)
        triggerServerEvent("drug > addArmor", resourceRoot, armor + math.random(15, 25))
    elseif drug == "heroin" then 
        setGameSpeed(math.random(50, 75)/100)
        activeDrugEffect = {"files/effects/4.png", {168, 129, 50}, {133, 50, 168}, getTickCount(), core:minToMilisec(math.random(7, 12))}
        addEventHandler("onClientRender", root, renderDrugEffect)

        local armor = getPlayerArmor(localPlayer)
        triggerServerEvent("drug > addArmor", resourceRoot, armor + math.random(20, 30))
    elseif drug == "marihuana" then 
        setGameSpeed(math.random(70, 90)/100)
        activeDrugEffect = {"files/effects/1.png", {245, 206, 66}, {245, 78, 66}, getTickCount(), core:minToMilisec(math.random(4, 8))}
        addEventHandler("onClientRender", root, renderDrugEffect)

        local armor = getPlayerArmor(localPlayer)
        triggerServerEvent("drug > addArmor", resourceRoot, armor + math.random(10, 20))
    elseif drug == "speed" then 
        setGameSpeed(1.2)

        activeDrugEffect = {"files/effects/2.png", {0, 0, 0}, {30, 30, 30}, getTickCount(), core:minToMilisec(math.random(3, 4))}
        addEventHandler("onClientRender", root, renderDrugEffect)
    end

    return true
end

function renderDrugEffect()
    local alpha = interpolateBetween(1, 0, 0, 0, 0, 0, (getTickCount()-activeDrugEffect[4])/activeDrugEffect[5], "Linear")

    exports.oBlur:createBlur(0, 0, sx, sy, 255*alpha, 1)

    local r, g, b = interpolateBetween(activeDrugEffect[2][1], activeDrugEffect[2][2], activeDrugEffect[2][3], activeDrugEffect[3][1], activeDrugEffect[3][2], activeDrugEffect[3][3], (getTickCount()-activeDrugEffect[4])/5000, "CosineCurve")
    dxDrawImage(0, 0, sx, sy, activeDrugEffect[1], 0, 0, 0, tocolor(r, g, b, 255*alpha))

    if alpha <= 0.001 then 
        resetGameValues()
        useInProgress = false 
        removeEventHandler("onClientRender", root, renderDrugEffect)
    end
end

function resetGameValues()    
    setGameSpeed(1)
    setGravity(0.008)
end

-- Drogtermesztés 

local growingPlants = {}

local renderNeededPlants = {}
local renderNeededTables = {}

addEventHandler("onClientElementDataChange", resourceRoot, function(data, old, new)
    if data == "pot:plant" then 
        if new then 
            growingPlants[source] = source

            table.insert(renderNeededPlants, source)

            if #renderNeededPlants == 1 then 
                addEventHandler("onClientRender", root, renderGrowingPlantsDatas)
            end
        else
            growingPlants[source] = false
        end
    end
end)   

addEventHandler("onClientElementDestroy", resourceRoot, function()
    if growingPlants[source] then 
        growingPlants[source] = false
    end

    for k, v in ipairs(renderNeededPlants) do 
        if source == v then 
            table.remove(renderNeededPlants, k)
            break
        end
    end

    for k, v in ipairs(renderNeededTables) do 
        if source == v then 
            table.remove(renderNeededTables, k)
            break
        end
    end
end)   

addEventHandler("onClientResourceStart", resourceRoot, function()
    for k, v in ipairs(getElementsByType("object")) do 
        if getElementModel(v) == 2203 then 
            if getElementData(v, "pot:plant") then 
                if not growingPlants[v] then growingPlants[v] = v end
            end
        end
    end
end)


local plantBars = {
    {"pot:plant:growLevel", {112, 181, 85}},
    {"pot:plant:waterLevel", {104, 171, 237}},
    {"pot:plant:qualityLevel", {235, 200, 61}},
}

local itemSize = 0.2

addEventHandler("onClientElementStreamIn", root, function()
    if growingPlants[source] then 
        table.insert(renderNeededPlants, source)

        if #renderNeededPlants == 1 then 
            addEventHandler("onClientRender", root, renderGrowingPlantsDatas)
        end

    elseif getElementModel(source) == drugCraftTableModel then 
        table.insert(renderNeededTables, source)

        if #renderNeededTables == 1 then 
            addEventHandler("onClientRender", root, renderDrugCraftTables)
            addEventHandler("onClientKey", root, keyDrugCraft)
        end
    end
end)

addEventHandler("onClientElementStreamOut", root, function()
    if growingPlants[source] then 
        for k, v in ipairs(renderNeededPlants) do 
            if v == source then 
                table.remove(renderNeededPlants, k)
                break
            end
        end

        if #renderNeededPlants == 0 then 
            removeEventHandler("onClientRender", root, renderGrowingPlantsDatas)
        end

    elseif getElementModel(source) == drugCraftTableModel then 
        for k, v in ipairs(renderNeededTables) do 
            if v == source then 
                table.remove(renderNeededTables, k)
                break
            end
        end

        if #renderNeededTables == 0 then 
            removeEventHandler("onClientRender", root, renderDrugCraftTables)
            removeEventHandler("onClientKey", root, keyDrugCraft)
        end
    end
end)

function renderGrowingPlantsDatas()
    for k, v in pairs(renderNeededPlants) do 
        if v then 
            --local scale = interpolateBetween(0, 0, 0, 0.8, 0, 0, (getTickCount()-v[3])/v[2], "Linear") 

            --setObjectScale(k, scale)

            if isElement(v) then 
                if getElementInterior(v) == getElementInterior(localPlayer) and getElementDimension(v) == getElementDimension(localPlayer) then
                    if core:getDistance(v, localPlayer) < 3 then 
                        local x, y = getScreenFromWorldPosition(getElementPosition(v))

                        if x and y then 
                            y = y - sy*0.1

                            for k2, v2 in ipairs(plantBars) do 
                                dxDrawRectangle(x - sx*0.1/2, y, sx*0.1, sy*0.015, tocolor(35, 35, 35, 255))

                                local r, g, b = unpack(v2[2])
                                dxDrawRectangle(x - sx*0.1/2 + sx*0.002, y + sy*0.003, sx*0.1 - sx*0.004, sy*0.015 - sy*0.006, tocolor(r, g, b, 150))
                                dxDrawRectangle(x - sx*0.1/2 + sx*0.002, y + sy*0.003, (sx*0.1 - sx*0.004) * (getElementData(v, v2[1]) or 0), sy*0.015 - sy*0.006, tocolor(r, g, b, 255))

                                y = y + sy*0.02
                            end
                        end
                    end
                end
            end
        end
    end
end

function renderDrugCraftTables()
    for k, v in ipairs(renderNeededTables) do 
        local x, y, z = getElementPosition(v)

        local dxX, dxY = getScreenFromWorldPosition(core:getPositionFromElementOffset(v, 1.1, 0.2, 1.065))

        local selectedCraft = getElementData(v, "drug:craft:selectedCraft") or 0
        local craftItems = getElementData(v, "drug:craft:tableItems") or {}

        local existCraftItems = 0

            if selectedCraft > 0 then 
                for k2, v2 in ipairs(crafts[selectedCraft].items) do 
                    local  x, y, z = core:getPositionFromElementOffset(v, -0.55 + (k2*itemSize), 0.2, 1.065)

                    local rotX, rotY, rotZ = getElementRotation(v)
                    local faceX, faceY, faceZ = core:getPositionFromElementOffset(v, -0.55 + (k2*itemSize), 0-itemSize/2 + 0.07, 1.065)

                    local itemExist = false 
                    for k3, v3 in ipairs(craftItems) do 
                        if v3[1] == v2 then 
                            itemExist = true 
                            existCraftItems = existCraftItems + 1
                            break
                        end 
                    end

                    local alpha = 100 
                    if itemExist then alpha = 255 end 
                    dxDrawMaterialLine3D(x, y, z, faceX, faceY, z, inventory:getItemImageTexture(v2), itemSize, tocolor(255, 255, 255, alpha), false, faceX, faceY, 9999)
                end
            end

        if not getElementData(v, "drug:craft:inUse") then
            if dxX and dxY then 
                local distance = (core:getDistance(localPlayer, v) / 3)
                --print(distance)
                
                if distance <= 1 then 
                    distance = (1 - distance) + 0.4
                    distance = math.min(distance, 1)

                    if getElementData(localPlayer, "user:aduty") then 
                        core:dxDrawShadowedText("DBID: #"..(getElementData(v, "drug:craftTableID") or 0), dxX-sx*0.05*distance, dxY-sy*0.07*distance, dxX-sx*0.05*distance+sx*0.1*distance, dxY-sy*0.07*distance+sy*0.03*distance, tocolor(255, 0, 0, 255*distance), tocolor(0, 0, 0, 255*distance), 0.7*distance, font:getFont("condensed", 15/myX*sx), "center", "center") 
                    end
                    --dxDrawRectangle(dxX-sx*0.05*distance, dxY, sx*0.1*distance, sy*0.03*distance, tocolor(r, g, b, 150*distance))
                    if core:isInSlot(dxX-sx*0.05*distance, dxY, sx*0.05*distance, sy*0.03*distance) then 
                        core:dxDrawShadowedText("Előző", dxX-sx*0.05*distance, dxY, dxX-sx*0.05*distance+sx*0.1*distance, dxY+sy*0.03*distance, tocolor(r, g, b, 255*distance), tocolor(0, 0, 0, 255*distance), 0.8*distance, font:getFont("condensed", 15/myX*sx), "left", "center")
                    else 
                        core:dxDrawShadowedText("Előző", dxX-sx*0.05*distance, dxY, dxX-sx*0.05*distance+sx*0.1*distance, dxY+sy*0.03*distance, tocolor(255, 255, 255, 255*distance), tocolor(0, 0, 0, 255*distance), 0.8*distance, font:getFont("condensed", 15/myX*sx), "left", "center")
                    end

                    if core:isInSlot(dxX-sx*0.05*distance+sx*0.05*distance, dxY, sx*0.05*distance, sy*0.03*distance) then 
                        core:dxDrawShadowedText("Következő", dxX-sx*0.05*distance, dxY, dxX-sx*0.05*distance+sx*0.1*distance, dxY+sy*0.03*distance, tocolor(r, g, b, 255*distance), tocolor(0, 0, 0, 255*distance), 0.8*distance, font:getFont("condensed", 15/myX*sx), "right", "center")
                    else
                        core:dxDrawShadowedText("Következő", dxX-sx*0.05*distance, dxY, dxX-sx*0.05*distance+sx*0.1*distance, dxY+sy*0.03*distance, tocolor(255, 255, 255, 255*distance), tocolor(0, 0, 0, 255*distance), 0.8*distance, font:getFont("condensed", 15/myX*sx), "right", "center")
                    end
                    --dxDrawRectangle(dxX-sx*0.05*distance+sx*0.05*distance, dxY, sx*0.05*distance, sy*0.03*distance)
                    --core:dxDrawShadowedText("Következő", dxX-sx*0.05*distance, dxY, dxX-sx*0.05*distance+sx*0.1*distance, dxY+sy*0.03*distance, tocolor(255, 255, 255, 255*distance), tocolor(0, 0, 0, 255*distance), 0.8*distance, font:getFont("condensed", 15/myX*sx), "right", "center")

                    local craftText 
                    if selectedCraft > 0 then 
                        craftText = crafts[selectedCraft].name or "Ismeretlen"
                    else
                        craftText = "Nincs kiválasztva recepet"
                    end

                    core:dxDrawShadowedText("Kiválasztott recept:", dxX-sx*0.05*distance, dxY-sy*0.05*distance, dxX-sx*0.05*distance+sx*0.1*distance, dxY+sy*0.03*distance-sy*0.05*distance, tocolor(255, 255, 255, 255*distance), tocolor(0, 0, 0, 255*distance), 1*distance, font:getFont("condensed", 15/myX*sx), "center", "center")
                    core:dxDrawShadowedText(craftText, dxX-sx*0.05*distance, dxY-sy*0.025*distance, dxX-sx*0.05*distance+sx*0.1*distance, dxY+sy*0.03*distance-sy*0.025*distance, tocolor(r, g, b, 255*distance), tocolor(0, 0, 0, 255*distance), 0.9*distance, font:getFont("condensed", 15/myX*sx), "center", "center")

                    if #craftItems > 0 then 
                        core:dxDrawShadowedText("Asztal tartalma:", dxX-sx*0.05*distance, dxY+sy*0.03*distance, dxX-sx*0.05*distance+sx*0.1*distance, dxY+sy*0.03*distance+sy*0.03*distance, tocolor(255, 255, 255, 255*distance), tocolor(0, 0, 0, 255*distance), 1*distance, font:getFont("condensed", 15/myX*sx), "center", "center")

                        local startX = dxX- (#craftItems * sx*0.012)*distance
                        for k2, v2 in ipairs(craftItems) do 
                            dxDrawImage(startX, dxY+sy*0.065*distance, 35/myX*sx*distance, 35/myY*sy*distance, inventory:getItemImage(v2[1]), 0, 0, 0, tocolor(255, 255, 255, 255*distance))

                            if core:isInSlot(startX, dxY+sy*0.065*distance, 35/myX*sx*distance, 35/myY*sy*distance) then 
                                core:dxDrawShadowedText("X", startX, dxY+sy*0.065*distance, startX+35/myX*sx*distance, dxY+sy*0.065*distance+35/myY*sy*distance, tocolor(255, 0, 0, 200*distance), tocolor(0, 0, 0, 200*distance), 1*distance, font:getFont("condensed", 15/myX*sx), "center", "center")
                            else
                                core:dxDrawShadowedText(v2[2], startX, dxY+sy*0.065*distance, startX+35/myX*sx*distance, dxY+sy*0.065*distance+35/myY*sy*distance, tocolor(255, 255, 255, 200*distance), tocolor(0, 0, 0, 200*distance), 0.8*distance, font:getFont("condensed", 15/myX*sx), "center", "center")
                            end

                            startX = startX + 37/myX*sx*distance
                        end


                        if selectedCraft > 0 then 
                            if existCraftItems >= #crafts[selectedCraft].items then 
                                if core:isInSlot(dxX-sx*0.05*distance, dxY+sy*0.11*distance, sx*0.1*distance, sy*0.03*distance) then 
                                    core:dxDrawShadowedText("Elkészítés", dxX-sx*0.05*distance, dxY+sy*0.11*distance, dxX-sx*0.05*distance+sx*0.1*distance, dxY+sy*0.11*distance+sy*0.03*distance, tocolor(r, g, b, 255*distance), tocolor(0, 0, 0, 255*distance), 0.8*distance, font:getFont("condensed", 15/myX*sx), "center", "center")
                                else
                                    core:dxDrawShadowedText("Elkészítés", dxX-sx*0.05*distance, dxY+sy*0.11*distance, dxX-sx*0.05*distance+sx*0.1*distance, dxY+sy*0.11*distance+sy*0.03*distance, tocolor(255, 255, 255, 255*distance), tocolor(0, 0, 0, 255*distance), 0.8*distance, font:getFont("condensed", 15/myX*sx), "center", "center")
                                end
                            else
                                core:dxDrawShadowedText("Elkészítés", dxX-sx*0.05*distance, dxY+sy*0.11*distance, dxX-sx*0.05*distance+sx*0.1*distance, dxY+sy*0.11*distance+sy*0.03*distance, tocolor(255, 255, 255, 150*distance), tocolor(0, 0, 0, 255*distance), 0.8*distance, font:getFont("condensed", 15/myX*sx), "center", "center")
                            end
                        end
                    else
                        core:dxDrawShadowedText("Az asztal üres!", dxX-sx*0.05*distance, dxY+sy*0.03*distance, dxX-sx*0.05*distance+sx*0.1*distance, dxY+sy*0.03*distance+sy*0.03*distance, tocolor(245, 66, 66, 255*distance), tocolor(0, 0, 0, 255*distance), 0.9*distance, font:getFont("condensed", 15/myX*sx), "center", "center")
                    end
                end
            end
        end
    end
end

local activeSelectedCraft = 0
local activeCraftTable = false

function keyDrugCraft(key, state)
    if key == "mouse1" and state then 
        for k, v in ipairs(getElementsByType("object")) do 
            if getElementModel(v) == 2132 then 
                if activeCraftTable or getElementData(v, "drug:craft:inUse") then 
                    return 
                end

                local x, y, z = getElementPosition(v)
    
                local dxX, dxY = getScreenFromWorldPosition(core:getPositionFromElementOffset(v, 1.1, 0.2, 1.065))
    
                local selectedCraft = getElementData(v, "drug:craft:selectedCraft") or 0 
                local craftItems = getElementData(v, "drug:craft:tableItems") or {}

                local existCraftItems = 0    

                if selectedCraft > 0 then 
                    for k2, v2 in ipairs(crafts[selectedCraft].items) do 
                        for k3, v3 in ipairs(craftItems) do 
                            if v3[1] == v2 then 
                                existCraftItems = existCraftItems + 1
                                break
                            end 
                        end
                    end
                end
    
                if dxX and dxY then 
                    local distance = (core:getDistance(localPlayer, v) / 3)
                    
                    if distance <= 1 then 
                        distance = (1 - distance) + 0.4
                        distance = math.min(distance, 1)

                        if core:isInSlot(dxX-sx*0.05*distance, dxY, sx*0.05*distance, sy*0.03*distance) then 
                            if selectedCraft > 1 then 
                                setElementData(v, "drug:craft:selectedCraft", selectedCraft-1)
                            else
                                setElementData(v, "drug:craft:selectedCraft", #crafts)
                            end
                        end

                        if core:isInSlot(dxX-sx*0.05*distance+sx*0.05*distance, dxY, sx*0.05*distance, sy*0.03*distance) then     
                            if selectedCraft < #crafts then 
                                setElementData(v, "drug:craft:selectedCraft", selectedCraft+1)
                            else
                                setElementData(v, "drug:craft:selectedCraft", 1)
                            end
                        end
    
                        local craftItems = getElementData(v, "drug:craft:tableItems")

                        if #craftItems > 0 then 
                            local startX = dxX- (#craftItems * sx*0.012)*distance
                            for k2, v2 in ipairs(craftItems) do     
                                if core:isInSlot(startX, dxY+sy*0.065*distance, 35/myX*sx*distance, 35/myY*sy*distance) then 
                                    if inventory:getAllItemWeight() + (inventory:getItemWeight(v2[1])*v2[2]) <= 20 then 
                                        inventory:giveItem(v2[1], 1, v2[2], 0)
                                        table.remove(craftItems, k2)
                                        setElementData(v, "drug:craft:tableItems", craftItems)
                                    else
                                        outputChatBox(core:getServerPrefix("red-dark", "Drog készítés", 3).."Nincs elég hely az inventorydban!", 255, 255, 255, true)
                                    end
                                end
        
                                startX = startX + 37/myX*sx*distance
                            end

                            if selectedCraft > 0 then 
                                if existCraftItems >= #crafts[selectedCraft].items then 
                                    if core:isInSlot(dxX-sx*0.05*distance, dxY+sy*0.11*distance, sx*0.1*distance, sy*0.03*distance) then 
                                        local allowed = exports.oDashboard:isPlayerFactionTypeMember({4, 5}) 

                                        if allowed then 
                                            if inventory:getAllItemWeight() + (inventory:getItemWeight(crafts[selectedCraft].endItem[1])*crafts[selectedCraft].endItem[2]) <= 20 then 

                                                for k2, v2 in ipairs(crafts[selectedCraft].items) do 
                                                    for k3, v3 in ipairs(craftItems) do 
                                                        if v3[1] == v2 then 
                                                            if v3[2] == 1 then 
                                                                table.remove(craftItems, k3)
                                                            else
                                                                v3[2] = v3[2] - 1
                                                            end
                                                        end
                                                    end
                                                end

                                                setElementData(v, "drug:craft:tableItems", craftItems)
                                                activeSelectedCraft = selectedCraft
                                                setElementData(v, "drug:craft:inUse", true)
                                                activeCraftTable = v

                                                triggerServerEvent("drug > setPedAnimationServer", resourceRoot, "shop", "shp_serve_loop")
                                                exports.oMinigames:createMinigame(1, 25, 48500, "drugcraft > endDrogCraft > success", "drugcraft > endDrogCraft > unSuccess")
                                            else
                                                outputChatBox(core:getServerPrefix("red-dark", "Drog készítés", 3).."Nincs elég hely az inventorydban!", 255, 255, 255, true)
                                            end
                                        else
                                            outputChatBox(core:getServerPrefix("red-dark", "Drog készítés", 3).."Nem vagy illegális szervezet tagja!", 255, 255, 255, true)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

addEvent("drugcraft > endDrogCraft > success", true)
addEventHandler("drugcraft > endDrogCraft > success", root, function()
    triggerServerEvent("drug > setPedAnimationServer", resourceRoot, "", "")
    exports.oInfobox:outputInfoBox("Sikeresen elkészítetted a kiválasztott drogot!", "success")

    inventory:giveItem(crafts[activeSelectedCraft].endItem[1], 1, crafts[activeSelectedCraft].endItem[2], 0)
    outputChatBox(core:getServerPrefix("green-dark", "Drog készítés", 3).."Készítettél "..color..crafts[activeSelectedCraft].endItem[2].."#ffffffdb "..color..inventory:getItemName(crafts[activeSelectedCraft].endItem[1]).."#ffffff-(e)t.", 255, 255, 255, true)
    exports.oChat:sendLocalMeAction("készített "..crafts[activeSelectedCraft].endItem[2].."db "..inventory:getItemName(crafts[activeSelectedCraft].endItem[1]).."-(e)t.")

    setElementData(activeCraftTable, "drug:craft:inUse", false)

    activeSelectedCraft = 0
    activeCraftTable = false
end)

addEvent("drugcraft > endDrogCraft > unSuccess", true)
addEventHandler("drugcraft > endDrogCraft > unSuccess", root, function()
    triggerServerEvent("drug > setPedAnimationServer", resourceRoot, "", "")
    exports.oInfobox:outputInfoBox("Nem sikerült elkészítened a kiválasztott drogot!", "error")
    exports.oChat:sendLocalDoAction("nem sikerült elkészítenie a drogot.")

    setElementData(activeCraftTable, "drug:craft:inUse", false)

    activeSelectedCraft = 0
    activeCraftTable = false
end)

function collectPlant(id, qualityLevel, potObj)
    local plant = drugPlants[id]
    local allItemWeight = 0
    local givedItems = {}

    for k, v in ipairs(plant.givedItems) do 
        local count = v[2]*qualityLevel
        count = math.floor(count)

        allItemWeight = allItemWeight + inventory:getItemWeight(v[1])*count

        if count >= 1 then 
            table.insert(givedItems, {v[1], count})
        end
    end

    if inventory:getAllItemWeight() + allItemWeight <= 20 then 
        for k, v in ipairs(givedItems) do  
            outputChatBox(core:getServerPrefix("server", "Drog", 2).."Kaptál "..color..v[2].."#ffffffdb "..color..inventory:getItemName(v[1]).."#ffffff-(e)t.", 255, 255, 255, true)
            setTimer(function() 
                inventory:giveItem(v[1], 1, v[2], 0)
            end, 50*k, 1)
        end
        triggerServerEvent("drugs > destroyPlant", resourceRoot, potObj)
    else
        outputChatBox(core:getServerPrefix("red-dark", "Szüretelés", 3).."Nincs nálad elég hely a növény szüreteléséhez!", 255, 255, 255, true)
    end
end

function addItemToCraftTable(obj, itemID, itemCount)
    if craftAllowedItems[itemID] then 
        local tableItems = getElementData(obj, "drug:craft:tableItems")

        if #tableItems < 5 then 
            local exist = false 

            for k, v in ipairs(tableItems) do 
                if v[1] == itemID then 
                    exist = k 
                    break
                end
            end

            if exist then 
                tableItems[exist][2] = tableItems[exist][2]+itemCount
            else
                table.insert(tableItems, {itemID, itemCount})
            end

            setElementData(obj, "drug:craft:tableItems", tableItems)
            return true
        else
            outputChatBox(core:getServerPrefix("red-dark", "Drog készítés", 3).."Nem fér több alapanyag az asztalba!", 255, 255, 255, true)
            return false  
        end
    else
        return false 
    end
end

-- Modell load 
--engineImportTXD(engineLoadTXD("files/models/marijuana.txd"), 16134)
--engineReplaceModel(engineLoadDFF("files/models/marijuana.dff"), 16134)

--Admin help
--exports.oAdmin:addAdminCMD("delcrafting", 7, "Drogkészítő asztal törlése")
--exports.oAdmin:addAdminCMD("createcrafting", 7, "Drogkészítő asztal létrehozása")

-- Drug buy panel

local alpha = 0
local tick = getTickCount()
local animType = "open"

local distanceCheck = false

local panelHeight = {sy*0.05, sy*0.05}
clickTick = getTickCount()
local height = 0

local selectedElement = false

local actions = {
    [0] = {0},
    [1] = {50},
    [2] = {75},
    [3] = {120},
    [4] = {180},
    [5] = {250},
    [6] = {300},
    [7] = {350},
    [8] = {400},
    [9] = {450},
    [10] = {500}
}

function renderDrugSeedBuyPanel()
    if distanceCheck then 
        if isElement(selectedElement) then 
            if core:getDistance(localPlayer, selectedElement) > 3 then 
                toggleDrugByPanel()
            end
        else 
            toggleDrugByPanel()
        end
    end

    if animType == "open" then 
        alpha = interpolateBetween(alpha, 0, 0, 1, 0, 0, (getTickCount()-tick)/300, "Linear")
    else
        alpha = interpolateBetween(alpha, 0, 0, 0, 0, 0, (getTickCount()-tick)/300, "Linear")
    end

    height = (#shop_items*sy*0.04767) + sy*0.033

    local drugBuyLevel, drugBuyExperience = unpack(getElementData(localPlayer, "char:drugBuyStats") or {0, 0})
    local bonus = actions[drugBuyLevel][1]

    if (bonus) < 1 then 
        bonus = 1
    end 

    local bonusforPrice = bonus
    local bonus = bonus

    dxDrawRectangle(sx*0.4, sy*0.5-height/2, sx*0.2, height, tocolor(30, 30, 30, 200*alpha))
    dxDrawRectangle(sx*0.4+2/myX*sx, sy*0.5-height/2+2/myY*sy, sx*0.2-4/myX*sx, height-4/myY*sy, tocolor(35, 35, 35, 255*alpha))
    dxDrawText("Akció: "..bonus.."$",sx*0.495+2/myX*sx - 1, sy*0.49-height/2+2/myY*sy + 1,_,_, tocolor(0,0,0,200*alpha), 1, font:getFont("condensed", 10/myX*sx), "center", "center",false,false,false,true)
    dxDrawText("Akció: "..color..bonus.."#ffffff$",sx*0.495+2/myX*sx, sy*0.49-height/2+2/myY*sy,_,_, tocolor(255,255,255,200*alpha), 1, font:getFont("condensed", 10/myX*sx), "center", "center",false,false,false,true)
    local startY = sy*0.5-height/2 + 4/myY*sy
    for k, v in ipairs(shop_items) do 
        local defA = 255 

        if k % 2 == 0 then defA = 150 end
        dxDrawRectangle(sx*0.4+3/myX*sx, startY, sx*0.2-6/myX*sx, sy*0.045, tocolor(30, 30, 30, defA*alpha))
       
        dxDrawImage(sx*0.4+7.5/myX*sx, startY + 2.5/myY*sy, 35/myX*sx, 35/myY*sy, inventory:getItemImage(v[1]), 0, 0, 0, tocolor(255, 255, 255, 255*alpha))

        local price = (v[2] - bonusforPrice) or v[2]
        local price = math.floor(price) or v[2]


        --dxDrawRectangle(sx*0.4+44.5/myX*sx, startY + 2.5/myY*sy, sx*0.1, sy*0.025)
        dxDrawText(inventory:getItemName(v[1]), sx*0.4+44.5/myX*sx, startY + 2.5/myY*sy, sx*0.4+44.5/myX*sx+sx*0.1, startY + 2.5/myY*sy+sy*0.025, tocolor(255, 255, 255, 255*alpha), 1, font:getFont("condensed", 10/myX*sx), "left", "center",false,false,false,true)
        dxDrawText(price.."$ / db", sx*0.4+44.5/myX*sx, startY + 2.5/myY*sy+sy*0.025, sx*0.4+44.5/myX*sx+sx*0.1, startY + 2.5/myY*sy+sy*0.025+sy*0.01, tocolor(255, 255, 255, 150*alpha), 0.8, font:getFont("condensed", 10/myX*sx), "left", "center",false,false,false,true)

        if v[3] > drugBuyLevel then 
            dxDrawRectangle(sx*0.4+3/myX*sx, startY, sx*0.2-6/myX*sx, sy*0.045, tocolor(30, 30, 30, 240*alpha))
            dxDrawText("Elérhető a(z) ".. v[3]..". szinttől", sx*0.4+3/myX*sx, startY, sx*0.4+3/myX*sx+sx*0.2-10/myX*sx, startY+sy*0.045, tocolor(255, 54, 54, 255*alpha), 1, font:getFont("condensed", 10/myX*sx), "right", "center")
        else
            local hasAccess = true 

            if v[4] then
                if not exports.oDashboard:isPlayerFactionTypeMember({4, 5}) then 
                    hasAccess = false
                end
            end
            --dxDrawRectangle(sx*0.4+3/myX*sx+sx*0.2-6/myX*sx-sx*0.052, startY+4/myY*sy, sx*0.05, sy*0.045-8/myY*sy, tocolor(r, g, b, 50*alpha))

            if hasAccess then
                if core:isInSlot(sx*0.4+3/myX*sx+sx*0.2-6/myX*sx-sx*0.052, startY+4/myY*sy, sx*0.05, sy*0.045-8/myY*sy) then 
                    core:dxDrawShadowedText("Vásárlás", sx*0.4+3/myX*sx+sx*0.2-6/myX*sx-sx*0.052, startY+4/myY*sy, sx*0.4+3/myX*sx+sx*0.2-6/myX*sx-sx*0.052+sx*0.05, startY+4/myY*sy+sy*0.045-8/myY*sy, tocolor(r, g, b, 255*alpha), tocolor(0, 0, 0, 255*alpha), 1, font:getFont("condensed", 10/myX*sx), "center", "center")
                else
                    core:dxDrawShadowedText("Vásárlás", sx*0.4+3/myX*sx+sx*0.2-6/myX*sx-sx*0.052, startY+4/myY*sy, sx*0.4+3/myX*sx+sx*0.2-6/myX*sx-sx*0.052+sx*0.05, startY+4/myY*sy+sy*0.045-8/myY*sy, tocolor(255, 255, 255, 255*alpha), tocolor(0, 0, 0, 255*alpha), 1, font:getFont("condensed", 10/myX*sx), "center", "center")
                end
            else
                dxDrawRectangle(sx*0.4+3/myX*sx, startY, sx*0.2-6/myX*sx, sy*0.045, tocolor(30, 30, 30, 240*alpha))
                dxDrawText("Csak illegális szervezetek számára érhető el!", sx*0.4+3/myX*sx, startY, sx*0.4+3/myX*sx+sx*0.2-10/myX*sx, startY+sy*0.045, tocolor(255, 54, 54, 255*alpha), 1, font:getFont("condensed", 10/myX*sx), "right", "center")
            end
        end

        dxDrawRectangle(sx*0.4+3/myX*sx, startY, 2/myX*sx, sy*0.045, tocolor(r, g, b, defA*alpha))

        startY = startY + sy*0.045+2/myY*sy
    end

    dxDrawRectangle(sx*0.415, startY+sy*0.005, sx*0.15, sy*0.02, tocolor(30, 30, 30, 255*alpha))
    dxDrawRectangle(sx*0.415+1/myX*sx, startY+sy*0.005+1/myY*sy, sx*0.15-2/myX*sx, sy*0.02-2/myY*sy, tocolor(35, 35, 35, 255*alpha))
    dxDrawRectangle(sx*0.415+1/myX*sx, startY+sy*0.005+1/myY*sy, (sx*0.15-2/myX*sx)*(drugBuyExperience/100), sy*0.02-2/myY*sy, tocolor(r, g, b, 255*alpha))
    dxDrawText(drugBuyLevel, sx*0.415-sx*0.02, startY+sy*0.005, sx*0.415-sx*0.02+sx*0.027, startY+sy*0.005+sy*0.02, tocolor(255, 255, 255, 255*alpha), 1, font:getFont("condensed", 11/myX*sx), "center", "center")
    dxDrawText(math.min(drugBuyLevel + 1, maxDrugBuyLevel), sx*0.41+sx*0.152, startY+sy*0.005, sx*0.41+sx*0.152+sx*0.02, startY+sy*0.005+sy*0.02, tocolor(255, 255, 255, 255*alpha), 1, font:getFont("condensed", 11/myX*sx), "center", "center")

    local cx, cy = getCursorPosition()

    if core:isInSlot(sx*0.425, startY+sy*0.005, sx*0.15, sy*0.02) then 
        local cx, cy = getCursorPosition()
        cx, cy = cx*sx, cy*sy

        local panelWidth = sx*0.05

        cx = cx - panelWidth/2

        dxDrawRectangle(cx, cy+sy*0.02, panelWidth, sy*0.04, tocolor(30, 30, 30, 150*alpha))
        dxDrawRectangle(cx+2/myX*sx, cy+sy*0.02+2/myY*sy, panelWidth-4/myX*sx, sy*0.04-4/myY*sy, tocolor(35, 35, 35, 255*alpha))
        
        dxDrawText(drugBuyExperience.."#ffffff/100 RP", cx+2/myX*sx, cy+sy*0.02+4/myY*sy, cx+2/myX*sx+panelWidth-4/myX*sx, cy+sy*0.02+4/myY*sy+sy*0.04-4/myY*sy, tocolor(r, g, b, 255*alpha), 1, font:getFont("condensed", 10/myX*sx), "center", "top", false, false, false, true)
        dxDrawText(drugBuyLevel .. ". #ffffffszint", cx+2/myX*sx, cy+sy*0.02+2/myY*sy, cx+2/myX*sx+panelWidth-4/myX*sx, cy+sy*0.02+2/myY*sy+sy*0.04-6/myY*sy, tocolor(r, g, b, 150*alpha), 0.8, font:getFont("condensed", 10/myX*sx), "center", "bottom", false, false, false, true)
    end

    if core:isInSlot(sx*0.41+sx*0.167, startY+sy*0.005, sx*0.02, sy*0.02) then 
        dxDrawText("", sx*0.41+sx*0.167, startY+sy*0.005, sx*0.41+sx*0.167+sx*0.02, startY+sy*0.005+sy*0.02, tocolor(255, 255, 255, 255*alpha), 1, font:getFont("fontawesome2", 11/myX*sx), "center", "center")

        local cx, cy = getCursorPosition()
        cx, cy = cx*sx, cy*sy

        local panelWidth = sx*0.29

        cx = cx - panelWidth/2

        dxDrawRectangle(cx, cy+sy*0.02, panelWidth, sy*0.04, tocolor(30, 30, 30, 150*alpha))
        dxDrawRectangle(cx+2/myX*sx, cy+sy*0.02+2/myY*sy, panelWidth-4/myX*sx, sy*0.04-4/myY*sy, tocolor(35, 35, 35, 255*alpha))
        
        dxDrawText("RP#ffffff-t (Reputation Point) úgy szerezhetsz, hogy "..color.."drog leveleket #ffffffvagy "..color.."kész drogokat #ffffffadsz a kereskedőnek!", cx+2/myX*sx, cy+sy*0.02+4/myY*sy, cx+2/myX*sx+panelWidth-4/myX*sx, cy+sy*0.02+4/myY*sy+sy*0.04-4/myY*sy, tocolor(r, g, b, 255*alpha), 0.9, font:getFont("condensed", 10/myX*sx), "center", "top", false, false, false, true)
        dxDrawText("Minden leadott drog "..color.."0-30rp#ffffff között dob, a pillanatnyi árat a szinted és az xp-d által kiszámolt"..color.." szorzó#ffffff adja meg!", cx+2/myX*sx, cy+sy*0.02+2/myY*sy, cx+2/myX*sx+panelWidth-4/myX*sx, cy+sy*0.02+2/myY*sy+sy*0.04-6/myY*sy, tocolor(255, 255, 255, 150*alpha), 0.8, font:getFont("condensed", 10/myX*sx), "center", "bottom", false, false, false, true)
    else
        dxDrawText("", sx*0.41+sx*0.167, startY+sy*0.005, sx*0.41+sx*0.167+sx*0.02, startY+sy*0.005+sy*0.02, tocolor(255, 255, 255, 150*alpha), 1, font:getFont("fontawesome2", 11/myX*sx), "center", "center")
    end
end

local lastBuy = 0
function drugBuyPanelKey(key, state)
    if state then 
        if key == "backspace" then 
            toggleDrugByPanel()
        elseif key == "mouse1" then 
            height = sy*0.05+#shop_items*sy*0.045

            local drugBuyLevel, drugBuyExperience = unpack(getElementData(localPlayer, "char:drugBuyStats") or {0, 0})

            local startY = sy*0.5-height/2 + 4/myY*sy
            for k, v in ipairs(shop_items) do 
                if v[3] <= drugBuyLevel then 
                    local hasAccess = true 

                    if v[4] then
                        if not exports.oDashboard:isPlayerFactionTypeMember({4, 5}) then 
                            hasAccess = false
                        end
                    end

                    if hasAccess then
                        if core:isInSlot(sx*0.4+3/myX*sx+sx*0.2-6/myX*sx-sx*0.052, startY+4/myY*sy, sx*0.05, sy*0.045-8/myY*sy) then 

                            local drugBuyLevel, drugBuyExperience = unpack(getElementData(localPlayer, "char:drugBuyStats") or {0, 0})
                            local bonus = actions[drugBuyLevel][1]

                            if getElementData(localPlayer, "char:money") >= (v[2] - bonus) then 
                                if inventory:getItemWeight(v[1]) + inventory:getAllItemWeight() < 20 then 
                                    if lastBuy + 500 < getTickCount() then 
                                    
                                        if (bonus) < 1 then 
                                            bonus = 1
                                        end 
                                    
                                        local bonusforPrice = bonus
                                        local bonus = bonus
                                        local price = (v[2] - bonusforPrice) or v[2]
                                        local price = math.floor(price) or v[2]

                                        lastBuy = getTickCount()
                                        triggerServerEvent("drugs > buyDrugFromPed", resourceRoot, v[1], price)
                                        --exports.oMinigames:createMinigame(1, 25, 48500, "drugcraft > endDrogCraft > success", "drugcraft > endDrogCraft > unSuccess")
                                    end
                                else 
                                    exports.oInfobox:outputInfoBox("Nincs elegendő hely az inventorydban! (Súly)", "error")
                                end
                            else

                                local drugBuyLevel, drugBuyExperience = unpack(getElementData(localPlayer, "char:drugBuyStats") or {0, 0})
                                local bonus = actions[drugBuyLevel][1]
                            
                                if (bonus) < 1 then 
                                    bonus = 1
                                end 
                            
                                local bonusforPrice = bonus
                                local bonus = bonus
                                local price = (v[2] - bonusforPrice) or v[2]
                                local price = math.floor(price) or v[2]

                                exports.oInfobox:outputInfoBox("Nincs nálad elegendő pénz a vásárláshoz! ("..price.."$)", "error")
                            end
                        end
                    end
                end
                startY = startY + sy*0.045+2/myY*sy
            end
        end
    end
end

local drugBuyPanelShowing = false
function openDrugBuyPanel()
    distanceCheck = true

    tick = getTickCount()
    animType = "open"

    addEventHandler("onClientRender", root, renderDrugSeedBuyPanel)
    addEventHandler("onClientKey", root, drugBuyPanelKey)
end

function closeDrugBuyPanel()
    distanceCheck = false 

    tick = getTickCount()
    animType = "close"

    removeEventHandler("onClientKey", root, drugBuyPanelKey)
    setTimer(function()
        selectedElement = false 
        removeEventHandler("onClientRender", root, renderDrugSeedBuyPanel)
    end, 300, 1)
end

function toggleDrugByPanel()
    drugBuyPanelShowing = not drugBuyPanelShowing 

    if drugBuyPanelShowing then openDrugBuyPanel() else closeDrugBuyPanel() end
end

addEventHandler("onClientClick", root, function(key, state, _, _, _, _, _, element)
    if key == "right" and state == "up" then 
        if element then 
            if getElementData(element, "isDrugPed") then 
                if core:getDistance(element, localPlayer) < 3 then
                    if not drugBuyPanelShowing then 
                        if not selectedElement then 
                            selectedElement = element
                            toggleDrugByPanel()
                        end
                    end
                end
            end
        end
    end
end)

function addDrugDealerExperience(ped, itemID, itemCount)
    if drugItemExperiences[itemID] then 
        local drugBuyLevel, drugBuyExperience = unpack(getElementData(localPlayer, "char:drugBuyStats") or {0, 0})

        if tostring(drugBuyLevel) < tostring(maxDrugBuyLevel) then 
            local addedXP = drugItemExperiences[itemID]*itemCount 
            
            if math.floor(addedXP/100) > 0 then 
                drugBuyLevel = drugBuyLevel + math.floor(addedXP/100)

                addedXP =  addedXP - (math.floor(addedXP/100) * 100)
            end
            drugBuyExperience = drugBuyExperience + addedXP 

            if drugBuyExperience >= 100 then 
                drugBuyLevel = drugBuyLevel + 1

                drugBuyExperience = drugBuyExperience - 100
            end

            setElementData(localPlayer, "char:drugBuyStats", {drugBuyLevel, drugBuyExperience})

            local level, xp = unpack(getElementData(localPlayer, "char:drugBuyStats"))
            if level >= maxDrugBuyLevel then 
                setElementData(localPlayer, "char:drugBuyStats", {maxDrugBuyLevel, 0})
            end

            return true
        else
            exports.oInfobox:outputInfoBox("Elérted a maximális szintet!", "warning")
            return false 
        end
    else
        return false
    end
end