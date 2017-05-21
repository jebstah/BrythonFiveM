function firstRunFreeroam() 
    db.GETData("",
      function(exist, rText)
      if not exists then
        db.PUTData("",function()end,"es_freeroam", "")
      end
    end,'es_freeroam')
  end