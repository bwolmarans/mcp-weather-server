#!/bin/bash

# Script to call Claude Code with MCP weather server integration
# This script prompts the user for input and passes it to Claude Code

# Color codes for better output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if claude-code is installed
if ! command -v claude-code &> /dev/null; then
    echo "Error: claude-code is not installed or not in PATH"
    echo "Please install it from: https://docs.claude.com/en/docs/claude-code"
    exit 1
fi

# Prompt user for their question/request
echo -e "${BLUE}=== Claude Code with Weather MCP Server ===${NC}"
echo ""
echo "Enter your prompt (press Ctrl+D when done):"
echo -e "${GREEN}> ${NC}"

# Read multi-line input from user
USER_PROMPT=$(cat)

# Check if prompt is empty
if [ -z "$USER_PROMPT" ]; then
    echo "Error: No prompt provided"
    exit 1
fi

echo ""
echo -e "${BLUE}Calling Claude Code with weather server...${NC}"
echo ""

# Call claude-code with the weather MCP server and user prompt
# The --mcp flag enables MCP server integration
# Adjust the weather server path/command as needed for your setup
claude-code --mcp weather "$USER_PROMPT"

# Capture exit code
EXIT_CODE=$?

echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}Claude Code completed successfully${NC}"
else
    echo -e "Claude Code exited with code: $EXIT_CODE"
fi

exit $EXIT_CODE