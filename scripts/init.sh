#!/usr/bin/env sh

CONFIG_FILE="locify.config.sh"

# Function to initialize locales
init_locales() {
  echo "Enter the JSON file names for locales (comma-separated, e.g., en,hu,fr):"
  read locales_input

  # Convert to a space-separated list
  locales=$(echo "$locales_input" | tr ',' ' ')

  echo "Enter the path where the locale files should be stored (e.g., src/localization/locales):"
  read locales_path

  # Ensure directory exists
  mkdir -p "$locales_path"

  # Create locale JSON files
  for locale in $locales; do
    locale_file="$locales_path/$locale.json"

    if [ ! -f "$locale_file" ]; then
      echo "{}" > "$locale_file"
      echo "✅ Created: $locale_file"
    else
      echo "⚠️ Warning: $locale_file already exists, skipping..."
    fi
  done

  # Save configuration to a separate file
  echo "LOCALES_DIR=\"$locales_path\"" > "$CONFIG_FILE"
  echo "LOCALES=\"$locales\"" >> "$CONFIG_FILE"

  echo "✅ Localization setup complete! Locale files created in $locales_path"
}

# Run the initialization function
init_locales