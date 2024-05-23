addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oDashboard" or getResourceName(res) == "oFont" then  
        
 	core = exports.oCore
	color, R, G, B = exports.oCore:getServerColor();
 	font = exports.oFont:getFont("condensed", 15);
	end
end)

local core = exports.oCore
local pX,pY = 1920, 1080;
local sX,sY = guiGetScreenSize();
local color, R, G, B = exports.oCore:getServerColor();
local font = exports.oFont:getFont("condensed", 15);
local doing = 0;
local tick = getTickCount ();

addEvent("createTrashs", true);
addEventHandler("createTrashs", root,
	function (thePlayer, amount)
		if (thePlayer == localPlayer) then
		    points = {
				{631.82116699219, -584.76434326172, 15.3359375},	
				{631.65661621094, -540.11981201172, 15.3359375},	
			};
			much = amount;
			time = amount*5;
			random = math.random(1, #points);
			theTrash = createObject( 2840, points[random][1], points[random][2], points[random][3]);
			theCol = createColTube ( points[random][1], points[random][2], points[random][3], 1, 1);
			theBlip = createBlip ( points[random][1], points[random][2], points[random][3], 3, 1, R, G, B, 170, 255);
			addEventHandler("onClientRender", root, defaultPanel);
			addEventHandler("onClientColShapeHit", root, colHit);
			addEventHandler("onClientColShapeLeave", root, colLeave);
			if not(isTimer(workTimer)) then
				workTimer =  setTimer(
					function ()
						if (time > 1) then
							time = getElementData(localPlayer, "publicwork:time") or time - 1;
							triggerServerEvent("setTime", root, localPlayer, time);
						else
							outputChatBox(core:getServerPrefix("red-dark", "Közmunka", 3).. "Sajnáljuk! Nem sikerült időben teljesítened a rád kiszabott közmunkát", 0, 0, 0, true);
							doing = 0;						
							table.remove(points, random);
							setElementFrozen(localPlayer, false);
							much = much - 1;
							removeEventHandler("onClientRender", root, text);
							removeEventHandler("onClientKey", root, pickUp);
							destroyElement(theTrash);
							destroyElement(theCol);
							destroyElement(theBlip);
							triggerServerEvent("setanimoff", root, localPlayer);
							removeEventHandler("onClientColShapeHit", root, colHit);
							removeEventHandler("onClientColShapeLeave", root, colLeave);
							removeEventHandler("onClientRender", root, defaultPanel);
							if (isTimer(workTimer)) then
								killTimer(workTimer);
							end																		
						end		
					end
				,60000,0);
			end	
		end					
	end
);

function text()
	core:dxDrawShadowedText("A szemét felszedéséhez nyomd meg az "..color.."[E] #ffffffgombot.", 0, sY*0.89, sX, sY*0.89+sY*0.05, tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 255), 0.9/pX*sX, font, "center", "center", false, false, false, true);		
end	

