local users = {}

AddEventHandler('es:playerLoaded', function(source, user)
  db.getUser(user.identifier, function(freeroamuser)
    users[source] = freeroamuser
  end)
end)

RegisterServerEvent('CheckMoneyForVeh')
AddEventHandler('CheckMoneyForVeh', function(vehicle, price)
	TriggerEvent('es:getPlayerFromId', source, function(user)

	if (tonumber(user.money) >= tonumber(price)) then
    local player = user.identifier
    print(player)
			-- Pay the shop (price)
			user:removeMoney((price))
      -- Save this shit to the database
      db.updateUser(player, {personalvehicle = vehicle}, function()
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
    db.createDocument("es_freeroam", {identifier = identifier, personalvehicle = ""}, function()end)
  end

  created[source] = true
end)
