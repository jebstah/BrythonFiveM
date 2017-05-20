serverUrl = "http://127.0.0.1:"
port = 5984
auth = "username:password"
bytespassword = clr.System.Text.Encoding.UTF8.GetBytes(auth);
auth = clr.System.Convert.ToBase64String(bytespassword);

local db = {}

function db.GETData(identifier, callback, db, table, queryData)
 if queryData then
  local appJS = ["Content-type"] = "application/json", Authorization = "Basic " .. auth
  local queryDataEncoded = json.encode(queryData)
 else
  local appJS = Authorization = "Basic " .. auth
  local queryDataEncoded = nil
 end
  PerformHttpRequest(serverUrl .. port .. "/" .. db .. "/" .. table, function(err, rText, headers)
      if rText then
        valReturn = json.decode(rText)
      end
  end, "GET", queryDataEncoded, { appJS })
  return valReturn
end

function db.PUTData(identifier, callback, db, table, queryData)
 if queryData then
  local appJS = ["Content-type"] = "application/json", Authorization = "Basic " .. auth
  local queryDataEncoded = json.encode(queryData)
 else
  local appJS = Authorization = "Basic " .. auth
  local queryDataEncoded = nil
 end
  PerformHttpRequest(serverUrl .. port .. "/" .. db .. "/" .. table, function(err, rText, headers)
      if err > 299 then
        callback(false, rText)
      else
        callback(true, 0)
      end
  end, "PUT", queryDataEncoded, { appJS })
end

function db.POSTData(identifier, callback, db, table, queryData)
 if queryData then
  local appJS = ["Content-type"] = "application/json", Authorization = "Basic " .. auth
  local queryDataEncoded = json.encode(queryData)
 else
  local appJS = Authorization = "Basic " .. auth
  local queryDataEncoded = nil
 end
  PerformHttpRequest(serverUrl .. port .. "/" .. db .. "/" .. table, function(err, rText, headers)
      if rText then
        valReturn = json.decode(rText)
      end
  end, "POST", queryDataEncoded, { appJS })
  return valReturn
end
