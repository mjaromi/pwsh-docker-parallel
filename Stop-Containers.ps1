function Stop-Containers
{
    [CmdletBinding()]
    param(
        [string] $containerNamePrefix = 'test_container',
        [int] $numberOfContainers = 100,
        [int] $throttleLimit = $([int]$env:NUMBER_OF_PROCESSORS+1)
    )

    1..$numberOfContainers | ForEach-Object -Parallel {
        $containerName = "${using:containerNamePrefix}_$_"
        Write-Verbose "Removing: $containerName"
        docker rm -f $containerName | Out-Null
    } -ThrottleLimit $throttleLimit
}
