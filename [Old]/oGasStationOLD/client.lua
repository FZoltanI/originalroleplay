addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oGasStation" or getResourceName(res) == "oFont" or getResourceName(res) == "oCustomMarker" then  
        core = exports.oCore
		fontscript = exports.oFont:getFont("bebasneue", 21);
		font = exports.oFont:getFont("condensed", 13);
		font2 = exports.oFont:getFont("condensed", 10);
		color, R, G, B = exports.oCore:getServerColor();
		theMarker = exports.oCustomMarker:createCustomMarker(0, 0, 0, 1, R, G, B, 255, _, "circle");
	end
end)

local core = exports.oCore;
local ClientObjects = {};
local plus = 0;
local handled = 0;
local pX,pY = 1920, 1080;
local sX,sY = guiGetScreenSize();
local fontscript = exports.oFont:getFont("bebasneue", 21);
local font = exports.oFont:getFont("condensed", 13);
local font2 = exports.oFont:getFont("condensed", 10);
local color, R, G, B = exports.oCore:getServerColor();
local benzin2, diesel2 = 3, 6;

function click(button, state, _, _, _, _, _, clickedElement)
	if (button == "left") and (state == "up") then
	local vehicle = getPedOccupiedVehicle(localPlayer);	
		if not(vehicle) then
			if (clickedElement) then
				if (getElementData(clickedElement, "element")) then
					if (getElementData(localPlayer, "gas:which")) then	
						if (getElementData(localPlayer, "gas:which") == getElementData(clickedElement, "gas:which")) then
							triggerServerEvent("boneattach", root, clickedElement, localPlayer);
						end	
					else
						triggerServerEvent("boneattach", root, clickedElement, localPlayer);	
					end	
				end	
			end	
		end	
	end	
end	
addEventHandler("onClientClick", root, click);

function drawlines()
	for k,v in pairs(getElementsByType("object", getResourceRootElement(), true)) do
		if getElementData(v, "pistol") then
			if (core:getDistance(v, localPlayer) < 30) then
				local startx, starty, startZ = core:getPositionFromElementOffset(v, 0, 0, 0);
				local endX, endY, endZ = unpack(getElementData(v, "offset"));
				endX, endY, endZ = core:getPositionFromElementOffset(getElementData(v, "stations"), endX, endY, endZ);
				dxDrawLine3D(startx, starty, startZ, endX, endY, endZ, tocolor(0, 0, 0, 255), 1.5);
			end	
		end	
	end
end
addEventHandler("onClientRender", root, drawlines);
addEvent("triggerObject", true);
addEventHandler("triggerObject", resourceRoot,
	function(table)
		ClientObjects = table;
	end
);

addEvent("watching", true);
addEventHandler("watching", root, 
	function(theElement, element2)
	element = theElement;	
	element3 = element2;
	local station = getElementData(theElement, "stations");	
		addEventHandler("onClientRender", root,
			function ()
				if (core:getDistance(station, theElement) > 5) then
					triggerServerEvent("attachBack", root, theElement, localPlayer, element2);
				end	
			end
		);			
	end
);

addEvent("createMarker", true);
addEventHandler("createMarker", localPlayer,
	function (theVehicle)
	x, y, z = 0, 0, 0;
	local x, y, z = getVehicleComponentPosition(theVehicle, "wheel_rb_dummy", "world");
	theMarker = exports.oCustomMarker:createCustomMarker(0, 0, 0, 1, R, G, B, 255, _, "circle");
	attachElements(theMarker, theVehicle, 1.2, -1.5, -0.5);
	theCar = theVehicle;	
	end
);
addEventHandler("onClientMarkerHit", root,
	function (hitPlayer, mDim)
		if (mDim) then
			if (source == theMarker) then
				addEventHandler("onClientKey", root, setanim);
				addEventHandler("onClientRender", root, interactionRender);	
				addEventHandler("onClientRender", root, FuelPanel);
			end	
		end	
	end
);

