$kbList = '3155533','3155538','3156764','3155544','3156754','3156761','3156987','3141083','3150220','3154846','3155520','3158222','3157993','3156757','3155451','3146706','3155784'

$ie = New-Object -ComObject InternetExplorer.Application
$results = @()


$kbList | ForEach {

    $matches =""
    $url = "https://support.microsoft.com/en-us/kb/$_"
    $ie.Navigate2($url)
    Do {
        If ($ie.Busy) { 
            Start-Sleep -Milliseconds 100 
        } 
    } Until (!($ie.Busy))
# Make sure the KB Article number is contained in the HTML
    $issues = "OK"
    $title = "Title not found"
    if ($ie.Document.Body.InnerHTML -match '<h1 title=".*"') {$title = $matches[0].split('"')[1]}
    $matches = ""
    $article = "article-id=`"$_`""
    if ($ie.Document.Body.InnerHTML -match $article) {
        if ($ie.Document.Body.InnerHTML -match "Known Issues") {$issues = "Need to do research - Known Issues found"}
    }
    else {
        $title = "KB article # not found in webpage text"
    }
    
    $results += New-Object PSObject -Property @{
        KBID = $_
        Title = $title
        Issues = $issues
        } 
}
# Dump the saved results
$results
#test
#more testing