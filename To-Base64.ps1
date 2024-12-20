param(
    [Parameter(Mandatory = $true)]
    [string]$Unencoded
)

if ($Unencoded) {
    $Bytes = [System.Text.Encoding]::UTF8.GetBytes($Unencoded)
    $Encoded = [Convert]::ToBase64String($Bytes)
    Write-Host "Base64 encoded: $Encoded"
} else {
    Write-Host "No Input provided"
}
