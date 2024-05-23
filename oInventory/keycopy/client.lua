function clickToPed(button,state,absoluteX,absoluteY,worldX,worldY,worldZ,clickedElement)
	if button == "right" and state == "down" then
		if isElement(clickedElement) then
			if getElementData(clickedElement,"inventory:copyPed") then
				outputChatBox(core:getServerPrefix("green-dark", "Kulcsmásolás", 3).."A másolás ára 500$. Másoláshoz dobd az NPC-re a másolni kívánt kulcsot!",255, 255, 255, true)
			end
		end
	end
end
addEventHandler("onClientClick",getRootElement(),clickToPed)