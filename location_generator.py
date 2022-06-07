import pandas as pd
from geopy.geocoders import Nominatim
from geopy.extra.rate_limiter import RateLimiter
import math 

df = pd.read_csv("sample_data\\201907-citibike-tripdata.csv")

df = df[["start station id", "start station latitude", "start station longitude"]]
df["start station latitude"] = round(df["start station latitude"], 2)
df["start station longitude"] = round(df["start station longitude"], 2)





print(df.head())

print(len(pd.unique(df["start station id"])))
print(len(df.drop_duplicates()))





geolocator = Nominatim(user_agent="bikes")
reverse = RateLimiter(geolocator.reverse, min_delay_seconds=1, max_retries=0)