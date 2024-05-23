--[[
	
	Project trains
	Creator: IIYAMA
	File: server.lua
	
	You are free to modify this file to your needs.
	
	
]]


--- settings ---
local amountOfTrains = tonumber(get("amountOfTrains"))
if not amountOfTrains or amountOfTrains <= 0 then
	amountOfTrains = 4
	outputChatBox("WARNING: amountOfTrains has been given a wrong value. It has been reset to default: " .. amountOfTrains,root,255,0,0)
end


local trainSpeed = tonumber(get("trainSpeed"))
if not trainSpeed or trainSpeed < 0.1 then
	trainSpeed = 10
	outputChatBox("WARNING: trainSpeed has been given a wrong value. It has been reset to default: " .. trainSpeed,root,255,0,0)
end

local minAmountOfCarts = tonumber(get("minAmountOfCarts"))
if not minAmountOfCarts or minAmountOfCarts <= 0 then
	minAmountOfCarts = 3
	outputChatBox("WARNING: minAmountOfCarts has been given a wrong value. It has been reset to default: " .. minAmountOfCarts,root,255,0,0)
end

local maxAmountOfCarts = tonumber(get("maxAmountOfCarts"))
local maxAmountOfCarts = tonumber(get("maxAmountOfCarts"))
if not maxAmountOfCarts or maxAmountOfCarts <= 0 then
	maxAmountOfCarts = 10
	outputChatBox("WARNING: maxAmountOfCarts has been given a wrong value. It has been reset to default: " .. maxAmountOfCarts,root,255,0,0)
end


local driverSkins = get("driverSkins")
if not driverSkins or type(driverSkins) ~= "table" or #driverSkins == 0 then
	driverSkins = {17}
	outputChatBox("WARNING: driverSkins has been given a wrong value. It has been reset to default: [ [" .. table.concat(driverSkins,",") .. "] ]",root,255,0,0)
else
	local validSkinNumbersArray = getValidPedModels()
	local validSkinNumbers = {}
	for i=1,#validSkinNumbersArray do
		validSkinNumbers[validSkinNumbersArray[i]] = true
	end
	for i=#driverSkins,1,-1 do
		local skin = driverSkins[i]
		if not validSkinNumbers[skin] then
			table.remove(driverSkins,i)
			outputChatBox("WARNING: Invalid skin found: " .. tostring(skin),root,255,0,0)
		end
	end
	if #driverSkins == 0 then
		outputChatBox("WARNING: driverSkins has been given a wrong values and has been reset to default: [ [ 17 ] ]",root,255,0,0)
		driverSkins = {17}
	end
end

----------------

local trainServersideData = {}


local loadedPlayers = {}
local serverStartTickCount = 0
local serverStartTickCount = getTickCount()

function sendTrainTimingToPlayers ()
	triggerClientEvent(loadedPlayers, "syncTrainsTiming", resourceRoot, getTickCount() - serverStartTickCount)
end


math.randomseed((getTickCount()*getTickCount())/(getTickCount()*0.5))

function superRandom (mini,maxi)
	local randomContent2 = {}
	local mathRandom = math.random
	for i=1,10 do
		local randomContent = {}
		for j=1, 10 do
			randomContent[j]= mathRandom(mini,maxi)
		end
		randomContent2[i]=randomContent
	end
	local randomContent = randomContent2[mathRandom(#randomContent2)]
	return randomContent[mathRandom(#randomContent)]
end

addEventHandler("onResourceStart",resourceRoot,
function ()
	
	local trainDesigns = loadTrainCartDesigns()
	
	for trainIndex=1, amountOfTrains do
	
		local designIndex = trainIndex % #trainDesigns
		if designIndex == 0 then
			designIndex = #trainDesigns
		end
		
		
		local design = trainDesigns[designIndex]
		
		local cartsData = {}
		
		local trainCartDesigns_ = design.trainCarts
		
		--[[
			This is making a shallow copy, so that table.remove can be used for the reserved train-cart positions.
		]]
		local trainCartDesigns = {}
		for i=1, #trainCartDesigns_ do
			trainCartDesigns[i] = trainCartDesigns_[i]
		end
		
		
		
		local amountOfCarts = superRandom(minAmountOfCarts, maxAmountOfCarts)
		
		local trainCartIndexReserved = {}
		for i=#trainCartDesigns, 1, -1 do
			local trainCartDesign = trainCartDesigns[i]
			local position = tonumber(trainCartDesign.config.position)
			if position then
				table.remove(trainCartDesigns, i)
				
				if position < 0 then
					trainCartIndexReserved[amountOfCarts + position + 1] = trainCartDesign
				else
					trainCartIndexReserved[position] = trainCartDesign
				end
			end
		end
		
		
		for trainCartIndex=1,amountOfCarts do
			local trainCartDesign = trainCartIndexReserved[trainCartIndex]
			if not trainCartDesign then
				trainCartDesign = trainCartDesigns and trainCartDesigns[superRandom(1,#trainCartDesigns)] or false
			end
			cartsData[trainCartIndex] = {["model"]=trainCartDesign.model,["attached"]=trainCartDesign.elements}
		end
		
		trainServersideData[trainIndex] = {["cartsData"]=cartsData,["model"]= design.model,["driver"]=driverSkins[superRandom(1,#driverSkins)]}
		
	end
	
	setTimer(sendTrainTimingToPlayers, 10000, 0)
end)

addEvent("onClientTrainScriptLoad",true)
addEventHandler("onClientTrainScriptLoad",root,
function (thisResource)
	if source == client and thisResource == resourceRoot then
		triggerClientEvent(source,"onClientTrainResourceStart", resourceRoot, amountOfTrains, trainSpeed, trainServersideData, getTickCount() - serverStartTickCount)
		loadedPlayers[#loadedPlayers+1] = source
	end
end)

addEventHandler("onPlayerQuit",root,
function ()
	for i=1,#loadedPlayers do
		local player = loadedPlayers[i]
		if player == source then
			table.remove(loadedPlayers,i)
			break
		end
	end
end)
