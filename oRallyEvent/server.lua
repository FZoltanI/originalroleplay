local core = exports.oCore
local color, r, g, b = core:getServerColor()
local font = exports.oFont 
local infobox = exports.oInfobox
local admin = exports.oAdmin
local winnerlap = 0 --5

local playerLaps = {}
local serverSideRacers = {}
local playerF1Timer = {}
local endWithRace = {}
    
addEventHandler("onResourceStart",resourceRoot,function()
    raceCol = createColSphere(2001.5924072266,110.23322296143,29.746223449707,10,10,10)
    setElementData(raceCol,"isF1Col",true)

    endCol = createColSphere(324.43002319336,-352.55545043945,8.8875303268433,5,10,10)
    setElementData(endCol,"isF1Col",true)
    setElementData(endCol,"isEndCol",true)
end)

addEventHandler("onColShapeHit",root,function(player,md)
    if md then 
        if getElementData(source,"isF1Col") then 
            if getElementType(player) == "player" then 

                if getPedOccupiedVehicle(player) and getElementModel(getPedOccupiedVehicle(player)) == 558 then 
                    if not serverSideRacers[player] then 

                        if #serverSideRacers <= 1 then 
                            serverSideRacers[player] = {true,player} 
                            triggerClientEvent(root,"syncRacer",root,utf8.gsub(getPlayerName(player),"_"," "),getElementData(player,"F1CurrentTime"))
                            playerF1Timer[player] = setTimer(function()
                                setElementData(player,"F1CurrentTime",getElementData(player,"F1CurrentTime") + 1)
                                triggerClientEvent(root,"syncTime",root,utf8.gsub(getPlayerName(player),"_"," "),getElementData(player,"F1CurrentTime"))
                            end,1000,0)
                            playerLaps[player] = 0 

                        end

                    else 
                        if playerLaps[player] <= (winnerlap-1) then 
                            if playerLaps[player] then 
                                playerLaps[player] = playerLaps[player] + 1
                            end 
                            setElementData(player,"playerLap",playerLaps[player])
                        else 
                            if getElementData(source,"isEndCol") then 
                                local inTable = findInTable(endWithRace,utf8.gsub(getPlayerName(player),"_"," ")) or false

                                if not inTable then 

                                    local countRacers = countTable(serverSideRacers)

                                    records = {utf8.gsub(getPlayerName(player),"_"," "),true,getElementData(player,"F1CurrentTime")}
                                    table.insert(endWithRace,records)

                                    setVehicleEngineState(getPedOccupiedVehicle(player),false)
                                    setTimer(function()
                                        removePedFromVehicle(player)
                                        setElementPosition(player,2019.5612792969,84.727149963379,30.018466949463) 
                                        outputChatBox(core:getServerPrefix("red-dark", "Rally Event", 3).."Sikeresen teljesítetted az eventet, várj a további utasításokig itt!", player, 255, 255, 255, true)
                                        triggerClientEvent(root,"insertPlayerToTable",root,utf8.gsub(getPlayerName(player),"_"," "),getElementData(player,"F1CurrentTime"))
                                    end,5000,1)

                                    if isTimer(playerF1Timer[player]) then killTimer(playerF1Timer[player]) end

                                    if #endWithRace == countRacers then 
                                        triggerClientEvent(root,"showWinner",root,tostring(endWithRace[1][1]),tostring(endWithRace[1][3]))
                                    end 
                                end
                            end 
                        end 
                    end 
                end 

            end 
        end 
    end 
end)

function countTable(table)
    local num = 0
    for k,v in pairs(table) do 
        num = num + 1
    end 

    return num 
end 

function findInTable(table,who)
    for k,v in pairs(table) do 
        if table[k][1] == who then 
            return true 
        end 
    end 
end

function makeCountdown(thePlayer,cmd)

    local aLevel = getElementData(thePlayer,"user:admin")

    if aLevel >= 7 then 
        admin:sendMessageToAdmins(thePlayer, "létrehozott egy visszaszámlálást az F1 Eventhez!")
        outputChatBox(core:getServerPrefix("red-dark", "Rally Event", 3)..color..getElementData(thePlayer, "user:adminnick").." #ffffffSikeresen elindítottad a visszaszámlálást!", thePlayer, 255, 255, 255, true)
        triggerClientEvent(root,"startCountdown",root)
        for k,v in pairs(serverSideRacers) do 
            if isTimer(playerF1Timer[v[2]]) then killTimer(playerF1Timer[v[2]]) end
        end 
        serverSideRacers = {}
        playerLaps = {}
        endWithRace = {}
    end 

end 
addCommandHandler("makecountdown",makeCountdown)

function countF1Vehicles()
    local num = 0
    for k,v in pairs(getElementsByType("vehicle")) do 
        num = num + 1
    end 

    return num
end 

function resetcars(thePlayer,cmd)
    
    local aLevel = getElementData(thePlayer,"user:admin")

    if aLevel >= 7 then 
        currentVehs = countF1Vehicles()

        if currentVehs > 0 then 
            for k,v in pairs(getElementsByType("vehicle")) do 
                if getElementData(v,"isF1Vehicle") then 
                    triggerClientEvent(root,"delSound",root,v)
                    destroyElement(v)
                end 
            end 
        end 

        for k,v in pairs(defcarpos) do 
            f1cars = exports.oVehicle:createTemporaryVehicle(v[1], {v[2],v[3],v[4] + 0.5,0,0,v[5]}, thePlayer, "F1EVENT", false) --createVehicle(v[1],v[2],v[3],v[4],0,0,v[5])
            setVehicleColor(f1cars,255,255,255)
            setElementData(f1cars,"isF1Vehicle",true)
            exports.oVehicle:setVehEngine(f1cars)
            setElementFrozen(f1cars,true)
        end 
    end 
end 
addCommandHandler("resetcars",resetcars)

function deleventcars(thePlayer,cmd)
    local aLevel = getElementData(thePlayer,"user:admin")

    if aLevel >= 7 then
        for k,v in pairs(getElementsByType("vehicle")) do 
            if getElementData(v,"isF1Vehicle") then 
                triggerClientEvent(root,"delSound",root,v)
                destroyElement(v)
            end 
        end 
    end 
end 
addCommandHandler("deleventcars",deleventcars)

function unfreezF1Vehs()
    for k,v in pairs(getElementsByType("vehicle")) do 
        if getElementData(v,"isF1Vehicle") then 
            setElementFrozen(v,false)
        end 
    end 
end 
addEvent("unfreezeveh",true)
addEventHandler("unfreezeveh",root,unfreezF1Vehs)
