addCommandHandler("gotocar", function(cmd, carID)

    if getElementData(localPlayer, "user:admin") > 1 then 
        carID = tonumber(carID) or 0
        
        if carID > 0 then 

            for k, v in ipairs(getElementsByType("vehicle")) do 
                if getElementData(v, "veh:id") == carID then 
                    triggerServerEvent("gotoCarOnServer", resourceRoot, localPlayer, v)
                    outputChatBox(core:getServerPrefix("server", "Jármű",3).."Odateleportáltál a(z) "..color..carID.."#ffffff-as/es ID-vel rendelkező járműhöz!", 255, 255, 255, true)
                    return
                end
            end
            outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."Nincs ilyen ID-vel rendelkező jármű!", 255, 255, 255, true)

        else
            outputChatBox(core:getServerPrefix("server", "Jármű",3).."/gotocar [ID]", 255, 255, 255, true)
        end

    end
end)
admin:addAdminCMD("gotocar", 2, "Teleportálás járműhöz")

addCommandHandler("getcar", function(cmd, carID)

    if getElementData(localPlayer, "user:admin") > 1 then 
        carID = tonumber(carID) or 0
        
        if carID > 0 then 

            for k, v in ipairs(getElementsByType("vehicle")) do 
                if getElementData(v, "veh:id") == carID then 
                    if getElementData(v, "vehIsBooked") == 1 then 
                        outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."Ez a jármű le van foglalva!", 255, 255, 255, true)
                        return
                    end

                    if getElementData(v, "inCarshop") then 
                        outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."Ez a jármű egy használtautókereskedésben van!", 255, 255, 255, true)
                        return
                    end

                    triggerServerEvent("getCarOnServer", resourceRoot, localPlayer, v)
                    outputChatBox(core:getServerPrefix("server", "Jármű",3).."Magadhoz teleportáltad a(z) "..color..carID.."#ffffff-as/es ID-vel rendelkező járművet!", 255, 255, 255, true)
                    return
                end
            end
            outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."Nincs ilyen ID-vel rendelkező jármű!", 255, 255, 255, true)

        else
            outputChatBox(core:getServerPrefix("server", "Jármű",3).."/getcar [ID]", 255, 255, 255, true)
        end

    end

end)
admin:addAdminCMD("getcar", 2, "Jármű magadhoz teleportálása")

addCommandHandler("setvehplatetext", function(cmd, carID, text)

    if carID and text then 
        if getElementData(localPlayer, "user:admin") >= 5 then
            
            if string.len(text) <= 8 then 

                if carID == "*" then

                    local vehicle = getPedOccupiedVehicle(localPlayer) 

                    if vehicle then 

                        triggerServerEvent("setVehiclePlateText", resourceRoot, localPlayer, vehicle, tostring(text))
                        outputChatBox(core:getServerPrefix("server", "Jármű",3).."Megváltoztattad a(z) "..color..getElementData(vehicle, "veh:id").."#ffffff-as/es ID-vel rendelkező jármű rendszámát! "..color.."("..text..")", 255, 255, 255, true)
                        return

                    else

                        outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."Jelenleg nem ülsz járműben!", 255, 255, 255, true)
                        return

                    end 

                else

                    carID = tonumber(carID) or 0 
                    
                    if carID > 0 then 

                        for k, v in ipairs(getElementsByType("vehicle")) do 
                            if getElementData(v, "veh:id") == carID then 
                                triggerServerEvent("setVehiclePlateText", resourceRoot, localPlayer, v, tostring(text))
                                outputChatBox(core:getServerPrefix("server", "Jármű",3).."Megváltoztattad a(z) "..color..carID.."#ffffff-as/es ID-vel rendelkező jármű rendszámát! "..color.."("..text..")", 255, 255, 255, true)
                                return
                            end
                        end
                        outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."Nincs ilyen ID-vel rendelkező jármű!", 255, 255, 255, true)
            
                    end

                end 

            else

                outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."Hosszú rendszám!", 255, 255, 255, true)

            end

        end
    else
        outputChatBox(core:getServerPrefix("server", "Jármű",3).."/setvehplatetext [ID] [Plate Text]", 255, 255, 255, true)
    end