addEventHandler("onClientMarkerLeave", root,
	function (thePlayer, mDim)
		removeEventHandler("onClientKey", root, setanim);
		removeEventHandler("onClientRender", root, interactionRender);	
		removeEventHandler("onClientRender", root, FuelPanel);
	end
);
function setanim(button, state)
	if (button == "e") and (state) then
		triggerServerEvent("anim", root, localPlayer);
		fuelTimer = setTimer(
			function()
			local fuel = getElementData(theCar, "veh:fuel");
			local max = getElementData(theCar, "veh:maxFuel");
				if ((fuel+plus) < max) then
					plus = plus + 1;
				else
					removeEventHandler("onClientKey", root, setanim);	
					triggerServerEvent("attachBack", root, element, localPlayer, element3);
					outputChatBox(core:getServerPrefix("red-dark", "Benzinkút", 3).."A járműved üzemanyag tankja tele van!", 255, 255, 255,true);
					exports.oChat:sendLocalMeAction("vissza akasztja a tankoló pisztolyt." );				
					triggerServerEvent("anim2", root, localPlayer);
					if (plus > 0) then
						if (handled == 0) then
							addEventHandler("onClientClick", root, pedClick);
							if not(isTimer(theTimer)) then
							triggerServerEvent("gas:vehicle", root, localPlayer, theCar);	
							triggerServerEvent("setPlayerData", root, localPlayer, element);		
								theTimer = setTimer(
									function ()
										zero();
										triggerServerEvent("gas:noveh", root, localPlayer);
									end
								,180000,1);
							end					
							handled = 1;
						end	
					end	
					handled = 1;
					if (isTimer(fuelTimer)) then
						killTimer(fuelTimer);
					end	 
				end	
			end
		,500,0);
	else
		if (plus > 0) then
			if (handled == 0) then
				addEventHandler("onClientClick", root, pedClick);
				if not(isTimer(theTimer)) then
				triggerServerEvent("gas:vehicle", root, localPlayer, theCar);	
				triggerServerEvent("setPlayerData", root, localPlayer, element);	
					theTimer = setTimer(
						function ()
							zero();
							triggerServerEvent("gas:noveh", root, localPlayer);
						end
					,180000,1);
				end					
				handled = 1;
			end	
		end	
		triggerServerEvent("anim2", root, localPlayer);
		if (isTimer(fuelTimer)) then
			killTimer(fuelTimer);
		end	
	end									
end

addEvent("destroyMarker", true);
addEventHandler("destroyMarker", root,
	function ()
		if (isElement(theMarker)) then
			destroyElement(theMarker);
			removeEventHandler("onClientRender", root, interactionRender);
			removeEventHandler("onClientRender", root, FuelPanel);
		end	
	end
);

function pedClick(button, state, _, _, _, _, _, clickedElement)
	if (button == "right") and (state == "up") then
		if (getElementData(clickedElement, "gas:ped")) then
			if (getElementData(localPlayer, "gas:which") == getElementData(clickedElement, "gas:which")) then
				addEventHandler("onClientKey", root, panelUsing);
				addEventHandler("onClientRender", root, payPanel);
				removeEventHandler("onClientClick", root, pedClick);
				thePed = clickedElement;
				if (isTimer(theTimer)) then
					killTimer(theTimer);
				end	
			end	
		end	
	end					
end

local text = {
	[1] = {"Tankolt mennyiség:", " l", "FIZETÉS", color, 4},
	[2] = {"Fizetendő:", " $", "MÉGSEM", "#87de85", 6},
}; 
local textcolor = {
	[1] = {tocolor(220, 220, 220, 255), tocolor(220, 220, 220, 255)},
	[2] = {tocolor(R, G, B, 255), tocolor(245, 66, 66, 255)};
};

function payPanel()
	if ((core:getDistance(localPlayer, thePed)) < 4) then
		dxDrawRectangle(803/pX*sX, 434/pY*sY, 314/pX*sX, 212/pY*sY, tocolor(32, 32, 32, 255), false);
		dxDrawRectangle(807/pX*sX, 438/pY*sY, 306/pX*sX, 204/pY*sY, tocolor(40, 40, 40, 255), false);
		dxDrawRectangle(809/pX*sX, 440/pY*sY, 302/pX*sX, 64/pY*sY, tocolor(32, 32, 32, 255), false);
		dxDrawText("Benzinkút számlázás", 811/pX*sX, 443/pY*sY, 1110/pX*sX, 505/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, fontscript, "center","center", false,false,false,true);
		for i=1, 2 do
			if (i == 1) then
				price = plus;
			else
				price = plus*benzin2;	
			end	
			dxDrawText(text[i][1], 816/pX*sX, (494+(i*42))/pY*sY, 916/pX*sX, (504+(i*27))/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, font, "left", "center", false, false, false, true);
			dxDrawText(text[i][4]..price.."#dcdcdc"..text[i][2], 1003/pX*sX, (494+(i*42))/pY*sY, 1103/pX*sX, (504+(i*27))/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, font, "right", "center", false, false, false, true);
			dxDrawRectangle((655+(i*154))/pX*sX, 598/pY*sY, 148/pX*sX, 42/pY*sY, tocolor(32, 32, 32, 255), false);
			dxDrawText(text[i][3], (655+(i*154))/pX*sX, 598/pY*sY, (803+(i*154))/pX*sX, 640/pY*sY, textcolor[1][i], 1/pX*sX, font, "center", "center", false, false, false, true);
			if core:isInSlot((655+(i*154))/pX*sX, 598/pY*sY, 148/pX*sX, 42/pY*sY) then
				textcolor[1][i] = textcolor[2][i];
			else
				textcolor[1][i] = tocolor(220, 220, 220, 255);
			end	
		end	
	else
		zero()
	end	
