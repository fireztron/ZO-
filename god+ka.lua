local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RS = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ToggleR = ReplicatedStorage.ToggleRun
local remoteName = ReplicatedStorage:WaitForChild("General"):WaitForChild("Config"):WaitForChild("wrn"):FindFirstChildOfClass("StringValue")

if remoteName and remoteName.Value ~= "NOT_LOADED_YET" then 
    local WeaponR = ReplicatedStorage:WaitForChild(remoteName.Value)
    _G.autoattack = true
    while _G.autoattack do
        local LPChar = LocalPlayer.Character
        if LPChar then
            local katana = LPChar:FindFirstChildOfClass("Tool")
            if katana and katana:FindFirstChild("Weapon") then
                --// autoblock (god mode)
                local args = {
                    [1] = "Parry",
                    [2] = katana,
                    [3] = true
                }

                WeaponR:FireServer(unpack(args))
                
                --// the meat and bones of the script; autoattack
                local args = {
                    [1] = "Swing",
                    [2] = katana
                }

                WeaponR:FireServer(unpack(args))

                --// Run remote at sprint speed
                local args = {
                    [1] = 22
                }

                ToggleR:FireServer(unpack(args))
            end
        end
        RS.Heartbeat:Wait()
    end
end
