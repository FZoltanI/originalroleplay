local screenX,screenY = guiGetScreenSize()
local width, height = 1920, 1080
local sx, sy = guiGetScreenSize()
local xF = (1920/sx)*1.1
if xF < 0.7 then xF = 0.7 end
if xF > 1 then xF = 1 end
local raceData = {
	{"Dr Christopher Gates", 23.4, "Koenigsegg CCX"}
}
local raceColActive, shader, renderTarget
local font = exports["oFont"]:getFont("condensed",20);

local startedRace = true
local lastCol = -1
local startTime = 0
local startCol = createColCuboid(-260.2678527832-1.5,-1577.1987304688-2,11.10000038147-3, 2, 21, 7)
local needCols = {
    createColSphere(-298.03198242188,-1576.0681152344,11.10000038147, 12),
    createColSphere(-287.36553955078,-1623.0987548828,11.10000038147, 12),
    createColSphere(-260.00424194336,-1602.3812255859,16.95937538147, 12),
    createColSphere(-324.94149780273,-1545.9382324219,11.10000038147, 12),
    createColSphere(-167.6325378418,-1504.8747558594,11.10000038147, 12),
}

local colIDS = {}
for id, col in ipairs(needCols) do
	local pos = Vector3(getElementPosition(col))
	createMarker(pos.x,pos.y,pos.z,"checkpoint", 1)
	colIDS[col] = id
end



addEventHandler("onClientColShapeHit", resourceRoot, function(theElement, matchingDimension)
	if theElement == localPlayer and matchingDimension and startedRace and colIDS[source] then
		local id = colIDS[source]
		local beforeCol = id - 1
		if lastCol == -1 or lastCol == beforeCol then
			lastCol = id
		end
	end
end)

-- elindítás
addEventHandler("onClientColShapeHit", startCol, function(theElement, matchingDimension)
	if theElement == localPlayer and matchingDimension and startedRace then
		if startTime <= 0 and isPedInVehicle(localPlayer) and getPedOccupiedVehicleSeat(localPlayer) == 0 then
			startTime = getTickCount()
            lastCol = -1
            addEventHandler("onClientRender", root, renderRaceTime)
		elseif lastCol == #needCols and isPedInVehicle(localPlayer) and getPedOccupiedVehicleSeat(localPlayer) == 0 then
			local time = (startTime > 0 and (getTickCount()-startTime)/1000) or 0
			triggerServerEvent("finish.race", localPlayer, time)
            outputChatBox("Sikeresen végigmentél a pályán, időd: "..disp_time(time).."!")
			resetRace()
		end
	end
end)

-- reset
function resetRace()
	if startedRace then
		removeEventHandler("onClientRender", root, renderRaceTime)
		--startedRace = false
		startTime = 0
		lastCol = -1
	end
end

function renderRaceTime()
    exports.oCore:dxDrawShadowedText(disp_time((startTime > 0 and (getTickCount()-startTime)/1000) or 0), 0, 30*xF, sx, 30*xF, tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 255), 1, font, "center", "top", _, _, true, true)
end


createObject(2790,584.50338134766, -1167.9005615234, 28.150974273682,20,0,43) --(cj_airp_s_2)
createObject(3077, -176.43533325195,-1542.18359375,11.10000038147-1, 0,0,90)


local marker = createMarker(588.32006835938, -1171.7384033203, 21.05011138916,"cylinder",4,237, 100, 21,100)
local Endmarker = createMarker(-178.72991943359, -1519.7692871094, 10.022966194153,"cylinder",4,237, 100, 21,100)

-- shader
local shaderValue = [[
	texture textureFile;

	technique TexReplace
	{
		pass P0
		{
			Texture[0] = textureFile;
		}
	}
]]

-- init
function initRaceTable()
	shader = dxCreateShader(shaderValue, 0, 500, false, "object")
	if shader then
		engineApplyShaderToWorldTexture(shader, "cj_airp_s_2")
		engineApplyShaderToWorldTexture(shader, "nf_blackbrd")
		generateTable(raceData)
	else
		outputChatBox("Hiba történt a shader létrehozásakor", 255, 0, 0)
	end
end


-- reset
function resetRaceTable()
	if isElement(shader) then
		destroyElement(shader)
	end
	
	if isElement(renderTarget) then
		destroyElement(renderTarget)
	end
end