end

function panelUsing(button, state)
	if (button == "mouse1") and (state) then
		if core:isInSlot(809/pX*sX, 598/pY*sY, 148/pX*sX, 42/pY*sY) then
			if (plus > 0) then
			local pMoney = getElementData(localPlayer, "char:money");	
				if (pMoney >= plus*5) then
					if (theCar) then
						triggerServerEvent("pay", root, localPlayer, theCar, plus);
						zero();
					else	
						zero();
					end	
				else
					zero(); 
				end	
			else
				zero();
			end	
		elseif core:isInSlot(963/pX*sX, 598/pY*sY, 148/pX*sX, 42/pY*sY) then
			zero();
		end	
	end	
end

function zero()
	plus = 0;
	theCar = false;
	handled = 0;
	removeEventHandler("onClientKey", root, panelUsing);
	removeEventHandler("onClientRender", root, payPanel);
	removeEventHandler("onClientClick", root, pedClick);	
	triggerServerEvent("setPlayerDataFalse", root, localPlayer);
	triggerServerEvent("gas:noveh", root, localPlayer);
end

 function interactionRender()
    core:dxDrawShadowedText("Tankoláshoz nyomd meg az "..color.."[E] #ffffffgombot.", 0, sY*0.89, sX, sY*0.89+sY*0.05, tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 255), 0.9/pX*sX, font, "center", "center", false, false, false, true);
end

local text2 = {"Benzin ára:", "Tankolt mennyiség:", "Fizetendő összesen:"};

function FuelPanel()
	dxDrawRectangle(1710/pX*sX, 455/pY*sY, 200/pX*sX, 170/pY*sY, tocolor(32, 32, 32, 255), false);
	dxDrawRectangle(1712/pX*sX, 457/pY*sY, 196/pX*sX, 166/pY*sY, tocolor(40, 40, 40, 255), false);
	dxDrawRectangle(1714/pX*sX, 459/pY*sY, 192/pX*sX, 50/pY*sY, tocolor(32, 32, 32, 255), false);
	dxDrawText("Benzinkút", 1714/pX*sX, 459/pY*sY, 1900/pX*sX, 509/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, fontscript, "center", "center", false, false, false, true);
	for i=1, 3 do
	   if (i%2 == 0) then
	     rgb = tocolor(32, 32, 32, 255);
	     alpha = 150;
	   else
	   	 rgb = tocolor(35, 35, 35, 255);
	     alpha = 255;	   	 
	   end	
	   dxDrawRectangle(1714/pX*sX, (474+(i*37))/pY*sY, 192/pX*sX, 35/pY*sY, rgb, false);
	   dxDrawRectangle(1714/pX*sX, (474+(i*37))/pY*sY, 2/pX*sX, 35/pY*sY, tocolor(R, G, B, alpha), false);
	   dxDrawText(text2[i], 1718/pX*sX, (474+(i*37))/pY*sY, 1900/pX*sX, (509+(i*37))/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, font2, "left", "center", false, false, false, true);
	   if (i == 1) then
	   	word = benzin2.."#ffffff /l";
	   elseif (i == 2) then
	   	word = plus.."#ffffff l";
	   else	
	   	word = plus*benzin2.."#ffffff $";		
	   end	
	   dxDrawText(color..word, 1716/pX*sX, (474+(i*37))/pY*sY, 1900/pX*sX, (509+(i*37))/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, font2, "right", "center", false, false, false, true);	
	end	
end

addEvent("Cost", true);
addEventHandler("Cost", root,
	function (benzin, diesel)
		benzin2 = benzin;
		diesel2 = diesel;
		outputChatBox(core:getServerPrefix("server", "Benzinkút", 3).."Az üzemanyag ára megváltozott.", 255, 255, 255,true);
		outputChatBox(core:getServerPrefix("server", "Benzinkút", 3).."Benzin: "..color..benzin.."$"--[[#ffffff   Dízel: "..color..diesel.."$"]], 255, 255, 255,true);
	end
);

addEventHandler( "onClientResourceStop", getRootElement( ),
    function ()
        if (isElement(theMarker)) then
			destroyElement(theMarker);
			removeEventHandler("onClientRender", root, interactionRender);
			removeEventHandler("onClientRender", root, FuelPanel);
		end
		zero();	
    end
);
------------------
txd = engineLoadTXD( "files/fuelgun.txd", 11521)
engineImportTXD(txd, 11521 )
dff = engineLoadDFF( "files/fuelgun.dff", 11521)
engineReplaceModel(dff, 11521, true )
col = engineLoadCOL( "files/fuelgun.col" )
engineReplaceCOL ( col, 11521 )





