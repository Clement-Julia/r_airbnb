import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.preprocessing import LabelEncoder, PowerTransformer
from sklearn.model_selection import train_test_split, cross_val_score, KFold
from xgboost import XGBRegressor
from sklearn.metrics import accuracy_score, r2_score, mean_squared_error

df = pd.read_csv('Data/Lyon/listings.csv')
df.isnull().sum()

le = LabelEncoder()
catcol = df.select_dtypes(include=['object','bool'])

for x in catcol:
    df[x] = le.fit_transform(df[x])

df['beds_and_baths'] = df['bedrooms'] + df['bathrooms']
corr = df.corr()
print(corr['price'])

df.drop(columns=['bedrooms','bathrooms','beds', 'listing_url', 'scrape_id', 'last_scraped', 'host_id', 'description', 'name', 'neighborhood_overview', 'picture_url', 'host_url', 'host_name', 'host_since', 'host_location', 'host_about', 'host_response_time', 'host_response_rate', 'host_acceptance_rate', 'host_thumbnail_url', 'host_picture_url', 'host_neighbourhood', 'host_listings_count', 'host_verifications', 'host_has_profile_pic', 'host_identity_verified', 'neighbourhood', 'neighbourhood_group_cleansed', 'minimum_nights', 'maximum_nights', 'minimum_minimum_nights', 'maximum_minimum_nights', 'minimum_maximum_nights', 'maximum_maximum_nights', 'minimum_nights_avg_ntm', 'maximum_nights_avg_ntm', 'calendar_updated', 'has_availability', 'availability_30', 'availability_60', 'availability_90', 'availability_365', 'calendar_last_scraped', 'number_of_reviews','number_of_reviews_ltm', 'number_of_reviews_l30d', 'first_review', 'last_review', 'review_scores_accuracy', 'review_scores_cleanliness', 'review_scores_checkin', 'review_scores_communication', 'review_scores_location', 'review_scores_value', 'license', 'instant_bookable', 'calculated_host_listings_count', 'calculated_host_listings_count_entire_homes', 'calculated_host_listings_count_private_rooms', 'calculated_host_listings_count_shared_rooms', 'reviews_per_month'],axis=1,inplace=True)

plt.figure(figsize=(60,20))
sns.boxplot(data=df)

pt = PowerTransformer(method='yeo-johnson')
df.skew()

cols = (df.drop(columns=['price'], axis=1)).columns
pt = PowerTransformer(method='yeo-johnson')

for x in cols:
    try:
        if df[x].abs().max() > 1e6:
            print(f"Applying log transformation to column {x} due to large values.")
            df[x] = np.log1p(df[x].abs())

        df[x] = pt.fit_transform(df[[x]])
    except Exception as e:
        print(f"Error transforming column {x}: {e}")

df.isnull().sum()

df.dropna(subset=['beds_and_baths'],inplace=True)
df['beds_and_baths'].isnull().sum()

df['review_scores_rating'] = df['review_scores_rating'].fillna(float(int(df['review_scores_rating'].mean())))
df.isnull().sum()

df.drop(columns=['latitude','longitude','id'],axis=1,inplace=True)
df['price_per_room'] = df['price']/df['beds_and_baths']
corr = df.corr()

Features = df.drop(columns=['price'],axis=1)
Labels = df['price']

ft, fe, lt, le = train_test_split(Features,Labels, test_size=0.2, random_state=42)

xg = XGBRegressor()
xg.fit(ft, lt)
pred = xg.predict(fe)

acc = cross_val_score(xg, Features, Labels, cv=KFold(n_splits=10, shuffle=True, random_state=42))