local Permissions = {
	levels = {
		BOT_MASTER = 4,
		SERVER_OWNER = 3,
		BOT_COMMANDER = 2,
		NORMAL_USER = 1,
		BOT = 0
	},
}

local flags = {
	createInstantInvite	= 0x00000001, -- general
	kickMembers			= 0x00000002, -- general
	banMembers			= 0x00000004, -- general
	administrator		= 0x00000008, -- general
	manageChannels		= 0x00000010, -- general
	manageGuild			= 0x00000020, -- general
	addReactions		= 0x00000040, -- text
	readMessages		= 0x00000400, -- text
	sendMessages		= 0x00000800, -- text
	sendTextToSpeech	= 0x00001000, -- text
	manageMessages		= 0x00002000, -- text
	embedLinks			= 0x00004000, -- text
	attachFiles			= 0x00008000, -- text
	readMessageHistory	= 0x00010000, -- text
	mentionEveryone		= 0x00020000, -- text
	useExternalEmojis	= 0x00040000, -- text
	connect				= 0x00100000, -- voice
	speak				= 0x00200000, -- voice
	muteMembers			= 0x00400000, -- voice
	deafenMembers		= 0x00800000, -- voice
	moveMembers			= 0x01000000, -- voice
	useVoiceActivity	= 0x02000000, -- voice
	changeNickname		= 0x04000000, -- general
	manageNicknames		= 0x08000000, -- general
	manageRoles			= 0x10000000, -- general
	manageWebhooks		= 0x20000000, -- general
	manageEmojis		= 0x40000000, -- general
}

function Permissions:hasPermission(user,...)
	local permissions = {}
	local tuple = {...}
	local defaultRole = user.guild.defaultRole
	for role in user.roles do	
		for i,v in pairs(flags) do
			if role.permissions:has(i) or defaultRole.permissions:has(i) or role.permissions:has("administrator")  then
				permissions[i] = i
			end
		end
	end
	for i,v in pairs(tuple) do
		if not permissions[v] and not defaultRole.permissions:has(v) then
			return false
		end
	end
	return true
end
function Permissions:get(user,server,optional_flags)
	local level = {
		flags={},
		level=1,
	}
	local defaultRole = user.guild.defaultRole
	if optional_flags and type(optional_flags) == "table" then
		for role in user.roles do
			for l,k in pairs(flags) do
				if not level.flags[l] then
					if role.permissions:has(l) or defaultRole.permissions:has(l) or role.permissions:has("administrator") then
						level.flags[l] = l
					end
				end
			end
		end
	end
	if user.id == "217122202934444033" then level.level = 4 return level end
	if user.id == server.owner.id then level.level = 3 	level.flags["administrator"] = "administrator"  return level end
	for role in user.roles do
		if role.name == "Bot Commander" then
			level.level = 2
			return level
		end
	end
	--DETECT IF BOT

	return level
end

return Permissions