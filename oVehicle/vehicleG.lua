core = exports.oCore
infobox = exports.oInfobox
chat = exports.oChat
admin = exports.oAdmin

color, r, g, b = core:getServerColor()

vehicleDatas = { -- Ez a tábla van használva minden exportba!!
	--[[
		name: jármű neve (Default: Nincs megadva)
		fuelType: üzemanyag típusa (95, D, electric) (Default: 95)
		tankSize: tankméret, max üzemanyag amit bele lehet tankolni (Default: 100)
		consumption: fogyasztás (Default: 1) minél nagyobb a szám annál többet fogyaszt
		safetyMultiplier: jármű biztonsága (Default: 1), ha kisebb a szám mint 1 akkor biztonságosabb az autó, ha nagyobb mint egy akkor több sebzést kap a játékos
		trunkSize: csomagtartó mérete (hány kg item fér bele) (Default: 50)
	]]	

	-- Üres modellek: 401, 419, 587, 533, 474, 545, 517, 600, 436, 439, 491, 466, 580, 550, 566, 529, 489, 458, 575, 567, 535, 576, 412, 603, 475, 434, 503, 561, 558, 555, 
	-- 477 érdekes


	[421] = {name = "Honda Civic Type R", fuelType = "95", tankSize = 100, consumption = 3, safetyMultiplier = 0.9, trunkSize = 100},
	[549] = {name = "BMW Series 5 E28", fuelType = "95", tankSize = 100, consumption = 4, safetyMultiplier = 0.7, trunkSize = 100},
	[400] = {name = "Range Rover Sport", fuelType = "D", tankSize = 125, consumption = 4.8, safetyMultiplier = 0.8, trunkSize = 100},
	[402] = {name = "Dodge Demon SRT", fuelType = "95", tankSize = 100, consumption = 5, safetyMultiplier = 0.9, trunkSize = 50}, 
	[404] = {name = "BMW M5 Touring", fuelType = "95", tankSize = 100, consumption = 3, safetyMultiplier = 1, trunkSize = 100}, 
	[405] = {name = "BMW M5 E34", fuelType = "95", tankSize = 100, consumption = 3.7, safetyMultiplier = 1, trunkSize = 50},
	[409] = {name = "Lincoln Towncar Limo", fuelType = "D", tankSize = 150, consumption = 5, safetyMultiplier = 1, trunkSize = 200},
	[410] = {name = "Mazda RX7", fuelType = "95", tankSize = 100, consumption = 4, safetyMultiplier = 1, trunkSize = 100},
	[411] = {name = "McLaren 720s", fuelType = "95", tankSize = 100, consumption = 4, safetyMultiplier = 0.7, trunkSize = 50}, 
	[415] = {name = "McLaren P1", fuelType = "95", tankSize = 100, consumption = 4, safetyMultiplier = 0.6, trunkSize = 50}, 
	[422] = {name = "Chevrolet C10", fuelType = "D", tankSize = 150, consumption = 3.8, safetyMultiplier = 1, trunkSize = 200}, 
	[442] = {name = "Mercedes-Benz G65", fuelType = "95", tankSize = 100, consumption = 4.4, safetyMultiplier = 1, trunkSize = 125}, 
	[445] = {name = "BMW M5 E60", fuelType = "95", tankSize = 100, consumption = 3, safetyMultiplier = 0.8, trunkSize = 100}, 
	[429] = {name = "Ferrari 250 GTO", fuelType = "95", tankSize = 100, consumption = 5, safetyMultiplier = 0.8, trunkSize = 100},
	[451] = {name = "Ferrari F40", fuelType = "95", tankSize = 100, consumption = 5, safetyMultiplier = 0.8, trunkSize = 100}, 
	[494] = {name = "Ford Mustang GT", fuelType = "95", tankSize = 100, consumption = 5.5, safetyMultiplier = 0.8, trunkSize = 100},
	[463] = {name = "Harley Davidson", fuelType = "95", tankSize = 50, consumption = 2, safetyMultiplier = 0.8, trunkSize = 20}, 
	[516] = {name = "Mercedes-Benz E63 AMG", fuelType = "95", tankSize = 100, consumption = 3, safetyMultiplier = 0.6, trunkSize = 100},  
	[506] = {name = "Lamborghini Huracan", fuelType = "95", tankSize = 100, consumption = 4, safetyMultiplier = 0.9, trunkSize = 100},
	[468] = {name = "Sanchez", fuelType = "95", tankSize = 50, consumption = 2, safetyMultiplier = 0.6, trunkSize = 20},
	[478] = {name = "Chevrolet Silverado", fuelType = "D", tankSize = 100, consumption = 4.2, safetyMultiplier = 1, trunkSize = 200}, 
	[479] = {name = "Mercedes-Benz AMG A45", fuelType = "D", tankSize = 100, consumption = 3, safetyMultiplier = 1, trunkSize = 200}, 
	[480] = {name = "Porsche Carrera S", fuelType = "95", tankSize = 100, consumption = 3, safetyMultiplier = 0.8, trunkSize = 50}, 
	[483] = {name = "Barcas", fuelType = "D", tankSize = 150, consumption = 7, safetyMultiplier = 1, trunkSize = 200}, 
	[492] = {name = "BMW M5 F10", fuelType = "95", tankSize = 100, consumption = 3, safetyMultiplier = 0.9, trunkSize = 100}, 
	[496] = {name = "Tesla Roadster", fuelType = "electric", tankSize = 100, consumption = 5, safetyMultiplier = 0.9, trunkSize = 100}, 
	[502] = {name = "Bugatti Chiron", fuelType = "95", tankSize = 100, consumption = 3, safetyMultiplier = 1, trunkSize = 100},
	[505] = {name = "Jeep Wangler", fuelType = "D", tankSize = 100, consumption = 5, safetyMultiplier = 0.6, trunkSize = 100}, 
	[507] = {name = "Mercedes-Benz E500", fuelType = "D", tankSize = 100, consumption = 3, safetyMultiplier = 1, trunkSize = 150}, 
	[477] = {name = "Mercedes-Benz 190E", fuelType = "D", tankSize = 100, consumption = 3, safetyMultiplier = 1, trunkSize = 150},
	[518] = {name = "Volkswagen Golf 7R", fuelType = "95", tankSize = 100, consumption = 2, safetyMultiplier = 0.8, trunkSize = 100},
	[526] = {name = "Ford Shelby GT500", fuelType = "95", tankSize = 100, consumption = 4.5, safetyMultiplier = 1, trunkSize = 100},
	[529] = {name = "Audi RS6", fuelType = "95", tankSize = 100, consumption = 3, safetyMultiplier = 1, trunkSize = 120}, 
	[534] = {name = "Ford Shelby GT500 Cobra", fuelType = "95", tankSize = 100, consumption = 5, safetyMultiplier = 1, trunkSize = 100}, 
	[536] = {name = "Dodge Coronet 440", fuelType = "95", tankSize = 100, consumption = 4.8, safetyMultiplier = 1, trunkSize = 100}, 
	[540] = {name = "Dodge Charger", fuelType = "95", tankSize = 100, consumption = 5, safetyMultiplier = 1, trunkSize = 100}, 
	[541] = {name = "Ferrari Scuderia F430", fuelType = "95", tankSize = 100, consumption = 4, safetyMultiplier = 1, trunkSize = 100}, 
	[542] = {name = "Pontiac Firebird", fuelType = "95", tankSize = 100, consumption = 4, safetyMultiplier = 1, trunkSize = 100}, 
	[546] = {name = "Tesla Model S", fuelType = "electric", tankSize = 100, consumption = 5, safetyMultiplier = 1, trunkSize = 100},
	[547] = {name = "Peugeot 406", fuelType = "95", tankSize = 100, consumption = 2, safetyMultiplier = 0.7, trunkSize = 100}, 
	[551] = {name = "Audi A8", fuelType = "D", tankSize = 100, consumption = 2.7, safetyMultiplier = 0.9, trunkSize = 150},
	[559] = {name = "Toyota Supra", fuelType = "95", tankSize = 100, consumption = 3, safetyMultiplier = 0.7, trunkSize = 100},
	[560] = {name = "Subaru Impreza WRX", fuelType = "95", tankSize = 100, consumption = 3, safetyMultiplier = 0.7, trunkSize = 100},
	[562] = {name = "Nissan Skyline", fuelType = "95", tankSize = 100, consumption = 3, safetyMultiplier = 0.7, trunkSize = 100},
	[565] = {name = "Ford Focus RS", fuelType = "95", tankSize = 100, consumption = 3, safetyMultiplier = 0.8, trunkSize = 50},
	[579] = {name = "Jeep Grand Cherokee", fuelType = "D", tankSize = 100, consumption = 4, safetyMultiplier = 1, trunkSize = 150},
	[458] = {name = "Mercedes-Benz E250", fuelType = "D", tankSize = 100, consumption = 3, safetyMultiplier = 0.7, trunkSize = 150},
	[586] = {name = "Harley Davidson", fuelType = "95", tankSize = 100, consumption = 2, safetyMultiplier = 0.7, trunkSize = 50},
	[581] = {name = "Suzuki Hayabusa", fuelType = "95", tankSize = 100, consumption = 2, safetyMultiplier = 0.7, trunkSize = 50},
	[596] = {name = "Ford Taurus", fuelType = "D", tankSize = 100, consumption = 3.2, safetyMultiplier = 1, trunkSize = 100}, 
	[490] = {name = "Ford Crown Victoria", fuelType = "D", tankSize = 100, consumption = 3, safetyMultiplier = 1, trunkSize = 100}, 
	[597] = {name = "Dodge Charger", fuelType = "95", tankSize = 100, consumption = 5, safetyMultiplier = 1, trunkSize = 100}, 
	[598] = {name = "Ford Interceptor", fuelType = "D", tankSize = 100, consumption = 5, safetyMultiplier = 1, trunkSize = 100}, 
	[599] = {name = "Mitsubishi Lancer", fuelType = "D", tankSize = 100, consumption = 4, safetyMultiplier = 1, trunkSize = 100},
	[602] = {name = "Nissan GTR-35", fuelType = "95", tankSize = 100, consumption = 4, safetyMultiplier = 0.8, trunkSize = 100},
	[416] = {name = "Mercedes-Benz Sprinter", fuelType = "D", tankSize = 100, consumption = 5, safetyMultiplier = 1, trunkSize = 150},
	[521] = {name = "Kawasaki Ninja", fuelType = "95", tankSize = 100, consumption = 2, safetyMultiplier = 0.7, trunkSize = 50},
	[525] = {name = "Chevrolet Silverado", fuelType = "D", tankSize = 100, consumption = 3, safetyMultiplier = 1, trunkSize = 150},
	[527] = {name = "Audi Sport Quattro", fuelType = "95", tankSize = 100, consumption = 3.5, safetyMultiplier = 1, trunkSize = 150},
	[604] = {name = "Cadillac Eldorado", fuelType = "95", tankSize = 100, consumption = 4, safetyMultiplier = 1, trunkSize = 150}, 
	[589] = {name = "Chevrolet Camaro ZL1", fuelType = "95", tankSize = 100, consumption = 5, safetyMultiplier = 0.8, trunkSize = 100},
	[543] = {name = "Dodge Ram", fuelType = "D", tankSize = 100, consumption = 5, safetyMultiplier = 1, trunkSize = 150},
	[487] = {name = "Maverick", fuelType = "95", tankSize = 100, consumption = 5, safetyMultiplier = 1, trunkSize = 150},
	[488] = {name = "Maibatsu Frogger", fuelType = "95", tankSize = 100, consumption = 5, safetyMultiplier = 1, trunkSize = 150},
	[469] = {name = "Sparrow", fuelType = "95", tankSize = 100, consumption = 5, safetyMultiplier = 1, trunkSize = 150},
	[454] = {name = "Sea Ray L650 Fly", fuelType = "95", tankSize = 100, consumption = 4, safetyMultiplier = 1, trunkSize = 200},
	[473] = {name = "Dinghy", fuelType = "95", tankSize = 100, consumption = 4, safetyMultiplier = 1, trunkSize = 100},
	[453] = {name = "Reefer", fuelType = "95", tankSize = 100, consumption = 3, safetyMultiplier = 1, trunkSize = 200},
	[493] = {name = "Jetmax", fuelType = "95", tankSize = 100, consumption = 5, safetyMultiplier = 1, trunkSize = 100},
	[498] = {name = "Grumman Kurbmaster", fuelType = "D", tankSize = 150, consumption = 6, safetyMultiplier = 1, trunkSize = 200},
	[427] = {name = "Taktikai Teherautó", fuelType = "D", tankSize = 150, consumption = 1, safetyMultiplier = 1, trunkSize = 200},
	[566] = {name = "Mercedes-Benz GT63 S", fuelType = "95", tankSize = 100, consumption = 3, safetyMultiplier = 0.8, trunkSize = 100},
	[550] = {name = "Lamborghini Urus", fuelType = "95", tankSize = 100, consumption = 3, safetyMultiplier = 0.8, trunkSize = 100},
	[497] = {name = "Police Maverick", fuelType = "95", tankSize = 100, consumption = 4, safetyMultiplier = 1, trunkSize = 150},
	[489] = {name = "Ford Raptor", fuelType = "D", tankSize = 100, consumption = 5, safetyMultiplier = 1, trunkSize = 100}, 
	[587] = {name = "Porsche 911", fuelType = "95", tankSize = 100, consumption = 3, safetyMultiplier = 1, trunkSize = 100}, 
	[585] = {name = "Audi e-tron", fuelType = "electric", tankSize = 100, consumption = 2.8, safetyMultiplier = 1, trunkSize = 80}, 
	--[426] = {name = "Audi Etron", fuelType = "electric", tankSize = 100, consumption = 5, safetyMultiplier = 1, trunkSize = 100},  
	[426] = {name = "Audi RS4", fuelType = "95", tankSize = 100, consumption = 3, safetyMultiplier = 1, trunkSize = 100}, -- CSEREKOR EZT KIKOMMENTELED A MÁSIKAT MEG VISSZA!
	[466] = {name = "Chrysler 300C", fuelType = "95", tankSize = 80, consumption = 2, safetyMultiplier = 1, trunkSize = 50}, 
	[467] = {name = "Chrysler Town", fuelType = "95", tankSize = 100, consumption = 3, safetyMultiplier = 0.9, trunkSize = 100}, 
}

