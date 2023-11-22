$PSGalleryProfile = Invoke-WebRequest -Uri $env:PSGALLERY_PROFILE_URI
$ModuleList = $PSGalleryProfile.links.href.where({
    $_ -like "/packages/*/"
}) -replace "(\/[A-Za-z]+\/)|(\/)",""

$UnixTime = Get-Date -UFormat %s

$ModuleList.ForEach({
    $ModuleURI = "https://www.powershellgallery.com/packages/$_"
    $ModulePage = ((Invoke-WebRequest -Uri $ModuleURI | ConvertFrom-Html).InnerText -split '\r?\n').Trim()
    $TotalDownloadsIndex = $ModulePage.IndexOf("Downloads")
    [int]$ModuleDownloads = $ModulePage[$TotalDownloadsIndex-3]

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
})