end)
admin:addAdminCMD("setvehplatetext", 5, "Jármű rendszámának megváltoztatása")

addCommandHandler("fuelveh", function(cmd, target)

    if getElementData(localPlayer, "user:admin") > 2 then 
        if target then
			local target = core:getPlayerFromPartialName(localPlayer, target)
            if target then
                if getPedOccupiedVehicle(target) then 
                    local carID = getElementData(getPedOccupiedVehicle(target), "veh:id")
                    if carID > 0 then 
                        --for k, v in ipairs(getElementsByType("vehicle")) do 
                        -- if getElementData(v, "veh:id") == carID then 
                                triggerServerEvent("fuelVehicle", resourceRoot, getPedOccupiedVehicle(target), target)
                                outputChatBox(core:getServerPrefix("server", "Jármű",3).."Megtankoltad "..color..getPlayerName(target):gsub("_", " ").."#ffffffnevű játékos járművét!", 255, 255, 255, true)
                                return
                            --end
                        --end
                    
                    else
                        outputChatBox(core:getServerPrefix("server", "Jármű",3).."/fuelveh [ID]", 255, 255, 255, true)
                    end
                else
                    outputChatBox(core:getServerPrefix("red-dark", "Jármű", 3).."A játékos nincs járműben!", 255, 255, 255, true)
                end
            else
                outputChatBox(core:getServerPrefix("server", "Jármű",3).."/fuelveh [ID]", 255, 255, 255, true)
            end
               
        else
            outputChatBox(core:getServerPrefix("server", "Jármű",3).."/fuelveh [ID]", 255, 255, 255, true)
        end
    end
end)
admin:addAdminCMD("fuelveh", 3, "Játékos járművének megtankolása")

addCommandHandler("setvehfuel", function(cmd, target, value)
    if getElementData(localPlayer, "user:admin") > 2 then 
        if target or value then
			local target = core:getPlayerFromPartialName(localPlayer, target)
            if target then
                if getPedOccupiedVehicle(target) then 
                    local carID = getElementData(getPedOccupiedVehicle(target), "veh:id")
                    if carID > 0 then 
                        --for k, v in ipairs(getElementsByType("vehicle")) do 
                        -- if getElementData(v, "veh:id") == carID then 
                                triggerServerEvent("setFuelVeh", resourceRoot, getPedOccupiedVehicle(target), target, value)
                                outputChatBox(core:getServerPrefix("server", "Jármű",3).."Megtankoltad "..color..getPlayerName(target):gsub("_", " ").."#ffffffnevű játékos járművét!", 255, 255, 255, true)
                                return
                            --end
                        --end
                    
                    else
                        outputChatBox(core:getServerPrefix("server", "Jármű",3).."/setvehfuel [ID] [Érték (L)]", 255, 255, 255, true)
                    end
                else
                    outputChatBox(core:getServerPrefix("red-dark", "Jármű", 3).."A játékos nincs járműben!", 255, 255, 255, true)
                end
            else
                outputChatBox(core:getServerPrefix("server", "Jármű",3).."/setvehfuel [ID] [Érték (L)]", 255, 255, 255, true)
            end
               
        else
            outputChatBox(core:getServerPrefix("server", "Jármű",3).."/setvehfuel [ID] [Érték (L)]", 255, 255, 255, true)
        end
    end
end)
admin:addAdminCMD("setvehfuel", 3, "Játékos járművének tankolásának változtatása")

