# 💬 BetterDiscord Custom Config

This guide helps you set up symbolic links to use a custom [**BetterDiscord**](https://github.com/BetterDiscord/BetterDiscord) configuration.

## ⚙️ Setup

1. **Open PowerShell as Administrator**.

2. **Create Symbolic Link**:
   Run the following command to link your custom **BetterDiscord** configuration to its default location:

   ```powershell
   New-Item -ItemType SymbolicLink -Path "C:\Users\$env:USERNAME\AppData\Roaming\BetterDiscord" -Target "C:\Users\$env:USERNAME\Configs\better-discord"
   ```

   - The `$env:USERNAME` variable automatically replaces with your Windows username.
   - Replace `C:\Users\$env:USERNAME\Configs\better-discord` with the path to your custom **BetterDiscord** configuration folder.
   - This command creates a symbolic link from the default BetterDiscord config location to your custom configuration folder.
