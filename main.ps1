
function start_wow($main) {
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.Clipboard]::Clear()
    Start-Process $main
}

function main() {
    $wow = $(Get-ChildItem -Filter "wow*64.exe")
    if ($null -eq $wow) {
        $wow = $(Get-ChildItem -Filter "*wow.exe")
    }

    start_wow $wow
}

main