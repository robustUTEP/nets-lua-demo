-- adrian protocol example
-- author: Adrian Veliz

local adrian_proto = Proto("adrian","Adrian Protocol")

-- create a function to dissect it
function adrian_proto.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol = "ADRIAN"
    local subtree = tree:add(adrian_proto,buffer(),"Adrian Protocol Data")

	-- Message is at least three bytes long
	if buffer:len() < 3 then
		subtree:add_expert_info(PI_MALFORMED, PI_ERROR, "Invalid Message")
		return end
	
	-- All messages have a sequence number and type
    local seq_num = buffer(0,1):uint()
    local msg_type = buffer(1,1):string() 
    
    subtree:add(buffer(0,1),"Sequence Number: " .. seq_num)
    subtree:add(buffer(1,1),"Type: " .. msg_type)

    if msg_type == "X" then  	-- File Not Found
		subtree:add(buffer(2), "Response: " .. buffer(2):string())
		subtree:add_expert_info(PI_RESPONSE_CODE, PI_WARN, "File not found")
	elseif msg_type == "G" then -- Request a file
		subtree:add(buffer(2), "GET: " .. buffer(2):string())
	elseif msg_type == "D" or msg_type == "F" then 	-- Sending Data
		subtree:add(buffer(2),"DATA: " .. buffer(2))
		if msg_type == "F" then						-- Last Data
			subtree:add_expert_info(PI_RESPONSE_CODE, PI_NOTE, "Finished sending")
		end
	else						-- Unknown message type	
		subtree:add_expert_info(PI_PROTOCOL, PI_WARN, "Unknown message type")
		subtree:add(buffer(0),"ERROR: " .. buffer(0))
	end
end
-- load the udp.port table
udp_table = DissectorTable.get("udp.port")
-- register protocol to handle udp ports
udp_table:add(5000,adrian_proto)
udp_table:add(5001,adrian_proto) 
udp_table:add(5002,adrian_proto)
 
-- original source code and getting started
-- https://shloemi.blogspot.com/2011/05/guide-creating-your-own-fast-wireshark.html

-- helpful links
-- https://delog.wordpress.com/2010/09/27/create-a-wireshark-dissector-in-lua/
-- https://wiki.wireshark.org/LuaAPI/Tvb
-- http://lua-users.org/wiki/LuaTypesTutorial
-- https://wiki.wireshark.org/Lua/Examples
-- https://wiki.wireshark.org/LuaAPI/Proto
-- https://www.wireshark.org/docs/wsdg_html_chunked/wslua_dissector_example.html
-- https://www.wireshark.org/lists/wireshark-users/201206/msg00010.html
-- https://wiki.wireshark.org/LuaAPI/TreeItem
-- https://www.wireshark.org/docs/man-pages/tshark.html

