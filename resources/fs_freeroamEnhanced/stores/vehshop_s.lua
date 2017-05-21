-- Modified by c7a1 and Zaedred

local users = {}

local db = require '../common/db.lua'
local POST_database = 'es_freeroam/_find'
local PUT_database = 'es_freeroam'
local queryData = '{selector = {["identifier"] = '..target.identifier..'}}'

AddEventHandler('es:playerLoaded', function(source, user)
    queryData = '{selector = {["identifier"] = '..user.identifier..'}}'
    db.POSTData(
      function(exist, rText)
        users[source] = rText["id"]
      end,"es_freeroam",queryData)
  end)

RegisterServerEvent('CheckMoneyForVeh')
AddEventHandler('CheckMoneyForVeh', function(vehicle, price)
    TriggerEvent('es:getPlayerFromId', source, 
      function(user)
        if (tonumber(user.money) >= tonumber(price)) then
          local player = user.identifier
          print(player)
          -- Pay the shop (price)
          user:removeMoney((price))
          -- Save this shit to the database
          db.GETData("",
            function(exist, rText)
              for i in pairs({personalvehicle = vehicle})do
              user[i] = update[i]
            end
            queryData = json.encode(user)
            db.PUTData(rText['uuid'],
              function(exist, rText)
                if not exist then
                  print('Error importing data to the Database!')
                end
              end,PUT_Database, queryData)
          end,'_uuids')
        -- Trigger some client stuff
        TriggerClientEvent('FinishMoneyCheckForVeh',source)
        TriggerClientEvent("es_freeroam:notify", source, "CHAR_SIMEON", 1, "Simeon", false, "Drive safe with this new car, this is not Carmageddon!\n")
      end)
  else
    -- Inform the player that he needs more money
    TriggerClientEvent("es_freeroam:notify", source, "CHAR_SIMEON", 1, "Simeon", false, "You dont have enough cash to buy this car!\n")
  end
end)
end)

-- Spawn the personal vehicle
TriggerEvent('es:addCommand', 'pv', function(source, user)
    local vehicle = users[source].personalvehicle
    TriggerClientEvent('vehshop:spawnVehicle', source, vehicle)
  end)

local created = {}

AddEventHandler('es:newPlayerLoaded', function(source, user)
    local identifier = user.identifier

    if created[source] == nil then
      print('test creating acc ' .. tostring(created[source]))
      db.GETData("",
        function(exist, rText)
          if exists then
            db.PUTData(rText['uuid'],
              function(exist, rText)
                if not exist then
                  print('Error importing data to the Database!')
                else
                  created[source] = true
                  queryData = '{"identifier" = ' .. identifier .. ', personalvehicle = ""}'
                end
              end,PUT_Database, queryData)
          end
        end,'_uuids')
    end
  end)