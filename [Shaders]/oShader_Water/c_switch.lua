--------------------------------
-- Switch effect on or off
--------------------------------
function switchShader( wrOn )
	if (wrOn) then
		enableWaterRef()
	else
		disableWaterRef()
	end
end
--*switchWaterRef(true)