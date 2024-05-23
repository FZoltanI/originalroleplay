addEvent("setStaminaAnimation", true)
addEventHandler("setStaminaAnimation", getRootElement(), function(state)
    if state then
        setPedAnimation(client, "fat", "idle_tired")
    else
        setPedAnimation(client)
    end
end)