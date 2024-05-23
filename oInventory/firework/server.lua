
--[[maxRockets = 1
command = "firework"


addEventHandler("onResourceStart", resourceRoot, function()
        for i, thePlayer in ipairs(getElementsByType("player")) do
            setElementData(thePlayer, "rocket", 0)
        end
    end)

addEventHandler("onPlayerJoin", root, function()
    setElementData(source, "rocket", 0)
end)

local r,g,b = 255,255,255

function createFirework(player,type)
        if type == 1 then 
            r,g,b = 252, 186, 3 
        elseif type == 2 then 
            r,g,b = 217, 43, 43
        elseif type == 3 then 
            r,g,b = 101, 125, 219
        elseif type == 4 then 
            r,g,b = 70, 189, 64
        end

        rand = math.random(40,60)

        local pX, pY, pZ = getElementPosition(player)
        rocket = createObject(1636, pX, pY, pZ-0.2, 90, 0, 0)
        smoke1 = createObject(1337, pX, pY, pZ-0.4, 0, 0, 0)
        rSmoke = createObject(8678, pX, pY, pZ-0.4, 0, 0, 0)              
            
        light = createMarker(pX, pY, pZ, "corona", 0.4, r,g,b, 140, root)
        light2 = createMarker(pX, pY, pZ, "corona", 0.5, r,g,b, 140, root)

        attachElements(light, rocket)
        attachElements(light2, rocket)

        attachElements(smoke1, rocket, 0, 0, 0, 90, 0, 0)

        setElementCollisionsEnabled(smoke1, false)
        setElementCollisionsEnabled(rSmoke, false)
        setElementCollisionsEnabled(rocket, false)    
                
        setTimer(function()
            local x, y, z = getElementPosition(rocket)              
            triggerClientEvent("flying", root, x, y, z)
        end,5000,1)

        setTimer(moveObject, 5000, 1, rocket, 3000, pX, pY, pZ+rand)
        setTimer(moveObject, 8000, 1, rocket, 2000, pX-math.random(5, 10), pY+math.random(5, 10), pZ-0.66, math.random(10, 90), math.random(10, 90), math.random(10, 90))
        
        setTimer(setElementCollisionsEnabled, 8000, 1, rocket, false)
        setTimer(destroyElement, 8000, 1, light)
        setTimer(destroyElement, 8000, 1, light2)
        setTimer(destroyElement, 8000, 1, smoke1)
        setTimer(destroyElement, 17000, 1, rocket)
        setTimer(destroyElement, 6000, 1, rSmoke)
                           
        setTimer(function()
            boom1 = createObject(1338, pX, pY, pZ+30)
            boom2 = createObject(1338, pX, pY+math.random(3, 9), pZ+rand)
            boom3 = createObject(1338, pX, pY+math.random(3, 8), pZ+rand)
            boom4 = createObject(1338, pX, pY+math.random(3, 6), pZ+rand)
            boom5 = createObject(1338, pX, pY+math.random(3, 4), pZ+rand)
                        
            boom6 = createObject(1338, pX+math.random(3, 4), pY, pZ+rand)
            boom7 = createObject(1338, pX+math.random(3, 6), pY, pZ+rand)
            boom8 = createObject(1338, pX+math.random(3, 9), pY, pZ+rand)
            boom9 = createObject(1338, pX+math.random(3, 12), pY, pZ+rand)
                        
            col1 = createMarker(pX+math.random(1, 5), pY+math.random(1, 5), pZ+rand, "corona", 1,r,g,b, 160, root)
            col2 = createMarker(pX+math.random(1, 5), pY+math.random(1, 5), pZ+rand, "corona", 2, r,g,b, 160, root)
            col3 = createMarker(pX+math.random(1, 5), pY+math.random(1, 5), pZ+rand, "corona", 4, r,g,b, 160, root)
            col4 = createMarker(pX+math.random(1, 5), pY+math.random(1, 5), pZ+rand, "corona", 5, r,g,b, 160, root)
            col5 = createMarker(pX+math.random(1, 5), pY+math.random(1, 5), pZ+rand, "corona", 3, r,g,b, 160, root)
            
                    function flashMark()
                            if col1 and col2 and col3 and col4 and col5 and flashTimer then
                                setMarkerColor(col1, r,g,b, 160)
                                setMarkerColor(col2, r,g,b, 160)
                                setMarkerColor(col3, r,g,b, 160)
                                setMarkerColor(col4, r,g,b, 160)
                                setMarkerColor(col5, r,g,b, 160)
                                else
                                killTimer(flashTimer)
                            end
                        end
                    flashTimer = setTimer(flashMark, 100, 7)
                        
            setObjectScale(boom1, 2)
            setElementCollisionsEnabled(boom1, false)
            setObjectScale(boom2, 2)
            setElementCollisionsEnabled(boom2, false)
            setObjectScale(boom3, 2)
            setElementCollisionsEnabled(boom3, false)
            setObjectScale(boom4, 2)
            setElementCollisionsEnabled(boom4, false)
            setObjectScale(boom5, 2)
            setElementCollisionsEnabled(boom5, false)
            setObjectScale(boom6, 2)
            setElementCollisionsEnabled(boom6, false)
            setObjectScale(boom7, 2)
            setElementCollisionsEnabled(boom7, false)
            setObjectScale(boom8, 2)
            setElementCollisionsEnabled(boom8, false)
            setObjectScale(boom9, 2)
            setElementCollisionsEnabled(boom9, false)
                            
            setTimer(destroyElement, 4000, 1, boom1)
            setTimer(destroyElement, 4000, 1, boom2)
            setTimer(destroyElement, 4000, 1, boom3)
            setTimer(destroyElement, 4000, 1, boom4)
            setTimer(destroyElement, 4000, 1, boom5)
            setTimer(destroyElement, 4000, 1, boom6)
            setTimer(destroyElement, 4000, 1, boom7)
            setTimer(destroyElement, 4000, 1, boom8)
            setTimer(destroyElement, 4000, 1, boom9)
            setTimer(destroyElement, 1000, 1, col1)
            setTimer(destroyElement, 1000, 1, col2)
            setTimer(destroyElement, 1000, 1, col3)
            setTimer(destroyElement, 1000, 1, col4)
            setTimer(destroyElement, 1000, 1, col5)
            pX,pY,pZ = nil,nil,nil
            local x, y, z = getElementPosition(boom1)              
            triggerClientEvent("playBoom", root, x, y, z)
                    
            setElementData(player, "rocket", getElementData(player, "rocket")-1)
        end, 7999, 1)
            
end  
addEvent("createFirework",true)
addEventHandler("createFirework",root,createFirework)]]