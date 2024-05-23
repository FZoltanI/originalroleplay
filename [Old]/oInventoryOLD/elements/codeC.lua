local hoverWorldItem = nil
local func = {}
local stream = {}
local opensans = fontScript:getFont("condensed", 12)
local objects = {}
local players = {}
local upCount = 0
local check = {}
check.positions = {sX/2 - 800/2,sY/2 -460/2,800,460}
check.opensans = fontScript:getFont("condensed", 12)
check.categorys = {"Játékosok","Járművek","Széfek"}
check.selected = 0
check.show = false

func["buggClickCountNull"] = function()
	upCount = 0
end
addEvent("buggClickCount",true)
addEventHandler("buggClickCount",getRootElement(),func["buggClickCountNull"])

-- / fegyver melegedés / --
melegedes = {}
local hotTimer = false 

local item = getElementData(localPlayer,"active:itemID")

function weaponHot(weaponID)
	if source == localPlayer then 
		if getElementData(localPlayer, "inWeaponSkilling") then return end
		if hotTable[weaponID] then

			item = getElementData(localPlayer,"active:itemID")
			
			if not melegedes[item] then 
				table.insert(melegedes, item, 0)
			end

			melegedes[item] = melegedes[item] + hotTable[weaponID]

			if melegedes[item] > 100 then 
				melegedes[item] = 100 

				setElementHealth(localPlayer, getElementHealth(localPlayer) - 3)
				setElementData(localPlayer, "char:health", getElementHealth(localPlayer))
				outputChatBox(core:getServerPrefix("red-dark", "Fegyver", 3).."A fegyver túlmelegedett és megégetted magadat.", 255, 255, 255, true)

				local newValue = math.random(10, 20)

				if newValue < 0 then 
					newValue = 0 
				end

				addItemValue(activeWeaponSlot, (0-newValue))

				activeWeaponSlot = -1
				activeAmmoSlot = - 1
				triggerServerEvent("elveszfegyot", localPlayer, localPlayer)
				setElementData(localPlayer,"active:weaponSlot",-1)
				setElementData(localPlayer,"active:itemID",-1)
				setElementData(localPlayer,"active:itemSlot",-1)
			end

			if not isTimer(hotTimer) then 
				hotTimer = setTimer(function()
					if isTimer(hotTimer) then 
						melegedes[item] = melegedes[item] - 1

						if melegedes[item] < 0 then 
							melegedes[item] = 0
						end

						if melegedes[item] <= 0 then 
							killTimer(hotTimer)
						end

						setElementData(localPlayer, "weapon:hot", melegedes[item])
					end
				end, 75, 0)
			end

			setElementData(localPlayer, "weapon:hot", melegedes[item])
		end
	end
end
addEventHandler("onClientPlayerWeaponFire", root, weaponHot)