local levelColors = {
	[1] = tocolor(235, 201, 52, 200),
	[2] = tocolor(192, 192, 192, 200),
	[3] = tocolor(205, 127, 50, 200),
}
function generateTable(data)
    if isElement(renderTarget) then
		destroyElement(renderTarget)
	end
	renderTarget = dxCreateRenderTarget(width, height)
    if renderTarget then
        dxSetRenderTarget(renderTarget)
        dxDrawRectangle ( 0, 0, width, height, tocolor(22,22,22) ) 
        dxDrawRectangle(0,0, width, 69, tocolor(10,10,10))
        dxDrawText("RANK#", 10, 0, width, 69 , tocolor(255,128,64,255),2,font)
        dxDrawText("NÉV", 350, 0, width, 69 , tocolor(255,128,64,255),2,font)
        dxDrawText("IDŐ", 0, 0, width, 69 , tocolor(255,128,64,255),2,font, "center", "center")
        dxDrawText("JÁRMŰ", 0, 0, width - 160, 69 , tocolor(255,128,64,255),2,font, "right", "center")
        local x, y = 0, 79
        local w, h = width, 69
        local padding = 2
        
        for i=1, 14 do
            local d = data[i]
            dxDrawRectangle(x, y, w, h, tocolor(10,10,10))



            if d then
                dxDrawText(i, x+50, y+h, w, y, (i <= 3 and levelColors[i] or tocolor(255, 255, 255)), 2, font, "left", "center", false, false, false, true)
                dxDrawText(d[1], x+250, y+h, w, y, (i <= 3 and levelColors[i] or tocolor(255, 255, 255)), 2, font, "left", "center", false, false, false, true)
                dxDrawText(disp_time(d[2]), x, y+h, w, y, (i <= 3 and levelColors[i] or tocolor(255, 255, 255)), 2, font, "center", "center", false, false, false, true)
                dxDrawText(d[3], x- dxGetTextWidth(d[3], 2, font) , y+h, w- 10, y, (i <= 3 and levelColors[i] or tocolor(255, 255, 255)), 2, font, "right", "center", false, false, false, true)
               -- dxDrawText(d[3].."\n "..d[4], x+w-10, y+h, x+w-10, y, (i <= 3 and tocolor(0,0,0) or tocolor(255, 255, 255)), 1, font, "right", "center", false, false, false, true)
            else
                dxDrawText(i, x+50, y+h, w, y, (i <= 3 and tocolor(255,255,255) or tocolor(255, 255, 255)), 2, font, "left", "center", false, false, false, true)
                dxDrawText("Üres hely", x, y+h, w, y, (i <= 3 and tocolor(255,255,255) or tocolor(255, 255, 255)), 2, font, "center", "center", false, false, false, true)
            end

            y = y + h + padding
        end
        dxDrawRectangle(0, height-1, width, 1, tocolor(248, 102, 37, 255))
        dxSetRenderTarget()
		dxSetShaderValue(shader, "textureFile", renderTarget)
    end
end


function disp_time(time)
   -- print(time)
	local ms = split(time, ".")
	if not ms or #ms < 2 then
		ms = 0
	elseif ms[2] then
		ms = tonumber(ms[2]:sub(0, 2) or 0)
	end
	ms = math.floor(ms)
	local hours = math.floor(math.mod(time, 86400)/3600)
	local minutes = math.floor(math.mod(time,3600)/60)
	local seconds = math.floor(math.mod(time,60))
	return string.format("%d:%02d:%02d.%02d",hours,minutes,seconds,ms)
end



addEvent("race.generateTable", true)
addEventHandler("race.generateTable", root, function(data)
	raceData = data
    table.sort(raceData, function(a,b)
        if a[2] and b[2] then 
            return a[2] < b[2]
        end
    end)
	generateTable(data)
end)
local syntax = exports["oCore"]:getServerPrefix()
addCommandHandler("getracedetails",function()
    if getElementData(localPlayer, "user:admin") >= 10 then
        if #raceData > 0 then
            for k,v in pairs(raceData) do 
                outputChatBox(syntax .." ".. k .. ". | ".. v[1] .. " | " .. v[2] .. " | "..v[3], 255,255,255,true)
            end
        else 
            outputChatBox(syntax .."Nincs még eredmény!", 255, 255,255,true)
        end
    end
end)

initRaceTable()

