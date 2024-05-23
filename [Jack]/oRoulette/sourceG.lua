interactionTime = 60000

local red = {1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36}
local black = {2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35}

redex = {
	[1] = true,
	[3] = true,
	[5] = true,
	[7] = true,
	[9] = true,
	[12] = true,
	[14] = true,
	[16] = true,
	[18] = true,
	[19] = true,
	[21] = true,
	[23] = true,
	[25] = true,
	[27] = true,
	[30] = true,
	[32] = true,
	[34] = true,
	[36] = true
}

blackex = {
	[2] = true,
	[4] = true,
	[6] = true,
	[8] = true,
	[10] = true,
	[11] = true,
	[13] = true,
	[15] = true,
	[17] = true,
	[20] = true,
	[22] = true,
	[24] = true,
	[26] = true,
	[28] = true,
	[29] = true,
	[31] = true,
	[33] = true,
	[35] = true
}

wheelNumbers = {
	[0] = 0,
	[32] = 1,
	[15] = 2,
	[19] = 3,
	[4] = 4,
	[21] = 5,
	[2] = 6,
	[25] = 7,
	[17] = 8,
	[34] = 9,
	[6] = 10,
	[27] = 11,
	[13] = 12,
	[36] = 13,
	[11] = 14,
	[30] = 15,
	[8] = 16,
	[23] = 17,
	[10] = 18,
	[5] = 19,
	[24] = 20,
	[16] = 21,
	[33] = 22,
	[1] = 23,
	[20] = 24,
	[14] = 25,
	[31] = 26,
	[9] = 27,
	[22] = 28,
	[18] = 29,
	[29] = 30,
	[7] = 31,
	[28] = 32,
	[12] = 33,
	[35] = 34,
	[3] = 35,
	[26] = 36
}

degPerNum = 360 / (36 + 1)

function rotateAround(angle, x, y, x2, y2)
	x2 = x2 or 0
	y2 = y2 or 0

	local theta = math.rad(angle)
	local rotatedX = x * math.cos(theta) - y * math.sin(theta) + x2
	local rotatedY = x * math.sin(theta) + y * math.cos(theta) + y2

	return rotatedX, rotatedY
end

function formatNumber(amount, stepper)
	local left, center, right = string.match(math.floor(amount), "^([^%d]*%d)(%d*)(.-)$")
	return left .. string.reverse(string.gsub(string.reverse(center), "(%d%d%d)", "%1" .. (stepper or " "))) .. right
end

function getDetailsFromName(name)
	local fieldNumbers = {}
	local fieldName = name
	local oneFieldName = name
	local priceMultipler = 1
	
	if type(name) == "table" then
		local nameLength = #name
		
		if nameLength == 1 then
			name = name[1]
			fieldName = name
			oneFieldName = name
		else
			if nameLength > 1 and nameLength <= 4 then
				local haveNumber = false
				
				for i = 1, #name do
					if not tonumber(name[i]) then
						haveNumber = true
						break
					end
				end
				
				if not haveNumber then
					if #name == 2 then
						fieldNumbers = name
						name = "split"
						fieldName = "split"
						oneFieldName = false
						priceMultipler = 17
					elseif #name == 3 then
						fieldNumbers = name
						name = "three line"
						fieldName = "three line"
						oneFieldName = false
						priceMultipler = 11
					elseif #name == 4 then
						fieldNumbers = name
						name = "corner"
						fieldName = "corner"
						oneFieldName = false
						priceMultipler = 8
					end
				end
			end
			
			if type(name) == "table" then
				if string.sub(name[1], 4, 5) == "12" and tonumber(name[2]) and tonumber(name[3]) then
					if tonumber(name[2]) > 0 then
						for i = tonumber(name[2]), tonumber(name[2]) + 2 do
							table.insert(fieldNumbers, i)
						end
						
						for i = tonumber(name[3]), tonumber(name[3]) + 2 do
							table.insert(fieldNumbers, i)
						end
						
						fieldName = "six line"
						priceMultipler = 5
						oneFieldName = false
					else
						table.insert(fieldNumbers, 0)
						
						for i = tonumber(name[3]), tonumber(name[3]) + 2 do
							table.insert(fieldNumbers, i)
						end
						
						fieldName = "corner"
						priceMultipler = 8
						oneFieldName = false
					end
				elseif string.sub(name[1], 4, 5) == "12" and tonumber(name[2]) then
					for i = tonumber(name[2]), tonumber(name[2]) + 2 do
						table.insert(fieldNumbers, i)
					end
					
					fieldName = "three line"
					priceMultipler = 11
					oneFieldName = false
				else
					name = name[1]
					fieldName = name
					oneFieldName = name
				end
			end
		end
	end
	
	if #fieldNumbers < 1 then
		if tonumber(name) then
			fieldName = "straight " .. name
			priceMultipler = 35
		elseif name == "red" then
			fieldNumbers = red
			priceMultipler = 1
		elseif name == "black" then
			fieldNumbers = black
			priceMultipler = 1
		elseif name == "even" then
			for i = 2, 36, 2 do
				table.insert(fieldNumbers, i)
			end

			priceMultipler = 1
		elseif name == "odd" then
			for i = 1, 35, 2 do
				table.insert(fieldNumbers, i)
			end

			priceMultipler = 1
		elseif string.find(name, "-") then
			local nameSplit = split(name, "-")

			for i = nameSplit[1], nameSplit[2] do
				table.insert(fieldNumbers, i)
			end

			priceMultipler = 1
		elseif string.sub(name, 1, 3) == "2to" then
			local number = tonumber(string.sub(name, -1))

			for i = 0, 33, 3 do
				table.insert(fieldNumbers, i + number)
			end

			fieldName = "2to" .. string.sub(name, -1)
			priceMultipler = 2
		elseif string.sub(name, 4, 5) == "12" then
			local number = 12 * (tonumber(string.sub(name, 1, 1)) - 1)

			for i = 1 + number, 12 + number do
				table.insert(fieldNumbers, i)
			end
			
			fieldName = string.sub(name, 1, 3) .. " 12"
			priceMultipler = 2
		else
			return false
		end
	end
	
	return fieldNumbers, fieldName, oneFieldName, priceMultipler
end