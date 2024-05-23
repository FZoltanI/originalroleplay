local func = {};

txd_floors = engineLoadTXD ( "assets/"..modelname..".txd" )
engineImportTXD ( txd_floors, model )
dff_floors = engineLoadDFF ( "assets/"..modelname..".dff" )
engineReplaceModel ( dff_floors, model )
col_floors = engineLoadCOL ( "assets/"..modelname..".col" )
engineReplaceCOL ( col_floors, model )

func.click = function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
    if button == "right" and state == "down" then
        if clickedElement and getElementData(clickedElement,"gift") then
            if getElementData(localPlayer,"user:admin") >= 2 and getElementData(localPlayer,"user:admin") <= 8 then
                outputChatBox(core:getServerPrefix("green-dark", "Ajándék", 3).."Adminisztrátorként nem vehetsz fel ajándékot, jutalmat kapsz az event végén.",220,20,60,true)
            else
                local playerX,playerY,playerZ = getElementPosition(localPlayer);
                local targetX,targetY,targetZ = getElementPosition(clickedElement);
                if getDistanceBetweenPoints3D(playerX,playerY,playerZ,targetX,targetY,targetZ) < 3 then
                    if not getElementData(clickedElement,"gift:pickup") then
                        setElementData(clickedElement,"gift:pickup",localPlayer);
                        triggerServerEvent("givePlayerGift",localPlayer,localPlayer,getElementData(clickedElement,"gift:id"));
                    else
                        outputChatBox(core:getServerPrefix("green-dark", "Ajándék", 3).."Ezt már valaki felvette.",220,20,60,true)
                    end
                end
            end
        end
    end
end
addEventHandler ( "onClientClick", getRootElement(), func.click)