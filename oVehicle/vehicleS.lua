local conn = exports.oMysql:getDBConnection()

Async:setPriority("low")
Async:setDebug(true)
------------------------/ Thread / ------------------------------------------------------
ThreadClass = {
	name = "thread";
	perElements = 5000;
	perElementsTick = 50;
	threadCount = 1;
	threadElements = {};
	callback = nil;
	funcArgs = {};
	state = false;
}


function ThreadClass:new(o)
	o = o or {};
	o.threadCount = 1;
	o.threadElements = {};
	setmetatable(o, self);
	self.__index = self;
	return o;
end

function ThreadClass:setMaxElement(m)
	self.perElements = m;
end

function ThreadClass:foreach(elements, func, callback, ...)
	if self.state and #elements > 0 then
		outputDebugString("New thread for " .. self.name);
		return ThreadClass:new({name = self.name, perElements = self.perElements, perElementsTick = self.perElementsTick}):foreach(elements, func, callback, ...);
	end
	self.state = true;
	self.callback = callback;
	self.funcArgs = {...};
	for i, v in ipairs(elements) do
		if not self.threadElements[self.threadCount] then
			self.threadElements[self.threadCount] = {};
		end
		table.insert(self.threadElements[self.threadCount], function()
			if(#self.funcArgs > 0)then
				func(v, unpack(self.funcArgs));
			else
				func(v);
			end
		end);

		if (#self.threadElements[self.threadCount] >= self.perElements or i == #elements) then
			self.threadCount = self.threadCount + 1;
		end
	end

	return self:resume();
end

function ThreadClass:resume()
	if(self.threadCount>0) then
		local state, result = coroutine.resume(coroutine.create(function()
			if self.threadElements[self.threadCount] then
				for j, k in ipairs(self.threadElements[self.threadCount]) do
					k();
				end
			end
		end));
		self.threadCount = self.threadCount - 1;
		if not state then
			outputDebugString("[Thread - " .. self.name .. "] Error: " .. result, 0, 255, 0, 0);
		end
		if self.perElementsTick >= 50 then
			setTimer(function()
				self:resume();
			end, self.perElementsTick, 1);
		else
			self:resume();
		end
	else
		if(self.callback)then
			if(#self.funcArgs > 0)then
				self.callback(v, unpack(self.funcArgs));
			else
				self.callback(v);
			end
		end
		self.state = false;
	end

	return self;
end

function newThread(n, per, tick)
	return ThreadClass:new({name = n or "threading", perElements = per or 5000, perElementsTick = tick or 50});
end
---------------------------------------------------------------------------------------
local loadedVehicles = {}
local usedcarids = {}
local existingVehicleModels = {}

addEventHandler("onPlayerQuit", root, function()
    local playerID = getElementData(source, "char:id")

    for k, v in ipairs(getElementsByType("vehicle")) do
        if getElementData(v, "veh:owner") == playerID then
            if getElementInterior(v) == 0 then
                if getElementData(v, "veh:protected") == 0 and (not getElementData(v, 'inCarshop')) then
                    if getElementData(v, "veh:isFactionVehice") == 0 then
                        local occupants = getVehicleOccupants(v)

                        usedcarids[getElementData(v, "veh:id")] = false

                        for k, v in pairs(occupants) do
                            removePedFromVehicle(v)
                        end

                        --setElementDimension(v, playerID)

                        if getElementData(v, "vehicleInTeslaCharger") then
                            exports.oTeslaCharger:removeTeslaChargerToVehServer(v)
                        end

                        saveOneVehicle(v)
                        setTimer(function()
                            destroyElement(v)
                        end, 1000, 1)
                    end
                end
            end
        end
    end

    local tempVehicles = getElementData(source, "vehicle:tempVehicles") or {}

    for k, v in ipairs(tempVehicles) do
        if isElement(v) then
            destroyElement(v)
        end
    end
end)

function loadVehicleFromClientRequest(veh, status, playerID)
    if client then 
        setElementDimension(veh, status and 0 or (playerID or 0))

        if status then 
            vehicleLoadinAnimation(veh) 
        else 
            if getElementData(veh, "vehicleInTeslaCharger") then
                exports.oTeslaCharger:removeTeslaChargerToVehServer(veh)
            end
        end
    end 
end 
addEvent("loadVehicleFromClientRequest", true)
addEventHandler("loadVehicleFromClientRequest", resourceRoot, loadVehicleFromClientRequest)


function loadVehicleFromCharID(charID)
    local Thread = newThread("vehicles"..(charID or 0), 2, 100);
    local loadTick = getTickCount()

    dbQuery(function(qh)
        local result, rows = dbPoll(qh, 0)
        local loadCount = 0

        if rows > 0 then
            Thread:foreach(result, function(v)
                loadOneVehicle(v) 
            end)

        end

    end, conn, "SELECT * FROM vehicles WHERE owner = ? AND isFactionVehicle = 0 AND isProtected = 0 AND isBooked = 0 AND carshop = '[ false ]'", charID)
end

function loadVehiclesFromClientRequest(playerID) 
    if client then 
        loadVehicleFromCharID(playerID)
    end
end
addEvent("loadVehiclesFromClientRequest", true)
addEventHandler("loadVehiclesFromClientRequest", resourceRoot, loadVehiclesFromClientRequest)


------------[ SZÜKSÉGES FUNKCIÓK ]------------
function createNewVehicle(model, owner, pos, rot, color, plate)
    if not plate then plate = createRandomPlateText() end

    model = tonumber(model)
    if not existingVehicleModels[model] then 
        existingVehicleModels[model] = 0
    end
    existingVehicleModels[model] = existingVehicleModels[model] + 1
    triggerClientEvent(root,"syncLimits",root, existingVehicleModels)

    local ownerID = getElementData(owner, "char:id")
    local veh = createVehicle(model, pos[1], pos[2], pos[3], rot[1], rot[2], rot[3], plate)
    vehicleLoadinAnimation(veh)
    dbExec(conn,"INSERT INTO vehicles SET model=?, owner=?, health=?, position=?, rotation=?, color=?, plateText=?, fuelType = ?, isBooked=?",model, ownerID, 1000, toJSON(pos), toJSON(rot), toJSON(color), plate, getVehicleModelFuelType(model), 0)
   -- local insertResult, _, insertID = dbPoll(dbQuery(conn, "INSERT INTO vehicles SET model=?, owner=?, health=?, position=?, rotation=?, color=?, plateText=?, fuelType = ?, isBooked=?", model, ownerID, 1000, toJSON(pos), toJSON(rot), toJSON(color), plate, vehicleFuelType[model] or "95", 0), 250)

   if model==416 then
    setElementData(veh,"veh:Stretcher",true)
   end


    dbQuery(function(qh)
        local result = dbPoll(qh, 0)[1]
        if result then
            setElementData(veh, "veh:id", result.id)
        end
    end, conn, "SELECT * FROM vehicles WHERE id = LAST_INSERT_ID()")

    setElementData(veh, "veh:isFactionVehice", 0)
    setElementData(veh, "veh:owner", ownerID)

    setVehicleColor(veh, color[1], color[2], color[3])
    setVehiclePlateText(veh, plate)

    setElementData(veh, "veh:engine", false)
    setElementData(veh, "veh:locked", true)
    setVehicleLocked(veh, true)
    setElementData(veh, "veh:lamp", false)

    setElementData(veh, "veh:protected", 0)
    setElementData(veh, "veh:distanceToOilChange", 15000)
    setElementData(veh, "veh:wheelType", "S")


    setElementData(veh, "veh:fuel", getVehicleMaxFuel(model))
    setElementData(veh, "veh:maxFuel", getVehicleMaxFuel(model))
    setElementData(veh, "veh:fuelType", getVehicleModelFuelType(model))
    setElementData(veh, "veh:lastFuelType", getVehicleModelFuelType(model))

    setElementData(veh, "veh:traveledDistance", 0)

    setElementData(veh, "vehIsBooked", 0)

    setElementData(veh, "tuning:vehVariant", {255, 255})
    setVehicleVariant(veh, 255, 255)

    veh:setData('inCarshop', false)

    exports.oInventory:loadVehicleInventory(veh)
    exports.oHandling:loadHandling(veh)

    return veh
end

function createNewFactionVehicle(model, faction, pos, rot, color, plate)
    if not plate then plate = createRandomPlateText() end
    model = tonumber(model)
    local faction = tonumber(faction)

    local veh = createVehicle(model, pos[1], pos[2], pos[3], rot[1], rot[2], rot[3], plate)
    vehicleLoadinAnimation(veh)
    dbExec(conn, "INSERT INTO vehicles SET model=?, owner=?, health=?, position=?, rotation=?, color=?, plateText=?, isFactionVehicle=?, fuelType = ?, isBooked=?", model, faction, 1000, toJSON(pos), toJSON(rot), toJSON(color), plate, 1, getVehicleModelFuelType(model), 0)
    dbQuery(function(qh)
        local result = dbPoll(qh, 0)[1]
        if result then
            setElementData(veh, "veh:id", result.id)
        end
    end, conn, "SELECT * FROM vehicles WHERE id = LAST_INSERT_ID()")
    --local insertResult, _, insertID = dbPoll(dbQuery(conn, "INSERT INTO vehicles SET model=?, owner=?, health=?, position=?, rotation=?, color=?, plateText=?, isFactionVehicle=?, fuelType = ?, isBooked=?", model, faction, 1000, toJSON(pos), toJSON(rot), toJSON(color), plate, 1, vehicleFuelType[model] or "95", 0), 250)


    setElementData(veh, "veh:isFactionVehice", 1)
    setElementData(veh, "veh:owner", faction)

    setVehicleColor(veh, color[1], color[2], color[3])
    setVehiclePlateText(veh, plate)

    setElementData(veh, "veh:engine", false)
    setElementData(veh, "veh:locked", true)
        setVehicleLocked(veh, true)
    setElementData(veh, "veh:lamp", false)

    setElementData(veh, "veh:protected", 0)


    setElementData(veh, "veh:fuel", getVehicleMaxFuel(model))
    setElementData(veh, "veh:maxFuel", getVehicleMaxFuel(model))
    setElementData(veh, "veh:fuelType", getVehicleModelFuelType(model))
    setElementData(veh, "veh:lastFuelType", getVehicleModelFuelType(model))
    setElementData(veh, "veh:distanceToOilChange", 15000)
    setElementData(veh, "veh:wheelType", "S")

    setElementData(veh, "veh:traveledDistance", 0)
    setElementData(veh, "veh:traveledDistance", 0)

    setElementData(veh, "vehIsBooked", 0)

    setElementData(veh, "tuning:vehVariant", {255, 255})
    setVehicleVariant(veh, 255, 255)

    veh:setData('inCarshop', false)

    exports.oInventory:loadVehicleInventory(veh)
    exports.oHandling:loadHandling(veh)

    return veh
end

function saveOneVehicle(veh)
    local vehId = getElementData(veh, "veh:id")

    local posX, posY, posZ = getElementPosition(veh)
    local rotX, rotY, rotZ = getElementRotation(veh)

    local ownerId = getElementData(veh, "veh:owner")
    local model = getElementModel(veh)
    local hp = getElementHealth(veh)
    local position = toJSON({posX, posY, posZ})
    local rotation = toJSON({rotX, rotY, rotZ})
    local color = toJSON({getVehicleColor(veh, true)})
    local plateText = getVehiclePlateText(veh)

    local isProtected = getElementData(veh, "veh:protected")

    local engineTunings = getElementData(veh, "veh:engineTunings") or {}
    engineTunings = toJSON(engineTunings)

    local fuel = getElementData(veh, "veh:fuel") or 0
    local fuelType = getElementData(veh, "veh:lastFuelType")
    local dis = getElementData(veh, "veh:traveledDistance") or 0
    local wheelType = getElementData(veh, "veh:wheelType") or "S"

    --exports.oInventory:saveOneElementInventory(veh)

    local paintjobID = (getElementData(veh, "veh:paintjob") or 0)
    local opticTunings = {  -- [[wheel, exhaust, roof, spoiler, rear_bumper, front_bumper, skirt]]
        (getElementData(veh, "veh:tuningWheel") or 0),
        (getElementData(veh, "veh:tuning:exhaust") or 0),
        (getElementData(veh, "veh:tuning:roof") or 0),
        (getElementData(veh, "veh:tuning:spoiler") or 0),
        (getElementData(veh, "veh:tuning:rear_bumper") or 0),
        (getElementData(veh, "veh:tuning:front_bumper") or 0),
        (getElementData(veh, "veh:tuning:skirt") or 0),
    }

    local neon = getElementData(veh, "veh:neon:id") or 0
    local airride = getElementData(veh, "veh:tuning:airride") or 0

    local vehIsBooked = getElementData(veh, "vehIsBooked") or 0

    local vehVariant = toJSON(getElementData(veh, "tuning:vehVariant") or {255, 255})

    local lightColor = {getVehicleHeadLightColor(veh)}

    local horn = getElementData(veh, "veh:customHorn") or 0
    local handBrake = getElementData(veh, "veh:handbrake") or 0
    local oilChange = getElementData(veh, "veh:distanceToOilChange") or 10

    local supercharger = getElementData(veh, "veh:sc") or false


    local datas = { -- ezt használjuk
        -- SQL_Oszlop név = érték,
        position = toJSON({posX, posY, posZ}),
        rotation = toJSON({rotX, rotY, rotZ}),
    }

    local columns = {};
    local columnValues = {};

    for k,v in pairs(datas) do
        table.insert(columns, k .. " = ?");
        table.insert(columnValues, v);
    end

    table.insert(columnValues, vehId);
    -- Ez majd kell de ha majd rá érek akkor írom át
    --dbExec(connection, "UPDATE vehicles SET " .. table.concat(columns, ", ") .. " WHERE id = ?", unpack(columnValues));

    local interior = getElementInterior(veh)
    local dim = getElementDimension(veh)

    dbExec(conn, "UPDATE vehicles SET owner = ?, health = ?, position = ?, rotation = ?, color = ?, plateText = ?, interior = ?, dim = ?, isProtected = ?, engineTunings = ?, fuel = ?, traveledDistance = ?, paintjobID = ?, opticTunings = ?, neon = ?, airride = ?, fuelType = ?, isBooked = ?, variant = ?, lightColor = ?, horn = ?, supercharger = ?, handbrake = ?, oilChange = ?, wheelType = ? WHERE id = ?", ownerId,  hp, position, rotation, color, plateText, interior, dim, isProtected, engineTunings, fuel, dis, paintjobID, toJSON(opticTunings), neon, airride, fuelType, vehIsBooked, vehVariant, toJSON(lightColor), horn, supercharger, handBrake, oilChange, wheelType, vehId)


    if not (getElementData(veh, "veh:isFactionVehice") == 1) then
        conn:exec('UPDATE vehicles SET carshop=? WHERE id=?', toJSON(veh:getData('inCarshop') or false), vehId)
    end
end

function saveAllVehicle()
    local count = 0
    for k, v in ipairs(getElementsByType("vehicle")) do
        local vehID = getElementData(v, "veh:id") or 0

        if vehID > 0 then
            saveOneVehicle(v)
            count = count + 1
        end

        --setElementPosition(v, 1961.2858886719, -2188.8364257812, 13.546875)
    end

    --outputDebugString("[Vehicle]: "..count.."db jármű sikeresen elmentve!")
end

function saveRequest()
    saveAllVehicle()
	outputDebugString("[oServerStop]: oVehicle sikeres mentés.",3);
end 

function loadOneVehicle(v)
    if usedcarids[v["id"]] then return end 
    usedcarids[v["id"]] = true
    local vehId = v["id"] 
    local ownerId = v["owner"]
    vehOwnerId = ownerId
    local model = v["model"]
    local hp = v["health"]
    local position = fromJSON(v["position"])
    local rotation = fromJSON(v["rotation"])
    local int = v["interior"]
    local dim = v["dim"]
    local color = fromJSON(v["color"])
    local plateText = v["plateText"]

    local isFactionVehicle = v["isFactionVehicle"]
    local isProtected = v["isProtected"]

    local engineTunings = fromJSON(v["engineTunings"]) or {}

    local fuel = v["fuel"]
    local dis = v["traveledDistance"]

    local opticTunings = fromJSON(v["opticTunings"])
    local paintjob = v["paintjobID"]
    local neonID = v["neon"]
    local airride = v["airride"]
    local fuelType = v["fuelType"]
    local wheelType = v["wheelType"]

    local handBrake = v["handbrake"]
    local oilChange = v["oilChange"]

    local vehIsBooked = v["isBooked"]

    local vehVariant = fromJSON(v["variant"])

    local lightColor = fromJSON(v["lightColor"])

    local horn = v["horn"]

    veh = createVehicle(model, position[1], position[2], position[3] + 1, rotation[1], rotation[2], rotation[3], plateText)
    if isElement(veh) then
        setVehicleColor(veh, unpack(color))
        setElementHealth(veh, hp)
        setVehicleDamageProof(veh, false)
        setVehicleHeadLightColor(veh, unpack(lightColor))

        if model==416 then
            setElementData(veh,"veh:Stretcher",true)
        end

        if handBrake == 1 then
            setElementData(veh, "veh:handbrake", true)
        else
            setElementData(veh, "veh:handbrake", false)
        end

        setElementData(veh, "veh:distanceToOilChange", tonumber(oilChange))
        setElementData(veh, "veh:wheelType", wheelType)

        if not (isFactionVehicle == 1) then
            if isProtected == 0 then
                if not vehicleOwnerIsOnline(ownerId) then
                    setElementDimension(veh, ownerId)
                else
                    --outputChatBox(v["id"]..": "..int.." "..dim)
                    if vehIsBooked == 1 then
                        setElementInterior(veh, 0)
                        setElementDimension(veh, math.random(1,60000))
                    else
                        setElementInterior(veh, int)
                        setElementDimension(veh, dim)
                    end
                end
            else
               if vehIsBooked == 1 then
                    setElementInterior(veh, 0)
                    setElementDimension(veh, vehId)
                end
            end
        else
            setElementInterior(veh, int)
            setElementDimension(veh, dim)

        end

        setElementData(veh, "veh:isFactionVehice", isFactionVehicle)
        setElementData(veh, "veh:owner", ownerId)

        setElementData(veh, "veh:id", vehId)

        setElementData(veh, "veh:engine", false)
        setElementData(veh, "veh:locked", true)
        setVehicleLocked(veh, true)
        setElementData(veh, "veh:lamp", false)
        setElementData(veh, "veh:protected", isProtected)
        setElementData(veh, "veh:engineTunings", engineTunings)


        setElementData(veh, "veh:fuel", fuel)
        setElementData(veh, "veh:maxFuel", getVehicleMaxFuel(model))
        setElementData(veh, "veh:fuelType", getVehicleModelFuelType(model))

        if fuelType == "" then
            fuelType = getVehicleModelFuelType(model) or "95"
        end

        setElementData(veh, "veh:lastFuelType", fuelType)

        setElementData(veh, "veh:traveledDistance", dis)

        setElementData(veh, "veh:paintjob", paintjob)

        setElementData(veh, "veh:neon:active", false)
        setElementData(veh, "veh:neon:id", neonID)
        setElementData(veh, "veh:tuning:airride", airride)

        setElementData(veh, "vehIsBooked", vehIsBooked)

        setElementData(veh, "tuning:vehVariant", vehVariant)
        setVehicleVariant(veh, unpack(vehVariant))

        setElementData(veh, "veh:customHorn", horn)

        local supercharger = v["supercharger"]

        if supercharger == 0 then
            supercharger = false
        elseif supercharger == 1 then
            supercharger = true
        end

        setElementData(veh, "veh:sc", supercharger)

        local opticTuningList = {"veh:tuningWheel", "veh:tuning:exhaust", "veh:tuning:roof", "veh:tuning:spoiler", "veh:tuning:rear_bumper", "veh:tuning:front_bumper", "veh:tuning:skirt"}
        for k, v in ipairs(opticTuningList) do
            --print(v)
            local upID = 0

            if opticTunings[k] then
                upID = opticTunings[k]
            end

            setElementData(veh, v, upID)

            if upID > 0 then
                addVehicleUpgrade(veh, upID)
            end
        end

        setElementData(veh, 'inCarshop', fromJSON(v['carshop']))

        exports.oInventory:loadVehicleInventory(veh)
        exports.oHandling:loadHandling(veh)

        vehicleLoadinAnimation(veh)
    end
end

function loadAllVehicle()
    local Thread = newThread("factionVehicles", 2, 100);
    local loadTick = getTickCount()
    -- frakció kocsik
    dbQuery(function(qh)
        local result, rows = dbPoll(qh, 0)
        local loadCount = 0
        if rows > 0 then
            Thread:foreach(result, function(v)
                loadCount = loadCount + 1
                loadOneVehicle(v) 
            end, function()
                outputDebugString("[Vehicle] Sikeresen betöltöttem az összes frakció járművet! (".. loadCount .." db)")
            end)
        end
    end, conn, "SELECT * FROM vehicles WHERE isFactionVehicle = 1")

    local Thread2 = newThread("vehicles", 2, 100);
    dbQuery(function(qh)
        local result, rows = dbPoll(qh, 0)
        local loadCount = 0
        if rows > 0 then
            Thread2:foreach(result, function(v)
                loadCount = loadCount + 1
                loadOneVehicle(v) 
            end, function()
                outputDebugString("[Vehicle] Sikeresen betöltöttem az összes protectes járművet! (".. loadCount .." db)")
            end)
        end
    end, conn, "SELECT * FROM vehicles WHERE isFactionVehicle = 0 AND isProtected = 1")

    setTimer(function()
        local Thread2 = newThread("vehicles", 2, 100);
        dbQuery(function(qh)
            local result, rows = dbPoll(qh, 0)
            local loadCount = 0
            if rows > 0 then
                Thread2:foreach(result, function(v)
                    loadCount = loadCount + 1
                    
                    if not existingVehicleModels[v["model"]] then 
                        existingVehicleModels[v["model"]] = 0
                    end

                    existingVehicleModels[v["model"]] = existingVehicleModels[v["model"]] + 1
                    triggerClientEvent(root,"syncLimits",root, existingVehicleModels)
                end, function()
                    outputDebugString("[Vehicle] Sikeresen betöltöttem az összes jármű limitét! (".. loadCount .." db)")
                end)
            end
        end, conn, "SELECT * FROM vehicles WHERE isFactionVehicle = 0")
    end,10000,1)

    for k, v in ipairs(getElementsByType("player")) do
        loadVehicleFromCharID(getElementData(v, "char:id"))
    end

    --for k, v in ipairs(result) do

   -- outputDebugString("[Vehicle]: "..loadCount.."db jármű sikeresen betöltve!")
end

addEvent("vehicle > getLimits", true)
addEventHandler("vehicle > getLimits", resourceRoot, function()
    triggerClientEvent(client,"syncLimits",client, existingVehicleModels)
end)

function deleteVehicle(vehicle)

    local vehID = tonumber(getElementData(vehicle, "veh:id"))

    dbExec(conn, "DELETE FROM vehicles WHERE id=?", vehID)

    for k, v in ipairs(getElementsByType("vehicle")) do
        if getElementData(v, "veh:id") == vehID then
            local model = getElementModel(v)
			if model == 497 then
				exports.oFactionScripts:detachServerSide(veh)
			end

            if getElementData(v, "veh:isFactionVehice") == 0 then 
                model = tonumber(model)
                if not existingVehicleModels[model] then 
                    existingVehicleModels[model] = 0
                end
                existingVehicleModels[model] = existingVehicleModels[model] - 1


                triggerClientEvent(root,"syncLimits",root, existingVehicleModels)
            end
            destroyElement(v)
            return
        end
    end

end

-- [Temporary vehicles] --
local tempVehCount = 0

function createTemporaryVehicle(modelID, pos, owner, plateText, alwaysLocked)
    tempVehCount = tempVehCount + 1

    local posX, posY, posZ, rotX, rotY, rotZ = unpack(pos)
    local plateText = plateText or ("T" .. tostring(tempVehCount))
    local removeTime = removeTime or 0

    local tVeh = createVehicle(modelID, posX, posY, posZ, rotX, rotY, rotZ, plateText)
    setElementData(tVeh, "vehicle:tempVeh:owner", owner)
    setElementData(tVeh, "vehicle:tempVeh:isTempVeh", true)
    setElementData(tVeh, "vehicle:tempVeh:removeTime", removeTime)
    setElementData(tVeh, "vehicle:tempVeh:vehIsAlwaysLocked", alwaysLocked)

    if alwaysLocked then
        setVehicleLocked(tVeh, true)
        setElementData(tVeh, "veh:locked", true)
    end


    -- a distanceToOilChange liter ben van megadva!


    setElementData(tVeh, "veh:fuel", getVehicleMaxFuel(modelID))
    setElementData(tVeh, "veh:maxFuel", getVehicleMaxFuel(modelID))
    setElementData(tVeh, "veh:fuelType", getVehicleModelFuelType(modelID))
    setElementData(tVeh, "veh:lastFuelType", getVehicleModelFuelType(modelID))
    setElementData(tVeh, "veh:wheelType", "S")
    setElementData(tVeh, "veh:distanceToOilChange", 15000)
    setElementData(tVeh, "veh:traveledDistance", 0)

    local ownerTempVehs = getElementData(owner, "vehicle:tempVehicles") or {}
    table.insert(ownerTempVehs, tVeh)
    setElementData(owner, "vehicle:tempVehicles", ownerTempVehs)

    return tVeh
end

function destroyTemporaryVehicle(vehicle)
    local owner = getElementData(vehicle, "vehicle:tempVeh:owner")

    if isElement(owner) then
        local tempVehTable = getElementData(owner, "vehicle:tempVehicles")

        for k, v in ipairs(tempVehTable) do
            if v == vehicle then
                table.remove(tempVehTable, k)
                break
            end
        end

        setElementData(owner, "vehicle:tempVehicles", tempVehTable)
    end

    destroyElement(vehicle)
end

------------[ Ajtó zárás, lámpa, motor ]----------
function setVehLocked(veh)
    if getElementData(veh, "veh:locked") then
        setElementData(veh, "veh:locked", false)
        setVehicleLocked(veh, false)
    else
        setElementData(veh, "veh:locked", true)
        setVehicleLocked(veh, true)
        for i=1, 5 do
			setVehicleDoorOpenRatio(veh, i, 0)
		end
	end

    lockLight(veh)
end
addEvent("setVehicleLocked", true)
addEventHandler("setVehicleLocked", resourceRoot, setVehLocked)

function setVehLampState(veh)
    if getElementData(veh, "veh:lamp") then
        setElementData(veh, "veh:lamp", false)
        setVehicleOverrideLights(veh, 1)
    else
        setElementData(veh, "veh:lamp", true)
        setVehicleOverrideLights(veh, 2)
    end
end
addEvent("setVehicleLamp", true)
addEventHandler("setVehicleLamp", root, setVehLampState)

function setVehEngine(veh)
    if getElementData(veh, "veh:engine") then
        setElementData(veh, "veh:engine", false)
        setVehicleEngineState(veh, false)
    else
        setElementData(veh, "veh:engine", true)
        setVehicleEngineState(veh, true)
    end
end
addEvent("setVehicleEngineOnServer", true)
addEventHandler("setVehicleEngineOnServer", resourceRoot, setVehEngine)

------------[ Egyéb funkciók ]------------
function vehicleLoadinAnimation(veh)
    if isElement(veh) then
        setElementData(veh, "veh:loading", true)
        setElementAlpha(veh, 0)
        setVehicleDamageProof(veh, true)
        setElementFrozen(veh, true)
        setElementCollisionsEnabled(veh, false)

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
                                    if isElement(veh) then
                                        setElementAlpha(veh, 255)
                                        setElementCollisionsEnabled(veh, true)
                                        setElementFrozen(veh, false)
                                        setVehicleDamageProof(veh, false)
                                        removeElementData(veh, "veh:loading")
                                    end
                                end, 1000, 1)
                            end, 1000, 1)
                        end, 1000, 1)
                    end, 1000, 1)
                end, 1000, 1)
            end, 1000, 1)
        end, 1000, 1)
    end

    --[[for i = 1, 255 do
        setTimer(function() if isElement(veh) then setElementAlpha(veh, i) end end, i*50, 1)
        if i == 255 then
            setVehicleDamageProof(veh, false)
            setElementFrozen(veh, false)
            setElementCollisionsEnabled(veh, true)
            setElementData(veh, "veh:loading", false)
        end
    end]]
