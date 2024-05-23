local conn = exports.oMysql:getDBConnection()

bankAccounts = {}
bankLogs = {}

function loadATMS()
    query = dbQuery(conn, 'SELECT * FROM atms')
    result = dbPoll(query, 255)

    if result then 
        for k, v in ipairs(result) do 
            local posX, posY, posZ = v["posX"], v["posY"], v["posZ"]
            local rot = v["rot"]
        
            local obj = createATM(posX, posY, posZ, rot)
            setElementData(obj, "atm:id", v["id"])
        end
    end
end

function loadAccounts()
    query = dbQuery(conn, 'SELECT * FROM bank_accounts')
    result = dbPoll(query, 255)

    if result then 
        for k, v in ipairs(result) do 
            bankAccounts[v["bankNumber"]] = {v["id"], v["owner"], v["money"], v["isMain"], v["pin"]}
            bankLogs[v["bankNumber"]] = {fromJSON(v["transactions"]), fromJSON(v["transfers"])}
        end
    end

    setTimer(function() triggerClientEvent(root, "bank > updateBankDatas > client", root, bankAccounts, bankLogs) end, 200, 1)
end

function createBankPeds()
    for k, v in ipairs(bankPeds) do 
        local ped = createPed(v.skin, v.pos.x, v.pos.y, v.pos.z, v.rot)
        setElementData(ped, "ped:name", v.name)
        setElementData(ped, "ped:prefix", "Bankár")
        setElementData(ped, "isBankPed", true)
        setElementFrozen(ped, true)

        if v.int then 
            setElementInterior(ped, v.int)
            setElementDimension(ped, v.dim)
        end
    end
end
addEventHandler("onResourceStart", resourceRoot, function()
    loadATMS()
    loadAccounts()
    createBankPeds()
end)

function saveBankAccounts()
    local accounts = {}
    local savedAccounts = 0

    for k, v in pairs(bankAccounts) do 
        if v then 
            accounts[k] = {
                ["id"] = v[1],
                ["owner"] = v[2],
                ["money"] = v[3],
                ["isMain"] = v[4],
                ["pin"] = v[5],
            }
        end
    end

    for k, v in pairs(bankLogs) do 
        if v then 
            accounts[k]["transactions"] = v[1]
            accounts[k]["transfers"] = v[2]
        end
    end

    for k, v in pairs(accounts) do 
        savedAccounts = savedAccounts + 1
        dbExec(conn, "UPDATE bank_accounts SET money=?, isMain=?, pin=?, transactions=?, transfers=? WHERE id=?", v["money"], v["isMain"], v["pin"], (toJSON(v["transactions"]) or "[[ ]]"), (toJSON(v["transfers"]) or "[[ ]]"), v["id"])
    end

    print("[BANK]: "..savedAccounts.."db bank account sikeresen mentve!")
end

setTimer(saveBankAccounts, core:minToMilisec(60), 0)

addEventHandler("onResourceStop", resourceRoot, function()
    saveBankAccounts()
end)

addEvent("bank > createNewBankAccount", true)
addEventHandler("bank > createNewBankAccount", resourceRoot, function(isMain)
    if client then 

        if not getElementData(client,"inBank") then return end
        if not source == client then 
            outputDebugString("[oCarshop]: INVALID ELEMENT!!! TRIGGERHACK!!! "..tostring(getPlayerName(source)),1)
            return 
        end 

        setElementData(client, "char:money", getElementData(client, "char:money") - 500)
        
        local owner = getElementData(client, "char:id")
        local insertResult, _, insertID = dbPoll(dbQuery(conn, "INSERT INTO bank_accounts SET owner=?, isMain=?, pin=? ", owner, isMain, 1234), 250)

        if tonumber(insertID) then 
            local serial = string.format("%04d", insertID)
            if string.len(serial) > 4 then 
                serial = serial:sub(1, 0-1-(string.len(serial)-4))
            end

            serial = serial .. "-" .. math.random(1000, 9999) .. "-" .. math.random(1000, 9999) .. "-" .. math.random(1000, 9999)

            dbExec(conn, "UPDATE bank_accounts SET bankNumber=? WHERE id=?", serial, insertID)

            bankAccounts[serial] = {insertID, owner, 0, isMain, 1234}
            bankLogs[serial] = {{}, {}}

            triggerClientEvent(root, "bank > updateBankDatas > client", root, bankAccounts, bankLogs)
        end
    end 
end)

addEvent("bank > delBankAccount", true)
addEventHandler("bank > delBankAccount", resourceRoot, function(id, serial)
    if client then 

        if not getElementData(client,"inBank") then return end
        if not source == client then 
            outputDebugString("[oCarshop]: INVALID ELEMENT!!! TRIGGERHACK!!! "..tostring(getPlayerName(source)),1)
            return 
        end 
        bankAccounts[serial] = false
        bankLogs[serial] = false
        dbExec(conn, "DELETE FROM bank_accounts WHERE id=?", id)
        triggerClientEvent(root, "bank > updateBankDatas > client", root, bankAccounts, bankLogs)
    end 
end)

