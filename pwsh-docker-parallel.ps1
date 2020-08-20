# Licensed under the MIT License.

$throttleLimit = $([int]$env:NUMBER_OF_PROCESSORS+1)

function Start-Containers
{
    [CmdletBinding()]
    param(
        [string] $containerImage = 'alpine:latest',
        [string] $containerMemory = '4MB', # Minimum memory limit allowed is 4MB.
        [string] $containerNamePrefix = 'test_container',
        [int] $numberOfContainers = 100
    )

    1..$numberOfContainers | ForEach-Object -Parallel {
        $containerName = "${using:containerNamePrefix}_$_"
        $containerId = $(docker run -dit --name $containerName --memory $using:containerMemory $using:containerImage)
        Write-Output "Starting: $containerName, containerId: $containerId"
    } -ThrottleLimit $throttleLimit
}

function Stop-Containers
{
    [CmdletBinding()]
    param(
        [string] $containerNamePrefix = 'test_container',
        [int] $numberOfContainers = 100
    )

    1..$numberOfContainers | ForEach-Object -Parallel {
        $containerName = "${using:containerNamePrefix}_$_"
        Write-Output "Removing: $containerName"
        docker rm -f $containerName | Out-Null
    } -ThrottleLimit $throttleLimit
}

Start-Containers
Stop-Containers
