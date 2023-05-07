using namespace System.*
class WowEnhanced {
    $wow = $null
    $temp
    [System.Diagnostics.Process] $runnng_app
    [Boolean] $state

    clearClip()
    {
        Write-Output $null | clip.exe
    }

    [System.IO.FileSystemInfo] clipSave()
    {
        $list = New-Object Collections.Generic.List[Object]
        foreach ($item in $(Get-Clipboard -Raw))
        {
            $list.Add($item)
        }
        $this.temp = (New-TemporaryFile)
        $list | Out-File $this.temp

        $this.clearClip()

        return $(if ($list.Count -le 1) {$this.temp} Else {$false})
    }
    getWorldOfWarcraft()
    {
        $this.wow = $(Get-ChildItem -Filter "wow*64.exe")
        if ($null -eq $this.wow) {
            $this.wow = $(Get-ChildItem -Filter "*wow.exe")
        }
    }
    start_wow()
    {
        if ($null -eq $this.wow)
        {
            Write-Error "Missing property of application World of Warcraft"
        } else {
            $w = Start-Process -FilePath $this.wow -PassThru
            $this.state = $true
            $this.runnng_app = $($w)
        }
    }

    [Boolean] isRunning()
    {  
        return !$($this.runnng_app.HasExited)
    }

    memClear()
    {
        Remove-Item $this.temp -Force
        $this.state = $null
        $this.temp = $null
        $this.wow = $null
        exit(1)
    }
}

function main() {
    $ewow = [WowEnhanced]::new()
    $ewow.getWorldOfWarcraft()
    $ewow.clipSave()
    $ewow.start_wow()
    while ($ewow.isRunning()) {
        continue
    }
    Set-Clipboard (Get-Content $ewow.temp)
    $ewow.memClear()
}

main