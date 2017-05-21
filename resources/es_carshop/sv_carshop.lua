local plugin_data = {}
local vehicle_data = {}
local plates = {}
local vOptions = {}
local POST_database = 'es_carshop/_find'
local PUT_database = 'es_carshop'
local queryData = '{selector = {["identifier"] = '..target.identifier..'}}'

AddEventHandler("es:playerLoaded", 
  function(source, target) 
    queryData = {selector = {["identifier"] = target.identifier}}
    db.POSTData(
      function(docs)
        if docs then
          local send = {}
          for k,v in ipairs(docs[1].identifier)do
          send[v.model] = true
        end
        TriggerClientEvent("es_carshop:sendOwnedVehicles", source, send)
      end
    end, POST_database, queryData)
end)

function get3DDistance(x1, y1, z1, x2, y2, z2)
  return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

local plates = {}
local plate_possibilities = {"Expired license",	"Stolen vehicle",	"Unregistered plate", "Warrant for owner"}

TriggerEvent('es:addCommand', 'checkplate', function(source, args, user)
    TriggerEvent("es_roleplay:getPlayerJob", function(job)
        if(job or (tonumber(user.permission_level) > 2))then
          if(not #args == 2)then
            TriggerClientEvent('chatMessage', source, "JOB", {255, 0, 0}, "Usage: ^2/checkplate (PLATE)")
            return
          end

          if(job.job == "police" or tonumber(user.permission_level) > 2)then
            local plate = args[2]

            plate = string.lower(plate)

            if plate == "reborn" then
              TriggerClientEvent('chatMessage', source, "JOB", {255, 0, 0}, "Plate returns: ^1just reported stolen.")
              return
            end

            if(#plate ~= 8)then
              TriggerClientEvent('chatMessage', source, "JOB", {255, 0, 0}, "Invalid plate.")
              return
            end

            TriggerEvent('es_carshop:getVehicleOwner', plate, function(owner, veh)
                local returns = ""

                if(owner)then
                  TriggerClientEvent('es_roleplay:checkCar', source, owner, plate, veh[1])
                  return;
                else
                  returns = "^1STOLEN"
                end

                TriggerClientEvent('chatMessage', source, "JOB", {255, 0, 0}, "Plate returns: " .. returns .. "")
              end)
          else
            TriggerClientEvent('chatMessage', source, "JOB", {255, 0, 0}, "You need to be police.")
          end
        else
          TriggerClientEvent('chatMessage', source, "JOB", {255, 0, 0}, "You need to be police.")
        end
      end)
  end)

local carshops = {
  {['x'] = 1696.66, ['y'] = 3607.99, ['z'] = 35.36},
  {['x'] = -796.17, ['y'] = 300.94, ['z'] = 85.70},
  {['x'] = -673.44, ['y'] = -2390.78, ['z'] = 13.89},
  {['x'] = -15.20, ['y'] = -1082.81, ['z'] = 26.67},
  {['x'] = -28.65, ['y'] = -1680.18, ['z'] = 29.45},
  {['x'] = 1181.78, ['y'] = 2655.33, ['z'] = 37.82},
  {['x'] = -1212.95, ['y'] = -364.35, ['z'] = 37.28},
  {['x'] = -1080.71	, ['y'] = -1252.78, ['z'] = 5.41},
  { ['x'] = 248.57885742188, ['y'] = -3062.1379394531, ['z'] = 5.7798938751221 },
  { ['x'] = 348.42904663086, ['y'] = 350.54934692383, ['z'] = 105.10478210449 },
  { ['x'] = -2173.6982421875, ['y'] = -411.58480834961, ['z'] = 13.279825210571 },
  { ['x'] = 893.73767089844, ['y'] = -68.683937072754, ['z'] = 78.764297485352 },
  { ['x'] = -94.009635925293, ['y'] = 89.803314208984, ['z'] = 71.803337097168 },
  { ['x'] = 2665.8696289063, ['y'] = 1671.4300537109, ['z'] = 24.487155914307 },
  { ['x'] = 1983.103515625, ['y'] = 3773.9240722656, ['z'] = 32.180919647217 },
  { ['x'] = 124.32480621338, ['y'] = 6613.2944335938, ['z'] = 31.855966567993 },
  { ['x'] = -242.36260986328, ['y'] = 6196.7661132813, ['z'] = 31.489208221436 },
  { ['x'] = 130.98764038086, ['y'] = 6369.3666992188, ['z'] = 31.297519683838 },
  { ['x'] = 233.69268798828, ['y'] = -788.97814941406, ['z'] = 30.605836868286 },
  { ['x'] = -1115.3034667969, ['y'] = -2004.0853271484, ['z'] = 13.171050071716 },
}

local carshop_vehicles = {
  ['dominator'] = 50000,
  ['mule'] = 2000,
  ['police2'] = 2000,
  ['ninef'] = 250000,
  ['ninef2'] = 300000,
  ['prairie'] = 15000,
  ['gauntlet'] = 55000,
  ['voodoo2'] = 15000,
  ['bfinjection'] = 25000,
  ['rebel'] = 25000,
  ['cognoscenti'] = 200000,
  ['emperor'] = 18000,
  ['ingot'] = 19000,
  ['rancherxl'] = 20000,
  ['alpha'] = 500000,
  ['banshee'] = 300000,
  ['blista2'] = 17000,
  ['comet2'] = 200000,
  ['elegy2'] = 150000,
  ['schwarzer'] = 110000,
  ['tornado2'] = 16000,
  ['ztype'] = 6000000,
  ['adder'] = 8000000,
  ['fmj'] = 10000000,
  ['baller3'] = 120000,
}

local spawned_vehicles = {}

AddEventHandler("es:reload", function()
    TriggerEvent('es:getPlayers', function(players)
        for i,v in pairs(players) do
          if(GetPlayerName(i))then
            TriggerEvent('es:getPlayerFromId', i, 
              function(target)
                queryData = {selector = {["identifier"] = target.identifier}}
                db.POSTData(
                  function(docs)
                    local send = {}
                    for k,v in ipairs(docs)do
                    send[v.model] = true
                  end
                  TriggerClientEvent("es_carshop:sendOwnedVehicles", i, send)
                end,
                POST_Database, queryData)
            end)
        end
      end
    end)
end)

AddEventHandler('es_carshop:getVehicleOwner', function(pl, cb)
    if(plates[pl])then
      TriggerEvent('es:getPlayerFromId', plates[pl], function(user)
          if(user)then
            cb(plates[pl], vehicle_data[plates[pl]])
          else
            cb(plates[pl], nil)
          end
        end)
    else
      cb(plates[pl], nil)
    end
  end)

AddEventHandler("onResourceStart", function(rs)
    if(rs ~= 'es_carshop')then
      return
    end
    SetTimeout(2000, function()
        TriggerEvent('es:getPlayers', function(players)
            for i,v in pairs(players) do
              if(GetPlayerName(i))then
                local send = {}
                TriggerEvent('es:getPlayerFromId', i, 
                  function(target)
                    queryData = {selector = {["identifier"] = target.identifier}}
                    db.POSTData(
                      function(docs)
                        for k,v in ipairs(docs[i])do
                        send[v.model] = true
                      end

                    end,
                    POST_Database, queryData)
                end)
              TriggerClientEvent("es_carshop:sendOwnedVehicles", i, send)
            end
          end
        end)
    end)
end)

TriggerEvent('es:addCommand', 'deletevehicle', function(source, args, user)
    TriggerClientEvent('es_carshop:removeVehiclesDeleting', source)
  end)

RegisterServerEvent('es_carshop:vehicleRemoved')
AddEventHandler('es_carshop:vehicleRemoved', function()
    spawned_vehicles[source] = nil
  end)

function deletePlate(pl)
  plates[pl] = nil
end

AddEventHandler('playerDropped', function()
    spawned_vehicles[source] = nil
  end)

RegisterServerEvent('es_carshop:buyVehicle')
AddEventHandler('es_carshop:buyVehicle', function(veh)
    if(spawned_vehicles[source] ~= nil)then
      TriggerClientEvent('es_carshop:closeWindow', source)
      TriggerClientEvent('chatMessage', source, "SHOP", {255, 0, 0}, "You seem to still have a car out there, please delete that one first with ^2/deletevehicle")
      return
    end

    TriggerEvent('es:getPlayerFromId', source, function(user)
        TriggerEvent('es_roleplay:getPlayerJob', user.identifier, function(job)
            if(veh == "police2")then
              if(job)then
                if(job.job ~= "police")then
                  TriggerClientEvent('es_carshop:closeWindow', source)
                  TriggerClientEvent('chatMessage', source, "SHOP", {255, 0, 0}, "You can only spawn/buy this vehicle as ^2police^0.")
                  return
                end
              else
                TriggerClientEvent('es_carshop:closeWindow', source)
                TriggerClientEvent('chatMessage', source, "SHOP", {255, 0, 0}, "You can only spawn/buy this vehicle as ^2police^0.")
                return
              end
            end

            if(veh == "mule")then
              if(job)then
                if(job.job ~= "trucker")then
                  TriggerClientEvent('es_carshop:closeWindow', source)
                  TriggerClientEvent('chatMessage', source, "SHOP", {255, 0, 0}, "You can only spawn/buy this vehicle as ^2trucker^0.")
                  return
                end
              else
                TriggerClientEvent('es_carshop:closeWindow', source)
                TriggerClientEvent('chatMessage', source, "SHOP", {255, 0, 0}, "You can only spawn/buy this vehicle as ^2trucker^0.")
                return
              end
            end

            for k,v in carshops do
              if(get3DDistance(v.x, v.y, v.z, user.coords.x, user.coords.y, user.coords.z) < 2.0)then
                return
              end
            end

            if(vehicle_data[source])then
              for k,v in ipairs(vehicle_data[source]) do
                if(v.owner == user.identifier and veh == v.model)then
                  TriggerClientEvent('es_carshop:closeWindow', source)
                  TriggerClientEvent('chatMessage', source, "SHOP", {255, 0, 0}, "Owned vehicle spawned.")
                  TriggerClientEvent('es_carshop:removeVehicles', source)
                  if(v.model == "police2" or v.model == "mule")then
                    v.colour = "255,255,255"
                  end
                  TriggerClientEvent('es_carshop:createVehicle', source, veh, { main_colour = stringsplit(v.colour, ","), secondary_colour = stringsplit(v.scolour, ","), plate = v.plate, wheels = v.wheels, windows = v.windows, platetype = v.platetype, exhausts = v.exhausts, grills = v.grills, spoiler = v.spoiler }  )
                  spawned_vehicles[source] = true
                  plates[string.lower(v.plate)] = source
                  return
                end
              end
            end


            if(carshop_vehicles[veh])then
              local price = carshop_vehicles[veh]

              if(tonumber(user.money) >= price)then
                user:removeMoney(price)
                TriggerClientEvent('es_carshop:closeWindow', source)
                TriggerClientEvent('chatMessage', source, "SHOP", {255, 0, 0}, "Vehicle bought!")
                TriggerClientEvent('es_carshop:sendOwnedVehicle', source, veh)
                addVehicle(source, veh)
                spawned_vehicles[source] = true
              else
                TriggerClientEvent('chatMessage', source, "SHOP", {255, 0, 0}, "You do not have enough cash.")
              end
            end
          end)
      end)
  end)

local spawned_vehicles = {}

RegisterServerEvent('es_carshop:newVehicleSpawned')
AddEventHandler('es_carshop:newVehicleSpawned', function(veh)
    if(spawned_vehicles[source])then
      if(spawned_vehicles[source] ~= veh)then
        TriggerClientEvent('es_carshop:removeNetworkVehicle', -1, spawned_vehicles[source])
        spawned_vehicles[source] = veh
      end
    else
      spawned_vehicles[source] = veh
    end
  end)

local limiter = {}

RegisterServerEvent('es_carshop:vehicleCustom')
AddEventHandler('es_carshop:vehicleCustom', function(model, data)
    if(true)then
      if(spawned_vehicles[source] ~= nil)then
        local pstring = "" .. data.r .. "," .. data.g .. "," .. data.b
        local sstring = "" .. data.r2 .. "," .. data.g2 .. "," .. data.b2
        if(vehicle_data[source] ~= nil)then
          for k,v in ipairs(vehicle_data[source])do
          if(v.model == model)then
            if(limiter[source] == nil)then
              limiter[source] = 0
            end
            if(limiter[source] < os.time())then
              TriggerEvent("es:getPlayerFromId", source, function(user)
                  limiter[source] = os.time() + 60
                  user:removeMoney(1500)
                  vehicle_data[source][k].colour = pstring
                  vehicle_data[source][k].scolour = sstring

                  vehicle_data[source][k].wheels = data.wheels
                  vehicle_data[source][k].windows = data.windows
                  vehicle_data[source][k].platetype = data.platetype
                  vehicle_data[source][k].exhausts = data.dexhausts
                  vehicle_data[source][k].grills = data.grills
                  vehicle_data[source][k].spoiler = data.spoiler

                  vOptions = {
                    {row = "colour", value = pstring},
                    {row = "scolour", value = sstring},
                    {row = "wheels", value = data.wheels},
                    {row = "windows", value = data.windows},
                    {row = "platetype", value = data.platetype},
                    {row = "exhausts", value = data.exhausts},
                    {row = "grills", value = data.grills},
                    {row = "spoiler", value = data.spoiler}
                  }
                  setDynamicMulti(source, model, vOptions)

                  TriggerClientEvent('chatMessage', source, "CUSTOMS", {255, 0, 0}, "Vehicle customization has been saved. Your customization options will now stay forever until changed.")
                end)
            else
              TriggerClientEvent('chatMessage', source, "CUSTOMS", {255, 0, 0}, "You can save your vehicle again in ^2^*" .. (limiter[source] - os.time()) .. " ^r^0seconds.")
            end
          end
        end
      end
    else
      TriggerClientEvent("chatMessage", source, "CUSTOMS", {255, 0, 0}, "You do not have a spawned vehicle to save.")
    end
  end 
end)

function setDynamicMulti(source, vehicle, options)
  for k,v in ipairs(options)do
  str = str .. ',"' .. v.row .. '":"' .. v.value .. '"'
end
TriggerEvent('es:getPlayerFromId', source, 
  function(user)
    local queryData = '{selector = {["identifier"] = '..user.identifier..',["model"] = ' .. vehicle   ..' }}'
    db.POSTData(
      function(docs) 
        if docs then
          queryData = '{ "_rev":' .. docs[1]._rev .. ',"owner":"'.. user.identifier..'", "model": '..vehicle..',' .. str .. "}"
          db.PUTData(docs[1]._id,function()end,PUT_Database,queryData)
        else
          print("No record found in database. Creating one.")
          db.GETData("",
            function(uuid)
              if uuid then
                db.PUTData(uuid,
                  function(success)
                    if not success then
                      print('Error importing data to the Database!')
                    else
                      queryData = '{ "owner":"' .. user.identifier .. '",  "model": ' .. vehicle .. ',' .. str .. "}"
                    end
                  end,
                  PUT_Database, queryData)
              end
            end,
            '_uuids')
        end
      end, POST_database, queryData)
  end)
end

function addVehicle(s, v)
  TriggerEvent('es:getPlayerFromId', s, function(user)
      local plate = generatePlate(8)
      TriggerClientEvent('es_carshop:removeVehicles', source)
      TriggerClientEvent('es_carshop:createVehicle', source, v, { main_colour = stringsplit("0,0,0", ","), secondary_colour = stringsplit("0,0,0", ","), plate = plate, wheels = v.wheels, windows = v.windows, platetype = v.platetype, exhausts = v.exhausts, grills = v.grills, spoiler = v.spoiler })

      if(vehicle_data[s] == nil)then
        vehicle_data[s] = {}
        vehicle_data[s][1] = {owner = user.identifier, model = v, colour = '0,0,0', scolour = '0,0,0', plate = plate, wheels = 0, windows = 0, platetype = 0, exhausts = 0, grills = 0, spoiler = 0}
      else
        vehicle_data[s][#vehicle_data[s] + 1] = {owner = user.identifier, model = v, colour = '0,0,0', scolour = '0,0,0', plate = plate, wheels = 0, windows = 0, platetype = 0, exhausts = 0, grills = 0, spoiler = 0}
      end

      vOptions = {
        {row = "colour", value = '0,0,0'},
        {row = "scolour", value = '0,0,0'},
        {row = "plate", value = plate},
        {row = "wheels", value = 0},
        {row = "windows", value = 0},
        {row = "platetype", value = 0},
        {row = "exhausts", value = 0},
        {row = "grills", value = 0},
        {row = "spoiler", value = 0}
      }
      setDynamicMulti(s, v, vOptions)

      plates[string.lower(plate)] = s
    end)
end

-- Util function stuff
function stringsplit(self, delimiter)
  local a = self:Split(delimiter)
  local t = {}

  for i = 0, #a - 1 do
    table.insert(t, a[i])
  end

  return t
end

local charset = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","1","2","3","4","5","6","7","8","9"}

function generatePlate(length)
  if length > 0 then
    return generatePlate(length - 1) .. charset[math.random(1, #charset)]
  else
    return ""
  end
end
