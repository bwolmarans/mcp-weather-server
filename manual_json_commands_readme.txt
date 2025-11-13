
#We can send a ping to see if it's alive
{ "jsonrpc": "2.0", "id": "0", "method": "ping" }

# Must initialize our MCP server first
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-10-05","capabilities":{},"clientInfo":{"name":"manual-client","version":"0.0.0"}}}

# Then you need to notify about the initialization:
{"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
You won't probably get a response here.

#Then you can list the tools:
{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}

#And finally we can call our MCP weather server!
{"jsonrpc": "2.0", "id": 3, "method": "forecast", "params": {"city": "las vegas, nv"} }