end

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

addEvent("togglePlayerSeatbelt", true)
addEventHandler("togglePlayerSeatbelt", resourceRoot, function()
    local state = getElementData(client, "vehicle:seatbeltState") or false

    setElementData(client, "vehicle:seatbeltState", not state)
end)

------------[ Event handlerek ] ------------
addEventHandler("onVehicleDamage", root, function(dmg)
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
            infobox:outputInfoBox("Lerobbant a járműved!", "warning", driver)
            setElementData(source, "veh:broke", true)
        end
    end

    if getElementData(source, "veh:locked") then
        for i=1, 5 do
            setVehicleDoorOpenRatio(source, i, 0)
        end
    end

    if trailers[getElementModel(source)] then
       setElementHealth(source, 1000)
    end
end)

addEventHandler("onVehicleStartExit", root, function(player)
    if getElementData(source,"veh:locked") then
        infobox:outputInfoBox("Nem tudsz kiszállni, ameddig az ajtók zárva vannak!", "warning", player)
        cancelEvent()
    elseif getElementData(player, "vehicle:seatbeltState") then
        infobox:outputInfoBox("Nem tudsz kiszállni, ameddig a biztonsági öved be van kötve! [F5]", "warning", player)
        cancelEvent()
    end
end)

addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), function()
   loadAllVehicle()
end)



addEvent("loadPlayerVehicles", true)
addEventHandler("loadPlayerVehicles", getRootElement(),
	function (charID)
		loadPlayerVehicles(charID, source)
	end
)

addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), function()
    saveAllVehicle()
end)

addCommandHandler("saveallveh", function(player)
    if getElementData(player, "user:admin") >= 9 then
        saveAllVehicle()
    end
end)

setTimer(saveAllVehicle, core:minToMilisec(120), 0)

--- / Tuning / ---
addEventHandler("onVehicleEnter", root, function(player, seat)
    if seat == 0 then
        --outputChatBox(toJSON(getElementData(source, "veh:engineTunings")))
        exports.oTuning:applyVehicleTunings(source)
    end
end)
