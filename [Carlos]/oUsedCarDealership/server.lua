local conn = mysql:getDBConnection()
local carshopCount = 0

local carshops = {}
local carshop_markers = {}

function loadTables()
    query = dbQuery(conn, 'SELECT * FROM usedcardealerships')
    result = dbPoll(query, 255)

    if result then 
        for k, v in ipairs(result) do 
            local col, desk = createMainDesk(unpack(fromJSON(v["mainDeskPosition"])))
            setElementData(col, "carDealership:id", v["id"])
            setElementData(desk, "carDealership:id", v["id"])
            carshops[v["id"]] = {col, desk, fromJSON(v["carPositions"])}
        end
    end
end
addEventHandler("onResourceStart", resourceRoot, loadTables)

function createMainDesk(x, y, z, rot, dim, int)
    carshopCount = carshopCount + 1

    local deskObj = createObject(deskObject, x, y, z, 0, 0, rot)

    local laptopObj = createObject(laptopObject, x, y, z, 0, 0, rot)
    local plantObj = createObject(2241, x, y, z, 0, 0, rot)
    local chairObj = createObject(1671, x, y, z, 0, 0, rot)

    setObjectScale(laptopObj, 1.3)
    setObjectScale(plantObj, 0.5)
    setElementCollisionsEnabled(plantObj, false)
    attachElements(laptopObj, deskObj, 0.65, 0, 0.4, 0, 0, 50)
    attachElements(plantObj, deskObj, -0.7, -0.2, 0.65, 0, 0, 50)
    attachElements(chairObj, deskObj, -0.3, 0.95, 0.07, 0, 0, 50)

    local colShape = createColTube(x, y, z - 2, 1.75, 5)
    setElementData(colShape, "carDealership:tableObjects", {deskObj, laptopObj, plantObj, chairObj})

    for k, v in ipairs({deskObj, laptopObj, plantObj, chairObj}) do 
        setElementInterior(v, int)
        setElementDimension(v, dim)
    end

    return colShape, deskObj
end

function delCarshop(id)
    carshopCount = carshopCount - 1
    local col, desk = unpack(carshops[id])

    for k, v in ipairs(getElementData(col, "carDealership:tableObjects")) do 
        destroyElement(v)
    end

    destroyElement(col)
    carshops[id] = false
    
    dbExec(conn, "DELETE FROM usedcardealerships WHERE id = ?", id)
end

function createCarPosition(shopID, posX, posY, posZ, rot)
    posZ = posZ - 1

    local marker = createMarker(posX, posY, posZ, "cylinder", 2.5, 3, 252, 198, 100)

    if not carshop_markers[shopID] then 
        carshop_markers[shopID] = {}
    end

    carshop_markers[shopID][marker] = marker

    setElementData(marker, "carDealership:id", shopID)
    setElementData(marker, "carDealership:isEmptyPosition", true)
    setElementData(marker, "carDealership:carRot", rot)
end

addCommandHandler("createcarshop", function(player, cmd)
    if getElementData(player, "user:admin") >= 8 then 
        if carshopCount + 1 <= maxCarshopCount then
            local posX, posY, posZ = getElementPosition(player)
            local rotX, rotY, rotZ = getElementRotation(player)
            local dim, int = getElementDimension(player), getElementInterior(player)

            posZ = posZ - 0.6

            local insertResult, _, insertID = dbPoll(dbQuery(conn, "INSERT INTO usedcardealerships SET mainDeskPosition=? ", toJSON({posX, posY, posZ, rotZ, dim, int})), 250)

            if tonumber(insertID) then 
                local col, desk = createMainDesk(posX, posY, posZ, rotZ, dim, int)

                setElementData(col, "carDealership:id", tonumber(insertID))
                setElementData(desk, "carDealership:id", tonumber(insertID))

                carshops[tonumber(insertID)] = {col, desk}

                triggerClientEvent("sendMessageToAdmins", getRootElement(), player, "létrehozott egy Használtautó kereskedést. Itt: #db3535"..getElementZoneName(player).."#557ec9 (".."#db3535#"..insertID.."#557ec9)", 8)
            end
        else
            outputChatBox(core:getServerPrefix("red-dark", "Használtautó kereskedés", 3).."A maximálisan létrehozható autókereskedések száma "..color..maxCarshopCount.."#ffffffdb.", player, 255, 255, 255, true)
        end
    end
end)

addCommandHandler("delcarshop", function(player, cmd, id)
    if getElementData(player, "user:admin") >= 8 then 
        if tonumber(id) then
            id = tonumber(id)
            if carshops[id] then 
                delCarshop(id)
                triggerClientEvent("sendMessageToAdmins", getRootElement(), player, "törölt egy Használtautó kereskedést. Itt: #db3535"..getElementZoneName(player).."#557ec9 (".."#db3535#"..id.."#557ec9)", 8)
            else
                outputChatBox(core:getServerPrefix("red-dark", "Használtautó kereskedés", 3).."Nincs ilyen ID-vel rendelkező használtautó kereskedés.", player, 255, 255, 255, true)
            end
        else
            outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [ID]", player, 255, 255, 255, true)
        end
    end
end)

addCommandHandler("addcarpos", function(player, cmd, id)
    if getElementData(player, "user:admin") >= 8 then 
        if tonumber(id) then
            id = tonumber(id)
            if carshops[id] then 
                if #carshops[id][3] < carPositionsPerShop then
                    local posX, posY, posZ = getElementPosition(player)
                    local rotX, rotY, rotZ = getElementRotation(player)

                    createCarPosition(id, posX, posY, posZ - 0.5, rotZ)

                    triggerClientEvent("sendMessageToAdmins", getRootElement(), player, "hozzáadott egy pozíciót egy használtautó kereskedéshez. Itt: #db3535"..getElementZoneName(player).."#557ec9 (".."#db3535#"..id.."#557ec9)", 8)

                    table.insert(carshops[id][3], {posX, posY, posZ, rotZ})
                    dbQuery(conn, "UPDATE usedcardealerships SET carPositions=? WHERE id=? ", toJSON(carshops[id][3]), id)
                else
                    outputChatBox(core:getServerPrefix("red-dark", "Használtautó kereskedés", 3).."Ehhez a kereskedéshez már nem adhatsz több pozíciót.", player, 255, 255, 255, true)
                end
            else
                outputChatBox(core:getServerPrefix("red-dark", "Használtautó kereskedés", 3).."Nincs ilyen ID-vel rendelkező használtautó kereskedés.", player, 255, 255, 255, true)
            end
        else
            outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [ID]", player, 255, 255, 255, true)
        end
    end
end)