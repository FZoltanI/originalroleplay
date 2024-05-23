addEventHandler("onClientResourceStart",resourceRoot,function()
   local txd = engineLoadTXD("cars/hotring.txd")
   engineImportTXD(txd, 555)
   local dff = engineLoadDFF("cars/hotring.dff")
   engineReplaceModel(dff, 555)
   local txd2 = engineLoadTXD("cars/hotrina.txd")
   engineImportTXD(txd2, 558)
   local dff2 = engineLoadDFF("cars/hotrina.dff")
   engineReplaceModel(dff2, 558)
   local txd3 = engineLoadTXD("cars/hotrinb.txd")
   engineImportTXD(txd3, 587)
   local dff3 = engineLoadDFF("cars/hotrinb.dff")
   engineReplaceModel(dff3, 587)
end)

local countdownAnimTick,countdownAnim = getTickCount(),false
local winnerAnimTick,winnerAnim = getTickCount(),false
local font = dxCreateFont("files/display.ttf",40)
local screenWidth, screenHeight = guiGetScreenSize()
local raceColActive, shader, renderTarget
local shader2,renderTarget2
local width, height = 1920, 1080
local width2, height2 = 1200, 1200

local padding = 10 

local winner = "Paul Rodrigez"
local winnerTime = "00:00"
local countdown = 0

local boards = {	--objid,pos1,pos2,pos3,rot,objscale,roty
	{2789,4020.1489257812, -2789.9878417969, 14.096875,1,1,0},
	{2789,3821.3181152344,-2619.25078125,12.096875,1,1,0},
	{2789,3978.7416503906,-2912.769921875,10.100917816162,90,1,0},
	{8324,3978.7500761719,-2909.4489550781,8.8796875,90,0.3,90},
}


local leaderBoard = {}
local topracers = {}

local colors = {
	[1] = {1,210,189},
	[2] = {21,24,95},
	[3] = {208,0,110},
	[4] = {255,135,0},
	[5] = {254,0,0}
}

