-- Load NotifyLib from URL
local NotifyLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/pastebinhikxx/Libs/refs/heads/main/NotifyLibOBF.lua"))()
local player2 = game.Players.LocalPlayer

-- Optional: tweak configs
NotifyLib.BlurFadeTime = 0.7
NotifyLib.BlurStrength = 20
NotifyLib.Width =  200
NotifyLib.Height = 100

-- Push notifications
NotifyLib:Push("Injected Executor!", 4)
NotifyLib:Push("Welcome, Im Happy to see you! ".. player2.Name.. "❤", 4)
