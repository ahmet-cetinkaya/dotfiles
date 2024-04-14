# Aliases
Set-Alias touch New-Item
Set-Alias g git
Set-Alias gg gitui
Set-Alias vim nvim
Set-Alias code codium
Set-Alias exp explorer

# Starship
$env:STARSHIP_CONFIG = "C:\Users\ahmetcetinkaya\Configs\starship\starship.toml"
Invoke-Expression (&starship init powershell)

# Oh My Posh
# oh-my-posh init pwsh --config C:\code\config\PowerShell\ahmetcetinkaya.omp.json | Invoke-Expression
# oh-my-posh disable notice # Disable available update notice
# Posh Git
# $env:POSH_GIT_ENABLED = $true
# Import-Module posh-git

# PSReadLine 
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -BellStyle None
Set-PSReadlineKeyHandler -Key 'Ctrl+Spacebar' -Function MenuComplete

# PSFzf
#Import-Module PSFzf
#Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' #-PSReadlineChordReverseHistory 'Ctrl+r'

# Winget
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

# Utilities
function which($command) {
	Get-Command -Name $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function pubip {
	(Invoke-WebRequest http://ifconfig.me/ip).Content
}

function del-history($command) {
    $history = Get-History
    $commandEntries = $history | Where-Object { $_.CommandLine -match $command }
    if ($commandEntries.Count -eq 0) {
        Write-Host "No matching commands found."
        return
    }
    foreach ($entry in $commandEntries) {
        Clear-History -Id $entry.Id
        Write-Host "Command deleted: $($entry.CommandLine)"
    }
}

function mklink {
    param(
        [string]$source,
        [string]$destination
    )
    New-Item -ItemType SymbolicLink -Path $source -Target $destination
}
function dotnet-tools-update {
    param (
        [switch]$global
    )

    try {
        # List dotnet tools
        if ($global) {
            $tools = dotnet tool list --global | Select-String "^\S+" | ForEach-Object { $_.Matches[0].Value }
        } else {
            $tools = dotnet tool list | Select-String "^\S+" | ForEach-Object { $_.Matches[0].Value }
        }

        if ($tools) {
            Write-Host "Updating..."
            foreach ($tool in $tools) {
                # Update dotnet tools
                try {
                    if ($global) {
                        dotnet tool update -g $tool -v diag
                    } else {
                        dotnet tool update $tool -v diag
                    }
                }
                catch {
                    Write-Host "Failed to update $($tool): $_"
                }
            }
            Write-Host "Update completed."
        }
        else {
            Write-Host "No dotnet tools to update found."
        }
    }
    catch {
        Write-Host "An error occurred: $_"
    }
}
