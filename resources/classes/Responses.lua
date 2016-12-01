local response = {messages={}}
response.__index = response

local timer = require("timer")

function response.new()
  return setmetatable({},response)
end

function response:setMessage(author,message)
  response.messages[author.id] = message
end

function response:clean(typeOf,message,dialog,server)
  local contentLower = message.content:lower()
  if typeOf == "mention" then
    --
  elseif typeOf == "string" then
    return message.content
  elseif typeOf == "user" then
    local user = _G.class.Users:find(message,server)
    if not user then return {false,_G.DEFAULT_BOT_RESPONSE.."Could not find the user!"} end
    return user
  elseif typeOf == "channel" then
    local user = _G.class.Channels:find(message,server)
    if not user then return {false,_G.DEFAULT_BOT_RESPONSE.."Could not find the user!"} end
    return user
  elseif typeOf == "number" then
    local num = tonumber(message.content)
    if not num then return {false,_G.DEFAULT_BOT_RESPONSE.."You didn't give me a number!"} end
    return num
  elseif typeOf == "choices" then
    for i,v in pairs(dialog.input.choices) do
      if contentLower == v:lower() then
        return v
      end
    end
    return {false,_G.DEFAULT_BOT_RESPONSE.."\nInvalid type. Choices = "..table.concat(dialog.input.choices,", ").."."} 
  end
end
function response:sayResponse(countdown,dialog,message,ignore_prompt)
    local channel = message.channel
    local author = message.author
    if not ignore_prompt then message.channel:sendMessage(_G.DEFAULT_BOT_RESPONSE..dialog.prompt.."\nSay ``cancel`` to cancel.") end
    response.messages[message.author.id] = nil
    while not response.messages[message.author.id] and countdown > 0 do
      timer.sleep(500)
      countdown = countdown - .5
    end
    if not response.messages[message.author.id] or response.messages[message.author.id].content:lower():match("cancel") then
      return "Cancelled"
    end
    local content = response:clean(dialog.input.type,response.messages[message.author.id],dialog,message.server)
    if type(content) == "table" then
      if content[1] == false then
        message.channel:sendMessage(content[2].." Try again or say ``cancel`` to cancel.")
       return response:sayResponse(countdown,dialog,message,true)
      end
    end
    return content
end

function response:setDialogs(dialogs,message,countdown)
  local args = {}
  for i,v in pairs(dialogs) do
    if v.input.name then
     countdown = countdown or 20
     local status = response:sayResponse(countdown,v,message)
     if status == "Cancelled" then
        message.channel:sendMessage("**Cancelled prompt.**")
        return nil
      end
     args[v.input.name] = status
    end
  end
  return args 
end


return response