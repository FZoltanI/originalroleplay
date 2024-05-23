
tablesObjects = {}
tableDealer = {}
pokerSitTables = {}
cardsInUse = {}

function getNewCard(tableId)
	while true do
		local card = math.random ( 1, 52 )
		if not cardsInUse[tableId][card] then
			table.insert ( cardsInUse[tableId], card )
			cardsInUse[tableId][card] = true
			return card
		end
	end
end

addEvent("tableSit", true)
addEventHandler("tableSit", getRootElement(), function(chairId, posX, posY, posZ, tableId, betAmount)
	if not getPedOccupiedVehicle(source) then
		boardId = getElementData(tableId, "pokerTableObjectId")
		--print(boardId)
		if not pokerSitTables[tableId] then pokerSitTables[tableId] = 0 end 
		if pokerSitTables[tableId] <= 5 then 
			pokerSitTables[tableId] = pokerSitTables[tableId] + 1
			card1 = getNewCard(tableId)
			card2 = getNewCard(tableId)
			setElementData(resourceRoot, "pokerBoard."..getElementData(source,"pokerTableId")..".seat."..getElementData(source, "pokerTableSeat")..".pokerCoins", betAmount)
			setElementData(resourceRoot, "pokerBoard."..getElementData(source,"pokerTableId")..".seat."..getElementData(source, "pokerTableSeat")..".pokerCards", {card1,card2})
			setElementData(resourceRoot, "pokerBoard."..getElementData(source,"pokerTableId")..".seat."..getElementData(source, "pokerTableSeat")..".currentCall", 0)
		else 
			infobox:outputInfoBox("Ez a póker asztal tele van!", "warning")
		end
	end
end)

function generatePokerTable()
    for i=1, #pokerTables do 
        local v = pokerTables[i]
        tablesObjects[i] = createObject(4334, v[1], v[2], v[3]-0.5, v[4], v[5], v[6]-180) 
        local x, y, z = v[1], v[2], v[3]
        setElementInterior(tablesObjects[i], v[7])
        setElementDimension(tablesObjects[i], v[8])
		setElementData(tablesObjects[i], "pokerTableObjectId", i)
        setElementData(tablesObjects[i], "minBet", v[9])
        setElementData(tablesObjects[i], "maxBet", v[10])
        tableDealer[i] = createPed(59, x, y - 1.8, z)
		attachElements(tableDealer[i],tablesObjects[i], 0, -1.8, 0.5)
        setElementData(tableDealer[i], "ped:name", "Dealer")
		setElementRotation(tableDealer[i],v[4],v[5],v[6]-180)
        setElementInterior(tableDealer[i], v[7])
        setElementDimension(tableDealer[i], v[8])
        setElementFrozen(tableDealer[i], true)
		triggerClientEvent(source, "requestTables", source, tablesObjects[i])
		--triggerClientEvent(root, "")
		--generateTables()
		
    end
end
addEvent("requestTables", true)
addEventHandler("requestTables", getRootElement(), generatePokerTable)