addEvent("bank > setToMainAccount", true)
addEventHandler("bank > setToMainAccount", resourceRoot, function(new, old)
    if client then 

        if not getElementData(client,"inBank") then return end
        if not source == client then 
            outputDebugString("[oCarshop]: INVALID ELEMENT!!! TRIGGERHACK!!! "..tostring(getPlayerName(source)),1)
            return 
        end 
        if old then 
            bankAccounts[old][4] = 0
        end
        bankAccounts[new][4] = 1
        triggerClientEvent(root, "bank > updateBankDatas > client", root, bankAccounts, bankLogs)
    end 
end)

addEvent("bank > modifyPin", true)
addEventHandler("bank > modifyPin", resourceRoot, function(serial, pin)
    if client then 

        if not getElementData(client,"inBank") then return end
        if not source == client then 
            outputDebugString("[oCarshop]: INVALID ELEMENT!!! TRIGGERHACK!!! "..tostring(getPlayerName(source)),1)
            return 
        end 
        bankAccounts[serial][5] = pin
        triggerClientEvent(root, "bank > updateBankDatas > client", root, bankAccounts, bankLogs)
    end 
end)

addEvent("bank > giveCreditCard", true)
addEventHandler("bank > giveCreditCard", resourceRoot, function(serial)
    if client then 

        if not getElementData(client,"inBank") then return end
        if not source == client then 
            outputDebugString("[oCarshop]: INVALID ELEMENT!!! TRIGGERHACK!!! "..tostring(getPlayerName(source)),1)
            return 
        end 
        setElementData(client, "char:money", getElementData(client, "char:money") - 250) 
        exports.oInventory:giveItem(client, 155, serial, 1, 0)
    end 
end)

addEvent("bank > moneyToAccount", true)
addEventHandler("bank > moneyToAccount", resourceRoot, function(serial, money)
    if client then 

        if not getElementData(client,"inBank") then return end
        if not source == client then 
            outputDebugString("[oCarshop]: INVALID ELEMENT!!! TRIGGERHACK!!! "..tostring(getPlayerName(source)),1)
            return 
        end 

        if money <= getElementData(client, "char:money") then 
            local tax = 0
        
            local oldMoney = bankAccounts[serial][3]
        
            table.insert(bankLogs[serial][1], {money, false})
            setElementData(client, "char:money", getElementData(client, "char:money") - money)
        
            if money >= 5000 then 
                tax = money*0.02
                money = money - math.floor(tax)
            end
        
            bankAccounts[serial][3] = bankAccounts[serial][3] + money
        
            outputChatBox(core:getServerPrefix("server", "Bank", 2).."Sikeres tranzakció! Adó: "..color..math.floor(tax).."#ffffff$.", client, 255, 255, 255, true)
        
            triggerClientEvent(root, "bank > updateBankDatas > client", root, bankAccounts, bankLogs)
        
            local valtozas = bankAccounts[serial][3] - oldMoney 
        
            if math.abs(valtozas) >= 250000 then 
                for k, v in ipairs(getElementsByType("player")) do 
                    if getElementData(v, "user:admin") >= 2 then 
                        outputChatBox(core:getServerPrefix("red-dark", "Anticheat", 3).."#ff3929Magas banki egyenleg változás érzékelve!", v, 255, 255, 255, true)
                        outputChatBox(" #ff3929~ Bankszámla: "..color..serial.." #ff3929| Játékos: "..color..getElementData(client, "char:name").." (ID: "..getElementData(client, "playerid")..")", v, 255, 255, 255, true)
                        outputChatBox(" #ff3929~ Változás: "..color..valtozas, v, 255, 255, 255, true)
                    end
                end
            end
        end
    end 
end)

