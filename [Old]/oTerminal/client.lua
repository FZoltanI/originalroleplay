addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oTerminal" then  
        setElementData(localPlayer, "dashboard:veh", false)
        
	core = exports.oCore;

	font = exports.oFont:getFont("bebasneue", 17);
	font2 = exports.oFont:getFont("condensed", 12);
	color, R, G, B = exports.oCore:getServerColor();

	end
end)

local sX, sY = guiGetScreenSize();

local pX, pY = 1920, 1080;

local kapu;

local core = exports.oCore;

local font = exports.oFont:getFont("bebasneue", 17);
local font2 = exports.oFont:getFont("condensed", 12);
local color, R, G, B = exports.oCore:getServerColor();
osszeg = 25;

local hatarTimer;

local mutat = 1;

local theElement;

local ids = {1};

local pdistance = 0;
local tick = getTickCount()
local alpha1;
local word = "Zárolás";
local text = {word,"Felnyit","Lezár"};
R1, G1, B1 = 250, 250, 250;
R2, G2, B2 = 250, 250, 250; 
function rajz()
	    alpha1 = interpolateBetween ( 
		a1, 0, 0,
		a2, 0, 0,
		 (getTickCount()-tick)/300, "Linear");

		dxDrawRectangle(750/pX*sX, 480/pY*sY, 420/pX*sX, 120/pY*sY, tocolor(32, 32, 32, 255*alpha1), false);

		dxDrawRectangle(754/pX*sX, 484/pY*sY, 412/pX*sX, 112/pY*sY, tocolor(40, 40, 40, 255*alpha1), false);

		dxDrawRectangle(758/pX*sX, 552/pY*sY, 200/pX*sX, 40/pY*sY, tocolor(32, 32, 32, 255*alpha1), false);

		dxDrawRectangle(962/pX*sX, 552/pY*sY, 200/pX*sX, 40/pY*sY, tocolor(32, 32, 32, 255*alpha1), false);

		dxDrawText("Átkelés",758/pX*sX, 552/pY*sY, 958/pX*sX, 592/pY*sY, tocolor(R1, G1, B1, 255*alpha1), 1/pX*sX, font2, "center","center", false,false,false,true);

		dxDrawText("Mégsem", 962/pX*sX, 552/pY*sY, 1162/pX*sX, 592/pY*sY, tocolor(R2, G2, B2, 255*alpha1), 1/pX*sX, font2, "center","center", false,false,false,true);

		dxDrawText("Átszeretnél kelni a határon "..color..""..osszeg.."$#dcdcdc-ért?", 818/pX*sX, 512/pY*sY, 1162/pX*sX, 552/pY*sY, tocolor(220, 220, 220, 255*alpha1), 0.9/pX*sX, font2, "left","center", false,false,false,true);

		dxDrawText("HATÁRÁTKELÉS", 818/pX*sX, 492/pY*sY, 1162/pX*sX, 512/pY*sY, tocolor(250, 250, 250, 255*alpha1), 1/pX*sX, font, "left","center", false,false,false,true);

		dxDrawImage(758/pX*sX, 488/pY*sY, 50/pX*sX, 50/pY*sY, "logo.png", 0, 0, 0, tocolor(R, G, B, 255*alpha1));

		if  core:isInSlot(758/pX*sX, 552/pY*sY, 200/pX*sX, 40/pY*sY) then
			R1, G1, B1 = R, G, B;
			R2, G2, B2 = 250, 250, 255; 
		elseif core:isInSlot(962/pX*sX, 552/pY*sY, 200/pX*sX, 40/pY*sY) then
			R2, G2, B2 = 245, 66, 66;
			R1, G1, B1 = 250, 250, 255;
		else
			R1, G1, B1 = 250, 250, 255;
			R2, G2, B2 = 250, 250, 255; 	
		end

end

function draw()
	for i = 1, 3 do
		if core:isInSlot((674+(i*120))/pX*sX, 434/pY*sY, 100/pX*sX, 40/pY*sY) then
			inbox = tocolor(R, G, B, 255*alpha1);
		else
			inbox = tocolor(250, 250, 250, 255*alpha1);	
		end		
		dxDrawRectangle((674+(i*120))/pX*sX, 434/pY*sY, 100/pX*sX, 40/pY*sY, tocolor(40, 40, 40, 255*alpha1), false);
		dxDrawText(text[i], (674+(i*120))/pX*sX, 434/pY*sY, (774+(i*120))/pX*sX, 474/pY*sY, inbox, 1/pX*sX, font2	, "center","center", false,false,false,true);
	end
end	

function click(key, state)
	if state then
		if key == "mouse1" then
				if core:isInSlot(794/pX*sX, 434/pY*sY, 100/pX*sX, 40/pY*sY) then
				local free = getElementData(stop, "free") or false;	
					if not (free) then	
					triggerServerEvent("set", root, stop);
					set = getElementData(stop, "set") or false;	
						if (set) then
							text[1] = "Zárolás";
						else
	 						text[1] = "Feloldás";
						end	
					end	
				elseif core:isInSlot(914/pX*sX, 434/pY*sY, 100/pX*sX, 40/pY*sY) then
				local free = getElementData(stop, "free") or false;	
					if not (free) then
					local set = getElementData(stop, "set") or false;
						if not (set) then		
							triggerServerEvent("up", root, stop, kapu);
						end	
					end	
				elseif core:isInSlot(1034/pX*sX, 434/pY*sY, 100/pX*sX, 40/pY*sY) then
				local free = getElementData(stop, "free") or false;	
					if (free) then
					local set = getElementData(stop, "set") or false;
						if not (set) then							
							triggerServerEvent("down", root, stop, kapu);
						end
					end	

				end	
		end	
	end	