--[[vehicleNames = {

	-- Csúcskategória
	[415] = "McLaren P1",
	[411] = "McLaren 720s",
	[451] = "Ferrari F40", -- PP
	[429] = "Ferrari 250 GTO", -- PP
	[480] = "Porsche Carrera S",
	[496] = "Tesla Roadster Sport",
	[541] = "Ferrari Scuderia F430",
	[502] = "Bugatti Veyron",
	[602] = "Nissan GTR-35",
	[589] = "Chevrolet Camaro ZL1",
	[494] = "Ford Mustang GT",
	[506] = "Lamborghini Huracan",

	-- Felsőkategória
	[402] = "Dodge Demon SRT",
	[426] = "Audi RS4",
	[442] = "Mercedes-Benz G65",
	[445] = "BMW M5 E60",
	[400] = "Range Rover Sport",
	[404] = "BMW M5 Touring",
	[492] = "BMW M5 F10",
	[516] = "Mercedes-Benz E63 AMG",
	[526] = "Ford Shelby GT500",
	[546] = "Tesla Model S",
	[579] = "Jeep Grand Cherokee",
	[421] = "Honda Civic Type R",

	-- Középkategória
	[405] = "BMW M5 E34",
	[409] = "Lincoln Towncar Limo",
	[410] = "Mazda RX7",
	[479] = "Mercedes-Benz A45 AMG",
	[478] = "Chevrolet Silverado",
	[507] = "Mercedes-Benz E500",
	[518] = "Volkswagen Golf 7R",
	[551] = "Audi A8",
	[559] = "Toyota Supra",
	[560] = "Subaru Impreza WRX STI",
	[562] = "Nissan Skyline GTR-34",
	[565] = "Ford Focus RS",
	[585] = "Mercedes-Benz E250",
	[549] = "BMW Series 5 E28",

	-- Alsókategória
	[467] = "Lada 1207",
	[422] = "Chevrolet C10",
	[483] = "Barcas",
	[505] = "Jeep Wangler",
	[534] = "Ford Shelby GT500 Cobra",
	[536] = "Dodge Coronet 440",
	[540] = "Dodge Charger",
	[542] = "Pontiac Firebird",
	[547] = "Volkswagen Bora",
	[527] = "Audi Sport Quattro",
	[604] = "Eldorado", 

	-- Motorok
	[463] = "Harley Davidson",
	[468] = "Sanchez",
	[586] = "Harley Davidson", -- alacsonyabb kormányos
	[521] = "Kawasaki Ninja",

	-- Egyéb
	[525] = "Chevrolet Silverado",

	[475] = "NINCS MODEL",
	[529] = "NINCS MODEL",
	[550] = "Üres",

	-- Legális frakcióautók

	[596] = "Opel Astra",
	[598] = "Skoda Superb",
	[416] = "Mercedes-Benz Sprinter",
	[599] = "Nincs model PD",

	-- Biciklik

	[509] = "Kerékpár",
	[481] = "BMX",
	[510] = "Mountain Bike",

	-- Helikopterek

	[487] = "Maverick",
	[469] = "Sparrow",
	[488] = "Maibatsu Frogger",

	-- Hajók

	[454] = "Sea Ray L650 Fly",
	[473] = "Dinghy",
	[453] = "Reefer",
	[498] = "Grumman Kurbmaster",
}]]

