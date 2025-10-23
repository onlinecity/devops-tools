#!/usr/bin/env bash

set -euo pipefail

# Function to check if a directory is a git submodule
is_submodule() {
    local path="$1"
    if git config --file .gitmodules --get "submodule.${path}.url" &>/dev/null; then
        if [ -d "${path}/.git" ] || [ -f "${path}/.git" ]; then
            return 0
        fi
    fi
    return 1
}

# Function to get the latest semver tag from a git repository
get_latest_semver_tag() {
    local repo_path="$1"

    # Get all tags matching the semver pattern v<major>.<minor>.<patch>
    local tags=$(git -C "${repo_path}" tag -l 'v*.*.*' 2>/dev/null | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' || true)

    if [ -z "$tags" ]; then
        return 1
    fi

    # Sort tags using version sort and get the latest
    local latest_tag=$(echo "$tags" | sort -V | tail -n 1)
    echo "$latest_tag"
    return 0
}

# Function to parse .gitmodules and extract submodule information
parse_gitmodules() {
    local current_submodule=""
    local current_path=""
    local current_url=""

    while IFS= read -r line; do
        # Remove leading/trailing whitespace
        line=$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

        # Skip empty lines and comments
        if [[ -z "$line" || "$line" =~ ^# ]]; then
            continue
        fi

        # Match submodule declaration
        if [[ "$line" =~ ^\[submodule\ \"(.+)\"\]$ ]]; then
            # Process previous submodule if exists (as we collect info line by line)
            if [[ -n "$current_path" && -n "$current_url" ]]; then
                process_submodule "$current_path" "$current_url"
            fi

            current_submodule="${BASH_REMATCH[1]}"
            current_path=""
            current_url=""
        # Match path
        elif [[ "$line" =~ ^path\ =\ (.+)$ ]]; then
            current_path="${BASH_REMATCH[1]}"
        # Match url
        elif [[ "$line" =~ ^url\ =\ (.+)$ ]]; then
            current_url="${BASH_REMATCH[1]}"
        fi
    done < .gitmodules

    # Process the last submodule (as lines was collected in loop but not processed)
    if [[ -n "$current_path" && -n "$current_url" ]]; then
        process_submodule "$current_path" "$current_url"
    fi
}

# Function to process a single submodule
process_submodule() {
    local path="$1"
    local url="$2"

    echo "Processing submodule: ${path}"

    # Check if path exists
    if [ -e "$path" ]; then
        # Check if it's already a submodule
        if is_submodule "$path"; then
            echo "Path '${path}' is already initialized as a submodule, skipping add"
            checkout_latest_tag "$path"
            return 0
        else
            echo "Path '${path}' exists but is not a submodule"

            # Check if directory is empty
            if [ -d "$path" ] && [ -z "$(ls -A "$path" 2>/dev/null)" ]; then
                echo "Directory '${path}' is empty, removing it"
                rmdir "$path"
            else
                echo "Removing existing path '${path}' to initialize submodule"
                rm -rf "$path"
            fi
        fi
    fi

    # Add the submodule
    echo "Adding submodule at '${path}' from '${url}'"
    if git submodule add "$url" "$path" 2>&1; then
        echo "Submodule added: ${path}"

        # Initialize and update the submodule
        git submodule update --init "$path"

        # Checkout the latest tag
        checkout_latest_tag "$path"
    else
        echo "Failed to add submodule: ${path}"
        return 1
    fi
}

# Function to checkout the latest semver tag in a submodule
checkout_latest_tag() {
    local path="$1"

    if [ ! -d "$path" ]; then
        echo "Submodule path '${path}' does not exist"
        return 1
    fi

    echo "Fetching tags for submodule: ${path}"
    git -C "$path" fetch --tags 2>/dev/null || true

    local latest_tag=$(get_latest_semver_tag "$path")

    if [ -n "$latest_tag" ]; then
        echo "Checking out latest tag '${latest_tag}' in '${path}'"
        if git -C "$path" checkout "$latest_tag" 2>&1; then
            echo "Checked out tag '${latest_tag}' in '${path}'"
        else
            echo "Failed to checkout tag '${latest_tag}' in '${path}'"
            return 1
        fi
    else
        echo "No semver tags found in '${path}', staying on default branch"
    fi
}

# Main execution
main() {
    echo "Starting submodule initialization script"

    # Check if .gitmodules exists
    if [ ! -f .gitmodules ]; then
        echo ".gitmodules file not found in current directory"
        exit 1
    fi

    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Not in a git repository"
        exit 1
    fi

    echo "Parsing .gitmodules file"
    parse_gitmodules

    echo "Submodule initialization complete!"
}

# Run main function
main
