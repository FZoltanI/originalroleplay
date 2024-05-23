addEvent("job > hacker > sitOnTheChair", true)
addEventHandler("job > hacker > sitOnTheChair", resourceRoot, function(chair)
    attachElements(client, chair, 0, -0.7, 1.1)
    setPedAnimation(client, "ped", "SEAT_idle", -1, true, false, false)

    local chairRotX, chairRotY, chairRotZ = getElementRotation(chair)
    setElementRotation(client, 0, 0, chairRotZ + 180)
end)

addEvent("job > hacker > leaveFromTheChair", true)
addEventHandler("job > hacker > leaveFromTheChair", resourceRoot, function(chair)
    detachElements(client, chair)
    setPedAnimation(client)
end)