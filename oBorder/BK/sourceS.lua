local hatarped1 = createPed ( 71, 1751.7022705078, 532.75323486328, 27.144626617432, 250);	
local hatarped2 = createPed ( 71, 1730.6839599609, 529.16412353516, 27.743339538574, 71);
local hatarped3 = createPed ( 71, -176.92701721191, 332.67578125, 12.078125, 250);	
local hatarped4 = createPed ( 71, -164.18812561035, 383.97436523438, 12.078125, 80);		
setElementFrozen(hatarped1, true);
setElementFrozen(hatarped2, true);
setElementFrozen(hatarped3, true);
setElementFrozen(hatarped4, true);
setElementData(hatarped1, "katt", "hatar1");
setElementData(hatarped2, "katt", "hatar2");
setElementData(hatarped3, "katt", "hatar3");
setElementData(hatarped4, "katt", "hatar4");
setElementData(hatarped1, "ped:name", "James Orlando");
setElementData(hatarped1, "ped:prefix", "Határőr");
setElementData(hatarped2, "ped:name", "George White");
setElementData(hatarped2, "ped:prefix", "Határőr");
setElementData(hatarped3, "ped:name", "Bryan Fast");
setElementData(hatarped3, "ped:prefix", "Határőr");
setElementData(hatarped4, "ped:name", "Michael Calm");
setElementData(hatarped4, "ped:prefix", "Határőr");
local hatapeds = {hatarped1, hatarped2, hatarped3, hatarped4};

local kapuNames = {
	[1] = "Main Border LS > LV",
	[2] = "Main Border LV > LS",
	[3] = "Martin Bridge Border LS > LV",
	[4] = "Martin Bridge Border LV > LS",
}

local hatarkapu = { 
	[1] = {createObject(968, 1752.3456787109, 532.0379394531, 26.877333831787, -0, -90, 160), 1752.3456787109, 532.0379394531, 26.877333831787, 0, 60, 0, -60, createObject(966, 638.23565673828, -902.55267333984, -100, -0, 0, 24), -60},
	[2] = {createObject(968, 1730.3287597656, 529.87720947266, 27.406520080566, -0, -90, -20),  1730.3287597656, 529.87720947266, 27.406520080566, -0, 60, 0, -60, createObject(966, 638.23565673828, -902.55267333984, -100, -0, 0, 24), -60},
	[3] = {createObject(968, -177.17736816406, 331.56460571289, 11.88125, -0, -90, 165), -177.17736816406, 331.56460571289, 11.878125, -0, 60, 0, -60,createObject(966, -177.17736816406, 331.56460571289, 11.078125, 0, 0, 165), -60},
	[4] = {createObject(968,-163.78439331055, 384.97268676758, 11.878125, -0, -90, 345),-163.78439331055, 384.97268676758, 11.878125, -0, 60, 0, -60,createObject(966, -163.78439331055, 384.97268676758, 11.078125, 0, 0, 345), -60},
};

local kor = {
	[1] = {createColTube( 1756.2700195312, 532.35803222656, 25.078641891479, 10, 20)},
	[2] = {createColTube(1725.8471679688, 530.64630126953, 25.746147155762, 10, 20)},
	[3] = {createColTube(-173.48904418945, 331.81503295898, 10.078125, 10, 20)},
	[4] = {createColTube(-167.11686706543, 384.80221557617, 10.078125, 10, 20)},
};

for i=1, #kor do
	setElementData(kor[i][1], "theCol", i);
	setElementData(kor[i][1], "o", false);	
	if (i == 4) then
		break;
	end	
end
local core = exports.oCore
local color, r, g, b = core:getServerColor()

addEvent("sikeres", true);