function renderRaceTable()
	if isElement(renderTarget) then
		destroyElement(renderTarget)
	end

	if isElement(renderTarget2) then
		destroyElement(renderTarget2)
	end

		renderTarget = dxCreateRenderTarget(width, height)
		renderTarget2 = dxCreateRenderTarget(width2,height2)

		if renderTarget then

			dxSetRenderTarget(renderTarget)

			dxDrawImage(0, 0, width, height, "files/board.png", 0, 0, 0, tocolor(255,255,255,255), false)

			table.sort(leaderBoard, function(a,b)
				if a[2] and b[2] then 
					return a[2] < b[2]
				end
			end)

			if not countdownAnim and not winnerAnim then 
				for k,v in pairs(leaderBoard) do 

					realtime = secondsToTimeDesc( v[2] ) --getElementData(v[2],"F1CurrentTime") 
					r,g,b = colors[k][1],colors[k][2],colors[k][3] or 255,135,0			

					dxDrawImage(0 + padding, 150+ 170*(k-1), width - padding * 2, 150, "files/listing.png", 0, 0, 0, tocolor(r,g,b,255), false)
					dxDrawText("#"..k..".",0 + padding, 150+ 170*(k-1),_,_,tocolor(10,10,10,255),2,font)
					dxDrawText(tostring(v[1]),800 + padding, 220+ 170*(k-1),_,_,tocolor(10,10,10,255),1.3,font,"center","center")
					dxDrawText(realtime,1700 + padding, 220+ 170*(k-1),_,_,tocolor(10,10,10,255),1.3,font,"center","center")
				end 
			elseif countdownAnim then 
				color = "#ffffff"

				if countdown <= 10 and countdown >= 8 then 
					color = "#f03a3a"
				elseif countdown <= 7 and countdown >= 4 then 
					color = "#dcde4e"
				else 
					color = "#1bc215"
				end 

				if countdown == 0 then 
					plus,rot = interpolateBetween(0, 0, 0, 2, 180, 0, (getTickCount() - winnerAnimTick)/4000, "SineCurve")

					dxDrawImage(0,-400,2000,2000,"files/effect.png",rot)
					dxDrawText("GO",400 + padding, 150 + 150,_,_,tocolor(240,240,240,255),6 - plus,font,"center","center",false,false,false,true)
					dxDrawText("GO",1400 + padding, 150 + 600,_,_,tocolor(240,240,240,255),6 - plus,font,"center","center",false,false,false,true)


					dxDrawText("GO",950 + padding - 1, 150 + 350 + 1,_,_,tocolor(0,0,0,255),7,font,"center","center",false,false,false,true)
					dxDrawText(color.."GO",950 + padding, 150 + 350,_,_,tocolor(10,10,10,255),7,font,"center","center",false,false,false,true)

				else
					fontplus = interpolateBetween(0, 0, 0, 2, 0, 0, (getTickCount() - countdownAnimTick)/1000, "SineCurve")

					dxDrawText(countdown..".",950 + padding - 1, 150 + 400 + 1,_,_,tocolor(0,0,0,255),7,font,"center","center",false,false,false,true)
					dxDrawText(color..countdown..".",950 + padding, 150 + 400,_,_,tocolor(10,10,10,255),7,font,"center","center",false,false,false,true)
				end 
			elseif winnerAnim then 
				plus,rot = interpolateBetween(0, 0, 0, 1, 180, 0, (getTickCount() - winnerAnimTick)/4000, "SineCurve")
				wintime = secondsToTimeDesc( winnerTime )
				dxDrawImage(0,-400,2000,2000,"files/effect.png",rot)
				dxDrawText("ROUND WINNER",950 + padding, 150 + 150,_,_,tocolor(200,200,200,255),4 - plus,font,"center","center",false,false,false,true)
				dxDrawText(winner,950 + padding, 150 + 400,_,_,tocolor(200,200,200,255),3,font,"center","center",false,false,false,true)
				dxDrawText("TIME: "..wintime,950 + padding, 150 + 600,_,_,tocolor(200,200,200,255),3,font,"center","center",false,false,false,true)

			end 

			dxDrawText("© 2018 - 2023 www.originalrp.eu - All Rights Reserved.",500 + padding, height - padding * 4,_,_,tocolor(10,10,10,255),0.5,font)


			dxSetRenderTarget()
			dxSetShaderValue(shader, "textureFile", renderTarget)
			setTime(12,00)
			setWeather(0)
		end

		if renderTarget2 then 
			--FONTOS EZ AZ EGÉSZ EL VAN ROTÁLVA, AMI EDDI X VOLT AZ AZ Y ÉS FORDÍTVA

			dxSetRenderTarget(renderTarget2)
			dxDrawImage(0, 0, width2, height2, "files/topracers.png", 270, 0, 0, tocolor(255,255,255,255), false)

			table.sort(topracers, function(a,b)
				if a[2] and b[2] then 
					return a[2] < b[2]
				end
			end)

			for k,v in pairs(topracers) do 
				realtime = secondsToTimeDesc( v[2] )
				r,g,b = colors[k][1],colors[k][2],colors[k][3]
				
				dxDrawImage(-455 + padding + 140*(k-1), 525, width2 - padding * 2, 135, "files/topline.png", 270, 0, 0, tocolor(r,g,b,255), false)

				dxDrawText(tostring(v[1]),100 + padding + 140*(k-1), 600,_,_,tocolor(210,210,210,255),1.2,font,"center","center",false,false,false,false,false,270)
				dxDrawText(tostring(realtime),165 + padding + 140*(k-1), 600,_,_,tocolor(210,210,210,255),0.9,font,"center","center",false,false,false,false,false,270)

			end 

			dxSetRenderTarget()
			dxSetShaderValue(shader2, "textureFile", renderTarget2)
		end

		local veh = getPedOccupiedVehicle(localPlayer)
		if veh then
			if getElementModel(veh) == 555 or getElementModel(veh) == 558 or getElementModel(veh) == 587 then 
				currentLap = getElementData(localPlayer,"playerLap")
				realtime = secondsToTimeDesc( getElementData(localPlayer,"F1CurrentTime") )

				dxDrawText("F1: "..getPlayerName(localPlayer).." TIME: "..realtime.." LAP:"..currentLap.."/5",screenWidth*0.5 - 1,padding * 2 + 1,_,_,tocolor(0,0,0,255),0.3,font,"center","center",false,false,false,true)
				dxDrawText("F1: "..getPlayerName(localPlayer).." TIME: "..realtime.." LAP:"..currentLap.."/5",screenWidth*0.5,padding * 2,_,_,tocolor(255,255,255,255),0.3,font,"center","center",false,false,false,true)
			end 
		end 

