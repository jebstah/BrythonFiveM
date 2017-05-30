local savedOutfits = {}
local database = "es_customization"

RegisterServerEvent("es_customization:saveUser")
AddEventHandler("es_customization:saveUser", function(u)
    TriggerEvent("es:getPlayerFromId", source, function(target)
        print("es_customization")
        local queryData = {selector = {["identifier"] = target.identifier}}
        local updates = {identifier = target.identifier,
          hair = u.hair,
          haircolor = u.haircolour,
          torso = u.torso,
          torsotexture = u.torsotexture,
          torsoextra = u.torsoextra,
          torsoextratexture = u.torsoextratexture,
          pants = u.pants,
          pantscolor = u.pantscolour,
          shoes = u.shoes,
          shoescolor = u.shoescolour,
          bodyaccessory = u.bodyaccesorie,
          undershirt = u.undershirt,
          armor = u.armor}
        db.modifyDocument(function(success)
            if not success then
              db.createDocument(function(createSuccess)
                  if not createSuccess then
                    print("something went wrong...")
                  else
                    print(u.haircolour)
                    target:removeMoney(250)
                    savedOutfits[source] = u
                    TriggerClientEvent("chatMessage", source, "CLOTHING", {255, 0, 0}, "You saved your outfit, it will stay forever even if you reconnect. You can change it back at a clothing store.")
                  end
                end, database, updates)
            end
          end, database, queryData, updates)
      end)
  end)

AddEventHandler("es_customization:setToPlayerSkin", function(source)
    if(savedOutfits[source] == nil)then
      TriggerEvent("es:getPlayerFromId", source, function(target)
          print("es_customization")
          local queryData = {selector = {["identifier"] = target.identifier}}
          db.findDocument(function(docs)
              if docs._id then
                docs._id = nil
                savedOutfits[source] = docs
                TriggerClientEvent("es_customization:setOutfit", source, savedOutfits[source])
              else
                print("Unable to get player from id")
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
            end, database, queryData)
        end)
    end
  end)

RegisterServerEvent("playerSpawn")
AddEventHandler("playerSpawn", function()
    if(savedOutfits[source] == nil)then
      TriggerEvent("es:getPlayerFromId", source, function(target)
          print("es_customization")
          local queryData = {selector = {["identifier"] =  target.identifier }}
          db.findDocument(function(docs)
              if docs._id then
                docs._id = nil
                savedOutfits[source] = docs
                TriggerClientEvent("es_customization:setOutfit", source, savedOutfits[source])
              else
                print("Unable to get player from id")
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
            end, database, queryData)
        end)
    end
  end)

AddEventHandler("playerDropped", function()
    savedOutfits[source] = nil
  end)