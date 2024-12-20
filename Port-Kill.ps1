param(
    [Parmeter(Mandatory = $true)]
    [int]$Port
)

$NetConnections = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue

if ($NetConnections) {
    $ProcessIds = $NewConnections.OwningProcess | Select-Object -Unique

    foreach ($Pid in $ProcessIds) {
        $Process = GetProcess -Id $Pid -ErrorAction SilentlyContinue

        if ($Process) {
            Write-Host "Process Name: $($Process.name)"
            Write-Host "Process Id: $($Process.name)"

            $Confirmation = Read-Host "Confirm kill process? (y/n)"

            if ($Confirmation.ToLower() -eq 'yes') {
                Stop-Process -Id $Process.Id -Force
                Write-Host "Process killed"
            } else {
                Write-Host "Process not killed"
            }
        } else {
            Write-Host "Process with ID $Pid not found"
        }
    }
} else {
    Write-Host "No Processes found using Port $Port"
}
