sx, sy = guiGetScreenSize()
myX, myY = 1600, 900

local deliveryCol = 0

fonts = {
    ["condensed-10"] = font:getFont("condensed", 10),
    ["condensed-12"] = font:getFont("condensed", 12),
    ["condensed-25"] = font:getFont("condensed", 25),
    ["bebasneue-11"] = font:getFont("bebasneue", 11),
    ["bebasneue-25"] = font:getFont("bebasneue", 25),
    ["fontawesomes-25"] = font:getFont("fontawesome2", 25),
}

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oShop" or getResourceName(res) == "oMyslq" or getResourceName(res) == "oFont" or getResourceName(res) == "oInventory" or getResourceName(res) == "oChat" then  
        core = exports.oCore
        color, r, g, b = core:getServerColor()
        mysql = exports.oMysql
        inventory = exports.oInventory
        font = exports.oFont
        chat = exports.oChat
	end
end)

local a = 0
local closeTimer

local items = {}
local pointer = 0
local tick = getTickCount()
local animationType = "open"

local a_panel_showing = false
local a_panel_page = 1
local a_panel_selected_itemType = 1

local shopElement = false

local showing = false

local boughtItemCount = 0

local panelType = "normal"

local orderPanelShowing = false
local inOrderItem, inOrderPrice, inOrderCountEditbox = 0, 0, nil
core:deleteEditbox("orderCount")

local priceSetPanelShowing = false
local editedItem, editedItemPriceEditbox = 0, nil
core:deleteEditbox("priceEditbox")

local moneyEditbox = nil 
core:deleteEditbox("moneyEditbox")

local orderPed = createPed(261, -49.71997833252,-269.36404418945,6.633186340332, 180)
setElementFrozen(orderPed, true)
setElementData(orderPed, "ped:name", "Carl Ferguson")

local pickupOrderBlip = nil

local bolteladasCount = 0





local playerAllShopTable = {}
local pendingOrderCount = 0 
function getOwnedShopDatas()
    playerAllShopTable = {}

    --[[local charId = getElementData(localPlayer, "char:id")
    for k, v in ipairs(getElementsByType("ped")) do 
        if getElementData(v, "shop:private") == 1 then 
            if getElementData(v, "shop:owner") == charId then
                table.insert(playerAllShopTable, v) 
            end
        end
    end]]

    triggerServerEvent("shop > getAllOwnedBusinesses", resourceRoot)
end

