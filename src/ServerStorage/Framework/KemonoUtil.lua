--[[==========================================================================

  File:           KemonoUtil.lua
  Created: 	      08/01/2026  (dd/mm/yyyy)
  Project:        Kemono Hangout
  Purpose:        

  Author:         Snow2Code  –  snow2code@protonmail.com
  Copyright:      © 2025 Snow2Code and 0llie_kitty at Kemono Universe.
                  All rights reserved.

  Disclaimer:     Personal hobby code. No warranty, no promises.
                  Please don’t nick it without asking.

===========================================================================]]--


local DataStoreService = game:GetService("DataStoreService")

local KemonoProperties = require("./KemonoProperties")
local KemonoUtil = {}

function KemonoUtil.GetDate()
	return os.date("%d %B")
end

function KemonoUtil.GetDate_Day()
	return os.date("%d")
end

function KemonoUtil.GetDate_Month()
	return os.date("%b")
end

function KemonoUtil.GetDate_MonthFull()
	return os.date("%B")
end

-- Used for checking if a player has the VIF (Very Important Fur) gamepass.
function KemonoUtil.DoesUserHaveVIF(Player)
	local IsVIF = false

	--local success, e = pcall(function()
	local pass_id = nil

	-- Silly check -w-
	if game.PlaceId == KemonoProperties.place_ids[3] then
		pass_id = KemonoProperties.vif_ids[4]
	else 
		pass_id = KemonoProperties.vif_ids[0]
	end

	IsVIF = game.MarketplaceService:UserOwnsGamePassAsync(Player.UserId, pass_id)
	--end)

	return IsVIF
end

-- Used for the VIF customization. The custom name tag text.
function KemonoUtil.VIFTagText(Player)
	-- Dumb double check.
	if KemonoUtil.DoesUserHaveVIF(Player) then
		local DataBase = DataStoreService:GetDataStore(KemonoProperties.database_names["VIF Tag Text"])
		local Data = DataBase:GetAsync(tostring(Player.UserId))

		return Data
	end
end

-- Used for the VIF customization. The custom name tag color.
function KemonoUtil.VIFTagColor(Player)
	-- Dumb double check.
	if KemonoUtil.DoesUserHaveVIF(Player) then
		local DataBase = DataStoreService:GetDataStore(KemonoProperties.database_names["VIF Tag Color"])
		local Data = DataBase:GetAsync(tostring(Player.UserId))

		return Data
	end
end

-- Get a join message.
function KemonoUtil.GetJoinMessage(Player:Player)
	local Rank = Player:GetRankInGroupAsync(KemonoProperties.group_id)
	local Messages = KemonoProperties.join_messages.Members
	local Message = "undefined"
	
	if Rank > 100 and Rank < 106 then
		Messages = KemonoProperties.join_messages.Staff
	elseif Rank > 200 and Rank < 254 then
		Messages = KemonoProperties.join_messages.Sillies

		if Player.UserId == 546537609 then
			if KemonoUtil.GetDate() == "08 October" then
				Messages = KemonoProperties.join_messages.Sillies_Birthday
			end
		end
	elseif Rank >= 254 then
		Messages = KemonoProperties.join_messages.Snowy

		if KemonoUtil.GetDate() == "07 February" then
			Messages = KemonoProperties.join_messages.Snowy_Birthday
		end
	end

	Message = Messages[math.random(1, #Messages)]

	-- Replace <player> with the player name.
	Message = string.gsub(Message, "<player>", Player.DisplayName)
	
	-- Replace <pronoun_herhis> with the pronoun.
	if Player.UserId == 3643895594 then
		Message = string.gsub(Message, "<pronoun_herhis>", "her")
	elseif Player.UserId == 546537609 then
		Message = string.gsub(Message, "<pronoun_herhis>", "her")
	else
		Message = string.gsub(Message, "<pronoun_herhis>", "their")
	end

	return Message
end

function KemonoUtil.GetTeam(Rank)
	local Team = game.Teams.Guest
	
	if Rank == 1 then
		Team = game.Teams.Members
	elseif Rank == 2 or Rank == 5 then
		-- Donator and VIF
		Team = game.Teams.VIF
	elseif Rank == 101 then
		-- Mod
		Team = game.Teams.Staff
	elseif Rank > 101 and Rank < 106 then
		-- H.Mod, Admin, Dev and Manager
		Team = game.Teams["Head Staff"]
		
	elseif Rank == 106 then
		-- Glichy, the silly glitchy fox
		Team = game.Teams.VIF
	elseif Rank == 240 or Rank == 241 then
		-- Sillies
		Team = game.Teams.VIF
		
	-- Creator and Holder
	elseif Rank > 242 then
		Team = game.Teams["Head Staff"]
	end
	
	if Team ~= nil then
		return Team
	end
end

function KemonoUtil.RemoveEmojis(Text)
	local EmojiPattern = "[\128-\255]"
	return Text:gsub(EmojiPattern, "")
end

-- -w-
--function KemonoUtil.SendMessageToChat()

--end

-- Send a message to the chat.
function KemonoUtil.SendMessageToChat(Message)
	game.TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage(Message)
end

-- Send a message to the chat.
function KemonoUtil.SendMessageToChat_JoinMsg(Player)
	local Message = KemonoUtil.GetJoinMessage(Player)
	print(Message)
	--KemonoUtil.GetJoinMessage(Player)
	--game.TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage(Message)
end

return KemonoUtil