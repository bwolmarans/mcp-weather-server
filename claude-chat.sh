#!/bin/bash
# Interactive Chat Interface for Claude Code CLI
# Provides a continuous loop for conversing with Claude via the `claude` command

set -euo pipefail

# Color definitions for better UI
BOLD='\033[1m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
RESET='\033[0m'

# Display welcome message
show_welcome() {
    clear
    echo -e "${BOLD}${BLUE}========================================${RESET}"
    echo -e "${BOLD}${BLUE}  Claude Code - Interactive Chat${RESET}"
    echo -e "${BOLD}${BLUE}========================================${RESET}"
    echo ""
    echo -e "Type your message and press ${BOLD}Enter${RESET} to send."
    echo -e "Type ${BOLD}exit${RESET}, ${BOLD}quit${RESET}, or press ${BOLD}Ctrl+C${RESET} to exit."
    echo -e "Type ${BOLD}clear${RESET} to clear the screen."
    echo -e "Type ${BOLD}help${RESET} for usage information."
    echo ""
}

# Display help information
show_help() {
    echo -e "${BOLD}${YELLOW}Available Commands:${RESET}"
    echo -e "  ${BOLD}exit${RESET} or ${BOLD}quit${RESET}  - Exit the chat interface"
    echo -e "  ${BOLD}clear${RESET}            - Clear the terminal screen"
    echo -e "  ${BOLD}help${RESET}             - Show this help message"
    echo ""
}

# Check if Claude CLI is installed
check_claude_cli() {
    if ! command -v claude &> /dev/null; then
        echo -e "${RED}Error: Claude CLI is not installed or not in PATH.${RESET}" >&2
        echo "Please install Claude Code CLI first." >&2
        exit 1
    fi
}

# Display separator line
show_separator() {
    echo -e "${BLUE}----------------------------------------${RESET}"
}

# Handle cleanup on exit
cleanup() {
    echo ""
    echo -e "${GREEN}Goodbye!${RESET}"
    exit 0
}

# Set up trap for graceful exit
trap cleanup SIGINT SIGTERM

# Main chat loop
main() {
    # Verify Claude CLI is available
    check_claude_cli

    # Show welcome message
    show_welcome

    # Main interaction loop
    while true; do
        # Display prompt
        echo -e "${BOLD}${GREEN}You:${RESET} "

        # Read user input
        read -r user_input

        # Handle empty input
        if [[ -z "${user_input}" ]]; then
            echo -e "${YELLOW}Please enter a message.${RESET}"
            echo ""
            continue
        fi

        # Handle special commands
        case "${user_input,,}" in
            exit|quit)
                cleanup
                ;;
            clear)
                show_welcome
                continue
                ;;
            help)
                show_help
                continue
                ;;
        esac

        # Show separator and processing indicator
        show_separator
        echo -e "${BOLD}${BLUE}Claude:${RESET}"
        echo ""

        # Call Claude CLI with the user's prompt
        # Using printf to safely handle the input string
        if claude "$(printf '%s' "${user_input}")"; then
            echo ""
        else
            echo -e "${RED}Error: Failed to get response from Claude CLI.${RESET}" >&2
            echo -e "${YELLOW}Please check your Claude CLI installation and authentication.${RESET}" >&2
            echo ""
        fi

        # Show separator before next prompt
        show_separator
        echo ""
    done
}

# Run the main function
main
