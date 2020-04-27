# On The Map
This is the third portfolio app from Udacity iOS Developer Nanodegree. This app allows udacity students to share their 
location and a URL with their fellow students. And visualize this data on a map with pins for location 
and pin annotations for student names and URLs.


  
 * [Project Rubric](https://review.udacity.com/#!/rubrics/2114/view)

## This project focused on
* Accessing networked data using Apple’s URL loading framework 
* Authenticating a user over a network connection and making network request (Get , Post , Put , Delete)
* Parsing JSON file using Codable (Decodable , Encodable)
* Creating user interfaces that are responsive, asynchronous requests
* Use Core Location and the MapKit framework to display annotated pins on a map

## App Structure
On The Map is following the MVC pattern. 

<img src="https://github.com/RowanHisham/IOS-nanodegree-OnTheMap/blob/master/Images/onthemap1.png" alt="alt text" width="800" height="500" >

## Implementation
### Login Screen 
Allows the user to log in using their Udacity credentials, when the user taps the Login button, the app will attempt to authenticate with Udacity’s servers.
If the login does not succeed, the user will be presented with an alert view specifying whether it was a failed network connection, or an incorrect email and password.

<img src="https://github.com/RowanHisham/IOS-nanodegree-OnTheMap/blob/master/Images/onthemap2.png" alt="alt text" width="300" height="550" >

### Map Screen 
Displays a map with pins specifying the last 100 locations posted by students.

<img src="https://github.com/RowanHisham/IOS-nanodegree-OnTheMap/blob/master/Images/onthemap3.png" alt="alt text" width="300" height="550" >


### List Screen
Displays the most recent 100 locations posted by students in a table. 
Each row displays the name from the student’s Udacity profile. Tapping on the row launches launch Safari and direct it to the link associated with the cell

<img src="https://github.com/RowanHisham/IOS-nanodegree-OnTheMap/blob/master/Images/onthemap4.png" alt="alt text" width="300" height="550" ><img src="https://github.com/RowanHisham/IOS-nanodegree-OnTheMap/blob/master/Images/onthemap8.png" alt="alt text" width="300" height="550" >

### Add Pin Screen
Allows the user to input data in two steps: first adding their location string, then their link.
<img src="https://github.com/RowanHisham/IOS-nanodegree-OnTheMap/blob/master/Images/onthemap5.png" alt="alt text" width="300" height="550" ><img src="https://github.com/RowanHisham/IOS-nanodegree-OnTheMap/blob/master/Images/onthemap6.png" alt="alt text" width="300" height="550" >

When the user taps a pin, it displays the pin annotation popup, with the student’s name 
(Note: This is not the real Udacity API, but is a version specific to On the Map that uses randomized fake user data.) and the link associated with the student’s pin.
tapping the button within the annotation will launch Safari and direct it to the link associated with the pin.

<img src="https://github.com/RowanHisham/IOS-nanodegree-OnTheMap/blob/master/Images/onthemap7.png" alt="alt text" width="300" height="550" ><img src="https://github.com/RowanHisham/IOS-nanodegree-OnTheMap/blob/master/Images/onthemap8.png" alt="alt text" width="300" height="550" >



## Frameworks
UIKit

MapKit
