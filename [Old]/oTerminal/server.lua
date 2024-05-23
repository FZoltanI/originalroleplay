local hatarped1 = createPed ( 71, 297.18316650391, -1055.9920654297, 60.6279296875, 145.07768249512);	
local hatarped2 = createPed ( 71, 287.98645019531, -1063.783203125, 60.64013671875, 300.52856445313);
local hatarped3 = createPed ( 71,  636.88702392578, -900.10290527344, 37.502849578857, 120.52856445313);	
local hatarped4 = createPed ( 71,  640.51348876953, -901.76104736328, 38.155601501465, 300.52856445313);		
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

local hatarkapu = { 
	[1] = {createObject(968, 297.27172851563, -1054.3693847656, 60.15, -0, -90, 41), 297.27172851563, -1054.3693847656, 60.15, -0, 90, 0, -90,createObject(966, 297.27172851563, -1054.3693847656, 59.3, -0, 0, 41), -90},
	[2] = {createObject(968, 287.50350952148, -1065.8630371094, 60.6, -0, -90, 220.4059982299),  287.50350952148, -1065.8630371094, 60.6, -0, 90, 0, -90,createObject(966, 287.50350952148, -1065.8630371094, 59.76834487915, -0, 0, 220.4059982299), -90},
	[3] = {createObject(968, 638.23565673828, -902.55267333984, 37.7, -0, -90, 24), 638.23565673828, -902.55267333984, 37.7, -0, 90, 0, -90,createObject(966, 638.23565673828, -902.55267333984, 36.9, -0, 0, 24), -90},
	[3] = {createObject(968, 639.03887939453, -899.47839355469, 37.5, -0, -90, 207), 639.03887939453, -899.47839355469, 37.5, -0, 90, 0, -90,createObject(966, 639.03887939453, -899.47839355469, 36.7, -0, 0, 207), -90},
};

local kor = {
	[1] = {createColTube( 321, -1032, 45, 40, 20)},
	[2] = {createColTube( 269, -1090, 45, 38, 20)},
	[3] = {createColTube( 604.39422607422, -917.76275634766, 30, 38, 20)},
	[3] = {createColTube( 663.72247314453, -883.65484619141, 30, 30, 20)},
};

for i=1, #kor do
	setElementData(kor[i][1], "theCol", i);
	setElementData(kor[i][1], "o", false);	
	if (i == 4) then
		break;
	end	
end
local core = exports.oCore

addEvent("sikeres", true);

addEventHandler("sikeres", root,

	function(osszeg, localPlayer, kapu, stop)
		if (localPlayer) then
		local pMoney = getElementData(localPlayer, "char:money");
			if (pMoney >= osszeg) then	
				if (hatarkapu[kapu][10] == -90) then
					setElementData(localPlayer, "char:money",pMoney-osszeg);
					setElementData(stop, "moving", true);
					outputChatBox(core:getServerPrefix("red-dark", "Határ", 3).. "A határkapu 10 másodpercen belül automatikussan be fog záródni,hogyha nem hagyod el a területét!",client , 0, 0, 0, true);					
					moveObject(hatarkapu[kapu][1], 1000, hatarkapu[kapu][2], hatarkapu[kapu][3], hatarkapu[kapu][4], hatarkapu[kapu][5],  hatarkapu[kapu][6],  hatarkapu[kapu][7]);
					hatarkapu[kapu][10] = hatarkapu[kapu][7];
					local asd = 1;
					 mit = setTimer(
						function()
					 asd = asd + 1;		
					local isInSpot = isElementWithinColShape(localPlayer, kor[kapu][1]); 
					
						if not (isInSpot) or (asd >= 10) then
									moveObject(hatarkapu[kapu][1], 1000, hatarkapu[kapu][2], hatarkapu[kapu][3], hatarkapu[kapu][4], hatarkapu[kapu][5],  hatarkapu[kapu][8],  hatarkapu[kapu][7]);
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
		if (hatarkapu[kapu][10] == -90) then
			moveObject(hatarkapu[kapu][1], 1000, hatarkapu[kapu][2], hatarkapu[kapu][3], hatarkapu[kapu][4], hatarkapu[kapu][5],  hatarkapu[kapu][6],  hatarkapu[kapu][7]);
			setElementData(clickedElement,"free", true);
			setTimer(
				function()
					hatarkapu[kapu][10] = 90;		
				end,
			1000,1);
		end	
	end
);

addEvent("down", true);
addEventHandler("down", root,
	function(clickedElement, kapu)
		if (hatarkapu[kapu][10] == 90) then
			 moveObject(hatarkapu[kapu][1], 1000, hatarkapu[kapu][2], hatarkapu[kapu][3], hatarkapu[kapu][4], hatarkapu[kapu][5],  hatarkapu[kapu][8],  hatarkapu[kapu][7]);
			 setElementData(clickedElement,"free", false);
			setTimer(
				function()
				hatarkapu[kapu][10] = -90;
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

addEventHandler("onColShapeHit", root,
	function(theElement,mDim)
	local data = getElementData(source, "o") or false;	
		if not (data) then
			if getElementType ( theElement ) == "vehicle"  then	
				if (mDim) then
				local seris = getVehicleSirensOn(theElement);
					if (seris) then
						if (source == kor[1][1]) or (source == kor[2][1]) or (source == kor[3][1]) then
						local col = source;
						local kapu = getElementData(source, "theCol");
						local set =	getElementData(hatapeds[kapu] , "set") or false;
							if not (set) then
							local moving = getElementData(hatapeds[kapu], "moving");	
								if not (moving) then
									if (hatarkapu[kapu][10] == -90) then
										moveObject(hatarkapu[kapu][1], 1000, hatarkapu[kapu][2], hatarkapu[kapu][3], hatarkapu[kapu][4], hatarkapu[kapu][5],  hatarkapu[kapu][6],  hatarkapu[kapu][7]);
										setElementData(source, "o", true);
										setElementData(hatapeds[kapu],"free", true);
										setTimer(
											function()
												hatarkapu[kapu][10] = 90;											
											end,
										1000,1);			 																				
									end
								end	
							end								
						end	
					end	
				end	
			end
		end		
	end
);

addEventHandler("onColShapeLeave", root,
	function (theElement, mDim)	
	local data = getElementData(source, "o") or false;
	if (data) then	
		if getElementType ( theElement ) == "vehicle" then
			if (mDim) then
				local seris = getVehicleSirensOn(theElement);
					if (seris) then
						if (source == kor[1][1]) or (source == kor[2][1]) or (source == kor[3][1]) or (source == kor[4][1]) then
						local kapu = getElementData(source, "theCol");
							if (hatarkapu[kapu][10] == 90) then
								moveObject(hatarkapu[kapu][1], 1000, hatarkapu[kapu][2], hatarkapu[kapu][3], hatarkapu[kapu][4], hatarkapu[kapu][5],  hatarkapu[kapu][8],  hatarkapu[kapu][7]);
								setElementData(source, "o", false);
								setElementData(hatapeds[kapu],"free", false);	
								setTimer(
									function()
										hatarkapu[kapu][10] = -90;											
									end,
								1000,1);			 
							end						
						end	
					end		
				end	
			end	
		end	
	end
);