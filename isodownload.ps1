#### These instructions will allow you to download Windows 10 and customize it for deployment ###

# Make the folder structure to maintain consistency
set-location -Path "C:\"

$FolderNames = 
(
    "Deployment_Test",
    "Deployment_Test\ISO",
    "Deployment_Test\Mounted_Image",
    "Deployment_Test\Drivers",
    "Deployment_Test\Wim_Files",
    "Deployment_Test\Windows_Updates"
)

foreach ($Name in $FolderNames) {
    If (Test-Path -Path $Name) {
        Write-Output "Folder path $Name already exists."
    } else {
        Write-Output "Creating folder at C:\$Name"
        New-Item -Path . -ItemType "Directory" -Name $Name
    }    
}

# Set parameters for the command
# Example: ./isodownload.ps1 -Iso C:\Deployment_Test\testimage.iso -Build 1903
param(
    [string]$Iso, # used to take an input filepath for the Iso variable.  Example usage: -Iso C:\Deployment_Test\ISO\testimage.iso
    [string]$Build # Used to indicate which build of Windows it is.  Example usage: -Build 1903
)

# Set the variables
$Date = Get-Date -Format "yyyyMMdd"
$WindowsVersion = "Win10_$($Build)_V1_English_x64" #This should comply with the naming scheme when downloading a fresh Windows 10 iso
$UnmodifiedWim = "C:\Deployment_Test\Wim_Files\"
$WimName = "$Date-$WindowsVersion.wim"
$NewWimFile = "C:\Deployment_Test\Wim_Files\Build_$($Build)"
#$WimComplete = Join-Path -Path $NewWimFile -ChildPath "install.wim"

# Step 1: Download the Windows 10 ISO from here:
# https://www.microsoft.com/en-us/software-download/windows10ISO
# Choose English, and 64-bit version

# Mount the iso image to the computer
$IsoDriveLetter = (Mount-DiskImage -Imagepath $Iso | Get-Volume).DriveLetter
$OriginalWim = Join-Path -Path (Get-PSDrive -Name $IsoDriveLetter).Root -ChildPath "sources\install.wim"

# Copy the install.wim file over to the local drives, rename it to Today's date + install.wim
$WimFinalPath = Join-Path -Path $UnmodifiedWim -ChildPath $WimName
Copy-Item -Path $OriginalWim -Destination $WimFinalPath -Verbose -Force

# Un-mount the iso image 
Dismount-DiskImage -Imagepath $Iso
#Get-WindowsImage -ImagePath $WimFinalPath

# Extract just Windows 10 Pro from the entire installer
Export-WindowsImage -SourceImagePath $WimFinalPath -SourceName "Windows 10 Pro" -DestinationImagePath $NewWimFile\install.wim -DestinationName "Windows 10 Pro"
