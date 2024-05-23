function startVideo(videoID)
	setElementData(root,"cin:startTime", getTickCount())
	setElementData(root,"cin:vid", videoID)
	local players = getElementsByType ( "player" ) -- get a table of all the players in the server
	for theKey,thePlayer in ipairs(players) do -- use a generic for loop to step through each player
   		triggerClientEvent ( thePlayer, "onCinema", thePlayer, getElementData(root,"cin:vid"),getTickCount() - getElementData(root,"cin:startTime"))
	end
end
addEvent( "onStartVideo", true )
addEventHandler( "onStartVideo", resourceRoot, startVideo )

function startVideoJoin()
    triggerClientEvent ( source, "onCinema", source, getElementData(root,"cin:vid"),getTickCount() - getElementData(root,"cin:startTime"))
end
addEventHandler ( "onPlayerJoin", getRootElement(), startVideoJoin)

function aclChecker(player, acl )
	local account = getPlayerAccount ( player )
	if ( isGuestAccount ( account ) ) then
		return false
	end
        return isObjectInACLGroup ( "user."..getAccountName ( account ), aclGetGroup ( acl ) )
end

function checkAccess(thePlayer)
 	if getElementData(thePlayer, "user:admin") >= 9 then
  		triggerClientEvent ( thePlayer, "onOpenBrowser", thePlayer)
 	end
end
addEvent( "checkACL", true )
addEventHandler( "checkACL", resourceRoot, checkAccess )

addCommandHandler("setmovieplan", function(player, cmd, ...)
	if getElementData(player, "user:admin") >= 9 then 
		films = table.concat({...}, " ")

		setElementData(resourceRoot, "cinema:movies", films)
	end
end)

addCommandHandler("setcinemastate", function(player, cmd, ...)
	if getElementData(player, "user:admin") >= 9 then 
		setElementData(resourceRoot, "cinema:state", not getElementData(resourceRoot, "cinema:state"))

		if getElementData(resourceRoot, "cinema:state") then 
			triggerClientEvent("sendMessageToAdmins", getRootElement(), player, "megnyitotta a mozit.")
		else
			triggerClientEvent("sendMessageToAdmins", getRootElement(), player, "lezárta a mozit.")
		end
	end
end)