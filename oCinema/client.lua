local screenWidth, screenHeight = guiGetScreenSize()
 
local shader_cinema
local cinema_tex_name = "lamwhite"
local screenTexName = "CJ_AIRP_S_1"

local gUVScale = {-0.2, 0.4}
local gUVPosition = {0.2, 0.1}
local gUVAnim = {0, 0}
local gUVRotAngle = math.rad( 0 )
local gColorMulti = {0.61, 0.61, 0.61, 1}
local gVertexColor = false

local screenW, sreenH = 1280, 720

local cinemaCol = createColCuboid(688.40966796875, -1373.2611083984, 24.5, 18.5, 15.5, 7)

local monitor = createObject(2789, 692.34698486328, -1357.580078125, 28.414087295532, 0, 0, 180)
local monitorTarget = dxCreateRenderTarget( screenW, sreenH )

local myShader_raw_data = [[
	texture tex;
	technique replace {
		pass P0 {
			Texture[0] = tex;
		}
	}
]]

myRenderTarget = dxCreateRenderTarget( 1920, 1080, true) 
local font = exports.oFont
local core = exports.oCore
local color, r, g, b = core:getServerColor()
local fonts = {
	["bebasneue"] = font:getFont("bebasneue", 80),
}

local cinemaPrice = 150

local exitcol = createColTube(696.8076171875, -1358.9655761719, 26.014087295532, 1, 2)
local entercol = createColTube(692.03942871094, -1355.6325683594, 26.014087295532, 1, 2)

local ped = createPed(189, 689.69934082031, -1356.3299560547, 26.414087295532, 270)
setElementData(ped, "ped:name", "Joe Miller")

local buttonType = "enter"
function renderButton()
	if buttonType == "enter" then 
		core:dxDrawButton(screenWidth*0.45, screenHeight*0.8, screenWidth*0.1, screenHeight*0.05, r, g, b, 200, "Belépés (150$)", tocolor(255, 255, 255, 255), 1, font:getFont("condensed", 10), true, tocolor(0, 0, 0, 200))
	else
		core:dxDrawButton(screenWidth*0.45, screenHeight*0.8, screenWidth*0.1, screenHeight*0.05, 224, 65, 65, 200, "Kilépés", tocolor(255, 255, 255, 255), 1, font:getFont("condensed", 10), true, tocolor(0, 0, 0, 200))
	end
end

function keyButton(key, state) 
	if key == "mouse1" and state then 
		if buttonType == "enter" then 
			if core:isInSlot(screenWidth*0.45, screenHeight*0.8, screenWidth*0.1, screenHeight*0.05) then 
				if getElementData(resourceRoot, "cinema:state") == true then
					if getElementData(localPlayer, "char:money") >= 150 then 
						setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money") - 150)
						setElementPosition(localPlayer, 698.74816894531, -1358.8454589844, 26.414087295532)
					else
						exports.oInfobox:outputInfoBox("Nincs elegendő pénzed!", "error")
					end
				else
					exports.oInfobox:outputInfoBox("Jelenleg nincs nyitva a mozi!", "error")
				end
			end
		else
			if core:isInSlot(screenWidth*0.45, screenHeight*0.8, screenWidth*0.1, screenHeight*0.05) then 
				setElementPosition(localPlayer,  697.16418457031, -1356.4372558594, 26.414087295532)
			end
		end
	end
end

addEventHandler("onClientColShapeHit", root, function(player, mdim)
	if player == localPlayer and mdim then 
		if source == entercol then 
			addEventHandler("onClientRender", root, renderButton)
			addEventHandler("onClientKey", root, keyButton)
			buttonType = "enter"
		elseif source == exitcol then 
			addEventHandler("onClientRender", root, renderButton)
			addEventHandler("onClientKey", root, keyButton)
			buttonType = "exit"
		end
	end
end)

addEventHandler("onClientColShapeLeave", root, function(player, mdim)
	if player == localPlayer and mdim then 
		if source == entercol then 
			removeEventHandler("onClientRender", root, renderButton)
			removeEventHandler("onClientKey", root, keyButton)
		elseif source == exitcol then 
			removeEventHandler("onClientRender", root, renderButton)
			removeEventHandler("onClientKey", root, keyButton)
		end
	end
end)

function renderMonitor()
    dxSetRenderTarget( myRenderTarget, true)                
		local movies = getElementData(resourceRoot, "cinema:movies") or false

		dxDrawText("Original Cinema", 50, 0, 200, 200, tocolor(r, g, b), 1, fonts["bebasneue"], "left", "center")
		dxDrawText("Műsor", 50, 0, 200, 380, tocolor(255, 255, 255), 0.5, fonts["bebasneue"], "left", "center")

		if (movies == false) or (movies == "0") then 
			dxDrawText("Jelenleg nincs tervezett vetítés!", 0, 0, 1920, 1080, tocolor(245, 66, 66), 1, fonts["bebasneue"], "center", "center")
		else
			local start = 300
			for k, v in ipairs(fromJSON(movies)) do 
				dxDrawText(v[1], 100, start, _, _, tocolor(255, 255, 255), 0.6, fonts["bebasneue"])
				dxDrawText(v[2], 1400, start, 1820, 1080, tocolor(255, 255, 255), 0.6, fonts["bebasneue"], "right")
				start = start + 100
			end

			dxDrawText("Belépő: "..color..cinemaPrice.."$", 0, 0, 1900, 1060, tocolor(255, 255, 255), 0.5, fonts["bebasneue"], "right", "bottom", false, false, false, true)
		end
    dxSetRenderTarget()     

    local myShader = dxCreateShader(myShader_raw_data) 
	if isElement(myShader) then
		if isElement(myRenderTarget) then
			dxSetShaderValue(myShader, "tex", myRenderTarget)
			engineApplyShaderToWorldTexture(myShader, screenTexName)
		end
	end
