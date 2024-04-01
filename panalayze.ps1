#Goes throught the movies.csv in parallel. 

$data = Import-Csv -Path .\movie-small.csv 
$url = "172.233.34.111"
$path = "v2/models/sentiment_analysis/infer"
$api = "http://$url/$path"
$StartTime = Get-Date
$count = $data.count

Echo "Analysing $count comments."
Echo $StartTime
$ProgressPreference = 'SilentlyContinue'

$jobs = @()

foreach ($review in $data) {
    $jobs += Start-Job -ScriptBlock {
        param($postData, $api)

        $body = @{
            sequences = $postData
        } | ConvertTo-Json

        try {
            $ProgressPreference = 'SilentlyContinue'
            $result = Invoke-WebRequest -Uri $api -Method Post -ContentType "application/json" -Body $body -ErrorAction Stop
            $status = ($result.Content | ConvertFrom-Json).labels

            if ($status -eq "positive") {
                return "positive"
            } elseif ($status -eq "negative") {
                return "negative"
            } else {
                return "unknown"
            }
        } catch {
            return "error"
        }
    } -ArgumentList $review.text, $api
}

$positive = 0
$negative = 0
$fail = 0

$jobs | ForEach-Object {
    $result = Receive-Job $_
    if ($result -eq "positive") {
        $positive++
    } elseif ($result -eq "negative") {
        $negative++
    } elseif ($result -eq "error") {
        $fail++
    }
}

$jobs | Remove-Job -Force

$elapsedTime = (Get-Date) - $StartTime
$totalTime = "{0:HH:mm:ss}" -f ([datetime]$elapsedTime.Ticks)

echo "Failures: $fail"
echo "Positives: $positive"
echo "Negatives: $negative"
echo "Total time: $totalTime"
