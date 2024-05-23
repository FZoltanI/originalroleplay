--script by theMark
addEvent("playSoundVid", true)
addEventHandler("playSoundVid", root, function(player, url)
    if getElementDimension(player) == 262 and getElementInterior(player) == 3 then
        triggerClientEvent(root, "playVid", root, url)
        print("szerver küldi:" .. url)
    end
end)