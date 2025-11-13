#!/bin/bash

# Weather MCP Server Menu Interface
# This script provides a menu-driven interface to interact with a weather MCP server

# Configuration - adjust these variables as needed
WEATHER_SERVER_URL="http://localhost:3000"  # Replace with your server URL
WEATHER_ENDPOINT="/weather"                  # Replace with your endpoint

# Colors for better display (optional)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display the menu
show_menu() {
    clear
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}    Weather Server Interface    ${NC}"
    echo -e "${BLUE}================================${NC}"
    echo ""
    echo "1. Get weather information"
    echo "2. Exit"
    echo ""
    echo -n "Please select an option (1-2): "
}

# Function to get weather information
get_weather() {
    echo ""
    echo -e "${YELLOW}Enter your weather query:${NC}"
    echo "Examples: 'weather in New York', 'temperature in London', 'forecast for Paris'"
    echo -n "Query: "
    read -r weather_query
    
    # Check if query is not empty
    if [[ -z "$weather_query" ]]; then
        echo -e "${RED}Error: Query cannot be empty${NC}"
        return 1
    fi
    
    echo ""
    echo -e "${YELLOW}Contacting weather server...${NC}"
    
    # Make request to weather server using curl
    # Adjust the curl command based on your server's API requirements
    response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -d "{\"query\":\"$weather_query\"}" \
        "$WEATHER_SERVER_URL$WEATHER_ENDPOINT" 2>/dev/null)
    
    # Check if curl command was successful
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}Error: Failed to connect to weather server${NC}"
        echo -e "${RED}Please check if the server is running at $WEATHER_SERVER_URL${NC}"
        return 1
    fi
    
    # Check if response is empty
    if [[ -z "$response" ]]; then
        echo -e "${RED}Error: No response from server${NC}"
        return 1
    fi
    
    # Display the response
    echo ""
    echo -e "${GREEN}Weather Server Response:${NC}"
    echo "----------------------------------------"
    echo "$response"
    echo "----------------------------------------"
}

# Function to pause and wait for user input
pause() {
    echo ""
    echo -n "Press Enter to continue..."
    read -r
}

# Main program loop
main() {
    while true; do
        show_menu
        read -r choice
        
        case $choice in
            1)
                get_weather
                pause
                ;;
            2)
                echo ""
                echo -e "${GREEN}Thank you for using Weather Server Interface!${NC}"
                exit 0
                ;;
            *)
                echo ""
                echo -e "${RED}Invalid option. Please select 1 or 2.${NC}"
                pause
                ;;
        esac
    done
}

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo -e "${RED}Error: curl is required but not installed.${NC}"
    echo "Please install curl and try again."
    exit 1
fi

# Start the program
main
