-------[TESZTVEZETÉS]-----------

--[[function createTestVehicle(pos, model, color)
    if not(getElementData(client, "carshop:inTest")) then
        local px, py, pz = getElementPosition(client)
        setElementData(client, "carshop:defaultpos", {px, py, pz})

        local testVehDim = 700 + (getElementData(client, "char:id") * 2)

        local veh = createVehicle(model, pos[1], pos[2], pos[3], 0, 0, pos[4], "TESTVEH")
        setVehicleVariant(veh, 255, 255)
        setVehicleColor(veh, color[1], color[2], color[3])
        setElementDimension(veh, testVehDim)

        setElementDimension(client, testVehDim)
        warpPedIntoVehicle(client, veh)
        setElementData(client, "carshop:testveh", veh)
        setElementData(client, "carshop:inTest", true)
        setVehicleEngineState(veh, true)
        setElementData(veh, "veh:engine", true)

        exports.oHandling:loadHandling(veh)
    end    
end
addEvent("makeTestveh", true)
addEventHandler("makeTestveh", resourceRoot, createTestVehicle)

function respawnPlayer(player)
    setElementDimension(player, 0)
    setElementData(player, "carshop:inTest", false)

    local defaultpos = getElementData(player, "carshop:defaultpos")
    setElementPosition(player, defaultpos[1],defaultpos[2],defaultpos[3])
end

function destroyTestVehicle()
    local veh = getElementData(client, "carshop:testveh") or false 
    if veh then 
        destroyElement(veh)
    end
    respawnPlayer(client)
end
addEvent("deleteTestveh", true)
addEventHandler("deleteTestveh", resourceRoot, destroyTestVehicle)

addEventHandler("onResourceStop", resourceRoot, function()
    for k,v in ipairs(getElementsByType("player")) do 
        if getElementData(v, "carshop:inTest") then 
            destroyTestVehicle(v)
            respawnPlayer(v)
        end
    end
end)]]--
------------------


--------[Jármű vásárlás]--------
local spawnCols = {}
function createVehicleSpawnPosCols()
    for i = 1, #carSpawnPos do 
        table.insert(spawnCols, i, {})

        for k,v in pairs(carSpawnPos[i]) do 
            if k == "lv" or k == "ls" then 
                for k2, v2 in ipairs(v) do 
                    local col = createColSphere(v2[1],v2[2],v2[3],3)

                    if not spawnCols[i..k] then 
                        spawnCols[i..k] = {}
                    end

                    table.insert(spawnCols[i..k], col)
                end
            else
                local col = createColSphere(v[1],v[2],v[3],3)
                table.insert(spawnCols[i], col)
            end
        end
    end
end
createVehicleSpawnPosCols()

function countFirstEmptyCol(shopType, city)
    if shopType == 1 then
        for k, v in ipairs(spawnCols[shopType..city]) do 
            if #getElementsWithinColShape(v) == 0 then 
                return k
            end
        end
    else
        for k, v in ipairs(spawnCols[shopType]) do 
            if #getElementsWithinColShape(v) == 0 then 
                return k
            end
        end
    end
end

