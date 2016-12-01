local guildInfo = {{"Name","name"},{"ID","id"},{"Owner","owner"},{"Unavailable","unavailable"},{"VIP","vip"},{"MfaLevel","mfaLevel"},{"Roles","roleCount"},{"Icon","iconUrl"}}
local memberInfo = {{"Members","totalMemberCount"}}
local channelInfo = {{"TextChannels","textChannelCount"},{"VoiceChannels","voiceChannelCount"},{"Region","region"}}

function count(funct)
	local num = 0
	for value in funct do
		num = num+1
	end
	return num
end
--guild.icon = 'https://discordapp.com/api/guilds/'..guild.id..'/icons/'..guild.icon..'.jpg
function showGuildInfo(guild)
	local info1 = ""
	local info2 = ""
	local info3 = ""
	for i,v in pairs(guildInfo) do
		local guildInfo = tostring(guild[v[2]])
		guildInfo = string.gsub(guildInfo,"'","")
		guildInfo = string.gsub(guildInfo,"`","")
		info1 = info1..v[1].." = '"..guildInfo.."'\n"
	end	
	for i,v in pairs(memberInfo) do
		local guildInfo = tostring(guild[v[2]])
		guildInfo = string.gsub(guildInfo,"'","")
		guildInfo = string.gsub(guildInfo,"`","")
		info2 = info2..v[1].." = '"..guildInfo.."'\n"
	end
	for i,v in pairs(channelInfo) do
		local guildInfo = tostring(guild[v[2]])
		guildInfo = string.gsub(guildInfo,"'","")
		guildInfo = string.gsub(guildInfo,"`","")
		info3 = info3..v[1].." = '"..guildInfo.."'\n"
	end	
	local info = [[
```ini
[ Guild Info ]

]]..info1..[[
	
[ Member Info ]	

]]..info2..[[
	
[ Channel Info ]	

]]..info3..[[
```
]]
	return info
end


return 
	{About = "Shows a guild's info.",
	Arguments = {},
	Hidden = false,
	Level = 1,
	Flags = {""},
	Alias = {"sinfo","ginfo","guildinfo"}
	},
	function(command)
		local message = command.message
		return command:success(showGuildInfo(message.guild))
	end