return 
	{About = "Mutes a person from the guild. If the person rejoins and Tiger is online, the person will be re-muted.",
	Arguments = {{"<user>","user"}}, --{format,type,is_optional}
	Hidden = false,
	Level = 2,
	Flags = {},
	Alias = {""}
	},
	function(command)
		local sliced,joined,message = command.sliced,command.joined,command.message
    if not _G.class.Permissions:hasPermission(message.guild.me,"manageRoles") then return command:error("Sorry, I don't have permission to manage roles.") end
    local author = message.author
    local server = message.guild
		local member = _G.class.Users:find(tonumber(sliced[2]) and sliced[2] or joined,message.guild)
    if not member then return command:error("Could not find the user!") end
    local result = _G.class.Users:mute(member)
		if result then
			--local muted = _G.class.Data:load("guilds",message.guild.id,"muted",{}).muted or {}
			--table.insert(muted,member.id)
			--_G.class.Data:save("guilds",message.guild.id,"muted",muted)
    	return command:success("Successfully muted **"..member.username.."**.")
		else
			return command:error("Failed to mute **"..member.username.."**.")
		end
	end