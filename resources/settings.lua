local settings = {
	token = "",
	responseTemplate = "Response ➜ ",
	gameNames = {
		"with code",
		"with Lua",
		"with my hammers",
		"with 🔨",
		"with bots"
	},
}

local mt = {}
function mt.__call(table,define)
	if define == "reload" then
		--settings.gameNames[2] = "on ".._G.class:getBotServerCount().." server(s)" old stuff yo
	end
end
setmetatable(settings,mt)
return settings