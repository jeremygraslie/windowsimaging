How to Create a Windows PE Boot Drive
======================================

#### Necessary Materials:
+ 8 GB USB Flash Drive

#### Create a WindowsPE boot drive
1. Open the **Start Menu** > Search for **Deployment and Imaging Tools Environment**.  
2. Right-click and **Run As Administrator**
3. Run the following command to copy WindowsPE onto a local folder: 

    `CopyPE amd64 C:\Deployment\WinPE`

    Keep the window open to complete a later step. 
    
    Note: This will create the WinPE folder at that location.

4. Navigate to the WinPE\Sources folder

    `Set-Location -Path "C:Deployment_Test\WinPEx64\media\Sources"`

5. Mount the boot.wim file located in this Sources folder to the WinPE folder

    `Mount-WindowsImage -ImagePath "C:\Deployment_Test\WinPEx64\media\sources\boot.wim" -Index 1 -Path "C:\Deployment_Test\Wim_Mounts\WinPE"`

6. Install Network and Storage drivers onto the WinPE image

    `Add-WindowsDriver -Path "C:\Deployment_Test\Wim_Mounts\WinPE" -Driver "C:\Deployment_Test\Drivers\...\Storage\" -Recurse`

    `Add-WindowsDriver -Path "C:\Deployment_Test\Wim_Mounts\WinPE" -Driver "C:\Deployment_Test\Drivers\...\Network\" -Recurse`

    Note: Repeat this for every model of computer you are expecting to image.

7. Dismount the WindowsPE folder and save all changes

    `Dismount-WindowsImage -Path "C:\Deployment_Test\Wim_Mounts\WinPE" -Save`

8. Switch back to the Deployment and Imaging Tools Environment, run the following command to copy the WinPE files to make a bootable USB drive

    `MakeWinPEMEdia /UFD C:\Deployment_Test\Wim_Mounts\WinPE [USB Drive letter]:`

9. Close out of the Deployment and Imaging Tools Environment window.