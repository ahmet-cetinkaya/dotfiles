# Tools

- [Oh My Posh](https://github.com/JanDeDobbeleer/oh-my-posh)
- [PSReadLine](https://github.com/PowerShell/PSReadLine)
- [PSFzf](https://github.com/kelleyma49/PSFzf)
- [Z](https://github.com/badmotorfinger/z)
- [gsudo](https://github.com/gerardog/gsudo)
- [PoshGit](https://github.com/dahlbyk/posh-git)
- [GitUI](https://github.com/extrawurst/gitui)
- [WinFetch](https://github.com/lptstr/winfetch)
- [GitOpen](https://github.com/paulirish/git-open)

# Apperance

- [Nerd Font - CascadiaCode](https://github.com/ryanoasis/nerd-fonts)

# Installation

1. Clone this repository to your local machine.

   ```bash
   git clone https://github.com/ahmet-cetinkaya/dotfiles-public.git
   ```

2. Open a terminal.

3. Navigate to the repository directory.

   ```bash
   cd path/to/dotnet-public
   ```

4. Create a symbolic link for your PowerShell profile using the `mklink` command:

   ```bash
   mklink %USERPROFILE%/Documents/PowerShell/Microsoft.PowerShell_profile.ps1 "YOUR_REPO_PATH/powershell/Microsoft.PowerShell_profile.ps1"
   ```

   This command creates a symbolic link named `Microsoft.PowerShell_profile.ps1` in your PowerShell profile directory, pointing to the corresponding file in your repository.

5. Close and reopen your terminal or restart PowerShell to apply the changes.

# Updating Configuration

If you make changes to your PowerShell profile within the repository, they will automatically reflect in PowerShell. You don't need to manually copy files or update configurations.

Happy scripting!