end

function kattint(key,state)

	if state then

		if key == "mouse1" then

			if core:isInSlot(962/pX*sX, 552/pY*sY, 200/pX*sX, 40/pY*sY) then 
            	tick = getTickCount()
				a1 = 1
				a2 = 0;
				setTimer(
					function()	
						removeEventHandler("onClientRender", root, rajz);
						removeEventHandler("onClientRender", root, draw);					
					end,
				500,1);	

				showCursor(false);

				removeEventHandler("onClientKey", root, kattint);
				removeEventHandler("onClientKey", root, click);
				triggerServerEvent("open", root, theElement);

				if (isTimer(hatarTimer)) then

					killTimer(hatarTimer);

				end

				hatarTimer = false;
				mutat = 1;	

			elseif core:isInSlot(758/pX*sX, 552/pY*sY, 200/pX*sX, 40/pY*sY) then

				local pMoney = getElementData(localPlayer, "char:money");

				if (pMoney >= osszeg) then
				local free = getElementData(stop, "free") or false;	
					if not(free) then
					local set = getElementData(stop, "set") or false;
						if not (set) then
							tick = getTickCount()
							a1 = 1
							a2 = 0;
							setTimer(
								function()	
									removeEventHandler("onClientRender", root, rajz);
									removeEventHandler("onClientRender", root, draw);
								end,
							500,1);	

							showCursor(false);

							removeEventHandler("onClientKey", root, kattint);
							removeEventHandler("onClientKey", root, click);

							killTimer(hatarTimer);
							hatarTimer = false;

							triggerServerEvent("sikeres", root, osszeg, localPlayer, kapu, stop);

							triggerServerEvent("open", root, theElement);

								kapu = 0;
								pdistance = 0;
								mutat = 1;
						end	
					end			

				else

					outputChatBox(core:getServerPrefix("red-dark", "Határ", 3).."Nincs elég pénzed ahoz,hogy átmehess a határon!", 0, 0, 0, true);

				end	

			end	

		end	

	end	

end



addEventHandler("onClientClick", root,

	function(button, state, _, _, _, _, _, clickedElement)	

		if (button == "right") and (state == "up") then

			if (clickedElement) then
				for i = 1, 4 do	
					if (getElementData(clickedElement, "katt") == "hatar"..i) then
					local work = getElementData(clickedElement, "moving") or false;
						if not (work) then
							if not (mutat == 0) then
							local using = getElementData(clickedElement, "used") or false;	
								if not (using) then
								local free = getElementData(clickedElement, "free") or false;
								local set = getElementData(clickedElement, "set") or false;		
									if not(free) or not(set) then
										naa(clickedElement);
										kapu = i;
										stop = clickedElement;
										triggerServerEvent("closed", root, clickedElement);
									else
										for i, v in pairs(ids) do
										local faction = getElementData(localPlayer, "char:duty:faction");
											if (faction == ids[i]) then
												naa(clickedElement);
												kapu = i;
												stop = clickedElement;
												triggerServerEvent("closed", root, clickedElement);
												break;
											end	
										end		
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

function naa(clickedElement)
    mutat = 1;
    theElement = clickedElement;
	hatarTimer = setTimer(
		function ()
					local pdistance = core:getDistance(localPlayer, clickedElement);

						if (pdistance <= 5) then

						local vehicle = getPedOccupiedVehicle(localPlayer);

							if (vehicle) then 
								if (mutat == 1) then
									tick = getTickCount()
									a1 = 0
									a2 = 1;

									addEventHandler("onClientRender", root, rajz);

									addEventHandler("onClientKey", root, kattint);
									for i, v in pairs(ids) do
									local faction = getElementData(localPlayer, "char:duty:faction");
										if (faction == ids[i]) then
											addEventHandler("onClientRender", root, draw);
											addEventHandler("onClientKey", root, click);
											break;
										end	
									end	
									mutat = 0;

								end	
							else
								tick = getTickCount()
								a1 = 1
								a2 = 0;
								setTimer(
									function()	
										removeEventHandler("onClientRender", root, rajz);
										removeEventHandler("onClientRender", root, draw);
									end,
								500,1);	
									removeEventHandler("onClientKey", root, kattint);
									removeEventHandler("onClientKey", root, click);

									triggerServerEvent("open", root, clickedElement);
								
								if (isTimer(hatarTimer)) then

									killTimer(hatarTimer);

								end

								mutat = 1;
							end

					else
						tick = getTickCount()
						a1 = 1
						a2 = 0;
						setTimer(
							function()	
								removeEventHandler("onClientRender", root, rajz);
								removeEventHandler("onClientRender", root, draw);
							end,
						500,1);	
						removeEventHandler("onClientKey", root, kattint);
						triggerServerEvent("open", root, clickedElement);
						removeEventHandler("onClientKey", root, click);
						if (isTimer(hatarTimer)) then

							killTimer(hatarTimer);

						end

						hatarTimer = false;
						mutat = 1;
						return;
					end
		end,
	50,0);				
end

setDevelopmentMode(true);
