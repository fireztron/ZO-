--[[
    Attacking manually after running this will not affect how fast you kill.
    Idk what the difference between parrying and blocking but all i know is parrying is more op

    Made by fireztron @ v3rm
]]
warn("use gui its better :D (check v3rm dummy")
--[[
local mt = getrawmetatable(game) 
local oldnamecall = mt.__namecall
setreadonly(mt, false)

--// Always parry
mt.__namecall = newcclosure(function(self, ...)
   local method = getnamecallmethod()
   local Args = {...}
   if not checkcaller() and method == "FireServer" and (Args[1] == "Parry" or Args[1] == "Swing") and _G.autoattack then
       return
   end
   return oldnamecall(self, unpack(Args))
end)
setreadonly(mt, true)


--// parry (god mode)
local function parryAttacks(WeaponR, katana)
    if _G.autoattack then
        local args = {
            [1] = "Parry",
            [2] = katana,
            [3] = true
        }
        WeaponR:FireServer(unpack(args))
    end
end

--// Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RS = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ToggleR = ReplicatedStorage.ToggleRun
local remoteName = ReplicatedStorage:WaitForChild("General"):WaitForChild("Config"):WaitForChild("wrnd"):FindFirstChildOfClass("StringValue")

if remoteName and remoteName.Value ~= "NOT_LOADED_YET" then 
    local WeaponR = ReplicatedStorage:WaitForChild(remoteName.Value)

    --// Always be parrying
    do
        local LPChar = LocalPlayer.Character
        if LPChar then
            local katana = LPChar:FindFirstChildOfClass("Tool")
            if katana and katana:FindFirstChild("Weapon") then
                parryAttacks(WeaponR, katana)
            end
            LPChar.ChildAdded:Connect(function(katana)
                if katana:IsA("Tool") then
                    katana:WaitForChild("Weapon")
                    parryAttacks(WeaponR, katana)
                end
            end)
        end
        LocalPlayer.CharacterAdded:Connect(function(char)
            char.ChildAdded:Connect(function(katana)
                if katana:IsA("Tool") then
                    katana:WaitForChild("Weapon")
                    parryAttacks(WeaponR, katana)
                end
            end)
        end)
    end

    _G.autoattack = true
    while _G.autoattack do
        local LPChar = LocalPlayer.Character
        if LPChar then
            local katana = LPChar:FindFirstChildOfClass("Tool")
            if katana and katana:FindFirstChild("Weapon") then
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
        wait(.1)
    end
end
]]
