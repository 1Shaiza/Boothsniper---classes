task.wait(10) -- i hate library loading

setfpscap(8)
game.Players.LocalPlayer.PlayerScripts.Scripts.Core["Idle Tracking"].Enabled = false
game:GetService("RunService"):Set3dRenderingEnabled(false)
local Booths_Broadcast = game:GetService("ReplicatedStorage").Network:WaitForChild("Booths_Broadcast")
local http = game:GetService("HttpService")
local rs = game:GetService("ReplicatedStorage")
local Library = require(rs:WaitForChild("Library"))

local vu = game:GetService("VirtualUser")
Players.LocalPlayer.Idled:connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   task.wait(1)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

local function processListingInfo(uid, gems, item, version, shiny, amount, boughtFrom, boughtStatus, class, failMessage, snipeNormal)
    local gemamount = Players.LocalPlayer.leaderstats["💎 Diamonds"].Value
    local snipeMessage ="||".. Players.LocalPlayer.Name .. "||"
    local weburl, webContent, webcolor
    local versionVal = { [1] = "Golden ", [2] = "Rainbow " }
    local versionStr = versionVal[version] or (version == nil and "")
    local mention = (string.find(item, "Huge") or string.find(item, "Titanic")) and "<@" .. userid .. ">" or ""
	
    if boughtStatus then
	webcolor = tonumber(0x00ff00)
	weburl = "https://discordapp.com/api/webhooks/1192846169701896334/UGFK02uuIBAnsDhy-gc_MvKnGL_h5USweoVr55g9DgtMzAgR1Uffq5YyKDAdZvCOyEXE"
        snipeMessage = snipeMessage .. " just sniped ".. Library.Functions.Commas(amount) .."x "
        webContent = mention
	end
    else
	webContent = failMessage
	webcolor = tonumber(0xff0000)
	weburl = "https://discordapp.com/api/webhooks/1192846169701896334/UGFK02uuIBAnsDhy-gc_MvKnGL_h5USweoVr55g9DgtMzAgR1Uffq5YyKDAdZvCOyEXE"
	snipeMessage = snipeMessage .. " failed to snipe ".. Library.Functions.Commas(amount) .."x "
    end
    
    snipeMessage = snipeMessage .. "**" .. versionStr
    
    if shiny then
        snipeMessage = snipeMessage .. " Shiny "
    end
    
    snipeMessage = snipeMessage .. item .. "**"
    
    local message1 = {
        ['content'] = webContent,
        ['embeds'] = {
            {
		["author"] = {
			["name"] = "Shaiza",
			["icon_url"] = "https://cdn.discordapp.com/attachments/1034579708312027138/1192675000151457802/Snazzy.png?ex=65a9f026&is=65977b26&hm=d7714215f4dffc2f0825e6c31b5688958fae12adc9859a80e39ed8f88e627eca&",
		},
                ['title'] = snipeMessage,
                ["color"] = webcolor,
                ["timestamp"] = DateTime.now():ToIsoDate(),
                ['fields'] = {
                    {
                        ['name'] = "__Price:__",
                        ['value'] = Library.Functions.ParseNumberSmart(gems) .. " 💎",
                    },
                    {
                        ['name'] = "__Bought from:__",
                        ['value'] = "||"..tostring(boughtFrom).."|| ",
                    },
                    {
                        ['name'] = "__Amount:__",
                        ['value'] = Library.Functions.Commas(amount) .. "x",
                    },
                    {
                        ['name'] = "__Remaining gems:__",
                        ['value'] = Library.Functions.ParseNumberSmart(gemamount) .. " 💎",
                    },      
                    {
                        ['name'] = "__PetID:__",
                        ['value'] = "||"..tostring(uid).."||",
                    },
                },
		["footer"] = {
                        ["icon_url"] = "https://cdn.discordapp.com/attachments/1034579708312027138/1192675124571283516/Sad.png?ex=65a9f044&is=65977b44&hm=5c952d9fd71c948e336543b3214453f3f07eee01ca43dfbfeb01672200037071&", -- optional
                        ["text"] = "Heavily Modified by Shaiza"
		}
            },
        }
    }

    local jsonMessage = http:JSONEncode(message1)
    local success, webMessage = pcall(function()
	http:PostAsync(weburl, jsonMessage)
    end)
    if success == false then
        local response = request({
            Url = weburl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonMessage
        })
    end
end

local function tryPurchase(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
    if buytimestamp > listTimestamp then
      task.wait(3.05 - Players.LocalPlayer:GetNetworkPing())
    end
    local boughtPet, boughtMessage = game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, class, boughtMessage, snipeNormal)
end

Booths_Broadcast.OnClientEvent:Connect(function(username, message)
        if type(message) == "table" then
            local highestTimestamp = -math.huge -- Initialize with the smallest possible number
            local key = nil
            local listing = nil
            for v, value in pairs(message["Listings"] or {}) do
                if type(value) == "table" and value["ItemData"] and value["ItemData"]["data"] then
                    local timestamp = value["Timestamp"]
                    if timestamp > highestTimestamp then
                        highestTimestamp = timestamp
                        key = v
                        listing = value
                    end
                end
            end
            if listing then
                local buytimestamp = listing["ReadyTimestamp"]
                local listTimestamp = listing["Timestamp"]
                local data = listing["ItemData"]["data"]
                local gems = tonumber(listing["DiamondCost"])
                local uid = key
                local item = data["id"]
                local version = data["pt"]
                local shiny = data["sh"]
                local amount = tonumber(data["_am"]) or 1
                local playerid = message['PlayerID']
                local class = tostring(listing["ItemData"]["class"])
                local unitGems = gems/amount
		snipeNormal = false
                                 
                 if unitGems <= 5 then
           coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp)
                    return				
 elseif class == "Egg" and unitGems <= 75000 then
           coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp)
                    return
 elseif class == "Charm" and unitGems <= 10000 then
           coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp)
                    return
 elseif class == "Enchant" and unitGems <= 1000 then
           coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp)
                    return
 elseif class == "Potion" and unitGems <= 1000 then
           coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp)
                    return
 elseif class == "Misc" and unitGems <= 1000 then
           coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp)
                    return
 elseif class == "Fruit" and unitGems <= 100 then
           coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp)
                    return
                    end
                end
            end
        end
    end)
