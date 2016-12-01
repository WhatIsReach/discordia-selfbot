local responses = {
	"It is certain",
	"It is decidedly so",
	"Without a doubt",
	"Yes, definitely",
	"You may rely on it",
	"As I see it, yes",
	"Most likely",
	"Outlook good",
	"Yes",
	"Signs point to yes",
	"Reply hazy try again",
	"Ask again later",
	"Better not tell you now",
	"Cannot predict now",
	"Concentrate and ask again",
	"Don't count on it",
	"My reply is no",
	"My sources say no",
	"Outlook not so good",
	"Very doubtful"
}

return 
	{About = "Predict the future!",
	Arguments = {{"<text>","string"}}, --{format,type,is_optional}
	Hidden = false,
	Level = 1,
	Flags = {""},
	Alias = {"predict"}
	},
	function(command)
		local chosen = responses[math.random(1,#responses)]
		return command:success(chosen)
	end