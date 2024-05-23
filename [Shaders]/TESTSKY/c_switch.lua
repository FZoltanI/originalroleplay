--
-- c_switch.lua
--

----------------------------------------------------------------
----------------------------------------------------------------
-- Effect switching on and off
--
--	To switch on:
--			triggerEvent( "switchSkyAlt", root, true )
--
--	To switch off:
--			triggerEvent( "switchSkyAlt", root, false )
--
----------------------------------------------------------------
----------------------------------------------------------------

--------------------------------
-- onClientResourceStart
-- Auto switch on at start
--------------------------------
addEventHandler( "onClientResourceStart", getResourceRootElement( getThisResource()),
	function()
		outputDebugString('/sSkyAlt to switch the effect')
		triggerEvent( "switchSkyAlt", resourceRoot, true )
		addCommandHandler( "sSkyAlt",
			function()
				triggerEvent( "switchSkyAlt", resourceRoot, not salEffectEnabled )
			end
		)
	end
)


--------------------------------
-- Switch effect on or off
--------------------------------
function switchSkyAlt( sbaOn )
	outputDebugString( "switchSkyAlt: " .. tostring(sbaOn) )
	if sbaOn then
		startShaderResource()
	else
		stopShaderResource()
	end
end

addEvent( "switchSkyAlt", true )
addEventHandler( "switchSkyAlt", resourceRoot, switchSkyAlt )

--------------------------------
-- onClientResourceStop
-- Stop the resource
--------------------------------
addEventHandler( "onClientResourceStop", getResourceRootElement( getThisResource()),stopShaderResource)
