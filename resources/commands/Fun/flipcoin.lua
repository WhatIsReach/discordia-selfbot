local responses = {
	"Heads",
	"Tails"
}
return 
	{About = "Flip a coin.",
	Arguments = {}, --{format,type,is_optional}
	Hidden = false,
	Level = 1,
	Flags = {""},
	Alias = {"coin"}
	},
	function(command)
		local chosen = responses[math.random(1,#responses)]
		return command:success(chosen)
	end