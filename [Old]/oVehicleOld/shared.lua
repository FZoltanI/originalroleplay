core = exports.oCore
color, r, g, b = core:getServerColor()

function getNearestVehicle(player,distance)
	local tempTable = {}
	local lastMinDis = distance-0.0001
	local nearestVeh = false
	local px,py,pz = getElementPosition(player)
	local pint = getElementInterior(player)
	local pdim = getElementDimension(player)

	for _,v in pairs(getElementsByType("vehicle")) do
		local vint,vdim = getElementInterior(v),getElementDimension(v)
		if vint == pint and vdim == pdim then
			local vx,vy,vz = getElementPosition(v)
			local dis = getDistanceBetweenPoints3D(px,py,pz,vx,vy,vz)
			if dis < distance then
				if dis < lastMinDis then 
					lastMinDis = dis
					nearestVeh = v
				end
			end
		end
	end
	return nearestVeh
end

vehicleNames = {
	[400] = "Range Rover Sport",
	[402] = "Pontiac",
	[404] = "Chevrolet Suburban Z11",
	[405] = "Jaguar XF",
	[410] = "Ford Pinto Runabout",
	[429] = "Aston Martin",
	[445] = "BMW M5 E60",
	[451] = "Meclaren P1",
	[483] = "Barcas",
	[492] = "BMW M5 F10",
	[507] = "Mercedes-Benz 300SEL",
	[521] = "Valamimotor",
	[547] = "Cadilac Fletwood",
	[565] = "AMC Gremlin X V8",
	[579] = "Cadilac Escade",
	[580] = "Audi RS4",
	[585] = "Ford Crown Victoria",

	[596] = "Dodge Charger SRT8 Police",
	[598] = "Ford Crown Victoria Police",
	[599] = "Ford Exploler Police",

	[602] = "Nissan GTR",
}

function getModdedVehicleName(veh)
	local vehid = getElementModel(veh)
	if vehicleNames[vehid] then 
		return vehicleNames[vehid]
	else 
		return getVehicleName(veh)
	end
end