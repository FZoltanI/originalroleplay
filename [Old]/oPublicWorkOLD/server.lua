local ids = {1};
local core = exports.oCore

--[[for i,player in pairs(getElementsByType("player")) do
		setElementData(player, "publicwork:doing", false);	
end]]

function GivePublicWork(thePlayer, cmd, theWorker, amount)
	for i, v in pairs(ids) do
	local faction = getElementData(thePlayer, "char:duty:faction");
		if (faction == ids[i]) then
		local id = core:getPlayerFromPartialName(thePlayer, theWorker);
			if (amount) and (theWorker) then
				if not(tonumber(amount) > 100) then
					if (id) then
						--if not(id == thePlayer) then
							if (core:getDistance(thePlayer, id) <= 5) then
								if not(getElementData(id, "publicwork:doing")) then
									outputChatBox(core:getServerPrefix("red-dark", "Rendőrség", 3).. "Téged "..amount.." db szemét összeszedésére ítéltek el!",id , 0, 0, 0, true);
									setElementPosition(id, 631.23956298828, -572.01379394531, 16.3359375);
									triggerClientEvent("createTrashs", root, id, amount);
									setElementData(id, "publicwork:doing", true);
									setElementData(id, "publicwork:amount", amount);
									setElementData(id, "publicwork:time", amount*5);
								else
									outputChatBox(core:getServerPrefix("red-dark", "Hiba", 3).. "A játékos,már közmunkára van ítélve!",thePlayer , 0, 0, 0, true);	
								end	
							else
								outputChatBox(core:getServerPrefix("red-dark", "Hiba", 3).. "Túl messze vagy a játékostól!",thePlayer , 0, 0, 0, true);		
							end	
						--else
							--outputChatBox(core:getServerPrefix("red-dark", "Hiba", 3).. "Saját magadat nem tudod közmunkára ítélni!",thePlayer , 0, 0, 0, true);		
						--end	
					else
						outputChatBox(core:getServerPrefix("red-dark", "Hiba", 3).. "Nincs ilyen ID-vel rendelkező játékos!",thePlayer , 0, 0, 0, true);		
					end	
				else
					outputChatBox(core:getServerPrefix("red-dark", "Hiba", 3).. "Nem adhatsz meg 100-nál nagyobb mennyiséget!",thePlayer , 0, 0, 0, true);				
				end		
			else
				outputChatBox(core:getServerPrefix("server", "Használata", 3).. "/publicwork [Játékos ID] [Mennyiség] ",thePlayer , 0, 0, 0, true);			
			end	
		end
	end
end
addCommandHandler("publicwork", GivePublicWork);

function GivePublicWork(thePlayer, cmd, theWorker)
	for i, v in pairs(ids) do
	local faction = getElementData(thePlayer, "char:duty:faction");
		if (faction == ids[i]) then
			if not (theWorker) then
			outputChatBox(core:getServerPrefix("server", "Használata", 3).. "/unpublicwork [Játékos ID]",thePlayer , 0, 0, 0, true);
			else			
			local id = core:getPlayerFromPartialName(thePlayer, theWorker);		
				if (id) then
					--if not(id == thePlayer) then
						if (core:getDistance(thePlayer, id) <= 5) then
							if (getElementData(id, "publicwork:doing")) then
								outputChatBox(core:getServerPrefix("green-dark", "Rendőrség", 3).. "Téged felmentettek a rád kiszabott közmunka alól!",id , 0, 0, 0, true);
								triggerClientEvent("delEverything", root, id);
								setElementData(id, "publicwork:doing", false);
								setElementData(id, "publicwork:amount", false);
								setElementData(id, "publicwork:time", false);
								setPedAnimation(thePlayer);	
							else
								outputChatBox(core:getServerPrefix("red-dark", "Hiba", 3).. "A játékos,nincs közmunkára ítélve!",thePlayer , 0, 0, 0, true);	
							end	
						else
							outputChatBox(core:getServerPrefix("red-dark", "Hiba", 3).. "Túl messze vagy a játékostól!",thePlayer , 0, 0, 0, true);		
						end	
					--else
						--outputChatBox(core:getServerPrefix("red-dark", "Hiba", 3).. "Saját magadat nem tudod közmunkára ítélni!",thePlayer , 0, 0, 0, true);		
					--end	
				else
					outputChatBox(core:getServerPrefix("red-dark", "Hiba", 3).. "Nincs ilyen ID-vel rendelkező játékos!",thePlayer , 0, 0, 0, true);		
				end	
			end						
		end
	end
end
addCommandHandler("unpublicwork", GivePublicWork);

addEvent("setanim", true);
addEventHandler("setanim", root,
	function (thePlayer)
		setPedAnimation(thePlayer, "BOMBER", "BOM_Plant", -1, true, false, false);	
	end
);

addEvent("setanimoff", true);
addEventHandler("setanimoff", root,
	function (thePlayer)
		setPedAnimation(thePlayer);		
	end
);

addEvent("finished", true);
addEventHandler("finished", root,
	function (thePlayer)
		setElementData(thePlayer, "publicwork:doing", false);
		setElementData(thePlayer, "publicwork:amount", false);
		setElementData(thePlayer, "publicwork:time", false);	
	end
);

addEvent("setTime", true);
addEventHandler("setTime", root,
	function (thePlayer, time)
		setElementData(thePlayer, "publicwork:time", time);	
	end
);

addEvent("setAmount", true);
addEventHandler("setAmount", root,
	function (thePlayer, amount)
		setElementData(thePlayer, "publicwork:amount", amount);	
	end
);