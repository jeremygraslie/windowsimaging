

$DeploymentDirectory = "C:\"

set-location -Path "$DeploymentDirectory"

$FolderNames = 
(
    "Deployment",
    "Deployment\ISOs",
    "Deployment\Mounted_Image",
    "Deployment\Drivers",
    "Deployment\Wim_Files",
    "Deployment\Wim_Mounts",
    "Deployment\Windows_Updates",
    "Deployment\Windows_Updates\1903",
)

Write-Output "Creating folders in location $DeploymentDirectory..."

foreach ($Name in $FolderNames) {
    If (Test-Path -Path $Name) {
        Write-Output "Folder path '$Name' already exists."
    } else {
        Write-Output "Creating folder at C:\$Name"
        New-Item -Path . -ItemType "Directory" -Name $Name
    }    
}