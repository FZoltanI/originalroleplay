local sx, sy = guiGetScreenSize() 
local myX, myY = 1600, 900 

local grid = {}
local renderedGridSize

local core = exports.oCore
local color, r, g, b = core:getServerColor()

function createGrid(gridSize)

    grid = {}

    renderedGridSize = gridSize 

    local row, column = 1, 1

    local startSquare = math.random(1,gridSize*gridSize)
    local startRot
    local endSquare = math.random(1,gridSize*gridSize) 

    while endSquare == startSquare do 
        endSquare = math.random(1,gridSize*gridSize) 
    end

    for i = 1, gridSize*gridSize do 

        local squareType = "normal"
        local pipeType = 1
        local rot = 0

        if i == startSquare then 
            squareType = "start"
            pipeType = math.random(1)
            rot = rotations[math.random(#rotations)]
            startRot = rot
        elseif i == endSquare then 
            squareType = "end"
            pipeType = math.random(1)
        end

        table.insert(grid, #grid+1, {row, column, squareType, pipeType, rot})

        if column == gridSize then 
            row = row + 1
            column = 0
        end

        column = column + 1
    end

    local sides = getNearestBlocks(startSquare)
    --outputChatBox(rot_detects[startRot]..", "..startRot)
    while not sides[rot_detects[grid[startSquare][5]]] do 
        grid[startSquare][5] = rotations[math.random(#rotations)]

        --outputChatBox(rot_detects[startRot]..": "..tostring(sides[rot_detects[startRot]]))
    end
end
setTimer(function() 
    createGrid(math.random(3,6)) 
    addEventHandler("onClientRender", root, renderGrid)
end, 100, 1)

for k, v in ipairs(grid) do 
    outputChatBox("Sor: "..v[1]..", Oszlop: "..v[2])
end
outputChatBox("Össz: "..#grid)

local szorzo = 1
local renderedGridSquareSize = {0.03125*szorzo, 0.055*szorzo}

local startX, startY = 0.375, 0.28
function renderGrid()

    -- Development lines
    --[[dxDrawLine(sx*0.5,0,sx*0.5,sy,tocolor(210,150,32,255),5)
    dxDrawLine(0,sy*0.5,sx,sy*0.5,tocolor(210,32,150,255),5)

    dxDrawLine(sx,0,sx,sy,tocolor(255,0,0,255),5)
    dxDrawLine(0,sy,sx,sy,tocolor(255,0,0,255),5)]]

    szorzo = szorzoList[renderedGridSize]
    renderedGridSquareSize = {0.03125*szorzo, 0.055*szorzo}

    --dxDrawRectangle((sx*startX), (sy*startY)-4/myY*sy, sx*renderedGridSquareSize[1]*#grid, sy*renderedGridSquareSize[2]*4, tocolor(30, 30, 30, 255))

    for k, v in ipairs(grid) do

        local color = tocolor(255,255,255,255)

        if core:isInSlot(sx*(startX+renderedGridSquareSize[1]*v[2]),sy*(startY+renderedGridSquareSize[2]*v[1]),sx*renderedGridSquareSize[1],sy*renderedGridSquareSize[2]) then 
            dxDrawRectangle(sx*(startX+renderedGridSquareSize[1]*v[2]),sy*(startY+renderedGridSquareSize[2]*v[1]),sx*renderedGridSquareSize[1],sy*renderedGridSquareSize[2],tocolor(r, g, b, 200))
        end

        if v[3] == "start" then 
            dxDrawImage(sx*(startX+renderedGridSquareSize[1]*v[2]),sy*(startY+renderedGridSquareSize[2]*v[1]),sx*renderedGridSquareSize[1],sy*renderedGridSquareSize[2],"files/pipes/tile_"..v[4].."_out.png",v[5],0,0)
        elseif v[3] == "end" then 
            dxDrawImage(sx*(startX+renderedGridSquareSize[1]*v[2]),sy*(startY+renderedGridSquareSize[2]*v[1]),sx*renderedGridSquareSize[1],sy*renderedGridSquareSize[2],"files/pipes/tile_"..v[4].."_in.png",v[5],0,0)
            --dxDrawRectangle(sx*(startX+renderedGridSquareSize[1]*v[2]),sy*(startY+renderedGridSquareSize[2]*v[1]),sx*renderedGridSquareSize[1],sy*renderedGridSquareSize[2],tocolor(255,0,0,255))
        elseif v[3] == "pipe_bend" then 
        elseif v[3] == "pipe_normal" then 
        elseif v[3] == "pipe_cross" then 
        else
            --dxDrawRectangle(sx*(startX+renderedGridSquareSize[1]*v[2]),sy*(startY+renderedGridSquareSize[2]*v[1]),sx*renderedGridSquareSize[1],sy*renderedGridSquareSize[2],tocolor(0,0,170,30))
        end

        exports.oCore:dxDrawOutLine(sx*(startX+renderedGridSquareSize[1]*v[2]),sy*(startY+renderedGridSquareSize[2]*v[1]),sx*renderedGridSquareSize[1],sy*renderedGridSquareSize[2],tocolor(30, 30, 30, 255), 2)

        --dxDrawText(k, sx*(startX+renderedGridSquareSize[1]*v[2]),sy*(startY+renderedGridSquareSize[2]*v[1]),sx*(startX+renderedGridSquareSize[1]*v[2])+sx*renderedGridSquareSize[1],sy*(startY+renderedGridSquareSize[2]*v[1])+sy*renderedGridSquareSize[2],tocolor(0,0,0,150),3, "default-bold", "center", "center")
    end
end

function GridClick(key, state)
    if key == "mouse1" and state then 
        for k, v in ipairs(grid) do

            if core:isInSlot(sx*(startX+renderedGridSquareSize[1]*v[2]),sy*(startY+renderedGridSquareSize[2]*v[1]),sx*renderedGridSquareSize[1],sy*renderedGridSquareSize[2]) then 
                if v[3] == "start" then 
                    return
                elseif v[3] == "end" then 
                    return
                end

                v[3] = "start"
            end
        end
    end
end
addEventHandler("onClientKey", root, GridClick)

addCommandHandler("recreate", function()
    createGrid(math.random(3,6))
end)

function getNearestBlocks(id)
    local blockRow, blockColumn = grid[id][1], grid[id][2] 

    local sides = {
        ["left"] = 1, 
        ["right"] = 1, 
        ["up"] = false, 
        ["down"] = false,
    }

    if blockRow-1 > 0 then 
        sides["up"] = blockRow-1
        --outputChatBox("felette: "..blockRow-1)
    else
        sides["up"] = false
    end

    if blockRow+1 < getGridRowsCount() then 
        sides["down"] = blockRow+1
    else
        sides["down"] = false
    end

    if blockColumn - 1 > 0 then 
        sides["left"] = blockColumn - 1
    else 
        sides["left"] = false 
    end  

    if blockColumn+1 < getGridColumnsCount() then 
        sides["right"] = blockColumn+1
    else
        sides["right"] = false
    end

    --outputChatBox("alatta: "..grid[id+renderedGridSize][1]..", "..grid[id+renderedGridSize][2])

    return sides
end

function getGridRowsCount()
    local rows
    for k, v in ipairs(grid) do 
        rows = v[1]
    end

    return rows
end

function getGridColumnsCount()
    local columns
    for k, v in ipairs(grid) do 
        columns = v[2]
    end

    return columns
end