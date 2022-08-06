<# Copyright 2022 jcarpenter48
Description: This script allows a user to customize the stubs they wish to generate for inclusion
in a patched mission.lvl for Battlefront II's console editions, enabling an approximation of addon
functionality as described at the bottom.
#> 

function Create-Stub($missionCode, $missionEra, $missionMode) { 
    <#$missionCode = "000"
    $missionEra = "k"
    $missionMode = "ctf"#>
    $dummystub = @"
local assetLocation = "addon\\$($missionCode)\\"
ReadDataFile(assetLocation .. "$($missionCode)$($missionEra)_$($missionMode)_actual.script")
ScriptCB_DoFile("$($missionCode)$($missionEra)_$($missionMode)_actual")
"@
    $dummystub
}

# .Net methods for hiding/showing the console in the background
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'

function Show-Console
{
    param ([Switch]$Show,[Switch]$Hide)
    if (-not ("Console.Window" -as [type])) { 

        Add-Type -Name Window -Namespace Console -MemberDefinition '
        [DllImport("Kernel32.dll")]
        public static extern IntPtr GetConsoleWindow();

        [DllImport("user32.dll")]
        public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
        '
    }

    if ($Show)
    {
        $consolePtr = [Console.Window]::GetConsoleWindow()

        # Hide = 0,
        # ShowNormal = 1,
        # ShowMinimized = 2,
        # ShowMaximized = 3,
        # Maximize = 3,
        # ShowNormalNoActivate = 4,
        # Show = 5,
        # Minimize = 6,
        # ShowMinNoActivate = 7,
        # ShowNoActivate = 8,
        # Restore = 9,
        # ShowDefault = 10,
        # ForceMinimized = 11

        $null = [Console.Window]::ShowWindow($consolePtr, 5)
    }

    if ($Hide)
    {
        $consolePtr = [Console.Window]::GetConsoleWindow()
        #0 hide
        $null = [Console.Window]::ShowWindow($consolePtr, 0)
    }
}
#Hide the terminal ASAP
show-console -hide
#we create a GUI for user friendliness
Add-Type -assembly System.Windows.Forms
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='Alt-Addon Stub Generator'
$main_form.Width = 490
$main_form.Height = 275
$main_form.AutoSize = $true
#user input section
$directoryLabel = New-Object System.Windows.Forms.Label
$directoryLabel.Text = "Enter Output Directory:"
$directoryLabel.Location  = New-Object System.Drawing.Point(10,10)
$directoryLabel.AutoSize = $true
$directoryBox = New-Object System.Windows.Forms.TextBox
$directoryBox.Location = New-Object System.Drawing.Point(10,35)
$directoryBox.Size = New-Object System.Drawing.Size(260,20)
$main_form.Controls.Add($directoryLabel)
$main_form.Controls.Add($directoryBox)

$missionCodeLabel = New-Object System.Windows.Forms.Label
$missionCodeLabel.Text = "Enter Number of Missions"
$missionCodeLabel.Location  = New-Object System.Drawing.Point(10,65)
$missionCodeLabel.AutoSize = $true
$missionCodeBox = New-Object System.Windows.Forms.TextBox
$missionCodeBox.Location = New-Object System.Drawing.Point(10,90)
$missionCodeBox.Size = New-Object System.Drawing.Size(260,20)
$main_form.Controls.Add($missionCodeLabel)
$main_form.Controls.Add($missionCodeBox)

$missionEraLabel = New-Object System.Windows.Forms.Label
$missionEraLabel.Text = "Enter Mission Era (e.g. c):"
$missionEraLabel.Location  = New-Object System.Drawing.Point(10,120)
$missionEraLabel.AutoSize = $true
$missionEraBox = New-Object System.Windows.Forms.TextBox
$missionEraBox.Location = New-Object System.Drawing.Point(10,145)
$missionEraBox.Size = New-Object System.Drawing.Size(260,20)
$main_form.Controls.Add($missionEraLabel)
$main_form.Controls.Add($missionEraBox)

