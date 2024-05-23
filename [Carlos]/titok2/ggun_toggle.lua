function toggleGGun(player)
	local on = not exports.titok:isGravityGunEnabled(player)
	exports.titok:togglePlayerGravityGun(player,on)
	outputChatBox("gravity gun "..(on and "on" or "off"),player)
end
addCommandHandler("ggun",toggleGGun)
