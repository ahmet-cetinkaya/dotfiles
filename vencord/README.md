# 💬 Vencord Custom Config

This guide helps you set up symbolic links to use a custom [**Vencord**](https://github.com/Vendicated/Vencord) configuration.

## ⚙️ Setup

1. Open a terminal with the necessary permissions for your operating system.

2. Run the appropriate command below to link your custom **Vencord** configuration to its default location:

   - **Windows:**
     ```powershell
     New-Item -ItemType SymbolicLink -Path "C:\Users\$env:USERNAME\AppData\Roaming\Vesktop" -Target "C:\Users\$env:USERNAME\Configs\vencord"
     ```
     - The `$env:USERNAME` variable automatically replaces with your Windows username.
     - Replace `C:\Users\$env:USERNAME\Configs\vencord` with the path to your custom **Vencord** configuration folder.

   - **Linux:**
     ```sh
     ln -s ~/Configs/vencord ~/.config/vesktop
     ```
     - Replace `/path/to/your/vencord` with the path to your custom **Vencord** configuration folder.

   Both commands create a symbolic link from the default Vencord config location to your custom configuration folder.