addEvent("bank > moneyFromAccount", true)
addEventHandler("bank > moneyFromAccount", resourceRoot, function(serial, money)
    if client then 

        if not getElementData(client,"inBank") then return end
        if not source == client then 
            outputDebugString("[oCarshop]: INVALID ELEMENT!!! TRIGGERHACK!!! "..tostring(getPlayerName(source)),1)
            return 
        end 

        if bankAccounts[serial][3] >= money then 
            local tax = 0

            local oldMoney = bankAccounts[serial][3]

            table.insert(bankLogs[serial][1], {money, true})
            bankAccounts[serial][3] = bankAccounts[serial][3] - money

            if money >= 5000 then 
                tax = money*0.02
                money = money - math.floor(tax)
            end

            setElementData(client, "char:money", getElementData(client, "char:money") + money)

            outputChatBox(core:getServerPrefix("server", "Bank", 2).."Sikeres tranzakció! Adó: "..color..math.floor(tax).."#ffffff$.", client, 255, 255, 255, true)

            triggerClientEvent(root, "bank > updateBankDatas > client", root, bankAccounts, bankLogs)

            local valtozas = bankAccounts[serial][3] - oldMoney 

            if math.abs(valtozas) >= 250000 then 
                for k, v in ipairs(getElementsByType("player")) do 
                    if getElementData(v, "user:admin") >= 2 then 
                        outputChatBox(core:getServerPrefix("red-dark", "Anticheat", 3).."#ff3929Magas banki egyenleg változás érzékelve!", v, 255, 255, 255, true)
                        outputChatBox(" #ff3929~ Bankszámla: "..color..serial.." #ff3929| Játékos: "..color..getElementData(client, "char:name").." (ID: "..getElementData(client, "playerid")..")", v, 255, 255, 255, true)
                        outputChatBox(" #ff3929~ Változás: "..color..valtozas, v, 255, 255, 255, true)
                    end
                end
            end
        end
    end 
end)

addEvent("bank > setAccountMoney", true)
addEventHandler("bank > setAccountMoney", resourceRoot, function(serial, money)
    if client then 
        if not getElementData(client,"inBank") then return end
        if not source == client then 
            outputDebugString("[oCarshop]: INVALID ELEMENT!!! TRIGGERHACK!!! "..tostring(getPlayerName(source)),1)
            return 
        end 

        bankAccounts[serial][3] = money 
        triggerClientEvent(root, "bank > updateBankDatas > client", root, bankAccounts, bankLogs)
    end 
end)

addEvent("bank > clearTransactionLog", true)
addEventHandler("bank > clearTransactionLog", resourceRoot, function(serial)
    if client then 
        if not getElementData(client,"inBank") then return end
        if not source == client then 
            outputDebugString("[oCarshop]: INVALID ELEMENT!!! TRIGGERHACK!!! "..tostring(getPlayerName(source)),1)
            return 
        end 
        bankLogs[serial][1] = {}
        triggerClientEvent(root, "bank > updateBankDatas > client", root, bankAccounts, bankLogs)
    end 
end)

addEvent("bank > clearTransferLog", true)
addEventHandler("bank > clearTransferLog", resourceRoot, function(serial)
    if client then 
        if not getElementData(client,"inBank") then return end
        if not source == client then 
            outputDebugString("[oCarshop]: INVALID ELEMENT!!! TRIGGERHACK!!! "..tostring(getPlayerName(source)),1)
            return 
        end 
        bankLogs[serial][2] = {}
        triggerClientEvent(root, "bank > updateBankDatas > client", root, bankAccounts, bankLogs)
    end
end)

addEvent("bank > transferMoney", true)
addEventHandler("bank > transferMoney", resourceRoot, function(from, to, money)
    if client then 

        if not getElementData(client,"inBank") then return end
        if not source == client then 
            outputDebugString("[oCarshop]: INVALID ELEMENT!!! TRIGGERHACK!!! "..tostring(getPlayerName(source)),1)
            return 
        end 
        if  bankAccounts[from][3] >= money then 
            local tax = 0
            table.insert(bankLogs[from][2], {to, money, true})
            local oldMoney = bankAccounts[from][3]
            bankAccounts[from][3] = bankAccounts[from][3] - money

            local valtozas = bankAccounts[from][3] - oldMoney 

            if math.abs(valtozas) >= 250000 then 
                for k, v in ipairs(getElementsByType("player")) do 
                    if getElementData(v, "user:admin") >= 2 then 
                        outputChatBox(core:getServerPrefix("red-dark", "Anticheat", 3).."#ff3929Magas banki egyenleg változás érzékelve!", v, 255, 255, 255, true)
                        outputChatBox(" #ff3929~ Bankszámla: "..color..from.." #ff3929| Játékos: "..color..getElementData(client, "char:name").." (ID: "..getElementData(client, "playerid")..")", v, 255, 255, 255, true)
                        outputChatBox(" #ff3929~ Változás: "..color..valtozas, v, 255, 255, 255, true)
                    end
                end
            end

            if money >= 5000 then 
                tax = money*0.035
                money = money - math.floor(tax)
            end

            local oldMoney = bankAccounts[to][3]
            bankAccounts[to][3] = bankAccounts[to][3] + money
            local valtozas = bankAccounts[to][3] - oldMoney 

            if math.abs(valtozas) >= 250000 then 
                for k, v in ipairs(getElementsByType("player")) do 
                    if getElementData(v, "user:admin") >= 2 then 
                        outputChatBox(core:getServerPrefix("red-dark", "Anticheat", 3).."#ff3929Magas banki egyenleg változás érzékelve!", v, 255, 255, 255, true)
                        outputChatBox(" #ff3929~ Bankszámla: "..color..to.." #ff3929", v, 255, 255, 255, true)
                        outputChatBox(" #ff3929~ Változás: "..color..valtozas, v, 255, 255, 255, true)
                    end
                end
            end

            table.insert(bankLogs[to][2], {from, money, false})

            triggerClientEvent(root, "bank > updateBankDatas > client", root, bankAccounts, bankLogs)
        end
    end 
end)

