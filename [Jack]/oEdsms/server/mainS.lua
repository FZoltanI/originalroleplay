function receiveDonation(phone, value, prefix, msg) 
    
    --[[
        phone = Telefonszám amiről érkezett az sms
        value = sms értéke
        prefix = sms prefix (pl: seerpg)
        msg = a prefix utáni szöveg (seerpg 123 (például account id))
    ]]--
    
    outputChatBox('A szervert támogatták a ' .. phone .. ' telefonszámról ' .. value .. ' forinttal!', root, 255, 255, 255, true);
end