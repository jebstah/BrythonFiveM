-- Spawn override
AddEventHandler('onClientMapStart', function()
    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
end)

AddEventHandler("playerSpawned", function(spawn)
  SetNotificationTextEntry("STRING")
  AddTextComponentString("Welcome to ~g~FiveM\n ~y~For more info go to github.com/FiveM-Scripts")
  SetNotificationMessage("CHAR_LESTER", "CHAR_LESTER", true, 4, "Essential Freeroam", "v0.1.4")
  DrawNotification(false, true);
end)

RegisterNetEvent("es_freeroam:wanted")
AddEventHandler("es_freeroam:wanted", function()
  SetPlayerWantedLevel(PlayerId(), 0, 0)
  SetPlayerWantedLevelNow(PlayerId(), 0)
end)

RegisterNetEvent("es_freeroam:displaytext")
AddEventHandler("es_freeroam:displaytext", function(text, time)
  ClearPrints()
  SetTextEntry_2("STRING")
  AddTextComponentString(text)
  DrawSubtitleTimed(time, 1)
end)

RegisterNetEvent("es_freeroam:notify")
AddEventHandler("es_freeroam:notify", function(icon, type, sender, title, text)
  Wait(1)
  SetNotificationTextEntry("STRING");
  AddTextComponentString(text);
  SetNotificationMessage(icon, icon, true, type, sender, title, text);
  DrawNotification(false, true);
end)
