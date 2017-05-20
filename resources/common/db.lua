serverUrl = "http://127.0.0.1:"
port = 5984
auth = "username:password"
bytespassword = clr.System.Text.Encoding.UTF8.GetBytes(auth);
auth = clr.System.Convert.ToBase64String(bytespassword);

function db.GETData(identifier, callback, db, table, queryData)
  PerformHttpRequest(serverUrl .. port .. "/" .. db .. "/" .. table, function(err, rText, headers)
      if rText then
        valReturn = json.decode(rText)
      end
  end, "GET", json.encode(queryData), {["Content-type"] = 'application/json', Authorization = "Basic " .. auth})
  return valReturn
end

function db.PUTData(identifier, callback, db, table, queryData)
  PerformHttpRequest(serverUrl .. port .. "/" .. db .. "/" .. table, function(err, rText, headers)
      if err > 299 then
        callback(false, rText)
      else
        callback(true, 0)
      end
  end, "PUT", json.encode(queryData), {["Content-type"] = 'application/json', Authorization = "Basic " .. auth})
end

function db.POSTData(identifier, callback, db, table, queryData)
  PerformHttpRequest(serverUrl .. port .. "/" .. db .. "/" .. table, function(err, rText, headers)
      if rText then
        valReturn = json.decode(rText)
      end
  end, "POST", json.encode(queryData), {["Content-type"] = 'application/json', Authorization = "Basic " .. auth})
  return valReturn
end
