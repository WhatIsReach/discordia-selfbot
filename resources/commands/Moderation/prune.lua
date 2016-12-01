function count(func)
	local num = 0
	for value in func do
		num = num+1
	end
	return num
end

function clearMessages(message,amount)
	local channel = message.channel
	amount = tonumber(amount)
	if amount < 100 then
		local num = count(message.channel:getMessageHistory(amount))
		local result = message.channel:bulkDelete(amount)
		if result then
			return "Successfully pruned **"..num.."** messages."
		end
	else
		local deletedcount = 0
		while true do
			local num = count(message.channel:getMessageHistory(100))
			message.channel:bulkDelete(num)
			amount = amount-num
			deletedcount = deletedcount + num
			if num == 0 or amount == 0 or num < 100 then
				return "Successfully pruned **"..deletedcount.."** messages."
			end
			_G.class.Utilities:wait(5)
		end
	end
end
	

return 
	{About = "Clears any amount of messages.",
	Arguments = {{"<num>","number"}},
	Hidden = false,
	Level = 1,
	Flags = {"manageMessages"},
	Alias = {"purge"}
	},
	function(command)
		local sliced,joined,message = command.sliced,command.joined,command.message
		local amount = sliced[2]
		if not amount then return command:error("Please specify an amount of messages to prune.") end
		if not tonumber(amount) then return command:error("Please specify an amount of messages to prune.") end
		local result = clearMessages(message,tonumber(amount))
		if result then
			command:success(result)
			command:clean(5)
		else
			return command:error("Failed to prune messages.")
		end
	end