addCommandHandler("setvehcolor", function(cmd, carID, r, g, b, r1, g1, b1)

    if getElementData(localPlayer, "user:admin") > 5 then 
        if carID and r and g and b then 

                r, g, b = tonumber(r), tonumber(g), tonumber(b)
                r1, g1, b1 = tonumber(r1), tonumber(g1), tonumber(b1)
                if not r1 and g1 and b1 then 
                    r1, g1, b1 = 255, 255, 255
                else 
                    r1, g1, b1 = tonumber(r1), tonumber(g1), tonumber(b1) 
                end

                if carID == "*" then

                    local vehicle = getPedOccupiedVehicle(localPlayer) 

                    if vehicle then 

                        triggerServerEvent("setVehicleColorOnServer", resourceRoot, localPlayer, vehicle, {r, g, b, r1, g1, b1})
                        outputChatBox(core:getServerPrefix("server", "Jármű",3).."Megváltoztattad a(z) "..color..getElementData(vehicle, "veh:id").."#ffffff-as/es ID-vel rendelkező jármű színét!", 255, 255, 255, true)
                        return

                    else

                        outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."Jelenleg nem ülsz járműben!", 255, 255, 255, true)
                        return

                    end 

                else

                    carID = tonumber(carID) or 0 
                    
                    if carID > 0 then 

                        for k, v in ipairs(getElementsByType("vehicle")) do 
                            if getElementData(v, "veh:id") == carID then 
                                triggerServerEvent("setVehicleColorOnServer", resourceRoot, localPlayer, v, {r, g, b, r1, g1, b1})
                                outputChatBox(core:getServerPrefix("server", "Jármű",3).."Megváltoztattad a(z) "..color..carID.."#ffffff-as/es ID-vel rendelkező jármű színét!", 255, 255, 255, true)
                                return
                            end
                        end
                        outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."Nincs ilyen ID-vel rendelkező jármű!", 255, 255, 255, true)
            
                    end

                end
        else
            outputChatBox(core:getServerPrefix("server", "Jármű",3).."/setvehcolor [ID] [R] [G] [B] <R1 G1 B1>", 255, 255, 255, true)
        end
    end

end)
admin:addAdminCMD("setvehcolor", 6, "Jármű színének megváltoztatása")

addCommandHandler("delveh", function(cmd, carID)
    if getElementData(localPlayer, "user:admin") >= 7 then 
        if carID then 
            if carID == "*" then

                local vehicle = getPedOccupiedVehicle(localPlayer) 

                if vehicle then 

                    triggerServerEvent("delVehicleOnServer", resourceRoot, localPlayer, vehicle)
                    outputChatBox(core:getServerPrefix("server", "Jármű",3).."Kitörölted a(z) "..color..getElementData(vehicle, "veh:id").."#ffffff-as/es ID-vel rendelkező járművet!", 255, 255, 255, true)
                    return

                else

                    outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."Jelenleg nem ülsz járműben!", 255, 255, 255, true)
                    return

                end 

            else

                carID = tonumber(carID) or 0 
                
                if carID > 0 then 

                    for k, v in ipairs(getElementsByType("vehicle")) do 
                        if getElementData(v, "veh:id") == carID then 
                            triggerServerEvent("delVehicleOnServer", resourceRoot, localPlayer, v)
                            outputChatBox(core:getServerPrefix("server", "Jármű",3).."Kitörölted a(z) "..color..carID.."#ffffff-as/es ID-vel rendelkező járművet!", 255, 255, 255, true)
                            return
                        end
                    end
                    outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."Nincs ilyen ID-vel rendelkező jármű!", 255, 255, 255, true)
        
                end

            end
        else
            outputChatBox(core:getServerPrefix("server", "Jármű",3).."/delveh [ID] ", 255, 255, 255, true)
        end
    end

end)
admin:addAdminCMD("delveh", 7, "Jármű törlése")

