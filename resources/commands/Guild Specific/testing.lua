return 
	{About = "Shows the testing channels for Discord Bots.",
	Arguments = {},
	Hidden = true,
	Level = 1,
	Flags = {""},
	Alias = {""},
	Examples = {""}
	},
	function(command)
		local sliced,joined,message = command.sliced,command.joined,command.message
    if message.guild.id ~= "110373943822540800" then return end
	  local author = message.author
    local server = message.guild
		local member = _G.class.Users:find(tonumber(sliced[2]) and sliced[2] or joined,message.guild)
    if member then
      message.channel:sendMessage(member.mentionString..", YOU NEED TO USE COMMANDS IN EITHER: <#132632676225122304>,<#113743192305827841>,<#117018340114825217>,<#116705171312082950>,<#119222314964353025>. Use anymore and you are risking yourself a **BAN/MUTE/KICK/SOFTBAN**. Basically, **DON'T DO IT!**")
    else
     	message.channel:sendMessage("USE COMMANDS IN EITHER: <#132632676225122304>,<#113743192305827841>,<#117018340114825217>,<#116705171312082950>,<#119222314964353025>. Use anymore and you are risking yourself a **BAN/MUTE/KICK/SOFTBAN**. Basically, **DON'T DO IT!**")
    end
	end