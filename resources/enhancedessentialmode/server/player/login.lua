-- Made by KanerSPS

-- Modified by c7a1 and Zaedred

local POST_database = 'essentialmode/_find'
local PUT_database = 'essentialmode'
local queryData = {}

function LoadUser(identifier, source, new)
  queryData = {selector = {["identifier"] = identifier}, fields = {"_rev", "_id", "identifier", "bank", "money", "group", "permission_level"}}
  db.POSTData(
    function(docs)
      local group = groups[docs[1].group]

      Users[source] = Player(source, docs[1].permission_level, docs[1].money, docs[1].bank, docs[1].identifier, group)

      TriggerEvent('es:playerLoaded', source, Users[source])

      TriggerClientEvent('es:setPlayerDecorator', source, 'rank', Users[source]:getPermissions())
      TriggerClientEvent('es:setMoneyIcon', source,settings.defaultSettings.moneyIcon)

      if(new)then
        TriggerEvent('es:newPlayerLoaded', source, Users[source])
      end
    end,POST_database,queryData)
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
  print("calling registerUser POSTData func")
  db.POSTData(function(doc)
      print(json.encode(doc))
      if (doc) then
        print("calling LoadUser func")
        LoadUser(identifier, source, false)
      else
        print("calling registerUser GETData func")
        print(json.encode(queryData))
        db.GETData(
          function(uuid)
            queryData = { identifier = identifier, money = 0, bank = 0, group = "user", permission_level = 0 }
            print("calling registerUser PUTData func")
            print(json.encode(queryData))
            db.PUTData(uuid[1], 
              function(success)
                if success then
                  LoadUser(identifier, source, true)
                end
              end, PUT_database, queryData)
          end, '_uuids')
      end
    end, POST_database, { selector = {["identifier"] = identifier }})
end

AddEventHandler("es:setPlayerData", function(user, k, v, callback)
    if(Users[user])then
      if(Users[user][k])then

        if(k ~= "money") then
          Users[user][k] = v

          db.POSTData(
            function(docs)
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
                  end,PUT_Database, queryData)
              end
            end,POST_database,{selector = {["identifier"] = Users[user].identifier }} )
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
    db.POSTData(
      function(docs)
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
            end,PUT_Database, queryData)
        end
      end,POST_database,{selector = {["identifier"] = user }})
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
    db.POSTData(
      function(docs)
        callback(docs[1])
      end,POST_database,queryData)
  end)

-- Function to update player money every 60 seconds.
local function savePlayerMoney()
  SetTimeout(60000, function()
      TriggerEvent("es:getPlayers", function(users)
          for k,v in pairs(users)do
          db.POSTData(
            function(docs)
              if docs then
                new = {money = v.money}
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
                  end,PUT_Database, queryData)
              end
            end,POST_database,{selector = {["identifier"] = v.identifier }})
        end
      end)

    savePlayerMoney()
  end)
end

savePlayerMoney()