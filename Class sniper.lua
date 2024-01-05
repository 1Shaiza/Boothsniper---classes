local Booths_Broadcast = game:GetService("ReplicatedStorage").Network:WaitForChild("Booths_Broadcast")

local function checklisting(uid, gems, item, version, shiny, amount, username, playerid)
    gems = tonumber(gems)

    if gems <= 5 then
        task.wait(3.05)
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)

    elseif class == "Egg" and gems <= 75000 then
           task.wait(3.05)
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)

    elseif class == "Charm" and gems <= 10000 then
           task.wait(3.05)
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)

    elseif class == "Enchant" and gems <= 1000 then
           task.wait(3.05)
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)

    elseif class == "Potion" and gems <= 1000 then
           task.wait(3.05)
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)

    elseif class == "Misc" and gems <= 1000 then
           task.wait(3.05)
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    
    elseif class == "Fruit" and gems <= 100 then
           task.wait(3.05)
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    end
end
