local enteredMarkerData = {}

addEventHandler("onResourceStart", resourceRoot, function()
	for i = 1, #availableTuningMarkers do
		local currentTuning = availableTuningMarkers[i]
		
		if currentTuning then
			local tuningMarker = createMarker(currentTuning[1], currentTuning[2], currentTuning[3] - 1, "cylinder", 2.5, r, g, b, 100)
			
			setElementData(tuningMarker, "tuningMarkerSettings", {true, currentTuning[4]})
			
			addEventHandler("onMarkerHit", tuningMarker, hitTuningMarker)
		end
	end
end)


function hitTuningMarker(element)
	if isElement(element) then
		if getElementType(element) == "vehicle" then
			if getVehicleController(element) then
				local vehicleController = getVehicleController(element)
				local markerX, markerY, markerZ = getElementPosition(source)
				local markerRotation = getElementData(source, "tuningMarkerSettings")[2] or 0
				
				enteredMarkerData[vehicleController] = {source, element}
				
				setElementFrozen(element, true)
				setVehicleDamageProof(element, true)
				setElementPosition(element, markerX, markerY, markerZ + 1)
				setElementRotation(element, 0, 0, markerRotation)
				
				setElementDimension(source, 65535)
				
				--triggerClientEvent(vehicleController, "showTuning", vehicleController, element)
			end
		end
	end
end

function resetTuningMarker(player)
	if player then
		if enteredMarkerData[player] then
			setElementDimension(enteredMarkerData[player][1], 0)
			
			setElementFrozen(enteredMarkerData[player][2], false)
			setVehicleDamageProof(enteredMarkerData[player][2], false)
		
			enteredMarkerData[player] = nil
		end
	end
end