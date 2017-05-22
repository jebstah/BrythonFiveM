serverUrl = "http://127.0.0.1:"
port = 5984
auth = "username:password"
bytespassword = clr.System.Text.Encoding.UTF8.GetBytes(auth);
auth = clr.System.Convert.ToBase64String(bytespassword);

db = {}

function db.GETData(identifier, callback, database)
  PerformHttpRequest(serverUrl .. port .. "/" .. database .. "/" .. identifier, function(err, rText, headers)
      local uuids = json.decode(rText).uuids
      if (uuids[1]) then
        callback(uuids[1])
      else
        callback(false)
      end
  end, "GET", "", {Authorization = "Basic " .. auth})
end

function db.GETDatabase(callback, database)
  PerformHttpRequest(serverUrl .. port .. "/" .. database, function(err, rText, headers)
      local response = json.decode(rText)
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
      if (response.ok) then
        callback(true)
      else
        callback(false)
      end
  end, "PUT", json.encode(queryData), {["Content-type"] = 'application/json', Authorization = "Basic " .. auth})
end

function db.POSTData(callback, database, queryData)
  PerformHttpRequest(serverUrl .. port .. "/" .. database, function(err, rText, headers)
      local docs = json.decode(rText).docs
      if (docs._id) then
        callback(docs)
      else
        callback(false)
      end
  end, "POST", json.encode(queryData), {["Content-type"] = 'application/json', Authorization = "Basic " .. auth})
end

function db.DELETEData(identifier, callback, database)
  PerformHttpRequest(serverUrl .. port .. "/" .. database .. "/" .. identifier, function(err, rText, headers)
      local response = json.decode(rText)
      if (response.ok) then
        callback(true)
      else
        callback(false)
      end
  end, "DELETE", "", {Authorization = "Basic " .. auth})
end

-- First run check.
function firstRun(database)
db.GETDatabase(function(success)
    if (success) then
      db.PUTData("",function()end,database, "")
    end
  end,
database)
end


--Last line apparently requires, or so says the shitty dev :)
local theTestObject, jsonPos, jsonErr = json.decode('{"test":"tested"}')
