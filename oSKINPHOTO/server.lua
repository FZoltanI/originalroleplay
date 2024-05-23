addEvent("avatarC > takePlayerScreenShot", true)
addEventHandler("avatarC > takePlayerScreenShot", resourceRoot, function(model)
    takePlayerScreenShot(client, 1768, 992, "avatar_"..model)
    --print("asd")
end)

addEventHandler("onPlayerScreenShot", root, function(res, status, imageData, timestamp, tag)
    print(res, status, timestamp, tag)
    if string.find(tag, "avatar_") then 

        print("bela")

        local file
        if fileExists("avatars/"..tag) then 
            file = fileOpen("avatars/"..tag..".jpeg")
        else
            file = fileCreate("avatars/"..tag..".jpeg")
        end

        fileWrite(file, imageData)
        fileClose(file)
    end
end)