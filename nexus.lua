-- SmoxHub: Ultimate Unlocked MM2 Premium Menu
-- No Keys, No Webhooks, 100% Free and Open Source

local Library = loadstring(game:HttpGet("https://githubusercontent.com"))()
local Window = Library:CreateWindow({Name = "SmoxHub | MM2 Unlocked", Enabled = true})

-- SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")

-- PREMIUM WELCOME NOTIFICATION
StarterGui:SetCore("SendNotification", {
    Title = "SmoxHub Premium",
    Text = "Welcome, " .. LocalPlayer.Name .. " | Unlocked Loaded!",
    Duration = 5,
    Icon = "rbxassetid://4483345998"
})

-- TABS
local CombatTab = Window:CreateTab({Name = "Combat Mods"})
local FarmTab = Window:CreateTab({Name = "Auto Farm"})
local VisualsTab = Window:CreateTab({Name = "ESP & Visuals"})

-- HELPER FUNCTION: GET ROLES
local function getMurderer()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and (p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")) then
            return p
        end
    end
    return nil
end

-- 1. COMBAT: BLATANT KILL AURA (As Murderer)
CombatTab:CreateToggle({
    Name = "Blatant Kill Aura",
    CurrentValue = false,
    Callback = function(Value)
        _G.KillAura = Value
        task.spawn(function()
            while _G.KillAura do
                task.wait(0.05) -- Hyper-fast check rate
                local knife = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Knife")
                if knife then
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                            if distance < 25 then -- Extended blatant range
                                -- Automatically slashes and logs hit registration
                                knife:Activate()
                                firetouchinterest(p.Character.HumanoidRootPart, knife.Handle, 0)
                                firetouchinterest(p.Character.HumanoidRootPart, knife.Handle, 1)
                            end
                        end
                    end
                end
            end
        end)
    end
})

-- 2. COMBAT: AUTO SHOOT MURDERER (As Sheriff / Hero)
CombatTab:CreateToggle({
    Name = "Auto Shoot Murderer",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoShoot = Value
        task.spawn(function()
            while _G.AutoShoot do
                task.wait(0.1)
                local gun = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun")
                local murderer = getMurderer()
                
                if gun and murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
                    -- Fires weapon directly targeting the Murderer's core root position
                    local targetPos = murderer.Character.HumanoidRootPart.Position
                    gun.KnifeServer.ShootGun:InvokeServer(targetPos, LocalPlayer.Character.HumanoidRootPart.Position)
                end
            end
        end)
    end
})

-- 3. COMBAT: AUTO PICKUP DROPPED GUN
CombatTab:CreateToggle({
    Name = "Auto Grab Dropped Gun",
    CurrentValue = false,
    Callback = function(Value)
        _G.GrabGun = Value
        task.spawn(function()
            while _G.GrabGun do
                task.wait(0.2)
                local gunDrop = Workspace:FindFirstChild("GunDrop")
                if gunDrop and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    -- Smoothly teleports directly onto the gun to collect it instantly
                    local currentPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
                    LocalPlayer.Character.HumanoidRootPart.CFrame = gunDrop.CFrame
                    task.wait(0.2)
                end
            end
        end)
    end
})

-- 4. AUTO FARM: FULL MAP COIN TWEEN
FarmTab:CreateToggle({
    Name = "Auto Farm Coins",
    CurrentValue = false,
    Callback = function(Value)
        _G.CoinFarm = Value
        task.spawn(function()
            while _G.CoinFarm do
                task.wait(0.1)
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if (obj.Name == "Coin_Container" or obj.Name == "Coin") and obj:IsA("BasePart") then
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and _G.CoinFarm then
                            -- Tweens character to coin safely
                            LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame
                            task.wait(0.3) -- Delay to guarantee database registers coin pickup
                        end
                    end
                end
            end
        end)
    end
})

-- 5. VISUALS: CHAM / HIGHLIGHT ESP
VisualsTab:CreateButton({
    Name = "Activate Full Player ESP",
    Callback = function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                -- Clear old highlights to avoid duplicates
                if p.Character:FindFirstChild("ESPHighlight") then
                    p.Character.ESPHighlight:Destroy()
                end
                
                local bp = p:FindFirstChild("Backpack")
                local hl = Instance.new("Highlight")
                hl.Name = "ESPHighlight"
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.OutlineTransparency = 0
                hl.FillTransparency = 0.5
                
                -- Dynamic role coloring logic
                if bp:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
                    hl.FillColor = Color3.fromRGB(255, 0, 0) -- Murderer = Blatant Red
                elseif bp:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then
                    hl.FillColor = Color3.fromRGB(0, 0, 255) -- Sheriff = Electric Blue
                else
                    hl.FillColor = Color3.fromRGB(0, 255, 0) -- Innocent = Neon Green
                end
                hl.Parent = p.Character
            end
        end
    end
})
