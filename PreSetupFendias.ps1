####This script creates the FendiasDownload directory and copies cached updates to expedite the installation process
####TL 7/1/2022
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()
Add-Type -AssemblyName System.Drawing

$sync = [Hashtable]::Synchronized(@{})

$copyScript = {
    #Sync setup
    $count = [PowerShell]::Create().AddScript({
        $sync.button.Enabled = $false
        $sync.button.text = "Transfer In Progress"

        $sync.label.text = "Initiating transfer"
        [int]$pct = 0
        Get-Date > C:\Utilities\PreFendiasLog.txt
        mkdir C:\FendiasDownload >> C:\Utilities\PreFendiasLog.txt

        ###START COPY###
        $sync.label.text = "Copying Fendias V 1.2022"
        robocopy '\\e500srv6\Software\Fendias\NewFendiasData\Fendias V 1.2022' C:\FendiasDownload\ /e /copyall >> C:\Utilities\PreFendiasLog.txt
        [int]$pct += 6.5
        $sync.progressBar.Value = $pct

        $sync.label.text = "Copying Fendias V 1a.2022"
        robocopy '\\e500srv6\Software\Fendias\NewFendiasData\Fendias V 1a.2022' C:\FendiasDownload\ /e /copyall >> C:\Utilities\PreFendiasLog.txt
        [int]$pct += 2
        $sync.progressBar.Value = $pct

        $sync.label.text = "Copying Fendias V 3.2021"
        robocopy '\\e500srv6\Software\Fendias\NewFendiasData\Fendias V 3.2021' C:\FendiasDownload\ /e /copyall >> C:\Utilities\PreFendiasLog.txt
        [int]$pct += 91
        $sync.progressBar.Value = $pct

        $sync.label.text = "Copying Manifests"
        robocopy '\\e500srv6\Software\Fendias\NewFendiasData\manifests' C:\FendiasDownload\ /e /copyall >> C:\Utilities\PreFendiasLog.txt
        [int]$pct += 0.5
        $sync.progressBar.Value = $pct

        ###END COPY###
        [int]$pct = 100
        $sync.progressBar.Value = $pct
        $sync.label.text = "Transfer complete"
        $sync.button.Remove_Click()
        $sync.button.Add_Click()
        $sync.button.text = "Exit"
        $sync.button.Enabled = $true
    })

    $null = Register-ObjectEvent -InputObject $PowerShell -EventName InvocationStateChanged -Action {
        param([System.Management.Automation.PowerShell] $ps)
      
        # NOTE: Use $EventArgs.InvocationStateInfo, not $ps.InvocationStateInfo, 
        #       as the latter is updated in real-time, so for a short-running script
        #       the state may already have changed since the event fired.
        $state = $EventArgs.InvocationStateInfo.State
      
        Write-Host "Invocation state: $state"
        if ($state -in 'Completed', 'Failed') {
          # Dispose of the runspace.
          Write-Host "Disposing of runspace."
          $ps.Runspace.Dispose()
          # Speed up resource release by calling the garbage collector explicitly.
          # Note that this will pause *all* threads briefly.
          [GC]::Collect()
        }      
      
      }
      

    $runspace = [RunspaceFactory]::CreateRunspace()
    $runspace.ApartmentState = "STA"
    $runspace.ThreadOptions = "ReuseThread"
    $runspace.Open()
    $runspace.SessionStateProxy.SetVariable("sync", $sync)

    $count.Runspace = $runspace
    $result = $count.BeginInvoke()

    $PowerShell.EndInvoke($result)
    
    return -1

}

###FORM SETUP###
$form = New-Object Windows.Forms.Form
$form.ClientSize = New-Object Drawing.Size(400, 90)
$form.Text = "Pre-Setup for Fendias"
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false

