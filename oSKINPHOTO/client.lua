local skins = getValidPedModels()
local inProgress = false

local waitTime = 1200

local bug = {9, 22, 23, 24, 25, 26, 27, 28, 102, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 184, 185, 188, 189, 194, 196, 197, 198, 199, 200, 201, 203, 204, 205, 207, 213, 214, 215, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 228, 232, 233, 235, 236, 239, 240, 241, 242, 247, 247, 248, 249, 250, 251, 253, 254, 255, 258, 259, 260, 2261, 262, 264, 265, 268, 269, 270, 271, 272, 275, 276, 277, 278, 279, 281, 282, 283, 284, 288, 291, 293, 294, 295, 296, 297, 298, 299, 300, 302, 303, 304, 305, 306, 307, 308, 309, 310}
local bug2 = {1}

--local accessories = {18204, 18206, 18214, 18336, 18342, 18343, 18344, 18351, 18352, 18376, 18377, 18383, 18385, 18475, 18477, 18625}
--local accessories = {18211, 18353, 18479}
--local accessories = {4296, 4297, 18213, 18280, 18281, 18291, 18335, 18337, 18345, 18359, 18360, 18457, 18471, 18485, 18518, 18620, 18621}
--local accessories = {18338, 18459}
--local accessories = {18301, 18302, 18309, 18446, 18630}
local accessories = {18386}

addCommandHandler("createavatars", function() 
    if getElementData(localPlayer, "aclLogin") then 
        if inProgress then return end 


        inProgress = true 
        for k, v in ipairs(getValidPedModels()) do 
            setTimer(function()
                setElementModel(localPlayer, v)
                setElementAlpha(localPlayer, 255)

                setElementPosition(localPlayer, 1286.7556152344, -1621.8463134766, 14)
                setElementRotation(localPlayer, 0, 0, 90)
     
                setCameraMatrix(1288.9908203125,-1621.8260498047,14.069299697876,1287.591796875,-1621.8370361328,14.011536979675, 0, 85)
                showChat(false)
                exports.oInterface:toggleHud(true)

                triggerServerEvent("avatarC > takePlayerScreenShot", resourceRoot, v)
            end, k*waitTime, 1)

            if k == #bug2 then 
                setTimer(function()
                    inProgress = false
                end, waitTime*k, 1)
            end
        end
    end
end)

local OBJECT = nil

addCommandHandler("createaccessories", function() 
    if getElementData(localPlayer, "aclLogin") then 
        if inProgress then return end

        inProgress = true 
        for k, v in ipairs(accessories) do 
            setTimer(function()
                --setElementModel(localPlayer, v)

                if isElement(OBJECT) then destroyElement(OBJECT) end

                setElementPosition(localPlayer, 1286.7556152344, -1621.8463134766, 13.546875)
                OBJECT = createObject(v, 1286.7556152344, -1621.8463134766, 14.2, 0, 0, -30)
                setObjectScale(OBJECT, 3)
                setElementRotation(OBJECT, 0, 0, -60)
                setCameraMatrix(1288.5908203125,-1621.8260498047,14.069299697876,1287.591796875,-1621.8370361328,14.111536979675)
                showChat(false)
                exports.oInterface:toggleHud(true)

                triggerServerEvent("avatarC > takePlayerScreenShot", resourceRoot, v)
            end, k*waitTime, 1)

            if k == #bug2 then 
                setTimer(function()
                    inProgress = false
                end, waitTime*k, 1)
            end
        end
    end
end)


triggerServerEvent("avatarC > takePlayerScreenShot", resourceRoot, 1)