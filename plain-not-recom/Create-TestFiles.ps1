##################################################################################
#
#
#  Script name: SetFolderPermission.ps1
#  Author:      goude@powershell.nu
#  Homepage:    www.powershell.nu
#
#
##################################################################################

param ([string]$FilePath1, [string]$FilePath2, [switch]$help)

function GetHelp() {

$HelpText = @"

DESCRIPTION:
NAME: SetFolderPermission.ps1
Sets FolderPermissions for User on a Folder.
Creates folder if not exist.

PARAMETERS: 
-Path           Folder to Create or Modify (Required)
-User           User who should have access (Required)
-Permission     Specify Permission for User, Default set to Modify (Optional)
-help           Prints the HelpFile (Optional)

SYNTAX:
./SetFolderPermission.ps1 -Path C:\Folder\NewFolder -Access Domain\UserName -Permission FullControl

Creates the folder C:\Folder\NewFolder if it doesn't exist.
Sets Full Control for Domain\UserName

./SetFolderPermission.ps1 -Path C:\Folder\NewFolder -Access Domain\UserName

Creates the folder C:\Folder\NewFolder if it doesn't exist.
Sets Modify (Default Value) for Domain\UserName

./SetFolderPermission.ps1 -help

Displays the help topic for the script

Below Are Available Values for -Permission

"@
$HelpText

[system.enum]::getnames([System.Security.AccessControl.FileSystemRights])

}

# Start creating two test files if now exist
if (-not (Test-Path $FilePath1 -PathType leaf)) { 
    $newFile = New-Item $FilePath1 -ItemType File
    Write-Host "Just created the First file to $($newFile.FullName)"
    } 

if (-not (Test-Path $FilePath2 -PathType leaf)) { 
    $newFile = New-Item $FilePath2 -ItemType File
    Write-Host "Just created the Second file to $($newFile.FullName)"
    } 