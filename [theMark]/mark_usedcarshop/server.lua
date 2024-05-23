--Script by theMark
addEvent("toSql", true)
addEventHandler("toSql", root, function()

end)

addEvent("deletePlayer", true)
addEventHandler("deletePlayer", root, function(player, key)
    triggerClientEvent(root, "delPlayerServerSide", root, key)
end)

addCommandHandler("setp", function(player, cmd, playername, playerid)
    if not playername or not playerid then return outputChatBox("Használat: [Játékos Név] [Játékos ID] [Legutolsó Bejelentkezés] [Eladott autók]", player, 255, 255, 255, true) end
    triggerClientEvent(root, "tableTreatment", root, playername, playerid, lastlogin, SelledCars)
    outputChatBox("asd!")
end)

addCommandHandler("removep", function(player, cmd, pos)
    if not pos then return outputChatBox("Használat: [Hanyadik embert szeretnéd kitörölni a sorban?]", player, 255, 255, 255, true) end
    triggerClientEvent(root, "removePlayer", root, pos)
    outputChatBox("VÁLASZ MEGKAPÓDDIK!!!44!!!", root)
end)