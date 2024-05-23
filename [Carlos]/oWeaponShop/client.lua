addEventHandler("onClientResourceStart", root, function(res)
    if getResourceName(res) == "oCore" or getResourceName(res) == "oInfobox" or getResourceName(res) == "oWeaponShop" or getResourceName(res) == "oInventory" then  
        core = exports.oCore
        color, r, g, b = core:getServerColor()
        infobox = exports.oInfobox
        inventory = exports.oInventory
	end
end)

local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900

local panelTick = getTickCount()
local panelAnimation = "open"
local panelShowing = false
local activeped = false

local fonts = {
    ["condensed-15"] = exports.oFont:getFont("condensed", 15),
    ["bebasneue-17"] = exports.oFont:getFont("bebasneue", 17),
    ["bebasneue-55"] = exports.oFont:getFont("bebasneue", 100),
}

for k, v in ipairs(shops) do 
    local weaponShopPed = createPed(312, v[1], v[2], v[3], v[4])
    setElementDimension(weaponShopPed, v[5])
    setElementInterior(weaponShopPed, v[6])
    setElementFrozen(weaponShopPed, true)
    setElementData(weaponShopPed, "ped:name", "Jacob Huff")
    setElementData(weaponShopPed, "ped:prefix", "Fegyverbolt")
    setPedAnimation(weaponShopPed, "cop_ambient", "coplook_loop", -1, true, false, false)
end

local panelAlpha = 0 
local panelY = 0
function renderStatPanel()
    if panelAnimation == "open" then 
        panelAlpha = interpolateBetween(panelAlpha, 0, 0, 1, 0, 0, (getTickCount()-panelTick)/500, "Linear")
    else
        panelAlpha = interpolateBetween(panelAlpha, 0, 0, 0, 0, 0, (getTickCount()-panelTick)/500, "Linear")
    end

    if distanceCheckNeeded then 
        if core:getDistance(localPlayer, activeped) > 3 then 
            showPanel()
        end

        if getKeyState("backspace") then 
            showPanel()
        end
    end

    panelY = sy*0.5 - ((sy*0.055 + (sy*0.037 * #weaponShopItems)) / 2)

    dxDrawRectangle(sx*0.4, panelY, sx*0.2, sy*0.055 + (sy*0.037 * #weaponShopItems), tocolor(35, 35, 35, 255*panelAlpha))
    dxDrawRectangle(sx*0.4+2/myX*sx, panelY+2/myY*sy, sx*0.2-4/myX*sx, sy*0.05, tocolor(30, 30, 30, 255*panelAlpha))
    dxDrawText("Fegyverbolt", sx*0.4+2/myX*sx, panelY+2/myY*sy, sx*0.4+2/myX*sx+sx*0.2-4/myX*sx, panelY+2/myY*sy+sy*0.05, tocolor(255, 255, 255, 255*panelAlpha), 1/myX*sx, fonts["bebasneue-17"], "center", "center")

    local startY = panelY + sy*0.055
    for i = 1, #weaponShopItems do 
        local alpha = 255 

        if i % 2 == 0 then 
            alpha = 180
        end

        dxDrawRectangle(sx*0.4+2/myX*sx, startY, sx*0.2-4/myX*sx, sy*0.035, tocolor(30, 30, 30, alpha*panelAlpha))
        dxDrawRectangle(sx*0.4+2/myX*sx, startY, sx*0.001, sy*0.035, tocolor(r, g, b, alpha*panelAlpha))

        if weaponShopItems[i] then 
            dxDrawImage(sx*0.4 + 5/myX*sx, startY + 2/myY*sy, 28/myX*sx, 28/myY*sy, inventory:getItemImage(weaponShopItems[i][1]), 0, 0, 0, tocolor(255, 255, 255, 255*panelAlpha))
            dxDrawText(inventory:getItemName(weaponShopItems[i][1]), sx*0.4+40/myX*sx, startY, sx*0.4+10/myX*sx+sx*0.1, startY+sy*0.02, tocolor(255, 255, 255, 255*panelAlpha), 0.6/myX*sx, fonts["condensed-15"], "left", "center", false, false, false, true)
            dxDrawText(color..weaponShopItems[i][2].."#ffffffdb | #43a155"..weaponShopItems[i][3].."#ffffff$", sx*0.4+40/myX*sx, startY, sx*0.4+10/myX*sx+sx*0.1, startY+sy*0.032, tocolor(255, 255, 255, 150*panelAlpha), 0.55/myX*sx, fonts["condensed-15"], "left", "bottom", false, false, false, true)
       
            core:dxDrawButton(sx*0.557, startY+3/myY*sy, sx*0.04, sy*0.03, r, g, b, 150*panelAlpha, "Vásárlás", tocolor(255, 255, 255, 255*panelAlpha),  0.55/myX*sx, fonts["condensed-15"], true, tocolor(0, 0, 0, 100*panelAlpha))
        end

        startY = startY + sy*0.037
    end
end

function keyStatPanel(key, state)
    if key == "mouse1" and state then 
        local startY = panelY + sy*0.055
        for i = 1, #weaponShopItems do 
            if weaponShopItems[i] then
                if core:isInSlot(sx*0.557, startY+3/myY*sy, sx*0.04, sy*0.03) then
                    if getElementData(localPlayer, "char:money") >= weaponShopItems[i][3] then 
                        if ((inventory:getItemWeight(weaponShopItems[i][1]) * weaponShopItems[i][2]) + inventory:getAllItemWeight()) <= 20 then
                            showPanel()
                            triggerServerEvent("weaponShop > buyItem", resourceRoot, weaponShopItems[i][1], weaponShopItems[i][2], weaponShopItems[i][3])
                            infobox:outputInfoBox("Sikeres vásárlás!", "success")
                        else
                            infobox:outputInfoBox("Nincs elég hely az inventorydban a vásárláshoz!", "error")
                        end
                    else
                        infobox:outputInfoBox("Nincs elég pénzed a vásárláshoz!", "error")
                    end
                end
            end

            startY = startY + sy*0.037
        end
    end
end

function showPanel()
    if panelShowing then 
        panelShowing = false
        distanceCheckNeeded = false
        removeEventHandler("onClientKey", root, keyStatPanel)
        panelTick = getTickCount()
        panelAnimation = "close"
        setTimer(function() 
            removeEventHandler("onClientRender", root, renderStatPanel)
        end, 500, 1)
    else
        distanceCheckNeeded = true
        panelShowing = true
        panelTick = getTickCount()
        panelAnimation = "open"
        addEventHandler("onClientKey", root, keyStatPanel)
        addEventHandler("onClientRender", root, renderStatPanel)
    end
end

local lastClick = 0
addEventHandler("onClientClick", root, function(key, state, _, _, _, _, _, element)
    if key == "right" and state == "up" then 
        if isElement(element) then
            if getElementData(element, "ped:prefix") == "Fegyverbolt" then 
                if core:getDistance(localPlayer, element) < 3 then 
                    if exports.oLicenses:playerHasValidLicense(68) then
                        if lastClick + 500 < getTickCount() then
                            activeped = element
                            showPanel()
                            lastClick = getTickCount()
                        end
                    else
                        outputChatBox(core:getServerPrefix("red-dark", "Fegyverbolt", 2).."Csak érvényes fegyvertartási engedéllyel vásárolhatsz a fegyverboltban!", 255, 255, 255, true)
                    end
                end
            end
        end
    end
end)