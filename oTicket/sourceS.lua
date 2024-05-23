local hex = exports["oCore"]:getServerColor()
local core = exports.oCore
local faction = exports.oDashboard
local mysql = exports.oMysql:getDBConnection()

local factionIDS = {
    ["orfk"] = 1,
    ["omsz"] = 2,
}

function giveTicket(player,value,type) 
    if client then 
        if not source == client then 
            outputDebugString("[oTicket]: INVALID ELEMENT!!! TRIGGERHACK!!! "..tostring(getPlayerName(source)),1)
            return 
        end 

        local inputFields = fromJSON(value)

        local hasFreeSlot, slotid = exports["oInventory"]:getFreeSlot(player, 228)

        if hasFreeSlot then
            if type == "orfk" then 
                exports["oInventory"]:giveItem(player,228,value,1);
                exports["oInfobox"]:outputInfoBox("Kaptál egy bűntetést, részletek a chatboxban.","info",player)
            elseif type == "omsz" then 
                exports["oInventory"]:giveItem(player,229,value,1);
                exports["oInfobox"]:outputInfoBox("Kaptál egy orvosi ellátási csekket, részletek a chatboxban.","info",player)
            end
        else
            outputChatBox(core:getServerPrefix("server", "Ticket", 2).."Ticketet kaptál, de mivel nem volt hely az inventorydban így az automatikusan be lett fizetve! "..hex.."("..inputFields["money|num-only|5"].."$)", player, 255, 255, 255, true)
            payTicket(tonumber(inputFields["money|num-only|5"]), type)
        end

        if type == "orfk" then 
            factionID = factionIDS[type]

            if string.len(inputFields["numberplate|-|8"]) > 3 then 
                dbExec(mysql, "INSERT INTO mdclogs SET reason=?, other=?, owner=?", inputFields["reason|-|28"], inputFields["money|num-only|5"] .. "$", inputFields["numberplate|-|8"])
            end

            dbExec(mysql, "INSERT INTO mdclogs SET reason=?, other=?, owner=?", inputFields["reason|-|28"], inputFields["money|num-only|5"] .. "$", inputFields["name|-|28"])
        elseif type == "omsz" then 
            factionID = factionIDS[type]
        end

        for k, player2 in ipairs(getElementsByType("player")) do 
            local factions = faction:getPlayerAllFactions(player2)

            local benneVan = false
            if #factions > 0 then 
                for k2, v2 in ipairs(factions) do 
                    if v2 == factionID then 
                        benneVan = true
                        break
                    end
                end
            end

            if benneVan then 
                outputChatBox(core:getServerPrefix("blue-light-2", string.upper(type), 3)..hex..getPlayerName(client):gsub("_", " ").." #ffffffkiadott egy "..hex..inputFields["money|num-only|5"].."$#ffffff-os ticketet "..hex..inputFields["name|-|28"].."#ffffff-nak/nek.", player2, 255, 255, 255, true)

                outputChatBox(core:getServerPrefix("blue-light-2", string.upper(type), 3).."Indok: "..hex..inputFields["reason|-|28"].."#ffffff.", player2, 255, 255, 255, true)
            end
        end


        if type == "orfk" then 
            outputChatBox(hex.."[Ticket]: #ffffff"..hex..inputFields["intezkedo"].."#ffffff büntetést szabott ki neked!",player,255,255,255,true)
        elseif type == "omsz" then 
            outputChatBox(hex.."[Ticket]: #ffffff"..hex..inputFields["intezkedo"].."#ffffff ellátási díjat szabott ki neked!",player,255,255,255,true)
        end
        outputChatBox(hex.."[Ticket]: #ffffffÖsszeg: "..hex..inputFields["money|num-only|5"].."#ffffff$.",player,255,255,255,true)

        if hasFreeSlot then
            outputChatBox(hex.."[Ticket]: #ffffffHatáridő: "..hex.."90 #ffffffperc.",player,255,255,255,true)
        end
    end 
end 
addEvent("giveTicket",true)
addEventHandler("giveTicket",root,giveTicket)

function payTicket(osszeg, type)
    if client then 
        if not source == client then 
            outputDebugString("[oTicket]: INVALID ELEMENT!!! TRIGGERHACK!!! "..tostring(getPlayerName(source)),1)
            return 
        end 

        setElementData(client, "char:money", getElementData(client, "char:money") - osszeg)

        if type == "orfk" then 
            factionID = factionIDS[type]
            faction:setFactionBankMoney(factionID, math.floor(osszeg*0.7), "add")
        elseif type == "omsz" then 
            factionID = factionIDS[type]
            faction:setFactionBankMoney(factionID, math.floor(osszeg*0.9), "add")
        end
    end 
end

addEvent("ticket > payTicket", true)
addEventHandler("ticket > payTicket", root, payTicket)

local ticketbefizetes = createPed(227, 1677.5111083984,-1182.4792480469,23.837814331055,270)
setElementFrozen(ticketbefizetes, true)
setElementData(ticketbefizetes, "ped:name", "Otis R. Brown")
setElementData(ticketbefizetes, "ped:prefix", "Csekk befizetés")