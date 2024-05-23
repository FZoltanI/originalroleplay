function sendMessageToAdmins(player, msg)
    triggerClientEvent(getRootElement(), "sendMessageToAdmins", getRootElement(), player, msg)
end

addEvent("startAnim->OnServer", true)
addEventHandler("startAnim->OnServer", resourceRoot, function()
    animStart(client)
end)

addEvent("startDeath > onServer", true)
addEventHandler("startDeath > onServer", resourceRoot, function(player, damageText)
    setElementData(player, "playerInDead", true)
    setElementData(player, "cleaner:inJobInt", false)
    setElementData(player, "playerInClientsideJobInterior", false)
    setElementData(player, "pizza:isPlayerInInt", false)
    --print(getElementData(player, "customDeath"))
    
    if getPedOccupiedVehicle(player) then 
        removePedFromVehicle(player)
    end
end)

--[[addEvent("death > sync > blood", true)
addEventHandler("death > sync > blood", resourceRoot, function(blood)
    outputChatBox("server: "..getElementData(client, "char:blood"))
    setElementData(client, "char:blood", blood)
end)]]

local rleg = {}
local lleg = {}


function savePlayerLife(player, cmd, target)
    if getElementData(player, "user:admin") > 1 then 
        if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

        if target then 

            if target == "*" then 
                target = player
            else
                target = tonumber(target)
                target = core:getPlayerFromPartialName(player, target)
            end

            if target then 
                if getElementData(target, "playerInAnim") then 
                    animEnd(target)
                    setElementHealth(target, 100)
                    setElementData(target, "char:health", 100)
                    setElementData(target, "char:hunger", 100)
                    setElementData(target, "char:thirst", 100)
                    setElementData(target, "char:sick", 0)

                    local bones = toJSON( {["head"] = 0, ["body"] = 0, ["l_leg"] = 0, ["r_leg"] = 0, ["r_arm"] = 0, ["l_arm"] = 0} )
                    setElementData(target, "char:bones", bones)

                    sendMessageToAdmins(player, "felsegítette #db3535"..getPlayerName(target):gsub("_", " ").. "#557ec9 nevű játékost.")
                    outputChatBox(core:getServerPrefix("server", "original", 1) .. color .. getPlayerName(player):gsub("_", " ") .. " #fffffffelsegített téged!", target, 255, 255, 255, true)
                    return
                elseif getElementData(target, "playerInDead") then 
                    local targetPos = Vector3(getElementPosition(target))
                    spawnPlayer(target, targetPos.x, targetPos.y, targetPos.z, 0, getElementModel(target), getElementInterior(target), getElementDimension(target))
                    setElementData(target, "playerInDead", false)
                    setElementData(target, "customDeath", false)

                    setElementHealth(target, 100)
                    setElementData(target, "char:health", 100)
                    setElementData(target, "char:hunger", 100)
                    setElementData(target, "char:thirst", 100)
                    setElementData(target, "char:sick", 0)

                    triggerClientEvent(target, "endDeath", target, "admin")

                    local bones = toJSON( {["head"] = 0, ["body"] = 0, ["l_leg"] = 0, ["r_leg"] = 0, ["r_arm"] = 0, ["l_arm"] = 0} )
                    setElementData(target, "char:bones", bones)
                    
                    setElementData(target, "usedBlood", false)

                    sendMessageToAdmins(player, "felélesztette #db3535"..getPlayerName(target):gsub("_", " ").. "#557ec9 nevű játékost.")
                    outputChatBox(core:getServerPrefix("server", "original", 1) .. color .. getPlayerName(player):gsub("_", " ") .. " #fffffffelélesztett téged!", target, 255, 255, 255, true)
                    return
                end
            else
                outputChatBox(core:getServerPrefix("red-dark", "Hiba", 3).."Hiba, jelentsd egy fejlesztőnek!", player, 255, 255, 255, true)
            end

            outputChatBox(core:getServerPrefix("red-dark", "Felsegítés", 3) .. "A játékos nincs megsérülve és nem is halott. ", player, 255, 255, 255, true)
        else
            outputChatBox(core:getServerPrefix("red-dark", "Használat", 3) .. "/"..cmd.. " [Target]", player, 255, 255, 255, true)
        end
    end
end
addCommandHandler("ahelp", savePlayerLife)
addCommandHandler("asegit", savePlayerLife)

function animStart(player)
    setElementData(player, "char:blood", 0)

    setElementData(player, "playerInAnim", true)
    setElementData(player, "char:blood", 100)
    setElementFrozen(player, true)

    setElementData(player, "usedBlood", false)

    if not getPedOccupiedVehicle(player) then 
        setPedAnimation(player, "sweet", "sweet_injuredloop", _, false, false, true, 100) 
    end

    for k, v in ipairs(disable_needed_controlls) do 
        toggleControl(player,v,false)
    end

    local x, y, z = getElementPosition(player)
    local date = core:getDate("year") .. "." .. core:getDate("month").. "." .. core:getDate("monthday") .. "." .. core:getDate("hour") .. ":" .. core:getDate("minute") .. ":" .. core:getDate("second")

    for k, v in ipairs(getElementsByType("player")) do 
        if (getElementData(v, "user:admin") or 0) >= 2 then 
            outputChatBox("#2379cf["..date.."]: #e97619"..getPlayerName(player):gsub("_", " ").."#FFFFFF ["..getElementData(player, "playerid").."] animba esett.", v, 255, 255, 255, true)
        end
    end
end

function animEnd(player) 
    --outputChatBox("endAnim->OnServer : "..getPlayerName(player))
    setElementHealth(player, 30)
    setElementData(player, "char:health", 30)
    setElementFrozen(player, false)
    setPedAnimation(player)

    setElementData(player, "playerInAnim", false)

    setElementData(player, "usedBlood", false)

    for k, v in ipairs(disable_needed_controlls) do 
        toggleControl(player,v,true)
    end

    triggerClientEvent(player, "endAnim->onClient", resourceRoot)
end

addEvent("animEnd->onServer", true)
addEventHandler("animEnd->onServer", resourceRoot, function() 
    animEnd(client)
end)

addEvent("respawnPlayer", true)
addEventHandler("respawnPlayer", getRootElement(), function()
    spawnPlayer(client, 1157.4061279297,-1333.8961181641,15.4140625, 270, getElementModel(client))
    setElementData(client, "playerInDead", false)
    setElementData(client, "customDeath", false)
    setElementData(client, "usedBlood", false)
    local bones = toJSON( {["head"] = 0, ["body"] = 0, ["l_leg"] = 0, ["r_leg"] = 0, ["r_arm"] = 0, ["l_arm"] = 0} )
    setElementData(client, "char:bones", bones)
end)