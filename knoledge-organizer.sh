#!/bin/bash

# =================================================================
#  Knowledge Base Organizer (V3)
#  Automatically generates the `_sidebar.md` for Docsify based on
#  the repository's directory structure.
#
#  Usage:
#  Run this script from the root of the repository: ./knoledge-organizer.sh
# =================================================================

set -e # Exit immediately if a command exits with a non-zero status.

# --- Configuration ---
SIDEBAR_FILE="_sidebar.md"
# --- End Configuration ---

echo "🚀 Regenerating sidebar for Docsify: $SIDEBAR_FILE"

# Create a temporary file to build the new sidebar
TEMP_SIDEBAR=$(mktemp)

# Always start with the Home link
echo "- **[🏠 Home](/)**" > "$TEMP_SIDEBAR"
echo "" >> "$TEMP_SIDEBAR"

# Find all main category directories (e.g., 01_*, 99_*, etc.), sort them, and process
find . -mindepth 1 -maxdepth 1 -type d -name "[0-9][0-9]_*" | sort | while read -r main_dir; do
    # Clean up the main directory name for the title
    # e.g., ./01_Programming_Languages -> 01. Programming Languages
    main_dir_name=$(basename "$main_dir")
    display_name=$(echo "$main_dir_name" | sed -e 's/^[0-9][0-9]_//' -e 's/_/ /g')
    number=$(echo "$main_dir_name" | cut -d'_' -f1)

    echo "- **$display_name**" >> "$TEMP_SIDEBAR"

    # Process markdown files directly under the main directory (for cases like 99_Problem_Solving_Log)
    find "$main_dir" -maxdepth 1 -name "*.md" -type f | sort | while read -r md_file; do
        file_name=$(basename "$md_file" .md)
        # Replace underscores and hyphens with spaces for readability
        link_text=$(echo "$file_name" | sed -e 's/_/ /g' -e 's/-/ /g')
        link_path=$(echo "$md_file" | sed 's|^\./||')
        echo "  - [$link_text]($link_path)" >> "$TEMP_SIDEBAR"
    done

    # Process sub-category directories (like JavaScript, CSS)
    find "$main_dir" -mindepth 1 -maxdepth 1 -type d | sort | while read -r sub_dir; do
        sub_dir_name=$(basename "$sub_dir" | sed 's/_/ /g')
        echo "  - **$sub_dir_name**" >> "$TEMP_SIDEBAR"

        # Find all markdown files in the sub-directory and create links
        find "$sub_dir" -name "*.md" -type f | sort | while read -r md_file; do
            file_name=$(basename "$md_file" .md)
            link_text=$(echo "$file_name" | sed 's/_/ /g')
            link_path=$(echo "$md_file" | sed 's|^\./||')
            echo "    - [$link_text]($link_path)" >> "$TEMP_SIDEBAR"
        done
    done
    echo "" >> "$TEMP_SIDEBAR"
done

# Replace the old sidebar with the newly generated one
mv "$TEMP_SIDEBAR" "$SIDEBAR_FILE"

echo "✅ Sidebar '$SIDEBAR_FILE' regenerated successfully."
echo "ℹ️  Run 'git add $SIDEBAR_FILE && git commit' to save the changes."
