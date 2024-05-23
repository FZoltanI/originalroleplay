local sx,sy = guiGetScreenSize()
local font = exports.oFont:getFont("condensed", 15)
local countdownTick,active = getTickCount(),false
local color, r, g, b = exports.oCore:getServerColor()
local stopTimer;

function renderStopBanner()
    time = secondsToTimeDesc( getElementData(resourceRoot,"countdown:timeleft") )

    if active then 
        r,g,b = interpolateBetween(r,g,b, 250, 67, 57, (getTickCount() - countdownTick)/10000, "SineCurve")
    end 

    dxDrawText("A szerver hamarosan leáll / újraindúl, kérünk mindenkit hogy tevékenységét a megadott időkorláton belül fejezze be!",sx*0.5 - 1,20 + 1,_,_,tocolor(0,0,0,240),0.0005*sx, font, "center", "center",false,false,false,true)
    dxDrawText("A szerver hamarosan leáll / újraindúl, kérünk mindenkit hogy tevékenységét a megadott időkorláton belül fejezze be!",sx*0.5,20,_,_,tocolor(r,g,b,240),0.0005*sx, font, "center", "center",false,false,false,true)

    dxDrawText(time,sx*0.5 - 1,50 + 1,_,_,tocolor(0,0,0,240),0.0005*sx, font, "center", "center",false,false,false,true)
    dxDrawText(time,sx*0.5,50,_,_,tocolor(r,g,b,240),0.0005*sx, font, "center", "center",false,false,false,true)
end


addEvent("stopServerRequest",true)
addEventHandler("stopServerRequest",root,function()
    createRender("banner", renderStopBanner)
    outputChatBox(exports.oCore:getServerPrefix("red-dark", "Szerver", 3).."A szerver a megadott idő lejártával leáll és újraindúl!", 255, 255, 255, true)
    exports.oInfobox:outputInfoBox("Üzeneted érkezett a szervertől, részletek a chatboxban!", "warning")

end)

addEvent("animRequest",true)
addEventHandler("animRequest",root,function(state)
    if state then 
        countdownTick,active = getTickCount(),true
    else 
        color,r,g,b = exports.oCore:getServerColor()
        countdownTick,active = getTickCount(),false
    end
end)

addEvent("stopRender",true)
addEventHandler("stopRender",root,function()
    destroyRender("banner")
end)

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

        if sec == 0 then 
            if min < 10 then 
                stringmin = "0"..min..":00"
            else 
                stringmin = min..":00"
            end 
        end


		if day > 0 then table.insert( results, day .. ( day == 1 and "" or "" ) ) end
		if hou > 0 then table.insert( results, hou .. ( hou == 1 and "" or "" ) ) end
		if min > 0 then table.insert( results, stringmin .. ( min == 1 and "" or "" ) ) end
		if sec > 0 then table.insert( results, stringsec .. ( sec == 1 and "" or "" ) ) end
		
		return string.reverse ( table.concat ( results, ", " ):reverse():gsub(" ,", ":", 1 ) )
	end
	return ""
end