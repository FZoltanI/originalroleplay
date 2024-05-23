local screenX, screenY = guiGetScreenSize()
local sx, sy = guiGetScreenSize()
local clientData = {}
local oilMarker = false
local elements = {}
local leaveMarker = false
local leaveId = -1
local hex = "#e97619" --, r, g, b = exports.oCore:getServerColor()
--#e97619

local objs = {}

local createdObjs = {}

local created3d = false
local oilDat, oilDat2 = false, false
--outputChatBox(hex)
--oCore:getServerPrefix("server", "OilStation", 2)
addEventHandler("onClientResourceStart", resourceRoot, function()
    setElementData(localPlayer, "char.OilStationId", 0)
    setTimer(function()
        if getOilStationByOwner(getElementData(localPlayer, "char:id")) then 
            local stationData = getElementData(getOilStationByOwner(getElementData(localPlayer, "char:id")), "oilMarker.datas")
            if stationData then 
                if stationData.wrongMachineId > 0 and stationData.errorMachine == 1 then 
                    triggerEvent("createRepairMarker", localPlayer, stationData.id)
                end
            end
        end
    end, 5000, 1)
end)


function create3D()
    if not created3d then
        myElement = Object(3426, 0, 0, 9999999999)
        myObject = exports.oPreview:createObjectPreview(myElement,0, 0, -99999, 0, 0, 1, 1, false, false, false)
        -- myObject = exports.oPreview:createObjectPreview(myElement,0, 0, 0, 0.5, 0.5, 1, 1, true, true, true)
        guiWindow = GuiWindow((sx / 2 ) - 400, (sy / 2) - 270, 800, 800, " ", false, false)
        local projPosX, projPosY = guiWindow:getPosition(true)
        local projSizeX, projSizeY = guiWindow:getSize(true)
        guiWindow.visible = false
        exports.oPreview:setProjection(myObject, projPosX, projPosY, projSizeX, projSizeY, false, false)
        exports.oPreview:setRotation(myObject, 0, 0, 90)
        created3d = true
    end
end

function destroy3D()
    exports.oPreview:destroyObjectPreview(myObject)
    created3d = false
end


addEventHandler("onClientElementDataChange", getRootElement(), function(dataName)
    if getElementType(source) == "player" then 
        if dataName == "char:id" then 
            setTimer(function()
                if getOilStationByOwner(getElementData(localPlayer, "char:id")) then 
                    local stationData = getElementData(getOilStationByOwner(getElementData(localPlayer, "char:id")), "oilMarker.datas")
                    if stationData then 
                        if stationData.wrongMachineId > 0 and stationData.errorMachine == 1 then 
                            triggerEvent("createRepairMarker", localPlayer, stationData.id)
                        end
                    end
                end
            end, 5000, 1)
        end
    end
end)

function getNameForOwnerID(charId)
    for k,v in ipairs(getElementsByType("player")) do 
        if getElementData(v, "char:id") == charId then 
            return getPlayerName(v)
        end
    end
end

addEventHandler("onClientMarkerHit",getRootElement(),function(hitPlayer, matchD)
    if hitPlayer == localPlayer then 
        if getElementData(source, "oilMarker.isOil") then 
            oilMarker = source
            local data = getElementData(oilMarker, "oilMarker.datas")
            --outputChatBox(data.name)
            if data.owner == 0 then 
                outputChatBox(hex .."[OriginalRoleplay - OilStation]#FFFFFF Ez a olaj telep kiadó "..hex .."50000$#FFFFFF a kibérlése!",255, 255, 255, true)
                outputChatBox(hex .."[OriginalRoleplay - OilStation]#FFFFFF Figyelem ha kibéreled 1 heted van meghosszabítani!",255, 255, 255, true)
                outputChatBox(hex .."[OriginalRoleplay - OilStation]#FFFFFF /rentoilstation",255, 255, 255, true)
            else
                outputChatBox(hex .."[OriginalRoleplay - OilStation]#FFFFFF Ez a telep: "..getNameForOwnerID(data.owner) .. " tulajdonában van!",255, 255, 255, true)
            end
        end
    end
end)

local randomPositions = {
    {
        pos = Vector3(630.30023193359, 1355.8433837891, 13.182829856873)
    },
    {   
        pos = Vector3(562.69555664062, 1310.3547363281, 11.268767356873)
    },
    {
        pos = Vector3(489.40258789062, 1307.6101074219, 10.065642356873)
    },
    {
        pos = Vector3(353.03521728516, 1298.9880371094, 16.041793823242)
    }
}


addEventHandler("onClientMarkerLeave", getRootElement(), function(hitPlayer, matchD)
    if hitPlayer == localPlayer then 
        if getElementData(source, "oilMarker.isOil") then 
            oilMarker = false
        end
    end
end)

