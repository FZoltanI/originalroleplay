function switchShader(id)
	if tonumber(id) then
		if id == 0 then 
			disablePalette();
		else
			enablePalette(id);
		end
	else
		disablePalette();
	end
end