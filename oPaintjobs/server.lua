function sendMessageToAdmins(player, msg)
	triggerClientEvent("sendMessageToAdmins", getRootElement(), player, msg, 8)
end

addEvent("paintjob > sendAdminLog", true)
addEventHandler("paintjob > sendAdminLog", resourceRoot, function(veh)

    if getElementData(veh, "veh:isFactionVehice") == 1 then 
        sendMessageToAdmins(client, "megváltoztatta a(z) #db3535"..getElementData(veh, "veh:id").."#557ec9-as/es ID-vel rendelkező jármű paintjobját. #eba134[Frakció jármű!]")
    elseif getElementData(client, "char:id") == getElementData(veh, "veh:owner") then 
        sendMessageToAdmins(client, "megváltoztatta a(z) #db3535"..getElementData(veh, "veh:id").."#557ec9-as/es ID-vel rendelkező jármű paintjobját. #db3535[Saját jármű!]")
    else
        sendMessageToAdmins(client, "megváltoztatta a(z) #db3535"..getElementData(veh, "veh:id").."#557ec9-as/es ID-vel rendelkező jármű paintjobját.")
    end
end)