chache = {
    suprises = {},
}

function createSupriseBox(id)
    chache.suprises[id] = createObject(3781, settings.spawnPoints[id].x, settings.spawnPoints[id].y, settings.spawnPoints[id].z-0.67)
    setElementData(chache.suprises[id], 'obj:suprise', true)
    setElementData(chache.suprises[id], 'obj:id', id)
    setObjectScale ( chache.suprises[id], 0.3)
end


function loadBoxes ()
	for i = 1, settings.drops do
        id = math.random(1, #settings.spawnPoints)
        if (chache.suprises[id]) then
            id = math.random(1, #settings.spawnPoints) 
            if not (chache.suprises[id]) then
                createSupriseBox(id)
                outputChatBox(id)
            end
        else
            createSupriseBox(id)
            outputChatBox(id)
        end
    end
end
addEventHandler ( "onResourceStart", getRootElement(getThisResource()), loadBoxes )

function gotobox(player,cmd,id)
    if chache.suprises[tonumber(id)] then
        setElementPosition(player,settings.spawnPoints[tonumber(id)].x, settings.spawnPoints[tonumber(id)].y, settings.spawnPoints[tonumber(id)].z)
    end
end
addCommandHandler ( "gotobox", gotobox )