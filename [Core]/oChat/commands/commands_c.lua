function OOC(cmd, ...)
	if not isSpam() then
		if ... then
			local msg = table.concat({...}, " ")
			if msg:len() > 75 then return end
			triggerServerEvent("sendChatMessage", localPlayer,removeHex(msg), getNearestPlayers(localPlayer), 5)
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Szöveg]", 255, 255, 255, true)
		end
	end
end
addCommandHandler("b", OOC, false, false)
addCommandHandler("OOC", OOC, false, false)

addCommandHandler("me", function(cmd, ...)
	if not isSpam() and not isPedDead(localPlayer) then
		if ... then
			sendLocalMeAction(table.concat({...}, " "))
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Cselekvés]", 255, 255, 255, true)
		end
	end
end, false, false)

addCommandHandler("do", function(cmd, ...)
	if not isSpam() and not isPedDead(localPlayer) then
		if ... then
			sendLocalDoAction(table.concat({...}, " "))
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Történés]", 255, 255, 255, true)
		end
	end
end, false, false)

addCommandHandler("ame", function(cmd, ...)
	if not isSpam() and not isPedDead(localPlayer) then
		if ... then
			triggerServerEvent("sendChatMessage", localPlayer, removeHex(table.concat({...}, " ")), getNearestPlayers(localPlayer), 18)
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Karakterleírás]", 255, 255, 255, true)
		end
	end
end, false, false)

addCommandHandler("s", function(cmd, ...)
	if not isSpam() and not isPedDead(localPlayer) then
		if ... then
			triggerServerEvent("sendChatMessage", localPlayer, removeHex(table.concat({...}, " ")), getNearestPlayers(localPlayer, 30), 3)
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Szöveg]", 255, 255, 255, true)
		end
	end
end, false, false)

addCommandHandler("c", function(cmd, ...)
	if not isSpam() and not isPedDead(localPlayer) then
		if ... then
			triggerServerEvent("sendChatMessage", localPlayer, removeHex(table.concat({...}, " ")), getNearestPlayers(localPlayer, 10), 4)
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Szöveg]", 255, 255, 255, true)
		end
	end
end, false, false)

addCommandHandler("asay", function(cmd, ...)
	if not isSpam() and getElementData(localPlayer, "user:admin") >= 2 then
		if ... then
			triggerServerEvent("sendChatMessage", localPlayer, removeHex(table.concat({...}, " ")), getRootElement(), 8)
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Szöveg]", 255, 255, 255, true)
		end
	end
end)

addCommandHandler("as", function(cmd, ...)
	if not isSpam() and getElementData(localPlayer, "user:admin") >= 1 or getElementData(localPlayer, "user:idgAs") then
		if ... then
			triggerServerEvent("sendChatMessage", localPlayer, removeHex(table.concat({...}, " ")), getASORIDG(1), 9)
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Szöveg]", 255, 255, 255, true)
		end
	end
end)

addCommandHandler("a", function(cmd, ...)
	if not isSpam() and getElementData(localPlayer, "user:admin") >= 2 then
		if ... then
			triggerServerEvent("sendChatMessage", localPlayer, removeHex(table.concat({...}, " ")), getAdminPlayers(2), 10)
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Szöveg]", 255, 255, 255, true)
		end
	end
end)

function try(cmd, ...)
	if not isSpam() and not isPedDead(localPlayer) then
		if getElementData(localPlayer,"cuff:cuffed") then return outputChatBox(core:getServerPrefix("red-dark", "Rádió", 2).."Megbilincselve nem megpróbálozgatsz!", 255, 255, 255, true) end

		if ... then
			local success = math.random(2)
			triggerServerEvent("sendChatMessage", localPlayer, removeHex(table.concat({...}, " ")), getNearestPlayers(localPlayer), math.random(12, 13))
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Szöveg]", 255, 255, 255, true)
		end
	end
end
addCommandHandler("try", try)
addCommandHandler("megprobal", try)
addCommandHandler("megpróbál", try)

function megaphoneMessage(cmd, ...)
	if not isSpam() then
		if ... then
			local msg = table.concat({...}, " ")
			if not (msg:sub(0, 1) == "/") then
				if isPedDead(localPlayer) then return end

				local occupiedVeh = getPedOccupiedVehicle(localPlayer)

				if occupiedVeh then
					if getPedOccupiedVehicleSeat(localPlayer) <= 1 then
						if getElementData(occupiedVeh, "veh:isFactionVehice") == 1 then
							if exports.oDashboard:getFactionType(getElementData(occupiedVeh, "veh:owner") or 0) <= 3 then
								triggerServerEvent("sendChatMessage", localPlayer, removeHex(msg), getNearestPlayers(localPlayer, 35), 17)
							end
						end
					end
				end
			end
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Szöveg]", 255, 255, 255, true)
		end
	end
end
addCommandHandler("megaphone", megaphoneMessage)
addCommandHandler("m", megaphoneMessage)
