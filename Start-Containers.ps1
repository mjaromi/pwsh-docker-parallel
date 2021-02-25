function Start-Containers
{
    [CmdletBinding()]
    param(
        [string] $containerImage = 'alpine:latest',
        [string] $containerMemory = '6MB', # Minimum memory limit allowed is 6MB.
        [string] $containerNamePrefix = 'test_container',
        [int] $numberOfContainers = 100,
        [int] $throttleLimit = $([int]$env:NUMBER_OF_PROCESSORS+1)
    )

    1..$numberOfContainers | ForEach-Object -Parallel {
        $containerName = "${using:containerNamePrefix}_$_"
        $containerId = $(docker run -dit --name $containerName --memory $using:containerMemory $using:containerImage)
        Write-Verbose "Starting: $containerName, containerId: $containerId"
    } -ThrottleLimit $throttleLimit
}
