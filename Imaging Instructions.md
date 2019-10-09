Windows PC Imaging Instructions
===================================

This guide will walk you through the entire Windows PC imaging process from start to finish by creating a custom installation of Windows.  
This guide is applicable for Windows 10, version 1903.
-----------------------------------

### System Preparation
1. Install Windows ADK
2. Download the Powershell scripts in the Deployment folder

#### Create the local directory structure
1. Download and run `folderstructure.ps1`.  This creates all of the folders used in the rest of the imaging scripts and file locations.

#### Download Windows 10 and all updates
1. Navigate to https://www.microsoft.com/en-us/software-download/windows10ISO
2. Download the 64-bit version of Windows 10, Current version is May 2019 edition, and store it in `C:\Deployment\ISO\`
3. Navigate to https://support.microsoft.com/en-us/help/4498140/windows-10-update-history for a list of all updates available for the current version of Windows

    Example: KB4517211, release date September 26, 2019

4. Navigate to https://www.catalog.update.microsoft.com/home.aspx and search for the most recent update via the KB number
5. Download the update and store it in `C:\Deployment\Windows_Updates\`

#### Download all drivers for your machine(s)
1. Navigate to the computer's OEM website
2. Find the appropriate SCCM driver package(s) for your models, and download them to `C:\Deployment\Drivers\`
3. If SCCM drivers are not available, download all appropriate drivers individually

    Example: Lenovo's Thinkpad p51 drivers are located here: https://support.lenovo.com/us/en/downloads/ds121135

#### Mount the ISO to the computer, copy the sources\install.wim file
1. Right-click the ISO and select Mount
2. Navigate to the Sources directory of the mounted folder (likely, `D:\Sources\`)
3. Locate the install.wim file, copy to `C:\Deployment\Wim_Files\` created during the previous steps

#### Edit the .wim file to customize your build
1. Download and run `makewim.ps1`.  This will mount the .wim file copied in the previous step to the `\Mounted_Image` folder, install all of the drivers in the `\Drivers` folder, then install the Windows updates in the `\Windows_Updates` folder onto the .wim file.
The Wim file will then dismount at the end of the script.

#### Create an Answer File
+ See the "How to Create an Answer File" document for instructions

#### Create a WindowsPE boot drive
+ See the "How to Create a WindowsPE Boot Drive" document for instructions

#### Prepare an external drive with all necessary files

1. Copy the custom.wim file created using the makewim.ps1 script to the external drive.
2. Copy the unattend.xml answer over to the external drive