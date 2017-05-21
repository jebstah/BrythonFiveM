serverUrl = "http://127.0.0.1:"
port = 5984
auth = "username:password"
bytespassword = clr.System.Text.Encoding.UTF8.GetBytes(auth);
auth = clr.System.Convert.ToBase64String(bytespassword);

db = {}

function db.GETData(identifier, callback, database)Oka
  PerformHttpRequest(serverUrl .. port .. "/" .. database .. "/" .. identifier, function(err, rText, headers)
      local responseText = json.decode(rText)
      if err > 299 then
        callback(false, responseText)
      else
        callback(true, responseText)
      end
  end, "GET", "", {Authorization = "Basic " .. auth})
end

function db.PUTData(identifier, callback, database, table, queryData)
  PerformHttpRequest(serverUrl .. port .. "/" .. database .. "/" .. identifier, function(err, rText, headers)
      local responseText = json.decode(rText)
      if err > 299 then
        callback(false, responseText)
      else
        callback(true, 0)
      end
  end, "PUT", json.encode(queryData), {["Content-type"] = 'application/json', Authorization = "Basic " .. auth})
end

function db.POSTData(identifier, callback, database, table, queryData)
  PerformHttpRequest(serverUrl .. port .. "/" .. database, function(err, rText, headers)
      local responseText = json.decode(rText)
      if err > 299 then
        callback(false, responseText)
      else
        callback(true, responseText)
      end
  end, "POST", json.encode(queryData), {["Content-type"] = 'application/json', Authorization = "Basic " .. auth})
end

function db.DELETEData(identifier, callback, database, table)
  PerformHttpRequest(serverUrl .. port .. "/" .. database .. "/" .. identifier, function(err, rText, headers)
      local responseText = json.decode(rText)
      if err > 299 then
        callback(false, responseText)
      else
        callback(true, 0)
      end
  end, "DELETE", "", {Authorization = "Basic " .. auth})
end
