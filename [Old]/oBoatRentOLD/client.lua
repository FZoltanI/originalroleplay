addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oBoatRent" or getResourceName(res) == "oPreview" or getResourceName(res) == "oFont" then  
        
	 font = exports.oFont:getFont("condensed", 11)
 	fontscript = exports.oFont:getFont("bebasneue", 18)
	serverColor, sR, sG, sB = exports.oCore:getServerColor()
	core = exports.oCore
	preview =  exports.oPreview;
	end
end)

local sX, sY = guiGetScreenSize();
local pX, pY = 1920, 1080;

local kolcsonzoped = createPed(142, 154.00476074219, -1943.2685546875, 3.7734375, 0, 0, 0);
setElementFrozen(kolcsonzoped, true);
setElementData(kolcsonzoped, "katt", "kolcsonzo1");
setElementData(kolcsonzoped, "ped:name", "Logan Mars")
setElementData(kolcsonzoped, "ped:prefix", "Hajókölcsönző")

local kolcsonzoTimer;
local ido = 0;
local osszeg1 = 0;
local vehID = 0;
local font = exports.oFont:getFont("condensed", 11)
local fontscript = exports.oFont:getFont("bebasneue", 18)
local serverColor, sR, sG, sB = exports.oCore:getServerColor()
local core = exports.oCore
local tick = getTickCount ();
local tick2 = getTickCount ();
local tick3 = getTickCount ();
local tick4 = getTickCount ();

local kivalasztottkocsi = "NINCSEN KIVÁLASZTOTT JÁRMŰ";

