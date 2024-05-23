
local gridStart = {2688.7368164063, 794.07672119141, 9.98}
local gridObjects = {}

local wallSize = 3

local renderedGrid = {}
function createGrid(gridSize)
    local nextGridPos = gridStart
    local lastGridPos = nextGridPos

    for i = 1, gridSize * gridSize do 
        for i2 = 1, 4 do 
            lastGridPos = nextGridPos

            table.insert(renderedGrid, {lastGridPos[1], lastGridPos[2], lastGridPos[3], nextGridPos[1] - wallSize, nextGridPos[2], nextGridPos[3], false} )
            table.insert(renderedGrid, {lastGridPos[1], lastGridPos[2], lastGridPos[3], nextGridPos[1], nextGridPos[2] + wallSize, nextGridPos[3], false} )
            table.insert(renderedGrid, {lastGridPos[1], lastGridPos[2] + wallSize, lastGridPos[3], nextGridPos[1] - wallSize, nextGridPos[2] + wallSize, nextGridPos[3], false} )
        end

        if i % gridSize == 0 then 
            table.insert(renderedGrid, {lastGridPos[1] - wallSize, lastGridPos[2], lastGridPos[3], nextGridPos[1] - wallSize, nextGridPos[2] + wallSize, nextGridPos[3], false} )

            nextGridPos[2] = nextGridPos[2] + wallSize
            nextGridPos[1] = 2688.7368164063
        else
            nextGridPos[1] = nextGridPos[1] - wallSize
        end
    end
end
createGrid(6)

addEventHandler("onClientRender", root, function()
    for k, v in ipairs(renderedGrid) do 
        local startx, starty, startz, endx, endy, endz, hover = unpack(v)

        if hover then
            dxDrawLine3D(startx, starty, startz, endx, endy, endz, tocolor(0, 120, 30, 200), 3)
        else
            dxDrawLine3D(startx, starty, startz, endx, endy, endz, tocolor(200, 120, 30, 100), 3)
        end
        --dxDrawLine3D(startx, starty, startz, startx, starty, startz + 5, tocolor(200, 0, 0, 100), 3)
    end
end)

local pointer = createObject(3533, 0, 0, 0)
addEventHandler("onClientCursorMove", root, function(_, _, _, _, x, y, z)
    if isCursorShowing() then
        local px, py, pz = getCameraMatrix()
        local hit, wx, wy, wz, elementHit = processLineOfSight(px, py, pz, x, y, z)


        for k, v in ipairs(renderedGrid) do 
            local ox, oy, oz, ox2, oy2, oz2 = unpack(v)
            local distance = getDistanceBetweenPoints3D(wx, wy, wz, ox, oy, oz)

            v[7] = false 

            if distance < 0.5 then 
                if ox < wx then 
                    v[7] = true
                end
            end
        end
    end
end)

local generatedWalls = {}

function generateWalls()

end