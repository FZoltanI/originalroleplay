addEvent("switchHdTextures", true);
addEventHandler("switchHdTextures", root, function(state)
	if state then
		enableDetail();
	else
		disableDetail();
	end
end);

function switchShader(state)
	if state then
		enableDetail();
	else
		disableDetail();
	end
end