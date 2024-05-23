local db = exports.cl_mysql:getDBConnection()

local prefix = "[Jármű]: #ffffff"
local errprefix = "#ff0000[Jármű]: #ffffff"
local usgprefix = "[Használat]: #ffffff"

local loadedVehicle = {}
local lastUsed = {}

local _respawnVehicle = respawnVehicle

function sendMessageToAdmins(player, msg)
	triggerClientEvent("sendMessageToAdmins", getRootElement(), player, msg, 8)
end

addEventHandler("onResourceStart", resourceRoot, function()
    Async:setPriority("high")
    dbQuery(function(queryHandle)
        local result, rows = dbPoll(queryHandle, 0)
        if rows > 0 then
            Async:foreach(result, function(data)
                local veh = loadVehicle(data)
                setElementDimension(veh, data.owner)

                setTimer(function() setElementDimension(veh, 0) end, 100, 1)
            end,

            function()
                outputChatBox("[Jármű]: #ffffffÖsszes jármű sikeresen betöltődött!", root, 255, 40, 40, true)
            end)
        end
    end, db, "SELECT * FROM vehicles")
end)

function loadVehicle(data)
    local id = data.id
    local pos = fromJSON(data.position)
    local rot = fromJSON(data.rotation)
    local color = fromJSON(data.color)

    loadedVehicle[id] = createVehicle(data.model, pos[1], pos[2], pos[3], rot[1], rot[2], rot[3])
    setVehicleRespawnPosition(loadedVehicle[id], pos[1], pos[2], pos[3], rot[1], rot[2], rot[3])

    if data.health < 250 then
        setElementHealth(loadedVehicle[id], 250)
    else
        setElementHealth(loadedVehicle[id], data.health)
    end
    
    setVehicleColor(loadedVehicle[id], color[1], color[2], color[3])
    setVehicleLocked(loadedVehicle[id], true)
    setVehicleOverrideLights(loadedVehicle[id], 1)

    setElementData(loadedVehicle[id], "veh:id", id)
    setElementData(loadedVehicle[id], "veh:owner", data.owner)
    setElementData(loadedVehicle[id], "veh:engine", false)
    setElementData(loadedVehicle[id], "veh:locked", true)
    setElementDimension(loadedVehicle[id], 0)

    setElementAlpha(loadedVehicle[id], 100)
    setElementCollisionsEnabled(loadedVehicle[id], false)
    setElementFrozen(loadedVehicle[id], true)
    setTimer(function() 
        setElementAlpha(loadedVehicle[id], 100) 
        setTimer(function() 
            setElementAlpha(loadedVehicle[id], 125) 
            setTimer(function() 
                setElementAlpha(loadedVehicle[id], 150) 
                setTimer(function() 
                    setElementAlpha(loadedVehicle[id], 175) 
                    setTimer(function() 
                        setElementAlpha(loadedVehicle[id], 200) 
                        setTimer(function() 
                            setElementAlpha(loadedVehicle[id], 225) 
                            setTimer(function() 
                                setElementAlpha(loadedVehicle[id], 255) 
                                setElementCollisionsEnabled(loadedVehicle[id], true)
                                setElementFrozen(loadedVehicle[id], false)
                            end, 1000, 1)
                        end, 1000, 1)
                    end, 1000, 1)
                end, 1000, 1)
            end, 1000, 1)
        end, 1000, 1)
    end, 1000, 1)

    return loadedVehicle[id]
end

