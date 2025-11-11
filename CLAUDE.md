# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an MCP (Model Context Protocol) server implementation that provides real-time weather data capabilities to Claude through the National Weather Service API. It serves as both a functional weather server and a template for building custom MCP servers.

## Development Commands

### Building
```bash
npm run build
```
Compiles TypeScript to JavaScript in the `build/` directory and makes `build/index.js` executable.

### Installing Dependencies
```bash
npm install
```

## Architecture

### MCP Server Pattern

This codebase uses the `@modelcontextprotocol/sdk` to create an MCP server that communicates via stdio transport. The server architecture follows this pattern:

1. **Server Initialization** (src/index.ts:9-16): Creates an `McpServer` instance with name, version, and capability declarations
2. **Tool Registration** (src/index.ts:86-216): Tools are registered using `server.tool()` with zod schema validation for parameters
3. **Transport Connection** (src/index.ts:218-227): Server connects via `StdioServerTransport` and runs until terminated

### Single-File Architecture

The entire implementation is in `src/index.ts`. This includes:
- Server initialization and configuration
- Helper functions for API requests (`makeNWSRequest`)
- Data formatting utilities (`formatAlert`)
- TypeScript interfaces for API responses
- Two tool implementations: `get-alerts` and `get-forecast`
- Main entry point that establishes stdio transport

### Tool Implementation Pattern

MCP tools follow this structure:
```typescript
server.tool(
  "tool-name",
  "Tool description",
  { /* zod schema for parameters */ },
  async (params) => {
    // Implementation
    return {
      content: [{ type: "text", text: "result" }]
    };
  }
);
```

### API Integration Pattern

The NWS API integration uses a two-step process for forecasts:
1. Convert lat/lon to grid point: `/points/{lat},{lon}`
2. Fetch forecast from grid-specific endpoint returned in step 1

All API requests include required User-Agent header and Accept header for GeoJSON format.

## Key Technical Details

### TypeScript Configuration
- Target: ES2022 with Node16 module resolution
- Strict mode enabled
- Output directory: `./build`

### External Dependencies
- `@modelcontextprotocol/sdk`: Core MCP server implementation
- `zod`: Schema validation for tool parameters

### API Constraints
- NWS API only supports US locations
- No authentication required for NWS API
- Must include User-Agent header in all requests
- API returns GeoJSON format (application/geo+json)

## Testing MCP Servers

After building, test by:
1. Adding server configuration to Claude Desktop config at `~/Library/Application Support/Claude/claude_desktop_config.json` (Mac) or `%AppData%\Claude\claude_desktop_config.json` (Windows)
2. Configuration format:
   ```json
   {
     "mcpServers": {
       "weather": {
         "command": "node",
         "args": ["/absolute/path/to/mcp-weather-server/build/index.js"]
       }
     }
   }
   ```
3. Restart Claude Desktop
4. Look for hammer icon indicating tools are available

## Extending This Server

To add new tools:
1. Define TypeScript interfaces for any new API response types
2. Register tool using `server.tool()` pattern before the `main()` function
3. Implement tool logic with error handling
4. Return formatted content in MCP response format
5. Rebuild with `npm run build`

When replacing the weather API with a different service, maintain the same MCP server structure but swap out the API client logic in helper functions.
