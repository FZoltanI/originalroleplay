local default_distance = 500

setFarClipDistance( default_distance )

addEvent("setMaxShowDistance", true)
addEventHandler("setMaxShowDistance", root, function(distance)
    if distance == 0 then 
        setFarClipDistance(default_distance)
    else 
        setFarClipDistance(distance)
    end
end)