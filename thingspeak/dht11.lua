--dht11.lua
function sendData()

status,temp,humi,temp_decimial,humi_decimial = dht.read(dht_pin)
if (status == dht.OK) then
	print("Sending data to thingspeak.com")
	conn = net.createConnection(net.TCP, 0) 
	conn:on("receive", function(conn, payload) print(payload) end)
	-- api.thingspeak.com 184.106.153.149

	conn:connect(80,"184.106.153.149") 
	sendstr =      "field1="..tostring(temp)
				.."&field2="..tostring(humi)

	print(sendstr)
	conn:send("POST /update HTTP/1.1\r\n"..
			  "Host: api.thingspeak.com\r\n"..
			  "Connection: close\r\n"..
			  "X-THINGSPEAKAPIKEY: "..key.."\r\n"..
			  "Content-Type: application/x-www-form-urlencoded\r\n"..
			  "Content-Length: "..string.len(sendstr).."\r\n"..
			  "\r\n"..
			  sendstr)

	conn:on("sent",function(conn)
						  print("Closing connection")
						  conn:close()
					  end)
	conn:on("disconnection", function(conn)
			  print("Got disconnection...")
	  end)
end

end

-- send data every X ms to thingspeak
tmr.alarm(2, 10000, 1, function() sendData() end )
