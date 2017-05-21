serverUrl = "http://127.0.0.1:"
port = 5984
auth = "username:password"
bytespassword = clr.System.Text.Encoding.UTF8.GetBytes(auth);
auth = clr.System.Convert.ToBase64String(bytespassword);

db = {}

function db.GETData(identifier, callback, database)
  PerformHttpRequest(serverUrl .. port .. "/" .. database .. "/" .. identifier, function(err, rText, headers)
      local responseText = json.decode(rText)
      if err > 299 then
        callback(false, responseText)
      else
        callback(true, responseText)
      end
  end, "GET", "", {Authorization = "Basic " .. auth})
end

function db.PUTData(identifier, callback, database, queryData)
  PerformHttpRequest(serverUrl .. port .. "/" .. database .. "/" .. identifier, function(err, rText, headers)
      local responseText = json.decode(rText)
      if err > 299 then
        callback(false, responseText)
      else
        callback(true, 0)
      end
  end, "PUT", json.encode(queryData), {["Content-type"] = 'application/json', Authorization = "Basic " .. auth})
end

function db.POSTData(callback, database, queryData)
  PerformHttpRequest(serverUrl .. port .. "/" .. database, function(err, rText, headers)
      local responseText = json.decode(rText)
      if err > 299 then
        callback(false, responseText)
      else
        callback(true, responseText)
      end
  end, "POST", json.encode(queryData), {["Content-type"] = 'application/json', Authorization = "Basic " .. auth})
end

function db.DELETEData(identifier, callback, database)
  PerformHttpRequest(serverUrl .. port .. "/" .. database .. "/" .. identifier, function(err, rText, headers)
      local responseText = json.decode(rText)
      if err > 299 then
        callback(false, responseText)
      else
        callback(true, 0)
      end
  end, "DELETE", "", {Authorization = "Basic " .. auth})
end

-- First run check.
db.GETData("",
  function(exist, rText)
    if not exists then
      db.PUTData("",function()end,"essentialmode", "")
    end
  end,
'essentialmode')

--Last line apparently requires, or so says the shitty dev :)
local theTestObject, jsonPos, jsonErr = json.decode('{"test":"tested"}')