addEvent("shop > sendAllOwnedBusinessesDatasToClient", true)
addEventHandler("shop > sendAllOwnedBusinessesDatasToClient", localPlayer, function (data) 
    playerAllShopTable = data

    outputChatBox(#data)
end)

function checkPendingOrders()
    --getAllOwnedShop()

    setTimer(function()
        pendingOrderCount = 0

        for k, v in pairs(playerAllShopTable) do
            local orders = getElementData(v, "shop:orders")
            pendingOrderCount = pendingOrderCount + #orders
        end
    
        if pendingOrderCount > 0 then 
            outputChatBox(core:getServerPrefix("server", "Biznisz", 2).."Jelenleg "..color..pendingOrderCount.."db #ffffffrendelésed van folyamatban! A térképen #edd066sárga #ffffffhatszög jelöli az átvételi pontot.", 255, 255, 255, true)
    
            if not isElement(pickupOrderBlip) then 
                pickupOrderBlip = createBlip(pickupOrderPos[1], pickupOrderPos[2], pickupOrderPos[3], 6)
                setElementData(pickupOrderBlip, "blip:name", "Rendelés felvétele")
            end
        end
    end, 2500, 1)
   
end

addEventHandler("onClientResourceStart", resourceRoot, function()
    if getElementData(localPlayer, "user:loggedin") then 
        checkPendingOrders()
    end
end)

addEventHandler("onClientElementDataChange", localPlayer, function(data, old, new)
    if source == localPlayer then 
        if data == "user:loggedin" then 
            if new == true then 
                checkPendingOrders()
            end
        end
    end
end)

local openedShopDatas = {}
local openedShopDataStatus = "requested"

local loadingRot = 0

function renderPanel() 

    if animationType == "open" then 
        a = interpolateBetween(a, 0, 0, 1, 0, 0, (getTickCount() - tick)/300, "Linear")
    else
        a = interpolateBetween(a, 0, 0, 0, 0, 0, (getTickCount() - tick)/300, "Linear")
    end

    if not isElement(shopElement) then
        closeShop()
        shopElement = false
    end

    if shopElement then 
        if core:getDistance(shopElement, localPlayer) > 4 then 
            closeShop()
        end
    end

    if openedShopDataStatus then 
        if openedShopDataStatus == "requested" then 
            core:drawWindow(sx*0.4, sy*0.25, sx*0.2, sy*0.409, "Bolt", a)

            loadingRot = loadingRot + 5
            dxDrawImage(sx*0.5 - 50/myX*sx, sy*0.5 - 100/myY*sy, 100/myX*sx, 100/myX*sx, "files/circle1.png", loadingRot, 0, 0, tocolor(r, g, b, 255 *a ))
            return
        end
    end

    if getElementData(shopElement, "shop:private") == 1 then 
        if openedShopDatas.owner == 0 then 
            core:drawWindow(sx*0.4, sy*0.45, sx*0.2, sy*0.1, "Bolt vásárlása", a)
            dxDrawText("Ez a bolt eladó "..color..openedShopDatas.cost.."$#ffffff-ért. Szeretnéd megvásárolni?", sx*0.4, sy*0.45, sx*0.4 + sx*0.2, sy*0.45 + sy*0.08, tocolor(255, 255, 255, 255 * a), 0.7/myX*sx, fonts["condensed-12"], "center", "center", false, false, false, true)
            core:dxDrawButton(sx*0.404, sy*0.51, sx*0.095, sy*0.03, r, g, b, 200 * a, "Vásárlás", tocolor(255, 255, 255, 255 * a), 0.8/myX*sx, fonts["condensed-12"], true, tocolor(0, 0, 0, 100 * a))
            core:dxDrawButton(sx*0.404 + sx*0.096, sy*0.51, sx*0.095, sy*0.03, 245, 56, 56, 200 * a, "Mégsem", tocolor(255, 255, 255, 255 * a), 0.8/myX*sx, fonts["condensed-12"], true, tocolor(0, 0, 0, 100 * a))
            return 
        end
    end



    if panelType == "normal" then 
        if getElementData(shopElement, "shop:private") == 1 then 
            cache_items = openedShopDatas.items

            items = {}

            for k, v in pairs(cache_items) do
                if v[1] > 0 and v[2] > 0 then
                    table.insert(items, {tonumber(k), v[2]})
                end
            end

            table.sort(items, function (k1, k2) return k1[1] < k2[1] end )   
        end
 
        core:drawWindow(sx*0.4, sy*0.25, sx*0.2, sy*0.409, "Bolt", a)

        local starty = sy*0.275
        for i = 1, 9 do 
            if items[i+pointer] then 
                if (i + pointer) % 2 == 0 then
                    dxDrawRectangle(sx*0.4+4/myX*sx, starty, sx*0.2-10/myX*sx, sy*0.04, tocolor(40, 40, 40, 150*a))
                else
                    dxDrawRectangle(sx*0.4+4/myX*sx, starty, sx*0.2-10/myX*sx, sy*0.04, tocolor(40, 40, 40, 240*a))
                end

                if type(items[i+pointer]) == "table" then 
                    dxDrawImage(sx*0.4+6/myX*sx, starty+2/myY*sy, 32/myX*sx, 32/myY*sy, inventory:getItemImage(items[i+pointer][1]), 0, 0, 0, tocolor(255, 255, 255, 255*a))
                else
                    dxDrawImage(sx*0.4+6/myX*sx, starty+2/myY*sy, 32/myX*sx, 32/myY*sy, inventory:getItemImage(items[i+pointer]), 0, 0, 0, tocolor(255, 255, 255, 255*a))
                end


                if core:isInSlot(sx*0.55, starty, sx*0.05, sy*0.04) then 
                    dxDrawText("Vásárlás", sx*0.395+2/myX*sx, starty, sx*0.395+2/myX*sx+sx*0.2-8/myX*sx, starty+sy*0.04, tocolor(r, g, b, 255*a), 0.9/myX*sx, fonts["condensed-10"], "right", "center")
                else
                    dxDrawText("Vásárlás", sx*0.395+2/myX*sx, starty, sx*0.395+2/myX*sx+sx*0.2-8/myX*sx, starty+sy*0.04, tocolor(255, 255, 255, 255*a), 0.9/myX*sx, fonts["condensed-10"], "right", "center")
                end

                --dxDrawRectangle(sx*0.426, starty+sy*0.005, sx*0.135, sy*0.02, tocolor(255, 40, 40, 240*a))
                if type(items[i+pointer]) == "table" then 
                    dxDrawText(inventory:getItemName(items[i+pointer][1]), sx*0.426, starty+sy*0.005, sx*0.426+sx*0.135, starty+sy*0.005+sy*0.02, tocolor(255, 255, 255, 255*a), 1/myX*sx, fonts["condensed-10"], "left", "center")
                    dxDrawText(items[i+pointer][2].."$", sx*0.426, starty+sy*0.005, sx*0.426+sx*0.135, starty+sy*0.005+sy*0.035, tocolor(114, 194, 87, 255*a), 0.9/myX*sx, fonts["bebasneue-11"], "left", "bottom")
                else
                    dxDrawText(inventory:getItemName(items[i+pointer]), sx*0.426, starty+sy*0.005, sx*0.426+sx*0.135, starty+sy*0.005+sy*0.02, tocolor(255, 255, 255, 255*a), 1/myX*sx, fonts["condensed-10"], "left", "center")
                    dxDrawText(((itemPrices[items[i+pointer]]) or 0).."$", sx*0.426, starty+sy*0.005, sx*0.426+sx*0.135, starty+sy*0.005+sy*0.035, tocolor(114, 194, 87, 255*a), 0.9/myX*sx, fonts["bebasneue-11"], "left", "bottom")
                end
              
            end
            starty = starty + sy*0.04+2/myX*sx
        end

        local lineHeight = math.min(9 / #items, 1)

        dxDrawRectangle(sx*0.6 - sx*0.003, sy*0.275, sx*0.0015, sy*0.378, tocolor(r, g, b, 75*a))
        dxDrawRectangle(sx*0.6 - sx*0.003, sy*0.275 + (sy*0.378 * (lineHeight * pointer / 9)), sx*0.0015, sy*0.378 * lineHeight, tocolor(r, g, b, 200*a))
    end

    --dxDrawRectangle(sx*0.664, sy*0.215+sy*0.055 + (sy*0.58 * (lineHeight * adminScrolls["ad"]/11)), sx*0.002, sy*0.58 * lineHeight, tocolor(r, g, b, 200*alpha_pagebg))
    if openedShopDataStatus == "done" then 
        if openedShopDatas.owner == getElementData(localPlayer, "char:id") and getElementData(shopElement, "shop:private") == 1 then
            if panelType == "normal" then 
                core:dxDrawButton(sx*0.4, sy*0.66, sx*0.2, sy*0.03, r, g, b, 200 * a, "Bolt kezelése", tocolor(255, 255, 255, 255 * a), 0.8/myX*sx, fonts["condensed-12"], true, tocolor(0, 0, 0, 100 * a)) 
            elseif panelType == "admin" then 
                if (not orderPanelShowing) and (not priceSetPanelShowing) then 
                    items = openedShopDatas.items

                    core:dxDrawButton(sx*0.4, sy*0.66, sx*0.2, sy*0.03, r, g, b, 200 * a, "Vissza", tocolor(255, 255, 255, 255 * a), 0.8/myX*sx, fonts["condensed-12"], true, tocolor(0, 0, 0, 100 * a)) 

                    if bolteladasCount > 0 then
                        core:dxDrawButton(sx*0.4, sy*0.215, sx*0.2, sy*0.03, 245, 56, 56, 200 * a, "Tényleg el szeretnéd adni a boltodat?", tocolor(255, 255, 255, 255 * a), 0.8/myX*sx, fonts["condensed-12"], true, tocolor(0, 0, 0, 100 * a)) 
                    else
                        core:dxDrawButton(sx*0.4, sy*0.215, sx*0.2, sy*0.03, 245, 56, 56, 200 * a, "Bolt eladása", tocolor(255, 255, 255, 255 * a), 0.8/myX*sx, fonts["condensed-12"], true, tocolor(0, 0, 0, 100 * a)) 
                    end

                    if core:isInSlot(sx*0.4, sy*0.215, sx*0.2, sy*0.03) then
                        core:drawToolTip("Ha a boltot eladod akkor az eredeti összeget visszakapod, viszont a boltod alaphelyzetbe áll.", tocolor(25, 25, 25, 200 * a), tocolor(255, 255, 255, 255 * a), font:getFont("condensed", 10/myX*sx), 1) 
                    end

                    core:drawWindow(sx*0.3, sy*0.25, sx*0.4, sy*0.409, "Bolt", a)
                    
                    local starty = sy*0.275
                    for i = 1, 9 do 
                        if businessBuyableItems[i+pointer] then 
                            if (i + pointer) % 2 == 0 then
                                dxDrawRectangle(sx*0.3+4/myX*sx, starty, sx*0.2-10/myX*sx, sy*0.04, tocolor(40, 40, 40, 150*a))
                            else
                                dxDrawRectangle(sx*0.3+4/myX*sx, starty, sx*0.2-10/myX*sx, sy*0.04, tocolor(40, 40, 40, 240*a))
                            end

                            dxDrawImage(sx*0.3+6/myX*sx, starty+2/myY*sy, 32/myX*sx, 32/myY*sy, inventory:getItemImage(businessBuyableItems[i+pointer][1]), 0, 0, 0, tocolor(255, 255, 255, 255*a))

                            core:dxDrawButton(sx*0.45, starty + sy*0.005, sx*0.02, sy*0.03, r, g, b, 200 * a, "", tocolor(255, 255, 255, 255 * a), 0.45/myX*sx, fonts["fontawesomes-25"], true, tocolor(0, 0, 0, 100 * a))
                            core:dxDrawButton(sx*0.473, starty + sy*0.005, sx*0.02, sy*0.03, r, g, b, 200 * a, "", tocolor(255, 255, 255, 255 * a), 0.45/myX*sx, fonts["fontawesomes-25"], true, tocolor(0, 0, 0, 100 * a))

                            if core:isInSlot(sx*0.45, starty + sy*0.005, sx*0.02, sy*0.03) then
                                core:drawToolTip("Rendelés", tocolor(25, 25, 25, 200 * a), tocolor(255, 255, 255, 255 * a), font:getFont("condensed", 10/myX*sx), 1) 
                            end

                            if core:isInSlot(sx*0.473, starty + sy*0.005, sx*0.02, sy*0.03) then
                                core:drawToolTip("Ár módosítása", tocolor(25, 25, 25, 200 * a), tocolor(255, 255, 255, 255 * a), font:getFont("condensed", 10/myX*sx), 1) 
                            end

                            local itemCount = 0
                            local itemPrice = 0

                            if items[tostring(businessBuyableItems[i+pointer][1])] then 
                                itemCount = items[tostring(businessBuyableItems[i+pointer][1])][1]
                                itemPrice = items[tostring(businessBuyableItems[i+pointer][1])][2]
                            end

                        
                            if itemPrice > 0 then 
                                dxDrawText(inventory:getItemName(businessBuyableItems[i+pointer][1])..color.." #72c257("..itemPrice.."$)", sx*0.326, starty+sy*0.005, sx*0.326+sx*0.1, starty+sy*0.005+sy*0.02, tocolor(255, 255, 255, 255*a), 0.95/myX*sx, fonts["condensed-10"], "left", "center", true, false, false, true)
                            else
                                dxDrawText(inventory:getItemName(businessBuyableItems[i+pointer][1])..color.." #878787(X)", sx*0.326, starty+sy*0.005, sx*0.326+sx*0.1, starty+sy*0.005+sy*0.02, tocolor(255, 255, 255, 255*a), 0.95/myX*sx, fonts["condensed-10"], "left", "center", true, false, false, true)
                            end

                            local itemPrice = getElementData(resourceRoot, "shop:businessItemPrice:"..businessBuyableItems[i+pointer][1])

                            if itemPrice < itemPrices[businessBuyableItems[i+pointer][1]] then 
                                itemPrice = "#72c257"..itemPrice
                            elseif itemPrice > itemPrices[businessBuyableItems[i+pointer][1]] then 
                                itemPrice = "#f53838"..itemPrice
                            elseif itemPrice == itemPrices[businessBuyableItems[i+pointer][1]] then 
                                itemPrice = "#389af5"..itemPrice
                            end

                            dxDrawText("Készleten: "..color..itemCount.."#ffffffdb, Nagyker ár: "..itemPrice.."$", sx*0.326, starty+sy*0.005, sx*0.326+sx*0.135, starty+sy*0.005+sy*0.035, tocolor(255, 255, 255, 255*a), 0.8/myX*sx, fonts["condensed-10"], "left", "bottom", false, false, false, true)
                        end
                        starty = starty + sy*0.04+2/myX*sx
                    end

                    local lineHeight = math.min(9 / #businessBuyableItems, 1)

                    dxDrawRectangle(sx*0.5 - sx*0.003, sy*0.275, sx*0.0015, sy*0.378, tocolor(r, g, b, 75*a))
                    dxDrawRectangle(sx*0.5 - sx*0.003, sy*0.275 + (sy*0.378 * (lineHeight * pointer / 9)), sx*0.0015, sy*0.378 * lineHeight, tocolor(r, g, b, 200*a))

                    dxDrawRectangle(sx*0.5005, sy*0.275, sx*0.197, sy*0.02, tocolor(30, 30, 30, 200 * a))
                    dxDrawRectangle(sx*0.5005, sy*0.295, sx*0.197, sy*0.16, tocolor(30, 30, 30, 100 * a))

                    local pendingOrders = openedShopDatas.orders

                    dxDrawText("Rendelések" .. color .." ("..#pendingOrders .."/5)", sx*0.5005, sy*0.275, sx*0.5005 + sx*0.197, sy*0.275 + sy*0.02, tocolor(255, 255, 255, 150*a), 0.8/myX*sx, fonts["condensed-10"], "center", "center", true, false, false, true)

                    local startY = sy*0.298
                    for i = 1, 5 do
                        if (i % 2) == 0 then 
                            dxDrawRectangle(sx*0.501, startY, sx*0.195, sy*0.03, tocolor(40, 40, 40, 100 * a))
                        else
                            dxDrawRectangle(sx*0.501, startY, sx*0.195, sy*0.03, tocolor(40, 40, 40, 150 * a))
                        end

                        if pendingOrders[i] then 
                            dxDrawText(inventory:getItemName(pendingOrders[i][1]).." #ffffff("..pendingOrders[i][2].."db)", sx*0.501, startY, sx*0.501 + sx*0.195, startY + sy*0.03, tocolor(r, g, b, 255*a), 0.8/myX*sx, fonts["condensed-10"], "center", "center", true, false, false, true)
                        end

                        startY = startY + sy*0.031
                    end

                    dxDrawRectangle(sx*0.5005, sy*0.457, sx*0.197, sy*0.02, tocolor(30, 30, 30, 200 * a))
                    dxDrawRectangle(sx*0.5005, sy*0.477, sx*0.197, sy*0.12, tocolor(30, 30, 30, 100 * a))
                    dxDrawText("Üzleti számla", sx*0.5005, sy*0.457, sx*0.5005 + sx*0.197, sy*0.457 + sy*0.02, tocolor(255, 255, 255, 150*a), 0.8/myX*sx, fonts["condensed-10"], "center", "center", true, false, false, true)
                    dxDrawText("Egyenleg: "..color..(openedShopDatas.money).."$", sx*0.5005, sy*0.49, sx*0.5005 + sx*0.197, sy*0.49 + sy*0.02, tocolor(255, 255, 255, 255*a), 0.9/myX*sx, fonts["condensed-10"], "center", "center", true, false, false, true)
                    core:dxDrawButton(sx*0.5255, sy*0.565, sx*0.15, sy*0.023, r, g, b, 200 * a, "Pénz kivétele", tocolor(255, 255, 255, 255 * a), 0.65/myX*sx, fonts["condensed-12"], true, tocolor(0, 0, 0, 100 * a))
                elseif (orderPanelShowing) then
                    core:drawWindow(sx*0.425, sy*0.425, sx*0.15, sy*0.15, "Rendelés", 1)
                    dxDrawText("Add meg hány darab \n"..color..inventory:getItemName(inOrderItem).."#ffffff-(e)t szeretnél rendelni.", sx*0.425, sy*0.425, sx*0.425 + sx*0.15, sy*0.425 + sy*0.06, tocolor(255, 255, 255, 255*a), 0.9/myX*sx, fonts["condensed-10"], "center", "bottom", true, false, false, true)

                    local count = core:getEditboxText("orderCount")
                    if not (tonumber(count) == nil) then 
                        count = tonumber(count)
                    else
                        count = 0
                    end

                    dxDrawText((inOrderPrice * count) .. "#72c257$", sx*0.425, sy*0.425, sx*0.425 + sx*0.15, sy*0.425 + sy*0.12, tocolor(255, 255, 255, 255*a), 0.9/myX*sx, fonts["condensed-10"], "center", "bottom", true, false, false, true)

                    core:dxDrawButton(sx*0.427, sy*0.547, (sx*0.15 / 2) - sx*0.003, sy*0.023, r, g, b, 200 * a, "Rendelés", tocolor(255, 255, 255, 255 * a), 0.65/myX*sx, fonts["condensed-12"], true, tocolor(0, 0, 0, 100 * a))
                    core:dxDrawButton(sx*0.427 + (sx*0.15 / 2) - sx*0.0005, sy*0.547, (sx*0.15 / 2) - sx*0.003, sy*0.023, 245, 56, 56, 200 * a, "Mégsem", tocolor(255, 255, 255, 255 * a), 0.65/myX*sx, fonts["condensed-12"], true, tocolor(0, 0, 0, 100 * a))
                elseif (priceSetPanelShowing) then 
                    core:drawWindow(sx*0.425, sy*0.425, sx*0.15, sy*0.15, "Ár beállítása", 1)
                    dxDrawText(""..color..inventory:getItemName(editedItem).."#ffffff árának beállítása.", sx*0.425, sy*0.42, sx*0.425 + sx*0.15, sy*0.42 + sy*0.06, tocolor(255, 255, 255, 255*a), 0.9/myX*sx, fonts["condensed-10"], "center", "bottom", true, false, false, true)

                    core:dxDrawButton(sx*0.427, sy*0.547, (sx*0.15 / 2) - sx*0.003, sy*0.023, r, g, b, 200 * a, "Beállítás", tocolor(255, 255, 255, 255 * a), 0.65/myX*sx, fonts["condensed-12"], true, tocolor(0, 0, 0, 100 * a))
                    core:dxDrawButton(sx*0.427 + (sx*0.15 / 2) - sx*0.0005, sy*0.547, (sx*0.15 / 2) - sx*0.003, sy*0.023, 245, 56, 56, 200 * a, "Mégsem", tocolor(255, 255, 255, 255 * a), 0.65/myX*sx, fonts["condensed-12"], true, tocolor(0, 0, 0, 100 * a))
                end
            end
        end
    end

    if (getElementData(localPlayer, "user:admin") >= 6 and getElementData(localPlayer, "user:aduty")) and getElementData(shopElement, "shop:private") == 0 then 
        dxDrawRectangle(sx*0.6-40/myX*sx, sy*0.67, 40/myX*sx, 40/myY*sy, tocolor(30, 30, 30, 220*a))
        dxDrawRectangle(sx*0.6-40/myX*sx+2/myX*sx, sy*0.67+2/myY*sy, 36/myX*sx, 36/myY*sy, tocolor(40, 40, 40, 220*a))

        if core:isInSlot(sx*0.6-40/myX*sx+2/myX*sx, sy*0.67+2/myY*sy, 36/myX*sx, 36/myY*sy) then 
            dxDrawImage(sx*0.6-32.5/myX*sx, sy*0.67+7.5/myY*sy, 25/myX*sx, 25/myY*sy, "files/settings.png", 0, 0, 0, tocolor(r, g, b, 255*a))
        else
            dxDrawImage(sx*0.6-32.5/myX*sx, sy*0.67+7.5/myY*sy, 25/myX*sx, 25/myY*sy, "files/settings.png", 0, 0, 0, tocolor(255, 255, 255, 255*a))
        end

        if a_panel_showing then 
            dxDrawRectangle(sx*0.6+2/myX*sx, sy*0.25, sx*0.2, sy*0.415, tocolor(30, 30, 30, 240*a))
            dxDrawRectangle(sx*0.6+4/myX*sx, sy*0.25+2/myY*sy, sx*0.2-4/myX*sx, sy*0.03, tocolor(40, 40, 40, 240*a))
            dxDrawText("BOLT BEÁLLÍTÁSOK", sx*0.6+2/myX*sx, sy*0.25+2/myY*sy, sx*0.6+2/myX*sx+sx*0.2-4/myX*sx, sy*0.25+2/myY*sy+sy*0.03, tocolor(255, 255, 255, 255*a), 1/myX*sx, fonts["bebasneue-11"], "center", "center", false, false, false, true)

            dxDrawRectangle(sx*0.6+4/myX*sx, sy*0.285, sx*0.1-4/myX*sx, sy*0.03, tocolor(40, 40, 40, 240*a))
            if core:isInSlot(sx*0.6+4/myX*sx, sy*0.285, sx*0.1-4/myX*sx, sy*0.03) or a_panel_page == 1 then 
                dxDrawText("Típus", sx*0.6+4/myX*sx, sy*0.285, sx*0.6+4/myX*sx+sx*0.1-4/myX*sx, sy*0.285+sy*0.03, tocolor(r, g, b, 255*a), 1/myX*sx, fonts["condensed-10"], "center", "center")
            else
                dxDrawText("Típus", sx*0.6+4/myX*sx, sy*0.285, sx*0.6+4/myX*sx+sx*0.1-4/myX*sx, sy*0.285+sy*0.03, tocolor(255, 255, 255, 255*a), 1/myX*sx, fonts["condensed-10"], "center", "center")
            end

            dxDrawRectangle(sx*0.7+4/myX*sx, sy*0.285, sx*0.1-4/myX*sx, sy*0.03, tocolor(40, 40, 40, 240*a))
            if core:isInSlot(sx*0.7+4/myX*sx, sy*0.285, sx*0.1-4/myX*sx, sy*0.03) or a_panel_page == 2 then 
                dxDrawText("Itemek", sx*0.7+4/myX*sx, sy*0.285, sx*0.7+4/myX*sx+sx*0.1-4/myX*sx, sy*0.285+sy*0.03, tocolor(r, g, b, 255*a), 1/myX*sx, fonts["condensed-10"], "center", "center")
            else
                dxDrawText("Itemek", sx*0.7+4/myX*sx, sy*0.285, sx*0.7+4/myX*sx+sx*0.1-4/myX*sx, sy*0.285+sy*0.03, tocolor(255, 255, 255, 255*a), 1/myX*sx, fonts["condensed-10"], "center", "center")
            end

            if a_panel_page == 1 then
                local starty = sy*0.285+sy*0.03+2/myY*sy 

                for k, v in ipairs(shopTemplates) do 
                    dxDrawRectangle(sx*0.6+4/myX*sx, starty, sx*0.2-4/myX*sx, sy*0.03, tocolor(40, 40, 40, 240*a))

                    if core:isInSlot(sx*0.6+4/myX*sx, starty, sx*0.2-4/myX*sx, sy*0.03) then 
                        dxDrawText(v.name, sx*0.6+2/myX*sx, starty, sx*0.6+2/myX*sx+sx*0.2-4/myX*sx, starty+sy*0.03, tocolor(r, g, b, 255*a), 0.9/myX*sx, fonts["condensed-10"], "center", "center", false, false, false, true)
                    else
                        dxDrawText(v.name, sx*0.6+2/myX*sx, starty, sx*0.6+2/myX*sx+sx*0.2-4/myX*sx, starty+sy*0.03, tocolor(255, 255, 255, 255*a), 0.9/myX*sx, fonts["condensed-10"], "center", "center", false, false, false, true)
                    end

                    starty = starty + sy*0.03+2/myY*sy
                end
            elseif a_panel_page == 2 then 
                local starty = sy*0.285+sy*0.03+2/myY*sy 

                for k, v in ipairs(shopItems) do 
                    dxDrawRectangle(sx*0.8+2/myX*sx, starty, 40/myX*sx, 40/myY*sy, tocolor(30, 30, 30, 240*a))
                    dxDrawRectangle(sx*0.8+4/myX*sx, starty+2/myY*sy, 36/myX*sx, 36/myY*sy, tocolor(40, 40, 40, 240*a))

                    dxDrawImage(sx*0.8+10/myX*sx, starty+7/myY*sy, 25/myX*sx, 25/myY*sy, "files/"..(v.icon)..".png")

                    if core:isInSlot(sx*0.8+10/myX*sx, starty+7/myY*sy, 25/myX*sx, 25/myY*sy) or a_panel_selected_itemType == k then 
                        dxDrawImage(sx*0.8+10/myX*sx, starty+7/myY*sy, 25/myX*sx, 25/myY*sy, "files/"..(v.icon)..".png", 0, 0, 0, tocolor(r, g, b, 255*a))
                    else
                        dxDrawImage(sx*0.8+10/myX*sx, starty+7/myY*sy, 25/myX*sx, 25/myY*sy, "files/"..(v.icon)..".png", 0, 0, 0, tocolor(255, 255, 255, 255*a))
                    end

                    starty = starty + 42/myY*sy
                end

                local starty = sy*0.295+sy*0.03+2/myY*sy 
                local startx = sx*0.609
                local index = 0
                for k, v in ipairs(shopItems[a_panel_selected_itemType].items) do 
                    index = index + 1

                    if shopHaveItem(v) then 
                        dxDrawImage(startx, starty, 40/myX*sx, 40/myY*sy, inventory:getItemImage(v), 0, 0, 0, tocolor(255, 255, 255, 255*a)) 
                    else
                        dxDrawImage(startx, starty, 40/myX*sx, 40/myY*sy, inventory:getItemImage(v), 0, 0, 0, tocolor(255, 255, 255, 70*a))
                    end

                    startx = startx + 42/myX*sx
                    if index == 7 then
                        startx = sx*0.609
                        starty = starty + 42/myY*sy
                        index = 0
                    end
                end
            end

            dxDrawRectangle(sx*0.6+4/myX*sx, sy*0.632, sx*0.2-4/myX*sx, sy*0.03, tocolor(40, 40, 40, 240*a))

            if core:isInSlot(sx*0.6+4/myX*sx, sy*0.632, sx*0.2-4/myX*sx, sy*0.03) then 
                dxDrawText("MENTÉS", sx*0.6+2/myX*sx, sy*0.632, sx*0.6+2/myX*sx+sx*0.2-4/myX*sx, sy*0.632+sy*0.03, tocolor(r, g, b, 255*a), 1/myX*sx, fonts["bebasneue-11"], "center", "center", false, false, false, true)
            else
                dxDrawText("MENTÉS", sx*0.6+2/myX*sx, sy*0.632, sx*0.6+2/myX*sx+sx*0.2-4/myX*sx, sy*0.632+sy*0.03, tocolor(255, 255, 255, 255*a), 1/myX*sx, fonts["bebasneue-11"], "center", "center", false, false, false, true)
            end
        end
    end
end

function shopKey(key, state)
    if state then 
        if core:isInSlot(sx*0.3, sy*0.25, sx*0.4, sy*0.409) then
            if panelType == "normal" then 
                if key == "mouse_wheel_down" then  
                    if pointer + 9 < #items then 
                        pointer = pointer + 1
                    end 
                end
            else
                if key == "mouse_wheel_down" then  
                    if pointer + 9 < #businessBuyableItems then 
                        pointer = pointer + 1
                    end 
                end
            end

            if key == "mouse_wheel_up" then  
                if pointer > 0 then 
                    pointer = pointer - 1
                end 
            end
        end

        if key == "mouse1" then 
            if getElementData(shopElement, "shop:private") == 1 then 
                if getElementData(shopElement, "shop:owner") == 0 then 
                    if core:isInSlot(sx*0.404, sy*0.51, sx*0.095, sy*0.03) then 
                        if getElementData(localPlayer, "char:money") >= openedShopDatas.cost then 
                            
                            openedShopDataStatus = "requested"
                            triggerServerEvent("shop > business > buyShop", resourceRoot, shopElement)

                            getAllOwnedShop()
                        else
                            outputChatBox(core:getServerPrefix("red-dark", "Bolt", 2).."Nincs elég pénzed a bolt megvásárláshoz!", 255, 255, 255, true)
                        end
                    end

                    if core:isInSlot(sx*0.404 + sx*0.096, sy*0.51, sx*0.095, sy*0.03) then 
                        closeShop()
                    end
                    return 
                end
            end

            local starty = sy*0.285
            for i = 1, 9 do 
                if items[i+pointer] then 
                    if core:isInSlot(sx*0.55, starty, sx*0.05, sy*0.04) then 
                        if type(items[i+pointer]) == "table" then 
                            if getElementData(localPlayer, "char:money") >= items[i+pointer][2] then 
                                openedShopDataStatus = "requested"
                                triggerServerEvent("shop > buyShopItem", resourceRoot, items[i+pointer][1], items[i+pointer][2], "business", shopElement)
                                boughtItemCount = boughtItemCount + 1
    
                                if boughtItemCount >= 25 then 
                                    closeShop()
                                end
                            else
                                outputChatBox(core:getServerPrefix("red-dark", "Bolt", 2).."Nincs elég pénzed a vásárláshoz!", 255, 255, 255, true)
                            end
                        else
                            if getElementData(localPlayer, "char:money") >= itemPrices[items[i+pointer]] then 
                                triggerServerEvent("shop > buyShopItem", resourceRoot, items[i+pointer], itemPrices[items[i+pointer]])
                                boughtItemCount = boughtItemCount + 1
    
                                if boughtItemCount >= 25 then 
                                    closeShop()
                                end
                            else
                                outputChatBox(core:getServerPrefix("red-dark", "Bolt", 2).."Nincs elég pénzed a vásárláshoz!", 255, 255, 255, true)
                            end
                        end
                        
                    end
                end
                starty = starty + sy*0.04+2/myX*sx
            end

            if openedShopDatas.owner == getElementData(localPlayer, "char:id") then
                if core:isInSlot(sx*0.4, sy*0.66, sx*0.2, sy*0.03) then 
                    if panelType == "normal" then 
                        bolteladasCount = 0
                        panelType = "admin"
                        moneyEditbox = core:createEditbox(sx*0.575, sy*0.525, sx*0.05, sy*0.03, "moneyEditbox", "$", "text", true, {30, 30, 30, 255}, 1)
                    elseif panelType == "admin" then 
                        bolteladasCount = 0
                        panelType = "normal"
                        core:deleteEditbox("moneyEditbox")
                    end
                    pointer = 0
                end

                if panelType == "admin" then 
                    if (not orderPanelShowing) and (not priceSetPanelShowing) then
                        local starty = sy*0.275
                        for i = 1, 9 do 
                            if businessBuyableItems[i+pointer] then 
                                if core:isInSlot(sx*0.45, starty + sy*0.005, sx*0.02, sy*0.03) then 
                                    local pendingOrders = openedShopDatas.orders

                                    if #pendingOrders < 5 then
                                        orderPanelShowing = true
                                        core:deleteEditbox("moneyEditbox")
                                        inOrderItem, inOrderPrice, inOrderCountEditbox = businessBuyableItems[i+pointer][1], getElementData(resourceRoot, "shop:businessItemPrice:"..businessBuyableItems[i+pointer][1]), core:createEditbox(sx*0.475, sy*0.493, sx*0.05, sy*0.03, "orderCount", "db", "text", true, {30, 30, 30, 255}, 1, 3)
                                    else
                                        outputChatBox(core:getServerPrefix("red-dark", "Rendelés", 2).."Egyszerre csak "..color.."5db #fffffffolyamatban lévő rendelésed lehet!", 255, 255, 255, true)
                                    end
                                end

                                if core:isInSlot(sx*0.473, starty + sy*0.005, sx*0.02, sy*0.03) then 
                                    priceSetPanelShowing = true
                                    core:deleteEditbox("moneyEditbox")
                                    editedItem, editedItemPriceEditbox = businessBuyableItems[i+pointer][1], core:createEditbox(sx*0.475, sy*0.493, sx*0.05, sy*0.03, "priceEditbox", "$", "text", true, {30, 30, 30, 255}, 1, 4)
                                    core:setEditboxText("priceEditbox", (items[tostring(businessBuyableItems[i+pointer][1])][2] or ""))
                                end
                            end
                            starty = starty + sy*0.04+2/myX*sx
                        end

                        if core:isInSlot(sx*0.5255, sy*0.565, sx*0.15, sy*0.023) then 
                            local editboxMoneyValue = core:getEditboxText("moneyEditbox")
                            editboxMoneyValue = tonumber((editboxMoneyValue or 0))

                            if (editboxMoneyValue or 0) > 0 then 
                                if editboxMoneyValue <= openedShopDatas.money then 
                                    --setElementData(shopElement, "shop:money", getElementData(shopElement, "shop:money") - editboxMoneyValue)
                                    --setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money") + editboxMoneyValue)
                                    
                                    openedShopDataStatus = "requested"
                                    triggerServerEvent("shop > updateShopBusinessMoney", resourceRoot, shopElement, editboxMoneyValue)
                                    chat:sendLocalDoAction("kivesz "..editboxMoneyValue.."$-t a bolt számlájártól.")
                                    core:setEditboxText("moneyEditbox", "")
                                else
                                    infobox:outputInfoBox("Ennyi pénz nincs a bolt számlájának egyenlegén!", "error")
                                end
                            end
                        end

                        if core:isInSlot(sx*0.4, sy*0.215, sx*0.2, sy*0.03) then
                            if bolteladasCount > 0 then 
                                bolteladasCount = 0
                                -- bolt eladása
                                openedShopDataStatus = "requested"
                                triggerServerEvent("shop > business > sellShop", resourceRoot, shopElement)
                                closeShop()
                                
                            else
                                bolteladasCount = bolteladasCount + 1
                            end
                        end
                    elseif (orderPanelShowing) then
                        if core:isInSlot(sx*0.427, sy*0.547, (sx*0.15 / 2) - sx*0.003, sy*0.023) then 
                            local count = core:getEditboxText("orderCount")
                            if not (tonumber(count) == nil) then 
                                count = tonumber(count)
                            else
                                count = 0
                            end
                            local price = (inOrderPrice * count)

                            if count > 0 then 
                                if getElementData(localPlayer, "char:money") >= price then 
                                    openedShopDataStatus = "requested"

                                    triggerServerEvent("shop > business > makeOrder", resourceRoot, shopElement, inOrderItem, count, price)

                                    outputChatBox(core:getServerPrefix("green-dark", "Rendelés", 2).."Sikeresen rendeltél "..color..count.."#ffffffdb "..color..inventory:getItemName(inOrderItem).."#ffffff-(e)t.", 255, 255, 255, true)
                                    orderPanelShowing = false 
                                    moneyEditbox = core:createEditbox(sx*0.575, sy*0.525, sx*0.05, sy*0.03, "moneyEditbox", "$", "text", true, {30, 30, 30, 255}, 1)
                                    inOrderItem, inOrderPrice = 0, 0
                                    core:deleteEditbox("orderCount")

                                    if not isElement(pickupOrderBlip) then 
                                        pickupOrderBlip = createBlip(pickupOrderPos[1], pickupOrderPos[2], pickupOrderPos[3], 6)
                                        setElementData(pickupOrderBlip, "blip:name", "Rendelés felvétele")
                                    end
                                else
                                    outputChatBox(core:getServerPrefix("red-dark", "Rendelés", 2).."Nincs nálad elég pénz a rendeléshez.", 255, 255, 255, true)
                                end
                            else 
                                outputChatBox(core:getServerPrefix("red-dark", "Rendelés", 2).."0 db ot nem tudsz rendelni!.", 255, 255, 255, true) 
                            end 
                        end

                        if core:isInSlot(sx*0.427 + (sx*0.15 / 2) - sx*0.0005, sy*0.547, (sx*0.15 / 2) - sx*0.003, sy*0.023) then 
                            orderPanelShowing = false 
                            inOrderItem, inOrderPrice = 0, 0
                            core:deleteEditbox("orderCount")
                            moneyEditbox = core:createEditbox(sx*0.575, sy*0.525, sx*0.05, sy*0.03, "moneyEditbox", "$", "text", true, {30, 30, 30, 255}, 1)
                        end
                    elseif (priceSetPanelShowing) then 
                        if core:isInSlot(sx*0.427, sy*0.547, (sx*0.15 / 2) - sx*0.003, sy*0.023) then 
                            local price = core:getEditboxText("priceEditbox")

                            price = tonumber(price) or 0
                            
                            outputChatBox(core:getServerPrefix("green-dark", "Bolt", 2).."Sikeresen beállítottad a kiválasztott árucikk árát.", 255, 255, 255, true)

                            openedShopDataStatus = "requested"
                            triggerServerEvent("shop > business > setItemPrice", resourceRoot, shopElement, editedItem, price)
                                
                            priceSetPanelShowing = false 
                            editedItem = 0
                            core:deleteEditbox("priceEditbox")
                            moneyEditbox = core:createEditbox(sx*0.575, sy*0.525, sx*0.05, sy*0.03, "moneyEditbox", "$", "text", true, {30, 30, 30, 255}, 1)
                        end

                        if core:isInSlot(sx*0.427 + (sx*0.15 / 2) - sx*0.0005, sy*0.547, (sx*0.15 / 2) - sx*0.003, sy*0.023) then 
                            priceSetPanelShowing = false 
                            editedItem = 0
                            core:deleteEditbox("priceEditbox")
                            moneyEditbox = core:createEditbox(sx*0.575, sy*0.525, sx*0.05, sy*0.03, "moneyEditbox", "$", "text", true, {30, 30, 30, 255}, 1)
                        end
                    end
                end
            end

            if (getElementData(localPlayer, "user:admin") >= 6 and getElementData(localPlayer, "user:aduty")) and (getElementData(shopElement, "shop:owner") or 0) == 0 then 
                if core:isInSlot(sx*0.6-40/myX*sx+2/myX*sx, sy*0.67+2/myY*sy, 36/myX*sx, 36/myY*sy) then 
                    a_panel_showing = not a_panel_showing
                end
        
                if a_panel_showing then 
                
                    if core:isInSlot(sx*0.6+4/myX*sx, sy*0.285, sx*0.1-4/myX*sx, sy*0.03) then 
                        a_panel_page = 1
                    end
        
                    if core:isInSlot(sx*0.7+4/myX*sx, sy*0.285, sx*0.1-4/myX*sx, sy*0.03) then 
                        a_panel_page = 2    
                    end
        
                    if a_panel_page == 1 then
                        local starty = sy*0.285+sy*0.03+2/myY*sy 
        
                        for k, v in ipairs(shopTemplates) do 
                            if core:isInSlot(sx*0.6+4/myX*sx, starty, sx*0.2-4/myX*sx, sy*0.03) then 
                                items = v.items
                            end
                            starty = starty + sy*0.03+2/myY*sy
                        end
                    elseif a_panel_page == 2 then 
                        local starty = sy*0.285+sy*0.03+2/myY*sy 

                        for k, v in ipairs(shopItems) do 
                            if core:isInSlot(sx*0.8+10/myX*sx, starty+7/myY*sy, 25/myX*sx, 25/myY*sy) then 
                                a_panel_selected_itemType = k
                            end

                            starty = starty + 42/myY*sy
                        end

                        local starty = sy*0.295+sy*0.03+2/myY*sy 
                        local startx = sx*0.609
                        local index = 0
                        for k, v in ipairs(shopItems[a_panel_selected_itemType].items) do 
                            index = index + 1

                            if core:isInSlot(startx, starty, 40/myX*sx, 40/myY*sy) then 
                                if shopHaveItem(v) then 
                                    for k2, v2 in ipairs(items) do 
                                        if v == v2 then 
                                            table.remove(items, k2)
                                        end
                                    end
                                else
                                    table.insert(items, #items+1, v)
                                end
                            end

                            startx = startx + 42/myX*sx
                            if index == 7 then
                                startx = sx*0.609
                                starty = starty + 42/myY*sy
                                index = 0
                            end
                        end
                    end

                    
                    if core:isInSlot(sx*0.6+4/myX*sx, sy*0.632, sx*0.2-4/myX*sx, sy*0.03) then 
                        if not (toJSON(items) == toJSON(getElementData(shopElement, "shop:ped:items"))) then 
                            triggerServerEvent("setShopPedItems", resourceRoot, shopElement, items)
                            infobox:outputInfoBox("Sikeresen elmentetted a bolt beállításait!", "success")
                        end
                    end
                end
            end
        end
    end
end

local allOrder = {}
local orderPointer = 0
local orderPanelTick = getTickCount()

local orderPanelState = 1
local orderPanelAnimState = "close"
local orderPanelAlpha = 0
local selectedOrderShop = false 

function renderOrderPanel()
    
    if core:getDistance(orderPed, localPlayer) > 4 then 
        closeOrderPanel()
    end

    if orderPanelAnimState == "open" then
        orderPanelAlpha = interpolateBetween(orderPanelAlpha, 0, 0, 1, 0, 0, (getTickCount() - orderPanelTick) / 200, "Linear")
    else
        orderPanelAlpha = interpolateBetween(orderPanelAlpha, 0, 0, 0, 0, 0, (getTickCount() - orderPanelTick) / 200, "Linear")
    end

    core:drawWindow(sx*0.35, sy*0.4, sx*0.3, sy*0.245, "Rendelések", orderPanelAlpha)

    allOrder = openedShopDatas.orders
    outputDebugString(toJSON(openedShopDatas.orders))

    if openedShopDataStatus == "done" then
        local startY = sy*0.429


        for i = 1, 4 do
            local alpha = 150

            if ((i+orderPointer) % 2) == 0 then 
                alpha = 200
            end


            dxDrawRectangle(sx*0.35 + sx*0.005, startY, sx*0.285, sy*0.05, tocolor(30, 30, 30, alpha * orderPanelAlpha))
            if allOrder[i + orderPointer] then
                dxDrawImage(sx*0.35 + sx*0.005 + 3/myX*sx, startY + 2.5/myX*sx, 40/myX*sx, 40/myX*sx, inventory:getItemImage(allOrder[i + orderPointer][1]), 0, 0, 0, tocolor(255, 255, 255, 255 * orderPanelAlpha))
                dxDrawText("Bolt neve: "..color..openedShopDatas.name, sx*0.35 + sx*0.035, startY + 2.5/myX*sx, sx*0.35, startY + sy*0.03, tocolor(255, 255, 255, 255 * orderPanelAlpha), 0.9/myX*sx, fonts["condensed-10"], "left", "center", false, false, false, true)
                dxDrawText("Mennyiség: "..color..(allOrder[i + orderPointer][2]).."#ffffffdb", sx*0.35 + sx*0.035, startY + 2.5/myX*sx, sx*0.35, startY + sy*0.045, tocolor(255, 255, 255, 255 * orderPanelAlpha), 0.9/myX*sx, fonts["condensed-10"], "left", "bottom", false, false, false, true)
                core:dxDrawButton(sx*0.582 + sx*0.005 + 3/myX*sx, startY + 2.5/myX*sx, sx*0.05, 40/myX*sx, r, g, b, 200 * orderPanelAlpha, "Bepakolás", tocolor(255, 255, 255, 255 * orderPanelAlpha), 0.65/myX*sx, fonts["condensed-12"], true, tocolor(0, 0, 0, 100 * orderPanelAlpha))
            end

            startY = startY + sy*0.052
        end

        local lineHeight = math.min(4 / #allOrder, 1)

        dxDrawRectangle(sx*0.643 , sy*0.429, sx*0.0015, sy*0.203, tocolor(r, g, b, 75*orderPanelAlpha))
        dxDrawRectangle(sx*0.643 , sy*0.429 + (sy*0.203 * (lineHeight * orderPointer / 4)), sx*0.0015, sy*0.203 * lineHeight, tocolor(r, g, b, 200*orderPanelAlpha))
      
    end
end

local deliveryBlip = nil
function keyOrderPanel(key, state)
    if state then 
        if key == "mouse_wheel_up" then 
            if orderPointer > 0 then 
                orderPointer = orderPointer - 1
            end
        end

        if key == "mouse_wheel_down" then 
            if orderPointer + 4 < #allOrder then 
                orderPointer = orderPointer + 1
            end
        end

        if key == "backspace" then 
            closeOrderPanel()
        end

        if openedShopDataStatus == "done" then
            if key == "mouse1" then 
                local startY = sy*0.429
                for i = 1, 4 do
                    if core:isInSlot(sx*0.582 + sx*0.005 + 3/myX*sx, startY + 2.5/myX*sx, sx*0.05, 40/myX*sx) then 
                        local pickupVeh = getTransportCar()

                        if pickupVeh then 
                            local inTransportID = getElementData(pickupVeh, "veh:shop:inTransportShop") or 0
                            local inTransportBoxes = getElementData(pickupVeh, "veh:shop:inTransportBoxes") or {}

                            if (inTransportID == 0) or (inTransportID == openedShopDatas.shopID) then
                                if #inTransportBoxes < 4 then 

                                    if not isElement(deliveryBlip) then 
                                        --for k, v in pairs(playerAllShopTable) do 
                                            --if openedShopDatas.shopID == allOrder[i + orderPointer][1] then 
                                                local x, y, z = unpack(openedShopDatas.deliveryArea)

                                                deliveryCol = openedShopDatas.shopID
                                                deliveryBlip = createBlip(x, y, z, 5)
                                                setElementData(deliveryBlip, "blip:name", "Leszállítási bolt")
                                                outputChatBox(core:getServerPrefix("server", "Bolt", 2).."A boltodat megjelöltük a térképen!", 255, 255, 255, true)
                                               -- break
                                            --end
                                        --end
                                    end

                                    if (#allOrder - 1) == 0 then 
                                        if isElement(pickupOrderBlip) then 
                                            destroyElement(pickupOrderBlip)
                                            pickupOrderBlip = false 
                                        end
                                    end

                                    triggerServerEvent("shop > business > takeOrder", resourceRoot, pickupVeh, allOrder[i + orderPointer], openedShopDatas.shopID)
                                    closeOrderPanel()
                                    orderPointer = 0
                                else
                                    infobox:outputInfoBox("Több doboz már nem fér fel.", "error")
                                end
                            else
                                infobox:outputInfoBox("Egyszerre csak egy boltba szállíthatsz árut.", "error")
                            end
                        else
                            infobox:outputInfoBox("Nincs megfelelő jármű a raktár előtt.", "error")
                        end
                    end

                    startY = startY + sy*0.052
                end
            end
        end
    end
end

function openOrderPanel()
    allOrder = {}

    --getAllOwnedShop()
    --[[for k, v in pairs(playerAllShopTable) do
        local orders = getElementData(v, "shop:orders")
        
        for k2, v2 in pairs(orders) do 
            table.insert(allOrder, {getElementData(v, "shop:id"), getElementData(v, "ped:name"), v2[1], v2[2]})
        end
    end]]

    openedShopDataStatus = "requested"
    triggerServerEvent("shop > getOwnedShopBusinessDatasFromSever", resourceRoot)

    if orderPanelAnimState == "close" then 
        orderPanelAnimState = "open"
        orderPanelTick = getTickCount()

        addEventHandler("onClientRender", root, renderOrderPanel)
        addEventHandler("onClientKey", root, keyOrderPanel)
    end
end

function closeOrderPanel()
    if orderPanelAnimState == "open" then
        orderPanelAnimState = "close"
        orderPanelTick = getTickCount()

        removeEventHandler("onClientKey", root, keyOrderPanel)
        
        setTimer(function()
            removeEventHandler("onClientRender", root, renderOrderPanel)
        end, 200, 1)
    end
end

local playerLastVeh = nil 

addEventHandler("onClientVehicleEnter", root, function(ped, seat)
    if ped == localPlayer then 
        if getElementData(source, "veh:owner") == getElementData(localPlayer, "char:id") then 
            if getElementModel(source) == 422 then
                playerLastVeh = source
            else
                playerLastVeh = nil
            end
        else
            playerLastVeh = nil
        end
    end
end)

addEventHandler("onClientColShapeHit", resourceRoot, function(player, mdim)
    if player == localPlayer then 
        if mdim then 
            local playerVeh = getPedOccupiedVehicle(localPlayer)
            if playerVeh then 
                if getPedOccupiedVehicleSeat(localPlayer) == 0 then
                    local shopID1 = getElementData(playerVeh, "veh:shop:inTransportShop") or 0
                    local shopID2 = getElementData(source, "deliveryArea:shop") or 0
                    
                    if shopID1 > 0 then 
                        if shopID1 == shopID2 then 
                            triggerServerEvent("shop > business > completeDelivery", resourceRoot, playerVeh, source)
                            infobox:outputInfoBox("Sikeresen leszálítottad az árut!", "success")
                            deliveryCol = false

                            if isElement(deliveryBlip) then destroyElement(deliveryBlip) end
                        end
                    end
                end
            end
        end
    end
end)

local o3D = exports.o3DElements

local colShape1, colShape2 = createColRectangle(-20.256324768066 - 5.7,-269.74282836914-10, 5.7, 10), createColRectangle(-11.756324768066 - 5.7,-269.74282836914 - 10, 5.7, 10)

function renderTransportZone()
    if isElement(playerLastVeh) then 
        if isElementWithinColShape(playerLastVeh, colShape1) then 
            o3D:render3DZone(-20.256324768066,-269.74282836914, 4.5, -5.7, -10, r, g, b, 100, 25, 6)
        else
            o3D:render3DZone(-20.256324768066,-269.74282836914, 4.5, -5.7, -10, 255, 255, 255, 100, 25, 6)
        end

        if isElementWithinColShape(playerLastVeh, colShape2) then 
            o3D:render3DZone(-11.756324768066,-269.74282836914, 4.5, -5.7, -10, r, g, b, 100, 25, 6)
        else
            o3D:render3DZone(-11.756324768066,-269.74282836914, 4.5, -5.7, -10, 255, 255, 255, 100, 25, 6)
        end
    else
        o3D:render3DZone(-11.756324768066,-269.74282836914, 4.5, -5.7, -10, 255, 255, 255, 100, 25, 6)
        o3D:render3DZone(-20.256324768066,-269.74282836914, 4.5, -5.7, -10, 255, 255, 255, 100, 25, 6)
    end
end
addEventHandler("onClientRender", root, renderTransportZone)

function getTransportCar()
    if isElement(playerLastVeh) then
        if isElementWithinColShape(playerLastVeh, colShape1) or isElementWithinColShape(playerLastVeh, colShape2) then 
            return playerLastVeh
        end
    end

    return false
end 

addEventHandler("onClientClick", root, function(key, state, _, _, _, _, _, element)
    if key == "right" then 
        if state == "up" then 
            if element then 
                if core:getDistance(localPlayer, element) < 4 then 
                    if getElementData(element, "isShopPed") then 
                        if not showing then 
                            if not isTimer(closeTimer) then 
                                if getElementData(element, "shop:isRobbable") then 
                                    items = getElementData(element, "shop:ped:items")
                                    showing = true
                                    shopElement = element
                                    openedShopDataStatus = false
                                    if getElementData(element, "shop:private") == 1 then
                                        openedShopDataStatus = "requested"
                                        triggerServerEvent("shop > getShopBusinessDatasFromSever", resourceRoot, element)

                                    end
                                    openShop()
                                else
                                    outputChatBox(core:getServerPrefix("red-dark", "Bolt", 2).."Ez a bolt nem régen lett kirabolva! Várd meg még újra feltöltik az árut!", 255, 255, 255, true)
                                end
                            end
                        end
                    elseif element == orderPed then 
                        openOrderPanel()
                    end
                end
            end
        end
    end
end)

function openShop()
    pointer = 0
    bolteladasCount = 0
    panelType = "normal"
    tick = getTickCount()
    animationType = "open"
    addEventHandler("onClientRender", root, renderPanel)
    addEventHandler("onClientKey", root, shopKey)
    setElementData(localPlayer,"inShop",true)
    bindKey("backspace", "up", closeShop)
end

function closeShop()
    unbindKey("backspace", "up", closeShop)
    tick = getTickCount()
    animationType = "close"

    removeEventHandler("onClientKey", root, shopKey)

    closeTimer = setTimer(function() 
        showing = false
        removeEventHandler("onClientRender", root, renderPanel)
    end, 300, 1)

    orderPanelShowing = false 
    inOrderItem, inOrderPrice = 0, 0
    core:deleteEditbox("orderCount")

    priceSetPanelShowing = false 
    editedItem = 0
    core:deleteEditbox("priceEditbox")
    setElementData(localPlayer,"inShop",false)

    core:deleteEditbox("moneyEditbox")
end

setTimer(function()
    if boughtItemCount >= 5 then
        boughtItemCount = boughtItemCount - 5
    end
end, 1000, 0)

function shopHaveItem(id)
    local have = false

    for k, v in ipairs(items) do 
        if v == id then 
            have = true 
            break
        end
    end

    return have
end

addCommandHandler("nearbyshops", function(player, cmd)
    if getElementData(localPlayer, "user:admin") >= 4 then 
        local nearbyShops = {}
        for k, v in ipairs(getElementsByType("ped")) do 
            if getElementData(v, "isShopPed") then 
                if core:getDistance(localPlayer, v) < 10 then 
                    if getElementDimension(localPlayer) == getElementDimension(v) then
                        table.insert(nearbyShops, #nearbyShops+1, v)
                    end
                end
            end
        end

        if #nearbyShops >= 1 then 
            outputChatBox(color.."<==== #ffffffKözeledben lévő boltok "..color.."====>", 255, 255, 255, true)
            for k, v in ipairs(nearbyShops) do 
                local type = "Állami"

                if getElementData(v, "shop:private") == 1 then 
                    type = "Magán"
                    outputChatBox(color.."ID:#ffffff "..( getElementData(v, "shop:id") or 0)..color.." Név:#ffffff "..( getElementData(v, "ped:name") or "nan" )..color.." Típus: #ffffff"..type..color.." Tulajdonos: #ffffff"..(getElementData(v, "shop:owner") or 0)..color.." Bolt egyenlege: #ffffff"..(getElementData(v, "shop:money") or 0).."$", 255, 255, 255, true)
                else
                    outputChatBox(color.."ID:#ffffff "..( getElementData(v, "shop:id") or 0)..color.." Név:#ffffff "..( getElementData(v, "ped:name") or "nan" )..color.." Típus: #ffffff"..type, 255, 255, 255, true)
                end

            end
        end
    end
end)

local deliveryPos = {0, 0, 0, 0, 0}
local pendingShopDatas = {}
local inShopCreate = false

function createDeliveryArea()
    local x, y, z = getElementPosition(localPlayer)

    if deliveryPos[1] == 0 then 
        dxDrawLine3D(x, y, z - 1, x, y, z +3, tocolor(r, g, b, 100), 5)

        if getKeyState("lalt") then 
            if getElementDimension(localPlayer) == 0 and getElementInterior(localPlayer) == 0 then
                deliveryPos[1] = x
                deliveryPos[2] = y
                deliveryPos[3] = z - 0.9
                outputChatBox(core:getServerPrefix("server", "Bolt létrehozás", 3).."Most add meg a terület méretét, majd nyomd meg az "..color.."ENTER #ffffffgombot.", 255, 255, 255, true)
            end
        end
    else
        o3D:render3DZone(deliveryPos[1], deliveryPos[2], deliveryPos[3], x - deliveryPos[1], y - deliveryPos[2], r, g, b, 100, 25, 6)

        deliveryPos[4] = x - deliveryPos[1] 
        deliveryPos[5] = y - deliveryPos[2]

        if getKeyState("enter") then
            if getElementDimension(localPlayer) == 0 and getElementInterior(localPlayer) == 0 then
                removeEventHandler("onClientRender", root, createDeliveryArea)
                pendingShopDatas[7] = deliveryPos

                triggerServerEvent("shop > makeShop", resourceRoot, unpack(pendingShopDatas))

                inShopCreate = false
            end
        end
    end
end

addCommandHandler("makeshop", function(cmd,name,skin,private,cost,money)
    if getElementData(localPlayer, "user:admin") >= 7 then
        if name and skin then 
            if inShopCreate then return end 

            skin = tonumber(skin)
            name = tostring(name)

            local x,y,z = getElementPosition(localPlayer)
            local rotX,rotY,rotZ = getElementRotation(localPlayer)

            local interior = getElementInterior(localPlayer)
            local dimension = getElementDimension(localPlayer)

            local pos = toJSON({x, y, z, rotZ, interior, dimension})

            private = tonumber(private) or 0 
            cost = cost or 0

            if private == 0 then 
                triggerServerEvent("shop > makeShop", resourceRoot, name, skin, pos, private, cost, 0, {})
            else
                inShopCreate = true 

                deliveryPos = {0, 0, 0, 0, 0}
                pendingShopDatas = {name, skin, pos, private, cost, 0, {}}
                addEventHandler("onClientRender", root, createDeliveryArea)
                outputChatBox(core:getServerPrefix("server", "Bolt létrehozás", 3).."Most hagyd el az interiort és hozd létre a rakodási területet. Ha a megfelelő helyen vagy nyomd meg az "..color.."ALT #ffffffgombot.", 255, 255, 255, true)
            end
        else 
            outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Név] [Skin] [Biznisz (0, 1)] [Ára]", 255, 255, 255, true)
        end
    end
end)

addEventHandler("onClientRender", root, function()
    --if #playerAllShopTable > 0 then
        if deliveryCol then
            if getElementDimension(localPlayer) == 0 and getElementInterior(localPlayer) == 0 then
                for k, v in pairs(getElementsByType("colshape", resourceRoot, true)) do 
                    if isElement(v) then
                        if getElementData(v, "deliveryArea:shop") == deliveryCol then
                            --outputChatBox("asd")
                            --local col = getElementData(v, "shop:deliveryArea")

                            --if isElement(col) then
                                local pos = getElementData(v, "deliveryArea:position")
                
                                o3D:render3DZone(pos[1], pos[2], pos[3], pos[4], pos[5], 255, 255, 255, 100, 25, 6)
                            --send
                        end
                    end
                end 
            end
        end
    --end
end)

addEvent("shop > sendShopBusinessDataToClient", true)
addEventHandler("shop > sendShopBusinessDataToClient", localPlayer, function(data)
    --outputChatBox(toJSON(data))
    if not data then 
        closeShop()
    else
        openedShopDatas = data
        openedShopDataStatus = "done"
    end
end)