function showMods(guild,status)
	local mods = {online={},idle={},dnd={},offline={}}
	local sorted = {}
	for member in guild.members do
		if not member.bot then
			if _G.class.Permissions:hasPermission(member,"kickMembers") then
				local status = (member.status == "online" and "<:vpOnline:212789758110334977>") or (member.status == "idle" and "<:vpAway:212789859071426561>") or (member.status == "offline" and "<:vpOffline:212790005943369728>") or "<:vpDnD:236744731088912384>"
				table.insert(mods[member.status],status.."**"..member.username.."#"..member.discriminator.."**")
				
				--	local name = (member.status == "idle" and "~~"..member.username.."~~") or (member.status == "offline" and "~~"..member.username.."~~") or "**"..member.username.."**"
				--table.insert(mods,name.." ("..member.id..")")
				--table.insert(mods,status.."**"..member.username.."#"..member.discriminator.."**")
			end
		end
	end
	if status then
		if status == "dnd" then
			for i,v in pairs(mods.dnd) do
				table.insert(sorted,v)
			end
			return table.concat(sorted,"\n")
		elseif status == "online" then
			for i,v in pairs(mods.online) do
				table.insert(sorted,v)
			end
			return table.concat(sorted,"\n")
		elseif status == "offline" then
			for i,v in pairs(mods.offline) do
				table.insert(sorted,v)
			end	
			return table.concat(sorted,"\n")
		elseif status == "idle" then
			for i,v in pairs(mods.idle) do
				table.insert(sorted,v)
			end	
			return table.concat(sorted,"\n")
		end
	else
		for i,v in pairs(mods.online) do
			table.insert(sorted,v)
		end
		for i,v in pairs(mods.dnd) do
			table.insert(sorted,v)
		end
		for i,v in pairs(mods.idle) do
			table.insert(sorted,v)
		end
		for i,v in pairs(mods.offline) do
			table.insert(sorted,v)
		end
		return table.concat(sorted,"\n")
	end
end
return 
	{About = "Shows guild moderators.",
	Arguments = {{"[online/offline/idle/dnd]","string"}},
	Hidden = false,
	Level = 1,
	Flags = {""},
	Alias = {"moderators","admins"}
	},
	function(command)
		local sliced,joined,message = command.sliced,command.joined,command.message
		if sliced[2] then
			if sliced[2]:sub(1,2) == "on" then
				message:reply("List of **online** guild moderators:\n"..showMods(message.guild,"online"))
				return
			elseif sliced[2]:sub(1,2) == "of" then
				message:reply("List of **offline** guild moderators:\n"..showMods(message.guild,"offline"))
				return
			elseif sliced[2]:sub(1,1) == "d" then
				message:reply("List of **dnd** guild moderators:\n"..showMods(message.guild,"dnd"))
				return
			elseif sliced[2]:sub(1,1) == "i" then
				message:reply("List of **idle** guild moderators:\n"..showMods(message.guild,"idle"))
				return
			else
				message:reply("List of guild moderators:\n"..showMods(message.guild))
				return
			end
		end
		message:reply("List of guild moderators:\n"..showMods(message.guild))
		return
	end