function setVehicleDimension(veh)
    setElementDimension(veh, 0)

    setElementData(veh, "veh:loading", true)
    setElementAlpha(veh, 100)
    setElementCollisionsEnabled(veh, false)
    setElementFrozen(veh, true)
    setTimer(function() 
        setElementAlpha(veh, 100) 
        setTimer(function() 
            setElementAlpha(veh, 125) 
            setTimer(function() 
                setElementAlpha(veh, 150) 
                setTimer(function() 
                    setElementAlpha(veh, 175) 
                    setTimer(function() 
                        setElementAlpha(veh, 200) 
                        setTimer(function() 
                            setElementAlpha(veh, 225) 
                            setTimer(function() 
                                setElementAlpha(veh, 255) 
                                setElementCollisionsEnabled(veh, true)
                                setElementFrozen(veh, false)
                                removeElementData(veh, "veh:loading")
                            end, 1000, 1)
                        end, 1000, 1)
                    end, 1000, 1)
                end, 1000, 1)
            end, 1000, 1)
        end, 1000, 1)
    end, 1000, 1)
end

function saveAllVehicle()
    local vehicleCache = {}

    for k, v in pairs(lastUsed) do
        table.insert(vehicleCache, k)
    end

    local start = getTickCount()
    print("[VEHICLE] Started saving "..#vehicleCache.." vehicles...")

    local maxcars = 0
    for k, v in ipairs(getElementsByType("vehicle")) do 
        saveVehicle(v)
        maxcars = maxcars + 1
    end

    print("[VEHICLE] Saved "..maxcars.." vehicles in "..(getTickCount() - start).."ms!")
    lastUsed = {}
end
addCommandHandler("saveallveh", saveAllVehicle)

setTimer(function()
    saveAllVehicle()
end, 600000, 0)

function saveVehicle(v)
    local id = getElementData(v, "veh:id") or 0
    local vX, vY, vZ = getElementPosition(v)
    local rX, rY, rZ = getElementRotation(v)
    if id > 0 then
		dbExec(db, "UPDATE vehicles SET health=?, color=?, position=?, rotation=? WHERE id=?", getElementHealth(v), toJSON({getVehicleColor(v, true)}), toJSON({vX,vY,vZ}), toJSON({rX, rY, rZ}), id)
	end
end

addEventHandler("onPlayerQuit", getRootElement(), function()
    if not getElementData(source, "user:loggedin") then return end
    local owner = getElementData(source, "user:id")
    dbQuery(function(queryHandle)
        local result, rows = dbPoll(queryHandle, 0)
        if rows > 0 then
            for k, v in pairs(result) do
                local vehicle = findVehicle(v.id)
                setElementDimension(vehicle, owner)
                setVehicleLocked(vehicle, true)
                setVehicleEngineState(vehicle, false)
                setElementData(vehicle, "veh:locked", true)
                setElementData(vehicle, "veh:engine", false)
                setVehicleOverrideLights(vehicle, 1)
            end
        end
    end, db, "SELECT id FROM vehicles WHERE owner=?", owner)
end)

addEventHandler("onElementDataChange", root, function(theKey, oldValue, newValue)
    --outputChatBox(getPlayerName(source).." "..theKey.." "..tostring(newValue))
    if theKey == "user:loggedin" and tostring(newValue) == "true" then
        for k, vehicle in ipairs(getElementsByType("vehicle")) do
            --outputChatBox("car owner: "..getElementData(vehicle, "veh:owner").." userid: "..getElementData(source,"user:id"))
            if getElementData(vehicle, "veh:owner") == getElementData(source,"user:id") then
                setElementDimension(vehicle, 0)
                setElementFrozen(vehicle, true)
                setElementCollisionsEnabled(vehicle, false)
                setElementAlpha(vehicle, 100)
                setElementData(vehicle, "veh:loading", true)

                setTimer(function() 
                    setElementAlpha(vehicle, 100) 
                    setTimer(function() 
                        setElementAlpha(vehicle, 125) 
                        setTimer(function() 
                            setElementAlpha(vehicle, 150) 
                            setTimer(function() 
                                setElementAlpha(vehicle, 175) 
                                setTimer(function() 
                                    setElementAlpha(vehicle, 200) 
                                    setTimer(function() 
                                        setElementAlpha(vehicle, 225) 
                                        setTimer(function() 
                                            setElementAlpha(vehicle, 255) 
                                            setElementCollisionsEnabled(vehicle, true)
                                            setElementFrozen(vehicle, false)
                                            removeElementData(vehicle, "veh:loading")
                                        end, 1000, 1)
                                    end, 1000, 1)
                                end, 1000, 1)
                            end, 1000, 1)
                        end, 1000, 1)
                    end, 1000, 1)
                end, 1000, 1)
            end
        end
    end
end)

addCommandHandler("getcar", function(thePlayer, cmd, id)
    if getElementData(thePlayer,"user:admin") > 1 then 
	--if exports.cl_admin:isPlayerInAdminDuty(thePlayer)then
		if id then
			local veh = findVehicle(id)
			if veh then
				local x, y, z = getElementPosition(thePlayer)
				setElementPosition(veh, x, y+3, z)
                setElementDimension(veh, getElementDimension(thePlayer))
                setElementInterior(veh, getElementInterior(thePlayer))
                exports.cl_admin:sendMessageToAdmins(thePlayer,"maga mellé teleportálta a(z) #db3535"..getElementData(veh, "veh:id").."#557ec9-as/es ID-vel rendelkező járművet.")
				outputChatBox("[Jármű]: #ffffffMagad mellé teleportáltál egy járművet. ("..color.."#"..getElementData(veh, "veh:id").."#ffffff)", thePlayer, r, g, b, true)
			else
				outputChatBox("[Jármű]: #ffffffNem található jármű evvel az ID-vel.", thePlayer, 255, 40, 40, true)
			end
		else
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Jármű ID]", thePlayer, r, g, b, true)
		end
	end
end)

