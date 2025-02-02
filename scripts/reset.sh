#!/usr/bin/env sh

CONFIG_FILE="locify.config.sh"

# Check if the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "❌ Error: No locale configuration found. Run 'init-locales' first."
  exit 1
fi

# Load the existing configuration
# shellcheck disable=SC1091
. "$CONFIG_FILE"

# Confirm deletion
echo "⚠️  Warning: This will delete all locale JSON files in $LOCALES_DIR and reset the configuration."
printf "Are you sure? (y/N): "
read confirm

if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
  echo "❌ Reset cancelled."
  exit 0
fi

# Delete locale JSON files
for locale in $LOCALES; do
  locale_file="$LOCALES_DIR/$locale.json"
  if [ -f "$locale_file" ]; then
    rm "$locale_file"
    echo "🗑 Deleted: $locale_file"
  fi
done

# Remove the locale directory if empty
if [ -d "$LOCALES_DIR" ] && [ -z "$(find "$LOCALES_DIR" -type f 2>/dev/null)" ]; then
  rmdir "$LOCALES_DIR"
  echo "🗑 Deleted empty directory: $LOCALES_DIR"
fi

# Remove the configuration file
rm "$CONFIG_FILE"
echo "🗑 Deleted configuration file: $CONFIG_FILE"

echo "✅ Locale reset complete! You can now run 'init-locales' again."