local fonts = {}

function getFont(fontname, size, bold, quality)
	if fontname and size then
		if not bold then bold = false end
		if not quality then quality = "proof" end
		local fontstr = fontname..size..tostring(bold)..quality
		local font = fonts[fontstr]
		if font then
			return font
		end
		
		if fonts[fontstr] then 
			return fonts[fontstr]
		else
			local tick = getTickCount()
			local font = dxCreateFont("fonts/"..fontname..".ttf", size, bold, quality)
			fonts[fontstr] = font
			print("Created font: '"..fontname.."' Size: "..size.." in "..getTickCount()-tick.."ms!")
			return font
		end
	end
end