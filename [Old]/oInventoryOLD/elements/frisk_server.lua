local func = {}

func["friskItems"] = function(playerSource, targetPlayer)
	if (targetPlayer) then
		local targetItems = getElementItems(playerSource,targetPlayer,0)
		triggerClientEvent(playerSource,"setFriskItems",playerSource,targetItems[targetPlayer],targetPlayer)	
	end
end
addEvent("getFriskItems", true)
addEventHandler("getFriskItems", getRootElement(), func["friskItems"])