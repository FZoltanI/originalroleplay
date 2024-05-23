local hex,r,g,b = exports["oCore"]:getServerColor()

local startMarker = createMarker (2379.2038574219, -649.95227050781, 127.45172119141,"checkpoint",4.0,r,g,b,255) 
local endMarker = createMarker (2162.2133789063, -675.72387695313, 51.035755157471,"checkpoint",4.0,r,g,b,255) 
local rstart = createBlip(2379.2038574219, -649.95227050781, 127.45172119141,5)
local rend = createBlip(2162.2133789063, -675.72387695313, 51.035755157471,5)
setElementData(rstart,"blip:name","Rally Start");
setElementData(rend,"blip:name","Rally End");

local players = {}
local rally = nil

function startMark(source)
if source then 
    if not players[source] then
        if not rally then 
            if getPedOccupiedVehicle(source) then
                players[source] = {"true"};
                minute = 0
                sec = 0
                rally = true 
                SecTimer = setTimer(function()
                        sec = sec + 1
                
                        if sec == 60 then 
                            sec = 0 
                            minute = minute + 1
                        end

                end,1000,0)

                outputChatBox("#b52424[Rally]: #ffffffSTART!!",source,255,255,255,true)
            end 
        else 
            outputChatBox("#b52424[Rally]: #ffffffMár van folyamatban lévő verseny!",source,255,255,255,true)
        end 
    else 
        outputChatBox("#b52424[Rally]: #ffffffTe már elkezdted a versenyt!",source,255,255,255,true)
    end 
end
end
addEventHandler("onMarkerHit", startMarker, startMark)

function endMark(source)
    if source then 
        if players[source] then
            players[source] = nil
            outputChatBox("#b52424[Rally]: #ffffffSikeresen teljesítetted a pályát, az időd: "..minute.." perc // "..sec.." másodperc.",source,255,255,255,true)
            setElementPosition(getPedOccupiedVehicle(source),2369.1787109375, -652.55444335938, 127.61670684814)

            for k,v in pairs(getElementsByType("player")) do 
                if (getElementData(v,"user:admin") or 0) > 5 then
                    outputChatBox("[RALLY LOG]: "..getElementData(source,"char:name").." sec: "..sec.." minute: "..minute,v); 
                end 
            end 

            killTimer(SecTimer)
            minute = 0 
            sec = 0
            rally = nil
        end
    end
end
addEventHandler("onMarkerHit", endMarker, endMark)