addCommandHandler("setcarhp", function(cmd, carID, hp)

    if carID then 
        if getElementData(localPlayer, "user:admin") >= 7 then 

            hp = tonumber(hp)

            if carID == "*" then

                local vehicle = getPedOccupiedVehicle(localPlayer) 

                if vehicle then 

                    triggerServerEvent("setVehicleHpOnServer", resourceRoot, localPlayer, vehicle, hp)
                    outputChatBox(core:getServerPrefix("server", "Jármű",3).."Átállítottad a(z) "..color..getElementData(vehicle, "veh:id").."#ffffff-as/es ID-vel rendelkező jármű életszintjét! "..color.."("..hp..")", 255, 255, 255, true)
                    return

                else

                    outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."Jelenleg nem ülsz járműben!", 255, 255, 255, true)
                    return

                end 

            else

                carID = tonumber(carID) or 0 
                
                if carID > 0 then 

                    for k, v in ipairs(getElementsByType("vehicle")) do 
                        if getElementData(v, "veh:id") == carID then 
                            triggerServerEvent("setVehicleHpOnServer", resourceRoot, localPlayer, v, hp)
                            outputChatBox(core:getServerPrefix("server", "Jármű",3).."Átállítottad a(z) "..color..carID.."#ffffff-as/es ID-vel rendelkező jármű életszintjét! "..color.."("..hp..")", 255, 255, 255, true)
                            return
                        end
                    end
                    outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."Nincs ilyen ID-vel rendelkező jármű!", 255, 255, 255, true)
        
                end

            end

        end
    else
        outputChatBox(core:getServerPrefix("server", "Jármű",3).."/setcarhp [ID] [HP (0-1000)]", 255, 255, 255, true)
    end

end)
admin:addAdminCMD("setcarhp", 7, "Jármű életének megváltoztatása")

addCommandHandler("blowveh", function(cmd, carID, hp)
    if carID then 
        if getElementData(localPlayer, "user:admin") >= 10 then 
            if carID == "*" then
                local vehicle = getPedOccupiedVehicle(localPlayer) 

                if vehicle then 

                    triggerServerEvent("blowUpVehicle", resourceRoot, localPlayer, vehicle)
                    outputChatBox(core:getServerPrefix("server", "Jármű",3).."Felrobbantottad a(z) "..color..getElementData(vehicle, "veh:id").."#ffffff-as/es ID-vel rendelkező járművet!", 255, 255, 255, true)
                    return

                else

                    outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."Jelenleg nem ülsz járműben!", 255, 255, 255, true)
                    return

                end 
            else
                carID = tonumber(carID) or 0 
                
                if carID > 0 then 
                    for k, v in ipairs(getElementsByType("vehicle")) do 
                        if getElementData(v, "veh:id") == carID then 
                            triggerServerEvent("blowUpVehicle", resourceRoot, localPlayer, v)
                            outputChatBox(core:getServerPrefix("server", "Jármű",3).."Felrobbantottad a(z) "..color..getElementData(vehicle, "veh:id").."#ffffff-as/es ID-vel rendelkező járművet!", 255, 255, 255, true)
                            return
                        end
                    end
                    outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."Nincs ilyen ID-vel rendelkező jármű!", 255, 255, 255, true)
                end
            end
        end
    else
        outputChatBox(core:getServerPrefix("server", "Jármű",3).."/blowveh [ID] ", 255, 255, 255, true)
    end
end)
admin:addAdminCMD("blowveh", 10, "Jármű felrobbantása")

addCommandHandler("respawnveh", function(cmd, carID, hp)
    if carID then 
        if getElementData(localPlayer, "user:admin") >= 2 then 
            if carID == "*" then
                local vehicle = getPedOccupiedVehicle(localPlayer) 

                if vehicle then 

                    triggerServerEvent("respawnVeh", resourceRoot, localPlayer, vehicle)
                    outputChatBox(core:getServerPrefix("server", "Jármű",3).."Respawnolta a(z) "..color..getElementData(vehicle, "veh:id").."#ffffff-as/es ID-vel rendelkező járművet!", 255, 255, 255, true)
                    return

                else

                    outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."Jelenleg nem ülsz járműben!", 255, 255, 255, true)
                    return

                end 
            else
                carID = tonumber(carID) or 0 
                
                if carID > 0 then 
                    for k, v in ipairs(getElementsByType("vehicle")) do 
                        if getElementData(v, "veh:id") == carID then 
                            triggerServerEvent("respawnVeh", resourceRoot, localPlayer, v)
                            outputChatBox(core:getServerPrefix("server", "Jármű",3).."Respawnolta a(z) "..color..getElementData(vehicle, "veh:id").."#ffffff-as/es ID-vel rendelkező járművet!", 255, 255, 255, true)
                            return
                        end
                    end
                    outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."Nincs ilyen ID-vel rendelkező jármű!", 255, 255, 255, true)
                end
            end
        end
    else
        outputChatBox(core:getServerPrefix("server", "Jármű",3).."/respawnveh [ID] ", 255, 255, 255, true)
    end
