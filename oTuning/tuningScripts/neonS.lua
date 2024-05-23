function sendMessageToAdmins(player, msg)
	triggerClientEvent("sendMessageToAdmins", getRootElement(), player, msg, 8)
end

addEvent("neon > sendAdminLog", true)
addEventHandler("neon > sendAdminLog", resourceRoot, function(veh)

    if getElementData(veh, "veh:isFactionVehice") == 1 then 
        sendMessageToAdmins(client, "megváltoztatta a(z) #db3535"..getElementData(veh, "veh:id").."#557ec9-as/es ID-vel rendelkező jármű neonját. #eba134[Frakció jármű!]")
    elseif getElementData(client, "char:id") == getElementData(veh, "veh:owner") then 
        sendMessageToAdmins(client, "megváltoztatta a(z) #db3535"..getElementData(veh, "veh:id").."#557ec9-as/es ID-vel rendelkező jármű neonját. #db3535[Saját jármű!]")
    else
        sendMessageToAdmins(client, "megváltoztatta a(z) #db3535"..getElementData(veh, "veh:id").."#557ec9-as/es ID-vel rendelkező jármű neonját.")
    end
end)