-- Made by KanerSPS

-- Modified by c7a1 and Zaedred


local db = require '../common/db.lua'
local POST_database = 'essentialsmode/_find'
local PUT_database = 'essentialsmode'
local queryData = '{selector = {["identifier"] = ' .. identifier .. '}, fields = {"_rev", "_id", "identifier", "bank", "money", "group", "permission_level"}}'


function LoadUser(identifier, source)
  local new = false
  queryData = '{selector = {["identifier"] = ' .. identifier .. '}, fields = {"_rev", "_id", "identifier", "bank", "money", "group", "permission_level"}}'
  db.POSTData(function(exist, rText)
      if exist then
        new = false
      else
        new = true
      end
      local group = groups[rText["group"]]

      Users[source] = Player(source, user.permission_level, user.money, user.bank, user.identifier, group)

      TriggerEvent('es:playerLoaded', source, Users[source])

      TriggerClientEvent('es:setPlayerDecorator', source, 'rank', Users[source]:getPermissions())
      TriggerClientEvent('es:setMoneyIcon', source,settings.defaultSettings.moneyIcon)

      if(new)then
        TriggerEvent('es:newPlayerLoaded', source, Users[source])
      end
    end,PUT_database,queryData)
end

function stringsplit(self, delimiter)
  local a = self:Split(delimiter)
  local t = {}

  for i = 0, #a - 1 do
    table.insert(t, a[i])
  end

  return t
end

AddEventHandler('es:getPlayers', function(callback)
    callback(Users)
  end)

function registerUser(identifier, source)
  LoadUser(identifier, source)
end

AddEventHandler("es:setPlayerData", function(user, k, v, callback)
    if(Users[user])then
      if(Users[user][k])then

        if(k ~= "money") then
          Users[user][k] = v
          queryData = json.encode({ _rev = user._rev, identifier = user.identifier, money = (new.money or user.money), bank = (new.bank or user.bank), group = (new.group or user.group), permission_level = (new.permission_level or user.permission_level) })
          db.POSTData(
            function(exist, rText)
              for i in pairs({[k] = v})do
              user[i] = update[i]
            end
            queryData = json.encode(user)
            db.PUTData(rText['_id'],
              function(exist, rText)
                if not exist then
                  callback('Error importing data to the Database!')
                end
              end,PUT_Database, queryData)
          end,POST_database,queryData)
      end
      if(k == "group")then
        Users[user].group = groups[v]
      end
    else
      callback("Column does not exist!")
    end
  else
    callback("User could not be found!")
  end
end)

AddEventHandler("es:setPlayerDataId", function(user, k, v, callback)
    queryData = json.encode({ _rev = user._rev, identifier = user.identifier, money = (new.money or user.money), bank = (new.bank or user.bank), group = (new.group or user.group), permission_level = (new.permission_level or user.permission_level) })
    db.POSTData(
      function(exist, rText)
        for i in pairs({[k] = v})do
        user[i] = update[i]
      end
      queryData = json.encode(user)
      db.PUTData(rText['_id'],
        function(exist, rText)
          if not exist then
            callback('Error importing data to the Database!')
          end
        end,PUT_Database, queryData)
    end,POST_database,queryData)
end)

AddEventHandler("es:getPlayerFromId", function(user, callback)
    if(Users)then
      if(Users[user])then
        callback(Users[user])
      else
        callback(nil)
      end
    else
      callback(nil)
    end
  end)

AddEventHandler("es:getPlayerFromIdentifier", function(identifier, callback)
    db.retrieveUser(identifier, function(user)
        callback(user)
      end)
  end)

-- Function to update player money every 60 seconds.
local function savePlayerMoney()
  SetTimeout(60000, function()
      TriggerEvent("es:getPlayers", function(users)
          for k,v in pairs(users)do
          queryData = json.encode({ _rev = user._rev, identifier = user.identifier, money = (new.money or user.money), bank = (new.bank or user.bank), group = (new.group or user.group), permission_level = (new.permission_level or user.permission_level) })
          db.POSTData(
            function(exist, rText)
              for i in pairs({money = v.money})do
              user[i] = update[i]
            end
            queryData = json.encode(user)
            db.PUTData(v.identifier,
              function(exist, rText)
                if not exist then
                  print('Error importing data to the Database!')
                end
              end,PUT_Database, queryData)
          end,POST_database,queryData)
      end
    end)

  savePlayerMoney()
end)
end

savePlayerMoney()