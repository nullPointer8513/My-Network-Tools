function Convert-MacAddress
{
    <#
    .SYNOPSIS
    Takes the passed in Mac Address and converts it to other formats

    .DESCRIPTION
    Takes the passed in Mac Address and converts it to other formats.
    Some Vendors use FF:FF:FF:FF:FF:FF formats and some use FFFF.FFFF.FFFF formats.
    This tool will convert from the passed in format to all known others in a list,
    or to a target format selected and optionally copy it to your clipboard.

    .INPUTS
    None.

    .OUTPUTS
    [String] | returns the converted mac address

    .NOTES
    Contact Michael Wheeler(55379) for help or suggestions.

    .EXAMPLE
    PS> Convert-MacAddress -Mac "a1b2.c3d4.e5f6" -Target "F:" -Copy $true

    Result = A1:B2:C3:D4:E5:F6 (will be copied to your clipboard)
    #>



    # params
    [CmdletBinding()]
    param (
        <#
        [String]Mac | Source Mac Address for format conversion.
        #>
        [Alias('Mac')]
        [Parameter(
            Mandatory,
            Position = 0
        )]
        [String]$param_mac,

        <#
        [String]Target | Desired Mac Address format, if not specified the script will return all known formats.
        Target format options:
        "f"  = f1f2f3f4f5f6
        "F"  = F1F2F3F4F5F6
        "f-" = f1-f2-f3-f4-f5-f6
        "F-" = F1-F2-F3-F4-F5-F6
        "f:" = f1:f2:f3:f4:f5:f6
        "F:" = F1:F2:F3:F4:F5:F6
        "f." = f1f2.f3f4.f5f6
        "F." = F1F2.F3F4.F5F6
        #>
        [Alias('Target')]
        [Parameter(
            Position = 1
        )]
        [String]$param_target = 'all',

        <#
        -Copy
        [Bool]Copy | choose whether or not to copy result to your clipboard.
        #>
        [Alias('NoCopy')]
        [Parameter(
            Position = 2
        )]
        [Switch]$param_noCopy
    )

    Write-Text "params ==========" 'log' -InitLog
    Write-Text "config = $($config)" 'debug' $DebugPreference
    Write-Text "Mac    = $($param_mac)" 'debug' $DebugPreference
    Write-Text "Target = $($param_target)" 'debug' $DebugPreference
    Write-Text "Copy   = $($param_noCopy)" 'debug' $DebugPreference
    Write-Text "Debug  = $($DebugPreference)" 'debug' $DebugPreference



    # vars
    Write-Text "vars ==========" 'log'
    ## config
    $config = Get-Config

    ## const
    [String]$console_lowercaseDetected      = "`"$($config.runtime.permutations[0])`" format detected"
    [String]$console_uppercaseDetected      = "`"$($config.runtime.permutations[1])`" format detected"
    [String]$console_lowercaseDashDetected  = "`"$($config.runtime.permutations[2])`" format detected"
    [String]$console_uppercaseDashDetected  = "`"$($config.runtime.permutations[3])`" format detected"
    [String]$console_lowercaseColonDetected = "`"$($config.runtime.permutations[4])`" format detected"
    [String]$console_uppercaseColonDetected = "`"$($config.runtime.permutations[5])`" format detected"
    [String]$console_lowercaseDotDetected   = "`"$($config.runtime.permutations[6])`" format detected"
    [String]$console_uppercaseDotDetected   = "`"$($config.runtime.permutations[7])`" format detected"
    [String]$console_noDelimiter            = "No delimiter to be removed"
    [String]$console_removingDash           = "Removing `"-`" delimiter"
    [String]$console_removingColon          = "Removing `":`" delimiter"
    [String]$console_removingDot            = "Removing `".`" delimiter"
    [String]$console_toLower                = "Converting to lowercase"
    [String]$console_toUpper                = "Converting to uppercase"
    [String]$console_addingDash             = "Adding `"-`" delimiter"
    [String]$console_addingColon            = "Adding `":`" delimiter"
    [String]$console_addingDot              = "Adding `".`" delimiter"

    ## dynamic
    [String]$mac_removedDelimiters          = $null
    [String]$mac_removedDelimitersTemp      = $null
    [String]$mac_caseConversion             = $null
    [String]$mac_addedDelimiters            = $null



    # functions
    # none



    # logic
    Write-Text "logic ==========" 'log'
    ## parse mac address
    Write-Text "!!! Parsing Mac Address ..." 'debug' $DebugPreference
    switch -Regex -CaseSensitive ($param_mac) {
        '^[a-z0-9]{12}$' { # "f" = ffffffffffff
            Write-Text $console_lowercaseDetected 'debug' $DebugPreference
            Write-Text $console_noDelimiter 'debug' $DebugPreference
            $mac_removedDelimiters = $param_mac
        }

        '^[A-Z0-9]{12}$' { # "F" = FFFFFFFFFFFF
            Write-Text $console_uppercaseDetected 'debug' $DebugPreference
            Write-Text $console_noDelimiter 'debug' $DebugPreference
            $mac_removedDelimiters = $param_mac
        }

        '^([a-z0-9]{2}\-){5}([a-z0-9]{2})$' { # "f-" = ff-ff-ff-ff-ff-ff
            Write-Text $console_lowercaseDashDetected 'debug' $DebugPreference
            Write-Text $console_removingDash 'debug' $DebugPreference
            $mac_removedDelimiters = $param_mac -replace '[\-]', ''
        }

        '^([A-Z0-9]{2}\-){5}([A-Z0-9]{2})$' { # "F-" = FF-FF-FF-FF-FF-FF
            Write-Text $console_uppercaseDashDetected 'debug' $DebugPreference
            Write-Text $console_removingDash 'debug' $DebugPreference
            $mac_removedDelimiters = $param_mac -replace '[\-]', ''
        }

        '^([a-z0-9]{2}\:){5}([a-z0-9]{2})$' { # "f:" = ff:ff:ff:ff:ff:ff
            Write-Text $console_lowercaseColonDetected 'debug' $DebugPreference
            Write-Text $console_removingColon 'debug' $DebugPreference
            $mac_removedDelimiters = $param_mac -replace '[\:]', ''
        }

        '^([A-Z0-9]{2}\:){5}([A-Z0-9]{2})$' { # "F:" = FF:FF:FF:FF:FF:FF
            Write-Text $console_uppercaseColonDetected 'debug' $DebugPreference
            Write-Text $console_removingColon 'debug' $DebugPreference
            $mac_removedDelimiters = $param_mac -replace '[\:]', ''
        }

        '^([a-z0-9]{4}\.){2}([a-z0-9]{4})$' { # "f." = ffff.ffff.ffff
            Write-Text $console_lowercaseDotDetected 'debug' $DebugPreference
            Write-Text $console_removingDot 'debug' $DebugPreference
            $mac_removedDelimiters = $param_mac -replace '[\.]', ''
        }

        '^([A-Z0-9]{4}\.){2}([A-Z0-9]{4})$' { # "F." = FFFF.FFFF.FFFF
            Write-Text $console_uppercaseDotDetected 'debug' $DebugPreference
            Write-Text $console_removingDot 'debug' $DebugPreference
            $mac_removedDelimiters = $param_mac -replace '[\.]', ''
        }

        default {
            Write-Error "`"$($param_mac)`" is not a valid Mac Address"
            return # ends script early
        }
    }
    Write-Text "Mac with delimiters removed: `"$($mac_removedDelimiters)`"" 'debug' $DebugPreference

    ## convert mac address
    Write-Text "!!! Converting Mac Address ..." 'debug' $DebugPreference
    if ($param_target -eq 'all') {
        foreach ($param_target in $config.runtime.permutations) {
            $mac_removedDelimitersTemp = $mac_removedDelimiters
            switch -CaseSensitive ($param_target) {
                'f' { # "f" = ffffffffffff
                    Write-Text $console_lowercaseDetected 'debug' $DebugPreference
                    $mac_caseConversion = $mac_removedDelimitersTemp.ToLower()
                    Write-Text "$($console_toLower) `"$($mac_caseConversion)`"" 'debug' $DebugPreference
                    $mac_addedDelimiters = $mac_caseConversion
                    Write-Text $mac_addedDelimiters
                }

                'F' { # "F" = FFFFFFFFFFFF
                    Write-Text $console_uppercaseDetected 'debug' $DebugPreference
                    $mac_caseConversion = $mac_removedDelimitersTemp.ToUpper()
                    Write-Text "$($console_toUpper) `"$($mac_caseConversion)`"" 'debug' $DebugPreference
                    $mac_addedDelimiters = $mac_caseConversion
                    Write-Text $mac_addedDelimiters
                }

                'f-' { # "f-" = ff-ff-ff-ff-ff-ff
                    Write-Text $console_lowercaseDashDetected 'debug' $DebugPreference
                    $mac_caseConversion = $mac_removedDelimitersTemp.ToLower()
                    Write-Text "$($console_toLower) `"$($mac_caseConversion)`"" 'debug' $DebugPreference
                    Write-Text $console_addingDash 'debug' $DebugPreference
                    $mac_addedDelimiters = $mac_caseConversion -split '([a-z0-9]{2})' -ne '' -join '-'
                    Write-Text $mac_addedDelimiters
                }

                'F-' { # "F-" = FF-FF-FF-FF-FF-FF
                    Write-Text $console_uppercaseDashDetected 'debug' $DebugPreference
                    $mac_caseConversion = $mac_removedDelimitersTemp.ToUpper()
                    Write-Text "$($console_toUpper) `"$($mac_caseConversion)`"" 'debug' $DebugPreference
                    Write-Text $console_addingDash 'debug' $DebugPreference
                    $mac_addedDelimiters = $mac_caseConversion -split '([A-Z0-9]{2})' -ne '' -join '-'
                    Write-Text $mac_addedDelimiters
                }

                'f:' { # "f:" = ff:ff:ff:ff:ff:ff
                    Write-Text $console_lowercaseColonDetected 'debug' $DebugPreference
                    $mac_caseConversion = $mac_removedDelimitersTemp.ToLower()
                    Write-Text "$($console_toLower) `"$($mac_caseConversion)`"" 'debug' $DebugPreference
                    Write-Text $console_addingColon 'debug' $DebugPreference
                    $mac_addedDelimiters = $mac_caseConversion -split '([a-z0-9]{2})' -ne '' -join ':'
                    Write-Text $mac_addedDelimiters
                }

                'F:' { # "F:" = FF:FF:FF:FF:FF:FF
                    Write-Text $console_uppercaseColonDetected 'debug' $DebugPreference
                    $mac_caseConversion = $mac_removedDelimitersTemp.ToUpper()
                    Write-Text "$($console_toUpper) `"$($mac_caseConversion)`"" 'debug' $DebugPreference
                    Write-Text $console_addingColon 'debug' $DebugPreference
                    $mac_addedDelimiters = $mac_caseConversion -split '([a-z0-9]{2})' -ne '' -join ':'
                    Write-Text $mac_addedDelimiters
                }

                'f.' { # "f." = ffff.ffff.ffff
                    Write-Text $console_lowercaseDotDetected 'debug' $DebugPreference
                    $mac_caseConversion = $mac_removedDelimitersTemp.ToLower()
                    Write-Text "$($console_toLower) `"$($mac_caseConversion)`"" 'debug' $DebugPreference
                    Write-Text $console_addingDot 'debug' $DebugPreference
                    $mac_addedDelimiters = $mac_caseConversion -split '([a-z0-9]{4})' -ne '' -join '.'
                    Write-Text $mac_addedDelimiters
                }

                'F.' { # "F." = FFFF.FFFF.FFFF
                    Write-Text $console_uppercaseDotDetected 'debug' $DebugPreference
                    $mac_caseConversion = $mac_removedDelimitersTemp.ToUpper()
                    Write-Text "$($console_toUpper) `"$($mac_caseConversion)`"" 'debug' $DebugPreference
                    Write-Text $console_addingDot 'debug' $DebugPreference
                    $mac_addedDelimiters = $mac_caseConversion -split '([a-z0-9]{4})' -ne '' -join '.'
                    Write-Text $mac_addedDelimiters
                } default {
                    # TODO
                }
            }
        }
    } else {
        switch -CaseSensitive ($param_target) {
            'f' { # "f" = ffffffffffff
                Write-Text $console_lowercaseDetected 'debug' $DebugPreference
                $mac_caseConversion = $mac_removedDelimiters.ToLower()
                Write-Text "$($console_toLower) `"$($mac_caseConversion)`"" 'debug' $DebugPreference
                $mac_addedDelimiters = $mac_caseConversion
            }

            'F' { # "F" = FFFFFFFFFFFF
                Write-Text $console_uppercaseDetected 'debug' $DebugPreference
                $mac_caseConversion = $mac_removedDelimiters.ToUpper()
                Write-Text "$($console_toUpper) `"$($mac_caseConversion)`"" 'debug' $DebugPreference
                $mac_addedDelimiters = $mac_caseConversion
            }

            'f-' { # "f-" = ff-ff-ff-ff-ff-ff
                Write-Text $console_lowercaseDashDetected 'debug' $DebugPreference
                $mac_caseConversion = $mac_removedDelimiters.ToLower()
                Write-Text "$($console_toLower) `"$($mac_caseConversion)`"" 'debug' $DebugPreference
                $mac_addedDelimiters = $mac_caseConversion -split '([a-z0-9]{2})' -ne '' -join '-'
                Write-Text $console_addingDash 'debug' $DebugPreference
            }
    
            'F-' # "F-" = FF-FF-FF-FF-FF-FF
            {
                Write-Text $console_uppercaseDashDetected 'debug' $DebugPreference
                $mac_caseConversion = $mac_removedDelimiters.ToUpper()
                Write-Text "$($console_toUpper) `"$($mac_caseConversion)`"" 'debug' $DebugPreference
                $mac_addedDelimiters = $mac_caseConversion -split '([A-Z0-9]{2})' -ne '' -join '-'
                Write-Text $console_addingDash 'debug' $DebugPreference
            }
    
            'f:' # "f:" = ff:ff:ff:ff:ff:ff
            {
                Write-Text $console_lowercaseColonDetected 'debug' $DebugPreference
                $mac_caseConversion = $mac_removedDelimiters.ToLower()
                Write-Text "$($console_toLower) `"$($mac_caseConversion)`"" 'debug' $DebugPreference
                $mac_addedDelimiters = $mac_caseConversion -split '([a-z0-9]{2})' -ne '' -join ':'
                Write-Text $console_addingColon 'debug' $DebugPreference
            }
    
            'F:' # "F:" = FF:FF:FF:FF:FF:FF
            {
                Write-Text $console_uppercaseColonDetected 'debug' $DebugPreference
                $mac_caseConversion = $mac_removedDelimiters.ToUpper()
                Write-Text "$($console_toUpper) `"$($mac_caseConversion)`"" 'debug' $DebugPreference
                $mac_addedDelimiters = $mac_caseConversion -split '([a-z0-9]{2})' -ne '' -join ':'
                Write-Text $console_addingColon 'debug' $DebugPreference
            }
    
            'f.' # "f." = ffff.ffff.ffff
            {
                Write-Text $console_lowercaseDotDetected 'debug' $DebugPreference
                $mac_caseConversion = $mac_removedDelimiters.ToLower()
                Write-Text "$($console_toLower) `"$($mac_caseConversion)`"" 'debug' $DebugPreference
                $mac_addedDelimiters = $mac_caseConversion -split '([a-z0-9]{4})' -ne '' -join '.'
                Write-Text $console_addingDot 'debug' $DebugPreference
            }
    
            'F.' # "F." = FFFF.FFFF.FFFF
            {
                Write-Text $console_uppercaseDotDetected 'debug' $DebugPreference
                $mac_caseConversion = $mac_removedDelimiters.ToUpper()
                Write-Text "$($console_toUpper) `"$($mac_caseConversion)`"" 'debug' $DebugPreference
                $mac_addedDelimiters = $mac_caseConversion -split '([a-z0-9]{4})' -ne '' -join '.'
                Write-Text $console_addingDot 'debug' $DebugPreference
            }
    
            default {
                # TODO
            }
        }

        Write-Text "Mac with added delimiters `"$($mac_addedDelimiters)`"" 'debug' $DebugPreference

        # return result
        Write-Text "!!! Returning data ..." 'debug' $DebugPreference
        Write-Text $mac_addedDelimiters
    }

    ## copy to clipboard
    if (($param_noCopy -eq $false) -and ($param_target -ne 'all')) {
        Write-Text "`"$($mac_addedDelimiters)`" copied to clipboard!"
        Set-Clipboard -Value $mac_addedDelimiters
    } else {
        # do nothing
    }
}
