# GuideMe

Guide me is a mobile app for iOS system written in Swift 3. Objective of the app is to aid users with varying degree of visual impairment to navigate an underground station. To achieve this goal our app scans for Bluetooth Beacons and passes directions to the user if it detects a beacon with an ID it knows.  

We thoroughly researched the needs of visually impaired people before we set to design our app. Hence, our interface follows Blind People Society advice regarding colour scheme and font style and size. Guide Me also offers text to speech functionality which makes it useful for people with severe visual impairment and also allows users to use the app while the phone is placed in their bag/pocket.  

#### To run the app (on a mac):

- download/clone this repo  
- make sure you have xcode installed  
- go to the project folder  
- open GuideMe.xcworkspace  
- to run the tests enter ctrl + u in xCode  
- connect your iphone to the computer, choose it as your preferred device in xcode and enter ctrl + r to run the app.  
- to test beacon detection you will need either a real Bluetooth Beacon or another phone simulating the beacon. Beacon minor should be set to one of values recognised by the app. At present those minor values are: 1, 41693, 49281 and 65159.  

Guide Me was built independently by our team over the course of two weeks. The app was our final project at Makers Academy web development course. Our app was inspired by a hackathon organised by [Wayfindr](https://www.wayfindr.net/) project.  



Our team:  
[Leke Abolade](https://github.com/aabolade)  
[Courtney Osborn](https://github.com/CourtneyLO)  
[Louisa Spicer](https://github.com/louisaspicer)  
[Pea M. Tyczynska](https://github.com/CrystalPea)  
[Bryony Watson](https://github.com/bryonywatson1)  


User Stories
============

```

As a User,
So I can be guided,
I need to receive a message when close to a beacon.

As a User,
So that I can get around the station,
I would like to be guided with prompts.

As a User,
So I receive clear instructions,
I want to receive only one message at a time

As a User,
So that I can prepare,
I would like to know what obstacle I am approaching.

As a User,
So that I can prepare,
I would like to know the number of step ahead.

As a User,
So that I can get on the correct train,
I would like to know the live platform departures.

As a User,
So that I can keep updated with my journey,
I would like to know about delays and disruptions.

As a User,
So that the app meets my individual needs,
I would like to be able to customise the settings.

As a User,
So that I can prepare,
I would like to know when I need to change direction.

As a User,
So that I don’t have to enter the settings each time,
I would like the settings to be saved

As a User,
So I can get on the correct train,
I would like to know the direction and line of trains leaving from a platform.

As a User,
So the app can help me,
I would like to tell it where I want to go.

```
