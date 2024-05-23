for i,v in ipairs(getElementsByType("object", getResourceRootElement(), true)) do
	if (getElementModel(v) == 11521) then
		setElementData(v, "f:using", false);
	end	
end

for i,v in ipairs(getElementsByType("player")) do
		setElementData(v, "fueling", false);
		setElementData(v, "gas:which", false);
end

local pos = {
	[1] = {-0.15, -0.3, 1.5, 0, 90, 270},
	[2] = {-0.45, -0.3, 1.5, 0, 90, 270},
	[3] = {-0.15, 0.3, 1.5, 0, 90, -270},
	[4] = {-0.45, 0.3, 1.5, 0, 90, -270},
};
local core = exports.oCore;
local objects = {};
function createPetrolStations()
	for key, value in pairs(stations) do 
		for k, v in pairs(value) do 
			if k == 1 then 
				v[6] = createPed(v[1], v[2], v[3], v[4], v[5]);
				setElementData(v[6], "ped:name", v[8]);
				setElementData(v[6], "ped:prefix", "Benzinkutas");
				setElementData(v[6], "gas:ped", true);
				setElementData(v[6], "gas:which", v[7]);
				setElementFrozen(v[6], true);
			else
				v[5] = createObject (v[1], v[2], v[3], v[4], 0, 0, v[6])			
				v[6] = createObject (11521, 0, 0, 0)
				v[7] = createObject (11521, 0, 0, 0)
				v[8] = createObject (11521, 0, 0, 0)
				v[9] = createObject (11521, 0, 0, 0)
				local p = createObject(2194, 0, 0, 0);
				local d = createObject(2194, 0, 0, 0);
				local c = createObject(2194, 0, 0, 0);
				local k = createObject(2194, 0, 0, 0);
				setElementCollisionsEnabled (v[6], false);
				setElementCollisionsEnabled (v[7], false);
				setElementCollisionsEnabled (v[8], false);
				setElementCollisionsEnabled (v[9], false);
				attachElements (v[6], v[5], -0.15, -0.3, 1.5, 0, 90, 270);
				attachElements (v[7], v[5], -0.45, -0.3, 1.5, 0, 90, 270);
				attachElements (v[8], v[5], -0.15, 0.3, 1.5, 0, 90, -270);
				attachElements (v[9], v[5], -0.45, 0.3, 1.5, 0, 90, -270);				
				attachElements (p, v[5], -0.15, -0.2, 1.8, 0, 0, 270);
				attachElements (d, v[5], -0.45, -0.2, 1.8, 0, 0, 270);
				attachElements (c, v[5], -0.15, 0.2, 1.8, 0, 0, -270);
				attachElements (k, v[5], -0.45, 0.2, 1.8, 0, 0, -270);
				setElementAlpha(p, 0);
				setElementAlpha(d, 0);
				setElementAlpha(c, 0);
				setElementAlpha(k, 0);
				setElementData(v[7], "gas:disel", true);
				setElementData(v[9], "gas:disel", true);
				local data = v[10];
				local stationhead = (v[5]);
				local pistols = {v[6], v[7], v[8], v[9]};
				local col = {p, d, c, k};
				local offsets = {
					[1] = {-0.15, -0.25, 0};
					[2] = {-0.45, -0.25, 0};
					[3] = {-0.15, 0.25, 0};
					[4] = {-0.45, 0.25, 0};
				};
				for i,v in ipairs(pistols) do
					setElementData(v, "pistol", v);
					setElementData(v, "stations", stationhead);
					table.insert(objects, v);	
					setElementData(v, "gas:which", data);												
				end
				for i=1, 4 do
					setElementData(col[i], "element", pistols[i]);
					setElementData(col[i], "gas:which", data);
					setElementData(pistols[i], "offset", {offsets[i][1], offsets[i][2], offsets[i][3]});
					setElementData(pistols[i], "pos", {pos[i][1], pos[i][2], pos[i][3], pos[i][4], pos[i][5], pos[i][6]});
				end
			end		
		end
	end
end
createPetrolStations()