addCommandHandler("gotocar", function(thePlayer, cmd, id)
	if getElementData(thePlayer,"user:admin") > 1 then 
		if id then
			local veh = findVehicle(id)
			if veh then
				local x, y, z = getElementPosition(veh)
				setElementPosition(thePlayer, x, y+3, z)
                setElementDimension(thePlayer, getElementDimension(veh))
                setElementInterior(thePlayer, getElementInterior(veh))
                exports.cl_admin:sendMessageToAdmins(thePlayer,"odateleportált a(z) #db3535"..getElementData(veh, "veh:id").."#557ec9-as/es ID-vel rendelkező járműhöz.")
				outputChatBox("[Jármű]: #ffffffOda teleportáltál egy járműhöz. ("..color.."#"..getElementData(veh, "veh:id").."#ffffff)", thePlayer, r, g, b, true)
			else
				outputChatBox("[Jármű]: #ffffffNem található jármű evvel az ID-vel.", thePlayer, 255, 40, 40, true)
			end
		else
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Jármű ID]", thePlayer, r, g, b, true)
		end
	end
end)

addCommandHandler("park", function(thePlayer)
	local theVehicle = getPedOccupiedVehicle(thePlayer)
    if theVehicle then
        local id = getElementData(theVehicle, "veh:id") or 0
        if (getElementData(theVehicle, "veh:owner") == getElementData(thePlayer, "char:id") or exports.cl_admin:getPlayerAdminLevel(thePlayer) > 6) and id > 0 then
            local x, y, z = getElementPosition(theVehicle)
            local rx, ry, rz = getElementRotation(theVehicle)
            setVehicleRespawnPosition(theVehicle, x, y, z, rx, ry, rz)
            exports.cl_infobox:outputInfoBox("Sikeresen leparkoztad a járművet.", "success", thePlayer)
		else
			outputChatBox("[Jármű]: #ffffffEz nem a te járműved.", thePlayer, 255, 40, 40, true)
		end
	else
		outputChatBox("[Jármű]: #ffffffNem ülsz járműben.", thePlayer, 255, 40, 40, true)
	end
end)

function respawnVehicle(v)
    local owner = getElementData(v, "veh:owner") or 0
    if owner > 0 then
        local target, targetName = core:getPlayerFromPartialName(thePlayer, owner, true)
        _respawnVehicle(v)
        if not target then
            setElementDimension(v, owner)
        end
    else
        destroyElement(v)
    end
