-- Made by KanerSPS

-- Modified by c7a1 and Zaedred

local database = 'essentialmode'
local queryData = {}

function registerUser(identifier, source)
  print("Entering register user...")
  db.findDocument(function(docs)
      print("Register user docs: " .. json.encode(docs))
      if (docs) then
        local group = groups[docs.group]
        Users[source] = Player(source, docs.permission_level, docs.money, docs.bank, docs.identifier, group)
         print("Register user variable: " .. json.encode(Users[source]))
        TriggerEvent('es:playerLoaded', source, Users[source])
        TriggerClientEvent('es:setPlayerDecorator', source, 'rank', Users[source]:getPermissions())
        TriggerClientEvent('es:setMoneyIcon', source,settings.defaultSettings.moneyIcon)
      else
        queryData = { ["identifier"] = identifier, ["money"] = 0, ["bank"] = 0, ["group"] = "user", ["permission_level"] = 0 }
        db.createDocument(function(createDocs)
            if createDocs then
              local group = groups[createDocs.group]
              Users[source] = Player(source, createDocs.permission_level, createDocs.money, createDocs.bank, createDocs.identifier, group)
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
    print("setPlayerData")
    if(Users[user])then
      if(Users[user][k])then
        local new = {}
        if(k ~= "money") then
          Users[user][k] = v
          new[k] = v
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
    local new
    new[k] = v
    db.modifyDocument(function(success)
        if not success then
          callback("Error creating document")
        end
      end,
      database, {selector = {["identifier"] = Users[user].identifier }}, new)
  end)

AddEventHandler("es:getPlayerFromId", function(user, cb)
      cb(Users[user])
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
          print(json.encode({money = v.money}) .. " " .. v.identifier)
          db.modifyDocument(function(success)
              if not success then
                print("Error updating document")
              end
            end,database, {selector = {["identifier"] = v.identifier }}, {money = v.money})
        end
      end)
    savePlayerMoney()
  end)
end

savePlayerMoney()