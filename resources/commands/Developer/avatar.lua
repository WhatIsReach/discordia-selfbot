return 
	{About = "Changes the bot's avatar.",
	Arguments = {},
	Hidden = true,
	Level = 4,
	Flags = {""},
	Alias = {""}
	},
	function(command)
		local sliced,joined,message = command.sliced,command.joined,command.message
		local success,result = pcall(function()
			local _,av = _G.class.Http.request("GET",joined)
			bot:setAvatar("data:image/png;base64,".._G.class.base64.encode(av))
		end)
		if success then
			command:success("Successfully changed the avatar.")
		else
			command:error("Could not change the avatar.")
			p(result)
		end
	end