$missionModeLabel = New-Object System.Windows.Forms.Label
$missionModeLabel.Text = "Enter Mission Mode (e.g. ctf):"
$missionModeLabel.Location  = New-Object System.Drawing.Point(10,175)
$missionModeLabel.AutoSize = $true
$missionModeBox = New-Object System.Windows.Forms.TextBox
$missionModeBox.Location = New-Object System.Drawing.Point(10,200)
$missionModeBox.Size = New-Object System.Drawing.Size(260,20)
$main_form.Controls.Add($missionModeLabel)
$main_form.Controls.Add($missionModeBox)

$genButton = New-Object System.Windows.Forms.Button
$genButton.Location = New-Object System.Drawing.Size(320,10)
$genButton.Size = New-Object System.Drawing.Size(120,23)
$genButton.Text = "Generate"
$main_form.Controls.Add($genButton)

$genProgressLabel = New-Object System.Windows.Forms.Label
$genProgressLabel.Text = "Hit Generate!"
$genProgressLabel.Location  = New-Object System.Drawing.Point(320,205)
$genProgressLabel.AutoSize = $true
$main_form.Controls.Add($genProgressLabel)
#$directory = Read-Host -Prompt 'Input desired output directory'
$genButton.Add_Click(
{
    $genProgressLabel.Text = "Working..."
    $directory = $directoryBox.Text
    $missionCeiling = $missionCodeBox.Text
    $missionCeiling = [int]$missionCeiling
    $counter = 0
    while ($counter -le $missionCeiling) {
        #do stuff
        $missionCode = ([string]$counter).PadLeft(3, '0')
        $missionEra = $missionEraBox.Text
        $missionMode = $missionModeBox.Text
        $dummystub = Create-Stub $missionCode $missionEra $missionMode
        New-Item $directory\$($missionCode)$($missionEra)_$($missionMode).lua
        Set-Content $directory\$($missionCode)$($missionEra)_$($missionMode).lua $dummystub
        $counter++
        }
    $genProgressLabel.Text = "Done!"
}
)

$main_form.ShowDialog() #display call must go at end
<#
Reasoning:
What we plan to do here is create a 'patch' mission.lvl (built off of BAD-AL's alt-addon mission.lvl)
that contains, say, 128 mostly empty mission .luas, 64 XXXc_con and 64 XXXg_con (this is arbitrary,
we can do however many we want within reasonable limits that don't break the mission.lvl) where XXX
are three digit mission combos like 005. 

BAD-AL's patched shell.lvl will read in an addonXXX.lvl like it normally does, but instead of having to 
merge a mission.lvl with his MissionMerge, the game will try to load up the dummy mission in our patched
mission.lvl. These dummy missions are as below, pointing to the actual mission script in the associated XXX
addon folder (for standards' sake).

While not clean, I've implemented this so users can add future single map updates to my Alt-Addon map pack
without needing a Windows PC. These dummy missions are simply unused, only displayed once an addon.lvl 'addme'
places them in the instant action list for selection. The game, which always first tries mission.lvl, will
read the dummy mission and get redirected to where the actual addon should be.

In this way, the Alt-Addon system's functionality is extended to not require a Windows PC or MissionMerge
so long as the user is only installing single maps limited to whatever eras/modes we implement in the patched lvl.

Again, not super clean or programmatic, but a brute force method that I think will work fine.
#> 

<# #unused
# add era options
$missionEraCheckboxC = New-Object System.Windows.Forms.Checkbox 
$missionEraCheckboxC.Location = New-Object System.Drawing.Size(10,145) 
$missionEraCheckboxC.Size = New-Object System.Drawing.Size(50,20)
$missionEraCheckboxC.Text = "era c"
$missionEraCheckboxC.TabIndex = 4
$main_form.Controls.Add($missionEraCheckboxC)

$missionEraCheckboxG = New-Object System.Windows.Forms.Checkbox 
$missionEraCheckboxG.Location = New-Object System.Drawing.Size(70,145) 
$missionEraCheckboxG.Size = New-Object System.Drawing.Size(50,20)
$missionEraCheckboxG.Text = "era g"
$missionEraCheckboxG.TabIndex = 4
$main_form.Controls.Add($missionEraCheckboxG)
#>
