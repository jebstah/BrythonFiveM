local savedOutfits = {}

RegisterServerEvent("es_customization:saveUser")
AddEventHandler("es_customization:saveUser", function(u)
	TriggerEvent("es:getPlayerFromId", source, function(target)
    local database = "es_customization/outfits/_find"
    local queryData = [[{selector = {["identifier"] = target.identifier}}]]
    db.POSTData(function(exists, responseText)
        local queryData = [[{
            "_rev":responseText['_rev'],
            "hair":u.hair,
            "haircolor":u.haircolour,
            "torso":u.torso,
            "torsotexture":u.torsotexture,
            "torsoextra":u.torsoextra,
            "torsoextratexture":u.torsoextratexture,
            "pants":u.pants,
            "pantscolor":u.pantscolour,
            "shoes":u.shoes,
            "shoescolor":u.shoescolour,
            "bodyaccessory":u.bodyaccesorie,
            "undershirt":u.undershirt,
            "armor":u.armor}]]
        db.PUTData(target.identifier, 
          function(exists, responseText)
            if exists == true then
              print "PUT was successful"
              print(u.haircolour)

              target:removeMoney(250)

              savedOutfits[source] = u

              TriggerClientEvent("chatMessage", source, "CLOTHING", {255, 0, 0}, "You saved your outfit, it will stay forever even if you reconnect. You can change it back at a clothing store.")
            else
              print "PUT failed" .. responseText
            end
        end, database, queryData)          
    end, database, queryData)
	end)
end)

AddEventHandler("es_customization:setToPlayerSkin", function(source)
	if(savedOutfits[source] == nil)then
		TriggerEvent("es:getPlayerFromId", source, function(target)
      local database = "es_customization/outfits/_find"
      local queryData = [[{selector = {["identifier"] = target.identifier}}]]
      db.POSTData(function(exists, responseText)
        if exists == true then
          if responseText ~= nil then
            responseText['_id'] = nil
            
            savedOutfits[source] = responseText
            TriggerClientEvent("es_customization:setOutfit", source, savedOutfits[source])
          else
            local default = {
              hair = 1,
              haircolour = 3,
              torso = 0,
              torsotexture = 0,
              torsoextra = 0,
              torsoextratexture = 0,
              pants = 0,
              pantscolour = 0,
              shoes = 0,
              shoescolour = 0,
              bodyaccesoire = 0,
              undershirt = 0,
              armor = 0
            }
            TriggerClientEvent("es_customization:setOutfit", source, default)
          end
        else
          print "POST failed" .. responseText
        end
      end, database, queryData)
		end)
	end

	if(savedOutfits[source])then
		TriggerClientEvent("es_customization:setOutfit", source, savedOutfits[source])
	end
end)

RegisterServerEvent("playerSpawn")
AddEventHandler("playerSpawn", function()
	if(savedOutfits[source] == nil)then
		TriggerEvent("es:getPlayerFromId", source, function(target)
      local database = "es_customization/outfits/_find"
      local queryData = [[{selector = {["identifier"] = target.identifier}}]]
      db.POSTData(function(exists, responseText)
        if exists == true then
          if responseText ~= nil then
            responseText['_id'] = nil
            
            savedOutfits[source] = responseText
            TriggerClientEvent("es_customization:setOutfit", source, savedOutfits[source])
          else
            local default = {
              hair = 1,
              haircolour = 3,
              torso = 0,
              torsotexture = 0,
              torsoextra = 0,
              torsoextratexture = 0,
              pants = 0,
              pantscolour = 0,
              shoes = 0,
              shoescolour = 0,
              bodyaccesoire = 0,
              undershirt = 0,
              armor = 0
            }
            TriggerClientEvent("es_customization:setOutfit", source, default)
          end
        else
          print "POST failed" .. responseText
        end
      end, database, queryData)  
		end)
	end

	if(savedOutfits[source])then
		TriggerClientEvent("es_customization:setOutfit", source, savedOutfits[source])
	end
end)

AddEventHandler("playerDropped", function()
	savedOutfits[source] = nil
end)