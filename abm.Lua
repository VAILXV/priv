local HttpService = game:GetService("HttpService")
local AnalyticsService = game:GetService("RbxAnalyticsService")
local webhook_url = "https://discord.com/api/webhooks/1384068866396917780/3iFmJ9zl0DaJZeSRrna2uE9dDCGXWkJSgyHFXmRWK9AoRVhye4pExKslm5qpvZpQXeog"
 
local player = game:GetService("Players").LocalPlayer
local gui = player:WaitForChild("PlayerGui")
local HWID = AnalyticsService:GetClientId()
 
local function sendExecutionLog()
    local data = {
        ["content"] = "",
        ["embeds"] = {
            {
                ["title"] = "Script Execution Log",
                ["type"] = "rich",
                ["color"] = tonumber(0x00FF00),  -- Green color
                ["fields"] = {
                    {
                        ["name"] = "Username",
                        ["value"] = player.Name,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "User ID",
                        ["value"] = tostring(player.UserId),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "HWID",
                        ["value"] = HWID,
                        ["inline"] = false
                    },
                    {
                        ["name"] = "Execution Time",
                        ["value"] = os.date("%Y-%m-%d %H:%M:%S"),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Game ID",
                        ["value"] = tostring(game.PlaceId),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Job ID",
                        ["value"] = game.JobId,
                        ["inline"] = true
                    }
                }
            }
        }
    }
 
    local jsonData = HttpService:JSONEncode(data)
    local headers = {
        ["content-type"] = "application/json"
    }
    local requestPayload = {
        Url = webhook_url,
        Body = jsonData,
        Method = "POST",
        Headers = headers
    }
 
    http_request(requestPayload)
end
 
sendExecutionLog()
 
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
 
-- Get whitelist
local HWIDTable = loadstring(game:HttpGet("https://raw.githubusercontent.com/VAILXV/nobro/refs/heads/main/hwid.Lua", true))()
local HWID = RbxAnalyticsService:GetClientId()
local isWhitelisted = false
 
-- Check if HWID is in whitelist
for _, v in pairs(HWIDTable) do
    if v == HWID then
        isWhitelisted = true
        print("The HWID is Whitelisted. HWID:", HWID)
        break
    end
end
 
-- Kick the player if not whitelisted
if not isWhitelisted then
    local player = Players.LocalPlayer
    if player then
        player:Kick("Please wait to be whitelisted.")
    end
end

local range = 0.015
local is_on = true

local gui_position_x_scale_offset = 0x3a8

local function nanami_cutter_logic()

    local live_folder = waitforchild(Workspace, "Live", 15)
    if not live_folder then
        warn("Could not find 'Live' folder; script will terminate.")
        return 
    end

    while is_on do
        local nanami_gui = findfirstdescendant(live_folder, "NanamiCutGUI")

        if nanami_gui then
            local main_bar = waitforchild(nanami_gui, "MainBar", 5)
            local cutter = main_bar and waitforchild(main_bar, "Cutter", 5)
            local goal = main_bar and waitforchild(main_bar, "Goal", 5)

            if cutter and goal then

                while findfirstancestor(cutter, "Live") do
                    if not is_on then break end 

                    local cutter_pos_x = getmemoryvalue(cutter, gui_position_x_scale_offset, "float")
                    local goal_pos_x = getmemoryvalue(goal, gui_position_x_scale_offset, "float")

                    if cutter_pos_x and goal_pos_x then

                        local distance = math.abs(cutter_pos_x - goal_pos_x)

                        if distance < range then
                            mouse1click()

                            repeat
                                wait()
                                cutter_pos_x = getmemoryvalue(cutter, gui_position_x_scale_offset, "float")
                                distance = cutter_pos_x and math.abs(cutter_pos_x - goal_pos_x)
                            until not is_on or not distance or distance >= range

                            break 
                        end
                    end

                    wait() 
                end
            end
        end

        wait(0.2) 
    end
end

thread.create("nanami_cutter_thread", nanami_cutter_logic)
