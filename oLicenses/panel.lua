local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900

local showing = false
local animState = 1
local pA = 0
local tick = getTickCount()
local closeing = false
local clickedElement = false
local inventory

local fonts = {
    ["menu-large"] = font:getFont("condensed",15,false),
    ["menu-medium"] = font:getFont("condensed",11,false),
    ["menu-small"] = font:getFont("condensed",9,false),
}

function renderPanel()

    if clickedElement then
        if not closeing then
            if core:getDistance(clickedElement, localPlayer) > 3 then
                closeing = true
                closePanel()
            end
        end
    end

    if animState == 1 then
        pA = interpolateBetween(pA,0,0,1,0,0,(getTickCount()-tick)/1000, "Linear")
    elseif animState == 2 then
        pA = interpolateBetween(pA,0,0,0,0,0,(getTickCount()-tick)/1000, "Linear")
    end

    shadowedText("Okmányiroda",sx*0.4,sy*0.35,sx*0.4+sx*0.2,sy*0.35+sy*0.02,220,220,220,255*pA,1/myX*sx,fonts["menu-large"],"center","center")
    dxDrawRectangle(sx*0.398,sy*0.377,sx*0.204,sy*0.241,tocolor(40,40,40,220*pA))
    dxDrawImage(0+(200/myX*sx),0+(140/myY*sy),sx-(400/myX*sx),sy-(280/myY*sy),":oJob/files/logo.png",0,0,0,tocolor(255,255,255,50*pA))

    local newy1 = 0.38
    for i=1, 6 do
        dxDrawRectangle(sx*0.4,sy*newy1, sx*0.2,sy*0.035,tocolor(30,30,30,240*pA))
        if menuPoints[i] then
            dxDrawText(menuPoints[i][1]..color.." ("..menuPoints[i][2].."$)",sx*0.405,sy*newy1,sx*0.405+sx*0.2,sy*newy1+sy*0.035,tocolor(255,255,255,255*pA),1/myX*sx,fonts["menu-medium"],"left","center", false, false, false, true)

            if core:isInSlot(sx*0.55,sy*newy1,sx*0.05,sy*0.035) then
                dxDrawText("Kiváltás", sx*0.405,sy*newy1,sx*0.395+sx*0.2,sy*newy1+sy*0.035,tocolor(r, g, b, 255*pA),1/myX*sx,fonts["menu-small"], "right", "center", false, false, false, true)
            else
                dxDrawText("Kiváltás", sx*0.405,sy*newy1,sx*0.395+sx*0.2,sy*newy1+sy*0.035,tocolor(255,255,255,255*pA),1/myX*sx,fonts["menu-small"], "right", "center", false, false, false, true)
            end
        end
        newy1 = newy1 + 0.04
    end
end

function panelKey(key, state)
    if key == "mouse1" then
        if state then
            if showing then
                local newy1 = 0.38
                for i=1, 6 do
                    if menuPoints[i] then
                        if core:isInSlot(sx*0.55,sy*newy1,sx*0.05,sy*0.035) then
                            if getElementData(localPlayer, "char:money") >= menuPoints[i][2] then
                                if i == 1 then
                                    local has, id, value, i, page = exports.oInventory:hasItem(65)

                                    if has then
                                        local name = string.sub(value,23)

                                        if name == getElementData(localPlayer, "char:name") then
                                            outputChatBox(core:getServerPrefix("red-dark", "Okmányiroda", 3).."Már van Személyi Igazolványod!", 255, 255, 255, true)
                                        else
                                            outputChatBox(core:getServerPrefix("green-dark", "Okmányiroda", 3).."Sikeresen kiváltottad a "..color.."Személyi Igazolványodat #ffffff.", 255, 255, 255, true)
                                            triggerServerEvent("licenses > giveLicenseToPlayer", root,localPlayer,"idcard")
                                        end
                                    else
                                        outputChatBox(core:getServerPrefix("green-dark", "Okmányiroda", 3).."Sikeresen kiváltottad a "..color.."Személyi Igazolványodat#ffffff.", 255, 255, 255, true)
                                        triggerServerEvent("licenses > giveLicenseToPlayer", root,localPlayer,"idcard")
                                    end

                                elseif i == 2 then
                                    if getElementData(localPlayer, "basic") == 1 then
                                        triggerServerEvent("givelicence", root, localPlayer)
                                        outputChatBox(core:getServerPrefix("green-dark", "Jogosítvány", 3).."Sikeresen átvetted a jogosítványodat!", 0, 0, 0, true)
                                        infobox:outputInfoBox("Átvetted a jogosítványodat!", "success")
                                    else
                                        outputChatBox(core:getServerPrefix("red-dark", "Jogosítvány", 3).."Először végezd el az autós iskolában a gépjármű vezetői vizsgát!", 0, 0, 0, true)
                                        infobox:outputInfoBox("Először el kell végezned a gépjármű vezetői vizsgát!", "warning")
                                    end
                                elseif i == 3 then
                                  outputChatBox(core:getServerPrefix("green-dark", "Okmányiroda", 3).."Sikeresen kiváltottad a"..color.." Horgászengedélyedet #ffffff.", 255, 255, 255, true)
                                  triggerServerEvent("licenses > giveLicenseToPlayer", root,localPlayer,"fishing")
                                end
                            else
                                outputChatBox(core:getServerPrefix("red-dark", "Okmányiroda", 3).."Nincs elegendő pénzed. "..color.."("..menuPoints[i][2].."$)", 255, 255, 255, true)
                            end
                            return
                        end
                    end
                    newy1 = newy1 + 0.04
                end
            end
        end
    end
