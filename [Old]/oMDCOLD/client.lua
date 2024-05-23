local sX, sY = guiGetScreenSize()
local pX, pY = 1980, 1080;
local scolor, R, G, B = exports.oCore:getServerColor();
local core = exports.oCore
local font = exports.oFont:getFont("bebasneue", 14);
local font3 = exports.oFont:getFont("bebasneue", 20);
local font4 = exports.oFont:getFont("condensed", 15);
local font5 = exports.oFont:getFont("condensed", 12);
local font6 = exports.oFont:getFont("bebasneue", 18);
local font7 = exports.oFont:getFont("condensed", 10);
local font8 = exports.oFont:getFont("condensed", 8);
local accounts;
local core = exports.oCore;
local slider = 0;
local reasons = {};
local players = {};
local wanted_person = {};
local wanted_car = {};
local penalcodes = {};
local ids = {1};
local date = {};
local preview =  exports.oPreview;
local userdatas = {
	[1] = {""},
	[2] = {""},
	[3] = {""},
	[4] = {""},
	[5] = {""},
};	

addEvent("mdc:tabelExport", true);
addEventHandler("mdc:tabelExport", getRootElement(),
	function (tabel, tabel2, tabel4, tabel5)
		accounts = tabel;
		penalcodes = tabel2;
		wanted_person = tabel4;
		wanted_car = tabel5;
	end
);

function openMDc()
	if not (showing) then
		--[[addEventHandler("onClientRender", root, loginDesign);
		addEventHandler("onClientKey", root, LoginUsing);
		showing = true;]]
		addEventHandler("onClientRender", root, panel);
		addEventHandler("onClientRender", root, wantedPerson);
		addEventHandler("onClientKey", root, wantedPersonUsing);
		addEventHandler("onClientKey", root, using);
		addEventHandler("onClientKey", root, moderation);
		showing = true; handled1 = true;
		players = getElementsByType("player");	
	end	
end
addCommandHandler("mdc", openMDc);	

local color = {
	tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 255),
};
function panel()
	dxDrawRectangle(560/pX*sX, 190/pY*sY, 800/pX*sX, 700/pY*sY, tocolor(32, 32, 32, 255), false);
	dxDrawRectangle(560/pX*sX, 190/pY*sY, 75/pX*sX, 700/pY*sY, tocolor(34, 34, 34, 255), false);
	dxDrawImage(560/pX*sX, 190/pY*sY, 75/pX*sX, 75/pY*sY, "files/logo.png", 0, 0, 0, tocolor(R, G, B, 255));
	dxDrawImage(575/pX*sX, 275/pY*sY, 45/pX*sX, 45/pY*sY, "files/male.png", 0, 0, 0, color[1]);
	dxDrawImage(575/pX*sX, 340/pY*sY, 45/pX*sX, 45/pY*sY, "files/car.png", 0, 0, 0, color[2]);
	dxDrawImage(575/pX*sX, 405/pY*sY, 45/pX*sX, 45/pY*sY, "files/book.png", 0, 0, 0, color[3]);
	dxDrawImage(575/pX*sX, 835/pY*sY, 45/pX*sX, 45/pY*sY, "files/close.png", 0, 0, 0, color[4]);
	for i=1,3 do
		if core:isInSlot(575/pX*sX, (200+(i*65))/pY*sY, 45/pX*sX, 45/pY*sY) then
			color[i] = tocolor(R, G, B, 255);
		else
			color[i] = tocolor(255, 255, 255, 255);	
		end	
	end
	if core:isInSlot(575/pX*sX, 835/pY*sY, 45/pX*sX, 45/pY*sY) then
	color[4] = tocolor(245, 66, 66, 255);
		else
	color[4] = tocolor(255, 255, 255, 255);		
	end	
end	

function using(button, press)
	if (button == "mouse1") and press then
		for i=1,3 do
			if core:isInSlot(575/pX*sX, (200+(i*65))/pY*sY, 45/pX*sX, 45/pY*sY) then
				if (i == 1) then
					if not (handled1) then	
						out();	
						addEventHandler("onClientRender", root, panel);					
						addEventHandler("onClientRender", root, wantedPerson);
						addEventHandler("onClientKey", root, wantedPersonUsing);
						addEventHandler("onClientKey", root, moderation);
						addEventHandler("onClientKey", root, using);
						handled1 = true; handled2 = false; handled3 = false; handled4 = false; handled5 = false;
						reasons = {};
					end	
				elseif (i == 2) then
					if not (handled2) then
						out();
						addEventHandler("onClientRender", root, panel);
						addEventHandler("onClientKey", root, moderation2);
						addEventHandler("onClientRender", root, wantedCar);
						addEventHandler("onClientKey", root, wantedCarUsing);
						addEventHandler("onClientKey", root, using);
						handled1 = false; handled2 = true; handled3 = false; handled4 = false; handled5 = false;
						reasons = {};
					end
				elseif (i == 3) then
					if not (handled3) then
						out();
						addEventHandler("onClientRender", root, panel);
						addEventHandler("onClientRender", root, penalCode);
						addEventHandler("onClientKey", root, using);	
						handled1 = false; handled2 = false; handled3 = true; handled4 = false; handled5 = false;
					end	
				end	
			end	
		end
		if core:isInSlot(575/pX*sX, 835/pY*sY, 45/pX*sX, 45/pY*sY) then
			out();
		end	
	end	
end

local color2 = {
	tocolor(255, 255, 255, 255),
};

function penalCode()
	dxDrawRectangle(640/pX*sX, 195/pY*sY, 175/pX*sX, 660/pY*sY, tocolor(34, 34, 34, 255), false);
	dxDrawRectangle(820/pX*sX, 195/pY*sY, 150/pX*sX, 660/pY*sY, tocolor(34, 34, 34, 255), false);
	dxDrawRectangle(975/pX*sX, 195/pY*sY, 187.5/pX*sX, 660/pY*sY, tocolor(34, 34, 34, 255), false);
	dxDrawRectangle(1167.5/pX*sX, 195/pY*sY, 187.5/pX*sX, 660/pY*sY, tocolor(34, 34, 34, 255), false);
	dxDrawText("Megnevezés",640/pX*sX, 195/pY*sY, 815/pX*sX, 230/pY*sY, tocolor(255, 255, 255, 255), 1/pX*sX, font, "center", "center",false, false, false, true);
	dxDrawText("Rövidítés",820/pX*sX, 195/pY*sY, 970/pX*sX, 230/pY*sY, tocolor(255, 255, 255, 255), 1/pX*sX, font, "center", "center",false, false, false, true);
	dxDrawText("Büntetés",975/pX*sX, 195/pY*sY, 1162.5/pX*sX, 230/pY*sY, tocolor(255, 255, 255, 255), 1/pX*sX, font, "center", "center",false, false, false, true);
	dxDrawText("Megjegyzés", 1167.5/pX*sX, 195/pY*sY, 1355/pX*sX, 230/pY*sY, tocolor(255, 255, 255, 255), 1/pX*sX, font, "center", "center",false, false, false, true);
