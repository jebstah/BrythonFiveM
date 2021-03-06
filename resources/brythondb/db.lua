--include the server_script line below in the __resource file to access functions below. 
--Don't forget to remove the -- infront of server_script as this creates a comment in Lua.

--server_script '../brythondb/db.lua'

--Or where ever you may have put the file. ../ is a relative path which means to go up one folder level from current file
--and continue the path to the folder brythondb/ and then the file db.lua

serverUrl = "http://127.0.0.1:"
port = 5984
auth = "username:password"
bytespassword = clr.System.Text.Encoding.UTF8.GetBytes(auth);
auth = clr.System.Convert.ToBase64String(bytespassword);

db = {}

function db.createDatabase(callback, database)
  PerformHttpRequest(serverUrl .. port .. "/" .. database, function(err, rText, headers)
      if err > 299 then
        PerformHttpRequest(serverUrl .. port .. "/" .. database, function(err, rText, headers)
            local response = json.decode(rText)
            if (response.ok) then
              callback(true)
            else
              callback(false)
            end
          end, "PUT", "", {Authorization = "Basic " .. auth})
      else
        callback(false)
      end
    end, "GET", "", {Authorization = "Basic " .. auth})
end

function db.createDocument(callback, database, query)
  PerformHttpRequest(serverUrl .. port .. "/_uuids", function(err, rText, headers)
      local uuids = json.decode(rText).uuids
      if (uuids) then
        PerformHttpRequest(serverUrl .. port .. "/".. database .. "/" .. uuids[1], function(err, rText, headers)
            local response = json.decode(rText)
            if err < 300 then
              PerformHttpRequest(serverUrl .. port .. "/".. database .. "/" .. uuids[1], function(err, rText, headers)
                  local allDocs = json.decode(rText)
                  if (allDocs.docs[1]._id) then
                    callback(allDocs.docs[1])
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
      end
    end, "GET", "", {Authorization = "Basic " .. auth})
end

function db.getDocument(callback, uuid, database)
  PerformHttpRequest(serverUrl .. port .. "/" .. database .. "/" .. uuid, function(err, rText, headers)
      local allDocs = json.decode(rText)
      print("Query:" .. serverUrl .. port .. "/" .. database .. "/" .. uuid .. " rText:" .. rText)
      if (allDocs.docs[1]) then
        callback(allDocs.docs[1])
      else
        callback(false)
      end
    end, "GET", "", {["Content-type"] = 'application/json', Authorization = "Basic " .. auth})
end

function db.findDocument(callback, database, queryData)
  PerformHttpRequest(serverUrl .. port .. "/" .. database .. "/_find", function(err, rText, headers)
      local allDocs = json.decode(rText)
      print("Query:" .. serverUrl .. port .. "/_find  rText:" .. rText)
      if (allDocs.docs[1]) then
        callback(allDocs.docs[1])
      else
        callback(false)
      end
    end, "POST", json.encode(queryData), {["Content-type"] = 'application/json', Authorization = "Basic " .. auth})
end

function db.modifyDocument(callback, database, queryData, updateData)
  PerformHttpRequest(serverUrl .. port .. "/" .. database .. "/_find", function(err, rText, headers)
      local allDocs = json.decode(rText)
      local updates = {}
      if (allDocs.docs[1]) then
--      Makes sure that even if {money = 10} is sent, the rest of the data stays in the record as well.
--      _id is used in the URL of PUT so it's not needed in the query.
--      Cannot be used to add things that do not exist and is out of the scope of the function.
        for k,v in pairs(allDocs.docs[1]) do
          updates[k] = (updateData[k] or allDocs.docs[1][k])
        end
      updates["_rev"] = allDocs.docs[1]._rev
      updates["identifier"] = allDocs.docs[1].identifier
      PerformHttpRequest(serverUrl .. port .. "/".. database .. "/" .. allDocs.docs[1]._id, function(err, rText, headers)
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

--[[

--
-- Everything below were used as test functions, but I cam across the scenario where I would only need one of the 5 above.
-- If you need one of the functions below for something feel free to cut it out of the comment block and place it where it
-- will be considered an actual function.
--

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
      local allDocs = json.decode(rText)
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
]]--
-- First run check.
function firstRun(database)
  db.createDatabase(function(success)
      if success then
        print("Database created")
      end
    end,database)
end

--Last line apparently required, or so says Kanersps. May try removing in the future.
local theTestObject, jsonPos, jsonErr = json.decode('{"test":"tested"}')
