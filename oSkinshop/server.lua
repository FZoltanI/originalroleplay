function buySkinOnServer(player,skinID,skinPrice)
    setElementData(player,"char:money",getElementData(player,"char:money")-skinPrice)

    setElementModel(player, skinID)
end
addEvent("buySkinOnServerSide", true)
addEventHandler("buySkinOnServerSide", resourceRoot, buySkinOnServer)