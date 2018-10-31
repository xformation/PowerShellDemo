function New-Folder {
    <#
    .SYNOPSIS
        This cmdlet will Create a new folder with righ access permission

    .DESCRIPTION
        This cmdlet will Create a new folder with righ access permission, it will also show some help information

    .PARAMETER Owner
        The owner of the repo, default to be the authenticated user. When used by itself, retrieves the information for all (public - unless the authenticated user is specified) repos for the specified owner.
    .PARAMETER Repository
        The name of the GitHub repository (not full name)

    .PARAMETER License
        When this switch is turned on, you will only get the info about the license of the repository. Can be used only when specifying the Respository Parameter.

    .PARAMETER ReadMe
        When this switch is turned on, you will only get the info about the README of the repository. Can be used only when specifying hte Repository Parameter.

    .OUTPUTS
        Create the folder with right permission, and shows some messages about successful creation or updation
        

    .EXAMPLE
        PS C:\> New-Folder -Path
        shows the help

    .EXAMPLE
        PS C:\>New-Folder -Path C:\Folder\NewFolder -Access Domain\UserName -Permission FullControl
        Create the folder with permission

    #>

    [CmdletBinding()]
    
    param(
        [Parameter(
            Position=0, 
            Mandatory=$false, 
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)
        ]
        [string] $Path,
        [Parameter(
            Position=1, 
            Mandatory=$false, 
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)
        ]
        [string] $Access,
        [Parameter(
            Position=2, 
            Mandatory=$false, 
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)
        ]
        [string] $Permission = ("Modify"),
        [switch] $help
    )

    begin {
        if ($help) { GetHelp }       
    }

    process {
        try
        {
            if ($Path -AND $Access -AND $Permission) { 
                CreateFolder $Path | Out-Null
                SetAcl $Path $Access $Permission | Out-Null
            }
        }
        catch
        {
            Return
        }
    }

    end {
        Write-Debug "About to exit New-Folder, anything else?"
        Write-Verbose "Exited New-Folder"
    }
}
Function GetHelp 
    {
        $HelpText = "
        DESCRIPTION:
            NAME: NewFolder.ps1
            Sets FolderPermissions for User on a Folder.
            Creates folder if not exist.

            PARAMETERS: 
            -Path           Folder to Create or Modify (Required)
            -User           User who should have access (Required)
            -Permission     Specify Permission for User, Default set to Modify (Optional)
            -help           Prints the HelpFile (Optional)

            SYNTAX:
            New-Folder -Path C:\Folder\NewFolder -Access Domain\UserName -Permission FullControl

            Creates the folder C:\Folder\NewFolder if it doesn't exist.
            Sets Full Control for Domain\UserName

            New-Folder -Path C:\Folder\NewFolder -Access Domain\UserName

            Creates the folder C:\Folder\NewFolder if it doesn't exist.
            Sets Modify (Default Value) for Domain\UserName

            New-Folder -help

            Displays the help topic for the script

            Below Are Available Values for -Permission
        "
        $HelpText
        [system.enum]::getnames([System.Security.AccessControl.FileSystemRights])
    }
    Function CreateFolder ([string]$Path) {

        # Check if the folder Exists
    
        if (Test-Path $Path) {
            Write-Host "Folder: $Path Already Exists" -ForeGroundColor Yellow
        } else {
            Write-Host "Creating $Path" -Foregroundcolor Green
            New-Item -Path $Path -type directory | Out-Null
        }
    }
    Function SetAcl ([string]$Path, [string]$Access, [string]$Permission) {

        # Get ACL on FOlder
    
        $GetACL = Get-Acl $Path
    
        # Set up AccessRule
    
        $Allinherit = [system.security.accesscontrol.InheritanceFlags]"ContainerInherit, ObjectInherit"
        $Allpropagation = [system.security.accesscontrol.PropagationFlags]"None"
        $AccessRule = New-Object system.security.AccessControl.FileSystemAccessRule($Access, $Permission, $AllInherit, $Allpropagation, "Allow")
    
        # Check if Access Already Exists
    
        if ($GetACL.Access | Where { $_.IdentityReference -eq $Access}) {
    
            Write-Host "Modifying Permissions For: $Access" -ForeGroundColor Yellow
    
            $AccessModification = New-Object system.security.AccessControl.AccessControlModification
            $AccessModification.value__ = 2
            $Modification = $False
            $GetACL.ModifyAccessRule($AccessModification, $AccessRule, [ref]$Modification) | Out-Null
        } else {
    
            Write-Host "Adding Permission: $Permission For: $Access"
    
            $GetACL.AddAccessRule($AccessRule)
        }
    
        Set-Acl -aclobject $GetACL -Path $Path
    
        Write-Host "Permission: $Permission Set For: $Access" -ForeGroundColor Green
    }