local showing = 0;
local x1 = 0;
local x2 = 811;
local a1, a2, a3, a4, a5, a6 = 0, 0, 0, 0, 0, 0;
local rectangleX = 811;
local alpha1 = 0;
local alpha2 = 0;
local fix = 0;
local rcolor = tocolor(255, 255, 255, 255*alpha1);
local lcolor = tocolor(255, 255, 255, 255*alpha1);
local alpha3 = 150;
local preview =  exports.oPreview;
local o3dvehicle;
function rajz()
	rectangleX = interpolateBetween(
				x1, 0, 0,
				x2, 0, 0,	
				(getTickCount()-tick)/300, "Linear");

		alpha1 = interpolateBetween(
					a1, 0, 0,
					a2, 0, 0,	
					(getTickCount()-tick2)/500, "Linear");					 	
	
		
	alpha2 = interpolateBetween(
				a3, 0, 0,
				a4, 0, 0,	
				(getTickCount()-tick4)/500, "Linear");						
	dxDrawRectangle((rectangleX-8)/pX*sX, 315/pY*sY, 314/pX*sX, 450/pY*sY, tocolor(32, 32, 32, 255*alpha2), false);
	dxDrawRectangle((rectangleX-4)/pX*sX, 319/pY*sY, 306/pX*sX, 442/pY*sY, tocolor(40, 40, 40, 255*alpha2), false);
	dxDrawRectangle(rectangleX/pX*sX, 323/pY*sY, 299/pX*sX, 60/pY*sY, tocolor(32, 32, 32, 255*alpha2), false);
	dxDrawRectangle(rectangleX/pX*sX, 717/pY*sY, 299/pX*sX, 40/pY*sY, tocolor(32, 32, 32, 255*alpha2), false);
	dxDrawText("Mégsem", rectangleX/pX*sX, 717/pY*sY, (rectangleX+299)/pX*sX, 757/pY*sY, tocolor(R1, G1, B1, 255*alpha2), 1/pX*sX, font, "center","center", false,false,false,true);	
	dxDrawText("Hajókölcsönző", rectangleX/pX*sX, 323/pY*sY, (rectangleX+299)/pX*sX, 383/pY*sY, tocolor(220, 220, 220, 255*alpha2), 1/pX*sX, fontscript, "center","center", false,false,false,true);	
	for i = 1, #rentboats do
	if (i%2 == 0) then
		alpha = 150;
	else
		alpha = 255;
	end	
	font2 = font; 
	dxDrawRectangle(rectangleX/pX*sX, (343+(i*42))/pY*sY, 299/pX*sX, 40/pY*sY, tocolor(35, 35, 35, alpha*alpha2), false);
	dxDrawRectangle(rectangleX/pX*sX, (343.5+(i*42))/pY*sY, 2/pX*sX, 39/pY*sY, tocolor(sR, sG, sB, alpha*alpha2), false);
	for a = 1, #rentboats do
		if core:isInSlot(rectangleX/pX*sX, (343+(i*42))/pY*sY, 299/pX*sX, 40/pY*sY) or (kivalasztottkocsi == i) then
			dxDrawRectangle(rectangleX/pX*sX, (343+(i*42))/pY*sY, 299/pX*sX, 40/pY*sY, tocolor(sR, sG, sB, 75*alpha2), false);
		end	
	end
	dxDrawText(rentboats[i][4], rectangleX/pX*sX, (423+(i*42))/pY*sY, (rectangleX+299)/pX*sX, (307+(i*42))/pY*sY, tocolor(220, 220, 220, 255*alpha2), 1/pX*sX, font2, "center","center", false,false,false,true);
	dxDrawRectangle(867/pX*sX, 315/pY*sY, 500/pX*sX, 450/pY*sY, tocolor(32, 32, 32, 255*alpha1), false);
	dxDrawRectangle(871/pX*sX, 319/pY*sY, 492/pX*sX, 442/pY*sY, tocolor(40, 40, 40, 255*alpha1), false);
	dxDrawRectangle(875/pX*sX, 323/pY*sY, 484/pX*sX, 213/pY*sY, tocolor(35, 35, 35, 255*alpha1), false);
	end
	for v = 1, 5 do
	if (v%2 == 0) then
		alpha = 150;
	else
		alpha = 255;
	end		
		dxDrawRectangle(875/pX*sX, (496+(v*44))/pY*sY, 484/pX*sX, 40/pY*sY, tocolor(35, 35, 35, alpha*alpha1), false);
		dxDrawRectangle(875/pX*sX, (496.5+(v*44))/pY*sY, 2/pX*sX, 39/pY*sY, tocolor(sR, sG, sB, alpha*alpha1), false);
	end
	dxDrawImage(1164/pX*sX, 547.5/pY*sY, 25/pX*sX, 25/pY*sY, "icon/balra.png", 0, 0, 0, lcolor, false);
	dxDrawImage(1314/pX*sX, 547.5/pY*sY, 25/pX*sX, 25/pY*sY, "icon/jobbra.png", 0, 0, 0, rcolor, false);
	dxDrawText("Bérlési idő:", 895/pX*sX, 540/pY*sY, 1045/pX*sX, 580/pY*sY, tocolor(220, 220, 220, 255*alpha1), 1/pX*sX, font, "left","center", false,false,false,true);
	dxDrawText(ido.." perc", 1189/pX*sX, 540/pY*sY, 1309/pX*sX, 580/pY*sY, tocolor(220, 220, 220, 255*alpha1), 1/pX*sX, font, "center","center", false,false,false,true);
	dxDrawText("Javítási költség:", 895/pX*sX, 584/pY*sY, 1045/pX*sX, 624/pY*sY, tocolor(220, 220, 220, 255*alpha1), 1/pX*sX, font, "left","center", false,false,false,true);
	dxDrawText(fix.."$ #dcdcdc sérülésenként", 1179/pX*sX, 584/pY*sY, 1339/pX*sX, 624/pY*sY, tocolor(sR, sG, sB, 255*alpha1), 1/pX*sX, font, "right","center", false,false,false,true);
	dxDrawText("Fizetendő:", 895/pX*sX, 628/pY*sY, 1045/pX*sX, 670/pY*sY, tocolor(220, 220, 220, 255*alpha1), 1/pX*sX, font, "left","center", false,false,false,true);
	dxDrawText(osszeg1.."$", 1189/pX*sX, 628/pY*sY, 1339/pX*sX, 670/pY*sY, tocolor(sR, sG, sB, 255*alpha1), 1/pX*sX, font, "right","center", false,false,false,true);
	dxDrawText("Bérlés:", 895/pX*sX, 674/pY*sY, 1045/pX*sX, 714/pY*sY, tocolor(220, 220, 220, 255*alpha1), 1/pX*sX, font, "left","center", false,false,false,true);
	dxDrawRectangle(1189/pX*sX, 676/pY*sY, 150/pX*sX, 34/pY*sY, tocolor(sR, sG, sB, alpha3*alpha1), false);
	dxDrawText("Bérlés", 1189/pX*sX, 674/pY*sY, 1339/pX*sX, 714/pY*sY, tocolor(220, 220, 220, 255*alpha1), 1/pX*sX, font, "center","center", false,false,false,true);
	dxDrawText("Original Roleplay", 895/pX*sX, 718/pY*sY, 1339/pX*sX, 758/pY*sY, tocolor(sR, sG, sB, 255*alpha1), 1/pX*sX, fontscript, "center","center", false,false,false,true);	
	if core:isInSlot(1164/pX*sX, 547.5/pY*sY, 25/pX*sX, 25/pY*sY) then
		rcolor = tocolor(255, 255, 255, 255*alpha1);
		lcolor = tocolor(sR, sG, sB, 255*alpha1);
	elseif core:isInSlot(1314/pX*sX, 547.5/pY*sY, 25/pX*sX, 25/pY*sY) then	
		rcolor = tocolor(sR, sG, sB, 255*alpha1);
		lcolor = tocolor(255, 255, 255, 255*alpha1);
	else
		rcolor = tocolor(255, 255, 255, 255*alpha1);
		lcolor = tocolor(255, 255, 255, 255*alpha1);	
	end	
	if core:isInSlot(rectangleX/pX*sX, 717/pY*sY, 299/pX*sX, 40/pY*sY) then
		R1, G1, B1 = 245, 66, 66;
	elseif core:isInSlot(1189/pX*sX, 676/pY*sY, 150/pX*sX, 34/pY*sY) then
		alpha3 = 255;		
	else
		R1, G1, B1 = 220, 220, 220;
		alpha3 = 150;	
	end				
