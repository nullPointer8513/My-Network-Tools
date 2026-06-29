function Get-ScriptName {

}



function Get-FunctionName {
    <#
    .SYNOPSIS
    Gets function name

    .DESCRIPTION
    Gets function name of the last called function before "Write-Text" for logging

    .EXAMPLE
    $functionName = Get-FunctionName

    .NOTES
    Intended to be used as a helper function for other scripts
    #>



    # params
    [CmdletBinding()]
    param (
        <#
        [null] | none
        #>
    )



    # vars
    ## const
    [int]$StackNumber = 2

    ## dynamic




    # logic
    try {
        return [string]$(Get-PSCallStack)[$StackNumber].FunctionName
    } catch {
        # TODO
    }    
}



function Write-Text {
    <#
    .SYNOPSIS
    Write text to multiple outputs

    .DESCRIPTION
    Write text to multiple outputs simultaneously, such as console and log

    .EXAMPLE
    Write-Text "text" 'console, debug'

    .NOTES
    Intended to be used as a helper function for other scripts
    #>



    # params
    [CmdletBinding()]
    param (
        <#
        [String]Text | The text you want to capture
        #>
        [Alias('Text')]
        [Parameter(
            mandatory,
            Position = 0
        )]
        [String]$param_text,

        <#
        [Array]Destinations | The destinations where you want the text to appear
        #>
        [Alias('Destinations')]
        [Parameter(
            Position = 1
        )]
        [Array]$param_destinations = 'console',

        <#
        [String]DebugPassthrough | passes the debug state of the parent script
        #>
        [Alias('DebugPassthrough')]
        [Parameter(
            Position = 2
        )]
        [String]$param_debugPassthrough = 'SilentlyContinue',

        <#
        [Switch]InitLog | initializes log for next dumb
        #>
        [Alias('InitLog')]
        [Parameter()]
        [Switch]$param_initLog
    )



    # vars
    ## const
    [String]$logPath = "C:\Users\$($env:USERNAME)\PS Module Logs\$(Get-FunctionName).log"

    ## dynamic
    [String]$date = Get-Date -Format 'yyyy-MM-dd'
    [String]$time = Get-Date -Format 'HH:mm:ss.fff'



    # logic
    try {
        if ($param_initLog -eq $true) {
            if ((Test-Path -Path $logPath) -eq $true) {
                # do nothing
            } else {
                New-Item -Path $logPath -ItemType 'File' | Out-Null
            }
            
            Out-File -FilePath $logPath -InputObject "[$($time)] (Log    ) ========== $(Get-ScriptName) $($date) $($time) ==========" -Append
        }
    
        foreach ($destination in $param_destinations) {
            switch -Regex -CaseSensitive ($destination) {
                '^(log)$' {
                    Out-File -FilePath $logPath -InputObject "[$($time)] (Log    ) {$(Get-FunctionName)} $($param_text)" -Encoding "ASCII" -Append
                }
    
                '^(console)$' {
                    Out-File -FilePath $logPath -InputObject "[$($time)] (Console) {$(Get-FunctionName)} $($param_text)" -Encoding "ASCII" -Append
                    Write-Output $param_text
                }
    
                '^(debug)$' {
                    $DebugPreference = $param_debugPassthrough
                    Out-File -FilePath $logPath -InputObject "[$($time)] (Debug  ) {$(Get-FunctionName)} $($param_text)" -Encoding "ASCII" -Append
                    Write-Debug $param_text
                    $DebugPreference = 'SilentlyContinue'
                }
    
                '^(error)$' {
                    Out-File -FilePath $logPath -InputObject "[$($time)] (Error  ) {$(Get-FunctionName)} $($param_text)" -Encoding "ASCII" -Append
                    Write-Error "{$(Get-FunctionName)} $($param_text)"
                    # copy under error in main module -> return # ends script early
                }
    
                default {
                    # TODO
                }
            }
        }
    } catch {
        # TODO
    }
}



function Get-Config # TODO FIX PARSING past first nested layer
{
    <#
    .SYNOPSIS
    Gets the config file

    .DESCRIPTION
    Gets the config file the is used to input setting parameters

    .EXAMPLE
    $config = Get-Config

    .NOTES
    Intended to be used as a helper function for other scripts
    #>



    # params
    [CmdletBinding()]
    param (
        <#
        [null] | none
        #>
    )



    # vars
    ## const
    [String]$configPath = "$((Get-Item $PSScriptRoot).parent)\$(Get-FunctionName)\config.json"

    ## dynamic
    [String]$configJson = $null



    # logic
    try {
        if ((Test-Path $configPath) -eq $true) {
            $configJson = Get-Content -Path $configPath -Raw
            return ConvertFrom-Json -InputObject $configJson
        } else {
            # do nothing
        }
    } catch {
        # TODO
    }
}
