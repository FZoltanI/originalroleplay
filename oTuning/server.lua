--[[addCommandHandler("scs", function(player, cmd)
    local defFlags = tostring(getVehicleHandling(getPedOccupiedVehicle(player))["handlingFlags"])

    print(defFlags)

    local flags = {}

    for i = 1, string.len(tostring(defFlags)) do 
        table.insert(flags, defFlags:sub(i, i))
    end

    flags[3] = "4" 
    flags[4] = "4" 
    flags[6] = "7" 

    defFlags = ""

    for k, v in ipairs(flags) do 
        defFlags = defFlags .. v 
    end

    defFlags = tonumber(defFlags)

    print(defFlags)
    
    setVehicleHandling(getPedOccupiedVehicle(player), "handlingFlags", tonumber(defFlags))
end)]]

local tunings = {}
function createTunings() 
    for k, v in ipairs(tuning_poses) do 
        local marker = cmarker:createCustomMarkerServer(v[1], v[2], v[3], 10, 245, 84, 66, 255, _, "circle")
        setElementData(marker, "tuning:rot", v[4])
        table.insert(tunings, marker)
        setElementData(marker, "isTuningMarker", true)
        setElementData(marker, "tuningMarkerId", k)
    end
end

addEventHandler("onResourceStart", resourceRoot, createTunings)
addEventHandler("onResourceStop", resourceRoot, function()
    for k, v in ipairs(tunings) do 
        if isElement(v) then 
            destroyElement(v)
        end
    end
end)

local markerTimer = {}

addEvent("tuning > goToMarker", true)
addEventHandler("tuning > goToMarker", resourceRoot, function(marker)
    setElementFrozen(client, true)

    local veh = getPedOccupiedVehicle(client)
    setElementFrozen(veh, true)
    for k, v in pairs(toggledControlls) do
        toggleControl(client, v, false)
    end
    
    local pos = Vector3(getElementPosition(marker))
    local _, _, cZ = getElementPosition(veh)

    setElementData(veh, "tuningMarker:DefID", getElementData(marker, "tuningMarkerId"))
    setElementPosition(veh, pos.x, pos.y, cZ)
    setElementRotation(veh, 0, 0, getElementData(marker, "tuning:rot"))
    setElementData(veh,"tuningMarker",marker)
    setElementData(marker,"tuningMarkerInUse",true)
    --destroyElement(marker)
    --setElementAlpha(marker,0)
    setElementData(marker,"showCustomMarker",false)
    player = client
    marker = marker

    markerTimer[marker] = setTimer(function()
        triggerClientEvent(player,"quitWhenCrash",player)
        setElementData(marker,"tuningMarkerInUse",false)
        setElementData(marker,"showCustomMarker",true)
        
    end,1800000,1) --1800000

end)

addEvent("tuning > quitFromMarker", true)
addEventHandler("tuning > quitFromMarker", resourceRoot, function(veh)
    setElementFrozen(client, false)

    setElementFrozen(veh, false)

    for k, v in pairs(toggledControlls) do
        toggleControl(client, v, true)
    end

    local defID = getElementData(veh, "tuningMarker:DefID")
    local marker = getElementData(veh,"tuningMarker")
    --setElementAlpha(marker,255)
    setElementData(marker,"tuningMarkerInUse",false)
    setElementData(marker,"showCustomMarker",true)
    if isTimer(markerTimer[marker]) then killTimer(markerTimer[marker]) end
    player = nil
    marker = nil
end)

addEvent("tuning > updateVehicleTuningsTable", true)
addEventHandler("tuning > updateVehicleTuningsTable", resourceRoot, function(type, vehicle, table)
    if type == "engine" then 
        setElementData(vehicle, "veh:"..type.."Tunings", table)
        applyVehicleTunings(vehicle)
    elseif type == "paint" then 
        setVehicleColor(vehicle, table[1], table[2], table[3], table[4], table[5], table[6], table[7], table[8], table[9], table[10], table[11], table[12])
        setVehicleHeadLightColor(vehicle, table[13], table[14], table[15])
    elseif type == "wheel" then 
        local wheelNow = getElementData(vehicle, "veh:tuningWheel") or 0 

        if wheelNow > 0 then 
            removeVehicleUpgrade(vehicle, wheelNow)
        end

        addVehicleUpgrade(vehicle, table)
        setElementData(vehicle, "veh:tuningWheel", table)
    elseif type == "spoiler" then 
        local wheelNow = getElementData(vehicle, "veh:tuning:spoiler") or 0 

        if wheelNow > 0 then 
            removeVehicleUpgrade(vehicle, wheelNow)
        end

        addVehicleUpgrade(vehicle, table)
        setElementData(vehicle, "veh:tuning:spoiler", table)
    elseif type == "customOpticTuning" then 
        local upgradeNow = getElementData(vehicle, "veh:tuning:"..table[1]) or 0 

        if upgradeNow > 0 then 
            removeVehicleUpgrade(vehicle, upgradeNow)
        end

        addVehicleUpgrade(vehicle, table[2])
        setElementData(vehicle, "veh:tuning:"..table[1], table[2])
    elseif type == "paintjob" then 
        setElementData(vehicle, "veh:paintjob", table)
    elseif type == "neon" then
        setElementData(vehicle, "veh:neon:id", table) 
    elseif type == "airride" then
        setElementData(vehicle, "veh:tuning:airride", table) 
    elseif type == "variant" then 
        setElementData(vehicle, "tuning:vehVariant", table)
        setVehicleVariant(vehicle, unpack(table))
    elseif type == "horn" then 
        setElementData(vehicle, "veh:customHorn", table)
    elseif type == "supercharger" then 
        setElementData(vehicle, "veh:sc", table)
    end
end)

