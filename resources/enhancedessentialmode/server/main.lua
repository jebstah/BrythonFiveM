-- Made by KanerSPS

-- Server
Users = {}
commands = {}
settings = {}
settings.defaultSettings = {
  ['pvpEnabled'] = false,
  ['permissionDenied'] = false,
  ['debugInformation'] = false,
  ['startingCash'] = 0,
  ['enableRankDecorators'] = false,
  ['moneyIcon'] = "$"
}
settings.sessionSettings = {}

AddEventHandler('playerDropped', function()
    if(Users[source])then
      TriggerEvent("es:playerDropped", Users[source])
      local docs = false
      POSTData(
        function(val)
          if val then
            docs = val
          end
        end,'essentialmode/_find', { selector = { ["identifier"] = Users[source].identifier}})
      if docs then
        queryData = { ["_rev"] = docs[1]._rev, ["_id"] = docs[1]._id, ["identifier"] = Users[source].identifier, ["money"] = Users[source].money, ["bank"] = Users[source].bank, ["group"] = groups[docs[1].group], ["permission_level"] = Users[source].permission_level}
        db.PUTData(docs[1]._id, 
          function(success)
            if not success then
              print("Issue with putting data into the database")
            end
          end,'essentialmode',queryData)
      end
      Users[source] = nil
    end
  end)

local justJoined = {}

RegisterServerEvent('es:firstJoinProper')
AddEventHandler('es:firstJoinProper', function()
    registerUser(GetPlayerIdentifiers(source)[1], source)
    justJoined[source] = true

    if(settings.defaultSettings.pvpEnabled)then
      TriggerClientEvent("es:enablePvp", source)
    end
  end)

AddEventHandler('es:setSessionSetting', function(k, v)
    settings.sessionSettings[k] = v
  end)

AddEventHandler('es:getSessionSetting', function(k, cb)
    cb(settings.sessionSettings[k])
  end)

RegisterServerEvent('playerSpawn')
AddEventHandler('playerSpawn', function()
    if(justJoined[source])then
      TriggerEvent("es:firstSpawn", source, Users[source])
      justJoined[source] = nil
    end
  end)

AddEventHandler("es:setDefaultSettings", function(tbl)
    for k,v in pairs(tbl) do
      if(settings.defaultSettings[k] ~= nil)then
        settings.defaultSettings[k] = v
      end
    end

    debugMsg("Default settings edited.")
  end)

AddEventHandler('chatMessage', function(source, n, message)
    if(startswith(message, "/"))then
      local command_args = stringsplit(message, " ")

      command_args[1] = string.gsub(command_args[1], "/", "")

      local command = commands[command_args[1]]

      if(command)then
        CancelEvent()
        if(command.perm > 0)then
          if(Users[source].permission_level >= command.perm or Users[source].group:canTarget(command.group))then
            command.cmd(source, command_args, Users[source])
            TriggerEvent("es:adminCommandRan", source, command_args, Users[source])
          else
            command.callbackfailed(source, command_args, Users[source])
            TriggerEvent("es:adminCommandFailed", source, command_args, Users[source])

            if(type(settings.defaultSettings.permissionDenied) == "string" and not WasEventCanceled())then
              TriggerClientEvent('chatMessage', source, "", {0,0,0}, defaultSettings.permissionDenied)
            end

            debugMsg("Non admin (" .. GetPlayerName(source) .. ") attempted to run admin command: " .. command_args[1])
          end
        else
          command.cmd(source, command_args, Users[source])
          TriggerEvent("es:userCommandRan", source, command_args, Users[source])
        end

        TriggerEvent("es:commandRan", source, command_args, Users[source])
      else
        TriggerEvent('es:invalidCommandHandler', source, command_args, Users[source])

        if WasEventCanceled() then
          CancelEvent()
        end
      end
    else
      TriggerEvent('es:chatMessage', source, message, Users[source])
    end
  end)

AddEventHandler('es:addCommand', function(command, callback)
    commands[command] = {}
    commands[command].perm = 0
    commands[command].group = "user"
    commands[command].cmd = callback

    debugMsg("Command added: " .. command)
  end)

AddEventHandler('es:addAdminCommand', function(command, perm, callback, callbackfailed)
    commands[command] = {}
    commands[command].perm = perm
    commands[command].group = "superadmin"
    commands[command].cmd = callback
    commands[command].callbackfailed = callbackfailed

    debugMsg("Admin command added: " .. command .. ", requires permission level: " .. perm)
  end)

AddEventHandler('es:addGroupCommand', function(command, group, callback, callbackfailed)
    commands[command] = {}
    commands[command].perm = math.maxinteger
    commands[command].group = group
    commands[command].cmd = callback
    commands[command].callbackfailed = callbackfailed

    debugMsg("Group command added: " .. command .. ", requires group: " .. group)
  end)

RegisterServerEvent('es:updatePositions')
AddEventHandler('es:updatePositions', function(x, y, z)
    if(Users[source])then
      Users[source]:setCoords(x, y, z)
    end
  end)

-- Info command
commands['info'] = {}
commands['info'].perm = 0
commands['info'].cmd = function(source, args, user)
  TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "^2[^3EssentialMode^2]^0 Version: ^23.2.3")
  TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "^2[^3EssentialMode^2]^0 Commands loaded: ^2" .. (returnIndexesInTable(commands) - 1))
end
