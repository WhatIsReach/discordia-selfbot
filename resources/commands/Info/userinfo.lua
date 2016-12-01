local userInfo = {{"Username","username"},{"ID","id"},{"Status","status"},{"Game","gameName"},{"Bot","bot"},{"Avatar","avatarUrl"}}
local memberInfo = {{"Nickname","nickname"},{"DisplayName","name"},{"JoinedAt","joinedAt"},{"RoleCount","roleCount"}}


function showUserInfo(user)
	local info1 = ""
	local info2 = ""
	for i,v in pairs(userInfo) do
		local userValue = tostring(user[v[2]])
		userValue = string.gsub(userValue,"'","")
		userValue = string.gsub(userValue,"`","")
		userValue = string.gsub(userValue,[[\]],"")
		info1 = info1..v[1].." = '"..userValue.."'\n"
	end	
	for i,v in pairs(memberInfo) do
		local userValue = tostring(user[v[2]])
		userValue = string.gsub(userValue,"'","")
		userValue = string.gsub(userValue,"`","")
		userValue = string.gsub(userValue,[[\]],"")
		info2 = info2..v[1].." = '"..userValue.."'\n"
	end	
	local info = [[
```ini
[ User Info ]
	
]]..info1..[[
	
[ Member Guild Info ]
	
]]..info2..[[
```
]]
	return info
end


return 
	{About = "Shows a user's info.",
	Arguments = {{"<user>","string"}},
	Hidden = false,
	Level = 1,
	Flags = {""},
	Alias = {"uinfo"}
	},
	function(command)
		local sliced,joined,message = command.sliced,command.joined,command.message
		if not sliced[2] then
			return command:success(showUserInfo(message.member))
		else
			local member = _G.class.Users:find(tonumber(sliced[2]) and sliced[2] or joined,message.guild)
			if not member then return command:error("Could not find the user!") end
			return command:success(showUserInfo(member))
		end
	end