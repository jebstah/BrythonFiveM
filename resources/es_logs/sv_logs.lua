-- Loading MySQL Class

AddEventHandler('es:chatMessage', function(source, msg, user)
	local tstamp2 = os.date("*t", os.time())
  local database = "es_logs/chat"
  local queryData = [[{"sender": ]] .. user.identifier .. [["timestamp":]] .. os.date(tstamp2.year .. "-" .. tstamp2.month .. "-" .. tstamp2.day .. " " .. tstamp2.hour .. ":" .. tstamp2.min .. ":" .. tstamp2.sec) .. [["message":]] .. msg .. [[}]]
  
  db.GETData("",
  function(exist, rText)
    if exists then
      db.PUTData(rText['uuid'],
        function(exist, rText)
          if not exist then
            print('Error adding chat message to Database!')
          end
        end, database, queryData)
    end
  end, '_uuids')
end)

AddEventHandler('es:adminCommandRan', function(source, msg, user)
	local tstamp2 = os.date("*t", os.time())
	msg = table.concat(msg, " ")
  local database = "es_logs/admin"
  local queryData = [[{"sender": ]] .. user.identifier .. [["timestamp":]] .. os.date(tstamp2.year .. "-" .. tstamp2.month .. "-" .. tstamp2.day .. " " .. tstamp2.hour .. ":" .. tstamp2.min .. ":" .. tstamp2.sec) .. [["message":]] .. msg .. [[}]]
  
  db.GETData("",
  function(exist, rText)
    if exists then
      db.PUTData(rText['uuid'],
        function(exist, rText)
          if not exist then
            print('Error adding admin message to Database!')
          end
        end, database, queryData)
    end
  end, '_uuids')
end)

AddEventHandler('es:userCommandRan', function(source, msg, user)
	local tstamp2 = os.date("*t", os.time())
	msg = table.concat(msg, " ")
  local database = "es_logs/commands"
  local queryData = [[{"sender": ]] .. user.identifier .. [["timestamp":]] .. os.date(tstamp2.year .. "-" .. tstamp2.month .. "-" .. tstamp2.day .. " " .. tstamp2.hour .. ":" .. tstamp2.min .. ":" .. tstamp2.sec) .. [["message":]] .. msg .. [[}]]
  
  db.GETData("",
  function(exist, rText)
    if exists then
      db.PUTData(rText['uuid'],
        function(exist, rText)
          if not exist then
            print('Error adding commands message to Database!')
          end
        end, database, queryData)
    end
  end, '_uuids')
end)