function buyVehicle(modelId, color, price_dollar, price_premium, shopType, city)
    if client then 
        if not source == client then 
            outputDebugString("[oVehicle]: INVALID ELEMENT!!! TRIGGERHACK!!! "..tostring(getPlayerName(source)),1)
            return 
        end 

        if not getElementData(client,"inCarshop") then return end


        local firstEmpyCol = countFirstEmptyCol(shopType, shortCityNames[city])

        if firstEmpyCol then
            local px, py, pz, rot  

            if shopType == 1 then
                px, py, pz, rot = carSpawnPos[shopType][shortCityNames[city]][firstEmpyCol][1], carSpawnPos[shopType][shortCityNames[city]][firstEmpyCol][2], carSpawnPos[shopType][shortCityNames[city]][firstEmpyCol][3], carSpawnPos[shopType][shortCityNames[city]][firstEmpyCol][4] 
            else 
                px, py, pz, rot = carSpawnPos[shopType][firstEmpyCol][1], carSpawnPos[shopType][firstEmpyCol][2], carSpawnPos[shopType][firstEmpyCol][3], carSpawnPos[shopType][firstEmpyCol][4] 
            end

            if (price_dollar > 0) then
                if (price_dollar <= getElementData(client,'char:money')) then
                    local veh = vehicle:createNewVehicle(modelId, client, {px, py, pz}, {0, 0, rot}, color)
                
                    setElementRotation(veh, 0, 0, rot)
                    warpPedIntoVehicle(client, veh)
                
                    setElementData(client, "char:money", getElementData(client, "char:money")-price_dollar)
                
                    local owner = client
                    setTimer(function()
                        inventory:giveItem(owner, 51, getElementData(veh, "veh:id"), 1, 0) 
                    end,1000,1)
                    infobox:outputInfoBox("Sikeresen megvásároltad a kiválasztott járművet!","success",client)
                else
                    infobox:outputInfoBox("Nincs elegendő készpénzed a vásárláshoz! ("..price_dollar.."$)","error",client)
                end
            elseif (price_premium > 0) then
                if (price_premium <= getElementData(client,'char:pp')) then
                    local veh = vehicle:createNewVehicle(modelId, client, {px, py, pz}, {0, 0, rot}, color)

                    setElementRotation(veh, 0, 0, rot)
                    warpPedIntoVehicle(client, veh)

                    setElementData(client, "char:pp", getElementData(client, "char:pp")-price_premium)
                    local owner = client
                    setTimer(function()
                        inventory:giveItem(owner, 51, getElementData(veh, "veh:id"), 1, 0)
                    end,1000,1)
                    infobox:outputInfoBox("Sikeresen megvásároltad a kiválasztott járművet!","success",client)
                else
                    infobox:outputInfoBox("Nincs elegendő prémium pontod a vásárláshoz! ("..price_premium.."PP)","error",client)
                end
            end

        end
    end 
end
addEvent("buyCarshopVehicle", true)
addEventHandler("buyCarshopVehicle", resourceRoot, buyVehicle)

local factionLogMessageColor = "#fc7b03"
local factionLogNameColor = "#0d73e0"
function buyVehicles(modelId, color, ownerFaction, price_dollar, price_premium, shopType, pj)
    if client then 
        if not source == client then 
            outputDebugString("[oVehicle]: INVALID ELEMENT!!! TRIGGERHACK!!! "..tostring(getPlayerName(source)),1)
            return 
        end 

        if not getElementData(client,"inCarshop") then return end

        local firstEmpyCol = countFirstEmptyCol(shopType, "ls")

        if firstEmpyCol then 
            local px, py, pz, rot = carSpawnPos[shopType][firstEmpyCol][1], carSpawnPos[shopType][firstEmpyCol][2], carSpawnPos[shopType][firstEmpyCol][3], carSpawnPos[shopType][firstEmpyCol][4] 
            local veh = vehicle:createNewFactionVehicle(modelId, ownerFaction, {px, py, pz}, {0, 0, rot}, color)

            if pj > 0 then 
                setElementData(veh, "veh:paintjob", pj)
            end

            setElementRotation(veh, 0, 0, rot)
            warpPedIntoVehicle(client, veh)

            exports.oDashboard:setFactionBankMoney(ownerFaction, price_dollar, "remove")
            exports.oDashboard:outputFactionLogToAdmins(factionLogNameColor..getPlayerName(client):gsub("_", " ")..factionLogMessageColor.." vett egy "..factionLogNameColor..vehicle:getModdedVehicleName(veh)..factionLogMessageColor.." nevű járművet a(z) "..factionLogNameColor..exports.oDashboard:getFactionName(ownerFaction)..factionLogMessageColor.." nevű frakcióba.")

            inventory:giveItem(client, 51, getElementData(veh, "veh:id"), 1, 0)
        end
    end 
end
addEvent("buyCarshopVehicleToFaction", true)
addEventHandler("buyCarshopVehicleToFaction", resourceRoot, buyVehicles)
----------------------