local command = {}
command.__index = command

local timer = require("timer")

local SUCCESS_TEXT = "Result ➜ "
local ERROR_TEXT = "| **Error** ➜ "

function command:sayMessage(text,title,color)
  local author = self.message.author
  if not author then return end
  local embed = nil
  if not title then
    self.message:setContent(text)
  else
    embed = {author = {name=author.username.."#"..author.discriminator,url=author.avatarUrl,icon_url=author.avatarUrl},fields={{name = title,value = text,inline = true}},color = color}
    self.message:setContent("",embed)
  end
  return self.message
end

function command.new(message,cmd,msgTable,joined)
  return setmetatable({message = message,text=nil,messages={},cmd = cmd,sliced = msgTable,joined = joined},command)
end

function command:clean(time)
  if time then
    _G.class.Utilities:wait(time)
  end
  for i,v in pairs(self.messages) do
    v:delete()
  end
end

function command:awaitResponse()
  local embed = {fields={{name = "Processing Command",value = "This command has not finished processing.",inline = true}},color = "3907276"}
  self.message:setContent("",embed)
end
function command:execute()
  coroutine.wrap(function()
    self.cmd.execute(self)
  end)()
end

function command:timeout()
  coroutine.yield()
end

function command:success(text)
  if not text then return end
  text = tostring(text)
  local msg
  if not _G.class.Permissions:hasPermission(self.message.guild.me,"embedLinks") then
    self.message:setContent(SUCCESS_TEXT..text)
  else
    self:sayMessage(text,"Success","3918953")
  end
end

function command:error(text)
  if not text then return end
  text = tostring(text)
  local msg
  if not _G.class.Permissions:hasPermission(self.message.guild.me,"embedLinks") then
    self.message:setContent(ERROR_TEXT..text)
  else
    self:sayMessage(text,"Error","13388859")
  end
end

--13388859
command.latency = "{latency}"
--[[function command.error(text,delete_time)
  return "| **Error ➜** "..text
end
function command.success(text,delete_time)
  return "| "..SUCCESS_TEXT..text
end]]

return command