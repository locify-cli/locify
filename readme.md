# 🌍 Locify CLI

**Locify** is a simple and powerful command-line tool for managing localization JSON files. With Locify, you can easily initialize, add, edit, and delete localization keys from your JSON files without manually modifying them. This makes managing translations for your applications much more efficient!

## 🚀 Features

- **Initialize locales**: Set up your localization JSON files in seconds.
- **Add new translations**: Easily insert new translation keys into JSON files.
- **Edit existing translations**: Modify the value of any existing localization key.
- **Delete translations**: Remove unwanted localization keys safely.
- **Clear Locify**: Remove Locify configuration and locale files.
- **Command-line support**: Execute actions directly with CLI arguments.
- **Cross-platform support**: Works on **macOS, Linux, and Windows**.

---

## 📚 Installation

### Install globally via npm

```sh
npm install -g locify
```

### Verify installation

```sh
locify --help
```

---

## 🎯 Usage

Locify supports both **interactive mode** and **direct command execution**.

### Running Locify in interactive mode

```sh
locify
```

This will open the Locify CLI menu:

```
====================================
          🚀 LOCIFY CLI
====================================

Available commands:
  1) Init         - Initialize locales JSON files
  2) Add          - Add a new translation key to locales JSON
  3) Edit         - Modify a translation value in locales JSON
  4) Delete       - Delete a translation key from locales JSON
  5) Clear        - Remove CLI configuration & locale JSON files
  6) Exit

Enter a number and press ENTER:
```

### Running Locify with command-line arguments

Instead of using the interactive mode, you can execute specific commands directly:

#### Initializing Locales

```sh
locify init
```

#### Adding a Translation

```sh
locify add
```

You will be prompted to enter the JSON key and translations.

#### Editing a Translation

```sh
locify edit
```

You will be prompted to enter the key to modify and the new translations.

#### Deleting a Translation

```sh
locify delete
```

You will be prompted to enter the key to delete.

#### Clearing Configuration and Locale Files

```sh
locify clear
```

This will remove the Locify configuration file and all locale JSON files. You will be asked for confirmation before proceeding.

---

## ℹ️ Help

To see available commands at any time, run:

```sh
locify --help
```

---

## 🌐 License

This project is licensed under the [MIT License](LICENSE).
