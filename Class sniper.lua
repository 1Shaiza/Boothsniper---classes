local Booths_Broadcast = game:GetService("ReplicatedStorage").Network:WaitForChild("Booths_Broadcast")

local function checklisting(uid, gems, item, version, shiny, amount, username, playerid, class)
    gems = tonumber(gems)

     if gems <= 0 then
        task.wait(3.01)
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)

    elseif class == "Egg" and gems <= 75000 then
           task.wait(3.01)
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)

    elseif class == "Charm" and gems <= 10000 then
           task.wait(3.01)
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)

    elseif class == "Enchant" and gems <= 500 then
           task.wait(3.01)
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)

    elseif class == "Potion" and gems <= 100 then
           task.wait(3.01)
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)

    elseif class == "Misc" and gems <= 100 then
           task.wait(3.01)
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    
    elseif class == "Fruit" and gems <= 100 then
           task.wait(3.01)
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        
    end
end

Booths_Broadcast.OnClientEvent:Connect(function(username, message)
    local playerID = message['PlayerID']
    if type(message) == "table" then
        local listing = message["Listings"]
        for key, value in pairs(listing) do
            if type(value) == "table" then
                local uid = key
                local gems = value["DiamondCost"]
                local itemdata = value["ItemData"]

                if itemdata then
                    local data = itemdata["data"]

                    if data then
                        local item = data["id"]
                        local version = data["pt"]
                        local shiny = data["sh"]
                        local amount = data["_am"]
                        local class = itemdata['class']
                        checklisting(uid, gems, item, version, shiny, amount, username , playerID, class)
                    end
                end
            end
        end
    end
end)
