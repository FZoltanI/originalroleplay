local dashboard = exports.oDashboard
local core = exports.oCore
local color, r, g, b = core:getServerColor()

addEvent("payday > getPaymentOnServer", true)
addEventHandler("payday > getPaymentOnServer", resourceRoot, function(factions, tax)
    local allPayment = 0
    for k, v in ipairs(factions) do 
        local payment = dashboard:getPlayerPaymentInFaction(v, client)

        if (dashboard:getFactionBankMoney(v) - payment > 0) then 
            dashboard:setFactionBankMoney(v, payment, "remove")
            allPayment = allPayment+payment
        end
    end

    outputChatBox(core:getServerPrefix("server", "Fizetésed", 3)..""..allPayment..color.."$", client, 255, 255, 255, true)
    setElementData(client, "char:money", getElementData(client, "char:money")+allPayment)
    setElementData(client, "char:money", getElementData(client, "char:money")-tax)
end)