local core = exports.oCore;

for i,player in pairs(getElementsByType("player")) do
	setElementData(player, "kresz", 4);
	setElementData(player, "doing", false);
	setElementData(player, "basic", 1);	
	setElementData(player, "islicence", true)
end

local colshaphes = {
	[1] = {createColCuboid ( 1304.6, -859.2, 38.58, 3.3, 7, 3), 1306.1, -855.5, 38.58, 0},
	[2] = {createColCuboid ( 1308.1, -859.2, 38.58, 3.3, 7, 3), 1309.6, -855.5, 38.58, 0},
	[3] = {createColCuboid ( 1311.6, -859.2, 38.58, 3.3, 7, 3), 1313.1, -855.5, 38.58, 0},
	[4] = {createColCuboid ( 1315.1, -860.2, 38.58, 3.3, 7, 3), 1316.6, -856.5, 38.58, 0},
	[5] = {createColCuboid ( 1318.6, -860.2, 38.58, 3.3, 7, 3), 1320.1, -856.5, 38.58, 0},
	[6] = {createColCuboid ( 1322.1, -861.2, 38.58, 3.3, 7, 3), 1323.6, -857.5, 38.58, 0},
	[7] = {createColCuboid ( 1325.6, -861.2, 38.58, 3.3, 7, 3), 1327.1, -857.5, 38.58, 0},
	[8] = {createColCuboid ( 1329.1, -861.2, 38.58, 3.3, 7, 3), 1330.6, -857.5, 38.58, 0},
};

addEvent("ocarlicences:pay", true);
addEventHandler("ocarlicences:pay", root,
	function(player, osszeg)
	local pMoney = getElementData(player,"char:money");	
		if (pMoney >= osszeg) then	
			setElementData(player, "char:money", pMoney - osszeg);
		end	
	end
);

addEvent("success", true);
addEventHandler("success", root,
	function(thePlayer)
		setElementData(thePlayer, "kresz", 4);
	end
);

addEvent("failure", true);
addEventHandler("failure", root,
	function(thePlayer)
	local kresz = getElementData(thePlayer, "kresz") or 0;
		if (kresz < 1) then
			setElementData(thePlayer, "kresz", 1);
		elseif (kresz < 2) then
			setElementData(thePlayer, "kresz", 2);
		elseif(kresz < 3) then
			setElementData(thePlayer, "kresz", 3);
		end	
	end
);

