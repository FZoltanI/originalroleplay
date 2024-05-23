for i, player in pairs(getElementsByType("player")) do
	setElementData(player, "kolcsonzott", false);
end

local vdelete;
local core = exports.oCore
local conn = exports.oMysql:getDBConnection()

local carspots = {
	[1] = {createColCuboid ( 1490.8, -2215.2658691406, 12.546875, 3.3, 7, 3), 1492.3, -2211.7197265625, 13.546875, 0},
	[2] = {createColCuboid ( 1494, -2215.2658691406, 12.546875, 3.3, 7, 3), 1495.6, -2211.7197265625, 13.546875, 0},
	[3] = {createColCuboid ( 1497.3, -2215.2658691406, 12.546875, 3.3, 7, 3), 1498.9, -2211.7197265625, 13.546875, 0},
	[4] = {createColCuboid ( 1500.5, -2215.2658691406, 12.546875, 3.3, 7, 3), 1502.2, -2211.7197265625, 13.546875, 0},
	[5] = {createColCuboid ( 1503.8, -2215.2658691406, 12.546875, 3.3, 7, 3), 1505.3, -2211.7197265625, 13.546875, 0},
	[6] = {createColCuboid ( 1507.1, -2215.2658691406, 12.546875, 3.3, 7, 3), 1508.6, -2211.7197265625, 13.546875, 0},
	[7] = {createColCuboid ( 1510.4, -2215.2658691406, 12.546875, 3.3, 7, 3), 1511.9, -2211.7197265625, 13.546875, 0},
	[8] = {createColCuboid ( 1513.7, -2215.2658691406, 12.546875, 3.3, 7, 3), 1515.2, -2211.7197265625, 13.546875, 0},
	[9] = {createColCuboid ( 1517, -2215.2658691406, 12.546875, 3.3, 7, 3), 1518.5, -2211.7197265625, 13.546875, 0},
	[10] = {createColCuboid ( 1520.3, -2215.2658691406, 12.546875, 3.3, 7, 3), 1521.8, -2211.7197265625, 13.546875, 0},
	[11] = {createColCuboid ( 1524.8, -2215.2658691406, 12.546875, 3.3, 7, 3), 1526.3, -2211.7197265625, 13.546875, 0},
	[12] = {createColCuboid ( 1528.1, -2215.2658691406, 12.546875, 3.3, 7, 3), 1529.6, -2211.7197265625, 13.546875, 0},
	[13] = {createColCuboid ( 1531.4, -2215.2658691406, 12.546875, 3.3, 7, 3), 1532.9, -2211.7197265625, 13.546875, 0},
	[14] = {createColCuboid ( 1534.7, -2215.2658691406, 12.546875, 3.3, 7, 3), 1536.2, -2211.7197265625, 13.546875, 0},
	[15] = {createColCuboid ( 1538, -2215.2658691406, 12.546875, 3.3, 7, 3), 1539.5, -2211.7197265625, 13.546875, 0},
	[16] = {createColCuboid ( 1541.3, -2215.2658691406, 12.546875, 3.3, 7, 3), 1542.8, -2211.7197265625, 13.546875, 0},
	[17] = {createColCuboid ( 1544.6, -2215.2658691406, 12.546875, 3.3, 7, 3), 1546.1, -2211.7197265625, 13.546875, 0},
	[18] = {createColCuboid ( 1557.1, -2236.2, 12.546875, 7, 3.3, 3),   1559.5, -2234.7, 13.546875, -450},	
	[19] = {createColCuboid ( 1557.1, -2239.5, 12.546875, 7, 3.3, 3),   1559.5, -2238, 13.546875, -450},
	[20] = {createColCuboid ( 1557.1, -2242.8, 12.546875, 7, 3.3, 3),   1559.5, -2241.3, 13.546875, -450},
	[21] = {createColCuboid ( 1557.1, -2246.1, 12.546875, 7, 3.3, 3),   1559.5, -2244.6, 13.546875, -450},
	[22] = {createColCuboid ( 1557.1, -2249.4, 12.546875, 7, 3.3, 3),   1559.5, -2247.9, 13.546875, -450},
	[23] = {createColCuboid ( 1557.1, -2252.7, 12.546875, 7, 3.3, 3),   1559.5, -2251.2, 13.546875, -450},
	[24] = {createColCuboid ( 1557.1, -2256, 12.546875, 7, 3.3, 3),   1559.5, -2254.5, 13.546875, -450},
	[25] = {createColCuboid ( 1557.1, -2259.3, 12.546875, 7, 3.3, 3),   1559.5, -2257.8, 13.546875, -450},
	[26] = {createColCuboid ( 1557.1, -2262.6, 12.546875, 7, 3.3, 3),   1559.5, -2261.1, 13.546875, -450},
	[27] = {createColCuboid ( 1557.1, -2265.9, 12.546875, 7, 3.3, 3), 1559.5, -2264.4, 13.546875, -450},
};

