function FunctionName {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .EXAMPLE
    An example

    .NOTES
    Contact Michael Wheeler(55379) for help or suggestions.
    #>

    # params
    [CmdletBinding()]
    param (
        [Alias('Name')]
        [Parameter(
            Mandatory,
            position = 0
        )]
        [String]$param_name
    )

    Write-Text "params ==========" 'log' -InitLog



    # vars
    Write-Text "vars ==========" 'log'

    ## config
    $config = Get-Config
    Write-Text $config 'debug'

    ## dynamic




    # functions




    # logic
    Write-Text "logic ==========" 'log'
    try {
        

        exit 0
    } catch {
        Write-Text "Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])" 'error'
        exit 1
    }
}