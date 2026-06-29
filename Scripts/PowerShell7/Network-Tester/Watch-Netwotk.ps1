# Vars
$targets = @(
    @("TargetName" , "TargetIP")
)

$logFileName = "ping_log.txt"

$count = 10 # used to get average
$sensitivity = 99 # + offset to average
$period = 250 # in ms

# logic
## check if log file exists, if not, make it
if (-not (Test-Path -Path "$($PSScriptRoot)\$($logFileName)" -PathType "Leaf")) { 
    Write-Output "Making log file..."
    New-Item "$($PSScriptRoot)\$($logFileName)" -ItemType "File"
    Out-File -FilePath "$($PSScriptRoot)\$($logFileName)" -InputObject "[$(Get-Date -Format 'HH:mm:ss.fff')] ### Log Created ###" -Append
}

#log file preamble
Out-File -FilePath "$($PSScriptRoot)\$($logFileName)" -InputObject "`n[$(Get-Date -Format 'HH:mm:ss.fff')] ### Log Session Started ###`n[HH:mm:ss.fff] Hostname     | ip address      | Status     |   ms | Threshold`n-----------------------------------------------------------------------------" -Append
Write-Output "Starting thread jobs..."

## make background processes from array
foreach ($target in $targets) {
    Write-Output "Making thread job : Monitor $($target[0])"
                                                    #TODO make throttle limit dynamic
    Start-ThreadJob -Name "Monitor $($target[0])" -ThrottleLimit 8 -ScriptBlock {
        Out-File -FilePath $args[5] -InputObject "[$(Get-Date -Format 'HH:mm:ss.fff')] Thread Job start : Monitor $($args[0])" -Append

        # autodetect average network latency
        $probe = Test-Connection -TargetName $args[1] -IPv4 -Count $args[2]
        $average = 0

        foreach ($ping in $probe) {
            $average += $ping.Latency
        }

        $threshold = [math]::Round(($average/$args[2])+$args[3])

        Out-File -FilePath $args[5] -InputObject "[$(Get-Date -Format 'HH:mm:ss.fff')] Threshold calculated for $($args[0]) : $($threshold)" -Append

        Start-Sleep -Seconds 5

        # begin latency monitoring until thread job is terminated and write result to file
        while($true) {
            $result = Test-Connection -TargetName $args[1] -IPv4 -Count 1
            
            if (($result.Status.ToString() -ne "Success") -or ($result.Latency -gt $threshold)) {
                Out-File -FilePath $args[5] -InputObject "[$(Get-Date -Format 'HH:mm:ss.fff')] $(($args[0]).ToString().PadRight(12, ' ')) | $(($args[1]).ToString().PadRight(15, ' ')) | $($result.Status.ToString().PadRight(10, ' ')) | $($result.Latency.ToString().PadLeft(4, ' ')) | $($threshold.ToString().PadLeft(4," "))" -Append
            }
            Start-Sleep -Milliseconds $args[4]
        }
    } -ArgumentList $target[0], $target[1], $count, $sensitivity, $period, "$($PSScriptRoot)\$($logFileName)"| Out-Null
}

## list jobs and wait for user input to terminate
Start-Sleep -Seconds 10
Get-Job
Read-Host -Prompt "`nPress `"enter`" to end..."

## clean up background processes
Write-Output "Ending thread jobs..."
$threadJobs = Get-job

foreach ($threadJob in $threadJobs) {

    if (($threadJob.Name -like "Monitor *") -and ($threadJob.PSJobTypeName.ToString() -eq "ThreadJob")) {
        Write-Output "Ending thread job : $($threadJob.Name)"

        try {
            Stop-Job -Id $threadJob.Id
            Remove-Job -Id $threadJob.Id
        } catch {
            Write-Error "Cannot stop thread job: $($threadJob.Name.ToString())"
        }

    }
}

## verify all jobs were cleaned up, of not, alert user
if ((Get-Job) -eq $null) {
    Write-Output "`nCleanup done!"
} else {
    Get-Job
    Write-Error "Unable to clean up the listed jobs!"
}
