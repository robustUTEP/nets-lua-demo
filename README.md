# nets-lua-demo

adrian is a simple lua dissector for wireshark 

The protocol uses UDP on ports 5000, 5001, and 5002 to upload or download a file. 
Messages must be at least 3 bytes long. 
* The first byte is the message's sequence number. 
* Second byte is an ascii character representing the message type. 
* Valid message types are:
  * G or P for get and put a file
  * D is a data packet
  * F is the end of a file
  * X is a file not found response

To capture packets using wireshark you must first run the `su` command. Then run `wireshark-gtk`. Select the loopback.io device and begin capturing. Once you are finished capturing save the file and then run `exit` to logout of root.

To run your lua code, run `wireshark-gtk -X lua_script:yourprotocol.lua`. Be sure to not run this as root as it will disable lua. Then load your captured file and filter using the name of your protocol.

adrian.lua contains many useful links but if you need additional help you can google for topics such as 'lua convert string to number' or 'lua split string'.
