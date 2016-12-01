local discordia = require('discordia')
local client = discordia.Client({fetchMembers = true})
local class = require("./resources/classes/classes.lua")
_G.class = class
client.settings = require("./resources/settings.lua")
local newCommand = require("./resources/commands/commands.lua")
local modules = require("./resources/Modules/modules.lua")
_G.botModules = modules
	_G.bot = client
	_G.DEFAULT_BOT_RESPONSE = client.settings.responseTemplate

client:on('ready', function()
	_G.botStarted = os.time()
	local username = client.user.username
	if username ~= client.settings.name then
		username = client.settings.name
	end
	p(string.format('Logged in as %s', client.user.username))
	client:setGameName("with my hammers")
	local gameCount = 1
	local games = client.settings.gameNames
	while true do
		client.settings("reload")
		gameCount = (gameCount < #games and gameCount + 1) or 1
		_G.class.Utilities:wait(20)
		client:setGameName(client.settings.gameNames[gameCount])
	end
end)

function executeCommand(message)
	local text = message.content
	local prefixes = {"$ ","$"}
	coroutine.wrap(function()
		for i,v in pairs(prefixes) do
			local beginning = text:sub(1,v:len())
			if beginning == v then
				local rest = text:sub(beginning:len()+1)
				local command,args = string.match(rest, '(%S+) (.*)')
				if not args then args = rest command = rest end
				local msgTable = {}
				for match in rest:gmatch("%S+") do	
					table.insert(msgTable,match)
				end
				newCommand(message,command,msgTable,args)
				break
			end
		end
	end)()
end
client:on('messageCreate', function(message)
	coroutine.wrap(function()
		if not message.guild then return end --DM commands
		local author = message.author
		local member = message.member
		if not author then return end
		local channel = message.channel
		if author.bot then return end
		if client.user.id ~= author.id then
			if message.guild.id == "163843122747408384" then 
				--autoMod(message.cleanContent) --TODO
			end
			return
		end
		local mentions = {members={}}
		for mention in message.mentionedUsers do
			table.insert(mentions.members,mention:getMembership(message.guild))
		end
		message.mentions = mentions
		pcall(function() _G.class.Responses:setMessage(author,message) end)
		executeCommand(message)
	end)()
end)


client:run(client.settings.token)
