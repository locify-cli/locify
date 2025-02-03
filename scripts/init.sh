#!/usr/bin/env sh

CONFIG_FILE="locify.config.json"

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

  # Create the JSON configuration file
  echo "{
  \"LOCALES_DIR\": \"$locales_path\",
  \"LOCALES\": [$(echo $locales | sed 's/ /", "/g' | sed 's/^/"/' | sed 's/$/"/')]
}" > "$CONFIG_FILE"

  echo "✅ Localization setup complete! Configuration saved in $CONFIG_FILE"
}

# Run the initialization function
init_locales