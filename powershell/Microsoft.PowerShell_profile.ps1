# Aliases
Set-Alias g git
Set-Alias touch New-Item
Set-Alias vim nvim
Set-Alias lg lazygit

# Prompt
oh-my-posh init pwsh --config C:\code\config\PowerShell\ahmetcetinkaya.omp.json | Invoke-Expression

# Utilities
function which($command) {
	Get-Command -Name $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
function pubip {
	(Invoke-WebRequest http://ifconfig.me/ip).Content
}

# PSReadLine 
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -BellStyle None

# PSFzf
Import-Module PSFzf 
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