end

function openPanel()
    animState = 1
    tick = getTickCount()

    addEventHandler("onClientRender", root, renderPanel)
    addEventHandler("onClientKey", root, panelKey)
    showing = true
    closeing = false
    bindKey("backspace", "up", closePanel)
end

function closePanel()
    closeing = true
    animState = 2
    tick = getTickCount()

    removeEventHandler("onClientKey", root, panelKey)
    setTimer(function()
        showing = false
        closeing = false
        removeEventHandler("onClientRender", root, renderPanel)

        unbindKey("backspace", "up", closePanel)
        clickedElement = false
    end, 1000, 1)
end

local refreshTimer

addEventHandler("onClientClick", root, function(key, state, _, _, _, _, _, element)
    if key == "right" then
        if state == "up" then
            if element then
                if getElementData(element, "isLicensesPed") then
                    if core:getDistance(element, localPlayer) < 3 then
                        if not showing then
                            openPanel()
                            clickedElement = element
                        end
                    end
                elseif getElementData(element, "isLicensesPed_2") then
                    if core:getDistance(element, localPlayer) < 3 then
                        if not isTimer(refreshTimer) then
                            local has, itemData = exports.oInventory:hasItem(65)

                            if has then
                                local name = string.sub(itemData["value"],23)

                                if name == getElementData(localPlayer, "char:name") then
                                    if getElementData(localPlayer, "char:money") >= 30 then
                                        refreshTimer = setTimer(function()
                                            if isTimer(refreshTimer) then
                                                killTimer(refreshTimer)
                                            end
                                        end, 1000*60, 1)
                                        triggerServerEvent("licenses > refreshPlayerIDCard", resourceRoot, id, value)
                                        outputChatBox(core:getServerPrefix("green-dark", "Okmányiroda", 3).."Sikeresen megújítottad a személyi igazolványodat "..color.."(30$-ért)#ffffff.", 255, 255, 255, true)
                                    else
                                        outputChatBox(core:getServerPrefix("red-dark", "Okmányiroda", 3).."Nincs nálad elegendő pénz, a személyi igazolványod megújításához "..color.."(30$)#ffffff.", 255, 255, 255, true)
                                    end
                                else
                                    outputChatBox(core:getServerPrefix("red-dark", "Okmányiroda", 3).."Nincs nálad személyi igazolvány!", 255, 255, 255, true)
                                end
                            else
                                outputChatBox(core:getServerPrefix("red-dark", "Okmányiroda", 3).."Nincs nálad személyi igazolvány!", 255, 255, 255, true)
                            end
                        else
                            outputChatBox(core:getServerPrefix("red-dark", "Okmányiroda", 3).."Csak "..color.."1 #ffffffpercenként újíthatod meg az igazolványodat!", 255, 255, 255, true)
                        end
                    end
                end
            end
        end
    end
end)

function shadowedText(text,x,y,x2,y2,r,g,b,a,size,font,align1,align2)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y+1,x2+1,y2+1,tocolor(0,0,0,a),size,font,align1,align2,false,false,false,false)
    dxDrawText(text,x,y,x2,y2,tocolor(r,g,b,a),size,font,align1,align2,false,false,false,true)
end
