return 
	{About = "Invite the bot to your guild!",
	Arguments = {},
	Hidden = false,
	Level = 1,
	Flags = {""},
	Alias = {""}
	},
	function(command,message,sliced,joined)
		return command:success("\nYou can **invite** Tiger to your guild by clicking this link! https://discordapp.com/oauth2/authorize?&client_id=225079733799485441&scope=bot&permissions=8")
	end