addEvent("boneattach", true);
addEventHandler("boneattach", root,
	function(theElement, thePlayer)
	local id = getElementModel(theElement);
		if (id == 2194) then
		local element = getElementData(theElement, "element");		
			if not(getElementData(theElement, "f:using")) then
				if not (getElementData(thePlayer, "fueling")) then
					if not(isTimer(aTimer)) then
					setElementData(theElement,"f:using", true);
					setElementData(thePlayer, "fueling", true);					
					--aTimer = setTimer(
						--function()
							exports.oBone:attachElementToBone(element, thePlayer, 10, 0.1, -0.05, 0.33, 180, 10, -60);
							triggerClientEvent("watching", root, element, theElement);
							local vehicle = exports.oVehicle:getNearestVehicle(thePlayer, 5);
							exports.oChat:sendLocalMeAction(thePlayer, "leveszi a tankoló pisztolyt." );
							if (vehicle) then
								if not (getVehicleEngineState(vehicle)) then
									if not(getElementModel(vehicle) == 509) and not(getElementModel(vehicle) == 481) and not(getElementModel(vehicle) == 510) then
										if not(getElementData(thePlayer, "gas:fueledveh")) then
											triggerClientEvent("createMarker", thePlayer, vehicle);
										else
											if (getElementData(thePlayer, "gas:fueledveh") == vehicle) then
												triggerClientEvent("createMarker", thePlayer, vehicle);
											end	
										end	
									end	
								end	
							end	
							aTimer = false;
						--end
						--,100,1)
					end
				end		
			else
				if (getElementData(thePlayer, "fueling")) then
					if not (isTimer(aTimer)) then	
					setElementData(theElement,"f:using", false);
					setElementData(thePlayer, "fueling", false);
					triggerClientEvent("destroyMarker", root);					
					--aTimer = setTimer(
						--function()
							exports.oBone:detachElementFromBone(element) 
							local station = getElementData(element, "stations");
							local pos1, pos2, pos3, pos4, pos5, pos6 = unpack(getElementData(element, "pos")); 
							attachElements (element, station,  pos1, pos2, pos3, pos4, pos5, pos6);
							exports.oChat:sendLocalMeAction(thePlayer, "vissza akasztja a tankoló pisztolyt." );
							aTimer = false;
						--end
						--,100,1)
					end
				end	
			end	
		end	
	end
);

addEvent("attachBack", true);
addEventHandler("attachBack", root, 
	function (theElement, thePlayer, element2)
	exports.oBone:detachElementFromBone(theElement);
	local station = getElementData(theElement, "stations");
	local pos1, pos2, pos3, pos4, pos5, pos6 = unpack(getElementData(theElement, "pos"));
	attachElements (theElement, station,  pos1, pos2, pos3, pos4, pos5, pos6);
	setElementData(element2,"f:using", false);
	setElementData(thePlayer, "fueling", false);
	triggerClientEvent("destroyMarker", root);	 			
	end
);

addEvent("anim", true);
addEventHandler("anim", root,
	function (thePlayer)
		setPedAnimation(thePlayer, "sword", "sword_idle", -1, true, false, false);		
	end
);

addEvent("anim2", true);
addEventHandler("anim2", root,
	function (thePlayer)
		setPedAnimation(thePlayer);		
	end
);

addEvent("pay", true);
addEventHandler("pay", root,
	function (thePlayer, theVehicle, amount)
	local pMoney = getElementData(thePlayer,"char:money");
		if (pMoney >= (amount*5)) then
			setElementData(thePlayer, "char:money", (pMoney-(amount*5)));
			local fuel = getElementData(theVehicle, "veh:fuel")
			setElementData(theVehicle, "veh:fuel", (fuel+amount));
		end	
	end
);

addEvent("setPlayerData", true);
addEventHandler("setPlayerData", root,
	function (thePlayer, element)
		local data = getElementData(element, "gas:which");
		setElementData(thePlayer, "gas:which", data);
	end
);

addEvent("setPlayerDataFalse", true);
addEventHandler("setPlayerDataFalse", root,
	function (thePlayer)
		setElementData(thePlayer, "gas:which", false);
	end
);

addEvent("gas:vehicle", true);
addEventHandler("gas:vehicle", root,
	function (thePlayer, theVehicle)
		setElementData(thePlayer, "gas:fueledveh", theVehicle);
	end
);

addEvent("gas:noveh", true);
addEventHandler("gas:noveh", root,
	function (thePlayer)
		setElementData(thePlayer, "gas:fueledveh", false);
	end
);

setTimer( 
	function ()
		benzin = math.random(3, 7);
		diesel = math.random(6, 11);
		triggerClientEvent("Cost", root, benzin, diesel);
	end
,core:minToMilisec(60), 0);

