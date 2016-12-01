return 
	{About = "Kicks a person and clears their messages from the past week.",
	Arguments = {{"<user>","user"}}, --{format,type,is_optional}
	Hidden = false,
	Level = 1,
	Flags = {"kickMembers"},
	Alias = {""}
	},
	function(command)
		local sliced,joined,message = command.sliced,command.joined,command.message
    if not _G.class.Permissions:hasPermission(message.guild.me,"banMembers") then return command:error("Sorry, I don't have permission to ban members.") end
    local author = message.author
    local server = message.guild
		local member = _G.class.Users:find(tonumber(sliced[2]) and sliced[2] or joined,message.guild)
    if not member then return command:error("Could not find the user!") end 
   	local result = server:banUser(member,7)
		if not result then return command:error("Failed to softban **"..member.username.."**.") end
		result = server:unbanUser(member)
		if result then
    	return command:success("Successfully softbanned **"..member.username.."**.")
		else
			return command:error("Failed to softban **"..member.username.."**.")
		end
	end