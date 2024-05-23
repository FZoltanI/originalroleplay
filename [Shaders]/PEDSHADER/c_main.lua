--
-- c_main.lua
--

pedNormalTable = { ns = { shader = {}, ID = {}, total = 0 }, nTex = {}, ss = { shader = {}, ID = {}, total = 0 } }

pedNormalSettings = {     
		sEffIntens = {0.8,1},
		sFreshlInten = {-0.42,1},
		maxEffectDistance = 22,
		sunEnabled = true, -- requires shader model 3
		ID = {
			{1,2}, {7,7}, {9,29}, {30,41}, {43,52}, {53,64}, {66,73}, {75,85}, {87,118}, {120,144}, 
			{145,148}, {150,189}, {190,207}, {209,238},{240,264},{265,272},{278,288},{290,312}
			}
}

function applyNormalToPedTexture(applyTable)
	for _,name in ipairs(applyTable) do
		local lastBit = string.len(string.match( name, ( "(.*_)" )))
		local bumpfactor = tonumber(string.sub( name, lastBit + 4, -5 ))
		pedNormalSettings.sEffIntens[1] = bumpfactor
		local texName = string.sub(name, string.len(string.match( name, ( "(.*/)" ))) + 1, lastBit-1)	
		pedNormalTable.ns.total = pedNormalTable.ns.total + 1
		pedNormalTable.ns.ID[texName] = pedNormalTable.ns.total
		outputDebugString('SPN Normal: apply effect to texture: '..tostring(texName)..' ids: '..pedNormalTable.ns.total)			
		local texID = pedNormalTable.ns.ID[texName]			
		pedNormalTable.ns.shader[texID] = dxCreateShader ( "shaders/pedNormal.fx", 2, pedNormalSettings.maxEffectDistance, false, "ped")
		if not pedNormalTable.ns.shader[texID] then
			outputChatBox( "SPN Normal: Failed to create shader" )
			return false
		else
			pedNormalTable.nTex[texID] = dxCreateTexture ( name )
			dxSetShaderValue ( pedNormalTable.ns.shader[texID], "sBumpTexture", pedNormalTable.nTex[texID] )
			dxSetShaderValue ( pedNormalTable.ns.shader[texID], "sEffIntens", pedNormalSettings.sEffIntens )
			dxSetShaderValue ( pedNormalTable.ns.shader[texID], "sFreshlInten", pedNormalSettings.sFreshlInten )
			dxSetShaderValue ( pedNormalTable.ns.shader[texID], "sVisibility", 0 )
   
			engineApplyShaderToWorldTexture ( pedNormalTable.ns.shader[texID], texName )
		end
	end
	spnEffectEnabled = true
	return true
end

function removeNormalFromPedTexture(removeTable)
	for _,name in ipairs(removeTable) do
		local lastBit = string.len( string.match( name, ( "(.*_)" )))
		local texName = string.sub( name, string.len( string.match( name, ( "(.*/)" ))) + 1,lastBit - 1)
		local texID = pedNormalTable.ns.ID[texName]	
		if  pedNormalTable.ns.shader[texID] then 
			engineRemoveShaderFromWorldTexture ( pedNormalTable.ns.shader[texID], texName )
			destroyElement( pedNormalTable.ns.shader[texID] )
			pedNormalTable.ns.shader[texID] = nil
			if pedNormalTable.ns.shader[texID] then 
				outputDebugString( 'SPN Normal: RemoveNormalFromPedTexture: '..texName..' fail' ) 
				return false 
			end
		end
	end
	return true 
end

