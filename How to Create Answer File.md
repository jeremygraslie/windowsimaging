How to Create the Answer file for Unattended Installation - Windows 10
======================================================================

#### Prerequesites:
+ Download and install Windows Assessment and Deployment Kit: https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install
+ Download and install the Windows PE add-on for the ADK in the same page
+ Have a copy of your install.wim file from a Windows 10 installation media

## Install the Windows ADK
1. Choose **Install the Windows Assessment and Deployment Kit - Windows 10 to this computer**, click **Next**
2. Check the **Deployment Tools** package.  This includes Windows System Image Manager.
3. Click **install**, then close out of the installer

## Setting up the Answer File Environment
1. Open Start > Search for **Windows System Image Manager** > Right-Click and select **Run as Administrator**
2. Click **File** and select the **Select Windows Image** option
3. Navigate to your custom.wim file created in the Imaging Instructions document (Should be in `C:\Deployment\Wim_Files`)
4. If you receive a prompt to select an image, choose **Windows 10 Pro**.  Note: This may not happen because we extracted the individual image earlier in the imaging process.
5. Click Yes to create a new Catalog File.  This can be reused later on other projects.
6. Click **File** > Select a **Distribution Share** > Choose the folder that you're using to store the project folders and files (`C:\Deployment`)
7. Click **File** > Select **New Answer File**

## Customizing the Answer File

### Pass 1: WindowsPE

##### Configuring Language and Region Settings
1. Under "Windows Image", expand the **Components** folder
2. Expand the **amd64_Microsoft-Windows-International-Core-WinPE** component
3. Right-click **SetupUILanguage** > select **Add Setting to Pass 1 WindowsPE**
4. Under the *Answer File* column, select the **amd64_Microsoft-Windows-International-Core-WinPE** component and define the following settings on the right side:

    + InputLocale: en-US
    + SystemLocale: en-US
    + UILanguage: en-US
    + UserLocale: en-US

5. Expand the **amd64_Microsoft-Windows-International-Core-WinPE** component and select the **SetupUILanguage** sub-component
6. Define the following settings on the right side:

    + UILanguage: en-US

##### Configuring Installation Settings
1. Under "Windows Image", expand the **Components** folder
2. Expand the **amd64-Microsoft-Windows-Setup_neutral** component
3. Expand the **Disk** sub-component
4. Expand the **Create Partitions** sub-component
5. Right-click **Create Partition** > select **Add Setting to Pass 1 WindowsPE**
6. Expand the **Modify Partitions** sub-component
7. Right-click **Modify Partition** > select **Add Setting to Pass 1 WindowsPE**
8. Under the *Answer File* Column, select the **Disk**, define the following information in the Properties Column:

    + Action: AddListItem
    + DiskID: 0
    + WillWipeDisk: TRUE

9. Highlight "Create Partitions" > Right-click and select "New Partition".  Repeat this to add four partitions.  Fill the Properties out with the following settings:

#### Partition 1:
    Action: AddListItem
    Extend: False
    Order: 1
    Size: 300
    Type: Primary

#### Partition 2:
    Action: AddListItem
    Extend: False
    Order: 2
    Size: 100
    Type: EFI

#### Partition 3:
    Action: AddListItem
    Extend: False
    Order: 3
    Size: 128
    Type: MSR

#### Partition 4:
    Action: AddListItem
    Extend: True
    Order: 4
    Size: 
    Type: Primary

10. Highlight "Modify Permissions" 