end

function showWinner(winnername,winnertime)
	leaderBoard = {}
	winnerAnim = true
	winner = winnername
	winnerTime = winnertime

	setTimer(function()
		winnerAnim = false
		setPlayerDatas()
	end,20000,1)
end 
addEvent("showWinner",true)
addEventHandler("showWinner",root,showWinner)

function setPlayerDatas()
	for k,v in pairs(getElementsByType("player")) do 
		setElementData(v,"F1CurrentTime",0)
		setElementData(v,"playerLap",0) 
	end 
end 

function startCountdown()
	leaderBoard = {}

	countdown = 10 
	countdownAnim = true
	setTimer(function()
		countdown = countdown - 1
		for k,v in pairs(boards) do 
			bip = playSound3D("files/countdown.mp3",v[1],v[2],v[3])
			setSoundVolume(bip,70)
			setSoundMaxDistance(bip, 100)
		end

		if countdown == 0 then 
			triggerServerEvent("unfreezeveh",root)

			setTimer(function()
				countdownAnim = false
				setPlayerDatas()
			end,5000,1)
		end 
	end,1000,countdown)
end 
addEvent("startCountdown",true)
addEventHandler("startCountdown",root,startCountdown)

function syncRacer(name,time)
	tableRecord = {name,time}
	table.insert(leaderBoard,tableRecord)
end 
addEvent("syncRacer",true)
addEventHandler("syncRacer",root,syncRacer)

function syncTime(name,time)
	for k,v in pairs(leaderBoard) do 
		if v[1] == name then 
			v[2] = time
		end 
	end 
end 
addEvent("syncTime",true)
addEventHandler("syncTime",root,syncTime)

function insertPlayerToTable(name,time)
	for k,v in pairs(topracers) do 
		if tostring(v[1]) == tostring(name) then 
			v[2] = time
			return 
		end 
	end 

	tableRecords = {name,time}
	table.insert(topracers,tableRecords)
end 
addEvent("insertPlayerToTable",true)
addEventHandler("insertPlayerToTable",root,insertPlayerToTable)

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
	shader2 = dxCreateShader(shaderValue, 0, 500, false, "object")

	if shader then
		engineApplyShaderToWorldTexture(shader, "cj_airp_s_1")
		engineApplyShaderToWorldTexture(shader2, "vgs_rockmid1a")
		setTimer(renderRaceTable,5,0)
		setElementData(localPlayer,"F1CurrentTime",0)
		setElementData(localPlayer,"playerLap",0)
		for k,v in pairs(boards) do 
			f1obj = createObject(v[1],v[2],v[3],v[4],0,v[7],v[5])
			setObjectScale(f1obj,v[6])
		end 

	else
		outputChatBox("Hiba történt a shader létrehozásakor", 255, 0, 0)
	end

end
initRaceTable()

function secondsToTimeDesc( seconds )
	if seconds then
		local results = {}
		local sec = ( seconds %60 )
		local min = math.floor ( ( seconds % 3600 ) /60 )
		local hou = math.floor ( ( seconds % 86400 ) /3600 )
		local day = math.floor ( seconds /86400 )
		
		stringsec = ""
		stringmin = ""

		if sec < 10 then 
			stringsec = "0"..sec 

			if min == 0 then 
				stringsec = "00:0"..sec
			end 
		else 
			stringsec = sec

			if min == 0 then 
				stringsec = "00:"..sec
			end 
		end 

		if min < 10 then 
			stringmin = "0"..min 
		else 
			stringmin = min
		end


		if day > 0 then table.insert( results, day .. ( day == 1 and "" or "" ) ) end
		if hou > 0 then table.insert( results, hou .. ( hou == 1 and "" or "" ) ) end
		if min > 0 then table.insert( results, stringmin .. ( min == 1 and "" or "" ) ) end
		if sec > 0 then table.insert( results, stringsec .. ( sec == 1 and "" or "" ) ) end
		
		return string.reverse ( table.concat ( results, ", " ):reverse():gsub(" ,", ":", 1 ) )
	end
	return ""
end