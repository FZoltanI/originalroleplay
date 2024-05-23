addEvent("animation > playAnim", true)
addEventHandler("animation > playAnim", resourceRoot, function(block, anim, time, loop, state)
   -- outputChatBox(block)
    --setPedAnimation(client, block, anim, time, loop, true, true, false, true)
    setPedAnimation(client, block, anim, time, loop, false, false)
    

    setElementData(client, "player:animation", state)
    if state then 
        setElementData(client, "customAnimations", {block, anim, time, loop, false, false})
    else
        setElementData(client, "customAnimations", false)
    end
end)