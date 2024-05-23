--------------------------------
-- Switch effect on or off
--------------------------------
function switchShader( bOn )
	if bOn then
		enableRadialBlur()
	else
		disableRadialBlur()
	end
end