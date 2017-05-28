-- Made by KanerSPS

-- Modified by c7a1 and Zaedred

local POST_database = 'essentialmode/_find'
local PUT_database = 'essentialmode'
local queryData = {}

function registerUser(identifier, source)
  local docs = false
  db.POSTData(
    function(val)
      if (val) then
        docs = val
      end
    end, POST_database, { selector = {["identifier"] = identifier }})

  if (docs) then
    local group = groups[docs[1].group]
    Users[source] = Player(source, docs[1].permission_level, docs[1].money, docs[1].bank, docs[1].identifier, group)
    TriggerEvent('es:playerLoaded', source, Users[source])
    TriggerClientEvent('es:setPlayerDecorator', source, 'rank', Users[source]:getPermissions())
    TriggerClientEvent('es:setMoneyIcon', source,settings.defaultSettings.moneyIcon)
  else
    local uuid = false
    db.GETData(
      function(val)
        if val then
          uuid = val
        end
      end, '_uuids')
    if uuid then
      queryData = { ["identifier"] = identifier, ["money"] = 0, ["bank"] = 0, ["group"] = "user", ["permission_level"] = 0 }
      local put = false
      db.PUTData(uuid[1], 
        function(success)
          if success then
            put = true
          end
        end, PUT_database, queryData)
      if put then
        local group = groups[queryData.group]
        Users[source] = Player(source, queryData.permission_level, queryData.money, queryData.bank, queryData.identifier, group)
        TriggerEvent('es:playerLoaded', source, Users[source])
        TriggerClientEvent('es:setPlayerDecorator', source, 'rank', Users[source]:getPermissions())
        TriggerClientEvent('es:setMoneyIcon', source,settings.defaultSettings.moneyIcon)
        TriggerEvent('es:newPlayerLoaded', source, Users[source])
      end
    end
  end
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

AddEventHandler("es:setPlayerData", function(user, k, v, callback)
    if(Users[user])then
      if(Users[user][k])then

        if(k ~= "money") then
          Users[user][k] = v

          local docs = false
          db.POSTData(
            function(val)
              if val then
                docs = val
              end
            end,POST_database,{selector = {["identifier"] = Users[user].identifier }} )
          if docs then
            new = {[k] = v}
            queryData = { 
              _rev = docs[1]._rev,
              identifier = docs[1].identifier,
              money = (new.money or docs[1].money),
              bank = (new.bank or docs[1].bank),
              group = (new.group or docs[1].group),
              permission_level = (new.permission_level or docs[1].permission_level)
            }
            db.PUTData(docs[1]._id,
              function(success)
                if not success then
                  print('Error importing data to the Database!')
                end
              end,PUT_database, queryData)
          end
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
    local docs = false
    db.POSTData(
      function(val)
        if val then
          docs = val
        end
      end,POST_database,{selector = {["identifier"] = user }})
    if docs then
      new = {[k] = v}
      queryData = { 
        _rev = docs[1]._rev,
        identifier = docs[1].identifier,
        money = (new.money or docs[1].money),
        bank = (new.bank or docs[1].bank),
        group = (new.group or docs[1].group),
        permission_level = (new.permission_level or docs[1].permission_level)
      }
      db.PUTData(docs[1]._id,
        function(success)
          if not success then
            print('Error importing data to the Database!')
          end
        end,PUT_database, queryData)

    end 
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
    queryData = {selector = {["identifier"] = identifier}, fields = {"_rev", "_id", "identifier", "bank", "money", "group", "permission_level"}}
    local docs = false
    db.POSTData(
      function(val)
        docs = val
      end,POST_database,queryData)
    callback(docs)
  end)

-- Function to update player money every 60 seconds.
local function savePlayerMoney()
  SetTimeout(60000, function()
      TriggerEvent("es:getPlayers", function(users)
          for k,v in pairs(users)do
          local docs = false
          db.POSTData(
            function(val)
              if val then
                docs = val
              end
            end,POST_database,{selector = {["identifier"] = v.identifier }})
          if docs then
            new = {["money"] = v.money}
            queryData = { 
              _rev = docs[1]._rev,
              identifier = docs[1].identifier,
              money = (new.money or docs[1].money),
              bank = (docs[1].bank),
              group = (docs[1].group),
              permission_level = (docs[1].permission_level)
            }
            db.PUTData(docs[1]._id,
              function(success)
                if not success then
                  print('Error importing data to the Database!')
                end
              end,PUT_database, queryData)
          end
        end
      end)

    savePlayerMoney()
  end)
end

savePlayerMoney()