electric_cars = {
	[496] = true, 
	[546] = true, 
	[585] = true,
}

function isElectricCar(model) 
	if electric_cars[model] then return true else return false end
end

bikes = {
	[509] = true,
	[481] = true,
	[510] = true,
}

nonLockableVehicles = {
	[594] = true,
	[606] = true,
	[607] = true,
	[611] = true,
	[584] = true,
	[608] = true,
	[435] = true,
	[450] = true,
	[591] = true,
	[539] = true,
	[441] = true,
	[464] = true,
	[501] = true,
	[465] = true,
	[564] = true,
	[472] = true,
	[473] = true,
	[493] = true,
	[595] = true,
	[484] = true,
	[430] = true,
	[453] = true,
	[452] = true,
	[446] = true,
	[454] = true,
	[581] = true,
	[509] = true,
	[481] = true,
	[462] = true,
	[521] = true,
	[463] = true,
	[510] = true,
	[522] = true,
	[461] = true,
	[448] = true,
	[468] = true,
	[586] = true,
	[425] = true,
	[520] = true,
}

trailers = {
	[606] = true,
	[607] = true,
}

doorComponents = {
    {"bonnet_dummy", 0, "motorháztető"},
    {"boot_dummy", 1, "csomagtartó"},
    {"door_lf_dummy", 2, "bal első"},
    {"door_rf_dummy", 3, "jobb első"},
    {"door_lr_dummy", 4, "bal hátsó"},
    {"door_rr_dummy", 5, "jobb hátsó"},
}

