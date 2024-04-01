#Loops serially through the movies.csv and sends each comment for sentiment analysis.
$data = Import-Csv -Path .\movie-small.csv | select -first 1000
$url = "http://172.233.34.111"
$path = "v2/models/sentiment_analysis/infer"
$api = "$url/$path"
$StartTime = $(get-date)
echo $StartTime
foreach($review in $data){
  $postdata = $review.text
    $body = @{
        sequences = "$postdata"
    } | ConvertTo-Json
  # Echo "Sending data $body" 
  $ProgressPreference = 'SilentlyContinue'
  try{ 
    $result = (Invoke-WebRequest -Uri $api -Method Post -ContentType "application/json" -Body $body).content | ConvertFrom-Json
    }
    catch{
        $fail = $fail + 1
  #      echo "$postdata"
    }
    finally{
        $status = $result.labels
        if($status -eq "positive"){
            $positive = $positive + 1
        }
        if($status -eq "negative"){
            $negative = $negative + 1
        }        
    #    echo $status
    }
}
$elapsedTime = $(get-date) - $StartTime

$totalTime = "{0:HH:mm:ss}" -f ([datetime]$elapsedTime.Ticks)
echo "Failures: $fail"
echo "Positives: $positive"
echo "Negatives: $negative"
echo "total time: $totaltime"

#curl -X POST http://172.233.58.11/v2/models/sentiment_analysis/infer -H "Content-Type: application/json" -d '{"sequences": "Akamai is awesome!"}'