#icon
$iconBase64 = '/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBAUEBAYFBQUGBgYHCQ4JCQgICRINDQoOFRIWFhUSFBQXGiEcFxgfGRQUHScdHyIjJSUlFhwpLCgkKyEkJST/2wBDAQYGBgkICREJCREkGBQYJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCT/wAARCAAgACADAREAAhEBAxEB/8QAGQABAAIDAAAAAAAAAAAAAAAACAEGAAUH/8QAMBAAAQMDAwEGAwkAAAAAAAAAAQIDBAAFBgcRMRIUFxghQZRU0dITIjJRVVZhcZH/xAAaAQACAwEBAAAAAAAAAAAAAAAFBwAEBgED/8QAKREAAQQBAgQGAwEAAAAAAAAAAQACAwQFETEVIZGhEhYyQVFSU9Hwgf/aAAwDAQACEQMRAD8A6Tk0t6345dZcZfQ+xEedbVtv0qCCQf8ARSKpxtksRsdsSB3WymcWxuI+ETO/nUT9fV7dr6aa/lnG/i7n9rNcRsfZR386h/uBXt2vpqeWcb+Luf2pxGx9kndLrzOyHArPdLk/9vMkNFTrnSE9R6iOB5elLPNV4692SKIaNB5dFoacjnwtc7dWlSUrSULSFJUNiCNwRQwHTmFYVI1KyPH9PcbduT9tgOSl7txWCynd1zb+uByaN4epZyFgRNcdPc6nkFTtyxwM8RA19katPsLuOrGZOF8lMYudonyEp2CEk/hHoCeAPlTHyuRixVQeHfZo/u6A1oHWZOf+piW23RbRAj2+CyliNHQG220jySkUoZpXyvMkh1J3WpYwMaGt2Ci6XOJZrdJuM55LMWM2XXVq4SkVIYXzSCKMak8guPeGNLnbBDjPMyn6q5klzrSzHU4GIbTrgShlBPKifIE8k/KnBjMfHi6mm53JG5P9sstYndZk16JI6eM4Xp/jjFqi5BZ1vH78l/tTe7zh5PPHoB+VLnLOvX7BmfE7T2Gh5BHqohgZ4Q4dVe4suPOjokxX2pDDg3Q40oKSofwR5Ggb2OY4teNCFda4OGoWh1EskzI8JvFpt6ULly45baStXSCdxyfSr2Jssr3I5pPSDzXhajMkTmN3KNXhx1A+Cg+7TTH82477HoUA4ZY+O6zw46gfBQfdpqebcd9j0KnDLHx3SS00sM3GMGtNouKEIlxWihxKFBQB6ieRzzS6zFmOzckmi9JPLoj1SN0cTWO3C//Z'
$iconBytes = [Convert]::FromBase64String($iconBase64)
$stream = [System.IO.MemoryStream]::new($iconBytes, 0, $iconBytes.Length)
$form.Icon = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($stream).GetHIcon()))

$button = New-Object Windows.Forms.Button
$button.Location = New-Object Drawing.Point(5, 60)
$button.Width = 385
$button.Text = "Start Transfer"
$button.Add_Click($copyScript)

$label = New-Object Windows.Forms.Label
$label.Location = New-Object Drawing.Point(5, 10)
$label.Width = 385
$label.Text = "Transfer not started"

$progressBar1 = New-Object System.Windows.Forms.ProgressBar
$progressBar1.Name = 'progressBar1'
$progressBar1.Value = 0
$progressBar1.Style="Continuous"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 400 - 15
$System_Drawing_Size.Height = 20
$progressBar1.Size = $System_Drawing_Size
$form.Controls.Add($progressBar1)
$progressBar1.Left = 5
$progressBar1.Top = 35

###Sync setup###
$sync.button = $button
$sync.button2 = $button2
$sync.label = $label
$sync.progressBar = $progressBar1
$sync.x = $x
$form.Controls.AddRange(@($sync.button, $sync.label, $sync.progressBar, $sync.x))

#START THE FORM#
[Windows.Forms.Application]::Run($form)

