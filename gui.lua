--[[
    Attacking manually after running this will not affect how fast you kill.
    Idk what the difference between parrying and blocking but all i know is parrying is more op

    Made by fireztron @ v3rm
]]

--// For Non-Synapse Users (credits to egg salad)
if not pcall(function() return syn.protect_gui end) then
    syn = {}
    syn.protect_gui = function(egg)
        egg.Parent = game.CoreGui
    end
end

--// lib stuff uwuware i think
local lib = loadstring(game:HttpGet('https://raw.githubusercontent.com/fireztron/uwuware-ui-library/main/ui.lua', true))()
local window = lib:CreateWindow('Trade Tower GUI')
window:AddLabel({text = "fireztron @ v3rmillion"})

--// auto attack UI
window:AddToggle({text = 'Auto attack', state = autoattack, callback = function(v) 
    autoattack = v; 
end})

--// godmode UI
window:AddToggle({text = 'Godmode', state = godmode, callback = function(v) 
    godmode = v; 
end})

--// walkspeed UI
window:AddToggle({text = 'Walkspeed Changer', state = ws, callback = function(v) 
    ws = v; 
end})

local walkspeedToChangeTo = 22
--// walkspeed options ui
local walkspeedoption = window:AddFolder("walkspeed option")
walkspeedoption:AddSlider({text = 'walkspeed', value = 22, min = 12, max = 22, float = 1, callback = function(v) walkspeedToChangeTo = v end})

--// Init library
lib:Init()

local mt = getrawmetatable(game) 
local oldnamecall = mt.__namecall
setreadonly(mt, false)

--// Always parry
mt.__namecall = newcclosure(function(self, ...)
   local method = getnamecallmethod()
   local Args = {...}
   if not checkcaller() and method == "FireServer" and (Args[1] == "Parry") and godmode then
       return
   end
   if not checkcaller() and method == "FireServer" and (Args[1] == "Swing") and autoattack then
       return
   end
   return oldnamecall(self, unpack(Args))
end)
setreadonly(mt, true)


--// parry (god mode)
local function parryAttacks(WeaponR, katana)
    if godmode then
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

local WeaponR
local first = false
for i,v in pairs(getgc()) do
    if type(v)=="function" and getfenv(v).script==game:GetService("ReplicatedStorage"):WaitForChild("WeaponModules"):WaitForChild("Weapon") then
        local x = debug.getupvalues(v)
        for a,b in pairs(x) do
            if a == 9 and not first then
                first = true
                WeaponR = b
            end
        end
    end
end

if WeaponR then 
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
                if autoattack then
                    local args = {
                        [1] = "Swing",
                        [2] = katana
                    }
                    
                    WeaponR:FireServer(unpack(args))
                end

                --// Run remote at sprint speed
                if ws then
                    local args = {
                        [1] = walkspeedToChangeTo
                    }

                    ToggleR:FireServer(unpack(args))
                end
            end
        end
        wait(.1)
    end
end
