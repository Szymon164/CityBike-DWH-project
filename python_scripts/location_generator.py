import pandas as pd
from geopy.geocoders import Nominatim
from geopy.extra.rate_limiter import RateLimiter
import math 


def generate_station_locations(filepath):
    df = pd.read_csv(filepath)
    df2 = df[["start station id", "start station name", "start station latitude", "start station longitude"]]
    df = df[["end station id", "end station name", "end station latitude", "end station longitude"]]

    df = df.groupby(["end station id", "end station name"], group_keys=False).mean()
    df2 = df2.groupby(["start station id", "start station name"], group_keys=False).mean()
    df["end station latitude"] = round(df["end station latitude"], 4)
    df["end station longitude"] = round(df["end station longitude"], 4)
    df2["start station latitude"] = round(df2["start station latitude"], 4)
    df2["start station longitude"] = round(df2["start station longitude"], 4)

    df.reset_index(inplace=True)
    df2.reset_index(inplace=True)
    df2.columns = df.columns
    df = df.append(df2)
    df = df.drop_duplicates(["end station id"])

    geolocator = Nominatim(user_agent="bikes")
    reverse = RateLimiter(geolocator.reverse, min_delay_seconds=1, max_retries=0)

    list_of_addresses  = df.apply(lambda row: reverse(str(row["end station latitude"]) + ", " + str(row["end station longitude"])).raw["address"], axis=1)

    addresses = pd.DataFrame(list(list_of_addresses))
    df[["Suburb", "Road", "Neighborhood"]] = addresses[["suburb", "road", "neighbourhood"]]
    df.columns = ["StationID", "StationName", "Latitude", "Longitude", "Suburb", "Road", "Neighborhood"]
    df.to_csv(filepath + "-stations.csv")