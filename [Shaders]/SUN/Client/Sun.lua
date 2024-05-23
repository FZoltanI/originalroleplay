
Sun = {}

function Sun:constructor(parent)
	self.parent = parent
	self.player = getLocalPlayer()
	
	self.isDebugMode = "true"
	
	self.x = 0
	self.y = 0
	self.z = 0
	self.rx = 0
	self.ry = 0
	self.rz = 0
	self.height = 100
	
	self.rzOffset = 0
	self.heightCurrentOffset = 0
	self.heightMinOffset = 100
	self.heightMaxOffset = 250
	self.heightOffsetDirection = "up"

	self.m_Update = function() self:update() end
	addEventHandler("onClientRender", root, self.m_Update)
	
	self.m_ToggleTestMode = function() self:toggleTestMode() end
	bindKey("N", "down", self.m_ToggleTestMode)
end

function Sun:toggleTestMode()
	if (self.isDebugMode == "true") then
		self.isDebugMode = "false"
	elseif (self.isDebugMode == "false") then
		self.isDebugMode = "true"
	end
end

function Sun:update()
	self.px, self.py, self.pz = getElementPosition(self.player)
	self.x, self.y, self.z = getAttachedPosition(self.px, self.py, self.pz, self.rx, self.ry, self.rz + self.rzOffset, 1500, 0, self.height + self.heightCurrentOffset)
	
	if (self.isDebugMode == "true") then
		self.rzOffset = self.rzOffset + 0.05
		
		if (self.rzOffset > 360) then
			self.rzOffset = 0
		end
		
		if (self.heightOffsetDirection == "up") then
			if (self.heightCurrentOffset < self.heightMaxOffset) then
				self.heightCurrentOffset = self.heightCurrentOffset + 0.1
			else
				self.heightOffsetDirection = "down"
			end
		elseif (self.heightOffsetDirection == "down") then
			if (self.heightCurrentOffset > self.heightMinOffset) then
				self.heightCurrentOffset = self.heightCurrentOffset - 0.1
			else
				self.heightOffsetDirection = "up"
			end		
		end
		
		dxDrawLine3D(self.px, self.py, self.pz, self.x, self.y, self.z, tocolor(255, 255, 0, 255), 4, true)
	end
	
	--dxDrawLine3D(self.px, self.py, self.pz, self.x, self.y, self.z, tocolor(255, 255, 0, 255), 4, true)
end

function Sun:getSunPosition()
	return self.x, self.y, self.z
end

function Sun:destructor()	
	removeEventHandler("onClientRender", root, self.m_Update)

end