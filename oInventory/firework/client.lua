--[[dff = engineLoadDFF ( "firework/files/smoke_flare.dff", 0 )
engineReplaceModel ( dff, 1337 )

dff2 = engineLoadDFF ( "firework/files/shootlight.dff", 0 )
engineReplaceModel ( dff2, 1338 )
    
dff3 = engineLoadDFF ( "firework/files/smoke30m.dff", 0 )
engineReplaceModel ( dff3, 8678 )

addEvent("playBoom", true)
addEvent("flying", true)

addEventHandler("playBoom", root, function(x, y, z)
        boom = playSound3D("firework/files/fwSound.mp3", x, y, z, false)
        setSoundVolume(boom, 50)
        setSoundMaxDistance(boom, 200)

        setTimer(function()
            burst = playSound3D("firework/files/burst.mp3", x, y, z, false)
            setSoundVolume(burst, 50)
            setSoundMaxDistance(burst, 200)
        end,700,1)
end)

addEventHandler("flying", root, function(x, y, z)
    flying = playSound3D("firework/files/flying.mp3", x, y, z, false)
    setSoundVolume(flying, 50)
    setSoundMaxDistance(flying, 200)
end)

function makeFireWork(player,type)
    triggerServerEvent("createFirework",resourceRoot,player,type)
end 
]]