function createATM(x, y, z, rot)
    local obj = createObject(2942, x, y, z, 0, 0, rot)
    setElementData(obj, "atm:working", true)
    setElementData(obj, "atm:hp", 100)

    return obj
end

function addATM(player, cmd)
    if getElementData(player, "user:admin") > 4 then 
        if getElementData(player, "user:aduty") then 
            if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

            local posX, posY, posZ = getElementPosition(player)
            local rotX, rotY, rotZ = getElementRotation(player)

            posZ = posZ - 0.1

            posZ = posZ - 0.3

            local insertResult, _, insertID = dbPoll(dbQuery(conn, "INSERT INTO atms SET posX=?, posY=?, posZ=?, rot=? ", posX, posY, posZ, rotZ), 250)

            if tonumber(insertID) then 
                local obj = createATM(posX, posY, posZ, rotZ)
                setElementData(obj, "atm:id", insertID)
            end

            triggerClientEvent(getRootElement(), "sendMessageToAdmins", getRootElement(), player, "létrehozott egy ATM-et. Itt: #db3535"..getElementZoneName(player).."#557ec9 (".."#db3535#"..insertID.."#557ec9)", 8)
            setElementData(player, "log:admincmd", {"ATM: "..insertID, cmd})
        end
    end
end
addCommandHandler("addatm", addATM)
addCommandHandler("makeatm", addATM)
addCommandHandler("createatm", addATM)

addEvent("bank > delATM", true)
addEventHandler("bank > delATM", resourceRoot, function(atm)
    if not client then return end 
    if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(client) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

    local id = getElementData(atm, "atm:id")
    triggerClientEvent(getRootElement(), "sendMessageToAdmins", getRootElement(), client, "törölt egy ATM-et. Itt: #db3535"..getElementZoneName(atm).."#557ec9 (".."#db3535#"..id.."#557ec9)", 8)
    destroyElement(atm)
    setElementData(client, "log:admincmd", {"ATM: "..id, "delatm"})

    dbExec(conn, "DELETE FROM atms WHERE id = ?", id)
end)

addEvent("bank > getBankDatas", true)
addEventHandler("bank > getBankDatas", resourceRoot, function()
    triggerClientEvent(client, "bank > updateBankDatas > client", client, bankAccounts, bankLogs)
end)

-- atm robbery

addEvent("bank > atmRob > setPedAnimation", true)
addEventHandler("bank > atmRob > setPedAnimation", resourceRoot, function(animType, animName)
    setPedAnimation(client, animType, animName, _, true, false, false)
end)

local atmBlips = {}

addEvent("bank > atmRob > atmFlexed", true)
addEventHandler("bank > atmRob > atmFlexed", resourceRoot, function(atm)
    setElementModel(atm, 2943)
    setElementData(atm, "atm:working", false)
    local x, y, z = getElementPosition(atm)
    atmBlips[atm] = createBlip(x, y, z, 26)
    setElementData(atmBlips[atm], "blip:name", "Üzemen kívüli ATM")

    local colShape = createColSphere(x, y, z, 1.5)
    setElementData(atm, "atm:colShape", colShape)
    setElementData(colShape, "atm:moneyCasettes", 4)
    setElementData(colShape, "atm:isRobberyCol", true)

    setTimer(function()
        setElementModel(atm, 2942)
        setElementData(atm, "atm:working", true)
        setElementData(atm, "atm:hp", 100)
        setElementData(atm, "atm:robStart", false)

        local deletCol = getElementData(atm, "atm:colShape")

        if isElement(deleteCol) then 
            destroyElement(deletCol)
        end

        destroyElement(atmBlips[atm])
    end, core:minToMilisec(240), 1)
end)

addEvent("bank > caseOpen > start", true) 
addEventHandler("bank > caseOpen > start", resourceRoot, function()
    setPedAnimation(client, "bomber", "bom_plant_loop", -1, true, false, false)
end)

addEvent("bank > caseOpen > end", true) 
addEventHandler("bank > caseOpen > end", resourceRoot, function(money)
    money = money or 0

    setPedAnimation(client, "", "")

    if money > 0 then 
        setElementData(client, "char:money", getElementData(client, "char:money") + money) 
    end
end)