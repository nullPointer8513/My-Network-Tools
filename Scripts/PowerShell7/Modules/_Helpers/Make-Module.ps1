<#
.SYNOPSIS
Creates a module package

.DESCRIPTION
Creates a module package with all the necessary files preconfigured

.EXAMPLE
Make-Module "Verb-Noun"

.NOTES
Contact Michael Wheeler(55379) for help or suggestions.
#>

# params
[CmdletBinding()]
Param (
    <#
    [String]ModuleName | name of the module you want to create
    #>
    [Alias('ModuleName')]
    [Parameter(
        mandatory = $true,
        Position = 0
    )]
    [String]$param_moduleName
)



# vars
Write-Debug "vars =========="
## config

## param
Write-Debug "param_moduleName    = $($param_moduleName)"

## const
[String]$path_moduleRoot         = (Get-Item $PSScriptRoot).Parent
[String]$path_moduleTemplate     = "$($PSScriptRoot)\module.psm1"
[String]$path_configTemplate     = "$($PSScriptRoot)\config.json"
[String]$path_readmeTemplate     = "$($PSScriptRoot)\readme.md"

## dynamic
[String]$path_moduleFolder       = "$($path_moduleRoot)\$($param_moduleName)"
Write-Debug "path_moduleFolder   = $($path_moduleFolder)"

[String]$path_manifestFile       = "$path_moduleRoot\$($param_moduleName)\$($param_moduleName).psd1"
Write-Debug "path_manifestFile   = $($path_manifestFile)"



# functions





# logic
Write-Debug "logic =========="
try {
    ## make folder
    Write-Debug "Making module folder"
    New-Item -Path $path_moduleRoot -Name $param_moduleName -ItemType "Directory" | Out-Null

    ## copy module
    Write-Debug "Copying module file"
    Copy-Item -Path $path_moduleTemplate -Destination $path_moduleFolder

    ## rename module
    Write-Debug "renaming module file"
    Rename-Item -Path "$($path_moduleFolder)/module.psm1" -NewName "$($param_moduleName).psm1"

    ## make manifest
    Write-Debug "Making manifest file"
    New-ModuleManifest -Path $path_manifestFile -CompanyName "BCSO" -Author "Michael Wheeler" -ModuleVersion "1.0.0" -RootModule "$($param_moduleName).psm1" -RequiredModules "Invoke-Helpers"

    ## copy config file
    Write-Debug "Copying config file"
    Copy-Item -Path $path_configTemplate -Destination $path_moduleFolder

    ## copy readme file
    Write-Debug "Copying readme file"
    Copy-Item -Path $path_readmeTemplate -Destination $path_moduleFolder

    exit 0 # success
} catch {
    Write-Error "Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
