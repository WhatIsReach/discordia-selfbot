
function generateHelp()
		local helpMessage = {
			{'Bot','Selfbot (ACTIVE)'},
			{'Developer','Mindy Lahiri'},
			{"Library","Discordia (Lua)"},
			{"Guilds","Connected to **"..bot.guildCount.."** guilds."},
			{"Uptime",(_G.class.Time(os.time()-_G.botStarted))},
		}
	local str = ''
		for i,v in pairs(helpMessage) do
			str = str.."\n**"..v[1].."** ➜ "..v[2]
		end
	return str
end

return 
	{About = "View data about the bot.",
	Arguments = {},
	Hidden = false,
	Level = 1,
	Flags = {""},
	Alias = {""}
	},
	function(command,message,sliced,joined)
		return command:success(generateHelp())
	end