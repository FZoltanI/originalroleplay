connection = exports.oMysql:getDBConnection()

local storedPrinter = {}

local temp = {
    -- OBJID, X, Y, Z, Int, Dim, RotX,rotY,rotZ
    {2202,1537.7209472656, -1351.8284912109, 329.46072387695, 0, 0, 0, 0, 0}
}


addEventHandler("onResourceStart", getResourceRootElement(getThisResource()),function()
    dbQuery(loadedPrinters, connection, "SELECT * FROM printers")
end)    

function loadedPrinters(qh)
    local result = dbPoll(qh, 0)
    if result then 
        for k,v in pairs(result) do 
            loadPrinter(v)
        end
    end
end

function loadPrinter(data)
    local pos = fromJSON(data["pos"])
   -- outputChatBox(pos[3])
    local objectElement = createObject(2202,pos[1],pos[2],pos[3]-1,pos[6],pos[7],pos[8])
    if isElement(objectElement) then 
        local printerId = data.id
        setElementInterior(objectElement, pos[4])
        setElementDimension(objectElement, pos[5])
        

        storedPrinter[printerId] = {}
        storedPrinter[printerId].objectElement = objectElement
        setElementData(storedPrinter[printerId].objectElement, "object:isPrinter",true)
        setElementData(storedPrinter[printerId].objectElement, "printer:status",0)
        setElementData(storedPrinter[printerId].objectElement, "printer:isUsing",false)
        return true
    end
    return false
end

addCommandHandler("createprinter", function(player)
    if getElementData(player, "user:admin") >= 7 then 
        local playerPosX, playerPosY, playerPosZ = getElementPosition(player)
        local playerRotX, playerRotY, playerRotZ = getElementRotation(player)
        local playerInterior = getElementInterior(player)
        local playerDimension = getElementDimension(player)
        local data = {playerPosX, playerPosY, playerPosZ, playerInterior, playerDimension, playerRotX, playerRotY, playerRotZ}
        dbQuery(function(qh, player)
            local result = dbPoll(qh, 0, true)[2][1][1]
            if result then 
                if loadPrinter(result) then 
                    if isElement(player) then 
                        outputChatBox(exports["oCore"]:getServerPrefix("red-dark", "Printer", 3).."Sikeresen létrehoztál egy nyomtatót (ID: ".. result.id ..")",player,220,20,60,true) 
                    end
                end
            end
        end,{player}, connection, "INSERT INTO printers (pos) VALUES (?); SELECT * FROM printers ORDER BY id DESC LIMIT 1", toJSON(data))
    end
end)

addCommandHandler("deleteprinter", function(player,cmd ,printerId)
    if getElementData(player, "user:admin") >= 7 then 
        if not printerId then 
            outputChatBox(exports["oCore"]:getServerPrefix("red-dark", "Printer", 3).."Használat: /"..cmd.. " [ID]",player,220,20,60,true)
        else
            printerId = tonumber(printerId)

            if printerId and storedPrinter[printerId] then
                destroyElement(storedPrinter[printerId].objectElement)
                storedPrinter[printerId] = nil
                dbExec(connection, "DELETE FROM printers WHERE id = ?", printerId)
                outputChatBox(exports["oCore"]:getServerPrefix("red-dark", "Printer", 3).."A kiválasztott nyomtató sikeresen törölve",player,220,20,60,true) 
            else 
                outputChatBox(exports["oCore"]:getServerPrefix("red-dark", "Printer", 3).."A kiválasztott nyomtató nem létezik",player,220,20,60,true)  
            end
        end
    end
end)

addCommandHandler("nearbyprinters", function(player,cmd ,nearby)
    if getElementData(player, "user:admin") >= 7 then 
        if not nearby then nearby = 10 else nearby = tonumber(nearby) end 
        local px,py,pz = getElementPosition(player)
        local count = 0
        outputChatBox(exports["oCore"]:getServerPrefix("red-dark", "Printer", 3).."Nyomtatók a közeledben ("..nearby .." Yard)",player,220,20,60,true)  
        for k,v in pairs(storedPrinter) do 
            --if getElementData(v.ojbectElement, "object:isPrinter") then 
                local x,y,z = getElementPosition(v.objectElement)
                if getDistanceBetweenPoints3D(px,py,pz,x,y,z) <= nearby then 
                    outputChatBox(exports["oCore"]:getServerPrefix("red-dark", "Printer", 3).."* Azonosító: "..k .." | Távolság: ".. math.floor(getDistanceBetweenPoints3D(px,py,pz,x,y,z)) .. " Yard",player,220,20,60,true)  
                    count = count + 1
                end
            --end
        end
        if count == 0 then 
            outputChatBox(exports["oCore"]:getServerPrefix("red-dark", "Printer", 3).."Nincs a közeledben nyomtató!",player,220,20,60,true)  
        end
    end
end)





addEvent("requestPrinter",true)
addEventHandler("requestPrinter", getRootElement(), function()

end)