function table_random ( theTable )
    return theTable[math.random ( #theTable )]
end



local randomPos = table_random(randomPositions)


addEvent("createObj", true)
function createClientObj(dim)
    outputChatBox(randomPos.pos.x .. randomPos.pos.y .. randomPos.pos.z)
    local prvObj = Object(3427, randomPos.pos.x, randomPos.pos.y, randomPos.pos.z)
    prvObj.dimension = dim
end
addEventHandler("createObj", root, createClientObj)
-- outputChatBox(randomPos.pos.x)

function initDimension(station, dim)
    setElementData(localPlayer, "char.OilStationId", station)
    -- outputChatBox(tostring(station))
    test = Object(2181, 662.48248291016, 1258.8697509766, 11.4609375 - 1)
    test:setData("oil > computer", true)
    test.dimension = station
    setElementRotation(test, 0, 0, 298)
    local stationData = getElementData(getOilStationById(station), "oilMarker.datas")
    
    for i, v in pairs(elements) do
        if isElement(v) then
            destroyElement(v)
        end
    end
    elements = {}

    for i = 1, stationData.oilPump do 
        local oilPump = createObject(unpack(oilStation.oilPump[i]))
        setElementInterior(oilPump, 0)
        setElementDimension(oilPump, dim)

        table.insert(elements,oilPump)
    end

    table.insert(elements, test)


    local removeObject = {
        {16271, 23.174088, 620.35938, 1249.3281, 24.89063, 0},
        {16620, 23.174088, 620.35938, 1249.3281, 24.89063, 0}, -- LOD of 16271
        {16272, 52.628826, 579.4375, 1249.1641, 22.5, 0},
        {16621, 52.628826, 579.4375, 1249.1641, 22.5, 0}, -- LOD of 16272
        {3173, 9.886817, 710.71094, 1210.1406, 12.39844, 0},
        {3342, 9.886817, 710.71094, 1210.1406, 12.39844, 0}, -- LOD of 3173
        {3241, 9.8965454, 706.65625, 1194.2266, 12.91406, 0},
        {3298, 9.8965454, 706.65625, 1194.2266, 12.91406, 0}, -- LOD of 3241
        {3169, 9.8952436, 395.1875, 1157.8203, 6.89844, 0},
        {3339, 9.8952436, 395.1875, 1157.8203, 6.89844, 0}, -- LOD of 3169
        {3275, 9.9976969, 395.375, 1146.3984, 8.54688, 0},
        {0, 9.9976969, 395.375, 1146.3984, 8.54688, 0}, -- LOD of 3275
        {3275, 9.9976969, 387.6875, 1153.5781, 8.13281, 0},
        {0, 9.9976969, 387.6875, 1153.5781, 8.13281, 0}, -- LOD of 3275
        {3275, 9.9976969, 386.52344, 1166.9844, 7.71875, 0},
        {0, 9.9976969, 386.52344, 1166.9844, 7.71875, 0}, -- LOD of 3275
        {16287, 10.851164, 412.25, 1164.1719, 6.89844, 0},
        {0, 10.851164, 412.25, 1164.1719, 6.89844, 0}, -- LOD of 16287
        {16285, 8.2953053, 511.99219, 1111.7813, 13.57031, 0},
        {0, 8.2953053, 511.99219, 1111.7813, 13.57031, 0}, -- LOD of 16285
        {3173, 9.886817, 498.75781, 1116.6172, 13.58594, 0},
        {3342, 9.886817, 498.75781, 1116.6172, 13.58594, 0}, -- LOD of 3173
    }

    for i = 1, #removeObject do
        removeWorldModel(unpack(removeObject[i]))
    end



    local objectCreate = {
        {16271, 691, 1260.40002, -67.2, 0, 0, 30.498, 0, 0, false, 1, 255, false, true, true},
        {3109, 675.90002, 1249, -66.8, 0, 0, 30, 0, 0, true, 1, 255, true, true, true},
        {3034, 674.09998, 1251.6, -66.3, 0, 0, 120, 0, 0, true, 1, 255, false, true, true},
        {3034, 672.5, 1254.2, -66.3, 0, 0, 119.998, 0, 0, true, 1, 255, false, true, true},
        {3109, 665.5, 1263.9, -66.9, 0, 0, 209.998, 0, 0, true, 1, 255, false, true, true},
        {10184, 668.2998, 1259, -65.5, 0, 0, 31.245, 0, 0, false, 1, 255, false, true, true},
        {3864, 658.59998, 1210.1, 16.6, 0, 0, 296, 0, 0, false, 1, 255, false, true, true},
        {17074, 676.70001, 1222.1, 10.5, 0, 0, 61.999, 0, 0, false, 1, 255, false, true, true},
        {669, 629.09998, 1180.6, 10.9, 0, 0, 170.997, 0, 0, false, 1, 255, false, true, true},
        {669, 575.09998, 1168.1, 11, 0, 0, 170.997, 0, 0, false, 1, 255, false, true, true},
        {669, 562.59998, 1165, 11.1, 0, 0, 170.997, 0, 0, false, 1, 255, false, true, true},
        {669, 538.90002, 1160, 10.6, 0, 0, 170.997, 0, 0, false, 1, 255, false, true, true},
        {669, 509.60001, 1153.6, 8.9, 0, 0, 170.997, 0, 0, false, 1, 255, false, true, true},
        {700, 549.70001, 1165.6, 10.8, 0, 0, 120.498, 0, 0, false, 1, 255, false, true, true},
        {700, 522.20001, 1158.1, 9.4, 0, 0, 120.498, 0, 0, false, 1, 255, false, true, true},
        {700, 489.89999, 1150.6, 7.5, 0, 0, 120.498, 0, 0, false, 1, 255, false, true, true},
        {700, 458.89999, 1142.5, 8, 0, 0, 120.498, 0, 0, false, 1, 255, false, true, true},
        {984, 591.5, 1238.8, 11.4, 0, 0, 265.998, 0, 0, false, 1, 255, false, true, true},
        {984, 570.59998, 1227.7, 11.3, 0, 0, 329.996, 0, 0, false, 1, 255, false, true, true},
        {984, 562.5, 1218, 11.4, 0, 0, 309.996, 0, 0, false, 1, 255, false, true, true},
        {984, 551.90002, 1211.1, 11.4, 0, 0, 295.995, 0, 0, false, 1, 255, false, true, true},
        {984, 540.29999, 1205.7, 11.3, 0, 0, 293.99, 0, 0, false, 1, 255, false, true, true},
        {3816, 619.29999, 1240.1, 15.6, 0, 0, 29.998, 0, 0, false, 1, 255, false, true, true},
        {8059, 682.5, 1266.4, 13.8, 0, 0, 208, 0, 0, false, 1, 255, false, true, true},
        {984, 579.5, 1236.2, 11.4, 0, 0, 297.995, 0, 0, false, 1, 255, false, true, true},
        {3864, 633, 1261.3, 16.7, 0, 0, 160, 0, 0, false, 1, 255, false, true, true},
        {3864, 606.5, 1218.1, 16.6, 0, 0, 352, 0, 0, false, 1, 255, false, true, true},
        {984, 634.29999, 1265.5, 11.3, 0, 0, 285.995, 0, 0, false, 1, 255, false, true, true},
        {984, 646.59998, 1269, 11.3, 0, 0, 285.991, 0, 0, false, 1, 255, false, true, true},
        {984, 659.09998, 1271.4, 11.3, 0, 0, 275.991, 0, 0, false, 1, 255, false, true, true},
        {849, 649.5, 1268.7, 11, 0, 0, 30, 0, 0, false, 1, 255, false, true, true},
        {910, 674, 1242.7, 11.7, 0, 0, 28, 0, 0, false, 1, 255, false, true, true},
        {16287, 681.90002, 1238.6, 10.4, 0, 0, 105.495, 0, 0, false, 1, 255, false, true, true},
        {16287, 669, 1210.8, 10.5, 0, 0, 41.991, 0, 0, false, 1, 255, false, true, true},
        {910, 651.79999, 1269.8, 12, 0, 0, 15.999, 0, 0, false, 1, 255, false, true, true},
        {984, 662.90002, 1202.4, 11.4, 0, 0, 295.991, 0, 0, false, 1, 255, false, true, true},
        {984, 650.70001, 1200, 11.4, 0, 0, 265.988, 0, 0, false, 1, 255, false, true, true},
        {984, 638.09998, 1202, 11.4, 0, 0, 255.985, 0, 0, false, 1, 255, false, true, true},
        {984, 625.59998, 1202.3, 11.3, 0, 0, 281.981, 0, 0, false, 1, 255, false, true, true},
        {2957, 674, 1205.3, 12.3, 0, 0, 42, 0, 0, false, 1, 255, false, true, true},
        {2957, 689.09998, 1240.5, 12.3, 0, 0, 105.495, 0, 0, false, 1, 255, false, true, true},
        {3626, 667.09998, 1257.2, -69.7, 0, 0, 300.5, 0, 0, false, 1, 255, false, true, true},
    }

    for i = 1, #objectCreate do
        local v = objectCreate[i]
        local e = createObject(v[1], v[2], v[3], v[4], v[5], v[6], v[7])
        setElementDimension(e, dim)
        setElementInterior(e, 0)
        setElementDoubleSided(e, v[10])
        setObjectScale(e, v[11])
        setElementAlpha(e, v[12])
        setElementFrozen(e, v[13])
        setObjectBreakable(e, v[14])
        setElementCollisionsEnabled(e, v[15])
        table.insert(elements, e)
    end

    leaveMarker = createMarker(659.05920410156,1256.3720703125,11.4609375-1, "cylinder", 1, 255, 0, 0, 150)
    setElementDimension(leaveMarker, dim)
    setElementInterior(leaveMarker, 0)
    setElementData(leaveMarker, "oilMarker.outMarkerElementData", getOilStationById(station))
    leaveId = station
    table.insert(elements, leaveMarker)
end
addEvent("initDimension", true)
addEventHandler("initDimension", root, initDimension)

addEvent("unLoadDimension", true)
addEventHandler("unLoadDimension",getRootElement(),function()
    for i, v in pairs(elements) do 
        if isElement(v) then 
            destroyElement(v)
        end
    end
    elements = {}
end)

addEventHandler("onClientKey",getRootElement(), function(key, press)
    if key == "e" and press and not isChatBoxInputActive() then 
        if isElement(leaveMarker) and isElementWithinMarker(localPlayer, leaveMarker) then 
           -- outputChatBox("exit")
            local outMarker = getElementData(leaveMarker, "oilMarker.outMarkerElementData")
            local data = getElementData(outMarker, "oilMarker.datas")
            if data.locked == 1 then outputChatBox(hex .."[OriginalRoleplay - OilStation]#FFFFFF Ez az olaj telep zárva van.", 255, 255, 255, true) return end
            for i, v in pairs(elements) do
                if isElement(v) then
                    destroyElement(v)
                end
            end
            elements = {}
            triggerServerEvent("teleportOut", localPlayer, localPlayer, leaveId)
            leaveId = -1
        elseif oilMarker then
            local id = getElementData(oilMarker, "oilMarker.dbId")
            local data = getElementData(oilMarker, "oilMarker.datas")
            --outputChatBox(getElementType(getOilStationById(id)))
            if data.locked == 1 then outputChatBox(hex .."[OriginalRoleplay - OilStation]#FFFFFF Ez az olaj telep zárva van.", 255, 255, 255, true) return end
            triggerServerEvent("teleportToOilStation", localPlayer, localPlayer, id)
           -- outputChatBox("enter")
        end
    elseif key == "k" and press and not isChatBoxInputActive() then 
        if isElement(leaveMarker) and isElementWithinMarker(localPlayer, leaveMarker) then
            local outMarker = getElementData(leaveMarker, "oilMarker.outMarkerElementData")
            local data = getElementData(outMarker, "oilMarker.datas")
            if data.locked == 1 then 
                outputChatBox(hex .."[OriginalRoleplay - OilStation]#FFFFFF Sikeresen kinyitottad az olaj telepet.", 255, 255, 255, true)
                data.locked = 0
            else
                outputChatBox(hex .."[OriginalRoleplay - OilStation]#FFFFFF Sikeresen bezártad az olaj telepet.", 255, 255, 255, true)
                data.locked = 1
            end
            setElementData(outMarker, "oilMarker.datas", data)
        elseif oilMarker then
            local data = getElementData(oilMarker, "oilMarker.datas")
            --outputChatBox(getElementData(localPlayer, "char:id"))
            if data.owner == getElementData(localPlayer, "char:id") then 
                if data.locked == 1 then 
                    outputChatBox(hex .."[OriginalRoleplay - OilStation]#FFFFFF Sikeresen kinyitottad az olaj telepet.", 255, 255, 255, true)
                    data.locked = 0
                else
                    outputChatBox(hex .."[OriginalRoleplay - OilStation]#FFFFFF Sikeresen bezártad az olaj telepet.", 255, 255, 255, true)
                    data.locked = 1
                end
            else 
                outputChatBox(hex .."[OriginalRoleplay - OilStation]#FFFFFF Ehhez a telephez nincs kulcsod!", 255, 255, 255, true)
            end
            setElementData(oilMarker, "oilMarker.datas", data)
        end
    end
end)

addCommandHandler("rentoilstation",function()
    if oilMarker then
        local data = getElementData(oilMarker, "oilMarker.datas") 
        if data.owner == 0 then 
            if getElementData(localPlayer, "char:money") >= 50000 then 
                
                data.owner = getElementData(localPlayer, "char:id")
                setElementData(oilMarker, "oilMarker.datas", data)
               setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money") - 50000)
                triggerServerEvent("changeOilStationOwner", localPlayer, localPlayer, data.id, oilMarker)
            else
                outputChatBox(hex .."[OriginalRoleplay - OilStation]#FFFFFF Nincs elegendő pénzed!", 255, 255, 255, true)
            end
        elseif data.owner == getElementData(localPlayer, "char:id") then
            outputChatBox("újra bérlés")
        else 
            outputChatBox(hex .."[OriginalRoleplay - OilStation]#FFFFFF Ez az olaj telep nem kiadó!", 255, 255, 255, true) 
        end
    else
        outputChatBox(hex .."[OriginalRoleplay - OilStation]#FFFFFF Túl messze vagy a bejárattól!", 255, 255, 255, true)
    end
end)

addEvent("createRepairMarker",true)
addEventHandler("createRepairMarker",getRootElement(),function(stationID)
    local stationData = getElementData(getOilStationById(stationID), "oilMarker.datas")
    local wrongMachine = stationData.wrongMachineId
    outputChatBox(hex .."[OriginalRoleplay - OilStation]#FFFFFF Figyelem meghibásodott a "..wrongMachine..". számú pumpa kérlek javítsd meg!", 255, 255, 255, true)
    --outputChatBox(oilStation.oilPump[wrongMachine][2])
    if isElement(repairMarker) then destroyElement(repairMarker) end
    repairMarker = createMarker(oilStation.oilPump[wrongMachine][2],oilStation.oilPump[wrongMachine][3]+5,oilStation.oilPump[wrongMachine][4])
    setElementDimension(repairMarker, stationID)
    setElementData(repairMarker, "oilMarker.isRepairMarker",true)
    setElementData(repairMarker, "oilMarker.repairMarkerStationID",stationID)
    setElementData(repairMarker, "oilMarker.repairMarkerWrongMachine",wrongMachine)
    --outputChatBox(wrongMachine .. " Client")
end)

addEventHandler("onClientMarkerHit",getRootElement(),function(hitPlayer, matchD)
    if hitPlayer == localPlayer and getElementData(source, "oilMarker.isRepairMarker") then 
        outputChatBox(exports["oCore"]:getServerPrefix() .. "Elkezdted megjavítani a gépet..", 255, 255, 255, true) 
        setTimer(function(marker)
            local reapirMarkerStationID = getElementData(marker, "oilMarker.repairMarkerStationID")
            local wrongMachineID = getElementData(marker, "oilMarker.repairMarkerWrongMachine")
            triggerServerEvent("reapirPumpToServer",localPlayer, localPlayer, reapirMarkerStationID, wrongMachineID)
            outputChatBox("Megjavítva" .. reapirMarkerStationID)
            destroyElement(repairMarker)
        end,5000,1, source)
    end
end)


--theMark

--[[
    theMak változások:
    Olajt lehet leszállítani,
    Panel majdnem teljesen kész
    Ha bele nyulnál fontos ezeket tudnod:
    !!!!!!!!!!-----------------!!!!!!!!!!
    A FOR CIKLUS VISSZAFELÉ SZÁMOL
    TEHÁT HA!!!!!!!!!!!
    I == 1 
    AKKOR A GOMBOK KÖZÜL AZ A ___4.!!!____
]]
local resultData = {}
local testOil = 50
local oilPanelShowed = false

local scx, scy = guiGetScreenSize ()
local myObject,myElement, guiWindow = nil, nil, nil
local myRotation = {0,0,0}


local zoom = math.min(1,0.75 + (sx - 1024) * (1 - 0.75) / (1600 - 1024))
function res(value) return value * zoom end

local panel = 4
 
local icons = ""
local panel = 4
local alpha = 180   
 
local hex, r, g, b = exports.oCore:getServerColor()
local panelSize = res(Vector2(900, 493))
local panelPos = res(Vector2(sx / 2 - panelSize.x / 2, sy / 2 - panelSize.y / 2))
 
local header = "Original" .. hex .. "Roleplay"
 
local fonts = {
    condensed = {
        [12] = exports.oFont:getFont("condensed", 12),
        [15] = exports.oFont:getFont("condensed", 15),
        [18] = exports.oFont:getFont("condensed", 18),
        [9] = exports.oFont:getFont("condensed", 9)
    }
}

addEvent("accept.OilDatas", true)
addEventHandler("accept.OilDatas", root, function(data, res)
    if data then
        clientData = data
        -- outputChatBox(inspect(clientData) .. "HA EZ SIKERÜLT TÖRTÉNELMET IRTAM!")
        -- outputChatBox("Átmentek az adatok" .. res)
        local id = res
        for k2, v2 in pairs(clientData) do
            if k2 == clientData[id].id then
                resultData = id
                -- if (id == clientData[id].dbId) then

                -- end
                if (clientData[id].id == res) then
                    -- outputChatBox(inspect(res) .. "<fasz")
                end
            end
        end
    end
end)

local oilLimit = 10000
local timerProg = 800

--[[addEventHandler("onClientRender", root, function()
    if localPlayer:getData("oilProginClient") > oilLimit then
        localPlayer:setData("oilProginClient", localPlayer:getData("oilProginClient"))
    end
end)]]
local well
local haveOilWell = 100

--[[function runOil()
    if not localPlayer then return end
    local oilClientData = localPlayer:getData("oilProginClient")
    if localPlayer.name == "Marco_Wright" or "theMark" then
        Timer(function()
            if tonumber(localPlayer:getData("oilProginClient")) < oilLimit then
                localPlayer:setData("oilProginClient", localPlayer:getData("oilProginClient") + haveOilWell)
                triggerServerEvent("updateOilInServer", localPlayer, localPlayer, oilClientData)
            end
        end, 50, 0)
    else
        Timer(function()
            if tonumber(localPlayer:getData("oilProginClient")) < oilLimit then
                localPlayer:setData("oilProginClient", localPlayer:getData("oilProginClient") + haveOilWell)
                triggerServerEvent("updateOilInServer", localPlayer, localPlayer, oilClientData)
            end
        end, 1800000, 0)
        -- end, 10000, 0)
    end
end]]


function renderOilPanel()
    if not localPlayer:getData("user:loggedin") then return end
    -- if localPlayer.name ~= "theMark" then return end
    dxDrawRectangle(panelPos, panelSize, tocolor(0, 0, 0, 200))
    dxDrawRectangle(panelPos, panelSize.x, 70, tocolor(0, 0, 0, 240))
    drawText(header, panelPos + res(Vector2(55, 15)), res(Vector2(panelSize.x, 70)), tocolor(255, 255, 255), 1, fonts.condensed[15], "left", "top", false, false, false, true)
    drawText("OilBusiness", panelPos + res(Vector2(55, 15)), res(Vector2(panelSize.x, 70)), tocolor(255, 255, 255), 1, fonts.condensed[15], "left", "center", false, false, false, true)
    dxDrawImage(panelPos + res(Vector2(10, 20)), res(40), res(35), "assets/logo.png")
 
    for i = 1, 4 do
        icons = string.format("assets/%d.png", i)
        dxDrawImage(panelPos + Vector2(panelSize.x - 10 - i * 45, 70 / 2 - 20), 40, 40, icons)
    end
    if panel == 4 then
        local stationData = getElementData(getOilStationByOwner(getElementData(localPlayer, "char:id")), "oilMarker.datas")
        -- dxDrawImage(panelPos + res(Vector2(panelSize.x / 2 - 119, panelSize.y / 2 - 147)), res(Vector2(238, 294)),  "assets/bgOil.png")
        dxDrawRectangle(panelPos + res(Vector2(panelSize.x - 300, panelSize.y - 162)), res(Vector2(156, 5)))

        -- dxDrawImage(500, 500, 500, 100, "assets/line.png")

        if stationData then
            drawText("Jelenleg termelt olaj:" .. hex .. stationData.oilProgress .. "#FFFFFF" .. " Liter", panelPos + res(Vector2(panelSize.x / 2 - 300, panelSize.y - 170)), Vector2(156, 5), tocolor(255, 255, 255), 1, fonts.condensed[9], "center", "center", false, false, false, true)
            drawText("Meghibásodott gépek: " .. hex .. stationData.errorMachine, panelPos + res(Vector2(panelSize.x - 300, panelSize.y - 170)), Vector2(156, 5), tocolor(255, 255, 255), 1, fonts.condensed[9], "center", "center", false, false, false, true)
        end
        dxDrawRectangle(panelPos + res(Vector2(panelSize.x / 2 - 300, panelSize.y - 162)), res(Vector2(156, 5)))
    elseif panel == 3 then
        local stationData = getElementData(getOilStationByOwner(getElementData(localPlayer, "char:id")), "oilMarker.datas")
        -- local inSlot = isInSlot(panelPos + Vector2(90, panelSize.y - 200), Vector2(109, 156))
        local inSlot = isInSlot(panelPos + Vector2(70, panelSize.y - 135), Vector2(145, 30))
        alpha = inSlot and 255 or 180
 
        dxDrawImage(panelPos + Vector2(90, panelSize.y / 2 - 78), Vector2(109, 156), "assets/barrel.png")
        dxDrawImage(panelPos + Vector2(430, panelSize.y / 2 - 170), Vector2(156, 156), "assets/bgOil.png")
        drawText("OLAJ TERMELÉS 5LITER / ÓRA", panelPos + Vector2(600, panelSize.y / 2 - 200), Vector2(156, 156), tocolor(255, 255, 255, 255), 1, fonts.condensed[12], "center", "center")
        if isInSlot(panelPos + Vector2(600, panelSize.y / 2 - 95), Vector2(156, 30)) then
            drawText(hex .. "MEGVÁSÁRLÁS", panelPos + Vector2(600, panelSize.y / 2 - 220), Vector2(156, 156), tocolor(200, 200, 200, 255), 1, fonts.condensed[18], "center", "bottom", false, false, false, true)
        else
            drawText("MEGVÁSÁRLÁS", panelPos + Vector2(600, panelSize.y / 2 - 220), Vector2(156, 156), tocolor(200, 200, 200, 255), 1, fonts.condensed[18], "center", "bottom")
        end

        dxDrawImage(panelPos + Vector2(430, panelSize.y - 210), Vector2(156, 156), "assets/bgOil.png")
        -- dxDrawRectangle(panelPos + Vector2(620, panelSize.y - 100), Vector2(156, 30))
        drawText("OLAJ TERMELÉS 50 LITER / ÓRA", panelPos + Vector2(620, panelSize.y - 210), Vector2(156, 156), tocolor(255, 255, 255, 255), 1, fonts.condensed[12], "center", "center")
        if isInSlot(panelPos + Vector2(620, panelSize.y - 100), Vector2(156, 30)) then
            drawText(hex .. "MEGVÁSÁRLÁS", panelPos + Vector2(620, panelSize.y - 225), Vector2(156, 156), tocolor(200, 200, 200, 255), 1, fonts.condensed[18], "center", "bottom", false, false, false, true)
        else
            drawText("MEGVÁSÁRLÁS", panelPos + Vector2(620, panelSize.y - 225), Vector2(156, 156), tocolor(200, 200, 200, 255), 1, fonts.condensed[18], "center", "bottom")
        end


        -- dxDrawRectangle(panelPos + Vector2(70, panelSize.y - 135), Vector2(145, 30))
        -- outputChatBox(inspect(stationData))
        if (stationData.oilProgress >= oilLimit) then
            drawText("#AD1414" .. stationData.oilProgress .. "#FFFFFF" .. " Liter olajad van", panelPos + Vector2(90, panelSize.y - 230), Vector2(109, 156), tocolor(255, 255, 255), 1, fonts.condensed[12], "center", "center", false, false, false, true)
        else
            drawText(hex .. stationData.oilProgress .. "#FFFFFF" .. " Liter olajad van", panelPos + Vector2(90, panelSize.y - 230), Vector2(109, 156), tocolor(255, 255, 255), 1, fonts.condensed[12], "center", "center", false, false, false, true)
        end
        drawText("OLAJ KIVÉTELE", panelPos + Vector2(90, panelSize.y - 200), Vector2(109, 156), tocolor(140, 140, 140, alpha), 1, fonts.condensed[15], "center", "center")
    elseif panel == 2 then
        drawText("Hamarosan...", panelPos, panelSize, tocolor(255, 255, 255), 1, fonts.condensed[18], "center", "center")
    end
end
-- addEventHandler("onClientRender", root, renderOilPanel)



function removePanel()
    -- exports.oPreview:destroyObjectPreview(myObject)
    destroy3D()
    removeEventHandler("onClientRender", root, renderOilPanel)
    oilPanelShowed = false
end


addEventHandler("onClientClick", root, function(button, state)
    local hex, r, g, b = exports["oCore"]:getServerColor()
    local panelSize = Vector2(900, 493)
    local panelPos = Vector2(sx / 2 - panelSize.x / 2, sy / 2 - panelSize.y / 2)
    if button == "left" and state == "down" then
        if (panel ~= 3) then return end
        if isInSlot(panelPos + Vector2(600, panelSize.y / 2 - 95), Vector2(156, 30)) then
            if localPlayer:getData("char:money") >= 30000 then
                triggerServerEvent("updatePumps", localPlayer, localPlayer, 1, 1, 30000)
                -- local privObj = Object(1337, randomPos.pos.x,  randomPos.pos.y, randomPos.pos.z) -- itt jártam
                -- privObj:setData("#oil#obj#", true)
                -- setObjectScale(obj, 20)
            else
                outputChatBox(exports["oCore"]:getServerPrefix() .. "Nincs elég pénzed a vásárláshoz!(30000$)", 255, 255, 255, true)
            end
        elseif isInSlot(panelPos + Vector2(620, panelSize.y - 100), Vector2(156, 30)) then
            outputChatBox(exports["oCore"]:getServerPrefix() .. "Jelenleg ez nem elérhető!", 255, 255, 255, true)
            --[[if localPlayer:getData("char:money") >= 200000 then
                triggerServerEvent("updatePumps", localPlayer, localPlayer, 1, 1, 200000)
            else
                outputChatBox(exports["oCore"]:getServerPrefix() .. "Nincs elég pénzed a vásárláshoz!(200000$)", 255, 255, 255, true)
            end]]
        end
    end
end)

addCommandHandler("0908080808080808080808080808080880800881081701870187017801807187", function(cmd, halo)
    if halo then
        triggerServerEvent("updatePumps", localPlayer, localPlayer, halo, 0, 0)
    end
end)

--{Olaj Kivásárlás Click része}--
addEventHandler("onClientClick", root, function(button, state)
    local hex, r, g, b = exports["oCore"]:getServerColor()
    local panelSize = Vector2(900, 493)
    local panelPos = Vector2(sx / 2 - panelSize.x / 2, sy / 2 - panelSize.y / 2)
    if button == "left" and state == "down" then
        if oilPanelShowed then
            if (panel ~= 3) then return end
            if isInSlot(panelPos + Vector2(70, panelSize.y - 135), Vector2(145, 30)) then
                removePanel()
                local stationData = getElementData(getOilStationByOwner(getElementData(localPlayer, "char:id")), "oilMarker.datas")
                if (stationData.oilProgress > 1000) then
                    triggerServerEvent("create.oilVehicle", localPlayer, localPlayer,stationData.oilProgress)
                    startOilJob()
                else
                    outputChatBox(exports["oCore"]:getServerPrefix() .. "Nincs elég olajad ahhoz hogy le tudd adni![ Minimum 1000liter olaj ]", 255, 255, 255, true)
                end
            end
        end
    end
end)
--{Olaj Kivásárlás Click része Befejezve}--


addEventHandler("onClientMarkerHit", getRootElement(), function(hitElement, dim)
    if hitElement == localPlayer and dim then
        if source:getData("oil # Down") then
            local playerVeh = localPlayer.vehicle
            local cPID = localPlayer:getData("char:id")
            local stationData = getElementData(getOilStationByOwner(getElementData(localPlayer, "char:id")), "oilMarker.datas")
            if (playerVeh:getData("veh:id") == cPID) then
                triggerServerEvent("destroyVehGiveMoney", localPlayer, localPlayer, getElementData(getPedOccupiedVehicle(localPlayer), "veh:oilCount"))
                stopOilJob()
            else
                outputChatBox(exports["oCore"]:getServerPrefix() .. "Ez nem az olaj leszállító autó!", 255, 255, 255, true)
            end
        end
    end
end)



addEventHandler("onClientClick", root, function(button, state)
    local panelSize = Vector2(900, 493)
    local panelPos = Vector2(sx / 2 - panelSize.x / 2, sy / 2 - panelSize.y / 2)
    if button == "left" and state == "down" then
        if oilPanelShowed then
            for i=1, 4 do
                if isInSlot(panelPos + Vector2(panelSize.x - 10 - i * 45, 70 / 2 - 20), Vector2(40, 40)) then
                    panel = i
                    if (panel == 4) then
                        create3D()
                        -- destroy3D()
                    end
                    --{Mivel visszafele számol a for ezért a 4. ikon [gomb] az a for ciklusban 1-es ezért ha 4-es[1-es FORBAN] Akkor zárja be a panelt!}--
                    if i == 1 then
                        destroy3D()
                        removeEventHandler("onClientRender", root, renderOilPanel)
                        oilPanelShowed = false
                        break
                    end
                    break
                end
            end
        end
    end
end)

function isInSlot(position, size) 
    if isCursorShowing() then 
        cPosX, cPosY = getCursorPosition()
        cPosX, cPosY = cPosX * sx, cPosY * sy
        if ( (cPosX > position.x) and (cPosY > position.y) and (cPosX < position.x + size.x) and (cPosY < position.y + size.y) ) then 
            return true 
        else
            return false
        end
    end
end

--[[function getMousePosition()
    if isCursorShowing() then
        local cX, cY = getCursorPosition()
        return sx * cX, sy * cY
    end
    return false
end

function checkNumbers(numbers)
    if type(numbers) == "table" then
        for k, v in pairs(numbers) do
            if not tonumber(v) then
                return false
            end
        end
        return true
    end
    return false
end

function isInSlot(position, size)
    if isCursorShowing() then
        local cX, cY = getMousePosition()
        if checkNumbers({position.x, position.y, size.x, size.y, cX, cY}) then
            if cX >= position.x and cY >= position.y and cX <= position.x+size.x and cY <= position.y+size.y then
                return true
            end
        end
    end
    return false
end]]

function isInBox(dX, dY, dW, dH, eX, eY)
    if checkNumbers({dX, dY, dW, dH, eX, eY}) then
        if eX >= dX and eY >= dY and eX <= dX+dW and eY <= dY+dH then
            return true
        end
    end
    return false
end



function drawText(text, position, size, ...)
    -- if x and y then
        -- if w and h then
            return dxDrawText(text, position.x, position.y, (position.x + size.x), (position.y + size.y), ...)
        -- end
    -- end
    -- return false
end

addEventHandler("onClientClick", root, function(button, state, x, y, wx, wy, wz, element)
    if button == "right" and state == "down" then
        if element and element:getData("oil > computer") then
            local distance = getDistanceBetweenPoints3D(localPlayer.position, test.position)
            if distance > 3 then return end
            -- outputChatBox("awdsad")
            
            -- local stationData = getElementData(getOilStationByOwner(getElementData(localPlayer, "char:id")), "oilMarker.datas")
            -- setElementData(getOilStationByOwner(getElementData(localPlayer, "char:id")), "oilMarker.datas")
            --{3D OBJECT}--
            create3D()
            -- destroy3D()
            --{3D OBJECT VÉGE!}--
            removeEventHandler("onClientRender", root, renderOilPanel)
            addEventHandler("onClientRender", root, renderOilPanel)
            oilPanelShowed = true
        end
    end
end)

--[[addEvent("accept.OilDatas", true)
addEventHandler("accept.OilDatas", root, function(data, dbId)
    if not data then return end
    clientData = data
    -- outputChatBox(inspect(clientData) .. "<" .. "kliens oldal")
    for k, v in pairs(clientData) do
        -- print(inspect(v))
        -- outputChatBox("k" .. "-->" .. inspect(clientData[1]))
        for k, v in pairs(clientData) do
            -- print(inspect(v))
            -- outputChatBox("k" .. "-->" .. inspect(clientData))
            local pName = tostring(localPlayer.name)
            if clientData[1].name == pName then
                -- outputChatBox("FÉLSIKER")
                oilDat, oilDat2 = clientData.name, pName
                -- outputChatBox(oilDat .. " " .. oilDat2 .. " " .. "fasz")
            end
            -- outputChatBox(inspect(clientData[1].name))
            -- break
        end
        -- outputChatBox(inspect(clientData[1].name))
        outputChatBox(inspect(data.prog .. "ez a prog"))
        outputChatBox(dbId)
        break
    end
end)]]
function startOilJob()
    oilDownMarker = Marker(2557.3471679688, 2790.6130371094, 10.8203125, "checkpoint", 3.5)
    createBlipAttachedTo(oilDownMarker, 1)
    oilDownMarker:setData("oil # Down", true)
    local stationData = getElementData(getOilStationByOwner(getElementData(localPlayer, "char:id")), "oilMarker.datas")
    setElementData(getOilStationByOwner(getElementData(localPlayer, "char:id")), "oilMarker.datas", {
        errorMachine = stationData.errorMachine,
        id = stationData.id,
        locked = stationData.locked,
        name = stationData.name,
        oilProgress = 0,
        oilPump = stationData.oilPump,
        owner = stationData.owner,
        position = stationData.position,
        rentOilStation = stationData.rentOilStation,
        wrongMachineId = stationData.wrongMachineId
    })
    triggerServerEvent("updatePumps", localPlayer, localPlayer, 0)
end

function stopOilJob()
    -- for k, v in ipairs(Element.getAllByType("marker")) do
        oilDownMarker:destroy()
    -- end
end

--TESZT
--[[addEventHandler("onClientResourceStart", getResourceRootElement( getThisResource()), function()
	--local x1, y1, z1 = getCameraMatrix()
	myElement = Object(1227, x1, y1, z1)

	myObject = exports.oPreview:createObjectPreview(myElement,0, 0, 0, 0.5, 0.5, 1, 1, true, true, true)
	local projPosX, projPosY = (scx/2)-100,(scy/2) - 100
    local projSizeX, projSizeY = 200, 200
	exports.oPreview:setProjection(myObject, projPosX, projPosY, projSizeX, projSizeY, true, true)
end)]]

-- local myObject, myElement, guiWindow = nil, nil, nil

--[[addEventHandler("onClientResourceStart", getResourceRootElement( getThisResource()), function()
    if oilPanelShowed then
        if localPlayer.name ~= "theMark" then return end
        myElement = Object(3426, 0, 0, 0)
        myObject = exports.oPreview:createObjectPreview(myElement,0, 0, 0, 0.5, 0.5, 1, 1, true, true, true)
        guiWindow = GuiWindow((sx / 2 ) - 400, (sy / 2) - 400, 800, 800, " ", false, false)
        local projPosX, projPosY = guiWindow:getPosition(true)
        local projSizeX, projSizeY = guiWindow:getSize(true)
        guiWindow.visible = false
        exports.oPreview:setProjection(myObject, projPosX, projPosY, projSizeX, projSizeY, true, true)
        exports.oPreview:setRotation(myObject, 90, 0, 0)
    end
end)]]
-- exports.oPreview:destroyObjectPreview(myObject)

function table_find(tbl, value)
    if tbl and value then
        for key, tables in pairs(tbl) do
            if (tables.value or tables[value]) then
                return true
            else
                return false
            end
        end
    end
end


function getFreePositionsWhereID(tbl, ID)
    if tbl then
        table_find(tbl, 5)
    end
end