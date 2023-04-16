# Aliases
Set-Alias touch New-Item
Set-Alias g git
Set-Alias gg gitui
Set-Alias lg lazygit
Set-Alias vim nvim

# Prompt
oh-my-posh init pwsh --config C:\code\config\PowerShell\ahmetcetinkaya.omp.json | Invoke-Expression

# Posh Git
$env:POSH_GIT_ENABLED = $true
Import-Module posh-git

# PSReadLine 
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -BellStyle None
Set-PSReadlineKeyHandler -Key 'Ctrl+Spacebar' -Function MenuComplete

# Winget
## Completion
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

# PSFzf
Import-Module PSFzf 
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
Import-Module posh-git


# Utilities
function which($command) {
	Get-Command -Name $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
function pubip {
	(Invoke-WebRequest http://ifconfig.me/ip).Content
}
function del-history($command) {
    $history = Get-History
    $commandEntries = $history | Where-Object { $_.CommandLine -match $Command }
    if ($commandEntries.Count -eq 0) {
        Write-Host "No matching commands found."
        return
    }
    foreach ($entry in $commandEntries) {
        Clear-History -Id $entry.Id
        Write-Host "Command deleted: $($entry.CommandLine)"
    }
}