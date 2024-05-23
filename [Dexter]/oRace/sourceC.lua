--nf_blackbrd
--cj_airp_s_2

local screenX, screenY = guiGetScreenSize()
local raceTable1 = false
local color,r,g,b = exports.oCore:getServerColor()

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oInfobox" then  
        infobox = exports.oInfobox
		core = exports.oCore
		color,r,g,b = exports.oCore:getServerColor()
	end
end)



addEventHandler("onClientResourceStart", getRootElement(), function(startedResource)
    if startedResource == getThisResource() then 
        raceTable1 = createObject(2790,584.50338134766, -1167.9005615234, 28.150974273682,20,0,43)
        for k,v in pairs(raceMarker) do
            markerElement = createMarker(v[1],v[2],v[3]-1, "cylinder", 3, r, g, b, 150) --exports["oCustomMarker"]:createCustomMarker(v[1],v[2],v[3], 4, 255, 0, 0, 150,"race", "circle")
        end
    end
end)

addEventHandler("onClientMarkerHit", getRootElement(), function(hitMarker, matchDim)
    if source == markerElement and hitMarker == localPlayer and matchDim then 
        outputChatBox("asd")
    end
end)