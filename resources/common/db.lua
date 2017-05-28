serverUrl = "http://127.0.0.1:"
port = 5984
auth = "username:password"
bytespassword = clr.System.Text.Encoding.UTF8.GetBytes(auth);
auth = clr.System.Convert.ToBase64String(bytespassword);

db = {}

function db.createDatabase(callback, database)
  PerformHttpRequest(serverUrl .. port .. "/" .. database, function(err, rText, headers)
      local response = json.decode(rText)
      if not (response.ok) then
        PerformHttpRequest(serverUrl .. port .. "/" .. database, function(err, rText, headers)
            if (response.ok) then
              callback(true)
            else
              callback(false)
            end
          end, "PUT", "", {Authorization = "Basic " .. auth})
      else
        callback(false)
        print("Database ".. database .." exists.")
      end
    end, "GET", "", {Authorization = "Basic " .. auth})
end

function db.createDocument(callback, database, query)
  PerformHttpRequest(serverUrl .. port .. "/_uuid", function(err, rText, headers)
      local uuids = json.decode(rText).uuids
      if (uuids) then
        PerformHttpRequest(serverUrl .. port .. "/".. database .. "/" .. uuids[1], function(err, rText, headers)
            local response = json.decode(rText)
            if (response.ok) then
              PerformHttpRequest(serverUrl .. port .. "/".. database .. "/" .. uuids[1], function(err, rText, headers)
                  local docs = json.decode(rText)
                  if (docs[1]._id) then
                    callback(docs)
                  else
                    callback(false)
                  end
                end, "GET", json.encode(query), {Authorization = "Basic " .. auth})
            else
              callback(false)
            end
          end, "PUT", json.encode(query), {Authorization = "Basic " .. auth})
      else
        callback(false)
        print("Error creating document.")
      end
    end, "GET", "", {Authorization = "Basic " .. auth})
end

function db.getDocument(callback, uuid, database)
  PerformHttpRequest(serverUrl .. port .. "/" .. database .. "/" .. uuid, function(err, rText, headers)
      local allDocs = json.decode(rText).docs
      print("Query:" .. serverUrl .. port .. "/" .. database .. "/" .. uuid .. " rText:" .. rText)
      if (allDocs[1]._id) then
        callback(allDocs)
      else
        callback(false)
      end
    end, "GET", "", {["Content-type"] = 'application/json', Authorization = "Basic " .. auth})
end

function db.findDocument(callback, database, queryData)
  PerformHttpRequest(serverUrl .. port .. "/" .. database .. "/_find", function(err, rText, headers)
      local allDocs = json.decode(rText).docs
      print("Query:" .. serverUrl .. port .. "/_find  rText:" .. rText)
      if (allDocs[1]._id) then
        callback(allDocs)
      else
        callback(false)
      end
    end, "POST", json.encode(queryData), {["Content-type"] = 'application/json', Authorization = "Basic " .. auth})
end

function db.modifyDocument(callback, database, queryData, updateData)
  PerformHttpRequest(serverUrl .. port .. "/" .. database .. "/_find", function(err, rText, headers)
      local allDocs = json.decode(rText)
      if (allDocs[1]._id) then
        updates = {}
        for k,v in ipairs(allDocs[1]) do
        table.insert(updates[v.row], (updateData[v.row] or v.value))
      end
      table.insert(updates["_rev"], allDocs[1]._rev)
      table.insert(updates["identifier"], allDocs[1].identifier)
      PerformHttpRequest(serverUrl .. port .. "/".. database .. "/" .. allDocs[1]._id, function(err, rText, headers)
          local response = json.decode(rText)
          if (response.ok) then
            callback(true)
          else
            callback(false)
          end
        end,"PUT", json.encode(updates), {["Content-type"] = 'application/json', Authorization = "Basic " .. auth})
    else
      callback(false)
    end
  end, "POST", json.encode(queryData), {["Content-type"] = 'application/json', Authorization = "Basic " .. auth})
end


function db.GETData(callback, database)
  PerformHttpRequest(serverUrl .. port .. "/" .. database, function(err, rText, headers)
      local uuids = json.decode(rText).uuids
      print("Query:" .. serverUrl .. port .. "/" .. database .. "rText:" .. rText)
      if (uuids) then
        callback(uuids)
      else
        callback(false)
      end
    end, "GET", "", {Authorization = "Basic " .. auth})
end

function db.GETDatabase(callback, database)
  PerformHttpRequest(serverUrl .. port .. "/" .. database, function(err, rText, headers)
      local response = json.decode(rText)
      print("Query:" .. serverUrl .. port .. "/" .. database .. "rText:" .. rText)
      if (response.ok) then
        callback(true)
      else
        callback(false)
      end
    end, "GET", "", {Authorization = "Basic " .. auth})
end

function db.PUTData(identifier, callback, database, queryData)
  PerformHttpRequest(serverUrl .. port .. "/" .. database .. "/" .. identifier, function(err, rText, headers)
      local response = json.decode(rText)
      print("Query:" .. serverUrl .. port .. "/" .. database .. "/" .. identifier .. "rText:" .. rText)
      if (response.ok) then
        callback(true)
      else
        callback(false)
      end
    end, "PUT", json.encode(queryData), {["Content-type"] = 'application/json', Authorization = "Basic " .. auth})
end

function db.POSTData(callback, database, queryData)
  PerformHttpRequest(serverUrl .. port .. "/" .. database, function(err, rText, headers)
      local allDocs = json.decode(rText).docs
      print("Query:" .. serverUrl .. port .. "/" .. database .. "rText:" .. rText)
      if (allDocs[1]._id) then
        callback(allDocs)
      else
        callback(false)
      end
    end, "POST", json.encode(queryData), {["Content-type"] = 'application/json', Authorization = "Basic " .. auth})
end

function db.DELETEData(identifier, callback, database)
  PerformHttpRequest(serverUrl .. port .. "/" .. database .. "/" .. identifier, function(err, rText, headers)
      local response = json.decode(rText)
      print("Query:" .. serverUrl .. port .. "/" .. database .. "/" .. identifier .. "rText:" .. rText)
      if (response.ok) then
        callback(true)
      else
        callback(false)
      end
    end, "DELETE", "", {Authorization = "Basic " .. auth})
end

-- First run check.
function firstRun(database)
  db.createDatabase(function(success)
      if success then
        print("Database created")
      end
    end,database)
end


--Last line apparently requires, or so says the shitty dev :)
local theTestObject, jsonPos, jsonErr = json.decode('{"test":"tested"}')