local delTimers = {}

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
						for i, spots in pairs(carspots) do
							local carisinSpot = getElementsWithinColShape(spots[1], "vehicle");
							if (#carisinSpot == 0) then
								local vehicle = createVehicle(vehID, spots[2], spots[3], spots[4], 0, 0, spots[5]);
								local max = exports.oVehicle:getVehicleMaxFuel(vehID)
								setElementData(vehicle, "veh:maxFuel", max);
								setElementData(vehicle, "veh:fuel", max);
								setElementData(vehicle, "veh:traveledDistance", 0);
								exports.oHandling:loadHandling(vehicle)
								setElementData(vehicle,"renteltcar", thePlayer);
								setElementData(thePlayer,"kolcsonzott", true);
								setElementData(thePlayer,"kolcsonzottcar", vehicle);
								setElementData(thePlayer,"char:money",pMoney - osszeg1);
								outputChatBox(core:getServerPrefix("server", "CarRent", 3).."Figyelem,hogyha a járműved meg fog sérülni,akkor lefogunk tőled vonni pénzt a javításokra!",thePlayer, 0, 0, 0,true);
								warpPedIntoVehicle(thePlayer, vehicle);

								isVehicle = true;	

								delTimers[vehicle] = setTimer(
									function()
										local vHealth = getElementHealth(vehicle);
										pMoney = getElementData(thePlayer, "char:money");

										if (vHealth < 1000) then
											vHealth = 1000 - vHealth
											multiplier = rentcars[index][3];
											setElementData(thePlayer, "char:money",pMoney - math.ceil(vHealth *multiplier));
											outputChatBox(core:getServerPrefix("server", "CarRent", 3).."Mivel a járműved sérült,ezért levontunk tőled "..math.ceil(vHealth *multiplier).."$-t!",thePlayer, 0, 0, 0, true);	
										end	

										delTimers[vehicle] = false
										
										destroyElement(vehicle);
										setElementData(thePlayer, "kolcsonzott", false);	
										outputChatBox(core:getServerPrefix("server", "CarRent", 3).."A bérlési idő lejárt,ezért visszahívtuk a járművedet!",thePlayer, 0, 0, 0, true);								
									end,
								core:minToMilisec(ido),1);

								break;
							end	
						end
						if not (isVehicle) then
							outputChatBox(core:getServerPrefix("server", "CarRent", 3).."Jelenleg nincsen szabad hely a parkolóban!",thePlayer, 0, 0, 0, true);	
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
		local data = getElementData(thePlayer, "kolcsonzott") or false;
		if (data) then
			local vehicle = getElementData(thePlayer,"kolcsonzottcar");
			local vHealth = getElementHealth(vehicle);
			for k,v in pairs(rentcars) do
				if (getElementModel(vehicle) == v[1]) then
					index = v;
					break;
				end	
			end			
			--setTimer(
				--function()
					--pMoney = getElementData(thePlayer, "char:money");	
					--local charid = getElementData(thePlayer, "char:id")
					--	if (vHealth < 1000) then
					--	vHealth = 1000 - vHealth
					--	multiplier = rentcars[index][3];				
					--	dbExec(conn, "UPDATE characters SET money = ? WHERE id = ?", pMoney - math.ceil(vHealth * multiplier), charid);
					--	end	
					if isTimer(delTimers[vehicle]) then 
						killTimer(delTimers[vehicle])
					end

					delTimers[vehicle] = false 

					destroyElement(vehicle);
					setElementData(thePlayer, "kolcsonzott", false);

				--end		
			--,1000,1);	
		end	
	end
);	

