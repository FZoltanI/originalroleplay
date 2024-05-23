local screenX, screenY = guiGetScreenSize()
local inventory = exports.oInventory 
local savedElement = false

addEventHandler("onClientResourceStart", root, function(res)
    if getResourceName(res) == "oInventory" then 
        inventory = exports.oInventory
    end
end)

local lastClick = 0

local selectedGarageBox = false

function useButton(v)
    if lastClick + 1000 < getTickCount() then
        lastClick = getTickCount()
        if v.func == "openVehInv" then 
            inventory:openVehicleInventory(selectedElement)
        elseif v.func == "handBrake" then
            if getElementData(selectedElement, "veh:handbrake") then
                setElementData(selectedElement, "veh:handbrake", false)
                setElementFrozen(selectedElement, false)
                outputChatBox(core:getServerPrefix("green-dark", "Kézifék", 3).."Sikeresen kiengedted a jármű kézifékjét!", 255, 255, 255, true)
            else
                outputChatBox(core:getServerPrefix("red-dark", "Kézifék", 3).."A kiválasztott jármű kézifékje nincs behúzva!", 255, 255, 255, true)
            end
        elseif v.func == "stingerOut" then 
            exports.oFactionScripts:getStingerFromVeh(selectedElement)
        elseif v.func == "speedcamOut" then 
            exports.oFactionScripts:getSpeedcamFromVehicle(selectedElement)
        elseif v.func == "showRBSPanel" then 
            exports.oFactionScripts:showRBSPanel()
        elseif v.func == "pickUpRBS" then 
            exports.oFactionScripts:pickUpRBS(selectedElement, openType)
        elseif v.func == "revivificationPlayer" then 
            if getElementData(selectedElement, "playerInAnim") then
                exports.oFactionScripts:startPlayerRevivification(selectedElement)
            else
                outputChatBox(core:getServerPrefix("red-dark", "Felsegítés", 3).."Ennek a játékosnak nincs szüksége felsegítésre!", 255, 255, 255, true)
            end
        elseif v.func == "checkHit" then
            if getElementData(selectedElement, "hit.cut") > 0 or getElementData(selectedElement, "hit.shot") > 0 then
                triggerServerEvent("sendChatMessage", localPlayer, removeHex(getElementData(localPlayer, "char:name"):gsub("_", " ") .." megvizsgálja a célszemély sérüléseit."), getNearestPlayers(localPlayer), 6)
                outputChatBox(core:getServerPrefix("red-dark", "Sérülések", 3)..""..color..""..getElementData(selectedElement, "char:name"):gsub("_", " ").."#ffffff sérülései:", 255, 255, 255, true)
                if getElementData(selectedElement, "hit.cuttorso") > 0 then
                    outputChatBox(core:getServerPrefix("red-dark", "Sérülések", 3).."(#858585"..getElementData(selectedElement, "hit.cuttorso").."#ffffff) "..color.."vágás #ffffffa törzsön.", 255, 255, 255, true)
                end
                if getElementData(selectedElement, "hit.cutleftarm") > 0 then
                    outputChatBox(core:getServerPrefix("red-dark", "Sérülések", 3).."(#858585"..getElementData(selectedElement, "hit.cutleftarm").."#ffffff) "..color.."vágás #ffffffa balkézen.", 255, 255, 255, true)
                end
                if getElementData(selectedElement, "hit.cutrightarm") > 0 then
                    outputChatBox(core:getServerPrefix("red-dark", "Sérülések", 3).."(#858585"..getElementData(selectedElement, "hit.cutleftarm").."#ffffff) "..color.."vágás #ffffffa jobbkézen.", 255, 255, 255, true)
                end
                if getElementData(selectedElement, "hit.cutleftleg") > 0 then
                    outputChatBox(core:getServerPrefix("red-dark", "Sérülések", 3).."(#858585"..getElementData(selectedElement, "hit.cutleftarm").."#ffffff) "..color.."vágás #ffffffa ballábon.", 255, 255, 255, true)
                end
                if getElementData(selectedElement, "hit.cutrightleg") > 0 then
                    outputChatBox(core:getServerPrefix("red-dark", "Sérülések", 3).."(#858585"..getElementData(selectedElement, "hit.cutleftarm").."#ffffff) "..color.."vágás #ffffffa jobblábon.", 255, 255, 255, true)
                end
                if getElementData(selectedElement, "hit.cutass") > 0 then
                    outputChatBox(core:getServerPrefix("red-dark", "Sérülések", 3).."(#858585"..getElementData(selectedElement, "hit.cutass").."#ffffff) "..color.."vágás #ffffffa faron.", 255, 255, 255, true)
                end

                if getElementData(selectedElement, "hit.shottorso") > 0 then
                    outputChatBox(core:getServerPrefix("red-dark", "Sérülések", 3).."(#858585"..getElementData(selectedElement, "hit.shottorso").."#ffffff) "..color.."lőtt seb #ffffffa törzsön.", 255, 255, 255, true)
                end
                if getElementData(selectedElement, "hit.shotleftarm") > 0 then
                    outputChatBox(core:getServerPrefix("red-dark", "Sérülések", 3).."(#858585"..getElementData(selectedElement, "hit.shotleftarm").."#ffffff) "..color.."lőtt seb #ffffffa balkézen.", 255, 255, 255, true)
                end
                if getElementData(selectedElement, "hit.shotrightarm") > 0 then
                    outputChatBox(core:getServerPrefix("red-dark", "Sérülések", 3).."(#858585"..getElementData(selectedElement, "hit.shotleftarm").."#ffffff) "..color.."lőtt seb #ffffffa jobbkézen.", 255, 255, 255, true)
                end
                if getElementData(selectedElement, "hit.shotleftleg") > 0 then
                    outputChatBox(core:getServerPrefix("red-dark", "Sérülések", 3).."(#858585"..getElementData(selectedElement, "hit.shotleftarm").."#ffffff) "..color.."lőtt seb #ffffffa ballábon.", 255, 255, 255, true)
                end
                if getElementData(selectedElement, "hit.shotrightleg") > 0 then
                    outputChatBox(core:getServerPrefix("red-dark", "Sérülések", 3).."(#858585"..getElementData(selectedElement, "hit.shotleftarm").."#ffffff) "..color.."lőtt seb #ffffffa jobblábon.", 255, 255, 255, true)
                end
                if getElementData(selectedElement, "hit.shotass") > 0 then
                    outputChatBox(core:getServerPrefix("red-dark", "Sérülések", 3).."(#858585"..getElementData(selectedElement, "hit.shotass")..") "..color.."lőtt seb a faron.", 255, 255, 255, true)
                end

            else
                outputChatBox(core:getServerPrefix("red-dark", "Sérülések", 3).."A kiválasztott játékosnak nincsenek sérülései!", 255, 255, 255, true)
            end
        elseif v.func == "useblood" then 
            if getElementData(selectedElement, "playerInAnim") then
                if inventory:hasItem(238) then
                    if not getElementData(selectedElement,"usedBlood") then    
                        if getElementData(selectedElement,"char:blood") >= 51 then
                            setElementData(selectedElement,"char:blood",100)
                            outputChatBox(core:getServerPrefix("green-dark", "Vértasak", 3).."Sikeresen alkalmaztad a vértasakot, mivel a sérült vérszázaléka nem esett 50% alá, ezért 100%-ra emelkedett!", 255, 255, 255, true)
                            setElementData(selectedElement,"usedBlood",true)
                        elseif getElementData(selectedElement,"char:blood") <= 50 then
                            setElementData(selectedElement,"char:blood",50)
                            outputChatBox(core:getServerPrefix("green-dark", "Vértasak", 3).."Sikeresen alkalmaztad a vértasakot, sajnos a sérült vérszázaléka 50% alá csökkent, így csak 50%-ra emelkedett!", 255, 255, 255, true)
                            setElementData(selectedElement,"usedBlood",true)
                        end
                    else
                        outputChatBox(core:getServerPrefix("red-dark", "Vértasak", 3).."A kiválasztott játékos már kapott vért!", 255, 255, 255, true)
                    end
                else
                    outputChatBox(core:getServerPrefix("red-dark", "Vértasak", 3).."Nincs nálad vértasak!", 255, 255, 255, true)
                end
            else
                outputChatBox(core:getServerPrefix("red-dark", "Vértasak", 3).."A kiválasztott játékosnak nincs szüksége vérre!", 255, 255, 255, true)
            end
        elseif v.func == "animalSkin" then 
        --    exports.oForestAnimals:skinAnimal(selectedElement) 
        elseif v.func == "createAnimalTrophy" then 
        --    exports.oForestAnimals:createAnimalTrophy(selectedElement)
        elseif v.func == "pickUpPlantPot" then 
            if inventory:getItemWeight(171) + inventory:getAllItemWeight() <= 20 then 
                outputChatBox(core:getServerPrefix("green-dark", "Cserép", 3).."Sikeresen felvettél a földről egy cserepet!", 255, 255, 255, true)
                inventory:giveItem(171, 1, 1, 0)
                exports.oChat:sendLocalMeAction("felvett egy cserepet.")
                triggerServerEvent("drugs > destroyPot", root, selectedElement)
            else
                outputChatBox(core:getServerPrefix("red-dark", "Cserép", 3).."Nincs nálad elég hely!", 255, 255, 255, true)
            end
        elseif v.func == "plantMarijuana" or v.func == "plantCocaine" then
            if not getElementData(selectedElement, "pot:plant") then 
                if v.func == "plantMarijuana" then 
                    if inventory:hasItem(59) then 
                        inventory:takeItem(59)
                        triggerServerEvent("drugs > plantDrugShrub", root, selectedElement, 2)
                        outputChatBox(core:getServerPrefix("green-dark", "Ültetés", 3).."Sikeresen elültettél egy "..color.."marihuana cserjét#ffffff!", 255, 255, 255, true)
                    else
                        outputChatBox(core:getServerPrefix("red-dark", "Ültetés", 3).."Nincs nálad "..color.."marihuana #ffffffmag!", 255, 255, 255, true)
                    end
                elseif v.func == "plantCocaine" then 
                    if inventory:hasItem(60) then 
                        inventory:takeItem(60)
                        triggerServerEvent("drugs > plantDrugShrub", root, selectedElement, 1)
                        outputChatBox(core:getServerPrefix("green-dark", "Ültetés", 3).."Sikeresen elültettél egy "..color.."kokain cserjét#ffffff!", 255, 255, 255, true)
                    else
                        outputChatBox(core:getServerPrefix("red-dark", "Ültetés", 3).."Nincs nálad "..color.."kokain #ffffffmag!", 255, 255, 255, true)
                    end
                end
            else
                outputChatBox(core:getServerPrefix("red-dark", "Ültetés", 3).."Ebbe a cserépbe már van növény ültetve!", 255, 255, 255, true)
            end
        elseif v.func == "wateringPlant" then 
            if getElementData(selectedElement, "pot:plant") then 
                if inventory:hasItem(172) then 
                    --local waterLevel = getElementData(selectedElement, "pot:plant:waterLevel")

                    --if waterLevel < 0.75 then 
                        setElementData(selectedElement, "pot:plant:waterLevel", 1)
                        exports.oChat:sendLocalMeAction("meglocsolt egy növényt.")
                    --else
                    --    outputChatBox(core:getServerPrefix("red-dark", "Locsolás", 3).."Ez a növény nem szorul öntözésre!", 255, 255, 255, true)
                    --end
                else
                    outputChatBox(core:getServerPrefix("red-dark", "Locsolás", 3).."Nincs nálad locsoló!", 255, 255, 255, true)
                end
            end
        elseif v.func == "collectDrugPlant" then 
            if getElementData(selectedElement, "pot:plant") then 
                if getElementData(selectedElement, "pot:plant:growLevel") >= 1 then 
                    --outputChatBox("aratás")
                    exports.oDrugs:collectPlant(getElementData(selectedElement, "pot:plantID"), getElementData(selectedElement, "pot:plant:qualityLevel"), selectedElement)
                else
                    outputChatBox(core:getServerPrefix("red-dark", "Locsolás", 3).."Ez a növény még nem nőtt meg!", 255, 255, 255, true)
                end
            end
        elseif v.func == "cuffPlayer" or v.func == "unCuffPlayer" then 
            exports.oFactionScripts:cuffPlayer(selectedElement)
        elseif v.func == "grabPlayer" then 
            exports.oFactionScripts:grabPlayer(selectedElement)
        elseif v.func == "unleashPlayer" then 
            exports.oFactionScripts:unleashPlayer(selectedElement)
        elseif v.func == "alcoholsonda" then
            if isTimer(theTimer) then return end
            theTimer = setTimer(function() end,12000,1)
            local level = getElementData(selectedElement, "char:alcoholLevel") or 0
            
            msg = "belefúj a szondába."
            msg3 = "A szonda vissza számol"
            msg2 = ""
            arg = 1
            triggerServerEvent("sendChatMessage", localPlayer, removeHex(getElementData(selectedElement, "char:name"):gsub("_", " ") .." belefúj a szondába."), getNearestPlayers(localPlayer), 7)
            --triggerServerEvent("sendChatMessage", localPlayer, removeHex(msg), getNearestPlayers(localPlayer), 6)
            triggerServerEvent("sendChatMessage", localPlayer, removeHex(msg3), getNearestPlayers(localPlayer), 7)
            setTimer(function(selectedElement)
                if arg == 1 then 
                    msg2 = "Szonda kijelző: 10"
                elseif arg == 2 then
                    msg2 = "Szonda kijelző: 9"
                elseif arg == 3 then
                    msg2 = "Szonda kijelző: 8"
                elseif arg == 4 then
                    msg2 = "Szonda kijelző: 7"
                elseif arg == 5 then
                    msg2 = "Szonda kijelző: 6"
                elseif arg == 6 then
                    msg2 = "Szonda kijelző: 5"
                elseif arg == 7 then
                    msg2 = "Szonda kijelző: 4"
                elseif arg == 8 then
                    msg2 = "Szonda kijelző: 3"
                elseif arg == 9 then
                    msg2 = "Szonda kijelző: 2"
                elseif arg == 10 then
                    msg2 = "Szonda kijelző: 1"
                elseif arg == 11 then
                --    outputChatBox("Érték: ".. (level/100) .. "‰")
                    levelName = 0.0
                    if (level/100) == 0 then 
                        levelName = "0.0"
                    else 
                        levelName = level/100
                    end
                    asd = getElementData(selectedElement, "char:name"):gsub("_", " ") .. " véralkohol szintje: ".. levelName .. "‰ (ezrelék)"
                    triggerServerEvent("sendChatMessage", localPlayer, removeHex(asd), getNearestPlayers(localPlayer), 7)
                    outputChatBox(core:getServerPrefix("red-dark", "Szonda", 3)..getElementData(selectedElement, "char:name"):gsub("_", " ") .. " véralkohol szintje: ".. levelName .. "‰ (ezrelék)", 255, 255, 255, true)
                end
                if arg >= 1 and arg <= 10 then 
                    outputChatBox(core:getServerPrefix("red-dark", "Szonda", 3)..msg2, 255, 255, 255, true)
                end
                arg = arg + 1
            end,1000,11, selectedElement)
        elseif v.func == "friskPlayer" then
            exports.oInventory:friskPlayer(selectedElement) 
        elseif v.func == "addTeslaChargerToVeh" then 
            exports.oTeslaCharger:addTeslaChargerToVeh(selectedElement)
        elseif v.func == "removeTeslaChargerToVeh" then 
            exports.oTeslaCharger:removeTeslaChargerToVeh(selectedElement)
        elseif v.func == "bagPlayer" then 
            if not getPedOccupiedVehicle(localPlayer) then 
                exports.oBag:attachBag(localPlayer,selectedElement) 
            end
        elseif v.func == "removeBagPlayer" then 
            if not getPedOccupiedVehicle(localPlayer) then 
                exports.oBag:deattachBag(localPlayer,selectedElement) 
            end
        elseif v.func == "connectHose" then 
            if not getPedOccupiedVehicle(localPlayer) then 
                exports.oFactionScripts:connectHose(selectedElement)
            end
        elseif v.func == "connectHoseToVeh" then 
            exports.oFactionScripts:connectHoseToVeh(selectedElement)
        elseif v.func == "unConnectHoseFromVeh" then 
            exports.oFactionScripts:unConnectHoseFromVeh(selectedElement)
        elseif v.func == "unConnectHose" then 
            exports.oFactionScripts:unConnectHose(selectedElement)
        elseif v.func == "strecher.CreateStrecher" then
            if getVehicleDoorOpenRatio(selectedElement, 4) == 1 and getVehicleDoorOpenRatio(selectedElement, 5) == 1 then
                if not getElementData(localPlayer,"strecher.objectAttached") then
                    if strecherElement[localPlayer] then 
                        outputChatBox(core:getServerPrefix("green-dark", "Hordágy", 3).."Már van egy hordágy ami hozzád tartozik!", 255, 255, 255, true)
                    else 
                        triggerServerEvent("strecher.CreateStrecher",localPlayer, localPlayer,true)
                        --   outputDebugString("Teljesenmindegy")
                            setElementData(selectedElement, "veh:Stretcher", false)
                    end
                else 
                    outputChatBox(core:getServerPrefix("green-dark", "Hordágy", 3).."Már van a kezedben egy hordágy", 255, 255, 255, true)
                end
            else 
                outputChatBox(core:getServerPrefix("green-dark", "Hordágy", 3).."Előbb nyisd ki az ajtókat", 255, 255, 255, true)
            end
        elseif v.func == "vehicleLockPick" then
            exports["oCarStealer"]:createlockpickingMechanic()
        elseif v.func == "strecher.pickup" then
         --   outputChatBox(getElementType(selectedElement))
            triggerServerEvent("strecher.pickup", localPlayer, selectedElement, localPlayer) 
        elseif v.func == "strecher.dropDown" then
            triggerServerEvent("strecher.dropDown", localPlayer, selectedElement, localPlayer) 
        elseif v.func == "strecher.helpPlayerDown" then
            local elementPlayer = getElementData(selectedElement, "stretcher.attachedPlayer")
            local ox,oy,oz = getElementPosition(selectedElement)
            setElementFrozen(elementPlayer, false)
            setElementPosition(elementPlayer, ox,oy+1.5,oz)
            
            triggerServerEvent("stretcher.playerAnim",localPlayer,elementPlayer, false)
            outputChatBox(core:getServerPrefix("green-dark", "Hordágy", 3).."Sikeresen lesegítetted ".. getElementData(elementPlayer, "char:name"):gsub("_", " ").. "-t a hordágyról!", 255, 255, 255, true)
        elseif v.func == "strecher.helpPlayerUp" then
            local x,y,z = getElementPosition(localPlayer)
            local ox,oy,oz = getElementPosition(selectedElement)
            selectedEl = selectedElement
            for k,v in ipairs(getElementsByType("player")) do 
                local tx,ty,tz = getElementPosition(v)
                if v == localPlayer and getDistanceBetweenPoints3D(x,y,z,tx,ty,tz) <= 3 then 
                    if getDistanceBetweenPoints3D(x,y,z,ox,oy,oz) <= 3 then 
                        element = v 
                        setElementData(selectedElement, "stretcher.attachedPlayer",element)
                        setElementFrozen(element, true) 
                        setElementPosition(element,  ox,oy,oz+1.5)
                        setPedRotation(element, 90) 
                        addEventHandler("onClientRender", element, elementPositionRender)
                        triggerServerEvent("stretcher.playerAnim",localPlayer,element, true)
                        outputChatBox(core:getServerPrefix("green-dark", "Hordágy", 3).."Sikeresen felsegítetted ".. getElementData(element, "char:name"):gsub("_", " ").. "-t a hordágyra!", 255, 255, 255, true)
                    else
                        outputChatBox(core:getServerPrefix("red-dark", "Hordágy", 3).."Túl messze vagy a hordágytól!", 255, 255, 255, true)
                    end
                else 
                    outputChatBox(core:getServerPrefix("red-dark", "Hordágy", 3).."Nincs a közeledben játékos!", 255, 255, 255, true)
                end
            end
        elseif v.func == "strecher.DeleteStrecher" then
            if getVehicleDoorOpenRatio(selectedElement, 4) == 1 and getVehicleDoorOpenRatio(selectedElement, 5) == 1 then
                if getElementData(localPlayer,"strecher.objectAttached") then
                    triggerServerEvent("strecher.DeleteStrecher",localPlayer, localPlayer)
                --  outputDebugString("Teljesenmindegy")
                    setElementData(selectedElement, "veh:Stretcher", true)
                else
                    outputChatBox("Mit akarsz vissza tenni nincs hordágy a kezedben ?!")
                end 
            else 
                outputChatBox(core:getServerPrefix("green-dark", "Hordágy", 3).."Előbb nyisd ki az ajtókat", 255, 255, 255, true)
            end
        elseif v.func == "dollyPickUp" then 
            if not getElementData(localPlayer,"dollyInMove") then 
                exports.oFactionScripts:attachDollyToPlayer(localPlayer, selectedElement)
                setElementData(localPlayer,"dollyInMove",true)
                outputChatBox(color.."[Dolly]#ffffff Felvetted a dolly-t, a fekete vagy piros hordóra kattintva tudod őket felhelyezni a tolókocsira.",255,255,255,true)
                outputChatBox(color.."[Dolly]#ffffff Lerakáshoz nyomd meg a backspace-t.",255,255,255,true)
            else 
                outputChatBox(color.."[Dolly]#ffffff Már van nálad egy dolly.",255,255,255,true)
            end 
        elseif v.func == "apiaryBeeBuy" then 
            --outputChatBox("vásárlás")
            triggerServerEvent("apiaryBeeBuy", localPlayer, localPlayer, selectedElement)
        elseif v.func == "apiaryCollect" then 
            --outputChatBox("begyűjt")
            triggerServerEvent("apiaryCollect", localPlayer, localPlayer, selectedElement)
        elseif v.func == "apiaryCleaning" then 
           --outputChatBox("tisztít")
            triggerServerEvent("apiaryCleaning", localPlayer, localPlayer, selectedElement)
        elseif v.func == "apiaryLockedHandler" then 
           -- outputChatBox("lockedhandler")
            triggerServerEvent("apiaryLockedHandler", localPlayer, localPlayer, selectedElement)
        elseif v.func == "apiaryUp" then
          --  outputChatBox("ApiaryUp")
          triggerServerEvent("apiaryUp", localPlayer, localPlayer, selectedElement)
        elseif v.func == "vehicledetain" then 
            --outputChatBox("asd")
            local anim, block = getPedAnimation ( selectedElement )
            --print(block)
            if getElementData(selectedElement, "player:animation") and block == "crckidle4" or getElementData(selectedElement, "cuff:cuffed") then 
                addEventHandler("onClientRender", getRootElement(), drawDetain)
                addEventHandler("onClientKey", getRootElement(), onKey)
                addEventHandler("onClientClick", getRootElement(), onClick)
                savedElement = selectedElement
            else 
                outputChatBox(core:getServerPrefix("green-dark", "Besegítés", 3).."A kiválasztott játékosnak meg kell lennie bilincselve!", 255, 255, 255, true)
            end
        elseif v.func == "drumPickup" then
            dolly = getElementData(localPlayer,"dollyUsedByPlayer")
            if not getElementData(dolly,"dolly:useDrum") then 
                exports.oFactionScripts:pickupDrum(localPlayer, selectedElement)
                outputChatBox(color.."[Dolly]#ffffff Felvettél egy olajos hordót, ahhoz hogy leereszd a gépjármű olaját álj a motortér alá és használd a "..color.."/leereszt #ffffffparancsot.",255,255,255,true)
                outputChatBox(color.."[Dolly]#ffffff Amennyiben megtelt a hordó ürítsd ki azt a telep konténereinek mögött lévő színazonos markerében.",255,255,255,true)
            else 
                outputChatBox(color.."[Dolly]#ffffff Egyszerre két hordót nem tudsz felrakni.",255,255,255,true)
            end
        elseif v.func == "drumTakeDown" then
            exports.oFactionScripts:takeDownDrum(localPlayer, selectedElement)
        elseif v.func == "FueldrumPickup" then
            dolly = getElementData(localPlayer,"dollyUsedByPlayer")
            if not getElementData(dolly,"dolly:useDrum") then 
                exports.oFactionScripts:pickupFuelDrum(localPlayer, selectedElement)
                outputChatBox(color.."[Dolly]#ffffff Felvettél egy üzemanyagos hordót, ahhoz hogy leereszd a gépjármű üzemanyagát álj az autó üzemanyag tartálya alá és használd a "..color.."/leereszt #ffffffparancsot.",255,255,255,true)
                outputChatBox(color.."[Dolly]#ffffff Amennyiben megtelt a hordó ürítsd ki azt a telep konténereinek mögött lévő színazonos markerében.",255,255,255,true)

            else 
                outputChatBox(color.."[Dolly]#ffffff Egyszerre két hordót nem tudsz felrakni.",255,255,255,true)
            end
        elseif v.func == "FueldrumTakeDown" then
            exports.oFactionScripts:takeDownFuelDrum(localPlayer, selectedElement)
        elseif v.func == "AttachTrailer" then 
            if getElementData(selectedElement,"trailerHasCar") then 
                    if not getElementData(selectedElement,"trailer->carin") then 
                        veh = getElementData(selectedElement,"trailerValue->Vehicle")
                        vehModel = getElementData(selectedElement,"trailerValue->VehicleModel")
                            
                        if not getElementData(veh,"veh:engine") and getElementData(veh,"veh:locked") then 
                            exports["oTrailerFix"]:attachExport("attach",selectedElement,veh,vehModel)
                            setElementData(selectedElement,"trailer->carin",true)
                        else
                            outputChatBox(color.."[Trailer]#ffffff Az összeakasztás csak leállított motor és zárt ajtók mellett történhet!",255,255,255,true)
                        end

                    else 
                        veh = getElementData(selectedElement,"trailerValue->Vehicle")
                        vehModel = getElementData(selectedElement,"trailerValue->VehicleModel")
                        exports["oTrailerFix"]:attachExport("deattach",selectedElement,veh,vehModel)
                        setElementData(selectedElement,"trailer->carin",false)
                        setElementData(selectedElement,"trailerHasCar",false)
                        removeElementData(selectedElement,"trailerValue->Vehicle")
                        removeElementData(selectedElement,"trailerValue->VehicleModel")
                    end

            else 
                outputChatBox(color.."[Trailer]#ffffff Nincs a traileren jármű!",255,255,255,true)
            end
        elseif v.func == "garageBidSearch" then 
            if not selectedGarageBox then
                local inventory = exports.oInventory
                if inventory:getAllItemWeight() <= 19 then

                    local x, y, z = getElementPosition(selectedElement)
                    local objCount = 0

                    for k, v in pairs(getElementsWithinRange(x, y, z, 0.3, "object", 0, getElementDimension(selectedElement))) do 
                        if getElementData(v, "garageBid:pickupObject:loottable") then 
                            local x2, y2, z2 = getElementPosition(v)

                            if z2 > z then
                                if math.abs(x - x2) < 0.1 and math.abs(y - y2) < 0.1 then
                                    objCount = objCount + 1
                                end
                            end
                        end
                    end

                    if objCount == 0 then
                        selectedGarageBox = selectedElement
                        
                        exports.oChat:sendLocalMeAction("elkezd tárgyak után keresni egy "..getElementData(selectedGarageBox, "garageBid:pickupObject:name").."-ban/ben.")

                        setElementFrozen(localPlayer, true)
                        setPedAnimation(localPlayer, "bomber", "bom_plant_loop", -1, true, false)
                        local sound = playSound("files/sounds/search.mp3")
                        setSoundVolume(sound, 0.8)
                        core:createProgressBar("Keresés", 10000, "nil", true)

                        setTimer(function()
                            setElementFrozen(localPlayer, false)
                            setPedAnimation(localPlayer, "", "")

                            local loots = getElementData(selectedGarageBox, "garageBid:pickupObject:loottable")
                            local generatedLootTable = {}
                            for k, v in pairs(loots) do
                                if type(v) == "table" then 
                                    for i = 1, v[2] do 
                                        table.insert(generatedLootTable, {v[1], v[3]})
                                    end
                                end
                            end

                            outputChatBox(core:getServerPrefix("server", "Garázsvásár", 2).."A keresés közben talált tárgyak: ", 255, 255, 255, true)
                            local lootCount = math.random(1, loots.itemrange)
                            for i = 1, lootCount do 
                                local randomLoot = generatedLootTable[math.random(#generatedLootTable)]

                                if randomLoot[1] == 0 then 
                                    outputChatBox(color .. " - #ffffffNem találtál semmit.", 255, 255, 255, true)
                                else
                                    local count = randomLoot[2] 
                                    if type(count) == "table" then 
                                        count = math.random(count[1], count[2])
                                    end
        
                                    inventory:giveItem(randomLoot[1], 1, count, false)
                                    outputChatBox(color .. " - #ffffff"..inventory:getItemName(randomLoot[1], 1).. " "..color..count.."db#ffffff.", 255, 255, 255, true)
                                end
                            end


                            triggerServerEvent("garageBid > removeObjectFromSave", root, getElementData(localPlayer, "char:id"), getElementData(selectedGarageBox, "garageBid:pickupObjectID"))
                            destroyElement(selectedGarageBox)
                            selectedGarageBox = false
                        end, 10000, 1)
                    else
                        outputChatBox(core:getServerPrefix("red-dark", "Doboz átkutatása", 2).."Előbb a felső tárgyat kell megnézned!", 255, 255, 255, true)
                    end
                else
                    outputChatBox(core:getServerPrefix("red-dark", "Doboz átkutatása", 2).."Nincs nálad elegendő szabad hely!", 255, 255, 255, true)
                end
            end
        elseif v.func == "revivePet" then 
            if inventory:hasItem(92) then 

                exports.oChat:sendLocalMeAction("elkezdi ellátni kisállata sebeit.")
                setPedAnimation(localPlayer,"BOMBER","BOM_Plant_Loop",-1, false)

                setTimer(function()
                    setElementHealth(v.element,100)
                    outputChatBox(color.."[Kisállat]#ffffff Sikeresen beállítottad kisállatod életerejét 100-ra!",255,255,255,true)
                    setPedAnimation(localPlayer)
                    inventory:takeItem(92)
                end,10000,1)
            end 
        elseif v.func == "feedPet" then 

            if v.foodType == 1 then 
                if inventory:hasItem(95) then 
                    if math.floor(getElementData(v.element,"pet:hunger")) == 100 then return outputChatBox(core:getServerPrefix("red-dark", "Kisállat", 3).."Ez az állat nem éhes!", 255, 255, 255, true) end
                    local favoritFood = getElementData(v.element,"pet:bestFood")
                    setPedAnimation(localPlayer,"BOMBER","BOM_Plant_Loop",-1, false)
                    setElementFrozen(v.element,true)
                    inventory:takeItem(95)

                    exports.oChat:sendLocalMeAction("elővesz egy zacskó eb tápot.")

                    setTimer(function()
                        exports.oChat:sendLocalMeAction("kinyitja a zacskót és kiönti a tartalmát a markába.")
                        exports.oChat:sendLocalDoAction("kutyatáp szag terjeng a levegőben.")
        
                        setTimer(function()
                            exports.oChat:sendLocalDoAction("a kutya szépen lassan elkezd a kezéből enni.")
                        end,1500,1)
                    end,2500,1)

                    setTimer(function()
                        if favoritFood == v.foodType then 
                            setElementData(v.element,"pet:hunger",100) 
                            outputChatBox(color.."[Kisállat]#ffffff Sikeresen megetetted az állatot a kedvenc ételével így az éhségi szintje 100% ra nőtt!",255,255,255,true)
                        else 
                            if (getElementData(v.element,"pet:hunger") + 20) < 100 then 
                                setElementData(v.element,"pet:hunger",getElementData(v.element,"pet:hunger")+ 20)
                            elseif (getElementData(v.element,"pet:hunger") + 10) < 100 then 
                                setElementData(v.element,"pet:hunger",getElementData(v.element,"pet:hunger")+ 10)
                            elseif (getElementData(v.element,"pet:hunger") + 5) < 100 then 
                                setElementData(v.element,"pet:hunger",getElementData(v.element,"pet:hunger")+ 5)
                            elseif (getElementData(v.element,"pet:hunger") + 1) < 100 then 
                                setElementData(v.element,"pet:hunger",getElementData(v.element,"pet:hunger")+ 1)
                            end 
                            outputChatBox(color.."[Kisállat]#ffffff Sikeresen megetetted az állatot de nem a kedvenc ételével!",255,255,255,true)

                        end 

                        setPedAnimation(localPlayer)
                        setElementFrozen(v.element,false)
                        exports.oChat:sendLocalDoAction("elfogyott a kezéből a táp.")
                        exports.oChat:sendLocalMeAction("eldobja az üres zacskót.")

                    end,10000,1)
                end 
            elseif v.foodType == 2 then 
                if inventory:hasItem(96) then 
                    if math.floor(getElementData(v.element,"pet:hunger")) == 100 then return outputChatBox(core:getServerPrefix("red-dark", "Kisállat", 3).."Ez az állat nem éhes!", 255, 255, 255, true) end

                    local favoritFood = getElementData(v.element,"pet:bestFood")
                    setPedAnimation(localPlayer,"BOMBER","BOM_Plant_Loop",-1, false)
                    setElementFrozen(v.element,true)
                    inventory:takeItem(96)
                    exports.oChat:sendLocalMeAction("elővesz egy zacskó eb tápot.")

                    setTimer(function()
                        exports.oChat:sendLocalMeAction("kinyitja a zacskót és kiönti a tartalmát a markába.")
                        exports.oChat:sendLocalDoAction("kutyatáp szag terjeng a levegőben.")
        
                        setTimer(function()
                            exports.oChat:sendLocalDoAction("a kutya szépen lassan elkezd a kezéből enni.")
                        end,1500,1)
                    end,2500,1)

                    setTimer(function()
                        if favoritFood == v.foodType then 
                            setElementData(v.element,"pet:hunger",100) 
                            outputChatBox(color.."[Kisállat]#ffffff Sikeresen megetetted az állatot a kedvenc ételével így az éhségi szintje 100% ra nőtt!",255,255,255,true)

                        else 
                            if (getElementData(v.element,"pet:hunger") + 20) < 100 then 
                                setElementData(v.element,"pet:hunger",getElementData(v.element,"pet:hunger")+ 20)
                            elseif (getElementData(v.element,"pet:hunger") + 10) < 100 then 
                                setElementData(v.element,"pet:hunger",getElementData(v.element,"pet:hunger")+ 10)
                            elseif (getElementData(v.element,"pet:hunger") + 5) < 100 then 
                                setElementData(v.element,"pet:hunger",getElementData(v.element,"pet:hunger")+ 5)
                            elseif (getElementData(v.element,"pet:hunger") + 1) < 100 then 
                                setElementData(v.element,"pet:hunger",getElementData(v.element,"pet:hunger")+ 1)
                            end 
                            outputChatBox(color.."[Kisállat]#ffffff Sikeresen megetetted az állatot de nem a kedvenc ételével!",255,255,255,true)

                        end 

                        setPedAnimation(localPlayer)
                        setElementFrozen(v.element,false)
                        exports.oChat:sendLocalDoAction("elfogyott a kezéből a táp.")
                        exports.oChat:sendLocalMeAction("eldobja az üres zacskót.")
                    end,10000,1)
                end 
            elseif v.foodType == 3 then 
                if inventory:hasItem(97) then 
                    if math.floor(getElementData(v.element,"pet:hunger")) == 100 then return outputChatBox(core:getServerPrefix("red-dark", "Kisállat", 3).."Ez az állat nem éhes!", 255, 255, 255, true) end

                    local favoritFood = getElementData(v.element,"pet:bestFood")
                    setPedAnimation(localPlayer,"BOMBER","BOM_Plant_Loop",-1, false)
                    setElementFrozen(v.element,true)
                    inventory:takeItem(97)
                    exports.oChat:sendLocalMeAction("elővesz egy zacskó eb tápot.")

                    setTimer(function()
                        exports.oChat:sendLocalMeAction("kinyitja a zacskót és kiönti a tartalmát a markába.")
                        exports.oChat:sendLocalDoAction("kutyatáp szag terjeng a levegőben.")
        
                        setTimer(function()
                            exports.oChat:sendLocalDoAction("a kutya szépen lassan elkezd a kezéből enni.")
                        end,1500,1)
                    end,2500,1)

                    setTimer(function()
                        if favoritFood == v.foodType then 
                            setElementData(v.element,"pet:hunger",100) 
                            outputChatBox(color.."[Kisállat]#ffffff Sikeresen megetetted az állatot a kedvenc ételével így az éhségi szintje 100% ra nőtt!",255,255,255,true)

                        else 
                            if (getElementData(v.element,"pet:hunger") + 20) < 100 then 
                                setElementData(v.element,"pet:hunger",getElementData(v.element,"pet:hunger")+ 20)
                            elseif (getElementData(v.element,"pet:hunger") + 10) < 100 then 
                                setElementData(v.element,"pet:hunger",getElementData(v.element,"pet:hunger")+ 10)
                            elseif (getElementData(v.element,"pet:hunger") + 5) < 100 then 
                                setElementData(v.element,"pet:hunger",getElementData(v.element,"pet:hunger")+ 5)
                            elseif (getElementData(v.element,"pet:hunger") + 1) < 100 then 
                                setElementData(v.element,"pet:hunger",getElementData(v.element,"pet:hunger")+ 1)
                            end 
                            outputChatBox(color.."[Kisállat]#ffffff Sikeresen megetetted az állatot de nem a kedvenc ételével!",255,255,255,true)

                        end 

                        setPedAnimation(localPlayer)
                        setElementFrozen(v.element,false)
                        exports.oChat:sendLocalDoAction("elfogyott a kezéből a táp.")
                        exports.oChat:sendLocalMeAction("eldobja az üres zacskót.")
                    end,10000,1)
                end 
            elseif v.foodType == 4 then 
                if inventory:hasItem(98) then 
                    if math.floor(getElementData(v.element,"pet:hunger")) == 100 then return outputChatBox(core:getServerPrefix("red-dark", "Kisállat", 3).."Ez az állat nem éhes!", 255, 255, 255, true) end


                    local favoritFood = getElementData(v.element,"pet:bestFood")
                    setPedAnimation(localPlayer,"BOMBER","BOM_Plant_Loop",-1, false)
                    setElementFrozen(v.element,true)
                    inventory:takeItem(98)
                    exports.oChat:sendLocalMeAction("elővesz egy zacskó eb tápot.")

                    setTimer(function()
                        exports.oChat:sendLocalMeAction("kinyitja a zacskót és kiönti a tartalmát a markába.")
                        exports.oChat:sendLocalDoAction("kutyatáp szag terjeng a levegőben.")
        
                        setTimer(function()
                            exports.oChat:sendLocalDoAction("a kutya szépen lassan elkezd a kezéből enni.")
                        end,1500,1)
                    end,2500,1)

                    setTimer(function()
                        if favoritFood == v.foodType then 
                            setElementData(v.element,"pet:hunger",100) 
                            outputChatBox(color.."[Kisállat]#ffffff Sikeresen megetetted az állatot a kedvenc ételével így az éhségi szintje 100% ra nőtt!",255,255,255,true)
                        else 
                            if (getElementData(v.element,"pet:hunger") + 20) < 100 then 
                                setElementData(v.element,"pet:hunger",getElementData(v.element,"pet:hunger")+ 20)
                            elseif (getElementData(v.element,"pet:hunger") + 10) < 100 then 
                                setElementData(v.element,"pet:hunger",getElementData(v.element,"pet:hunger")+ 10)
                            elseif (getElementData(v.element,"pet:hunger") + 5) < 100 then 
                                setElementData(v.element,"pet:hunger",getElementData(v.element,"pet:hunger")+ 5)
                            elseif (getElementData(v.element,"pet:hunger") + 1) < 100 then 
                                setElementData(v.element,"pet:hunger",getElementData(v.element,"pet:hunger")+ 1)
                            end 
                            outputChatBox(color.."[Kisállat]#ffffff Sikeresen megetetted az állatot de nem a kedvenc ételével!",255,255,255,true)

                        end 

                        setPedAnimation(localPlayer)
                        setElementFrozen(v.element,false)
                        exports.oChat:sendLocalDoAction("elfogyott a kezéből a táp.")
                        exports.oChat:sendLocalMeAction("eldobja az üres zacskót.")
                    end,10000,1)
                end 
            end 
        elseif v.func == "wateringPet" then 
            if inventory:hasItem(93) then 
                exports.oChat:sendLocalMeAction("elővesz egy itató kulacsot.")
                setPedAnimation(localPlayer,"BOMBER","BOM_Plant_Loop",-1, false)
                inventory:takeItem(93)
                setTimer(function()
                    exports.oChat:sendLocalMeAction("letekeri annak tetejét majd a kutya szájához helyezi.")
                    setTimer(function()
                        exports.oChat:sendLocalMeAction("a kutya szépen lassan elkezd inni.")
                    end,1500,1)
                end,2500,1)

                setTimer(function()
                    if (getElementData(v.element,"pet:thirsty") + 20) < 100 then 
                        setElementData(v.element,"pet:thirsty",getElementData(v.element,"pet:thirsty")+ 20)
                    elseif (getElementData(v.element,"pet:thirsty") + 10) < 100 then 
                        setElementData(v.element,"pet:thirsty",getElementData(v.element,"pet:thirsty")+ 10)
                    elseif (getElementData(v.element,"pet:thirsty") + 5) < 100 then 
                        setElementData(v.element,"pet:thirsty",getElementData(v.element,"pet:thirsty")+ 5)
                    elseif (getElementData(v.element,"pet:thirsty") + 1) < 100 then 
                        setElementData(v.element,"pet:thirsty",getElementData(v.element,"pet:thirsty")+ 1)
                    end 

                    setPedAnimation(localPlayer)
                    exports.oChat:sendLocalDoAction("elfogyott a víz a kulacsból.")
                    exports.oChat:sendLocalMeAction("visszatekeri a kulcsa tetejét majd elrakja.")
                    outputChatBox(color.."[Kisállat]#ffffff Sikeresen megetetted az állatot!",255,255,255,true)

                end,10000,1)
            end 
        elseif v.func == "setPetIdle" then 
            if getElementData(v.element,"petIsIdle") then 
                local petID = getElementData(v.element,"pet:id")
                exports.oPet:setPetIdleClient(v.element,false,localPlayer)
                exports.oPet:makePetSound(petID)
                setElementData(v.element,"petIsIdle",false)
            else 
                local petID = getElementData(v.element,"pet:id")
                exports.oPet:setPetIdleClient(v.element,true,localPlayer)
                exports.oPet:makePetSound(petID)
                setElementData(v.element,"petIsIdle",true)
            end 
        end 
    end  
end

local seat = {
    [1] = "Anyós ülés",
    [2] = "Bal hátsó ülés",
    [3] = "Jobb hátsó ülés"
}
local panelW, panelH = 300, 125
local panelX, panelY = screenX/2 - panelW/2, screenY/2 - panelH/2
detainFont = font:getFont("condensed",12)

function closePanel2()
    removeEventHandler("onClientRender", getRootElement(), drawDetain)
    removeEventHandler("onClientClick", getRootElement(), onClick)
    removeEventHandler("onClientKey", getRootElement(), onKey)
    savedElement = false
end

function drawDetain()
    if (core:getDistance(savedElement, localPlayer) > 4) then 
        closePanel2()
       -- checkNeed = false
    end
    exports["oCore"]:drawWindow(panelX, panelY, panelW, panelH, "OriginalRoleplay")
    local startY = panelY + 25
    for i=1, #seat do 
        local data = seat[i]
        if data then
            exports["oCore"]:dxDrawButton(panelX+5, startY, panelW - 10, 30, r, g, b, 150, data, tocolor(255,255,255,255),0.85,detainFont)
            startY = startY + 32
        end
    end
end
--addEventHandler("onClientRender", getRootElement(), drawDetain)

function onClick(button, state)
    if button == "left" and state == "down" then 
        local startY = panelY + 25
        for i=1, #seat do 
            local data = seat[i]
            if data then
                if exports["oCore"]:isInSlot(panelX+5, startY, panelW - 10, 30) then 
                    --outputChatBox(data)
                    if getNearestVehicle(savedElement, 5) and getNearestVehicle(localPlayer, 5)  then 
                        vehicle = getNearestVehicle(savedElement, 5)
                        exports.oChat:sendLocalMeAction("berak egy személyt a járműbe (".. data..")")
                        triggerServerEvent("warpPedIntoVeh", savedElement, savedElement, vehicle, i)
                        removeEventHandler("onClientRender", getRootElement(), drawDetain)
                        removeEventHandler("onClientClick", getRootElement(), onClick)
                        removeEventHandler("onClientKey", getRootElement(), onKey)
                        savedElement = false
                    else
                        outputChatBox(core:getServerPrefix("red-dark", "Detain", 3).."Túl messze vagy a járműtől!", 255, 255, 255, true)
                    end
                end
                startY = startY + 32
            end
        end
    end
end

function onKey(button, state)
    if button == "backspace" and state then 
        removeEventHandler("onClientRender", getRootElement(), drawDetain)
        removeEventHandler("onClientClick", getRootElement(), onClick)
        removeEventHandler("onClientKey", getRootElement(), onKey)
        savedElement = false
    end
end


function elementPositionRender()
    ox,oy,oz = getElementPosition(selectedElement)
    setElementPosition(element,  ox,oy,oz+1)
end


function getNearestPlayers(thePlayer, dist)
	if not dist then dist = 20 end
	local tempTable = {}
	local x1, y1, z1 = getElementPosition(thePlayer)
	local int = getElementInterior(thePlayer)
	local dim = getElementDimension(thePlayer)

	for _, player in pairs(getElementsByType("player")) do
		if int == getElementInterior(player) and dim == getElementDimension(player) then
			local x2, y2, z2 = getElementPosition(player)
			if getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) < dist then
				table.insert(tempTable, player)

				if getElementData(player, "recon:reconerPlayer") then 
					table.insert(tempTable, getElementData(player, "recon:reconerPlayer"))
				end
			--[[elseif getElementData(player, "recon:reconedPlayer") then 
				if getElementData(player, "recon:reconedPlayer") == thePlayer then 
					table.insert(tempTable, player)
				end]]
			end
		end
	end
	return tempTable
end

function getNearestVehicle(player,distance)
	local tempTable = {}
	local lastMinDis = distance-0.0001
	local nearestVeh = false
	local px,py,pz = getElementPosition(player)
	local pint = getElementInterior(player)
	local pdim = getElementDimension(player)

	for _,v in pairs(getElementsByType("vehicle")) do
		local vint,vdim = getElementInterior(v),getElementDimension(v)
		if vint == pint and vdim == pdim then
			local vx,vy,vz = getElementPosition(v)
			local dis = getDistanceBetweenPoints3D(px,py,pz,vx,vy,vz)
			if dis < distance then
				if dis < lastMinDis then 
					lastMinDis = dis
					nearestVeh = v
				end
			end
		end
	end
	
	return nearestVeh
end

function removeHex(msg)
    return msg:gsub("#" .. (6 and string.rep("%x", 6) or "%x+"), "")
end