local function dump(...)
	local args = table.pack(...)
	local content = ""
	for i = 1, args.n do
		content = content .. tostring(args[i])
		if i ~= args.n then content = content .. '\t' end
	end
	return content
end
function table.GetKeys( tab )
	local keys = {}
	local id = 1
	for k, v in pairs( tab ) do
		keys[ id ] = k
		id = id + 1
	end
	return keys
end


function execute(command,message,joined)
	local str = joined:gsub("```lua","''"):gsub("```","")
	local success,err = pcall(function()
		local lines = {}
		local sandbox = {}	
		sandbox.print = function(...)
			table.insert(lines,dump(...))
		end
		sandbox.p = function( t, indent, done )
			done = done or {}
			indent = indent or 0
			sandbox.print(string.rep( "\t", indent )..tostring(t))
			local keys = table.GetKeys( t )
			table.sort( keys, function( a, b )
				if ( sandbox.isnumber( a ) and sandbox.isnumber( b ) ) then return a < b end
				return tostring( a ) < tostring( b )
			end )
			for i = 1, #keys do
				local key = keys[ i ]
				local value = t[ key ]
				if sandbox.istable(value) and not done[ value ] then
					done[ value ] = true
					sandbox.print( string.rep( "\t", indent ).."\""..tostring( key ).."\"" .. ":" )
					sandbox.p ( value, indent + 1, done )
					done[ value ] = nil
				else
					sandbox.print(string.rep( "\t", indent ) .. "\""..tostring( key ).."\"" .. " = " .. "\"" .. tostring( value ).."\"" )
				end
			end
		end
		sandbox.printf = function(...)
			return sandbox.print(string.format(...))
		end
		sandbox.lines = lines
		sandbox.message = message
		sandbox.os = os
		sandbox.require = require
		sandbox.bot = bot
		sandbox._G = _G
		sandbox.class = _G.classes
		sandbox.type = type
		sandbox.math = math
		sandbox.table = table
		sandbox.pairs = pairs
		sandbox.ipairs = ipairs
		sandbox.coroutine = coroutine
		sandbox.tostring = tostring
		sandbox.tonumber = tonumber
		sandbox.ipairs = ipairs
		sandbox.string = string
		sandbox.db = _G.class.Data
		sandbox.istable = function(...)
		return type(...) == "table"
		end
		sandbox.isnumber = function(...)
			return type(...) == "number"
		end
		load(str,"","t",sandbox)()
		local content = table.concat(lines,"\n")
		if content ~= "" then
			--content = string.format("```lua\n%s\n```",content)
			--assert(message.channel:sendMessage(content))
				command:success(content,true)
		else
			--command:custom("",{})
		end
	end)
	if not success then
		--message.channel:sendMessage(string.format("```\n%s\n```",err))
		err = err:gsub("/home/self/resources/commands/Developer/code.lua:78: ","")
		command:error(err,true)
	end
end

return 
	{About = "Executes lua code.",
	Arguments = {},
	Hidden = true,
	Level = 4,
	Flags = {""},
	Alias = {""}
	},
	function(command)
		local message,sliced,joined = command.message,command.sliced,command.joined
		return execute(command,message,joined)
	end