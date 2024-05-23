local graffitiSavePath = "storedServerGraffitis.json"
local graffitiSaveFolder = "files/server_graffitis/"

local graffitiDatas = {}
local graffitiImages = {}

addEvent("onTryToDownloadClientImage", true)
addEventHandler("onTryToDownloadClientImage", getRootElement(),
	function (path)
		local player = source
		
		fetchRemote(path,
			function (responseData, errno)
				triggerClientEvent(player, "onClientReceiveDownloadedImage", player, responseData, errno)
			end
		, "", false)
	end
)

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		if not fileExists(graffitiSavePath) then
			graffitiDatas = {}
		else
			local graffitis = fileOpen(graffitiSavePath)
			if graffitis then
				local graffitisData = fileRead(graffitis, fileGetSize(graffitis))
				
				if graffitisData then
					graffitiDatas = fromJSON(graffitisData)
					
					for fileName, data in pairs(graffitiDatas) do
						fileName = utf8.gsub(utf8.gsub(fileName, "#%x%x%x%x%x%x", ""), "%W", "")

						if fileExists(graffitiSaveFolder .. fileName .. ".png") then
							local graffitiImage = fileOpen(graffitiSaveFolder .. fileName .. ".png")
							if graffitiImage then
								graffitiImages[fileName] = fileRead(graffitiImage, fileGetSize(graffitiImage))
								fileClose(graffitiImage)
							end
						end
					end
				end
				
				fileClose(graffitis)
			end
		end
	end
)

addEventHandler("onResourceStop", getResourceRootElement(),
	function ()
		if fileExists(graffitiSavePath) then
			fileDelete(graffitiSavePath)
		end
		
		local graffitis = fileCreate(graffitiSavePath)
		if graffitis then
			fileWrite(graffitis, toJSON(graffitiDatas))
			fileClose(graffitis)
		end
	end
)

addEvent("requestGraffitiList", true)
addEventHandler("requestGraffitiList", getRootElement(),
	function ()
		triggerClientEvent(source, "receiveGraffitiList", source, graffitiDatas)
	end
)

addEvent("requestGraffitis", true)
addEventHandler("requestGraffitis", getRootElement(),
	function (requestGraffitis)
		if requestGraffitis then
			local datasToSend = {}
			
			for _, fileName in pairs(requestGraffitis) do
				if graffitiDatas[fileName] and graffitiImages[fileName] then
					table.insert(datasToSend, {fileName, graffitiImages[fileName]})
				end
			end
			
			triggerClientEvent(source, "receiveGraffitis", source, datasToSend)
		end
	end
)

addEvent("createGraffiti", true)
addEventHandler("createGraffiti", getRootElement(),
	function (pixels, data)
		local fileName = getRealTime().timestamp .. "-" .. utf8.gsub(utf8.gsub(getPlayerName(source), "#%x%x%x%x%x%x", ""), "%W", "")
		
		local graffitiImage = fileCreate(graffitiSaveFolder .. fileName .. ".png")
		if graffitiImage then
			fileWrite(graffitiImage, pixels)
			fileClose(graffitiImage)
			
			graffitiImages[fileName] = pixels
			graffitiDatas[fileName] = data
			graffitiDatas[fileName].fileName = fileName
			
			triggerClientEvent("createGraffiti", getRootElement(), source, graffitiImages[fileName], graffitiDatas[fileName])
		end
	end
)

addEvent("deleteGraffiti", true)
addEventHandler("deleteGraffiti", getRootElement(),
	function (fileName)
		if graffitiDatas[fileName] then
			if fileExists(graffitiSaveFolder .. fileName .. ".png") then
				fileDelete(graffitiSaveFolder .. fileName .. ".png")
			end
			
			graffitiDatas[fileName] = nil
			graffitiImages[fileName] = nil
			
			triggerClientEvent("deleteGraffiti", getRootElement(), fileName)
		end
	end
)

addEvent("protectGraffiti", true)
addEventHandler("protectGraffiti", getRootElement(),
	function (fileName)
		if graffitiDatas[fileName] then
			graffitiDatas[fileName].isProtected = not graffitiDatas[fileName].isProtected
			
			triggerClientEvent("protectGraffiti", getRootElement(), fileName, graffitiDatas[fileName].isProtected)
		end
	end
)

addEvent("graffitiCleanAnimation", true)
addEventHandler("graffitiCleanAnimation", getRootElement(),
	function ()
		setPedAnimation(source, "graffiti", "spraycan_fire", 36000, true, false, false, false)
	end
)