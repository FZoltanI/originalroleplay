addEvent("giveMoney", true)
addEventHandler("giveMoney", resourceRoot, function(money)
    setElementData(client, "char:money", getElementData(client, "char:money") + money)
end)