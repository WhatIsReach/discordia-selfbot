local allCommandFiles = {}
local fs = require("fs")
local path = require("path")

_G.Commands = {}
local commandClass = _G.class.Commands

function getCommands()
	local readdir = fs.readdir
	local readdirRecursive = require('luvit-walk').readdirRecursive
	readdirRecursive(module.dir, function(k, files) 
		for i,v in pairs(files) do
			if v:match(".lua") and not v:match("commands.lua") then
				local cmdName = v:sub(2):match("([^/]-)%..-$")
				local roles = nil
				local aliases = nil
				local result,perms,execute = nil,nil,nil
				local success,err = pcall(function()
					perms,execute = dofile(v)		
				end)
				if success then
					local Alias = perms.Alias
					if Alias then
						for _,alias in pairs(Alias) do
							if alias ~= "" then
								if not aliases then aliases = {} end
								aliases[alias] = alias
							end
						end
					end
					if perms.Roles and #perms.Roles > 0 then
						for l,k in pairs(perms.Roles) do
							if k ~= "" then
								if not roles then roles = {} end
								roles[k] = k
							end
						end
					end
					local cmdInfo = {}
					for i,v in pairs(perms) do
						cmdInfo[i] = v
					end
					cmdInfo.Roles = roles
					cmdInfo.Alias = aliases
					cmdInfo.execute = execute
					_G.Commands[cmdName] = cmdInfo
				else
					p(err)
				end
			end
		end
	end)
end

function executeCommand(message,cmd,msgTable,joined)
		coroutine.wrap(function()
			local author = message.author
			local member = message.member
			for i,v in pairs(_G.Commands) do
				if i == cmd or (v.Alias and v.Alias[cmd]) then
					local roles = v.roles
					local authorRoles = _G.class.Users:getRoles(member)
					local level,flags = v.Level,v.Flags
					local authorPerms = _G.class.Permissions:get(member,message.guild,flags)
					if msgTable[2] and msgTable[2]:match("<@") then
						msgTable[2] = string.gsub(msgTable[2],"<@!","")
						msgTable[2] = string.gsub(msgTable[2],"<@","")
						msgTable[2] = string.gsub(msgTable[2],">","")
					end
					local newCommand = commandClass.new(message,v,msgTable,joined)
					newCommand:awaitResponse()
					for i,v in pairs(flags) do
						if v ~= "" then
							if not authorPerms.flags[v] and not authorPerms.flags["ADMINISTRATOR"] then
								return newCommand:error("I need the **"..v.."** permission to execute this command.")
							end
						end
					end
					local result = nil
					local success,err = pcall(function()
					--	result = v.execute(newCommand,message,msgTable,joined)
						result = newCommand:execute()
					end)
					if success then
						if result then
							return result
						end
					return nil
					else
						p(err)
						return newCommand:error("An error has occured while executing this command.")
					end
				end
			end
			
	end)()
--	end)()
end

getCommands()
return executeCommand
