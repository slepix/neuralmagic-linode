import csv
import json
import requests
from datetime import datetime
from multiprocessing import Pool

# Load comments from CSV file
data = []
with open('movie.csv', newline='', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        data.append(row['text'])

# Set up API details
url = "http://172.233.34.111"
path = "v2/models/sentiment_analysis/infer"
api = f"{url}/{path}"

# Start time
start_time = datetime.now()

print(f"Analyzing {len(data)} comments.")
print(start_time)

def analyze_sentiment(comment):
    """Function to analyze sentiment of a single comment"""
    body = json.dumps({"sequences": [comment]})  # Wrap comment in a list
    try:
        response = requests.post(api, headers={"Content-Type": "application/json"}, data=body)
        # Parse response and extract sentiment
        status = response.json().get('labels', ['unknown'])[0]  # Extract the first element from the list
        return status
    except Exception as e:
        # Handle errors during API request
        return "error"

# Number of workers for multiprocessing
num_workers = 16

with Pool(num_workers) as pool:
    # Map sentiment analysis function to comments using multiprocessing
    results = pool.map(analyze_sentiment, data)

# Count the number of positives, negatives, and failures
positive = results.count("positive")
negative = results.count("negative")
fail = results.count("error")

# Calculate elapsed time
elapsed_time = datetime.now() - start_time
total_time = elapsed_time.total_seconds()

print(f"Failures: {fail}")
print(f"Positives: {positive}")
print(f"Negatives: {negative}")
print(f"Total time: {total_time} seconds")