function getVehicleModelFuelType(modelID) 
	if vehicleDatas[modelID] and vehicleDatas[modelID].fuelType then
		return vehicleDatas[modelID].fuelType
	else
		return "95"
	end
end

function getVehicleConsumption(modelID)
	if vehicleDatas[modelID] and vehicleDatas[modelID].consumption then
		return vehicleDatas[modelID].consumption
	else
		return 1
	end
end

function getVehicleSafetyMultiplier(modelID)
	if vehicleDatas[modelID] and vehicleDatas[modelID].safetyMultiplier then
		return vehicleDatas[modelID].safetyMultiplier
	else
		return 1
	end
end

function getVehicleMaxFuel(modelID)
	if vehicleDatas[modelID] and vehicleDatas[modelID].tankSize then
		return vehicleDatas[modelID].tankSize
	else
		return 100
	end
end

function getModdedVehicleName(veh)

	if isElement(veh) then 
		local vehid = getElementModel(veh)
		
		if vehicleDatas[vehid] then 
			return  vehicleDatas[vehid].name
		else 
			return getVehicleName(veh)
		end
	else
		return vehicleDatas[vehid].name or "Nincs adat!"
	end
	
end

function getModdedVehName(modelID)
	if vehicleDatas[modelID] and vehicleDatas[modelID].name then
		return vehicleDatas[modelID].name
	else
		return "nincs adat"
	end