end

function kattintas(button, state, _, _, _, _, _, clickedElement)
	if (showing == 0) then
		if (button == "right") and (state == "up") then
			if (clickedElement) then
				if (getElementData(clickedElement, "katt") == "kolcsonzo1") then
					naa(clickedElement);
				end	
			end	
		end	
	end	
end
addEventHandler("onClientClick", root, kattintas);

function naa(clickedElement)
	local mutat = 1;
	kolcsonzoTimer =  setTimer(
		function()	
			local distance = core:getDistance(localPlayer, kolcsonzoped);
				if (distance <= 4) then
				local vehicle = getPedOccupiedVehicle(localPlayer);					
					if not(vehicle) then
						if (mutat == 1) then
							tick = getTickCount();
							tick4 = getTickCount();
							a4 = 1;
							addEventHandler("onClientHUDRender", root, rajz);
							addEventHandler("onClientKey", root, click);
							mutat = 0;
							showing = 1;
						end
					else
						leave();										
					end		
				else	
					leave();	
				end
		end,			
	50,0)	
end

function click(button, key)
	if (button == "mouse1") then
		if (key) then
			for i = 1, #rentboats do
				if core:isInSlot(rectangleX/pX*sX, (343+(i*42))/pY*sY, 299/pX*sX, 40/pY*sY) then					
					if not (vehID == rentboats[i][1]) then
						vehID = rentboats[i][1];
						fix =  rentboats[i][3];
						kivalasztottkocsi = i;
						osszeg1 = 0;
						ido = 0;
						if not (there) then
							there = true;
							tick = getTickCount();					
						    x1 = 811;
							x2 = 553;
							setTimer(
								function()
									tick2 = getTickCount();		
									a2 = 1;
									a1 = 0;
									addEventHandler("onClientKey", root, kattint);
									if not (o3dvehicle) then
										o3dvehicle = createVehicle(vehID, 0, 0, 0);
										objPreview = preview:createObjectPreview(o3dvehicle, 360, 0, 140, 875/pX*sX, 363/pY*sY, 484/pX*sX, 220/pY*sY);
										preview:setAlpha(objPreview, 255*alpha2);
										setElementModel(o3dvehicle, vehID);											
									end		
									end
							,300,1);			
						end	
						if (objPreview) then
						preview:setAlpha(objPreview, 255*alpha2);
							if  not (getElementModel(o3dvehicle) == vehID)then
							setElementModel(o3dvehicle, vehID);		
							end			
						end	
					break;							
					end	
				end	 				 			
			if core:isInSlot(rectangleX/pX*sX, 717/pY*sY, 299/pX*sX, 40/pY*sY) then	
				leave();
				break;
			end			
			end
		end
	end				
