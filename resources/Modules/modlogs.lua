local modlogs = {}
modlogs.__index = modlogs

function modlogs.new(channel)
  local guild = channel.guild
  local data = _G.class.Data:load("guilds",guild.id,"modlogs",{messages={},caseNumber=0,channel=""}).modlogs or {}
  p(data)
  return setmetatable({
      channel = channel,
      guild = guild,
      case = data.caseNumber or 1,
      data = data,
      modlogdata = {}
    },modlogs)
end

function modlogs:set(data)
  for i,v in pairs(data) do
   -- table.insert(self.modlogdata,"**"..i.."** ➜ "..v)
    self.modlogdata[v[1]] = v[2]
  end
end

function modlogs:setContent(data,msg)
  local newData = {}
  local function getContent()
    p(data)
    for i,v in pairs(data) do
      table.insert(newData,"**"..i.."** ➜ "..v)
    end
    return table.concat(newData,"\n")
  end
  if msg then
    msg:setContent(getContent())
  else
    return getContent()
  end
end

function modlogs:getData()
  return self
end
function modlogs:push()
  local msg = self.channel:sendMessage(modlogs:setContent(self.modlogdata))
  local newData = self.data
  --p(self.data)
  newData.messages = newData.messages or {}
  newData.messages[msg.id] = self.modlogdata
  newData.caseNumber = newData.caseNumber and newData.caseNumber + 1 or 1
  _G.class.Data:save("guilds",self.guild.id,"modlogs",newData)
end

function modlogs:getLog(guild,caseNumber)
  local data = _G.class.Data:load("guilds",guild.id,"modlogs",{messages={},caseNumber=0,channel=""}).modlogs or {}

  for i,v in pairs(data.messages) do
    if v.Case == caseNumber then 
      return i,v,data
    end
  end
end
function modlogs:updateLog(msg_id,guild,modlog,data,toChange)
  local channel = guild:getChannel(data.channel)
  if not channel then return false end
  local msg = channel:getMessage("id",msg_id)
  if not msg then return false end
  for i,v in pairs(toChange) do
    modlog[i] = v
  end
  modlogs:setContent(modlog,msg)
end


return modlogs