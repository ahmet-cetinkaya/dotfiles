### Getting Started

To create a symbolic link, follow these steps:

1. Open PowerShell as an Administrator.
2. Run the following command, replacing `<USER_NAME>` with your username and `<REPO_PATH>` with the path to your repository:

    ```powershell
    New-Item -ItemType SymbolicLink -Path "C:\Users\<USER_NAME>\.glaze-wm" -Target "<REPO_PATH>\glaze-vm"
    ```

This will create a symbolic link for your project.