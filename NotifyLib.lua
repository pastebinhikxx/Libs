--// Put this in StarterPlayerScripts as LocalScript
--// Notification Library with callback support

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local NotifyLib = {}

-- Config
NotifyLib.BlurFadeTime = 0.5 -- how fast blur fades in/out
NotifyLib.BlurStrength = 15
NotifyLib.Width = 320
NotifyLib.Height = 80

-- GUI container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NotificationGui"
ScreenGui.Parent = PlayerGui

-- Shared blur
local blur = Lighting:FindFirstChild("NotifBlur")
if not blur then
	blur = Instance.new("BlurEffect")
	blur.Name = "NotifBlur"
	blur.Size = 0
	blur.Parent = Lighting
end

-- Queue and state
NotifyLib.Queue = {}
NotifyLib.IsShowing = false

-- Internal: blur on/off
local function setBlur(enabled)
	local target = enabled and NotifyLib.BlurStrength or 0
	TweenService:Create(blur, TweenInfo.new(NotifyLib.BlurFadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = target
	}):Play()
end

-- Internal: show popup
local function showPopup(message, duration, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, NotifyLib.Width, 0, NotifyLib.Height)
	frame.Position = UDim2.new(1, NotifyLib.Width + 20, 1, -10)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.BackgroundTransparency = 0.3
	frame.BorderSizePixel = 0
	frame.AnchorPoint = Vector2.new(1, 1)
	frame.Parent = ScreenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = frame

	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(1, -10, 1, -10)
	text.Position = UDim2.new(0, 5, 0, 5)
	text.BackgroundTransparency = 1
	text.Text = message
	text.Font = Enum.Font.GothamSemibold
	text.TextSize = 18
	text.TextColor3 = Color3.fromRGB(255, 255, 255)
	text.TextXAlignment = Enum.TextXAlignment.Left
	text.TextWrapped = true
	text.Parent = frame

	setBlur(true)

	-- Tween in
	TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.new(1, -10, 1, -10)
	}):Play()

	-- Hold duration then fade out
	task.delay(duration, function()
		local tweenOut = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
			Position = UDim2.new(1, NotifyLib.Width + 20, 1, -10)
		})
		tweenOut:Play()
		tweenOut.Completed:Wait()
		frame:Destroy()
		if callback then callback() end
	end)
end

-- Public: push popup with optional callback
function NotifyLib:Push(message, duration, callback)
	table.insert(self.Queue, {msg = message, time = duration or 3, func = callback})
	if not self.IsShowing then
		self:ProcessQueue()
	end
end

-- Internal: process queue sequentially
function NotifyLib:ProcessQueue()
	self.IsShowing = true
	while #self.Queue > 0 do
		local item = table.remove(self.Queue, 1)
		local done = false
		showPopup(item.msg, item.time, function()
			done = true
			if item.func then
				item.func() -- run callback after this popup
			end
		end)
		repeat task.wait() until done
	end
	self.IsShowing = false
	setBlur(false)
end

--// Example usage
NotifyLib:Push("Injected! Leafy Executor — Have fun ", 3)
NotifyLib:Push("Now you can try some script! ❤️")


return NotifyLib
