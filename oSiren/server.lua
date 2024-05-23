addEvent("onClientSirensOn", true)
addEventHandler("onClientSirensOn", getRootElement(), function(type)
	local m_car = getPedOccupiedVehicle(client)
	local neededSirens = sirens[getElementModel(m_car)][type] or false

	if neededSirens then 
		removeVehicleSirens(m_car)

		addVehicleSirens(m_car, #neededSirens, 2, false, false, true, true)
		--outputChatBox("create")
		for k, v in pairs(neededSirens) do 
			--outputChatBox(k)
			setVehicleSirens(m_car, k, v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[7])
		end

		setVehicleSirensOn(m_car, false)
		setVehicleSirensOn(m_car, true)
	end
end)

addEvent("onClientSirensOff", true)
addEventHandler("onClientSirensOff", getRootElement(),
	function()
		m_car = getPedOccupiedVehicle(client)
		removeVehicleSirens(m_car)
end)

addEvent("siren > setVehicleSirenSound", true)
addEventHandler("siren > setVehicleSirenSound", resourceRoot, function(veh, sound, loop)
	if getElementData(veh, "sirenData") then 
		setElementData(veh, "sirenData", false)
	else
		setElementData(veh, "sirenData", false)
		setElementData(veh, "sirenData", {sound, loop})
	end
end)

addEvent("siren > playVehicleHornSound", true)
addEventHandler("siren > playVehicleHornSound", resourceRoot, function(veh)
	triggerClientEvent(root, "siren > playVehicleHornSoundClient", root, veh)
end)

-- P betű villogó
local flashedCars = {[427]=true, [596]=true, [598]=true, [597]=true, [599]=true, [490]=true, [416]=true}

for k, v in pairs(getElementsByType("vehicle")) do
	setElementData(v, "flasher_blue", false)
	vehicleModelID = getElementModel(v)
	if flashedCars[vehicleModelID] then
		setElementData(v, "flasher_blue", true)
	end
end

addEventHandler("onVehicleEnter", root, function(player, seat)
    if seat == 0 then
    	vehicleModelID = getElementModel(source)
    	if flashedCars[vehicleModelID] and not getElementData(source, "flasher_blue") then
	      	setElementData(source, "flasher_blue", true)
	    end
    end
end)

function vehicleBlown()
	setElementData(source, "pd_flashers", nil, true)
end
addEventHandler("onVehicleRespawn", getRootElement(), vehicleBlown)

function toggleFlasherState()
	if not (client) then
		return false
	end
	local theVehicle = getPedOccupiedVehicle(client)
	if not theVehicle then
		return false
	end
	
	if (theVehicle) then
		local vehicleModelID = getElementModel(theVehicle)
		local currentFlasherState = getElementData(theVehicle, "pd_flashers") or 0
		
		if getElementData(theVehicle, "flasher_blue") then
			setElementData(theVehicle, "pd_flashers", 1-currentFlasherState, true)
		else
			setElementData(theVehicle, "pd_flashers", 0, true)
		end
	end
end
addEvent( "pd:toggleFlashers", true )
addEventHandler( "pd:toggleFlashers", getRootElement(), toggleFlasherState )

addCommandHandler("debugsiren", function(thePlayer)
	if getElementData(thePlayer,"user:admin") >= 7 then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle then
			setElementData(v, "flasher_blue", true)
		end
	end
end)