end)
admin:addAdminCMD("respawnveh", 2, "Jármű respawnolása")

addCommandHandler("warp", function(cmd)

    if getElementData(localPlayer, "user:admin") >= 2 then 

        triggerServerEvent("warpPedToVehicleOnServer", resourceRoot, localPlayer, getNearestVehicle(localPlayer, 25))

    end

end)
admin:addAdminCMD("warp", 2, "beszállás a legközelebbi jármű anyósülésére")

addCommandHandler("rtc", function(cmd)

    if getElementData(localPlayer, "user:admin") >= 3 then

        local rtc_needed_vehicles = {}
        local playerDim, playerInt = getElementDimension(localPlayer), getElementInterior(localPlayer)

        for k, v in ipairs(getElementsByType("vehicle")) do 

            if core:getDistance(localPlayer, v) <= 15 then 

                if getElementDimension(v) == playerDim and getElementInterior(v) == playerInt then 

                    table.insert(rtc_needed_vehicles, #rtc_needed_vehicles+1, v)

                end

            end

        end

        if #rtc_needed_vehicles > 0 then 
            triggerServerEvent("rtcVehiclesOnServer", resourceRoot, localPlayer, rtc_needed_vehicles)
        else
            outputChatBox(core:getServerPrefix("red-dark", "RTC", 3).."Nincsenek járművek a közeledben!", 255, 255, 255, true)
        end
    end 

end)
admin:addAdminCMD("rtc", 3, "Járművek respawnolása")

addCommandHandler("nearbyvehicles", function(cmd)
    if getElementData(localPlayer, "user:admin") >= 3 then

        local playerDim, playerInt = getElementDimension(localPlayer), getElementInterior(localPlayer)
        outputChatBox(color.."<===== [Közeledben lévő járművek] =====>", 255, 255, 255, true)

        for k, vehicle in pairs(getElementsByType("vehicle")) do 
            if core:getDistance(localPlayer, vehicle) <= 15 then 
                if getElementDimension(vehicle) == playerDim and getElementInterior(vehicle) == playerInt then 
                    print(tonumber(getElementData(vehicle,"veh:isFactionVehicle")))

                    if not (getElementData(vehicle,"veh:isFactionVehicle") == 1) then
                        for k,v in pairs(getElementsByType("player")) do 
                            if getElementData(v,"char:id") == getElementData(vehicle, "veh:owner") then 
                                ownerPlayer = v
                                print(getElementData(v,"char:id"))
                            end 
                        end 
                    
                        text = ""

                        if ownerPlayer then
                            local playerid = getElementData(ownerPlayer,"playerid")
                            local charname = getElementData(ownerPlayer,"char:name")
                            text = charname.." ["..playerid.."]"
                        elseif not ownerPlayer then 
                            text = getElementData(vehicle,"veh:owner").." [CHARID:OFFLINE VAGY FRAKCIÓ]"
                        end 

                        outputChatBox(core:getServerPrefix("blue-dark", getElementData(vehicle, "veh:id"), 3).."Jármű neve: "..color..getModdedVehName(getElementModel(vehicle)).." #ffffffTulajdonos: "..color..text, 255, 255, 255, true)
                        ownerPlayer = nil
                    else 
                        text = getElementData(vehicle,"veh:owner").." [FRAKCIÓ]"
                        outputChatBox(core:getServerPrefix("blue-dark", getElementData(vehicle, "veh:id"), 3).."Jármű neve: "..color..getModdedVehName(getElementModel(vehicle)).." #ffffffTulajdonos: "..color..text, 255, 255, 255, true)
                    end
                end    
            end
        end
    end
end)
admin:addAdminCMD("nearbyvehicles", 3, "Közeledben lévő járművek listázása")

addCommandHandler("getvehid", function(cmd)
    if getElementData(localPlayer, "user:admin") >= 2 then

        local veh = getPedOccupiedVehicle(localPlayer) or false
        if veh then 
            outputChatBox(core:getServerPrefix("server", "Jármű", 3).."Jármű ID: "..color..getElementData(veh, "veh:id").." #ffffffJármű neve: "..color..getVehicleName(veh) .." #ffffffTulajdonos: "..color..getElementData(veh, "veh:owner").." #ffffffDevID: "..color..getElementModel(veh), 255, 255, 255, true)
        else
            outputChatBox(core:getServerPrefix("red-dark", "Jármű", 3).."Nem ülsz járműben!", 255, 255, 255, true)
        end
    end
end)
admin:addAdminCMD("getvehid", 2, "Jelenlegi járműved adatainak lekérése")

admin:addAdminCMD("makeveh", 7, "Jármű létrehozása")

addCommandHandler("protectveh", function(cmd, vehID)
    if vehID then 
        if getElementData(localPlayer, "user:admin") >= 7 then 

            if vehID == "*" then

                local vehicle = getPedOccupiedVehicle(localPlayer) 

                if vehicle then 

                    if getElementData(vehicle, "veh:protected") == 0 then 
                        triggerServerEvent("protectVehicleOnServer", resourceRoot, vehicle)
                        outputChatBox(core:getServerPrefix("server", "Jármű",3).."Levédted a(z) "..color..getElementData(vehicle, "veh:id").."#ffffff-as/es ID-vel rendelkező járművet!", 255, 255, 255, true)
                        return
                    else
                        outputChatBox(core:getServerPrefix("red-dark", "Jármű", 3).."Ez a jármű már le van védve!", 255, 255, 255, true)
                    end

                else

                    outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."Jelenleg nem ülsz járműben!", 255, 255, 255, true)
                    return

                end 

            else

                vehID = tonumber(carID) or 0 
                
                if vehID > 0 then 

                    for k, v in ipairs(getElementsByType("vehicle")) do 
                        if getElementData(v, "veh:id") == vehID then 
                            if getElementData(v, "veh:protected") == 0 then 
                                triggerServerEvent("protectVehicleOnServer", resourceRoot, v)
                                outputChatBox(core:getServerPrefix("server", "Jármű",3).."Levédted a(z) "..color..getElementData(v, "veh:id").."#ffffff-as/es ID-vel rendelkező járművet!", 255, 255, 255, true)
                                return
                            else
                                outputChatBox(core:getServerPrefix("red-dark", "Jármű", 3).."Ez a jármű már le van védve!", 255, 255, 255, true)
                            end
                        end
                    end
                    outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."Nincs ilyen ID-vel rendelkező jármű!", 255, 255, 255, true)
        
                end

            end

        end
    else
        outputChatBox(core:getServerPrefix("server", "Jármű",3).."/"..cmd.." [ID]", 255, 255, 255, true)
    end