end

local text = {
	[1] = {"Utolsó kiadott körözés", "Utolsó körözést kiadta", "Utolsó körözés kiadása", "Utolsó körözést kiadó szerv",},
	[2] = {"Adatok törlése", "Körözés kiadása",},
	[3] = {"name", "issued", "date", "faction"},
	[4] = {"Törlés", "Módosítás"},
	[5] = {""},
	[6] = {"placetext", "issued", "date", "faction"},
};



function wantedPerson()
	dxDrawRectangle(920/pX*sX, 195/pY*sY, 435/pX*sX, 140/pY*sY, tocolor(34, 34, 34, 255), false);
	dxDrawText("KÖRÖZÖTT SZEMÉLYEK",640/pX*sX, 190/pY*sY, 840/pX*sX, 230/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, font3, "left", "center",true, false, false, false);
	dxDrawText("KÖRÖZÉS KIADÁSA",925/pX*sX, 195/pY*sY, 1100/pX*sX, 240/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, font6, "left", "center",true, false, false, false);
	dxDrawText("Elkövetett büncselekmények:",930/pX*sX, 254/pY*sY, 1100/pX*sX, 370/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, font5, "left", "center",false, false, false, true);
	dxDrawRectangle(1155/pX*sX, 296.5/pY*sY, 195/pX*sX, 30/pY*sY, tocolor(32, 32, 32, 255), false);
	for i = 1, 4 do
		if (i == 4) then
			startX = 850;
			endX = 910;
			length = 60;
			color8 = tocolor(44, 80, 138, 255);
			if (#wanted_person > 0) then
				text5 = wanted_person[#wanted_person][text[3][i]];
			else
				text5 = "-";	
			end	
		elseif (i == 3) then
			if (#wanted_person > 0) then
				text5 = fromJSON(wanted_person[#wanted_person][text[3][i]]);
				text5 = string.format("%02d.%02d.%02d. %02d:%02d", text5[1], text5[2], text5[3], text5[4], text5[5]); 
			else
				text5 = "-";				
			end		
		else
			startX = 805;
			endX = 915;
			length = 110;
			color8 = tocolor(R, G, B, 255);
			if (#wanted_person > 0) then
				text5 = wanted_person[#wanted_person][text[3][i]];
			else
				text5 = "-";				
			end	
		end	
		dxDrawText(text[1][i]..":",640/pX*sX, (190+(i*25))/pY*sY, 840/pX*sX, (230+(i*25))/pY*sY, tocolor(158, 158, 158, 255), 1/pX*sX, font, "left", "center",true, false, false, false);
		roundedRectangle(startX/pX*sX, (200+(i*25))/pY*sY, length/pX*sX, 20/pY*sY, color8, false);
		dxDrawText(text5,startX/pX*sX, (200+(i*25))/pY*sY, endX/pX*sX, (220+(i*25))/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, font7, "center", "center",true, false, false, false);
	end
	for i=1, 2 do
		if (i%2 == 0) then
			color5 = tocolor(R, G, B, 255);
		else
			color5 = tocolor(245, 66, 66, 255);
		end	
		dxDrawRectangle(925/pX*sX, (197+(i*32))/pY*sY, 425/pX*sX, 30/pY*sY, tocolor(32, 32, 32, 255), false);
		roundedRectangle((1025+(i*110))/pX*sX, 200/pY*sY, 100/pX*sX, 20/pY*sY, color5, false);
		dxDrawText(text[2][i],(1025+(i*110))/pX*sX, 200/pY*sY, (1125+(i*110))/pX*sX, 220/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, font7, "center", "center",true, false, false, false);
	end
	if (#userdatas[3][1] > 0) then
		text2 = userdatas[3][1];
	else	
		text2 = "Név";
	end	
	dxDrawImage(1320/pX*sX, 263/pY*sY, 24/pX*sX, 26/pY*sY, "files/multimedia.png", 90, 0, 0, color6);
	dxDrawImage(1320/pX*sX, 298.5/pY*sY, 24/pX*sX, 26/pY*sY, "files/multimedia.png", 90, 0, 0, color7);
	dxDrawText("Elkövetett büncselekmény hozzáadása",930/pX*sX, 259/pY*sY, 1300/pX*sX, 294/pY*sY, color6, 1/pX*sX, font5, "left", "center",true, false, false, false);
	dxDrawText(text2,925/pX*sX, 232/pY*sY, 1350/pX*sX, 257/pY*sY, tocolor(158, 158, 158, 255), 1/pX*sX, font5, "center", "center", true, false, false, false);
	if core:isInSlot(925/pX*sX, 259/pY*sY, 425/pX*sX, 30/pY*sY) then
		color6 = tocolor(255, 255, 255, 255);
	elseif core:isInSlot(1155/pX*sX, 296.5/pY*sY, 195/pX*sX, 30/pY*sY) then	
		color7 = tocolor(255, 255, 255, 255);	
	else
		color6 = tocolor(158, 158, 158, 255);
		color7 = tocolor(158, 158, 158, 255);	
	end
	if (#wanted_person > 0) then
		for i = 1, 4 do
			if (i%2 == 0) then
				alpha3 = 155;
			else
				alpha3 = 255;
			end
			if (wanted_person[slider + i]) then	
				p = i;
				datetext = fromJSON(wanted_person[slider+i]["date"]);
				dxDrawRectangle(650/pX*sX, (215+(i*125))/pY*sY, 695/pX*sX, 120/pY*sY, tocolor(34, 34, 34, alpha3), false);
				dxDrawRectangle(650/pX*sX, (215+(i*125))/pY*sY, 3/pX*sX, 120/pY*sY, tocolor(R, G, B, alpha3), false);
				dxDrawText(wanted_person[slider+i]["name"], 800/pX*sX, (215+(i*125))/pY*sY, 940/pX*sX, (265+(i*125))/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, font6, "left", "center",true, false, false, false);
				dxDrawText("Körözést kiadta: "..scolor..wanted_person[slider+i]["issued"].."#2c508a ["..wanted_person[slider+i]["faction"].."]",800/pX*sX, (255+(i*125))/pY*sY, 1050/pX*sX, (270+(i*125))/pY*sY, tocolor(158, 158, 158, 255), 1/pX*sX, font5, "left", "center",false, false, false, true);
				dxDrawText("Körözést oka(i): "..scolor..table.concat(fromJSON(wanted_person[slider+i]["reasons"]), " , "),800/pX*sX, (280+(i*125))/pY*sY, 1050/pX*sX, (295+(i*125))/pY*sY, tocolor(158, 158, 158, 255), 1/pX*sX, font5, "left", "center",false, false, false, true);
				dxDrawText("Egyéb: "..scolor..wanted_person[slider+i]["other"],800/pX*sX, (305+(i*125))/pY*sY, 1050/pX*sX, (320+(i*125))/pY*sY, tocolor(158, 158, 158, 255), 1/pX*sX, font5, "left", "center",false, false, false, true);
				dxDrawImage(1180/pX*sX, (307.5+(i*125))/pY*sY, 20/pX*sX, 20/pY*sY, "files/pen.png", 0, 0, 0, tocolor(158, 158, 158, 255));
				datetext = string.format("%02d.%02d.%02d. %02d:%02d", datetext[1], datetext[2], datetext[3], datetext[4], datetext[5]); 
				dxDrawText(datetext, 1195/pX*sX, (305+(i*125))/pY*sY, 1345/pX*sX, (335+(i*125))/pY*sY, tocolor(158, 158, 158, 255), 1/pX*sX, font5, "center", "center",true, false, false, false);
				dxDrawImage(1320/pX*sX, (220+(i*125))/pY*sY, 25/pX*sX, 25/pY*sY, "files/settings.png", 0, 0, 0, tocolor(158, 158, 158, 255));
				dxDrawText( wanted_person[slider+i]["age"].." év", 955/pX*sX, (217.5+(i*125))/pY*sY, 995/pX*sX, (237.5+(i*125))/pY*sY, tocolor(158, 158, 158, 255), 1/pX*sX, font7, "center", "center",true, false, false, false);
				if (wanted_person[slider+i]["sexual"] == "2") then
					who = "files/male.png";
				elseif (wanted_person[slider+i]["sexual"] == "1") then
					who = "files/female.png";
				else
					who = "files/question.png";
				end	
				dxDrawImage(687.5/pX*sX, (237.5+(i*125))/pY*sY, 75/pX*sX, 75/pY*sY, who, 0, 0, 0, tocolor(158, 158, 158, 255));
				for a=1,2 do
					if (a%2 == 0) then
						color8 = tocolor(R, G, B, 255);
						text[5][1] = wanted_person[slider+i]["weight"].." kg";
					else
						color8 = tocolor(245, 66, 66, 255);
						text[5][1] = wanted_person[slider+i]["height"].." cm";
					end	
					dxDrawText(text[5][1], (900+(a*40))/pX*sX, (230+(i*125))/pY*sY, (940+(a*40))/pX*sX, (250+(i*125))/pY*sY, tocolor(158, 158, 158, 255), 1/pX*sX, font8, "center", "center",true, false, false, false);
					roundedRectangle((1010+(a*105))/pX*sX, (222.5+(i*125))/pY*sY, 100/pX*sX, 20/pY*sY, color8, false);
					dxDrawText(text[4][a], (1010+(a*105))/pX*sX, (222.5+(i*125))/pY*sY, (1110+(a*105))/pX*sX, (242.5+(i*125))/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, font7, "center", "center",true, false, false, false);
				end
			end
		end	
	end
	if (handled4) then
		dxDrawRectangle(925/pX*sX, 299/pY*sY, 425/pX*sX, 100/pY*sY, tocolor(40, 40, 40, 255), false);
		for i=1,3 do
			if (penalcodes[slider+i]["short"]) then
				dxDrawText("-"..penalcodes[slider+i]["short"],925/pX*sX, (266.5+(i*33))/pY*sY, 1350/pX*sX, (299.5+(i*33))/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, font5, "center", "center", true, false, false, false);
			end			
		end
	end
	if (handled5) then
		dxDrawRectangle(1155/pX*sX, 328.5/pY*sY, 195/pX*sX, 100/pY*sY, tocolor(40, 40, 40, 255), false);
		for i=1,#reasons do
			if (reasons[slider+i]) then
				dxDrawText("-"..reasons[slider+i],1155/pX*sX, (295.5+(i*33))/pY*sY, 1350/pX*sX, (328.5+(i*33))/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, font5, "center", "center", true, false, false, false);
			end
		end
	end	
end

function wantedCar()
	dxDrawRectangle(920/pX*sX, 195/pY*sY, 435/pX*sX, 140/pY*sY, tocolor(34, 34, 34, 255), false);
	dxDrawText("KÖRÖZÖTT JÁRMŰVEK",640/pX*sX, 190/pY*sY, 840/pX*sX, 230/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, font3, "left", "center",true, false, false, false);
	dxDrawText("KÖRÖZÉS KIADÁSA",925/pX*sX, 195/pY*sY, 1100/pX*sX, 240/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, font6, "left", "center",true, false, false, false);
	dxDrawText("Elkövetett büncselekmények:",930/pX*sX, 254/pY*sY, 1100/pX*sX, 370/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, font5, "left", "center",false, false, false, true);
	dxDrawRectangle(1155/pX*sX, 296.5/pY*sY, 195/pX*sX, 30/pY*sY, tocolor(32, 32, 32, 255), false);
	for i = 1, 4 do
		if (i == 4) then
			startX = 850;
			endX = 910;
			length = 60;
			color8 = tocolor(44, 80, 138, 255);
			if (#wanted_car > 0) then
				text5 = wanted_car[#wanted_car][text[6][i]];
			else
				text5 = "-";	
			end	
		elseif (i == 3) then
			if (#wanted_car > 0) then
				text5 = fromJSON(wanted_car[#wanted_car][text[6][i]]);
				text5 = string.format("%02d.%02d.%02d. %02d:%02d", text5[1], text5[2], text5[3], text5[4], text5[5]); 
			else
				text5 = "-";				
			end		
		else
			startX = 805;
			endX = 915;
			length = 110;
			color8 = tocolor(R, G, B, 255);
			if (#wanted_car > 0) then
				text5 = wanted_car[#wanted_car][text[6][i]];
			else
				text5 = "-";				
			end	
		end	
		dxDrawText(text[1][i]..":",640/pX*sX, (190+(i*25))/pY*sY, 840/pX*sX, (230+(i*25))/pY*sY, tocolor(158, 158, 158, 255), 1/pX*sX, font, "left", "center",true, false, false, false);
		roundedRectangle(startX/pX*sX, (200+(i*25))/pY*sY, length/pX*sX, 20/pY*sY, color8, false);
		dxDrawText(text5,startX/pX*sX, (200+(i*25))/pY*sY, endX/pX*sX, (220+(i*25))/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, font7, "center", "center",true, false, false, false);
	end
	for i=1, 2 do
		if (i%2 == 0) then
			color5 = tocolor(R, G, B, 255);
		else
			color5 = tocolor(245, 66, 66, 255);
		end	
		dxDrawRectangle(925/pX*sX, (197+(i*32))/pY*sY, 425/pX*sX, 30/pY*sY, tocolor(32, 32, 32, 255), false);
		roundedRectangle((1025+(i*110))/pX*sX, 200/pY*sY, 100/pX*sX, 20/pY*sY, color5, false);
		dxDrawText(text[2][i],(1025+(i*110))/pX*sX, 200/pY*sY, (1125+(i*110))/pX*sX, 220/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, font7, "center", "center",true, false, false, false);
	end
	if (#userdatas[3][1] > 0) then
		text2 = userdatas[3][1];
	else	
		text2 = "Rendszám";
	end	
	dxDrawImage(1320/pX*sX, 263/pY*sY, 24/pX*sX, 26/pY*sY, "files/multimedia.png", 90, 0, 0, color6);
	dxDrawImage(1320/pX*sX, 298.5/pY*sY, 24/pX*sX, 26/pY*sY, "files/multimedia.png", 90, 0, 0, color7);
	dxDrawText("Elkövetett büncselekmény hozzáadása",930/pX*sX, 259/pY*sY, 1300/pX*sX, 294/pY*sY, color6, 1/pX*sX, font5, "left", "center",true, false, false, false);
	dxDrawText(text2,925/pX*sX, 232/pY*sY, 1350/pX*sX, 257/pY*sY, tocolor(158, 158, 158, 255), 1/pX*sX, font5, "center", "center", true, false, false, false);
	if core:isInSlot(925/pX*sX, 259/pY*sY, 425/pX*sX, 30/pY*sY) then
		color6 = tocolor(255, 255, 255, 255);
	elseif core:isInSlot(1155/pX*sX, 296.5/pY*sY, 195/pX*sX, 30/pY*sY) then	
		color7 = tocolor(255, 255, 255, 255);	
	else
		color6 = tocolor(158, 158, 158, 255);
		color7 = tocolor(158, 158, 158, 255);	
	end
	if (#wanted_car > 0) then
		for i = 1, 4 do
			if (i%2 == 0) then
				alpha3 = 155;
			else
				alpha3 = 255;
			end
			if (wanted_car[slider + i]) then	
				p = i;
				datetext = fromJSON(wanted_car[slider+i]["date"]);
				dxDrawRectangle(650/pX*sX, (215+(i*125))/pY*sY, 695/pX*sX, 120/pY*sY, tocolor(34, 34, 34, alpha3), false);
				dxDrawRectangle(650/pX*sX, (215+(i*125))/pY*sY, 3/pX*sX, 120/pY*sY, tocolor(R, G, B, alpha3), false);
				dxDrawText(wanted_car[slider+i]["placetext"], 800/pX*sX, (215+(i*125))/pY*sY, 940/pX*sX, (265+(i*125))/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, font6, "left", "center",true, false, false, false);
				dxDrawText("Körözést kiadta: "..scolor..wanted_car[slider+i]["issued"].."#2c508a ["..wanted_car[slider+i]["faction"].."]",800/pX*sX, (255+(i*125))/pY*sY, 1050/pX*sX, (270+(i*125))/pY*sY, tocolor(158, 158, 158, 255), 1/pX*sX, font5, "left", "center",false, false, false, true);
				dxDrawText("Körözést oka(i): "..scolor..table.concat(fromJSON(wanted_car[slider+i]["reasons"]), " , "),800/pX*sX, (280+(i*125))/pY*sY, 1050/pX*sX, (295+(i*125))/pY*sY, tocolor(158, 158, 158, 255), 1/pX*sX, font5, "left", "center",false, false, false, true);
				dxDrawText("Egyéb: "..scolor..wanted_car[slider+i]["other"],800/pX*sX, (305+(i*125))/pY*sY, 1050/pX*sX, (320+(i*125))/pY*sY, tocolor(158, 158, 158, 255), 1/pX*sX, font5, "left", "center",false, false, false, true);
				dxDrawImage(1180/pX*sX, (307.5+(i*125))/pY*sY, 20/pX*sX, 20/pY*sY, "files/pen.png", 0, 0, 0, tocolor(158, 158, 158, 255));
				datetext = string.format("%02d.%02d.%02d. %02d:%02d", datetext[1], datetext[2], datetext[3], datetext[4], datetext[5]); 
				dxDrawText(datetext, 1195/pX*sX, (305+(i*125))/pY*sY, 1345/pX*sX, (335+(i*125))/pY*sY, tocolor(158, 158, 158, 255), 1/pX*sX, font5, "center", "center",true, false, false, false);
				dxDrawImage(1320/pX*sX, (220+(i*125))/pY*sY, 25/pX*sX, 25/pY*sY, "files/settings.png", 0, 0, 0, tocolor(158, 158, 158, 255));
				dxDrawText( wanted_car[slider+i]["type"], 955/pX*sX, (217.5+(i*125))/pY*sY, 995/pX*sX, (237.5+(i*125))/pY*sY, tocolor(158, 158, 158, 255), 1/pX*sX, font7, "center", "center",false, false, false, true);	
				dxDrawImage(687.5/pX*sX, (237.5+(i*125))/pY*sY, 75/pX*sX, 75/pY*sY, "files/car.png", 0, 0, 0, tocolor(158, 158, 158, 255));
				dxDrawText(wanted_car[slider+i]["color"], 955/pX*sX, (230+(i*125))/pY*sY, 995/pX*sX, (250+(i*125))/pY*sY, tocolor(158, 158, 158, 255), 1/pX*sX, font8, "center", "center",true, false, false, false);				
				for a=1,2 do
					if (a%2 == 0) then
						color8 = tocolor(R, G, B, 255);
					else
						color8 = tocolor(245, 66, 66, 255);
					end	
					roundedRectangle((1010+(a*105))/pX*sX, (222.5+(i*125))/pY*sY, 100/pX*sX, 20/pY*sY, color8, false);
					dxDrawText(text[4][a], (1010+(a*105))/pX*sX, (222.5+(i*125))/pY*sY, (1110+(a*105))/pX*sX, (242.5+(i*125))/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, font7, "center", "center",true, false, false, false);
				end
			end
		end	
	end
	if (handled4) then
		dxDrawRectangle(925/pX*sX, 299/pY*sY, 425/pX*sX, 100/pY*sY, tocolor(40, 40, 40, 255), false);
		for i=1,3 do
			if (penalcodes[slider+i]["short"]) then
				dxDrawText("-"..penalcodes[slider+i]["short"],925/pX*sX, (266.5+(i*33))/pY*sY, 1350/pX*sX, (299.5+(i*33))/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, font5, "center", "center", true, false, false, false);
			end
		end
	end
	if (handled5) then
		dxDrawRectangle(1155/pX*sX, 328.5/pY*sY, 195/pX*sX, 100/pY*sY, tocolor(40, 40, 40, 255), false);
		for i=1,#reasons do
			if (reasons[slider+i]) then
				dxDrawText("-"..reasons[slider+i],1155/pX*sX, (295.5+(i*33))/pY*sY, 1350/pX*sX, (328.5+(i*33))/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, font5, "center", "center", true, false, false, false);
			end
		end
	end	
end

local text3 = {
	"Felhasználónév","Jelszó",
};

function loginDesign()
	dxDrawRectangle(760/pX*sX, 440/pY*sY, 400/pX*sX, 200/pY*sY, tocolor(32, 32, 32, 255), false);
	dxDrawRectangle(762/pX*sX, 442/pY*sY, 396/pX*sX, 196/pY*sY, tocolor(34, 34, 34, 255), false);
	dxDrawRectangle(1006/pX*sX, 444/pY*sY, 150/pX*sX, 60/pY*sY, tocolor(30, 30, 30, 255), false);
	dxDrawRectangle(1008/pX*sX, 446/pY*sY, 3/pX*sX, 56/pY*sY, tocolor(245, 66, 66, 255), false);
	dxDrawImage(764/pX*sX, 444/pY*sY, 60/pX*sX, 60/pY*sY, "files/logo.png", 0, 0, 0, tocolor(R, G, B, 255));
	dxDrawText("Mégsem",1006/pX*sX, 444/pY*sY, 1156/pX*sX, 504/pY*sY, color3, 1/pX*sX, font4, "center", "center",true, false, false, true);
	dxDrawText("MDC Login panel",829/pX*sX, 444/pY*sY, 1156/pX*sX, 474/pY*sY, tocolor(R, G, B, 255), 1/pX*sX, font4, "left", "center",true, false, false, true);
	dxDrawText("OriginalRoleplay",829/pX*sX, 464/pY*sY, 1156/pX*sX, 504/pY*sY, tocolor(255, 255, 255, 255), 1/pX*sX, font5, "left", "center",true, false, false, true);
	for i=1,3 do
	if (i%2 == 0) then
		alpha2 = 155
	else
		alpha2 = 255
	end	
		dxDrawRectangle(764/pX*sX, (466+(i*43))/pY*sY, 392/pX*sX, 40/pY*sY, tocolor(30, 30, 30, alpha2), false);
		dxDrawRectangle(764/pX*sX, (468+(i*43))/pY*sY, 2/pX*sX, 36/pY*sY, tocolor(R, G, B, alpha2), false);
	end
	for i=1,2 do
		dxDrawText(text3[i]..":",772/pX*sX, (466+(i*43))/pY*sY, 1156/pX*sX, (506+(i*43))/pY*sY, tocolor(255, 255, 255, 255), 1/pX*sX, font5, "left", "center",true, false, false, true);
	if (i%2 == 0) then
		text4 = string.rep("*", string.len(userdatas[i][1]));
	else
		text4 = userdatas[i][1]
	end	
		dxDrawText(text4,772/pX*sX, (466+(i*43))/pY*sY, 1150/pX*sX, (506+(i*43))/pY*sY, tocolor(R, G, B, 255), 1/pX*sX, font5, "right", "center",true, false, false, true);
	end
	dxDrawText("Bejelentkezés",764/pX*sX, 595/pY*sY, 1156/pX*sX, 635/pY*sY, color4, 1/pX*sX, font5, "center", "center",true, false, false, true);
	if core:isInSlot(764/pX*sX, 595/pY*sY, 392/pX*sX, 40/pY*sY) then
		color4 = tocolor(R, G, B, 255);
	elseif core:isInSlot(1006/pX*sX, 444/pY*sY, 150/pX*sX, 60/pY*sY) then
		color3 = tocolor(245, 66, 66, 255);
	else
		color3 = tocolor(255, 255, 255, 255);
		color4 = tocolor(255, 255, 255, 255);
	end	
end	

function LoginUsing(button, press)
	if (button == "mouse1") and press then
		if core:isInSlot(1006/pX*sX, 444/pY*sY, 150/pX*sX, 60/pY*sY) then
			out();
		elseif core:isInSlot(764/pX*sX, 509/pY*sY, 392/pX*sX, 40/pY*sY) then
			removeEventHandler("onClientKey", root, pressedcharachter);
			addEventHandler("onClientKey", root, pressedcharachter);
			index = 1;
		elseif core:isInSlot(764/pX*sX, 552/pY*sY, 392/pX*sX, 40/pY*sY) then
			removeEventHandler("onClientKey", root, pressedcharachter);
			addEventHandler("onClientKey", root, pressedcharachter);
			index = 2;
		elseif core:isInSlot(764/pX*sX, 595/pY*sY, 392/pX*sX, 40/pY*sY) then
			if (accounts) then
				if (#accounts > 0) then
					if (accounts[1]["password"] ==  userdatas[2][1]) then
						exports.oInfoBox:outputInfoBox("Sikeres Bejelentkezés!", "success");
						out();
						addEventHandler("onClientRender", root, panel);
						addEventHandler("onClientRender", root, wantedPerson);
						addEventHandler("onClientKey", root, using);
						showing = true; handled1 = true;
					else
						exports.oInfoBox:outputInfoBox("Sikertelen Bejelentkezés!", "error");				
					end	
				else
					exports.oInfoBox:outputInfoBox("Sikertelen Bejelentkezés!", "error");
				end
			else
				exports.oInfoBox:outputInfoBox("Sikertelen Bejelentkezés!", "error");		
			end	
							
		end
	elseif (button == "backspace") then
		userdatas[index][1] = string.sub(userdatas[index][1], 0, string.len(userdatas[index][1])-1);			
	end	
end

function wantedPersonUsing(button, press)
	if (button == "mouse1") and press then
		if core:isInSlot(925/pX*sX, 222/pY*sY, 425/pX*sX, 30/pY*sY) then
			removeEventHandler("onClientKey", root, pressedcharachter2);
			addEventHandler("onClientKey", root, pressedcharachter2);
			index = 3;
		elseif core:isInSlot(925/pX*sX, 264/pY*sY, 425/pX*sX, 30/pY*sY) then	
			if not(handled5) then
				if not (handled4) then
					slider = 0;
					tabel3 = penalcodes;
					handled4 = true;
					addEventHandler("onClientKey", root, scroll);
					addEventHandler("onClientKey", root, reasonSelect);
				else
					handled4 = false;	
					removeEventHandler("onClientKey", root, scroll);
					removeEventHandler("onClientKey", root, reasonSelect);
				end
			end	
		elseif core:isInSlot(1155/pX*sX, 296.5/pY*sY, 195/pX*sX, 30/pY*sY) then	
			if not(handled4) then
				if not(handled5) then
					slider = 0;
					tabel3 = reasons;
					handled5 = true;
					addEventHandler("onClientKey", root, scroll);
				else
					handled5 = false;	
					removeEventHandler("onClientKey", root, scroll);
				end		
			end
		elseif core:isInSlot(1135/pX*sX, 200/pY*sY, 100/pX*sX, 20/pY*sY) then
			userdatas[3][1] = "";
			reasons = {};
			removeEventHandler("onClientKey", root, pressedcharachter2)
		elseif core:isInSlot(1245/pX*sX, 200/pY*sY, 100/pX*sX, 20/pY*sY) then
			if (#userdatas[3][1] > 0) then
				if not(#reasons == 0) then
				issued = getElementData(localPlayer, "char:name");
				date[1] = core:getDate("year") or "0";
				date[2] = core:getDate("month") or "0";
				date[3] = core:getDate("monthday") or "0";
				date[4] = core:getDate("hour") or "0";
				date[5] = core:getDate("minute") or "0";
				faction = getElementData(localPlayer, "char:duty:faction");
				name = userdatas[3][1];
				for i,v in ipairs(ids) do
					if (faction == v) then
						faction = "LSPD";
					else	
						faction = "SHERIFF";
					end		
				end	
				local person = exports.oCore:getPlayerFromPartialName(localPlayer, name);
					if (person) then
						age = getElementData(person, "char:age");
						height = getElementData(person, "char:height");
						weight = getElementData(person, "char:weight");
						sexual = tostring(getElementData(person, "char:gender"));
					else	
						age = "?";
						height = "?";
						weight = "?";
						sexual = "?";
					end	
					triggerServerEvent("mdc:addWanted_Person", root, name, age, height, weight, reasons, issued, faction, date, sexual);
					reasons = {};
					userdatas[3][1] = "";
					removeEventHandler("onClientKey", root, pressedcharachter2);
				end	
			end	
		end
	elseif (button == "backspace") and press then
		userdatas[index][1] = string.sub(userdatas[index][1], 0, string.len(userdatas[index][1])-1);			
	end	
end

function wantedCarUsing(button, press)
	if (button == "mouse1") and press then
		if core:isInSlot(925/pX*sX, 222/pY*sY, 425/pX*sX, 30/pY*sY) then
			removeEventHandler("onClientKey", root, pressedcharachter2);
			addEventHandler("onClientKey", root, pressedcharachter2);
			index = 3;
		elseif core:isInSlot(925/pX*sX, 264/pY*sY, 425/pX*sX, 30/pY*sY) then	
			if not(handled5) then
				if not (handled4) then
					slider = 0;
					tabel3 = penalcodes;
					handled4 = true;
					addEventHandler("onClientKey", root, scroll);
					addEventHandler("onClientKey", root, reasonSelect);
				else
					handled4 = false;	
					removeEventHandler("onClientKey", root, scroll);
					removeEventHandler("onClientKey", root, reasonSelect);
				end
			end	
		elseif core:isInSlot(1155/pX*sX, 296.5/pY*sY, 195/pX*sX, 30/pY*sY) then	
			if not(handled4) then
				if not(handled5) then
					slider = 0;
					tabel3 = reasons;
					handled5 = true;
					addEventHandler("onClientKey", root, scroll);
				else
					handled5 = false;	
					removeEventHandler("onClientKey", root, scroll);
				end		
			end
		elseif core:isInSlot(1135/pX*sX, 200/pY*sY, 100/pX*sX, 20/pY*sY) then
			userdatas[3][1] = "";
			reasons = {};
			removeEventHandler("onClientKey", root, pressedcharachter2)
		elseif core:isInSlot(1245/pX*sX, 200/pY*sY, 100/pX*sX, 20/pY*sY) then
			if (#userdatas[3][1] > 0) then
				if not(#reasons == 0) then
				issued = getElementData(localPlayer, "char:name");
				date[1] = core:getDate("year") or "0";
				date[2] = core:getDate("month") or "0";
				date[3] = core:getDate("monthday") or "0";
				date[4] = core:getDate("hour") or "0";
				date[5] = core:getDate("minute") or "0";
				faction = getElementData(localPlayer, "char:duty:faction");
				number_plate = userdatas[3][1];
				for i,v in ipairs(ids) do
					if (faction == v) then
						faction = "LSPD";
					else	
						faction = "SHERIFF";
					end		
				end	
				getVehicleByPlateText(number_plate);
					if (veh) then
						typev = exports.oVehicle:getModdedVehicleName(veh);
						colorv = getVehicleColor(veh, false);
					else	
						typev = "?";
						color = "?";
					end
					table.insert(wanted_car, name ,age, height, weight, toJSON(reasons), issued, faction, toJSON(date), "-", sexual);	
					triggerServerEvent("mdc:addWanted_Car", root, number_plate, typev, colorv, reasons, issued, faction, date, wanted_car);
					outputChatBox(number_plate.." "..colorv.." "..typev.." "..issued.." "..faction)
					reasons = {};
					userdatas[3][1] = "";
					removeEventHandler("onClientKey", root, pressedcharachter2);
				end	
			end	
		end
	elseif (button == "backspace") and press then
		userdatas[index][1] = string.sub(userdatas[index][1], 0, string.len(userdatas[index][1])-1);			
	end	
end

function pressedcharachter(button, press)
	if button and press then
		cancelEvent();
		--if (exports.oCore:getHungarian(button)) then
			--if (exports.oCore:getHungarianKeyboardLetter("button")) then
				if (exports.oCore:keyIsRealKeyboardLetter(button)) or (button == "space") then
					if getKeyState("lshift") then 
						button = string.upper(button); 
					elseif (button == "space") then
						button = " ";	
					end						
					--if not (string.len(userdatas[index][1]) > 15) then
						userdatas[index][1] = userdatas[index][1]..button;
						cancelEvent();
					--end
				end	
			--end		
		--	end	
	end	
end

function pressedcharachter2(button, press)
	if button and press then
		cancelEvent();
		--if (exports.oCore:getHungarian(button)) then
			--if (exports.oCore:getHungarianKeyboardLetter("button")) then
				if (exports.oCore:keyIsRealKeyboardLetter(button)) or (button == "space") then
					if getKeyState("lshift") then 
						button = string.upper(button); 
					elseif (button == "space") then
						button = "_";	
					end	
					--if not (string.len(userdatas[index][1]) > 100) then
						userdatas[index][1] = userdatas[index][1]..button;
						cancelEvent();
					
					--end
				end	
			--end		
		--	end	
	end	
end

function reasonSelect(button, press)
	if (button == "mouse1") and press then
		for i=1,3 do
		w = i;	
			if core:isInSlot(925/pX*sX, (266.5+(i*33))/pY*sY, 425/pX*sX, 33/pY*sY) then
				if (#reasons > 0) then
					for k,v in ipairs(reasons) do
						if (v == penalcodes[slider+w]["short"]) then
							return false;
						end	
					end
					table.insert(reasons, penalcodes[slider+w]["short"]);
				else
					table.insert(reasons, penalcodes[slider+i]["short"]);	
				end	
			end	
		end
	end	
end

function moderation(button, press)
	if (button == "mouse1") and press then
		for i=1,4 do
			if (wanted_person[slider+i]) then
				if core:isInSlot(1115/pX*sX, (222.5+(i*125))/pY*sY, 100/pX*sX, 20/pY*sY) then
					tableid = wanted_person[slider+i]["id"]
					table.remove(wanted_person, slider+i);	
					triggerServerEvent("delReport", root, tableid, wanted_person);			
				elseif core:isInSlot(1220/pX*sX, (222.5+(i*125))/pY*sY, 100/pX*sX, 20/pY*sY) then
					if not handled4 and not handled5 and not handled6 then
						handled6 = true;
						addEventHandler("onClientRender", root, moderationPanel);
						addEventHandler("onClientKey", root, moderationusing);
						userdatas[4][1] = wanted_person[slider+i]["name"]; 
						userdatas[5][1] = wanted_person[slider+i]["other"];
						tabel_reasons = fromJSON(wanted_person[slider+i]["reasons"]); 
						id = wanted_person[slider+i]["id"];
						id2 = wanted_person[slider+i];
					end	
				end	
			end
		end
	end	
end

function moderation2(button, press)
	if (button == "mouse1") and press then
		for i=1,4 do
			if (wanted_car[slider+i]) then
				if core:isInSlot(1115/pX*sX, (222.5+(i*125))/pY*sY, 100/pX*sX, 20/pY*sY) then
					tableid = wanted_person[slider+i]["id"]
					table.remove(wanted_car, slider+i)
					triggerServerEvent("delReport_car", root, tableid, wanted_car);				
				elseif core:isInSlot(1220/pX*sX, (222.5+(i*125))/pY*sY, 100/pX*sX, 20/pY*sY) then
					if not handled4 and not handled5 and not handled6 then
						handled6 = true;
						addEventHandler("onClientRender", root, moderationPanel);
						addEventHandler("onClientKey", root, moderationusing2);
						userdatas[4][1] = wanted_car[slider+i]["placetext"]; 
						userdatas[5][1] = wanted_car[slider+i]["other"]; 
						tabel_reasons = fromJSON(wanted_car[slider+i]["reasons"]); 
						id = wanted_car[slider+i]["id"];
						id2 = wanted_car[slider+i];
					end	
				end	
			end
		end
	end	
end

local text6 = {
	"Név","Egyéb","Büncselekmények",
};

function moderationPanel()
	dxDrawRectangle(760/pX*sX, 440/pY*sY, 400/pX*sX, 200/pY*sY, tocolor(32, 32, 32, 255), false);
	dxDrawRectangle(762/pX*sX, 442/pY*sY, 396/pX*sX, 196/pY*sY, tocolor(34, 34, 34, 255), false);
	dxDrawRectangle(836/pX*sX, 444/pY*sY, 150/pX*sX, 60/pY*sY, tocolor(30, 30, 30, 255), false);
	dxDrawRectangle(838/pX*sX, 446/pY*sY, 3/pX*sX, 56/pY*sY, tocolor(R, G, B, 255), false);
	dxDrawRectangle(1006/pX*sX, 444/pY*sY, 150/pX*sX, 60/pY*sY, tocolor(30, 30, 30, 255), false);
	dxDrawRectangle(1008/pX*sX, 446/pY*sY, 3/pX*sX, 56/pY*sY, tocolor(245, 66, 66, 255), false);
	dxDrawImage(764/pX*sX, 444/pY*sY, 60/pX*sX, 60/pY*sY, "files/logo.png", 0, 0, 0, tocolor(R, G, B, 255));
	dxDrawText("Mégsem",1006/pX*sX, 444/pY*sY, 1156/pX*sX, 504/pY*sY, color3, 1/pX*sX, font4, "center", "center",true, false, false, true);
	dxDrawText("Elfogadás",836/pX*sX, 444/pY*sY, 986/pX*sX, 504/pY*sY, color9, 1/pX*sX, font4, "center", "center",true, false, false, true);
	for i=1,3 do
	if (i%2 == 0) then
		alpha2 = 155
	else
		alpha2 = 255
	end	
		dxDrawRectangle(764/pX*sX, (466+(i*43))/pY*sY, 392/pX*sX, 40/pY*sY, tocolor(30, 30, 30, alpha2), false);
		dxDrawRectangle(764/pX*sX, (468+(i*43))/pY*sY, 2/pX*sX, 36/pY*sY, tocolor(R, G, B, alpha2), false);
		dxDrawText(text6[i]..":",772/pX*sX, (466+(i*43))/pY*sY, 1156/pX*sX, (506+(i*43))/pY*sY, tocolor(255, 255, 255, 255), 1/pX*sX, font5, "left", "center",false, false, false, true);
	end
	for i=1,2 do
	if (i%2 == 0) then
		text7 = userdatas[5][1]
	else
		text7 = userdatas[4][1]
	end	
		dxDrawText(text7,772/pX*sX, (466+(i*43))/pY*sY, 1150/pX*sX, (506+(i*43))/pY*sY, tocolor(R, G, B, 255), 1/pX*sX, font5, "right", "center",true, false, false, true);
	end
	if core:isInSlot(764/pX*sX, 595/pY*sY, 392/pX*sX, 40/pY*sY) then
		color4 = tocolor(220, 220, 220, 255);
		color3 = tocolor(255, 255, 255, 255);
		color9 = tocolor(255, 255, 255, 255);
	elseif core:isInSlot(1006/pX*sX, 444/pY*sY, 150/pX*sX, 60/pY*sY) then
		color3 = tocolor(245, 66, 66, 255);
		color4 = tocolor(158, 158, 158, 255);
		color9 = tocolor(255, 255, 255, 255);
	elseif core:isInSlot(836/pX*sX, 444/pY*sY, 150/pX*sX, 60/pY*sY) then
		color9 = tocolor(R, G, B, 255);	
		color3 = tocolor(255, 255, 255, 255);
		color4 = tocolor(158, 158, 158, 255);	
	else
		color3 = tocolor(255, 255, 255, 255);
		color4 = tocolor(158, 158, 158, 255);
		color9 = tocolor(255, 255, 255, 255);
	end	
	dxDrawImage(1125/pX*sX, 605/pY*sY, 20/pX*sX, 20/pY*sY, "files/multimedia.png", 90, 0, 0, color4);
	if (show_reasons) then
		dxDrawRectangle(764/pX*sX, 645/pY*sY, 392/pX*sX, 100/pY*sY, tocolor(40, 40, 40, alpha2), false);
		for i=1,3 do
			if (penalcodes[slider+i]["short"]) then
				dxDrawText("-"..penalcodes[slider+i]["short"],764/pX*sX, (612.5+(i*33))/pY*sY, 1156/pX*sX, (646+(i*33))/pY*sY, tocolor(220, 220, 220, 255), 1/pX*sX, font5, "center", "center", true, false, false, false);
				for k,v in pairs(tabel_reasons) do
					if (v == penalcodes[slider+i]["short"]) then
						color10 = tocolor(R, G, B, 255);
						break;
					else
						color10 = tocolor(34, 34, 34, 255);	
					end	
				end	
				dxDrawImage(1127/pX*sX, (616+(i*33))/pY*sY, 26/pX*sX, 26/pY*sY, "files/square.png", 0, 0, 0, color10);
			end	
		end	
	end	
end	

function moderationusing(button, press)
	if (button == "mouse1") and press then
		if core:isInSlot(1006/pX*sX, 444/pY*sY, 150/pX*sX, 60/pY*sY) then
			removeEventHandler("onClientRender", root, moderationPanel);
			removeEventHandler("onClientKey", root, pressedcharachter);
			removeEventHandler("onClientKey", root, moderationusing);
			removeEventHandler("onClientKey", root, reasonmoderation);
			handled6 = false;
		elseif core:isInSlot(764/pX*sX, 509/pY*sY, 392/pX*sX, 40/pY*sY) then
			removeEventHandler("onClientKey", root, pressedcharachter);
			addEventHandler("onClientKey", root, pressedcharachter);
			index = 4;
		elseif core:isInSlot(764/pX*sX, 552/pY*sY, 392/pX*sX, 40/pY*sY) then
			removeEventHandler("onClientKey", root, pressedcharachter);
			addEventHandler("onClientKey", root, pressedcharachter);
			index = 5;
		elseif core:isInSlot(836/pX*sX, 444/pY*sY, 150/pX*sX, 60/pY*sY) then
			id2["name"] = userdatas[4][1]; id2["other"] = userdatas[5][1]; id2["reasons"] = tabel_reasons;
			triggerServerEvent("updateReport", root, userdatas[4][1], userdatas[5][1], tabel_reasons, id, wanted_person);	
			removeEventHandler("onClientRender", root, moderationPanel);
			removeEventHandler("onClientKey", root, pressedcharachter);
			removeEventHandler("onClientKey", root, moderationusing);
			removeEventHandler("onClientKey", root, reasonmoderation);
			handled6 = false;
		elseif core:isInSlot(764/pX*sX, 595/pY*sY, 392/pX*sX, 40/pY*sY) then
			if not (show_reasons) then
				show_reasons = true;
				addEventHandler("onClientKey", root, reasonmoderation);
			else
				show_reasons = false;	
				removeEventHandler("onClientKey", root, reasonmoderation);
			end						
		end		
	end	
end

function moderationusing2(button, press)
	if (button == "mouse1") and press then
		if core:isInSlot(1006/pX*sX, 444/pY*sY, 150/pX*sX, 60/pY*sY) then
			removeEventHandler("onClientRender", root, moderationPanel);
			removeEventHandler("onClientKey", root, pressedcharachter);
			removeEventHandler("onClientKey", root, moderationusing2);
			removeEventHandler("onClientKey", root, reasonmoderation);
			handled6 = false;
		elseif core:isInSlot(764/pX*sX, 509/pY*sY, 392/pX*sX, 40/pY*sY) then
			removeEventHandler("onClientKey", root, pressedcharachter);
			addEventHandler("onClientKey", root, pressedcharachter);
			index = 4;
		elseif core:isInSlot(764/pX*sX, 552/pY*sY, 392/pX*sX, 40/pY*sY) then
			removeEventHandler("onClientKey", root, pressedcharachter);
			addEventHandler("onClientKey", root, pressedcharachter);
			index = 5;
		elseif core:isInSlot(836/pX*sX, 444/pY*sY, 150/pX*sX, 60/pY*sY) then
			triggerServerEvent("updateReport_car", root, userdatas[4][1], userdatas[5][1], tabel_reasons, id);	
			removeEventHandler("onClientRender", root, moderationPanel);
			removeEventHandler("onClientKey", root, pressedcharachter);
			removeEventHandler("onClientKey", root, moderationusing2);
			removeEventHandler("onClientKey", root, reasonmoderation);
			handled6 = false;
		elseif core:isInSlot(764/pX*sX, 595/pY*sY, 392/pX*sX, 40/pY*sY) then
			if not (show_reasons) then
				show_reasons = true;
				addEventHandler("onClientKey", root, reasonmoderation);
			else
				show_reasons = false;	
				removeEventHandler("onClientKey", root, reasonmoderation);
			end								
		end		
	end	
end

function reasonmoderation(button, press)
	if (button == "mouse1") and press then
		for i=1,3 do
			if (penalcodes[slider+i]["short"]) then
				if core:isInSlot(764/pX*sX, (612.5+(i*33))/pY*sY, 392/pX*sX, 33/pY*sY) then
				num = 0;	
					for k,v in pairs(tabel_reasons) do
					num = num + 1; 	
						if (v == penalcodes[slider+i]["short"]) then
							table.remove(tabel_reasons, num);
							return false;
						end	
					end	
					table.insert(tabel_reasons, penalcodes[slider+i]["short"]);
				end		
			end	
		end
	end	
end

function out()
	removeEventHandler("onClientRender", root, panel);
	removeEventHandler("onClientKey", root, using);
	removeEventHandler("onClientRender", root, penalCode);
	removeEventHandler("onClientRender", root, wantedPerson);
	removeEventHandler("onClientRender", root, wantedCar);
	removeEventHandler("onClientRender", root, moderationPanel);
	removeEventHandler("onClientRender", root, loginDesign);
	removeEventHandler("onClientKey", root, LoginUsing);
	removeEventHandler("onClientKey", root, wantedPersonUsing);
	removeEventHandler("onClientKey", root, wantedCarUsing);
	showing = false;
	removeEventHandler("onClientKey", root, pressedcharachter);
	removeEventHandler("onClientKey", root, pressedcharachter2);
	removeEventHandler("onClientKey", root, scroll);
	removeEventHandler("onClientKey", root, reasonSelect);
	removeEventHandler("onClientKey", root, moderation);
	removeEventHandler("onClientKey", root, moderation2);
	removeEventHandler("onClientKey", root, moderationusing);
	removeEventHandler("onClientKey", root, moderationusing2);
	removeEventHandler("onClientKey", root, reasonmoderation);
	userdatas[1][1] = ""; userdatas[2][1] = ""; userdatas[3][1] = ""; userdatas[4][1] = ""; userdatas[5][1] = "";
	handled1 = false; handled2 = false; handled3 = false; handled4 = false; handled5 = false; handled6 = false;
	slider = 0;
	reasons = {};
end	

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 200);
		end
		if (not bgColor) then
			bgColor = borderColor;
		end
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI);
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI);
	end
end


function scroll(key, pOr)
	if (key == "mouse_wheel_down") then 
		if not((#tabel3-3) == slider) then 
			slider = slider + 1; 
		end
	elseif (key == "mouse_wheel_up") then 
		if (slider > 0) then 
			slider = slider - 1; 
		end
	end
end
	
addEvent("mdc:getWanted_Person", true);
addEventHandler("mdc:getWanted_Person", root,
	function (tabel4)
		wanted_person = tabel4;
	end
)

addEvent("mdc:getWanted_Car", true);
addEventHandler("mdc:getWanted_Car", root,
	function (tabel5)
		wanted_car = tabel5;
	end
)

function getVehicleByPlateText(plateText)
  for k, v in ipairs(getElementsByType("vehicle")) do 
  veh = v
    if getVehiclePlateText(v) == plateText then 
    	return v
    end
  end
end