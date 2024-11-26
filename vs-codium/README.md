# 🖥️ VSCodium Custom Configs Setup

Set up symbolic links to use custom configuration files in VSCodium.

## 🪟 Windows

1. Open **PowerShell as Administrator**.
2. Run the following commands:

   ```powershell
   New-Item -ItemType SymbolicLink -Path "C:\Users\<USER_NAME>\AppData\Roaming\VSCodium\User\settings.json" -Target "C:\Users\ahmetcetinkaya\Configs\vs-codium\settings.json"
   New-Item -ItemType SymbolicLink -Path "C:\Users\<USER_NAME>\AppData\Roaming\VSCodium\product.json" -Target "C:\Users\ahmetcetinkaya\Configs\vs-codium\product.json"
   ```

   Replace `<USER_NAME>` with your Windows username.

## 🐧 Linux

1. Open a terminal.
2. Run the following commands:

   ```bash
   ln -s ~/Configs/vs-codium/product.json ~/.config/VSCodium/product.json
   ln -s ~/Configs/vs-codium/settings.json ~/.config/Code/User/settings.json
   ```