end

addEvent("respawnVehicles", true)
addEventHandler("respawnVehicles", getRootElement(), function(vehTable)
    for k, v in ipairs(vehTable) do
        respawnVehicle(v)
        exports.cl_admin:sendMessageToAdmins(client,"rtc-zte a(z) #db3535"..getElementData(v, "veh:id").."#557ec9-as/es ID-vel rendelkező járművet.")
    end
end)

addCommandHandler("respawnveh", function(thePlayer, cmd, id)
	if getElementData(thePlayer,"user:admin") > 2 then 
        local veh = findVehicle(id)
        if id then
            if veh then
                respawnVehicle(veh)
                exports.cl_admin:sendMessageToAdmins(thePlayer,"respawnolta a(z) #db3535"..getElementData(veh, "veh:id").."#557ec9-as/es ID-vel rendelkező járművet.")
                outputChatBox("[Jármű]: #ffffffRespawnoltál egy járművet. ("..color.."#"..id.."#ffffff)", thePlayer, r, g, b, true)
            else
                outputChatBox("[Jármű]: #ffffffNem található jármű ilyen ID-vel.", thePlayer, 255, 40, 40, true)
            end
        else
            outputChatBox("[Használat]: #ffffff/"..cmd.." [Jármű ID]", thePlayer, r, g, b, true)
        end
	end
end)

function findVehicle(id)
	local id = tonumber(id)
	if loadedVehicle[id] then
		return loadedVehicle[id]
	else
		return false
	end
end

local nonLockableVehicles = {
    [594] = true, [606] = true, [607] = true, [611] = true, [584] = true, [608] = true, [435] = true, [450] = true, [591] = true, [539] = true, [441] = true, [464] = true, [501] = true, [465] = true, [564] = true, [472] = true, [473] = true, [493] = true, [595] = true, [484] = true, [430] = true, [453] = true, [452] = true, [446] = true, [454] = true, [581] = true, [509] = true, [481] = true,
    [462] = true, [521] = true, [463] = true, [510] = true, [522] = true, [461] = true, [448] = true, [468] = true, [586] = true, [425] = true, [520] = true
}

addEventHandler("onVehicleStartEnter", getRootElement(), function(thePlayer, seat, jacked)
    if nonLockableVehicles[getElementModel(source)] and getElementData(source, "veh:locked") then
        cancelEvent()
        exports.cl_infobox:outputInfoBox("Ez a jármű le van zárva.", "error", thePlayer)
    elseif jacked then
        cancelEvent()
        outputChatBox("[Jármű]: #ffffffEz NonRP-s, használj inkább /kiszed -et!", thePlayer, 255, 40, 40, true)
    elseif getElementData(source, "veh:loading") then
        cancelEvent()
        exports.cl_infobox:outputInfoBox("Várj egy picit, míg a jármű betöltődik.", "error", thePlayer)
    end
end)

addEventHandler("onVehicleEnter", getRootElement(), function()
    if not lastUsed[source] then
        lastUsed[source] = true
    end
end)

addEventHandler("onVehicleExplode", getRootElement(), function()
    setTimer(function(source)
        if not isElement(source) then return end
		respawnVehicle(source)
		setVehicleDamageProof(source, false)
	end, 5000, 1, source)
end)

local seatWindows = {
	[0] = 4,
	[1] = 2,
	[2] = 5,
	[3] = 3
}