addEvent("tuning > updatePlayerMoney", true)
addEventHandler("tuning > updatePlayerMoney", resourceRoot, function(type, money)
    setElementData(client, type, getElementData(client, type) - money)
end)

function applyVehicleTunings(veh)
    --exports.oHandling:resetHandling(veh)
    exports.oHandling:loadHandling(veh)

    local vehTunings = getElementData(veh, "veh:engineTunings")

    if vehTunings then 
        --if vehTunings[1] then 
            for k, v in pairs(vehTunings) do 
                if tuning_modifiers[v] then 
                    local handlingNow = getVehicleHandling(veh)
                    for k2, v2 in pairs(tuning_modifiers[v]) do 

                        if tonumber(v2[2]) then 
                            --outputChatBox(tostring(v2[1])..": "..tostring(handlingNow[v2[1]]).." > "..tostring(handlingNow[v2[1]] + tonumber(v2[2])))
                            setVehicleHandling(veh, v2[1], handlingNow[v2[1]]+v2[2])
                        else
                            --outputChatBox(tostring(v2[1])..": "..tostring(handlingNow[v2[1]]).." > "..v2[2])
                            setVehicleHandling(veh, v2[1], v2[2])
                        end
                    end
                end
            end
        --end
    end
end

function vehicleWheelWidth(vehicle, side, type)
	if vehicle then
		if type then
			if type == "verynarrow" then type = 1
				elseif type == "narrow" then type = 2
				elseif type == "wide" then type = 4
				elseif type == "verywide" then type = 8
				elseif type == "default" then type = 0
			end
            --print(type)
			if side then
				if side == "front" then
					setVehicleHandlingFlags(vehicle, 3, type)
				elseif side == "rear" then
					setVehicleHandlingFlags(vehicle, 4, type)
				else
					setVehicleHandlingFlags(vehicle, {3, 4}, type)
				end
			else
				setVehicleHandlingFlags(vehicle, {3, 4}, type)
			end
		else
			setVehicleHandlingFlags(vehicle, {3, 4}, 0)
		end
	end
end
addEvent("tuning:vehicleWheelWidth", true)
addEventHandler("tuning:vehicleWheelWidth", root, vehicleWheelWidth)

function setVehicleHandlingFlags(vehicle, byte, value)
	if vehicle then
        exports.oHandling:loadHandling(vehicle)
		local handlingFlags = string.format("%X", getVehicleHandling(vehicle)["handlingFlags"])
		local reversedFlags = string.reverse(handlingFlags) .. string.rep("0", 8 - string.len(handlingFlags))
		local currentByte, flags = 1, ""

		for values in string.gmatch(reversedFlags, ".") do
			if type(byte) == "table" then
				for _, v in ipairs(byte) do
					if currentByte == v then
						values = string.format("%X", tonumber(value))
					end
				end
			else
				if currentByte == byte then
					values = string.format("%X", tonumber(value))
				end
			end

			flags = flags .. values
			currentByte = currentByte + 1
		end

		setVehicleHandling(vehicle, "handlingFlags", tonumber("0x" .. string.reverse(flags)), false)
	end
end

addEvent("tuning > setCustomPlateText", true)
addEventHandler("tuning > setCustomPlateText", resourceRoot, function(vehicle, plateText) 
    if not (client and vehicle) then return end

    local qh = dbQuery(exports.oMysql:getDBConnection(), "SELECT * FROM vehicles WHERE plateText = ?", plateText)
    local result = dbPoll(qh, 200)
    
    if #result <= 0 then 
        infobox:outputInfoBox("Sikeresen megváltoztattad a járműved rendszámát!", "success", client)
        setElementData(client, "char:pp", getElementData(client, "char:pp")-1000)
        setVehiclePlateText(vehicle, plateText)
    else
        infobox:outputInfoBox("Ez a rendszám már használatban van!", "error", client)
    end
end)