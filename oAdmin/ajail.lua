local sx,sy = guiGetScreenSize(  )
local myX, myY = 1600, 900

local h,r,g,b = exports["oCore"]:getServerColor()

local admin = "n/a"
local reason = "n/a"
local time = 0

local unjailtimer

local font = exports.oFont:getFont("condensed",11)
local core = exports.oCore

function renderJail()
	shadowedText("Indok: "..core:getServerColor()..reason,sx*0.75,sy*0.885,sx*0.75+sx*0.24,sy*0.885+sy*0.03,tocolor(255,255,255,255),1/myX*sx,font,"right","center")
	shadowedText("Admin: "..core:getServerColor()..admin,sx*0.75,sy*0.91,sx*0.75+sx*0.24,sy*0.91+sy*0.03,tocolor(255,255,255,255),1/myX*sx,font,"right","center")
	shadowedText("Idő: "..core:getServerColor()..tostring(time).." #ffffffperc",sx*0.75,sy*0.935,sx*0.75+sx*0.24,sy*0.935+sy*0.03,tocolor(255,255,255,255),1/myX*sx,font,"right","center")
end

addEventHandler("onClientElementDataChange", root, function(key, old, new)
	if source == localPlayer then 
		if key == "adminJail.IsAdminJail" then 
			if new then 
				admin = getElementData(localPlayer, "adminJail.Admin")
				reason = getElementData(localPlayer, "adminJail.Reason")
				time = tonumber(getElementData(localPlayer, "adminJail.Time"))
				addEventHandler("onClientRender",root,renderJail)

				unjailtimer = setTimer(
					function()
						time = time - 1 
						triggerServerEvent("savePlayerAdminJailTime", root, time)

						if time == 0 then 
							triggerServerEvent("playerRemoveFromAdminJail", root, localPlayer)
							removeFromJail()
						end
					end,1000*60,time)
			else
				removeFromJail()
			end
		end
	end
end)

addCommandHandler("jailed",function()
	if hasPermission(localPlayer,"jailed") then 
		players = getElementsByType("player")
		count = 0
		for k,v in pairs(players) do 
			if getElementData(v,"adminJail.IsAdminJail") then 
				count = count + 1
				outputChatBox(h.."[Jailed]: #ffffff"..getElementData(v,"char:name").." Admin: "..h..getElementData(v, "adminJail.Admin").."#ffffff Indok: "..h..getElementData(v, "adminJail.Reason").."#ffffff Idő: "..h..tonumber(getElementData(v, "adminJail.Time")).."#ffffff perc",255,255,255,true)
			end
		end
		if count == 0 then 
			outputChatBox(h.."[Jailed]: #ffffff".."Jelenleg egy aktív játékos sincs adminisztrátori börtönben.", 255, 255, 255, true)
		end
	end
end)

addEvent("showAjailInfos", true)
addEventHandler("showAjailInfos", localPlayer, function()
	--outputChatBox("client")
	admin = getElementData(localPlayer, "adminJail.Admin")
	reason = getElementData(localPlayer, "adminJail.Reason")
	time = tonumber(getElementData(localPlayer, "adminJail.Time"))
	addEventHandler("onClientRender",root,renderJail)

	unjailtimer = setTimer(
		function()
			time = time - 1 
			triggerServerEvent("savePlayerAdminJailTime", root, time)

			if time == 0 then 
				triggerServerEvent("playerRemoveFromAdminJail", root, localPlayer)
				removeFromJail()
			end
		end,1000*60,time)
end)

function removeFromJail()
	admin = "n/a"
	reason = "n/a"
	time = 0
	removeEventHandler("onClientRender",root,renderJail)	

	if isTimer(unjailtimer) then 
		killTimer(unjailtimer)
	end
end 

addEvent("removePlayerAdminJail.Client",true)
addEventHandler("removePlayerAdminJail.Client",root,removeFromJail)

addEventHandler("onClientResourceStop",resourceRoot,
	function()
		if getElementData(localPlayer,"adminJail.IsAdminJail") then 
			triggerServerEvent("savePlayerAdminJailTime",root,time)
		end
	end 
)

function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, false, true)
end