addCommandHandler("ablak", function(thePlayer)
	local veh = getPedOccupiedVehicle(thePlayer)
	if veh then
		local seat = getPedOccupiedVehicleSeat(thePlayer)
		local window = seatWindows[seat]
		if window then
			local status = getElementData(veh, "veh:windowopen"..window)
			if status then
				outputChatBox("[Jármű]: #ffffffFelőled lévő ablak felhúzva.", thePlayer, r, g, b, true)
				exports.cl_chat:sendLocalMeAction(thePlayer, "felhúzta a jármű ablakát.")
                setElementData(veh,"veh:windowstate","close")
			else
				outputChatBox("[Jármű]: #ffffffFelőled lévő ablak lehúzva.", thePlayer, r, g, b, true)
				exports.cl_chat:sendLocalMeAction(thePlayer, "lehúzta a jármű ablakát.")
                setElementData(veh,"veh:windowstate","open")
			end
			triggerClientEvent("client->turnDownWindow", veh, window, status)
			setElementData(veh, "veh:windowopen"..window, not status)
		end
	else
		outputChatBox("[Jármű]: #ffffffJárműben kell ülnöd, hogy le tudd húzni az ablakot.", thePlayer, 255, 40, 40, true)
	end
end)

addEventHandler("onVehicleStartExit", getRootElement(), function(thePlayer)
    if getElementData(source, "veh:locked") then
        cancelEvent()
        exports.cl_infobox:outputInfoBox("Ez a jármű le van zárva.", "error", thePlayer)
    elseif getElementData(thePlayer, "char:seatbelt") then
        cancelEvent()
        exports.cl_infobox:outputInfoBox("Kapcsold ki a biztonsági övedet [F5] mielőtt kiszállnál!", "error", thePlayer)
    elseif isElementFrozen(source) then
        cancelEvent()
        exports.cl_infobox:outputInfoBox("Nem tudsz kiszállni járműből ha le vagy fagyasztva!", "error", thePlayer)
    end
end)

addEventHandler("onVehicleDamage", getRootElement(), function(dmg)
    local health = getElementHealth(source)
    if health - dmg <= 250 then
        setElementHealth(source, 250)
        setVehicleEngineState(source, false)
        setVehicleOverrideLights(source, 1)
		resetVehicleExplosionTime(source) 
		setVehicleDamageProof(source, true)
        setElementData(source, "veh:engine", false)

        local driver = getVehicleOccupant(source)
        if not getElementData(source, "veh:broke") and driver then
            exports.cl_infobox:outputInfoBox("Lerobbant a járműved!", "warning", driver)
            setElementData(source, "veh:broke", true)
        end
    end
    if getElementData(source, "veh:locked") then
        for i=1, 5 do
            setVehicleDoorOpenRatio(source, i, 0)
        end
    end
end)

addCommandHandler("kiszed", function(thePlayer, cmd, target)
    if target then
        local target, targetName = core:getPlayerFromPartialName(thePlayer, target)
        if target then
            if target ~= thePlayer then
                local veh = getNearestVehicle(thePlayer, 4)
                if veh then
                    if getPedOccupiedVehicle(target) == veh then
                        removePedFromVehicle(target)
                        exports.cl_chat:sendLocalMeAction(thePlayer, "kiszedte "..targetName.."-t a járműből.")
                    else
                        outputChatBox("[Jármű]: #ffffffEz a játékos nem ül járműben.", thePlayer, 255, 40, 40, true)
                    end
                else
                    outputChatBox("[Jármű]: #ffffffNincs a közeledben játékos.", thePlayer, 255, 40, 40, true)
                end
            else
                outputChatBox("[Jármű]: #ffffffMagadat hogy akarod kiszedni? :)", thePlayer, 255, 40, 40, true)
            end
        else
            outputChatBox("[Jármű]: #ffffffNem található a játékos.", thePlayer, 255, 40, 40, true)
        end
    else
        outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID]", thePlayer, r, g, b, true)
    end
end)

addCommandHandler("mycars", function(thePlayer)
    dbQuery(function(queryHandle)
        local result, rows = dbPoll(queryHandle, 0)
        if rows > 0 then
            outputChatBox("[Jármű]: #ffffffKocsijaid:", thePlayer, r, g, b, true)
            for k, v in pairs(result) do
                local veh = findVehicle(v.id)
                outputChatBox("[Jármű]: #ffffff"..getElementData(veh, "veh:id").." - "..color..getVehicleName(veh).." #ffffff["..getElementModel(veh).."]", thePlayer, r, g, b, true)
            end
        else
            outputChatBox("[Jármű]: #ffffffNincs kocsid!", thePlayer, 255, 40, 40, true)
        end
    end, db, "SELECT id FROM vehicles WHERE owner=?", getElementData(thePlayer, "char:id"))
end)

