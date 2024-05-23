s = Vector2(guiGetScreenSize())
hex,r,g,b = exports["oCore"]:getServerColor()
lumberjack = {
    state = true,
    treeHuds = {},
}



function hitElementTree(loss, attacker)
    if (getElementData(source, 'tree:state')) then
        if ((getPedWeapon(attacker) == 9) or (getPedWeapon(attacker) == 10)) then
            outputChatBox('kugloff'..loss)
            if ( getElementData(source, 'tree:health') > 0 ) then
                newhp = getElementData(source, 'tree:health')
                newhp = newhp - (loss /math.random(9,14))
                if (newhp <= 0) then
                    fellingTree(source,attacker)
                    newhp = 0
                end
                setElementData(source,'tree:health',newhp)
            end
        end
    end
end
addEventHandler("onClientObjectDamage", root, hitElementTree)


function fellingTree(element,owner)
    setElementData(element, 'tree:owner',getElementData(owner, 'char:id'))
    --moveObject(element, 10000, Vector3(getElementPosition(element)), 90, 0, 0)
    destroyElement(element)
end

addEventHandler( "onClientElementStreamIn", root,
    function ( )
        if ( getElementType( source ) == "object" ) then
            if (getElementData(source, 'tree:state')) then
                t = Vector3(getElementPosition(source))
                lumberjack.treeHuds[getElementData(source, 'tree:id')] = {x = t.x, y = t.y, z = t.z, element = source}
            end 
        end
    end
);

addEventHandler( "onClientElementStreamOut", root,
    function ( )
        if ( getElementType( source ) == "object" ) then
            if (getElementData(source, 'tree:state')) then
                lumberjack.treeHuds[getElementData(source, 'tree:id')] = nil
            end 
        end
    end
);




function renderBar()
    for i, hud in ipairs(lumberjack.treeHuds) do 
        local wx, wy = getScreenFromWorldPosition ( hud.x, hud.y, hud.z+1.5) 
        if (wx and wy and getElementData(hud.element, 'tree:health') > 0) then
            distance = getDistanceBetweenPoints3D(hud.x, hud.y, hud.z, Vector3(getElementPosition(localPlayer)))
            if (distance < 5) then
                dxDrawRectangle(wx - (0.13 * s.x / 2), wy, 0.13 * s.x, 0.05 * s.y, tocolor(40,40,40,255))
                dxDrawRectangle(wx - (0.13 * s.x / 2) + 4, wy+4, (((0.13 * s.x) - 8) / settings.lumberjack.treeHealth) * getElementData(hud.element, 'tree:health'), (0.05 * s.y) - 8, tocolor(r,g,b,255))
            end
        end
    end
end
addEventHandler ( "onClientRender", getRootElement(), renderBar )


