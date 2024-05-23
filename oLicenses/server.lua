addEvent("licenses > giveLicenseToPlayer", true)
addEventHandler("licenses > giveLicenseToPlayer", resourceRoot, function(client,type)
  if type == "idcard" then
    inventory:createLicense(client, 1)
    setElementData(client, "char:money", getElementData(client, "char:money")-50)
  elseif type == "fishing" then
    inventory:createLicense(client,6)
    setElementData(client, "char:money", getElementData(client, "char:money")-500)
  end 
end)

addEvent("licenses > refreshPlayerIDCard", true)
addEventHandler("licenses > refreshPlayerIDCard", resourceRoot, function()
    setElementData(client, "char:money", getElementData(client, "char:money")-30)

    exports.oInventory:takeItem(client, 65)
    inventory:createLicense(client, 1)
end)
