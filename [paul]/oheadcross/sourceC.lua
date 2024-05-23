local value = {}
value["disabled"] = nil;

function headCursorMove(_, _, _, _, x, y, z)
    if not value["disabled"] then
        setPedLookAt(localPlayer, x,y,z)
    end
end
addEventHandler("onClientCursorMove", root, headCursorMove)

function toggleHeadMove()
	h,r,g,b = exports["ocore"]:getServerColor()
	serverName = exports["ocore"]:getServerName()
    value["disabled"] = not value["disabled"]
    if not value["disabled"] then
        outputChatBox(h.."["..serverName.."] #ffffffSikeresen bekapcsoltad a fejmozgatást!", 246,137,52,true)
    else
        outputChatBox(h.."["..serverName.."] #ffffffSikeresen kikapcsolatd a fejmozgatást!", 246,137,52,true)
    end
end
addCommandHandler("togglehead", toggleHeadMove)
addCommandHandler("toghead", toggleHeadMove)
addCommandHandler("headmove", toggleHeadMove)

if not xmlLoadFile("save.xml") then
	local posF = xmlCreateFile("save.xml", "root")
	local mainC2 = xmlCreateChild(posF, "data")
	xmlNodeSetValue(xmlCreateChild(mainC2, "headmovestate", 0), 0)
	xmlSaveFile(posF)
else
	local posF = xmlLoadFile("save.xml")
	local mainC2 = xmlFindChild(posF, "data", 0)
	local save = tonumber(xmlNodeGetValue(xmlFindChild(mainC2, "headmovestate", 0)))
	if save == 1 then
        value["disabled"] = true
    else
        value["disabled"] = false
	end
end


function savePos()
	local posF = xmlLoadFile("save.xml")
	if posF then
		local mainC2 = xmlFindChild(posF, "data", 0)
		if value["disabled"] then
			xmlNodeSetValue(xmlFindChild(mainC2, "headmovestate", 0), 1)
		else
            xmlNodeSetValue(xmlFindChild(mainC2, "headmovestate", 0), 0)
		end
		xmlSaveFile(posF)
	end
end
addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()), savePos)
addEventHandler("onClientPlayerQuit", getRootElement(), savePos)
