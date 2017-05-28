-- Loading MySQL Class

AddEventHandler('es:chatMessage', function(source, msg, user)
    local tstamp2 = os.date("*t", os.time())
    local queryData = {sender = user.identifier, 
      timestamp = os.date(tstamp2.year .. "-" .. tstamp2.month .. "-" .. tstamp2.day .. " " .. tstamp2.hour .. ":" .. tstamp2.min .. ":" .. tstamp2.sec), 
      message = msg }
    local uuid = false
    db.GETData(
      function(val)
        if val then
          uuid = val
        end
      end, '_uuids')
    if uuid then
      db.PUTData(uuid[1],
        function(success)
          if not success then
            print('Error adding chat message to Database!')
          end
        end, "chat_logs", queryData)
    end
  end)

AddEventHandler('es:adminCommandRan', function(source, msg, user)
    local tstamp2 = os.date("*t", os.time())
    msg = table.concat(msg, " ")
    local queryData = {sender = user.identifier, 
      timestamp = os.date(tstamp2.year .. "-" .. tstamp2.month .. "-" .. tstamp2.day .. " " .. tstamp2.hour .. ":" .. tstamp2.min .. ":" .. tstamp2.sec), 
      message = msg }
    local uuid = false
    db.GETData(
      function(val)
        if val then
          uuid = val
        end
      end, '_uuids')
    if uuid then
      db.PUTData(uuid[1],
        function(success)
          if not success then
            print('Error adding admin message to Database!')
          end
        end, "admin_logs", queryData)
    end
  end)

AddEventHandler('es:userCommandRan', function(source, msg, user)
    local tstamp2 = os.date("*t", os.time())
    msg = table.concat(msg, " ")
    local queryData = {sender = user.identifier, 
      timestamp = os.date(tstamp2.year .. "-" .. tstamp2.month .. "-" .. tstamp2.day .. " " .. tstamp2.hour .. ":" .. tstamp2.min .. ":" .. tstamp2.sec), 
      message = msg }
    local uuid = false
    db.GETData(
      function(val)
        if val then
          uuid = val
        end
      end, '_uuids')
    if uuid then
      db.PUTData(uuid[1],
        function(success)
          if not success then
            print('Error adding command message to Database!')
          end
        end, "commands_logs", queryData)
    end
  end)