end

addEventHandler("onClientElementStreamIn", resourceRoot, function()
	if source == monitor then  
		addEventHandler("onClientRender",root, renderMonitor)
	end
end)

addEventHandler("onClientElementStreamOut", resourceRoot, function()
	if source == monitor then  
		removeEventHandler("onClientRender",root, renderMonitor)
	end
end)

function cinema (vid,currtime)
	local RenderTarget = dxCreateRenderTarget( screenW, sreenH )
	if getElementData(getLocalPlayer(), "cin:browser") then
		destroyElement(getElementData(getLocalPlayer(), "cin:browser"))
		webBrowser = createBrowser(screenW, sreenH, false, false)
		setElementData(getLocalPlayer(),"cin:browser", webBrowser)
	else
		webBrowser = createBrowser(screenW, sreenH, false, false)
		setElementData(getLocalPlayer(),"cin:browser", webBrowser)
	end
	addEventHandler("onClientBrowserCreated", webBrowser, 
		function()
			vid = vid:gsub("v=", "")
			loadBrowserURL(webBrowser, "https://www.youtube.com/embed/"..vid.."?rel=0&autoplay=1&mute=0&start=".. math.floor(currtime/1000))
			addEventHandler ( "onClientRender", getRootElement(), 
			function ()
				dxSetRenderTarget( RenderTarget )
					if isBrowserLoading(webBrowser) then
						dxDrawImage(0, 0, screenW, sreenH, "background.png")
					else
						dxDrawImage(0, 0, screenW, sreenH, webBrowser)
					end
				dxSetRenderTarget()


				if isElementWithinColShape(localPlayer, cinemaCol) then
					local px, py, pz = getElementPosition(localPlayer)
					local volume = 1 - getDistanceBetweenPoints3D(px, py, pz, 706.27459716797, -1367.0148925781, 26.414087295532) / 90
					setBrowserVolume (getElementData(getLocalPlayer(), "cin:browser"), volume)
				else
					setBrowserVolume (getElementData(getLocalPlayer(), "cin:browser"), 0)
				end
			end )
			shader_cinema, tec = dxCreateShader ( "UVMod.fx" )
			if not shader_cinema then
				destroyElement( texture )
				return
			elseif not RenderTarget then
				destroyElement ( shader_cinema )
				tec = nil
				return
			else
				dxSetShaderValue ( shader_cinema, "gUVAnim", gUVAnim)
				--dxSetShaderValue ( shader_cinema, "gUVScale", gUVScale)
				--dxSetShaderValue ( shader_cinema, "gUVPosition", gUVPosition)
				dxSetShaderValue ( shader_cinema, "gUVRotAngle", gUVRotAngle)
				dxSetShaderValue ( shader_cinema, "gColorMulti", gColorMulti)
				dxSetShaderValue ( shader_cinema, "gVertexColor", gVertexColor)

				engineApplyShaderToWorldTexture ( shader_cinema, cinema_tex_name )	
				dxSetShaderValue ( shader_cinema, "CUSTOMTEX0", RenderTarget )
			end
		end
	)
end
addEvent( "onCinema", true )
addEventHandler( "onCinema", localPlayer, cinema )


local oppened = 0
function openBrowser()
	SearchWebBrowser = guiCreateBrowser(screenWidth/2 - 300, 300, 600, 600, false, false, false)

	theBrowser = guiGetBrowser(SearchWebBrowser)
	addEventHandler("onClientBrowserCreated", theBrowser, 
		function()
			loadBrowserURL(theBrowser, "http://youtube.com")
			addEventHandler("onClientRender", root, renderSearchPanel)
			setBrowserProperty ( theBrowser, "mobile", 1 )
			oppened = 1
		end
	)
end
addEvent( "onOpenBrowser", true )
addEventHandler( "onOpenBrowser", localPlayer, openBrowser )

function accessCheck()
 	triggerServerEvent("checkACL", resourceRoot, getLocalPlayer())
end
addCommandHandler("startcinema",accessCheck)

function renderSearchPanel ()
	dxDrawRectangle(screenWidth/2 - 350, 200, 700, 730, tocolor(30, 30, 30, 150))
	core:dxDrawButton(screenWidth/2 - 300, 220, 295, 50, 151, 206,104,150, "Vetítés kezédes", tocolor(255, 255, 255), 1, "default-bold", true, tocolor(0, 0, 0, 100))
	core:dxDrawButton(screenWidth/2 - 300 + 305, 220, 295, 50, 227,0,14,150, "Kilépés", tocolor(255, 255, 255), 1, "default-bold", true, tocolor(0, 0, 0, 100))
end
 
function OnClick ( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
	if button == "left" then
		if state == "up" then
			if oppened == 1 then
				if core:isInSlot(screenWidth/2 - 300, 220, 295, 50) then
					if string.find(tostring(getBrowserURL ( theBrowser )), "?v=") then
	  					triggerServerEvent ( "onStartVideo", resourceRoot, string.sub(tostring(getBrowserURL ( theBrowser )), 31) )
						outputChatBox("#97CE68[CINEMA]#FFFFFF Cinema starting...", 255,255,255,true)
					else
						outputChatBox("#E3000E[CINEMA]#FFFFFF Video not found...", 255,255,255,true)
					end
				elseif core:isInSlot(screenWidth/2 - 300 + 305, 220, 295, 50) then
					removeEventHandler("onClientRender", root, renderSearchPanel)
					destroyElement(SearchWebBrowser)
					oppened = 0
				end
			end
		end
	end
end
addEventHandler ( "onClientClick", getRootElement(), OnClick )