function pickUp(button, state)
	if (button == "e") and (state) then
		if (doing == 0) then
			doing = 1;
			tick = getTickCount();
			a1 = 0;
			a2 = 367;
			sound = playSound("files/trash_to_bag.wav");
			setSoundVolume(sound, 0.5);
			addEventHandler("onClientRender", root, showTime);
			triggerServerEvent("setanim", root, localPlayer);
			setElementFrozen(localPlayer, true);
			if not (isTimer(getting)) then
				getting = setTimer(
					function ()
						--stopSound(sound);
						removeEventHandler("onClientRender", root, showTime);
						a2 = 0;
						doing = 0;
						table.remove(points, random);
						setElementFrozen(localPlayer, false);
						much = much - 1;
						triggerServerEvent("setAmount", root, localPlayer, much);
						removeEventHandler("onClientRender", root, text);
						removeEventHandler("onClientKey", root, pickUp);
						destroyElement(theTrash);
						destroyElement(theCol);
						destroyElement(theBlip);
						triggerServerEvent("setanimoff", root, localPlayer);
						removeEventHandler("onClientColShapeHit", root, colHit);
						removeEventHandler("onClientColShapeLeave", root, colLeave);							
						if (much > 0) then
							random = math.random(1, #points);
							theTrash = createObject( 2840, points[random][1], points[random][2], points[random][3]);
							theCol = createColTube ( points[random][1], points[random][2], points[random][3], 1, 1);
							theBlip = createBlip ( points[random][1], points[random][2], points[random][3], 3, 1, R, G, B, 170, 255);
							addEventHandler("onClientColShapeHit", root, colHit);
							addEventHandler("onClientColShapeLeave", root, colLeave);								
						else
							outputChatBox(core:getServerPrefix("green-dark", "Közmunka", 3).. "Gratulálunk! Sikeresen teljesítetted a rád szabott bűntetésedet!", 0, 0, 0, true);
							triggerServerEvent("finished", root, localPlayer);
							removeEventHandler("onClientRender", root, defaultPanel);
							if (isTimer(workTimer)) then
								killTimer(workTimer);
							end			
						end						
					end
				,5000,1);	
			end	
		end	
	end	
end

function colLeave(theElement, mDim)
	if (source == theCol) then
		if (mDim) and (theElement == localPlayer) then
			removeEventHandler("onClientRender", root, text);
			removeEventHandler("onClientKey", root, pickUp);
		end	
	end	
end

function colHit(theElement, mDim)
	if (source == theCol) then
		if (mDim) and (theElement == localPlayer) then
			addEventHandler("onClientRender", root, text);
			addEventHandler("onClientKey", root, pickUp);
		end	
	end	
end

function defaultPanel()
	core:dxDrawShadowedText(color.."Hátralévő idő: #ffffff"..time.." perc", 885/pX*sX, 0/pY*sY, 1035/pX*sX, 50/pY*sY,tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 255), 0.9/pX*sX, font, "center", "center", false, false, false, true);	
	core:dxDrawShadowedText(color.."Hátralévő szemét: #ffffff"..much.." darab", 885/pX*sX, 25/pY*sY, 1035/pX*sX, 75/pY*sY, tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 255), 0.9/pX*sX, font, "center", "center", false, false, false, true);	
end

function showTime()
	line_height = interpolateBetween(
			a1, 0, 0,
			a2, 0, 0,	
	(getTickCount()-tick)/5000, "Linear");

	--dxDrawRectangle(810/pX*sX, 930/pY*sY, 300/pX*sX, 30/pY*sY, tocolor(32, 32, 32, 255), false);
	--dxDrawRectangle(814/pX*sX, 934/pY*sY, long/pX*sX, 22/pY*sY, tocolor(R, G, B, 255), false);
	dxDrawRectangle(sX*0.4, sY*0.85, sX*0.2, sY*0.03, tocolor(40, 40, 40, 255));
    dxDrawRectangle(sX*0.401, sY*0.852, (sX*0.2-sX*0.002), sY*0.03-sY*0.004, tocolor(35, 35, 35, 255));
    dxDrawRectangle(sX*0.401, sY*0.852, line_height/pY*sY, sY*0.03-sY*0.004, tocolor(R, G, B, 255));

    dxDrawText(math.floor(line_height/3.67).."%", sX*0.4, sY*0.85, sX*0.4+sX*0.2, sY*0.85+sY*0.03, tocolor(32, 32, 32, 255), 1/pX*sX, font, "center", "center", false, false, false, true);
end

addEvent("delEverything", true);
addEventHandler("delEverything", root,
	function (thePlayer)
		if (localPlayer == thePlayer) then
			removeEventHandler("onClientRender", root, showTime);
			a2 = 0;
			doing = 0;
			table.remove(points, random);
			setElementFrozen(localPlayer, false);
			much = much - 1;
			removeEventHandler("onClientRender", root, text);
			removeEventHandler("onClientKey", root, pickUp);
			destroyElement(theTrash);
			destroyElement(theCol);
			triggerServerEvent("setanimoff", root, localPlayer);
			removeEventHandler("onClientColShapeHit", root, colHit);
			removeEventHandler("onClientColShapeLeave", root, colLeave);
			removeEventHandler("onClientRender", root, defaultPanel);
			if (isTimer(workTimer)) then
				killTimer(workTimer);
			end		
			if (isTimer(getting)) then
				killTimer(getting	);
			end			
		end	
	end
);

addEventHandler("onClientElementDataChange", root,
	function (theKey, oldValue, newValue)
		if (getElementType(source) == "player") and (theKey == "publicwork:doing") then
			outputChatBox("Szia Booms");
		end	
	end
);