function applySpecularToGTAPeds(pedIDs,...)
	local extTab = {...}
	local isSobel = extTab[1] or false
	if type(pedIDs)~="table" and pedIDs=="all" then
		for _,IDTable in ipairs(pedNormalSettings.ID) do	 
			for thePedID = IDTable[1], IDTable[2], 1 do
				for _,pedTex in ipairs( engineGetModelTextureNames( thePedID ) ) do
					pedNormalTable.ss.total = pedNormalTable.ss.total + 1
					pedNormalTable.ss.ID[pedTex] = pedNormalTable.ss.total
					outputDebugString('SPN Sobel: apply effect to texture: '..tostring(pedTex)..' ids: '..pedNormalTable.ss.total)
					local texID = pedNormalTable.ss.ID[pedTex]
					pedNormalTable.ss.shader[texID] = dxCreateShader ( "shaders/pedSobel.fx", 1, pedNormalSettings.maxEffectDistance, false, "ped")
					if pedNormalTable.ss.shader[texID] then
						engineApplyShaderToWorldTexture ( pedNormalTable.ss.shader[texID], pedTex )
						dxSetShaderValue ( pedNormalTable.ss.shader[texID], "isSobel", isSobel )
						dxSetShaderValue ( pedNormalTable.ss.shader[texID], "sEffIntens", pedNormalSettings.sEffIntens[1],pedNormalSettings.sEffIntens[2]/2 )
						dxSetShaderValue ( pedNormalTable.ss.shader[texID], "sFreshlInten", pedNormalSettings.sFreshlInten)
						dxSetShaderValue ( pedNormalTable.ss.shader[texID], "sVisibility", 0 )
					else
						outputChatBox('SPN Sobel: Failed to create shader',255,0,0)
						return false
					end
				end
			end
		end
		return true
	elseif type(pedIDs)=="table" then 
		for _,singlePedID in ipairs(pedIDs) do   
			for _,pedTex in ipairs(engineGetModelTextureNames(singlePedID)) do
				pedNormalTable.ss.total = pedNormalTable.ss.total + 1
				pedNormalTable.ss.ID[pedTex] = pedNormalTable.ss.total
				outputDebugString('SPN Sobel: apply effect to texture: '..tostring(pedTex)..' ids: '..pedNormalTable.ss.total)
				local texID = pedNormalTable.ss.ID[pedTex]
				pedNormalTable.ss.shader[texID] = dxCreateShader ( "shaders/pedSobel.fx", 1, pedNormalSettings.maxEffectDistance, false, "ped")
				if pedNormalTable.ss.shader[texID] then
					engineApplyShaderToWorldTexture ( pedNormalTable.ss.shader[texID], pedTex )
					dxSetShaderValue ( pedNormalTable.ss.shader[texID], "isSobel", isSobel )
					dxSetShaderValue ( pedNormalTable.ss.shader[texID], "sEffIntens", pedNormalSettings.sEffIntens[1],pedNormalSettings.sEffIntens[2]/2 )
					dxSetShaderValue ( pedNormalTable.ss.shader[texID], "sFreshlInten", pedNormalSettings.sFreshlInten)
					dxSetShaderValue ( pedNormalTable.ss.shader[texID], "sVisibility", 0 )
				else
					outputChatBox('SPN Sobel: Failed to create shader',255,0,0)
					return false
				end
			end
		end
		return true
	elseif type(pedIDs)=="number" then
		for _,pedTex in ipairs( engineGetModelTextureNames( pedIDs ) ) do
			pedNormalTable.ss.total = pedNormalTable.ss.total + 1
			pedNormalTable.ss.ID[pedTex] = pedNormalTable.ss.total
			outputDebugString('SPN Sobel: apply effect to texture: '..tostring(pedTex)..' ids: '..pedNormalTable.ss.total)
			local texID = pedNormalTable.ss.ID[pedTex]
			pedNormalTable.ss.shader[texID] = dxCreateShader ( "shaders/pedSobel.fx", 1, pedNormalSettings.maxEffectDistance, false, "ped")
			if pedNormalTable.ss.shader[texID] then
				engineApplyShaderToWorldTexture ( pedNormalTable.ss.shader[texID], pedTex )
				dxSetShaderValue ( pedNormalTable.ss.shader[texID], "isSobel", isSobel )
				dxSetShaderValue ( pedNormalTable.ss.shader[texID], "sEffIntens", pedNormalSettings.sEffIntens[1],pedNormalSettings.sEffIntens[2]/2 )
				dxSetShaderValue ( pedNormalTable.ss.shader[texID], "sFreshlInten", pedNormalSettings.sFreshlInten)
				dxSetShaderValue ( pedNormalTable.ss.shader[texID], "sVisibility", 0 )
			else
				outputChatBox('SPN Sobel: Failed to create shader',255,0,0)
				return false
			end
		end
		return true
	else
		outputChatBox('SPN Sobel: Improper arguments',255,0,0)
		return false
	end
end

function removeSpecularFromGTAPeds(pedIDs)
	if type(pedIDs)~="table" and pedIDs=="all" then
		for _,IDTable in ipairs(pedNormalSettings.ID) do	 
			for thePedID = IDTable[1], IDTable[2], 1 do
				for _,pedTex in ipairs( engineGetModelTextureNames( thePedID ) ) do
					local texID = pedNormalTable.ss.ID[pedTex]	
					if pedNormalTable.ss.shader[texID] then
						engineRemoveShaderFromWorldTexture ( pedNormalTable.ss.shader[texID], pedTex )
						destroyElement(pedNormalTable.ss.shader[texID])
					else
						outputChatBox('SPN Sobel: Failed to destroy shader',255,0,0)
						return false
					end
				end
			end
		end	 
	elseif type(pedIDs)=="table" then 
		for _,singlePedID in ipairs(pedIDs) do   
			for _,pedTex in ipairs(engineGetModelTextureNames(singlePedID)) do
				local texID = pedNormalTable.ss.ID[pedTex]	
				if pedNormalTable.ss.shader[texID] then
					engineRemoveShaderFromWorldTexture ( pedNormalTable.ss.shader[texID], pedTex )
					destroyElement(pedNormalTable.ss.shader[texID])
				else
					outputChatBox('SPN Sobel: Failed to destroy shader',255,0,0)
					return false
				end
			end
		end
		return true
	elseif type(pedIDs)=="number" then
		for _,pedTex in ipairs( engineGetModelTextureNames( pedIDs ) ) do
			local texID = pedNormalTable.ss.ID[pedTex]
			if pedNormalTable.ss.shader[texID] then
				engineRemoveShaderFromWorldTexture ( pedNormalTable.ss.shader[texID], pedTex )
				destroyElement(pedNormalTable.ss.shader[texID])
			else
				outputChatBox('SPN Sobel: Failed to destroy shader',255,0,0)
				return false
			end
		end
		return true
	else
		outputChatBox('SPN Sobel: Improper arguments',255,0,0)
		return false
	end
end
	
addEventHandler( "onClientResourceStart", getResourceRootElement( getThisResource()),function()
	spnEffectEnabled = true
	if tostring( dxGetStatus().VideoCardPSVersion )~="3" then 
		outputDebugString('SPN: Shader Model 3 not supported')
		pedNormalSettings.sunEnabled = false
	end
	if isDynamicSkyStarted then 
		applyDynamicSky() 
	else 
		startShineTimer() 
	end
	addEventHandler( "onClientPreRender", root, updateVisibility )
end
)
