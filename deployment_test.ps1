# Set the variables
$DiskImagePath = "C:\Deployment_Test\ESD\"
$EsdSourcePath = "D:\Sources\install.esd"
$EsdDestPath = "C:\Deployment_Test\ESD"
$Date = Get-Date -Format "MM_dd_yyyy"

# Mount the iso image
Mount-DiskImage -Imagepath C:\Deployment_Test\ISO\Windows10.iso

# Find the install.esd file and copy over to the local drive
copy-item -Path D:\Sources\install.esd -Destination C:\Deployment_Test\ESD\$($Date)_install.esd

# Un-mount the iso image
Dismount-DiskImage -Imagepath C:\Deployment_Test\ISO\Windows10.iso

# Extract the .wim file from the .esd file
dism /Get-WimInfo /WimFile:C:\Deployment_Test\ESD\$($Date)_install.esd
dism /export-image /SourceImageFile:C:\Deployment_Test\ESD\$($Date)_install.esd /SourceIndex:6 /DestinationImageFile:C:\Deployment_Test\WIM\$($Date)_install.wim /Compress:max /CheckIntegrity
# Powershell equivalent ## Export-WindowsImage -SourceImagePath C:\Deployment_Test\ESD\install.esd -SourceIndex 6 -DestinationImagePath C:\Deployment_Test\WIM\install.wim

# Mount the .wim file to start manipulating it
dism /Mount-Image /ImageFile:C:\Deployment_Test\WIM\$($Date)_install.wim /Name:"Windows 10 Pro" /MountDir:C:\Deployment_Test\OfflineImages

# Show installed Appx Packages
#dism /Image:C:\Deployment_Test\OfflineImages /Get-ProvisionedAppxPackages

# Remove bloat Appx Packages
$AppxPackages = 
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
    "Microsoft.ZuneVideo_2019.18111.17311.0_neutral_~_8wekyb3d8bbwe"

# Iterate through a loop and remove each Package
foreach ($Package in $AppxPackages)
{
    dism /Image:C:\Deployment_Test\OfflineImages /Remove-ProvisionedAppxPackage /PackageName:$($Package)
    #Write-Output something about progress
}

# Add other packages


# Enable features


# Install all updates from the driver folder, recursively
dism /Image:C:\Deployment_Test\OfflineImages /Add-Driver /Driver:C:\Deployment_Test\Drivers /Recurse
