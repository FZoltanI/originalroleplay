addEvent("setVehicleDoorsState",true)
addEventHandler("setVehicleDoorsState", root,
	function(vehicle,component,rotationType)
		if rotationType == 1 then 
			setVehicleDoorOpenRatio(vehicle, component, 0, 400)
		elseif rotationType == 2 then 
			setVehicleDoorOpenRatio(vehicle, component, 2, 400)
		end
	end 
)