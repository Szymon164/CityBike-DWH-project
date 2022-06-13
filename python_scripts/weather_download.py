import csv
import codecs
from turtle import down
import urllib.request
import urllib.error
import sys
import json


def download_data(start, end):

    BaseURL = 'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/'
    
    with open("apikey.txt", "r") as f:
        ApiKey = f.readline()


    UnitGroup='metric'
    Location='New%20York,NY'
    Include='days'
    ContentType='csv'

    Query = BaseURL + Location + "/" + start + "/"+ end + "?" + "&unitGroup=" + UnitGroup + "&contentType=" + ContentType + "&include="+ Include + "&key="+ ApiKey

    print(' - Running query URL: ', Query)
    print()

    try: 
        CSVBytes = urllib.request.urlopen(Query)
    except urllib.error.HTTPError  as e:
        ErrorInfo= e.read().decode() 
        print('Error code: ', e.code, ErrorInfo)
        sys.exit()
    except  urllib.error.URLError as e:
        ErrorInfo= e.read().decode() 
        print('Error code: ', e.code,ErrorInfo)
        sys.exit()
    
    CSVText = csv.reader(codecs.iterdecode(CSVBytes, 'utf-8'))
    
    with open(f"weather_{start}_{end}.csv", "w") as f:
        writer = csv.writer(f, lineterminator='\n')
        for row in CSVText:
            writer.writerow(row)


download_data("2019-06-01", "2019-06-30")
download_data("2019-07-01", "2019-07-31")
download_data("2019-08-01", "2019-08-31")