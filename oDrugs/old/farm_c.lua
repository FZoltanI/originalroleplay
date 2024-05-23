activeFarmDatas = {
    ["roles"] = {
        [1] = {
            ["name"] = "Carlos White",
            ["plant"] = true, 
            ["harvest"] = true, 
            ["open"] = true, 
            ["machine_fix"] = true, 
            ["craft"] = true, 
        },

        [5] = {
            ["name"] = "Deez Peterson",
            ["plant"] = true, 
            ["harvest"] = false, 
            ["open"] = true, 
            ["machine_fix"] = false, 
            ["craft"] = true, 
        },
    }
}

local orderPackingBox = nil 

function renderFarmControllPanel()
    local animatedAlpha = 1
    core:drawWindow(sx*0.35, sy*0.3, sx*0.3, sy*0.4, "Konténer kezelése", animatedAlpha)


    dxDrawRectangle(sx*0.355, sy*0.33, sx*0.2, sy*0.024, tocolor(255, 255, 255, 30 * animatedAlpha))
    dxDrawText("Engedélyek", sx*0.355, sy*0.33, sx*0.355 + sx*0.2, sy*0.33 + sy*0.024, tocolor(255, 255, 255, 255 * animatedAlpha), 0.9, font:getFont("condensed", 10/myX*sx), "center", "center")
    dxDrawRectangle(sx*0.355, sy*0.33 + sy*0.024, sx*0.2, sy*0.048, tocolor(255, 255, 255, 10 * animatedAlpha))
    core:dxDrawButton(sx*0.36 + sx*0.155, sy*0.335 + sy*0.026, sx*0.035, sy*0.035, r, g, b, 150 * animatedAlpha, "", tocolor(255, 255, 255, 255 * animatedAlpha), 1, font:getFont("fontawesome2", 10/myX*sx))

    local startY = sy*0.33 + sy*0.024 + sy*0.048
    local count = 0
    for k, v in pairs(activeFarmDatas["roles"]) do 
        if (count % 2) == 0 then 
            dxDrawRectangle(sx*0.355, startY, sx*0.2, sy*0.028, tocolor(255, 255, 255, 25 * animatedAlpha))
        else
            dxDrawRectangle(sx*0.355, startY, sx*0.2, sy*0.028, tocolor(255, 255, 255, 20 * animatedAlpha))
        end

        dxDrawText(v["name"], sx*0.358, startY, sx*0.358 + sx*0.2, startY + sy*0.028, tocolor(255, 255, 255, 255 * animatedAlpha), 0.9, font:getFont("condensed", 10/myX*sx), "left", "center")

        local startX = sx*0.542

        for k2, v2 in pairs(farmRoles) do 
            if core:isInSlot(startX, startY + sy*0.0063, 15/myX*sx, 15/myY*sy) then 
                dxDrawRectangle(startX, startY + sy*0.0063, 15/myX*sx, 15/myY*sy, tocolor(255, 255, 255, 15 * animatedAlpha))
                core:drawToolTip(v2, tocolor(30, 30, 30, 255), tocolor(255, 255, 255, 255), font:getFont("condensed", 10/myX*sx), 0.9)
            else
                dxDrawRectangle(startX, startY + sy*0.0063, 15/myX*sx, 15/myY*sy, tocolor(255, 255, 255, 10 * animatedAlpha))
            end

            if v[k2] then 
                dxDrawText("", startX, startY + sy*0.0063, startX + 15/myX*sx, startY + sy*0.0063 + 15/myY*sy, tocolor(r, g, b, 255 * animatedAlpha), 0.7, font:getFont("fontawesome2", 10/myX*sx), "center", "center")
            end
            startX = startX - 20/myX*sx
        end

        startY = startY + sy*0.028
        count = count + 1
    end
end

function keyFarmControllPanel(key, state)
    if key == "mouse1" and state then 
        local startY = sy*0.33 + sy*0.024 + sy*0.048
        for k, v in pairs(activeFarmDatas["roles"]) do
            local startX = sx*0.542
            for k2, v2 in pairs(farmRoles) do 
                if core:isInSlot(startX, startY + sy*0.0063, 15/myX*sx, 15/myY*sy) then 
                    v[k2] = not v[k2]
                end
                startX = startX - 20/myX*sx
            end

            startY = startY + sy*0.028
        end
    end
end

function openFarmControllPanel()
    addEventHandler("onClientRender", root, renderFarmControllPanel)
    addEventHandler("onClientKey", root, keyFarmControllPanel)

    core:createEditbox(sx*0.36, sy*0.335 + sy*0.026, sx*0.15, sy*0.035, "drug_container_addPlayer", "ID/Név", "text", true, _, 0.4)
end
--openFarmControllPanel()

function drugFarmEnter(id)
    outputChatBox("farm: "..id)
    triggerServerEvent("drugFarm > getFarmDatas", resourceRoot, id)
end

function setElementToCorretIntAndDim(object)
    local int, dim = getElementInterior(localPlayer), getElementDimension(localPlayer)
    setElementInterior(object, int)
    setElementDimension(object, dim)
end


activeFarmDatas = {
    ["owner"] = 0,
    ["plants"] = {},
    ["roles"] = {},
    ["upgradedInterior"] = false,
    ["activeOrder"] = {
        ["packed"] = false, 
        ["items"] = {
            -- itemid, count, completed
            {218, 3, false},
            {219, 1, true},
            {220, 5, false},
            {221, 2, true},
        },
        ["price"] = 70000,
        ["transport_type"] = "water",
    },
    ["illegalFaction"] = false,
}

