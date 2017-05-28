-- Made by KanerSPS

-- Modified by c7a1 and Zaedred

local database = 'essentialmode'
local queryData = {}

function registerUser(identifier, source)
  local docs = false

  db.findDocument(function(docs)
      if (docs) then
        local group = groups[docs[1].group]
        Users[source] = Player(source, docs[1].permission_level, docs[1].money, docs[1].bank, docs[1].identifier, group)
        TriggerEvent('es:playerLoaded', source, Users[source])
        TriggerClientEvent('es:setPlayerDecorator', source, 'rank', Users[source]:getPermissions())
        TriggerClientEvent('es:setMoneyIcon', source,settings.defaultSettings.moneyIcon)
      else
        queryData = { ["identifier"] = identifier, ["money"] = 0, ["bank"] = 0, ["group"] = "user", ["permission_level"] = 0 }
        db.createDocument(function(docs)
            if docs then
              local group = groups[docs[1].group]
              Users[source] = Player(source, docs[1].permission_level, docs[1].money, docs[1].bank, docs[1].identifier, group)
              TriggerEvent('es:playerLoaded', source, Users[source])
              TriggerClientEvent('es:setPlayerDecorator', source, 'rank', Users[source]:getPermissions())
              TriggerClientEvent('es:setMoneyIcon', source,settings.defaultSettings.moneyIcon)
              TriggerEvent('es:newPlayerLoaded', source, Users[source])
            end
          end, database, queryData)
      end
    end, database, { selector = {["identifier"] = identifier }})
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
          new = {[k] = v}
          db.modifyDocument(function(success)
              if not success then
                callback("Error creating document")
              end
            end,database, {selector = {["identifier"] = Users[user].identifier }}, new)
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
    new = {[k] = v}
    db.modifyDocument(function(success)
        if not success then
          callback("Error creating document")
        end
      end,
      database, {selector = {["identifier"] = Users[user].identifier }}, new)
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
    db.findDocument(
      function(docs)
        callback(docs)
      end,database,queryData)
  end)

-- Function to update player money every 60 seconds.
local function savePlayerMoney()
  SetTimeout(60000, function()
      TriggerEvent("es:getPlayers", function(users)
          for k,v in pairs(users)do
          new = {["money"] = v.money}
          db.modifyDocument(function(success)
              if not success then
                print("Error creating document")
              end
            end,database, {selector = {["identifier"] = v.identifier }}, new)
        end
      end)
    savePlayerMoney()
  end)
end

savePlayerMoney()