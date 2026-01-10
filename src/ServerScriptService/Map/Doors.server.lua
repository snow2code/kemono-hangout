--[[==========================================================================

  File:           Doors.server.lua
  Created: 	      10/01/2026  (dd/mm/yyyy)
  Project:        Kemono Hangout
  Purpose:        <purpose>

  Author:         Snow2Code  –  snow2code@protonmail.com
  Copyright:      © 2025 Snow2Code and 0llie_kitty at Kemono Universe.
                  All rights reserved.

  Disclaimer:     Personal hobby code. No warranty, no promises.
                  Please don’t nick it without asking.

===========================================================================]]--

local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")

local DoorData = {}

function AddDoorData(Door)
	local TEMPDOORS = 0
	local _DATA_ = { ["ID"] = "", ["Open"] = false, ["CanOpen"] = false, ["OnCooldown"] = false, ["Doors"] = "", ["Type"] = "",["Time"] = 0 }

	-- Set data
	_DATA_.ID = game.HttpService:GenerateGUID()
	_DATA_.CanOpen = Door:GetAttribute("Disabled")
	
	if Door:GetAttribute("Disabled") then
		_DATA_.CanOpen = false
	else
		_DATA_.CanOpen = true
	end
	
	_DATA_.Time = Door.Variable.Time.Value
	
	for _, _Door in ipairs(Door.DoorPartList:GetChildren()) do
		TEMPDOORS = TEMPDOORS + 1
	end

	if TEMPDOORS == 2 then
		_DATA_.Doors = "Double"
	elseif TEMPDOORS == 1 then
		_DATA_.Doors = "Single"
	else
		_DATA_.Doors = `Unknown - {TEMPDOORS}`
	end

	DoorData[_DATA_.ID] = _DATA_	
	Door:SetAttribute("ID", _DATA_.ID)
	
	-- Set move goal and original frame
	if _DATA_.Doors == "Double" then
		local Doors = Door.DoorPartList
		local LeftDoor = Doors.LeftDoor
		local RightDoor = Doors.RightDoor
		
		LeftDoor.Original.Value = LeftDoor.MainPart.CFrame
		RightDoor.Original.Value = RightDoor.MainPart.CFrame

		if LeftDoor.MainPart.Orientation == Vector3.new(0, 0, 0) then
			local Goal, Goal_ = LeftDoor.Original.Value, LeftDoor.Goal
			Goal = Goal * CFrame.new(-5.3, 0, 0)
			Goal_.Value = Goal
		end
		if LeftDoor.MainPart.Orientation == Vector3.new(0, 90, 0) then
			local Goal, Goal_ = LeftDoor.Original.Value, LeftDoor.Goal
			Goal = Goal * CFrame.new(-5.3, 0, 0)
			Goal_.Value = Goal
		end
		if LeftDoor.MainPart.Orientation == Vector3.new(0, -90, 0) then
			local Goal, Goal_ = LeftDoor.Original.Value, LeftDoor.Goal
			Goal = Goal * CFrame.new(-5.3, 0, 0)
			Goal_.Value = Goal
		end
		if LeftDoor.MainPart.Orientation == Vector3.new(0, 180, 0) then
			local Goal, Goal_ = LeftDoor.Original.Value, LeftDoor.Goal
			Goal = Goal * CFrame.new(-5.3, 0, 0)
			Goal_.Value = Goal
		end
		

		if RightDoor.MainPart.Orientation == Vector3.new(0, 0, 0) then
			local Goal, Goal_ = RightDoor.Original.Value, RightDoor.Goal
			Goal = Goal * CFrame.new(5.3, 0, 0)
			Goal_.Value = Goal
		end
		if RightDoor.MainPart.Orientation == Vector3.new(0, 90, 0) then
			local Goal, Goal_ = RightDoor.Original.Value, RightDoor.Goal
			Goal = Goal * CFrame.new(5.3, 0, 0)
			Goal_.Value = Goal
		end
		if RightDoor.MainPart.Orientation == Vector3.new(0, -90, 0) then
			local Goal, Goal_ = RightDoor.Original.Value, RightDoor.Goal
			Goal = Goal * CFrame.new(5.3, 0, 0)
			Goal_.Value = Goal
		end
		if RightDoor.MainPart.Orientation == Vector3.new(0, 180, 0) then
			local Goal, Goal_ = RightDoor.Original.Value, RightDoor.Goal
			Goal = Goal * CFrame.new(5.3, 0, 0)
			Goal_.Value = Goal
		end
	end
	
	Door.Variable:Destroy()
end

function GenerateTweens(Door, Time)
	local Info = TweenInfo.new(Time, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
	
	local LeftDoor = Door.DoorPartList.LeftDoor
	local RightDoor = Door.DoorPartList.RightDoor
	
	return {
		["LeftOpen"] = TweenService:Create(LeftDoor.MainPart, Info, {CFrame = LeftDoor.Goal.Value}),
		["RightOpen"] = TweenService:Create(RightDoor.MainPart, Info, {CFrame = RightDoor.Goal.Value}),
		["LeftClose"] = TweenService:Create(LeftDoor.MainPart, Info, {CFrame = LeftDoor.Original.Value}),
		["RightClose"] = TweenService:Create(RightDoor.MainPart, Info, {CFrame = RightDoor.Original.Value}),
	}
end

for _, Doors in pairs(CollectionService:GetTagged("doors")) do
	-- Add door data.
	for _, Door in ipairs(Doors:GetChildren()) do
		if Door:GetAttribute("IsActuallyAKHDoor") ~= nil then
			AddDoorData(Door)
		end
	end
	
	-- Now actual function!
	for _, Door in ipairs(Doors:GetChildren()) do
		if Door:GetAttribute("IsActuallyAKHDoor") ~= nil then
			local Data = DoorData[Door:GetAttribute("ID")]

			--if Data ~= nil then
				Door.Sensor.Detection.Touched:Connect(function(Hit)
					if Hit.Parent:FindFirstChild("Humanoid") then
						if Data.CanOpen and Data.Open ~= true and Data.OnCooldown == false then
							Data.Open = true
							--Data.OnCooldown = true
						
							if Data.Doors == "Double" then
								local LeftDoor = Door.DoorPartList.LeftDoor
								local RightDoor = Door.DoorPartList.RightDoor

								local Tweens = GenerateTweens(Door)

								LeftDoor.MainPart.DoorOpen:Play()
								RightDoor.MainPart.DoorOpen:Play()

								Tweens.LeftOpen:Play()
								Tweens.RightOpen:Play()

								wait(5)
								LeftDoor.MainPart.DoorClose:Play()
								RightDoor.MainPart.DoorClose:Play()
								Tweens.LeftClose:Play()
								Tweens.RightClose:Play()

								wait(2)
								Data.Open = false
								--Data.OnCooldown = false
							end
						end
					end
				end)
			end
		--end
	end
end
