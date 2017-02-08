# GuideMe

Guide me is a mobile app for iOS system written in Swift 3. Objective of the app is to aid users with varying degree of visual impairment to navigate an underground station. To achieve this goal our app scans for Bluetooth Beacons and passes directions to the user if it detects a beacon with an ID it knows.  

We thoroughly researched the needs of visually impaired people before we set to design our app. Hence, our interface follows Blind People Society advice regarding colour scheme and font style and size. Guide Me also offers text to speech functionality which makes it useful for people with severe visual impairment and also allows users to use the app while the phone is placed in their bag/pocket.  

#### To run the app (on a mac):

- download/clone this repo  
- make sure you have Xcode installed  
- go to the project folder  
- open GuideMe.xcworkspace  
- to run the tests enter ctrl + u in xCode  
- connect your iPhone to the computer, choose it as your preferred device in Xcode and enter ctrl + r to run the app.  
- to test beacon detection you will need either a real Bluetooth Beacon or another phone simulating the beacon. Beacon minor should be set to one of values recognised by the app. At present those minor values are: 1, 41693, 49281, 50300, 50500, 50800 and 65159.  

**Guide Me** was built independently by our team over the course of two weeks. The app was our final project at **Makers Academy** web development course. Our app was inspired by a hackathon organised by **[Wayfindr](https://www.wayfindr.net/)** project.  

We worked following Agile methodology, with daily stand-ups and retros, setting an MVP goal and adjusting functionalities based by everyday observations throughout the development process.    

##### Technologies we used:

Language: Swift 3  
Framework: Xcode  
Libraries: AVFoundation, Speech, AudioToolBox, CoreLocation  
APIs: TFL live departures  

##### Successes:
- We built a fully working app in a language we didn't use before.
- We reached our MVP (minimum viable product) on Thursday, first week.
- We succeeded in implementing nearly all planned features
- We succesfully integrated a variety of libraries into our app.
- We learnt how to cooperate on a Swift project through Github
- We have learnt a lot about accesiblility and usability with particular user needs in mind.

##### Struggles:
- Stubbing the beacons for tests  
- Resolving Xcode-specific merge conflicts. We managed to solve this issue by fetching offending system files to a branch waiting to be merged.
- Clashing libraries (Speech to text functionality was shutting down the speakers and so text to Speech didn't want to work after recording has been made). This issue has been resolved by adding a "Record and play" method.

##### Areas for future exploration:
- Moving the dictionaries with beacon IDs (minors) and relevant instructions to an API for scalability.
- Improving beacons relation map.
- Improving accuracy.
- Retaining the settings after app shuts down.
- Adding delays and disruptions information functionality.




##### Our team:  
[Leke Abolade](https://github.com/aabolade)  
[Courtney Osborn](https://github.com/CourtneyLO)  
[Louisa Spicer](https://github.com/louisaspicer)  
[Pea M. Tyczynska](https://github.com/CrystalPea)  
[Bryony Watson](https://github.com/bryonywatson1)   

**Disclaimer:** Everyone worked equally hard on the project and this is, for some reason, not reflected on Github contribution graphs.


### User Stories

We started development process by writing down user stories. They guided us to functionalities that needed to be developed and helped us keep our focus:

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
