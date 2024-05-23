function updateTime()
	local realtime = getRealTime()
	hour = realtime.hour + 4
	minute = 1
	
	if hour >= 24 then
		hour = hour - 24
	elseif hour < 0 then
		hour = hour + 24
	end

	minute = realtime.minute
	setTime(hour, minute)

	nextupdate = (60-realtime.second) * 1000
	setMinuteDuration( nextupdate )
	setTimer( setMinuteDuration, nextupdate + 5, 1, 60000 )
end
addEventHandler("onResourceStart", getResourceRootElement(), updateTime )
setTimer( updateTime, 120000, 0 )