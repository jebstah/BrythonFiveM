local savedOutfits = {}
local POST_database = "es_customization/_find"
local PUT_database = "es_customization"

RegisterServerEvent("es_customization:saveUser")
AddEventHandler("es_customization:saveUser", function(u)
	TriggerEvent("es:getPlayerFromId", source, function(target)
    local queryData = {selector = {["identifier"] = target.identifier}}
    db.POSTData(function(exists, responseText)
        if responseText == nil then
          db.GETData("",
            function(exist, rText)
              if exists then
                local queryData = {
                  "identifier":target.identifier,
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
                  "armor":u.armor}
                  
                db.PUTData(rText.uuids[1], 
                  function(exists, responseText)
                    if exists then
                      print(u.haircolour)

                      target:removeMoney(250)

                      savedOutfits[source] = u

                      TriggerClientEvent("chatMessage", source, "CLOTHING", {255, 0, 0}, "You saved your outfit, it will stay forever even if you reconnect. You can change it back at a clothing store.")
                    else
                      print "Unable to save outfit " .. responseText
                    end
                end, PUT_database, queryData) 
              end
            end, '_uuids')
        else
          local queryData = {
                  "_rev":responseText._rev,
                  "identifier":target.identifier,
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
                  "armor":u.armor}
                  
                db.PUTData(responseText._id, 
                  function(exists, responseText)
                    if exists then
                      print(u.haircolour)

                      target:removeMoney(250)

                      savedOutfits[source] = u

                      TriggerClientEvent("chatMessage", source, "CLOTHING", {255, 0, 0}, "You saved your outfit, it will stay forever even if you reconnect. You can change it back at a clothing store.")
                    else
                      print "Unable to save outfit " .. responseText
                    end
                end, PUT_database, queryData)
        end        
    end, POST_database, queryData)
	end)
end)

AddEventHandler("es_customization:setToPlayerSkin", function(source)
	if(savedOutfits[source] == nil)then
		TriggerEvent("es:getPlayerFromId", source, function(target)
      local queryData = {selector = {["identifier"] = target.identifier}}
      db.POSTData(function(exists, responseText)
        if exists then
          if responseText ~= nil then
            responseText._id = nil
            
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
          print "Unable to get player from id " .. responseText
        end
      end, "es_customization/outfits/_find", queryData)
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
      local queryData = {selector = {["identifier"] =  target.identifier }}
      db.POSTData(function(exists, responseText)
        if exists then
          if responseText ~= nil then
            responseText._id = nil
            
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
          print "Unable to get player from id " .. responseText
        end
      end, "es_customization/outfits/_find", queryData)  
		end)
	end

	if(savedOutfits[source])then
		TriggerClientEvent("es_customization:setOutfit", source, savedOutfits[source])
	end
end)

AddEventHandler("playerDropped", function()
	savedOutfits[source] = nil
end)