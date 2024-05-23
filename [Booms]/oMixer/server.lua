local core = exports.oCore
local serverColor = {core:getServerColor()}
local dutymarkerPos = {
	--- x, y, z, dim, int
	{2087.7182617188, -1687.5612792969, 13.539081573486, 0, 0},
}

local jobmarkerPos = {
	--- x, y, z, dim, int
	{2089.6630859375, -1674.9818115234, 13.539081573486, 0, 0},
}

for i,v in ipairs(jobmarkerPos) do
	local marker = createMarker( v[1], v[2], v[3] - 1, "cylinder", 2, serverColor[2], serverColor[3], serverColor[4], 155)
	setElementDimension ( marker, v[4])
	setElementInterior( marker, v[5])
	setElementData(marker, "mixer:jobmarker", true)
end

for i,v in ipairs(dutymarkerPos) do
	local marker = createMarker( v[1], v[2], v[3] - 1, "cylinder", 2, serverColor[2], serverColor[3], serverColor[4], 155)
	setElementDimension ( marker, v[4])
	setElementInterior( marker, v[5])
	setElementData(marker, "mixer:dutymarker", true)
end

for i,v in ipairs(getElementsByType("player")) do
	setElementData(v, "mixer:job", true)
	setElementData(v, "mixer:duty", false)
end

addEvent("Mixer:DutyChange", true)
addEventHandler("Mixer:DutyChange", root, 
	function (thePlayer, value)
		setElementData(thePlayer, "mixer:duty", value)
	end
)