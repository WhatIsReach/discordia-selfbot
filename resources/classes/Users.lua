local Users = {}

--[[local http = require('coro-http')
local json = require("json")
local settingsCache = {}
local fs = require('fs')
local json = require('json')
local timer = require("timer")]]

function Users:getHighestRole(user)
  local highestRole = 0
  local Roles = user.roles
  if Roles then
    for i,v in pairs(Roles) do
      local pos = v.position
      if pos > highestRole then
        highestRole = pos
      end
    end
  end
  return highestRole
end
function Users:getRoles(user)
  local roles = {}
  for role in user.roles do
    roles[role.name] = role.name
  end
  return roles
end
function Users:getHighestRole(user)
	local highestRole = 0
	local Roles = user.roles
	if Roles then
		for i,v in pairs(Roles) do
			local pos = v.position
			if pos > highestRole then
				highestRole = pos
			end
		end
	end
	return highestRole
end
function Users:comparePermissions(target,calling_user)
	local roleNumCallingUser = Users:getHighestRole(calling_user)
	local roleNumUser = class:getHighestRole(target)
	if roleNumCallingUser > roleNumUser then
		return "Success"
	elseif roleNumCallingUser < roleNumUser then
		return "Target user has a greater role than you."
	elseif roleNumCallingUser == roleNumUser then
		return "Target user has an equivalent highest role."
	end
end
function Users:find(user,server)
  if not server then return end
  if not user then return end
  if type(user) == "table" then
		if #user <=2 then
			for i,v in pairs(user) do
				if v.username and v.id ~= "225079733799485441" then
     			return v
  			end
			end
		end
	end
  for member in server.members do
    local distance = _G.class.Utilities:matchString(user,member.username)
    if member.id == user or distance <= 1 then
      return member
    end
  end
  for member in server.bannedUsers do
    local distance = _G.class.Utilities:matchString(user,member.username)
    if member.id == user or distance <= 1 then
      return member
    end
  end	
end
 
function Users:mute(member)
	local guild = member.guild
	local role = guild:getRole("name","TigerMuted") or guild:createRole()
	if role.name ~= "TigerMuted" then
		role.name = "TigerMuted"
		role:disableAllPermissions()
	end
	for textChannel in guild.textChannels do
		local overwrite = textChannel:getPermissionOverwriteFor(role)
		local denied = overwrite:getDeniedPermissions()
		denied:enable('sendMessages')
		overwrite:setDeniedPermissions(denied)
	end
	member:addRoles(role)
	member:setMute(true)
	return true
end
 
function Users:unmute(member)
	local guild = member.guild
	local role = guild:getRole("name","TigerMuted") or guild:createRole()
	if role.name ~= "TigerMuted" then
		role.name = "TigerMuted"
		role:disableAllPermissions()
	end
	member:removeRoles(role)
	member:setMute(false)
	return true
end
function Users:isDonor(member)
	local guild = bot:getGuild("220692750872477696")
	if not guild then return false end
	member = guild:getMemberById(member.id)
	if not member then return false end
	for role in member.roles do
		if role.name == "Donator Perks" then
			return true
		end
	end
end
return Users