function createFarmInteriorObjectOnEnter()
    if isElement(orderPackingBox) then 
        destroyElement(orderPackingBox)
    end

    orderPackingBox = createObject(928, packBoxPosition[1], packBoxPosition[2], packBoxPosition[3], 0, 0, 100)
    setElementToCorretIntAndDim(orderPackingBox)

    addEventHandler("onClientRender", root, renderFarmThings)
    addEventHandler("onClientKey", root, keyFarmThings)
end

addEvent("drugfarm > sendFarmDatas > active", true)
addEventHandler("drugfarm > sendFarmDatas > active", getRootElement(), function(datas)
    activeFarmDatas = datas 
    print(toJSON(activeFarmDatas))

    createFarmInteriorObjectOnEnter()
end)



function renderFarmThings()
    if core:getDistance(localPlayer, orderPackingBox) < 2.5 then 
        if activeFarmDatas["activeOrder"] then
            local distance = math.min(1 - (core:getDistance(localPlayer, orderPackingBox) / 2.5) + 0.4, 1)

            local x, y = getScreenFromWorldPosition(packBoxPosition[1], packBoxPosition[2], packBoxPosition[3] + 1)

            if x and y then
                local panelWidth = #activeFarmDatas["activeOrder"]["items"] * sx*0.027 + sx*0.002
                local panelHeight = sy*0.11
                local startX = (x - panelWidth/2) + sx*0.002

                if activeFarmDatas["activeOrder"]["packed"] == true then
                    panelHeight = sy*0.06
                end

                dxDrawRectangle(x - panelWidth/2, y, panelWidth, panelHeight, tocolor(30, 30, 30, 200 * distance))

            
                if activeFarmDatas["activeOrder"]["packed"] == false then 
                    local buttonInactive = false 
                    for k, v in ipairs(activeFarmDatas["activeOrder"]["items"]) do 
                        if v[3] then
                            dxDrawImage(startX, y + sx*0.002, sx*0.025, sx*0.025, inventory:getItemImage(v[1]), 0, 0, 0, tocolor(255, 255, 255, 255 * distance)) 
                        else
                            buttonInactive = true
                            dxDrawImage(startX, y + sx*0.002, sx*0.025, sx*0.025, inventory:getItemImage(v[1]), 0, 0, 0, tocolor(255, 255, 255, 100 * distance))
                            dxDrawText(v[2], startX, y + sx*0.002, startX + sx*0.025, y + sx*0.002 + sx*0.025, tocolor(255, 255, 255, 255 * distance), 1, font:getFont("condensed", 12/myX*sx), "center", "center")
                        end
                        startX = startX + sx*0.027
                    end

                    if buttonInactive then
                        core:dxDrawButton((x - panelWidth/2) + sx*0.002, y + sy*0.055, panelWidth - sx*0.004, sy*0.03, r, g, b, 150 * distance, "Csomagolás", tocolor(255, 255, 255, 200 * distance), 0.8, font:getFont("condensed", 12/myX*sx))
                    else
                        core:dxDrawButton((x - panelWidth/2) + sx*0.002, y + sy*0.055, panelWidth - sx*0.004, sy*0.03, r, g, b, 220 * distance, "Csomagolás", tocolor(255, 255, 255, 255 * distance), 0.8, font:getFont("condensed", 12/myX*sx))
                    end
                else
                    core:dxDrawButton((x - panelWidth/2) + sx*0.002, y + sy*0.005, panelWidth - sx*0.004, sy*0.03, r, g, b, 220 * distance, "Csomag leszállítása", tocolor(255, 255, 255, 255 * distance), 0.8, font:getFont("condensed", 12/myX*sx))
                end

                dxDrawText("Csomag ára: #8acf74"..activeFarmDatas["activeOrder"]["price"].."#ffffff$", (x - panelWidth/2) + sx*0.002, y + sy*0.09,  (x - panelWidth/2) + sx*0.002 + panelWidth, y + panelHeight - sy*0.004, tocolor(255, 255, 255, 255 * distance), 0.8, font:getFont("condensed", 12/myX*sx), "center", "bottom", false, false, false, true)
            end
        end
    end
end

function keyFarmThings(key, state)
    if state then 
        if key == "mouse1" then 
            if core:getDistance(localPlayer, orderPackingBox) < 2.5 then 
                if activeFarmDatas["activeOrder"] then
                    local x, y = getScreenFromWorldPosition(packBoxPosition[1], packBoxPosition[2], packBoxPosition[3] + 1)

                    if x and y then
                        if activeFarmDatas["activeOrder"]["packed"] == false then 
                            local panelWidth = #activeFarmDatas["activeOrder"]["items"] * sx*0.027 + sx*0.002
                            local startX = (x - panelWidth/2) + sx*0.002
                
                            
                            local buttonInactive = false 
                            for k, v in ipairs(activeFarmDatas["activeOrder"]["items"]) do 
                                if not v[3] then
                                    buttonInactive = true
                                end
                                startX = startX + sx*0.027
                            end

                            if core:isInSlot((x - panelWidth/2) + sx*0.002, y + sy*0.055, panelWidth - sx*0.004, sy*0.03) then
                                if buttonInactive then
                                    exports.oInfobox:outputInfoBox("Először mindent be kell pakolnod a csomagba!", "warning")
                                else
                                    -- csomagolás folyamat

                                    -- valami animáció
                                    -- ellenőrizze hogy van e nálad ragasztószalag
                                    -- automatikus me + do
                                    
                                    exports.oInfobox:outputInfoBox("Sikeresen becsomagoltad a dobozt!", "success")
                                    activeFarmDatas["activeOrder"]["packed"] = true
                                    setElementModel(orderPackingBox, 1220)
                                    setObjectScale(orderPackingBox, 0.7)
                                    setElementFrozen(orderPackingBox, true)
                                end
                            end
                        else
                        end
                    end
                end
            end
        end
    end
end


createFarmInteriorObjectOnEnter()