addEvent("drivetest", true);
addEventHandler("drivetest", root,
	function (thePlayer)
	local pMoney = getElementData(thePlayer,"char:money");
		if (pMoney >= 1000) then
		local isVehicle = false;		
			for i, spots in pairs(colshaphes) do
			local carisinSpot = getElementsWithinColShape(spots[1], "vehicle");
				if (#carisinSpot == 0) then	
				    local vehicle = createVehicle(585, spots[2], spots[3], spots[4], spots[5]);
				    local max = exports.oVehicle:getVehicleMaxFuel(vehID)
				    setElementData(vehicle, "veh:maxFuel", max);
				    setElementData(vehicle, "veh:fuel", max);
				    setElementData(vehicle, "veh:traveledDistance", 0);
				    exports.oHandling:loadHandling(vehicle);			
				    warpPedIntoVehicle(thePlayer, vehicle, 0);
				    setElementData(thePlayer, "doing", true);
				    local ped = createPed(120, 0, 0, 0);
				    setElementData(vehicle, "veh:fuel", 100);
				    warpPedIntoVehicle(ped, vehicle, 1);
				    setElementData(vehicle, "drivecar", true);
				    setElementData(thePlayer, "thecar", vehicle);
				    setElementData(ped, "ped:name", "Huana Alex");			
				    setElementData(ped, "ped:prefix", "Oktató");
				    setElementData(ped, "vehicle:seatbeltState", true);
				    setElementData(thePlayer, "theped", ped);
				    setElementData(vehicle, "theDrive", thePlayer);
				    isVehicle = true;
				    break;
				end	
			end
			if not (isVehicle) then
				    local vehicle = createVehicle(585, 0, 0, 0);
				    setElementPosition(vehicle, 1322.7491455078, -872.16082763672, 39.578125);
				    local max = exports.oVehicle:getVehicleMaxFuel(vehID)
				    setElementData(vehicle, "veh:maxFuel", max);
				    setElementData(vehicle, "veh:fuel", max);
				    setElementData(vehicle, "veh:traveledDistance", 0);
				    exports.oHandling:loadHandling(vehicle);			
				    warpPedIntoVehicle(thePlayer, vehicle, 0);
				    setElementData(thePlayer, "doing", true);
				    local ped = createPed(120, 0, 0, 0);
				    setElementData(vehicle, "veh:fuel", 100);
				    warpPedIntoVehicle(ped, vehicle, 1);
				    setElementData(vehicle, "drivecar", true);
				    setElementData(thePlayer, "thecar", vehicle);
				    setElementData(ped, "ped:name", "Huana Alex");			
				    setElementData(ped, "ped:prefix", "Oktató");
				    setElementData(ped, "vehicle:seatbeltState", true);
				    setElementData(thePlayer, "theped", ped);
				    setElementData(vehicle, "theDrive", thePlayer);
				    isVehicle = true;	
			end	    
		end		
	end
);

addEvent("drivetestout", true);
addEventHandler("drivetestout", root,
	function (thePlayer)
	local vehicle = getElementData(thePlayer, "thecar");	
	local vHealth = getElementHealth(vehicle);
	local ped = getElementData(thePlayer, "theped");
	setElementPosition(thePlayer, 1332.7379150391, -871.67810058594, 39.578125);
	setElementPosition(vehicle, 1332.7379150391, -871.67810058594, 39.578125);
	setElementData(vehicle, "drivecar", false);	
	destroyElement(ped);
	destroyElement(vehicle);
	setElementData(thePlayer, "doing", false);
		if not(vHealth < 900) then
			setElementData(thePlayer, "basic", 1);
			setElementData(thePlayer, "newlicence", true);
			outputChatBox(core:getServerPrefix("green-dark", "Oktató", 3).. "Gratulálunk sikeresen átmentél a rutin vizsgán!",thePlayer , 0, 0, 0, true);
		else
			outputChatBox(core:getServerPrefix("red-dark", "Oktató", 3).. "Sajnáljuk,de a járműved állapota 90% alatt van,ezért nem sikerült átmenned a vizsgán.",thePlayer , 0, 0, 0, true);
		end	
	end
);

addEvent("drivetestout2", true);
addEventHandler("drivetestout2", root,
	function (thePlayer)
	local vehicle = getElementData(thePlayer, "thecar");	
	local vHealth = getElementHealth(vehicle);
	local ped = getElementData(thePlayer, "theped");
	setElementPosition(thePlayer, 1332.7379150391, -871.67810058594, 39.578125);
	setElementPosition(vehicle, 1332.7379150391, -871.67810058594, 39.578125);
	setElementData(vehicle, "drivecar", false);	
	destroyElement(ped);
	destroyElement(vehicle);
	setElementData(thePlayer, "doing", false);
		if not(vHealth < 900) then
			setElementData(thePlayer, "newlicence", true);
			outputChatBox(core:getServerPrefix("green-dark", "Oktató", 3).. "Gratulálunk sikeresen átmentél a vizsgán! Menj az önkmányirodába és vedd át az új jogosítványodat.",thePlayer , 0, 0, 0, true);
		else
			outputChatBox(core:getServerPrefix("red-dark", "Oktató", 3).. "Sajnáljuk,de a járműved állapota 90% alatt van,ezért nem sikerült átmenned a vizsgán.",thePlayer , 0, 0, 0, true);
		end	
	end
);

addEventHandler("onVehicleDamage", root,
	function()	
	local data = getElementData(source, "drivecar") or false;	
		if (data) then
		local vHealth = getElementHealth(source);
		local thePlayer = getElementData(source, "theDrive");
		local ped = getElementData(thePlayer, "theped");
			if (vHealth < 500) then
				setElementPosition(thePlayer, 1332.7379150391, -871.67810058594, 39.578125);
				setElementPosition(source, 1332.7379150391, -871.67810058594, 39.578125);
				local pMoney = getElementData(thePlayer,"char:money");
				setElementData(thePlayer, "char:money", pMoney - 1000);		
				setElementData(source, "drivecar", false);
				setElementData(thePlayer, "doing", false);
				setElementData(thePlayer, "theped", false);
				setElementData(source, "theDrive", false);	
				setElementData(thePlayer, "thecar", false);
				destroyElement(ped);
				destroyElement(source);
				outputChatBox(core:getServerPrefix("red-dark", "Oktató", 3).. "A járműved használhatatlan állapotba került, így megbuktál a vizsgán illetve további 1000$-t vontunk le a javításokra.",thePlayer , 0, 0, 0, true);
				triggerClientEvent("failed", root);				
			else																						
			end	
		end	
	end
);

function stopVehicleEntry ( theplayer, seat, jacked, door)
local data = getElementData(theplayer, "doing");
	if (data) then			
   		cancelEvent()
   	end	 
end
addEventHandler("onVehicleStartExit", getRootElement(), stopVehicleEntry);

addEvent("givelicence", true);
addEventHandler("givelicence", root,
	function (thePlayer)
		exports.oInventory:createLicense(thePlayer, 2);
		setElementData(thePlayer, "islicence", true);
		if (getElementData(thePlayer, "newlicence") == true) then
			setElementData(thePlayer, "newlicence", false)		
		end
	end
);

function ocarlicences_leave()
	if (getElementData(source, "doing")) then
		local vehicle = getElementData(source, "thecar");
		local ped = getElementData(source, "theped");
		setElementData(vehicle, "drivecar", false);	
		destroyElement(ped);
		destroyElement(vehicle);
		setElementData(source, "doing", false);			
	end	
end
addEventHandler("onPlayerQuit", root, ocarlicences_leave)