for i, player in pairs(getElementsByType("player")) do
	setElementData(player, "kolcsonzott1", false);
end

local vdelete;
local core = exports.oCore
local conn = exports.oMysql:getDBConnection()

local boatspots = {
	[1] = {createColCuboid (177, -1908.5, -0.5, 14, 8, 3), 182, -1904.5, -0.5, -450},
	[2] = {createColCuboid (177, -1917, -0.5, 14, 8, 3), 182, -1913, -0.5, -450},
	[3] = {createColCuboid (177, -1925.5, -0.5, 14, 8, 3), 182, -1921.5, -0.5, -450},
	[4] = {createColCuboid (177, -1934, -0.5, 14, 8, 3), 182, -1930, -0.5, -450},
	[5] = {createColCuboid (177, -1942.5, -0.5, 14, 8, 3), 182, -1938.5, -0.5, -450},
	[6] = {createColCuboid (177, -1951, -0.5, 14, 8, 3), 182, -1947, -0.5, -450},
	[7] = {createColCuboid (177, -1959.5, -0.5, 14, 8, 3), 182, -1955.5, -0.5, -450},
	[8] = {createColCuboid (191.5, -1908.5, -0.5, 14, 8, 3), 196.5, -1904.5, -0.5, -450},
	[9] = {createColCuboid (191.5, -1917, -0.5, 14, 8, 3), 196.5, -1913, -0.5, -450},
	[10] = {createColCuboid (191.5, -1925.5, -0.5, 14, 8, 3), 196.5, -1921.5, -0.5, -450},
	[11] = {createColCuboid (191.5, -1934, -0.5, 14, 8, 3), 196.5, -1930, -0.5, -450},
	[12] = {createColCuboid (191.5, -1942.5, -0.5, 14, 8, 3), 196.5, -1938.5, -0.5, -450},
	[13] = {createColCuboid (191.5, -1951, -0.5, 14, 8, 3), 196.5, -1947, -0.5, -450},
	[14] = {createColCuboid (191.5, -1959.5, -0.5, 14, 8, 3), 196.5, -1955.5, -0.5, -450},	
};

addEvent("sikeresebb", true);
addEventHandler("sikeresebb", resourceRoot,
	function (thePlayer, vehID, ido, osszeg1, index)
		if (thePlayer) then
		local van = getElementData(thePlayer, "kolcsonzott") or false;	
			if not (van) then
				if (vehID) then
					if (ido) then
					local pMoney = getElementData(thePlayer, "char:money");	
						if (pMoney >= osszeg1) then
						 local isVehicle = false;	
						for i, spots in pairs(boatspots) do
							local carisinSpot = getElementsWithinColShape(spots[1], "vehicle");
							if (#carisinSpot == 0) then
								local vehicle = createVehicle(vehID, spots[2], spots[3], spots[4], 0, 0, spots[5]);
								local max = exports.oVehicle:getVehicleMaxFuel(vehID)
								setElementData(vehicle, "veh:maxFuel", max);
								setElementData(vehicle, "veh:fuel", max);
								setElementData(vehicle, "veh:traveledDistance", 0);								
								exports.oHandling:loadHandling(vehicle)
								setElementData(vehicle,"renteltboat", true);
								setElementData(thePlayer,"kolcsonzott1", true);
								setElementData(thePlayer,"kolcsonzotthajo", vehicle);
								setElementData(thePlayer,"char:money",pMoney - osszeg1);
								outputChatBox(core:getServerPrefix("server", "CarRent", 3).."Figyelem,hogyha a hajód meg fog sérülni,akkor lefogunk tőled vonni pénzt a javításokra!",thePlayer, 0, 0, 0,true);
								warpPedIntoVehicle(thePlayer, vehicle);
								isVehicle = true;						
								vdelete = setTimer(
									function()
										local vHealth = getElementHealth(vehicle);
										pMoney = getElementData(thePlayer, "char:money");
											if (vHealth < 1000) then
											vHealth = 1000 - vHealth
											multiplier = rentboats[index][3];
											setElementData(thePlayer, "char:money",pMoney - math.ceil(vHealth *multiplier));
											outputChatBox(core:getServerPrefix("server", "CarRent", 3).."Mivel a hajód sérült,ezért levontunk tőled "..math.ceil(vHealth *multiplier).."$-t!",thePlayer, 0, 0, 0, true);	
											end	
										destroyElement(vehicle);
										setElementData(thePlayer, "kolcsonzott", false);	
										outputChatBox(core:getServerPrefix("server", "CarRent", 3).."A bérlési idő lejárt,ezért visszahívtuk a hajód!",thePlayer, 0, 0, 0, true);								
									end,
								ido*60000,1);
								break;
							end	
						end
						if not (isVehicle) then
							outputChatBox(core:getServerPrefix("server", "CarRent", 3).."Jelnleg nincsen szabad hely a mólóban!",thePlayer, 0, 0, 0, true);	
						end	
						end	
					end	
				end	
			end	
		end	
	end
);
addEventHandler("onPlayerQuit", root,
	function ()
	thePlayer = source;	
		local data = getElementData(thePlayer, "kolcsonzott1") or false;
		if (data) then
		local vehicle = getElementData(thePlayer,"kolcsonzottboat");
		local vHealth = getElementHealth(vehicle);
		pMoney = getElementData(thePlayer, "char:money");	
		local charid = getElementData(thePlayer, "char:id")
			if (vHealth < 1000) then
			vHealth = 1000 - vHealth
			multiplier = rentboats[index][3];				
			dbExec(conn, "UPDATE characters SET money = ? WHERE id = ?", pMoney - math.ceil(vHealth * multiplier), charid);
			end	
		destroyElement(vehicle);
		setElementData(thePlayer, "kolcsonzott1", false);
		if (isTimer(vdelete)) then
			killTimer(vdelete);
		end			
		end	
	end
);	

