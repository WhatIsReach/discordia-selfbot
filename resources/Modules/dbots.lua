local module = {}

local http = require('coro-http')
local json = require("json")

local url = "http://bots.discord.pw/api"
local token = ""
local headers = {}
headers['Authorization'] = token

function module:getBots()
  payload = payload or {}
  local status, result = http.request("GET", url.."/bots",headers)
  print(result)
  return result
end


return module