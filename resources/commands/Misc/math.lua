function executeMath(equation)
	if not equation or equation == "" then return "Please give me a math equation." end
	local result = nil
	local success,err = pcall(function()
		local sandbox = {}
		sandbox.pi = math.pi
		sandbox.math = math
		result = load("return "..equation, "", "t", sandbox)()	
	end)
	return (success and result) or nil
end
return 
	{About = "Solve math equations.",
	fullDescription = "Solve math equations. You can use Lua math operators such as *,+,-,%,/, etc. You are also able to use Lua math functions such as math.abs,math.ceil, math.pi, etc.",
	Arguments = {{"<equation>","string"}},
	Hidden = false,
	Level = 1,
	Flags = {""},
	Alias = {"solve"}
	},
	function(command)
		local sliced,joined = command.sliced,command.joined
		if not sliced[2] then return command:error("Please give me a math equation.") end
		local result = executeMath(joined)
		if result then
			return command:success(result)
		else
			return command:error("Unable to solve the equation.")	
    end
	end