function createSkinPeds()
    for k, v in ipairs(skinshops) do 
        for k2, v2 in ipairs(v[4]) do 
            local ped = createPed(v2[1], v2[3], v2[4], v2[5], v2[6])
            setElementFrozen(ped, true)

            setElementData(ped, "ped:name", "Próbababa")
            setElementInterior(ped, v[2])
            setElementDimension(ped, v[3])

            local col = createColSphere(v2[3], v2[4], v2[5], 1.5)
            setElementData(col, "skinshop:isSkinShopCol", true)
            setElementData(col, "skinshop:skinPrice", v2[2])
            setElementData(col, "skinshop:skinID", v2[1])
            setElementInterior(col, v[2])
            setElementDimension(col, v[3])

            setElementData(col, "skinshop:neededFaction", v2[7])
        end

        local elado = createPed(v[5][1],v[5][2],v[5][3],v[5][4],v[5][5])
        setElementFrozen(elado, true)
        setElementInterior(elado, v[2])
        setElementDimension(elado, v[3])
        setElementData(elado, "skinshop:skinDealer", true)
        setElementData(elado, "ped:name", "Eladó")
    end
end
createSkinPeds()

local selectedSkinData = false
addEventHandler("onClientColShapeHit", resourceRoot, function(player,mdim)

    if player == localPlayer then 

        if mdim then 

            if getElementData(source, "skinshop:isSkinShopCol") then 
                selectedSkinData = {}
                selectedSkinData[1] = getElementData(source, "skinshop:skinID")
                selectedSkinData[2] = getElementData(source, "skinshop:skinPrice")
                selectedSkinData[3] = getElementData(source, "skinshop:neededFaction") or 0

                addEventHandler("onClientRender", root, renderTooltipText)
                bindKey("e", "up", buySkin)
            end

        end
        
    end

end)

addEventHandler("onClientColShapeLeave", resourceRoot, function(player,mdim)
    
    if player == localPlayer then 

        if mdim then 

            if getElementData(source, "skinshop:isSkinShopCol") then 
                selectedSkinData = false
                removeEventHandler("onClientRender", root, renderTooltipText)

                unbindKey("e", "up", buySkin)
            end

        end
        
    end

end)

addEventHandler("onClientClick", root, function(key, state, _, _, _, _, _, element)
    if element then 
        if getElementData(element,"skinshop:skinDealer") then 
            if state == "down" and key == "right" then 
                if core:getDistance(localPlayer,element) < 5 then 
                    outputChatBox(core:getServerPrefix("server", "Ruhabolt", 3).."Válaszd ki a neked legjobban tetsző ruhát a próbababákon majd nyomd meg az "..color.."[E] #ffffffbillentyűt a vásárláshoz.",255,255,255,true)
                end
            end
        end
    end
end)

local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900
local font = exports.oFont:getFont("condensed", 11)
function renderTooltipText()
    if selectedSkinData then 
        if selectedSkinData[3] == 0 or dashboard:isPlayerFactionMember(selectedSkinData[3]) then
            shadowedText("A ruha ára "..color..selectedSkinData[2].."$ #ffffff \n Vásárláshoz használd az "..color.."[E] #ffffffgombot.",0,sy*0.85,sx,sy*0.85+sy*0.05,tocolor(255,255,255,255),1/myX*sx,font,"center","center", false, false, false, true)
        else
            shadowedText("Ezt a ruhát nem vásárolhatod meg!",0,sy*0.85,sx,sy*0.85+sy*0.05,tocolor(220,20,20,255),1/myX*sx,font,"center","center", false, false, false, true)
        end
    end
end

function buySkin()
    if selectedSkinData then
        local dutyState = getElementData(localPlayer, "char:duty:faction") or 0 

        if dutyState == 0 then 
            if getElementData(localPlayer, "char:money") >= selectedSkinData[2] then
                --outputChatBox(getElementModel(localPlayer).." "..selectedSkinData[1]) 
                if not (tonumber(getElementModel(localPlayer)) == tonumber(selectedSkinData[1])) then 
                    if selectedSkinData[3] == 0 or dashboard:isPlayerFactionMember(selectedSkinData[3]) then
                        info:outputInfoBox("Sikeres kinézetvásárlás!","success")
                        triggerServerEvent("buySkinOnServerSide", resourceRoot, localPlayer, selectedSkinData[1],selectedSkinData[2])
                    else
                        info:outputInfoBox("Ezt a kinézetet nem vásárolhatod meg!","warning")
                    end
                else
                    info:outputInfoBox("Már ez a kinézet van rajtad!","warning")
                end
            else
                info:outputInfoBox("Nincs elegendő pénzed a vásárláshoz! ("..selectedSkinData[2].."$)","error")
            end 
        else
            info:outputInfoBox("Szolgálatban nem tudsz kinézetet vásárolni!", "warning")
        end
    end
end

function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, false, true)
end