addCommandHandler("delveh", function(thePlayer, cmd, id)
	if exports.cl_admin:getPlayerAdminLevel(thePlayer) >= 8 then
		if tonumber(id) then
			dbQuery(function(qh, thePlayer)
				local veh = findVehicle(id)
				local res, rows = dbPoll(qh, 0)
				if rows > 0 then
                    loadedVehicle[id] = nil
                    if isElement(veh) then
					   destroyElement(veh)
                    end
					dbExec(db, "DELETE FROM vehicles WHERE id=?", id)
					sendMessageToAdmins(thePlayer, "törölt egy járművet. (#db3535#"..id.."#557ec9)")
				else
					outputChatBox("[Jármű]: #ffffffNem található jármű ezzel az ID-vel.", thePlayer, 255, 40, 40, true)
				end
			end, {thePlayer}, db, "SELECT * FROM vehicles WHERE id=?", id)
		else
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Jármű ID]", thePlayer, r, g, b, true)
		end
	end
end)

addCommandHandler("delthisveh", function(thePlayer)
	if exports.cl_admin:getPlayerAdminLevel(thePlayer) >= 8 then
        local veh = getPedOccupiedVehicle(thePlayer)
        local id = getElementData(veh, "veh:id") or 0
        if id > 0 then
            dbQuery(function(qh, thePlayer)
                local res, rows = dbPoll(qh, 0)
                if rows > 0 then
                    loadedVehicle[id] = nil
                    destroyElement(veh)
                    dbExec(db, "DELETE FROM vehicles WHERE id=?", id)
                    sendMessageToAdmins(thePlayer, "törölt egy járművet. (#db3535#"..id.."#557ec9)")
                else
                    outputChatBox("[Jármű]: #ffffffHiba történt, a jármű nem került törlésre.", thePlayer, 255, 40, 40, true)
                end
            end, {thePlayer}, db, "SELECT * FROM vehicles WHERE id=?", id)
        else
            destroyElement(veh)
        end
    end
end)

function createShopVehicle(model, owner, x, y, z, cr, cg, cb)
    local pos = toJSON({x, y, z})
    local color = toJSON({cr, cg, cb})

    dbExec(db, "INSERT INTO vehicles (owner, model, position, color) VALUES (?,?,?,?)", owner, model, pos, color)
    dbQuery(function(queryHandle)
        local result, rows = dbPoll(queryHandle, 0)
        if rows > 0 then
            local veh = loadVehicle(result[1])
            setElementData(owner, "log:carshop", {getElementData(veh, "veh:id")})
            return veh
        end
    end, db, "SELECT * FROM vehicles WHERE id=LAST_INSERT_ID()")
end

addCommandHandler("makeveh", function(thePlayer, cmd, model, owner, cr, cg, cb)
    if model and tonumber(owner) then
        if not tonumber(cr) or not tonumber(cg) or not tonumber(cb) then cr, cg, cb = 255, 255, 255 end
        local target, targetName = core:getPlayerFromPartialName(thePlayer, owner)
        if not target then return end

        if tonumber(model) then
            modelName = getVehicleNameFromModel(model)
            if not modelName then return end
        elseif tostring(model) then
            model = getVehicleModelFromName(model)
            if not model then return end
            modelName = getVehicleNameFromModel(model)
        end

        local x, y, z = getElementPosition(thePlayer)

        dbExec(db, "INSERT INTO vehicles (owner, model, position, color) VALUES (?,?,?,?)", getElementData(target, "char:id"), tonumber(model), toJSON({x, y + 5, z}), toJSON({cr, cg, cb}))
        dbQuery(function(queryHandle)
            local result, rows = dbPoll(queryHandle, 0)
            if rows > 0 then
                local veh = loadVehicle(result[1])
                modelName = getModdedVehicleName(veh)
                sendMessageToAdmins(thePlayer, "létrehozott #db3535"..modelName.."#557ec9 nevű járművet. (".."#db3535#"..getElementData(veh, "veh:id").."#557ec9) Tulajdonos: #db3535"..targetName)
            end
        end, db, "SELECT * FROM vehicles WHERE id=LAST_INSERT_ID()")
    else
        outputChatBox("[Használat]: #ffffff/makeveh [Model ID/Név] [Tulajdonos] [R] [G] [B]", thePlayer, r, g, b, true)
    end
end)

