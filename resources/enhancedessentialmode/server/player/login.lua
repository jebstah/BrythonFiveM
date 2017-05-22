-- Made by KanerSPS

-- Modified by c7a1 and Zaedred

local POST_database = 'essentialmode/_find'
local PUT_database = 'essentialmode'
local POSTqueryData = {}
local PUTqueryData = {}

function LoadUser(identifier, source, new)
  POSTqueryData = {selector = {["identifier"] = identifier}, fields = {"_rev", "_id", "identifier", "bank", "money", "group", "permission_level"}}
  db.POSTData(function(docs)
      local group = groups[docs[1].group]

      Users[source] = Player(source, user.permission_level, user.money, user.bank, user.identifier, group)

      TriggerEvent('es:playerLoaded', source, Users[source])

      TriggerClientEvent('es:setPlayerDecorator', source, 'rank', Users[source]:getPermissions())
      TriggerClientEvent('es:setMoneyIcon', source,settings.defaultSettings.moneyIcon)

      if(new)then
        TriggerEvent('es:newPlayerLoaded', source, Users[source])
      end
    end,POST_database,POSTqueryData)
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
  POSTqueryData = {selector = {["identifier"] = identifier}}
  db.POSTData(function(doc)
      if (doc) then
        LoadUser(identifier, source, false)
      else
        db.GETData(
          function(uuid)
            PUTqueryData = { identifier = identifier, money = 0, bank = 0, group = "user", permission_level = 0 }
            db.PUTData(uuid, 
              function(success)
                if success then
                  LoadUser(identifier, source, true)
                end
              end, PUT_database, PUTqueryData)
          end, '_uuids')
      end
    end, POST_database,POSTqueryData)
end

AddEventHandler("es:setPlayerData", function(user, k, v, callback)
    if(Users[user])then
      if(Users[user][k])then

        if(k ~= "money") then
          Users[user][k] = v
          POSTqueryData = { 
            _rev = user._rev,
            identifier = user.identifier,
            money = (new.money or user.money),
            bank = (new.bank or user.bank),
            group = (new.group or user.group),
            permission_level = (new.permission_level or user.permission_level)
          }
          db.POSTData(
            function(docs)
              if docs then
                for i in pairs({[k] = v})do
                user[i] = update[i]
              end
              PUTqueryData = user
              db.PUTData(docs[1]._id,
                function(success)
                  if not success then
                    print('Error importing data to the Database!')
                  end
                end,PUT_Database, PUTqueryData)
            end
          end,POST_database,POSTqueryData)
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
    PUTqueryData = { 
      _rev = user._rev,
      identifier = user.identifier,
      money = (new.money or user.money),
      bank = (new.bank or user.bank),
      group = (new.group or user.group),
      permission_level = (new.permission_level or user.permission_level)
    }
    POSTqueryData = {selector = {["identifier"] = identifier}}
    db.POSTData(
      function(docs)
        for i in pairs({[k] = v})do
        user[i] = update[i]
      end
      PUTqueryData = user
      db.PUTData(docs[1]._id,
        function(success)
          if not success then
            print('Error importing data to the Database!')
          end
        end,PUT_Database, PUTqueryData)
    end,POST_database,POSTqueryData)
end)

AddEventHandler("es:getPlayerFromId", function(user, cb)
    if(Users)then
      if(Users[user])then
        cb(Users[user])
      else
        cb(nil)
      end
    else
      cb(nil)
    end
  end)

AddEventHandler("es:getPlayerFromIdentifier", function(identifier, callback)
    POSTqueryData = {selector = {["identifier"] = identifier}, fields = {"_rev", "_id", "identifier", "bank", "money", "group", "permission_level"}}
    db.POSTData(
      function(docs)
        callback(docs[1])
      end,POST_database,POSTqueryData)
  end)

-- Function to update player money every 60 seconds.
local function savePlayerMoney()
  SetTimeout(60000, function()
      TriggerEvent("es:getPlayers", function(users)
          for k,v in pairs(users)do
          PUTqueryData = { 
            _rev = v._rev,
            identifier = v.identifier,
            money = (v.money),
            bank = (v.bank),
            group = (v.group),
            permission_level = (v.permission_level)
          }
          db.POSTData(
            function(docs)
            db.PUTData(docs[1]._id,
              function(success)
                if not success then
                  print('Error importing data to the Database!')
                end
              end,PUT_Database, PUTqueryData)
          end,POST_database, POSTqueryData)
      end
    end)

  savePlayerMoney()
end)
end

savePlayerMoney()