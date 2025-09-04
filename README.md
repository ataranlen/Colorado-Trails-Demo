# Colorado-Trails-Demo

This app is a simple demo application that uses the Strava API. Upon launch, the app attempts to authenticate to the API via oauth2. My original intention with this app, before reading the API, was to list the least popular trails in Colorado, but the API does not appear to have a sorting function. Some future improvements might be to include little map views of the location of each trail on the details page for each segment, as well as improve the display of segments on the main list view.

To run this application: 
1. Clone the repo
2. Add your Strava Client key and secret to Networking > Models > NetworkValues.swift
3. Run the app via xCode.