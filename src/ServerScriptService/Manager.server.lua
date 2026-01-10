--[[==========================================================================

  File:           Manager.server.lua
  Created: 	      07/01/2026  (dd/mm/yyyy)
  Project:        Kemono Hangout
  Purpose:        Handle joining players and other.

  Author:         Snow2Code  –  snow2code@protonmail.com
  Copyright:      © 2025 Snow2Code and 0llie_kitty at Kemono Universe.
                  All rights reserved.

  Disclaimer:     Personal hobby code. No warranty, no promises.
                  Please don’t nick it without asking.

===========================================================================]]--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local KemonoUtil = require(game.ServerStorage.Framework.KemonoUtil)
local KemonoProperties = require(game.ServerStorage.Framework.KemonoProperties)

local function CharacterAdded(Character)
	local Player = Players:GetPlayerFromCharacter(Character)
	local Tag = KemonoProperties.name_tag:Clone()
	
	local Rank = Player:GetRankInGroup(KemonoProperties.group_id)
	Character:SetAttribute("Player", true)

	if Character.Humanoid then
		local TagUser = Tag:FindFirstChild("User")
		local TagRank = Tag:FindFirstChild("Rank")
		local TagIcons = Tag:FindFirstChild("Icons")
		local Icons = {}

		local UserText = Player.DisplayName
		local UserColor

		-- Staff Icon
		if Rank > 100 and Rank < 106 then
			table.insert(Icons, "Staff")
			-- Developers
			if Rank == 104 then
				table.insert(Icons, "Developer")
			end
		end

		-- Owner Icon, and other.
		if Rank >= 254 then
			table.insert(Icons, "Staff")
			table.insert(Icons, "Developer")
			table.insert(Icons, "Owner")
		end

		-- Premium Icon
		if Player.MembershipType == Enum.MembershipType.Premium then
			table.insert(Icons, "Premium")
		end

		-- Now add icons.
		for _, icon in pairs(Icons) do
			TagIcons:WaitForChild(icon).Visible = true
		end

		-- VIF Customization
		if KemonoUtil.DoesUserHaveVIF(Player) then
			print(`[Debug] {Player.Name} has VIF.`)

			if KemonoUtil.VIFTagText(Player) ~= nil then
				UserText = KemonoUtil.VIFTagText(Player)
			end

			if KemonoUtil.VIFTagColor(Player) ~= nil then
				UserColor = KemonoUtil.VIFTagColor(Player)
			end
		end

		TagUser.Text = UserText
		TagUser.ShadowText.Text = UserText

		print(`{Player.Name} rank is {Rank}`)

		Tag.Parent = Character.Head

		Character.Humanoid.NameDisplayDistance = 0
		Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	end
end

Players.PlayerAdded:Connect(function(Player)
	Player.CharacterAdded:Connect(CharacterAdded)
	
	local Rank = Player:GetRankInGroup(KemonoProperties.group_id)
	local Role = Player:GetRoleInGroupAsync(KemonoProperties.group_id)
	local Character = Player.Character
	
	-- Auto kick if the account is not 4 weeks old.
	if Player.AccountAge < 28 then
		Player:Kick(`Your account must be 4 weeks old to join. Try joining back in {28 - Player.AccountAge} days.`)
		return
	end

	--KemonoUtil.SendMessageToChat_JoinMsg(Player)
	
	-- Leaderstats
	local Leaderstats
	local Role_LeaderStats = Instance.new("StringValue")
	
	if Player:FindFirstChild("leaderstats") then
		Leaderstats = Player:FindFirstChild("leaderstats")
	else
		Leaderstats = Instance.new("Folder", Player)
		Leaderstats.Name = "leaderstats"
	end
	
	Role_LeaderStats.Name = "Role"
	
	-- Player Events
	local Events = Instance.new("Folder", Player)
	local Notify = Instance.new("RemoteEvent", Events)
	local NotifyFunction = Instance.new("BindableEvent", Events)
	local Message = Instance.new("RemoteEvent", Events)
	Events.Name = "Events"
	Notify.Name = "NotifyEvent"
	NotifyFunction.Name = "NotifyFunctionEvent"
	Message.Name = "MessageEvent"
	
	
	Role_LeaderStats.Value = Role
	
	-- Now finish up.
	
	Player:GetPropertyChangedSignal("Team"):Connect(function()
		if Character and Character.Head:FindFirstChild("NameTag") then
			local Tag = Character.Head.NameTag
			local Text = Player.Team.Name
			
			Tag.Rank.Text = "Updating..."
			--wait(1)
			
			if Rank > 100 then
				Text = KemonoUtil.RemoveEmojis(Player:GetRoleInGroupAsync(KemonoProperties.group_id))
			end
			
			Tag.Rank.Text = Text
			Tag.Rank.ShadowText.Text = Text
			Tag.Rank.TextColor3 = Player.TeamColor.Color
		end
	end)
	
	Player.Team = KemonoUtil.GetTeam(Rank)
	Player:SetAttribute("Role", Role)
	Role_LeaderStats.Parent = Leaderstats
	
	ReplicatedStorage.Events.NameTagFriendIcon:FireAllClients(Player)
end)


-- We have this loop in a task spawn function because
-- of team changes..
task.spawn(function()
	while wait(1) do
		local AllPlayers = Players:GetPlayers()
		
		for i, Player in pairs(AllPlayers) do
			local Character = Player.Character
			local Rank = Player:GetRankInGroup(KemonoProperties.group_id)
			
			if Character and Character.Head:FindFirstChild("NameTag") then
				local Tag = Character.Head.NameTag
				local Text = Player.Team.Name

				Tag.Rank.Text = "Updating..."
				--wait(1)

				if Rank > 100 then
					Text = KemonoUtil.RemoveEmojis(Player:GetRoleInGroupAsync(KemonoProperties.group_id))
				end

				Tag.Rank.Text = Text
				Tag.Rank.ShadowText.Text = Text
				Tag.Rank.TextColor3 = Player.TeamColor.Color
			end
		end
	end
end)


			--[[
			game:BindToClose(function()
				for _, player in pairs(game.Players:GetChildren()) do
					task.spawn(function()
						task.wait(1)
						game:GetService("TeleportService"):Teleport(16919962965, player)
					end)
				end
			end)
]]