--[[==========================================================================

  File:           KemonoProperties.lua
  Created: 	      07/01/2026  (dd/mm/yyyy)
  Project:        Kemono Hangout
  Purpose:        Hold game properties that don't change

  Author:         Snow2Code  –  snow2code@protonmail.com
  Copyright:      © 2025 Snow2Code and 0llie_kitty at Kemono Universe.
                  All rights reserved.

  Disclaimer:     Personal hobby code. No warranty, no promises.
                  Please don’t nick it without asking.

===========================================================================]]--

local KemonoProps = {}

-- \\ Properties //
KemonoProps.group_id = 32066692
KemonoProps.vif_ids = {
	[0] = 730933732, -- Main
	[4] = 1661699882 -- Funland
}
KemonoProps.place_ids = {
	[0] = 15534555743, -- Kemono Hangout
	[1] = 100666768869824, -- Kemono Hangout 2025
	[2] = 109070408926798, -- Developments
	[3] = 17128133707 -- Funland
}

KemonoProps.join_messages = {
	["Members"] = {
		"All raise your paws! The might <player> has joined.",
		"Incoming fluffiness alert! <player> has just entered the hangout.",
		"Hold on to your tails, folks! <player> is in the house.",
		--"Fur-tastic news: <player> has just pounced into Kemono Hangout.",
		--"Prepare for a burst of adorableness! <player> is here to hang out.",
		--"The fluffy party just got an upgrade - <player> has arrived! Time to celebrate.",
		--"",
		--"",
	},
	["Staff"] = {
		"All raise your paws! The might <player> has joined.",
		"Incoming fluffiness alert! <player> has just entered the hangout.",
		"Hold on to your tails, folks! <player> is in the house.",
		-- Because these are meh. Use Member join message instead.
		--"Welcome to Kemono Hangout, <player>. You're apart of the Staff Team now. Let's keep this place fun and safe.",
		--"Hey there, <player>. As apart of Staff, your sillyness is our best defense. Welcome to Kemono Hangout.",
		--"<player>, you're now a Staff memeber! Let's make Kemono Hangout a great place for everyone.", -- !
		--"A warm welcome to our new staff member, <player>! Let's spread joy in Kemono Hangout!",
	},
	["Sillies"] = {
		"Initializing connection for <player>. beep boop... Connected.",
		"Ugh.. it's <player>. I mean.. Welcome back!.. please don't fire me.",
		"Attention: <player> is on deck. System online and ready for maximum fluffiness.",
		"Boop! <player> detected. Welcome back to Kemono Hangout – your furry kingdom!. And, um, don't fire me.",
		"It's a <player> alert! Initiating warm and fuzzy welcome protocol. And, um, don't fire me.",
		"Oh, it's just you, <player>. Kidding! Welcome back, dear friend. Please be gentle with the firing decisions."
	},
	["Snowy"] = {
		"Initializing connection for <player>. beep boop... Connected.",
		"Ugh.. it's <player>. I mean.. Welcome back!.. please don't fire me.",
		"Attention: <player> is on deck. System online and ready for maximum fluffiness.",
		"Boop! <player> detected. Welcome back to Kemono Hangout – your furry kingdom!. And, um, don't fire me.",
		"It's a <player> alert! Initiating warm and fuzzy welcome protocol. And, um, don't fire me.",
		"Oh, it's just you, <player>. Kidding! Welcome back, dear friend. Please be gentle with the firing decisions."
	},
	
	-- Birthdays.
	["Sillies_Birthday"] = {
		"It's <player>! And it's <pronoun_herhis> birthday!"
	},
	["Snowy_Birthday"] = {
		"It's <player>! And it's <pronoun_herhis> birthday!"
	}
}

KemonoProps.database_name_base = "Kemono Hangout"
KemonoProps.database_names = {
	["VIF Tag Text"] = `{KemonoProps.database_name_base} - VIF Text`,
	["VIF Tag Color"] = `{KemonoProps.database_name_base} - VIF Color`,
}

KemonoProps.name_tag = game.ServerStorage.Assets.NameTag
KemonoProps.game_ver = "2.5.0" -- Old Github readme says 2.5 is latest for expermential.

return KemonoProps