end)
admin:addAdminCMD("protectveh", 7, "Jármű levédése")

addCommandHandler("unprotectveh", function(cmd, vehID)
    if vehID then 
        if getElementData(localPlayer, "user:admin") >= 7 then 

            if vehID == "*" then

                local vehicle = getPedOccupiedVehicle(localPlayer) 

                if vehicle then 

                    if getElementData(vehicle, "veh:protected") == 1 then 
                        triggerServerEvent("unprotectVehicleOnServer", resourceRoot, vehicle)
                        outputChatBox(core:getServerPrefix("server", "Jármű",3).."Eltávolítottad a levédést a(z) "..color..getElementData(vehicle, "veh:id").."#ffffff-as/es ID-vel rendelkező járműről!", 255, 255, 255, true)
                        return
                    else
                        outputChatBox(core:getServerPrefix("red-dark", "Jármű", 3).."Ez a jármű nincs levédve!", 255, 255, 255, true)
                    end

                else

                    outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."Jelenleg nem ülsz járműben!", 255, 255, 255, true)
                    return

                end 

            else

                vehID = tonumber(carID) or 0 
                
                if vehID > 0 then 

                    for k, v in ipairs(getElementsByType("vehicle")) do 
                        if getElementData(v, "veh:id") == vehID then 
                            if getElementData(v, "veh:protected") == 1 then 
                                triggerServerEvent("unprotectVehicleOnServer", resourceRoot, v)
                                outputChatBox(core:getServerPrefix("server", "Jármű",3).."Eltávolítottad a levédést a(z) "..color..getElementData(v, "veh:id").."#ffffff-as/es ID-vel rendelkező járműről!", 255, 255, 255, true)
                                return
                            else
                                outputChatBox(core:getServerPrefix("red-dark", "Jármű", 3).."Ez a jármű nincs levédve!", 255, 255, 255, true)
                            end
                        end
                    end
                    outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."Nincs ilyen ID-vel rendelkező jármű!", 255, 255, 255, true)
        
                end

            end

        end
    else
        outputChatBox(core:getServerPrefix("server", "Jármű",3).."/"..cmd.." [ID]", 255, 255, 255, true)
    end
