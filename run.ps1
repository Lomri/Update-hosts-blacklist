Param(
    [Parameter(Mandatory=$true)][string]$URL,
    [Parameter(Mandatory=$true)][string]$Destination,
    [Parameter(Mandatory=$true)][string]$Username,
    [Parameter(Mandatory=$true)][string]$PasswordFile,
    [Parameter(Mandatory=$true)][string]$OutputFile

)

Begin
{
    $password = if(test-path $PasswordFile) {Get-Content $PasswordFile} else {break}
    $password = $password | ConvertTo-SecureString
    try
    {
        [pscredential]$cred = New-Object System.Management.Automation.PSCredential ($userName, $password) -ErrorAction stop
    }
    catch
    {
        throw "Credential error"
        break
    }
}

Process
{
    try
    {
        $drive = New-PSDrive -Name "DomainBlocklist" -PSProvider FileSystem -Root $Destination -Credential $cred
    }
    catch
    {
        throw "PSDrive creation error"
        break
    }
    if($drive -eq $null) { return }

    $response = curl $url

    if($response.StatusCode -ne 200) { throw "Web response: $($response.StatusCode)"; break }
    if($response.RawContentLength -le 10000) { throw "Too short answer"; break }

    $response | select -ExpandProperty content | Out-File -FilePath "$($drive.name):\$OutputFile" -Force

    if($?)
    {
        $Date = Get-Date -Format "dd.MM.yyyy"
        Add-Content "log.log" -Value "$Date OK"
    }                   
}

End
{
    if($drive) {Remove-PSDrive $drive}
}