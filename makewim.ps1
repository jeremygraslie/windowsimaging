$MountedImage = "C:\Deployment\Mounted_Image\"
$Updates = "C:\Deployment\Windows_Updates\1903"
$Drivers = "C:\Deployment\Drivers\"

# Extract just the Windows 10 Pro installer from the .wim file to a new .wim file
Export-WindowsImage -SourceImagePath "C:\Deployment\Wim_Files\install.wim" -SourceName "Windows 10 Pro" -DestinationImagePath "C:\Deployment\Wim_Files\custom.wim"

# Mount the .wim file to start manipulating it
Mount-WindowsImage -ImagePath "C:\Deployment\Wim_Files\custom.wim" -Index 1 -Path "$MountedImage"

# Remove bloat Appx Packages using the PackageName attribute.  These appear to be non-essential packages.
# Find installed packages with the following commandlet:
# Get-AppxProvisionedPackage -Path "$MountedImage"
$AppxPackages = 
(
    "Microsoft.BingWeather_4.25.20211.0_neutral_~_8wekyb3d8bbwe",
    "Microsoft.People_2019.123.2346.0_neutral_~_8wekyb3d8bbwe",
    "Microsoft.SkypeApp_14.35.152.0_neutral_~_kzf8qxf38zg5c",
    "Microsoft.Wallet_2.4.18324.0_neutral_~_8wekyb3d8bbwe",
    "Microsoft.Messaging_2019.125.32.0_neutral_~_8wekyb3d8bbwe",
    "Microsoft.Microsoft3DViewer_5.1902.20012.0_neutral_~_8wekyb3d8bbwe",
    "Microsoft.MixedReality.Portal_2000.19010.1151.0_neutral_~_8wekyb3d8bbwe",
    "Microsoft.OneConnect_5.1902.361.0_neutral_~_8wekyb3d8bbwe",
    "Microsoft.Print3D_3.3.311.0_neutral_~_8wekyb3d8bbwe",
    "Microsoft.WindowsFeedbackHub_2019.226.2324.0_neutral_~_8wekyb3d8bbwe",
    "microsoft.windowscommunicationsapps_16005.11029.20108.0_neutral_~_8wekyb3d8bbwe",
    "Microsoft.Xbox.TCUI_1.23.28002.0_neutral_~_8wekyb3d8bbwe",
    "Microsoft.XboxApp_48.48.7001.0_neutral_~_8wekyb3d8bbwe",
    "Microsoft.XboxGameOverlay_1.32.17005.0_neutral_~_8wekyb3d8bbwe",
    "Microsoft.XboxIdentityProvider_12.50.6001.0_neutral_~_8wekyb3d8bbwe",
    "Microsoft.XboxSpeechToTextOverlay_1.17.29001.0_neutral_~_8wekyb3d8bbwe",
    "Microsoft.YourPhone_2018.1128.231.0_neutral_~_8wekyb3d8bbwe",
    "Microsoft.ZuneMusic_2019.18111.17311.0_neutral_~_8wekyb3d8bbwe",
    "Microsoft.ZuneVideo_2019.18111.17311.0_neutral_~_8wekyb3d8bbwe",
    "Microsoft.XboxGamingOverlay_2.26.14003.0_neutral_~_8wekyb3d8bbwe",
    "Microsoft.MicrosoftSolitaireCollection_4.2.11280.0_neutral_~_8wekyb3d8bbw",
    "Microsoft.MicrosoftOfficeHub_18.1901.1141.0_neutral_~_8wekyb3d8bbwe",
    "Microsoft.Office.OneNote_16001.11126.20076.0_neutral_~_8wekyb3d8bbwe"
)

$Counter = 0
foreach ($Package in $AppxPackages)
{
    $Counter++
    Write-Output "Removing package $Counter of " $AppxPackages.Length
    Remove-AppxProvisionedPackage -Path "$MountedImage" -PackageName "$Package"
    
}

#Installs all Windows update packages found in the specified folder
Add-WindowsPackage -Path "$MountedImage" -PackagePath "$Updates" -IgnoreCheck

#Installs all drivers found in the specified folder.  Has no visible output during execute.
Add-WindowsDriver -Path "$MountedImage" -Driver "$Drivers" -Recurse -LogPath "C:\Deployment\driverinstalllogs.txt"

#Unmount the image so it is ready for packing
Dismount-WindowsImage -Path "$MountedImage" -Save