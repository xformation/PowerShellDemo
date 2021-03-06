Function Rename-File {
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
        [string] $OldLocation,
        [Parameter(
            Position=1, 
            Mandatory=$false, 
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)
        ]
        [string] $NewLocation,
        [switch] $help
    )

    begin {
        if ($help) { GetHelp }       
    }

    process {
        try
        {
            if ($OldLocation -AND $NewLocation ) {                
                    if ((Test-Path -Path $OldLocation)) {
                        $movedFile = move-item -path $OldLocation -destination $NewLocation
                        #for wiered reason , rename-item dont work
                        # rename-item –path  $OldLocation  –newname $NewLocation
                        Write-Host "Just Renamed the file to $NewLocation"
                    }
                    else {
                        Write-Output -Message ('source file dont exist')
                    }
            }
        }
        catch
        {
            Return
        }
    }

    end {
        Write-Debug "About to exit Rename-File, anything else?"
        Write-Verbose "Exited Rename-File"
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
 