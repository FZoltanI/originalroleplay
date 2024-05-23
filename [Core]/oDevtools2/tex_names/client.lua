local texNameState = false
local myShader
local bShowTextureUsage = false
local uiTextureIndex = 1
local m_SelectedTextureName = ""
local scx, scy = guiGetScreenSize ()
local usageInfoList = {}
KeyAutoRepeat = {}
KeyAutoRepeat.repeatDelay = 500
KeyAutoRepeat.repeatRateInitial = 100
KeyAutoRepeat.repeatRateMax = 10
KeyAutoRepeat.repeatRateChangeTime = 2700
KeyAutoRepeat.keydownInfo = {}

addEvent("onClientKeyClick")

addEventHandler("onClientResourceStart", resourceRoot, 
    function()
        local tec
        myShader, tec = dxCreateShader("tex_names/tex_names.fx", 1, 0, false, "all")
    end
)

addCommandHandler("tex", 
    function()
        if exports['oAdmin']:isPlayerDeveloper(localPlayer) then
            texNameState = not texNameState
            if texNameState then
                local syntax = exports['oCore']:getServerPrefix("green-dark", "dev", 2)    
                outputChatBox(syntax .. "Textúra nevek bekapcsolva!", 0, 255, 0, true)
                addEventHandler("onClientRender", root, renderTextureNames, true, "low")
                addEventHandler("onClientKeyClick", resourceRoot, handleKeyClicks)
                addEventHandler("onClientRender", root, KeyAutoRepeat.pulse)
                addEventHandler("onClientKey", root, KeyAutoRepeat.keyChanged)
                if m_SelectedTextureName ~= "" then
                    engineApplyShaderToWorldTexture ( myShader, m_SelectedTextureName )
                end
            else
                local syntax = exports['oCore']:getServerPrefix("red-dark", "dev", 2)    
                outputChatBox(syntax .. "Textúra nevek kikapcsolva!", 255, 0, 0, true)
                removeEventHandler("onClientRender", root, renderTextureNames)
                removeEventHandler("onClientKeyClick", resourceRoot, handleKeyClicks)
                removeEventHandler("onClientRender", root, KeyAutoRepeat.pulse)
                removeEventHandler("onClientKey", root, KeyAutoRepeat.keyChanged)
                engineRemoveShaderFromWorldTexture ( myShader, m_SelectedTextureName )
            end
        end
    end
)

function KeyAutoRepeat.pulse()
	for key,info in pairs(KeyAutoRepeat.keydownInfo) do
		local age = getTickCount () - info.downStartTime
		age = age - KeyAutoRepeat.repeatDelay
		if age > 0 then
			local ageAlpha = math.unlerpclamped( 0, age, KeyAutoRepeat.repeatRateChangeTime )
			local dynamicRate = math.lerp( KeyAutoRepeat.repeatRateInitial, ageAlpha, KeyAutoRepeat.repeatRateMax )		

			local count = math.floor(age/dynamicRate)
			if count > info.count then
				info.count = count
				triggerEvent("onClientKeyClick", resourceRoot, key)
			end
		end
	end
end

function KeyAutoRepeat.keyChanged(key,down)
	KeyAutoRepeat.keydownInfo[key] = nil
	if down then
		KeyAutoRepeat.keydownInfo[key] = { downStartTime=getTickCount (), count=0 }
		triggerEvent("onClientKeyClick", resourceRoot, key )
	end
end

function renderTextureNames()
	usageInfoList = engineGetVisibleTextureNames()
	local iXStartPos = scx - 200;
	local iYStartPos = 0;
	local iXOffset = 0;
	local iYOffset = 0;
	if bShowTextureUsage then
		for key, textureName in ipairs(usageInfoList) do
			local bSelected = textureName == m_SelectedTextureName;
			local dwColor = bSelected and tocolor(255,220,128) or tocolor(224,224,224,204)
			if bSelected then
				dxDrawText( textureName, iXStartPos + iXOffset + 1, iYStartPos + iYOffset + 1, 0, 0, tocolor(0,0,0) )
			end
			dxDrawText( textureName, iXStartPos + iXOffset, iYStartPos + iYOffset, 0, 0, dwColor )
			iYOffset = iYOffset + 15
			if iYOffset > scy - 15 then
				iYOffset = 0;
				iXOffset = iXOffset - 200;
			end
		end
	end
end

function handleKeyClicks(key)
	if key == "num_7" then
		moveCurrentTextureCaret( -1 )
	elseif key == "num_9" then
		moveCurrentTextureCaret( 1 )
	elseif key == "num_8" then
		bShowTextureUsage = not bShowTextureUsage
	elseif key == "k" then
		if m_SelectedTextureName ~= "" then
			setClipboard( m_SelectedTextureName )
            local syntax = exports['oCore']:getServerPrefix("green-dark", "dev", 2)    
			outputChatBox(syntax .. "'" .. tostring(m_SelectedTextureName) .. "' vágólapra másolva", 255,255,255,true)
		end
	end
end

function moveCurrentTextureCaret(dir)
	if #usageInfoList == 0 then
		return
	end
	
	for key, textureName in ipairs(usageInfoList) do
		if m_SelectedTextureName <= textureName then
			uiTextureIndex = key
			break
		end
	end
	
	uiTextureIndex = uiTextureIndex + dir
	uiTextureIndex = ( ( uiTextureIndex - 1 ) % #usageInfoList ) + 1
	
	engineRemoveShaderFromWorldTexture ( myShader, m_SelectedTextureName )
	m_SelectedTextureName = usageInfoList [ uiTextureIndex ]
	engineApplyShaderToWorldTexture ( myShader, m_SelectedTextureName )
end

function math.lerp(from,alpha,to)
    return from + (to-from) * alpha
end

function math.unlerp(from,pos,to)
	if ( to == from ) then
		return 1
	end
	return ( pos - from ) / ( to - from )
end

function math.clamp(low,value,high)
    return math.max(low,math.min(value,high))
end

function math.unlerpclamped(from,pos,to)
	return math.clamp(0,math.unlerp(from,pos,to),1)
end