end

function getVehicleTrunkMaxSize(modelID)
	if vehicleDatas[modelID] and vehicleDatas[modelID].trunkSize then
		return vehicleDatas[modelID].trunkSize
	else
		return 50
	end
end

-- vehicle sit vehicles 
vehicleSitList = {
	[454] = { -- 10 férőhely + 1 (sofőr)
		-- x, y, z, sit-rot 
		{1, -6.3, 0.8, 0},
		{-1, -6.3, 0.8, 0},

		{1.4, -5, 3.4, -90},
		{-0.5, -5, 3.4, 90},
		{0.5, -5.8, 3.4, 0},

		{0.8, -3, 3.4, 180},

		{1.7, -2, 1, -90},
		{0.5, -0.4, 1, 180},

		{-1.6, -1, 1, 90},
		{-1.6, -2, 1, 90},
	},

	[473] = { -- 3 férőhely + 1 (sofőr)
		-- x, y, z, sit-rot 
		{0.35, -0.6, 1.2, 0},
		{0.35, -1.7, 1.2, 0},
		{-0.35, -1.7, 1.2, 0},
	},
}

function createRandomPlateText()

    local plateText = ""

    for i = 1, 7 do 
		if i == 1 then 
			plateText = plateText .. tostring(math.random(1,9))
		elseif i >= 2 and i <= 4 then 
            plateText = plateText .. string.char(math.random(65, 90))
        elseif i >= 5 then
            plateText = plateText .. tostring(math.random(0,9))
        end
    end
	return plateText
	
end

function RGBToHex(red, green, blue, alpha)
	
	-- Make sure RGB values passed to this function are correct
	if( ( red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255 ) or ( alpha and ( alpha < 0 or alpha > 255 ) ) ) then
		return nil
	end

	-- Alpha check
	if alpha then
		return string.format("#%.2X%.2X%.2X%.2X", red, green, blue, alpha)
	else
		return string.format("#%.2X%.2X%.2X", red, green, blue)
	end

end

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

function vehicleOwnerIsOnline(ownerID)
	local online = false 

	for k, v in ipairs(getElementsByType("player")) do 
		if getElementData(v, "char:id") == ownerID then 
			online = true 
			break
		end
	end

	return online
end

function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end