--
-- c_switch.lua
--

----------------------------------------------------------------
----------------------------------------------------------------
-- Effect switching on and off
--
--	To switch on:
--			triggerEvent( "switchWaterRef", root, 4 )
--
--	To switch off:
--			triggerEvent( "switchWaterRef", root, 0 )
--
----------------------------------------------------------------
----------------------------------------------------------------

--------------------------------
-- onClientResourceStart
--		Auto switch on at start
--------------------------------
addEventHandler( "onClientResourceStart", getResourceRootElement( getThisResource()),
	function()
		if not isMTAUpToDate() then outputChatBox('Water Refract: You need to update your MTA nightly client',255,0,0) return end
		triggerEvent( "switchWaterRef", resourceRoot, true)
		addCommandHandler( "sWaterRef",
			function()
				triggerEvent( "switchWaterRef", resourceRoot, not wrEffectEnabled)
			end
		)
	end
)


--------------------------------
-- Switch effect on or off
--------------------------------
function switchWaterRef( wrOn )
	outputDebugString( "switchWaterRef: " .. tostring(wrOn) )
	if (wrOn) then
		enableWaterRef()
	else
		disableWaterRef()
	end
end

addEvent( "switchWaterRef", true )
addEventHandler( "switchWaterRef", resourceRoot, switchWaterRef )