addEventHandler("sikeres", root,

	function(osszeg, localPlayer, kapu, stop)
		if (localPlayer) then
		local pMoney = getElementData(localPlayer, "char:money");
			if (pMoney >= osszeg) then	
				if (hatarkapu[kapu][10] == -60) then
					setElementData(localPlayer, "char:money",pMoney-osszeg);
					setElementData(stop, "moving", true);
					outputChatBox(core:getServerPrefix("red-dark", "Határ", 3).. "A határkapu 10 másodpercen belül automatikussan be fog záródni!",client , 0, 0, 0, true);		

					local occupiedVeh = getPedOccupiedVehicle(client)

					local vehColor = {getVehicleColor(occupiedVeh, true)}

					triggerEvent("factionScripts > cctv > sendMessage", root, core:getServerPrefix("blue-light-2", "Határ", 2).."Egy "..color..exports.oVehicle:getModdedVehicleName(occupiedVeh).." #fffffftípusú jármű átkelt a "..color..kapuNames[kapu].."#ffffff nevű határon!", core:getServerPrefix("blue-light-2", "Határ", 2).."Színe: "..RGBToHex(vehColor[1], vehColor[2], vehColor[3]).."Szín 1 #ffffff| "..RGBToHex(vehColor[4], vehColor[5], vehColor[6]).."Szín 2#ffffff.", core:getServerPrefix("blue-light-2", "Határ", 2).."Rendszáma: "..color..getVehiclePlateText(occupiedVeh).."#ffffff.")
			
					moveObject(hatarkapu[kapu][1], 4000, hatarkapu[kapu][2], hatarkapu[kapu][3], hatarkapu[kapu][4], hatarkapu[kapu][5],  hatarkapu[kapu][6],  hatarkapu[kapu][7]);
					hatarkapu[kapu][10] = hatarkapu[kapu][7];
					local asd = 1;
					 mit = setTimer(
						function()
					 asd = asd + 1;		
					local isInSpot = isElementWithinColShape(localPlayer, kor[kapu][1]); 
					
						if not (isInSpot) or (asd >= 10) then
									moveObject(hatarkapu[kapu][1], 4000, hatarkapu[kapu][2], hatarkapu[kapu][3], hatarkapu[kapu][4], hatarkapu[kapu][5],  hatarkapu[kapu][8],  hatarkapu[kapu][7]);
									hatarkapu[kapu][10] = hatarkapu[kapu][8];
											setTimer(
												function()
													setElementData(stop, "moving", false);	
												end,
											1000,1);	
									if (isTimer(mit)) then
										killTimer(mit);
									end
						end
					end

						,1000,0);
				
				end 
			end	

		end

	end

);

addEvent("closed", true);
addEventHandler("closed", root,
	function(clickedElement)
		setElementData(clickedElement,"used", true);
	end
);

addEvent("open", true);
addEventHandler("open", root,
	function(clickedElement)
		setElementData(clickedElement,"used", false);
	end
);

addEvent("up", true);
addEventHandler("up", root,
	function(clickedElement, kapu)
		if (hatarkapu[kapu][10] == -60) then
			moveObject(hatarkapu[kapu][1], 4000, hatarkapu[kapu][2], hatarkapu[kapu][3], hatarkapu[kapu][4], hatarkapu[kapu][5],  hatarkapu[kapu][6],  hatarkapu[kapu][7]);
			setElementData(clickedElement,"free", true);
			setTimer(
				function()
					hatarkapu[kapu][10] = 60;		
				end,
			1000,1);
		end	
	end
);

addEvent("down", true);
addEventHandler("down", root,
	function(clickedElement, kapu)
		if (hatarkapu[kapu][10] == 60) then
			 moveObject(hatarkapu[kapu][1], 4000, hatarkapu[kapu][2], hatarkapu[kapu][3], hatarkapu[kapu][4], hatarkapu[kapu][5],  hatarkapu[kapu][8],  hatarkapu[kapu][7]);
			 setElementData(clickedElement,"free", false);
			setTimer(
				function()
				hatarkapu[kapu][10] = -60;
				local data = getElementData(kor[kapu][1], "o") or false;
					if (data) then
						setElementData(kor[kapu][1], "o", false);
					end			
				end,
			1000,1);			 
		end	 
	end
);

addEvent("set", true);
addEventHandler("set", root,
	function(clickedElement)
	local set = getElementData(clickedElement,"set") or false;	
		if not(set) then
			setElementData(clickedElement,"set", true);
		else 
			setElementData(clickedElement,"set", false);	
		end	
	end
);


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