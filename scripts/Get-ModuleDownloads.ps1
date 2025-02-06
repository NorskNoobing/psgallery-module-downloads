function Get-ModuleDownloads {
    param (
        [Parameter(Mandatory)][string]$ModuleName
    )

    $ModuleURI = "https://www.powershellgallery.com/packages/$ModuleName"

    try {
        $ModulePage = ((Invoke-WebRequest -Uri $ModuleURI | ConvertFrom-Html).InnerText -split '\r?\n').Trim()
    }
    catch {
        Write-Error -ErrorAction Stop -Message @"
Got error while trying to fetch `"$ModuleName`".
------------------------------------------------

$_
"@
    }

    $TotalDownloadsIndex = $ModulePage.IndexOf("Downloads")
    [int]$ModuleDownloads = $ModulePage[$TotalDownloadsIndex-3]

    if (!$ModuleDownloads) {
        return
    }

    $Splat = @{
        "Uri" = "$env:INFLUX_HOST/api/v2/write?bucket=$env:INFLUX_BUCKET&org=$env:INFLUX_ORG&precision=s"
        "Method" = "POST"
        "Headers" = @{
            "Authorization" = "Token $env:INFLUX_TOKEN"
            "Content-Type" = "text/plain"
        }
        "Body" = "count,source=psgallery,module_name=$_ downloads=$ModuleDownloads $UnixTime"
    }
    Invoke-RestMethod @Splat
}

$PSGalleryProfile = Invoke-WebRequest -Uri "https://www.powershellgallery.com/profiles/$env:PSGALLERY_PROFILE_NAME"
$ModuleList = $PSGalleryProfile.links.href.where({
    $_ -like "/packages/*/"
}) -replace "(\/[A-Za-z]+\/)|(\/)",""

$UnixTime = Get-Date -UFormat %s

$ModuleList.ForEach({
    Get-ModuleDownloads -ModuleName $_
})