end	

function kattint(button, key)
	if (button == "mouse1") then
		if (key) then
			if core:isInSlot(1314/pX*sX, 547.5/pY*sY, 25/pX*sX, 25/pY*sY) then
				if not(vehID == 0) then
					if (ido <= 45) then
						ido = ido + 15;
						osszeg1 = ido * rentboats[kivalasztottkocsi][2];									
					end
				else	
					outputChatBox(core:getServerPrefix("server", "CarRent", 3).."Nem adtad meg a kikölcsönözni kívánt hajót!", 0, 0, 0,true);	
				end		
			elseif core:isInSlot(1164/pX*sX, 547.5/pY*sY, 25/pX*sX, 25/pY*sY) then
				if not (vehID == 0) then
					if (ido >= 15) then
						ido = ido - 15;
						osszeg1 = ido * rentboats[kivalasztottkocsi][2];												
					end
				else	
					outputChatBox(core:getServerPrefix("server", "CarRent", 3).."Nem adtad meg a kikölcsönözni kívánt hajót!", 0, 0, 0,true);
				end	
			elseif core:isInSlot(1189/pX*sX, 676/pY*sY, 150/pX*sX, 34/pY*sY) then
				if not(vehID == 0) then
					if not(ido == 0) then
					local pMoney = getElementData(localPlayer, "char:money");	
						if (pMoney >= osszeg1) then
						local van = getElementData(localPlayer, "kolcsonzott1") or false;							
							if not(van) then
								triggerServerEvent("sikeresebb", resourceRoot, localPlayer, vehID, ido, osszeg1, kivalasztottkocsi);	
							else
								outputChatBox(core:getServerPrefix("server", "CarRent", 3).."Már van kölcsönzött hajód", 0, 0, 0,true);	
							end	
							leave();
						else
							outputChatBox(core:getServerPrefix("server", "CarRent", 3).."Nincs elegendő pénzed,hogy megvedd!", 0, 0, 0,true);	
						end	
					else
						outputChatBox(core:getServerPrefix("server", "CarRent", 3).."Nem adtad meg,hogy mennyi időre szeretnéd kibérelni!", 0, 0, 0,true);	
					end
				else
					outputChatBox(core:getServerPrefix("server", "CarRent", 3).."Nem választottál ki hajót!", 0, 0, 0,true);		
				end	
			end	
		end	
	end	
end

function setAlphaFunction()
	if not(alpha2 == 1) then
		preview:setAlpha(objPreview, 255*alpha2);
	end
end
-----------------------
function leave()
	addEventHandler("onClientRender", root, setAlphaFunction)
	if (isTimer(kolcsonzoTimer)) then	
		killTimer(kolcsonzoTimer);
	end	
	kolcsonzoTimer = false;
 	tick4 = getTickCount();
 	a3 = 1;
 	a4 = 0;
	if (alpha1 > 0) then
	 	tick2 = getTickCount();
	 	a1 = 1;
	 	a2 = 0;
	 end	 	
 	setTimer( 
 		function()
			removeEventHandler("onClientHUDRender", root, rajz);
			a2 = 0;
		 	a1 = 0;
		 	a3 = 0;
		 	a4 = 0;
		 	a5 = 0;
		 	a6 = 0;	
		 	mutat = 1;
			 showing = 0;
			ido = 0;
		 	osszeg1 = 0;
		 	vehID = 0;
		 	there = false;	
		 	x2 = 811;
		 	x1 = 0;
		 	rectangleX = 811;
		 	alpha3 = 150;
		 	fix = 0;
		 	if (o3dvehicle) then	
		 		destroyElement(o3dvehicle);
		 	end	
		 	o3dvehicle = false;
		 	objPreview = false;
		 	removeEventHandler("onClientRender", root, setAlphaFunction)
		end,			
	1000,1);
	removeEventHandler("onClientKey", root, click);
	removeEventHandler("onClientKey", root, kattint);
 	showCursor(false);
	kivalasztottkocsi = "NINCSEN KIVÁLASZTOTT JÁRMŰ";
end	