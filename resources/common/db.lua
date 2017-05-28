serverUrl = "http://127.0.0.1:"
port = 5984
auth = "username:password"
bytespassword = clr.System.Text.Encoding.UTF8.GetBytes(auth);
auth = clr.System.Convert.ToBase64String(bytespassword);

db = {}

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
  local exists
db.GETDatabase(function(success)
    exists = success
  end,
database)
 if exists then
  db.PUTData("",function()end,database, "")
 end
end


--Last line apparently requires, or so says the shitty dev :)
local theTestObject, jsonPos, jsonErr = json.decode('{"test":"tested"}')
