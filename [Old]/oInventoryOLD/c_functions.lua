local item_images = {}

addEventHandler("onClientResourceStart", resourceRoot, function() 
    for i = 0, #items do 
        if fileExists("files/items/"..i..".png") then
            table.insert(item_images, i, dxCreateTexture("files/items/"..i..".png")) 
        else
            table.insert(item_images, i, dxCreateTexture("files/items/0.png")) 
        end
	end 
	
	item_images["83_2"] = dxCreateTexture("files/items/83_2.png")
end)

function getItemImage(itemID,value)
	value = tonumber(value)
	if (tonumber(itemID)) then
		if (itemID == 83) then
			if value == 2 then 
				itempng = itemID.."_"..value
			else
				itempng = itemID
			end
		else
			itempng = itemID
		end
        
        return item_images[itempng]
	end
	return item_images[0]
end