end)
admin:addAdminCMD("unprotectveh", 7, "Jármű levédésének eltávolítása")

---------[ Civil commands ]---------
--kiszed
addCommandHandler("kiszed", function(cmd, id)
    if id then 
        if not getPedOccupiedVehicle(localPlayer) then 
            if tonumber(id) > 0 then 
                local target, targetName = core:getPlayerFromPartialName(localPlayer, id)

                if core:getDistance(localPlayer, target) <= 3 then
                    local targetVehicle = getPedOccupiedVehicle(target)
                    if targetVehicle then
                        if not (getElementData(targetVehicle, "veh:locked")) then 
                            if not (getElementData(target, "vehicle:seatbeltState")) then 
                                triggerServerEvent("takeOutFromVehicle", resourceRoot, target)
                            else
                                outputChatBox(core:getServerPrefix("red-dark", "Kiszed", 2).."A játékos biztonsági öve be van kötve!", 255, 255, 255, true)
                            end
                        else
                            outputChatBox(core:getServerPrefix("red-dark", "Kiszed", 2).."A jármű ajtaja zárva van!", 255, 255, 255, true)
                        end 
                    else
                        outputChatBox(core:getServerPrefix("red-dark", "Kiszed", 2).."Ez a játékos nem ül járműben!", 255, 255, 255, true)
                    end
                else
                    outputChatBox(core:getServerPrefix("red-dark", "Kiszed", 2).."Túl távol vagy!", 255, 255, 255, true)
                end 
            else
                outputChatBox(core:getServerPrefix("red-dark", "Kiszed", 2).."Csak számot!", 255, 255, 255, true)
            end
        else
            outputChatBox(core:getServerPrefix("red-dark", "Kiszed", 2).."Ez a parancs csak járművön kívül működik!", 255, 255, 255, true)
        end
    else
        outputChatBox(core:getServerPrefix("server", "Haszálat", 3).."/"..cmd.." [ID]", 255, 255, 255, true)
    end
end)
--öv elvágása

addEventHandler("onClientVehicleStartEnter", root, function(player, seat, door)
    if player == localPlayer then 
        if seat == 0 then 
            local occupants = getVehicleOccupants(source)
            
            if occupants[0] then
                outputChatBox(core:getServerPrefix("red-dark", "Jármű", 3).."Ez nonRP-s kocsilopás! Használd a "..color.."/kiszed #ffffffparancsot.", 255, 255, 255, true) 
                cancelEvent()
            end
        end
    end
end)

-- park 
--[[addCommandHandler("park", function()
    local occupiedVeh = getPedOccupiedVehicle(localPlayer)

    if occupiedVeh then 
        if getElementData(occupiedVeh, "veh:isFactionVehice") == 0 then 
            if getElementData(occupiedVeh, "veh:owner") == getElementData(localPlayer, "char:id") then 
                local x, y, z = getElementPosition(occupiedVeh)
                setElementData(occupiedVeh, "veh:parkPos", {x, y, z, getElementInterior(occupiedVeh), getElementDimension(occupiedVeh)})
                outputChatBox(core:getServerPrefix("green-dark", "Jármű", 3).."Sikeresen leparkoztad a járművedet.", 255, 255, 255, true) 
            end
        end
    end
end)]]