addCommandHandler("makecivveh", function(thePlayer, cmd, model)
    if model then
        if tonumber(model) then
            modelName = getVehicleNameFromModel(model)
            if not modelName then return end
        elseif tostring(model) then
            model = getVehicleModelFromName(model)
            if not model then return end
            modelName = getVehicleNameFromModel(model)
        end

        local x, y, z = getElementPosition(thePlayer)
        createVehicle(model, x, y + 5, z)

        sendMessageToAdmins(thePlayer, "létrehozott "..color..modelName.."#ffffff nevű civil járművet.")
    else
        outputChatBox("[Használat]: #ffffff/makecivveh [Model ID/Név]", thePlayer, r, g, b, true)
    end
end)

addCommandHandler("setcolor", function(thePlayer, cmd, cr, cg, cb, cr2, cg2, cb2)
    if cr and cg and cb then
        local veh = getPedOccupiedVehicle(thePlayer)
        if veh then
            setVehicleColor(veh, cr, cg, cb, cr2, cg2, cb2)
            sendMessageToAdmins(thePlayer, "átszínezett egy járművet.")
        else
            outputChatBox("[Jármű]: #ffffffNem ülsz járműben.", thePlayer, 255, 40, 40, true)
        end
    else
        outputChatBox("[Használat]: #ffffff/setcolor [R] [G] [B]", thePlayer, r, g, b, true)
    end
end)


addEvent("toggleEngine", true)
addEventHandler("toggleEngine", getRootElement(), function(veh, state)
	setVehicleEngineState(veh, not state)
	setElementData(veh, "veh:engine", not state)
	--setVehicleOverrideLights(veh, state and 1 or 2)
end)

function lockLight(veh)
    if getVehicleOverrideLights(veh) == 1 or getVehicleOverrideLights(veh) == 0 then
        setVehicleOverrideLights(veh, 2)
        setTimer(function()
            setVehicleOverrideLights(veh, 1)
        end, 300, 1)
    elseif getVehicleOverrideLights(veh) == 2 then
        setVehicleOverrideLights(veh, 1)
        setTimer(function()
            setVehicleOverrideLights(veh, 2)
        end, 300, 1)
    end
end

addEvent("toggleLights", true)
addEventHandler("toggleLights", getRootElement(), function(veh, state)
	setVehicleOverrideLights(veh, state)
end)

addEvent("lockVehicle", true)
addEventHandler("lockVehicle", getRootElement(), function(veh, state)
	if not state then
		for i=1, 5 do
			setVehicleDoorOpenRatio(veh, i, 0)
		end
	end
	setVehicleLocked(veh, not state)
	setElementData(veh, "veh:locked", not state)
	lockLight(veh)
end)

--jobbklikkes ajtónyitás 
addEvent("changeDoorState2", true)
addEventHandler("changeDoorState2", root,
    function(veh, num, oldState)
        setPedAnimation(source, "Ped", "CAR_open_LHS", 300, false, false, true, false)
        local oldState = not oldState
        local openRatio = 0
        if oldState then
            openRatio = 1
        end
        setVehicleDoorOpenRatio(veh, num, openRatio, 400)
    end
)

addEventHandler("onResourceStop", resourceRoot, function()
    saveAllVehicle()
end)