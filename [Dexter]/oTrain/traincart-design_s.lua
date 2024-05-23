
local validElementTypes = {
	object = true,
	vehicle = true,
	ped = true,
	marker = true,
	pickup = true
}





--[[
	Remove not required attributes to reduce transfer data.
]]
local notRequiredAttributes = {
	"id",
	"doublesided",
	"interior",
	"breakable",
	"dimension",
	"posX",
	"posY",
	"posZ",
	"rotX",
	"rotY",
	"rotZ",
	"frozen"
}

local hex2rgb = function (hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

local hex2rgba = function (hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6)), tonumber("0x"..hex:sub(7,8))
end

function loadTrainCartDesigns ()
	local xml = xmlLoadFile ("traincart-designs.xml",true)
	local trainNodes = xmlNodeGetChildren (xml)
	
	local trainsData = {}
	
	for trainIndex = 1, #trainNodes do
		local trainNode = trainNodes[trainIndex]
		local trainConfig = xmlNodeGetAttributes ( trainNode )  
		local trainData = {
			model = trainConfig.model,
			config = trainsData,
			trainCarts = {}
		}
		
		trainsData[#trainsData + 1] = trainData
		
		
		
		local trainCartNodes = xmlNodeGetChildren (trainNode)
		for trainCartIndex = 1, #trainCartNodes do
			local trainCartNode = trainCartNodes[trainCartIndex]
			local trainCartConfig = xmlNodeGetAttributes ( trainCartNode )
			
			local trainCartData = {
				config = trainCartConfig,
				model = trainCartConfig.model,
				elements = {}
			}
			
			local trainCarts = trainData.trainCarts
			trainCarts[trainCartIndex] = trainCartData
			
			local dataFormat = trainCartConfig.format 
			if not dataFormat then -- xml
				local trainCartElements = xmlNodeGetChildren (trainCartNode)
				local elements = trainCartData.elements
				for trainCartElementIndex = 1, #trainCartElements do
					local trainCartElement = trainCartElements[trainCartElementIndex]
					local elementData = xmlNodeGetAttributes ( trainCartElement )
					
					local elementType = xmlNodeGetName (trainCartElement)
					if validElementTypes[elementType] then
						
						elementData.elementType = elementType
						elementData.offset = {elementData.posX, elementData.posY, elementData.posZ, elementData.rotX, elementData.rotY, elementData.rotZ}
						elementData.model = elementData.model
						
						local color = elementData.color
						if color then
							if elementType == "marker" then
								local r, g, b, a = hex2rgba(color)
								if r then
									elementData.r, elementData.g, elementData.b, elementData.a = r, g, b, a
								end
							elseif elementType == "vehicle" then
								elementData.color = split(color, ",")
								if not elementData.color[1] or not elementData.color[2] then
									elementData.color = {38,55,57,245,245,245,0,0,0,0,0,0}
								end
							end
						end
						
						
						for i=1, #notRequiredAttributes do
							local attribute = notRequiredAttributes[i]
							if elementData[attribute] then
								elementData[attribute] = nil
							end
						end
						
						elements[#elements + 1] = elementData
					end
				end
			elseif 	dataFormat == "lua" then
				
				local value = xmlNodeGetAttribute ( trainCartNode, "value" )
				if value and value ~= "" then
					trainCartData.elements = trainCartLuaDesign[value]
				end
			elseif 	dataFormat == "json" then
			
			end
		end
	end
	
	xmlUnloadFile (xml)
	return trainsData
end

trainCartLuaDesign = {
	["rhino"] = {
		{["elementType"]="vehicle",["offset"]={0,0,0,0,0,0},["model"] = 432}
	},
	["barracks"] = {
		{["elementType"]="vehicle",["offset"]={0,0,0.41,0,0,0},["model"] = 433}
	},
	["patriot"] = {
		{["elementType"]="vehicle",["offset"]={0,0,0,0,0,0},["model"] = 470}
	},
	["army"] = {
		{	
			["elementType"]="object",
			["offset"]={0,5,-1.5,
				0,0,0},
			["model"] = 3884 -- samsite_SFXRF
		},
		{
			["elementType"]="object",
			["offset"]={-0.7,0,-0.5,
				0,0,90},
			["model"] = 3787 -- missile_02_SFXR
		},
		{	
			["elementType"]="object",
			["offset"]={0.7,0,-0.75,
				0,0,90},
			["model"] = 3795 -- missile_04_SFXR
		},
		{	
			["elementType"]="object",
			["offset"]={-0.7,-3.5,-0.55,
			0,0,90},
			["model"] = 3794 -- missile_07_SFXR
		},
		{
			["elementType"]="object",
			["offset"]={0.7,-2.6,-1.2,
			0,0,0},
			["model"] = 2977 -- kmilitary_crate
		},
		{	
			["elementType"]="object",
			["offset"]={0.7,-4.2,-1.2,
			0,0,0},
			["model"] = 2977 -- kmilitary_crate
		},
		{	
			["elementType"]="object",
			["offset"]={0,-7,-1.1,
			0,0,0},
			["model"] = 2985 -- minigun_base
		},
		{	
			["elementType"]="object",
			["offset"]={0,-6,-1.1,
			0,0,0},
			["model"] = 2985 -- minigun_base
		}
	},
	["last-passenger-cart"] = {
		{	
			["elementType"]="object",
			["offset"]={-1.4,-2.9, -0.9,
				0,0,0},
			["model"] = 18074 -- Donut_rail
		},
		{	
			["elementType"]="object",
			["offset"]={1.4,2.9, -0.9,
				0,0,0},
			["model"] = 18074 -- Donut_rail
		},
		{	
			["elementType"]="object",
			["offset"]={0.6,6.8, -0.7,
				0,0,0},
			["model"] = 3046 -- kb_barrel
		},
		{	
			["elementType"]="object",
			["offset"]={-0.1,-7.8, -0.3,
				0,0,0},
			["model"] = 1345 -- CJ_Dumpster
		},
		{	
			["elementType"]="object",
			["offset"]={-0.2,8.2,-0.6,
				0,0,182},
			["model"] = 920 -- Y_GENERATOR 
		},
		{	
			["elementType"]="object",
			["offset"]={-0.1,-4.5,-0.27,
				0,0,74},
			["model"] = 2960 -- kmb_beam

		},
		{	
			["elementType"]="object",
			["offset"]={-0.3,-4.4,-0.7,
				0,0,74},
			["model"] = 2960 -- kmb_beam
		},
		{	
			["elementType"]="object",
			["offset"]={0.3,-4.5,-0.26,
				0,0,74},
			["model"] = 2960 -- kmb_beam
		},
		{	
			["elementType"]="object",
			["offset"]={0.1,-4.5,-0.7,
				0,0,74},
			["model"] = 2960 -- kmb_beam
		},
		{	
			["elementType"]="object",
			["offset"]={0.5,-4.6,-0.7,
				0,0,74},
			["model"] = 2960 -- kmb_beam
		}, 
		{	
			["elementType"]="object",
			["offset"]={-0.6,6.9,-0.3,
				0,0,0},
			["model"] = 1685 -- blockpallet
		}, 
		{	
			["elementType"]="object",
			["offset"]={0.3,3.2,-0.3,
				0,0,0},
			["model"] = 1685 -- blockpallet
		},
		{	
			["elementType"]="vehicle",
			["offset"]={0.4,0.8,-0.3,
				0,0,0},
			["model"] = 530 -- Forklift
		},
		{	
			["elementType"]="ped",
			["offset"]={0.2,5.2,-0.1,
				0,0,0},
			["animBlock"] = "beach",
			["animName"]="parksit_m_loop",
			["model"] = 16
		}	
	}
}