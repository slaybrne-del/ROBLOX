-- NormalBodyProportions
-- Put this Script in ServerScriptService.
-- Resets every player's body scaling to Roblox's default, realistic proportions
-- so arms/legs/torso are no longer stretched.

local Players = game:GetService("Players")

-- Default Roblox scale values (1 = normal size, 0 = classic/realistic proportions)
local NORMAL_SCALES = {
	HeightScale = 1,
	WidthScale = 1,
	DepthScale = 1,
	HeadScale = 1,
	ProportionScale = 0,
	BodyTypeScale = 0,
}

-- Same values, but as the NumberValue names that live inside the Humanoid
local HUMANOID_VALUE_NAMES = {
	BodyHeightScale = 1,
	BodyWidthScale = 1,
	BodyDepthScale = 1,
	HeadScale = 1,
	BodyProportionScale = 0,
	BodyTypeScale = 0,
}

local function fixCharacter(character)
	local humanoid = character:WaitForChild("Humanoid", 10)
	if not humanoid then
		return
	end

	-- Preferred way: rebuild the avatar from a HumanoidDescription with normal scales
	local ok = pcall(function()
		local description = humanoid:GetAppliedDescription()
		for property, value in pairs(NORMAL_SCALES) do
			description[property] = value
		end
		humanoid:ApplyDescription(description)
	end)

	-- Fallback (custom rigs): set the scale values inside the Humanoid directly
	if not ok then
		humanoid.AutomaticScalingEnabled = true
		for name, value in pairs(HUMANOID_VALUE_NAMES) do
			local scaleValue = humanoid:FindFirstChild(name)
			if scaleValue and scaleValue:IsA("NumberValue") then
				scaleValue.Value = value
			end
		end
	end
end

local function onPlayerAdded(player)
	player.CharacterAppearanceLoaded:Connect(fixCharacter)
	if player.Character then
		task.spawn(fixCharacter, player.Character)
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end
