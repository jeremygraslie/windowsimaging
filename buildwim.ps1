
# Make the folder structure to maintain consistency
param(
    [string]$Build # Used to indicate which build of Windows it is.  Example usage: -Build 1903
)

set-location -Path "C:\"

$FolderNames = 
(
    "Deployment_Test",
    "Deployment_Test\ISO",
    "Deployment_Test\Mounted_Image",
    "Deployment_Test\Drivers",
    "Deployment_Test\Wim_Files",
    "Deployment_Test\Wim_Files\Build_$($Build)",
    "Deployment_Test\Windows_Updates"
)

Write-Output "Creating folders in location C:\..."

foreach ($Name in $FolderNames) {
    If (Test-Path -Path $Name) {
        Write-Output "Folder path '$Name' already exists."
    } else {
        Write-Output "Creating folder at C:\$Name"
        New-Item -Path . -ItemType "Directory" -Name $Name
    }    
}

$MountedImage = "C:\Deployment_Test\Mounted_Image"
$Drivers = "C:\Deployment_Test\Drivers\"
$NewWimFile = "C:\Deployment_Test\Wim_Files\Build_$($Build)"

# Mount the .wim file to start manipulating it
Mount-WindowsImage -ImagePath "$NewWimFile\install.wim" -Index 1 -Path "$MountedImage"

# Use this to show installed Appx Packages
# dism /Image:$MountedImage /Get-ProvisionedAppxPackages
#Get-AppxProvisionedPackage -Path "$MountedImage"

# Remove bloat Appx Packages using the PackageName attribute.  These are non-essential packages.
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
    "Microsoft.ZuneVideo_2019.18111.17311.0_neutral_~_8wekyb3d8bbwe"
)

# Iterate through a loop and remove each Package in the above list
$i = 0  #Used just as a counter
foreach ($Package in $AppxPackages) {
    $i++ 
    Write-Output "Removing package $i of " $AppxPackages.Length  #Write-Output something about progress
    dism /Image:$MountedImage /Remove-ProvisionedAppxPackage /PackageName:$($Package)
    # Powershell equivalent:
    # Get-AppXPackage $AppxPackages | Remove-AppXPackage
    #Remove-AppxPackage -Path "$MountedImage" -PackageName "$Package"
}


# Install all Windows Updates
$WindowsUpdates = 
(
    "windows10.0-kb4497935-x64_e1e15758afc9d32ca57779428d145cfba3a12e4b.msu",
    "windows10.0-kb4501375-x64_c54071d9b24a8efb7a48714883cf141a66b8c395.msu",
    "windows10.0-kb4503293-x64_df9098dcf9761b5652aab2666438fb128c16ffe0.msu",
    "windows10.0-kb4505903-x64_af8c6ab868423055a750797b6d52c1bd67e15a95.msu",
    "windows10.0-kb4507453-x64_79902381f303bd21104b0f9067c086e5dd6cd3f2.msu"
)

$i = 0
foreach ($Update in $WindowsUpdates) {
    $i++
    Write-Output "Installing update $i of " $WindowsUpdates.Length
    Dism /Image:C:\Deployment_Test\Mounted_Image /Add-Package /PackagePath:C:\Deployment_Test\Windows_Updates\1903\$Update
    #Add-WindowsPackage -Path "$MountedImage" -PackagePath "C:\Deployment_Test\Windows_Updates\$Build\$Update"
}

# Install all drivers from the driver folder, recursively
#Add-WindowsDriver -Path $MountedImage -Driver $Drivers -Recurse
dism /Image:$MountedImage /Add-Driver /Driver:$Drivers /Recurse

# Unmount the image
#Dismount-WindowsImage
Dism /Unmount-Image /MountDir:$MountedImage /Commit


imagex /compress maximum /export "$NewWimFile\install.wim" 1 "$NewWimFile\final.wim"
