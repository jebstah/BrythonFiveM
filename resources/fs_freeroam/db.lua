local port = 5984 -- change this if needed

db = {}

function db.getUser(identifier, callback)
	local qu = {selector = {["identifier"] = identifier}}
	PerformHttpRequest("http://127.0.0.1:" .. port .. "/es_freeroam/_find", function(err, rText, headers)
		local t = json.decode(rText)

		if(t.docs[1])then
			callback(t.docs[1])
		else
			callback(false)
		end
	end, "POST", json.encode(qu), {["Content-Type"] = 'application/json'})
end

function db.updateUser(identifier, update, callback)
	db.getUser(identifier, function(user)
		for i in pairs(update)do
			user[i] = update[i]
		end

		PerformHttpRequest("http://127.0.0.1:" .. port .. "/es_freeroam/" .. user._id, function(err, rText, headers)
			callback((err or true))
		end, "PUT", json.encode(user), {["Content-Type"] = 'application/json'})
	end)
end

TriggerEvent('es:exposeDBFunctions', function(DB)
	db.createDocument = DB.createDocument
	DB.createDatabase("es_freeroam", function()end)
end)
