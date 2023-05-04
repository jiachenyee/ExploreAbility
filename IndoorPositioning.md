# Indoor Positioning
## Determing the user's position through a series of iBeacons and GPS.

![5 iBeacons forming intersecting circles representing their range.](https://user-images.githubusercontent.com/36725840/236233973-2a517d6f-a69c-4ec5-98ef-f1348913ea21.png)

_Example with 5 iBeacon ranges (in red) overlapped with the GPS location range (blue) to determine a user's location (the poorly-drawn yellow stickman)._

## Data Collection
- There are 7 iBeacons present in the lab. 
  - iBeacon data is classified into 4 categories
    - unknown (very far away, hard to detect)
    - immediate (less than 1m)
    - near (less than 12m)
    - far (less than 40m)
  - These readings were done in the lab, readings may differ based on environment (e.g. a less open space, or a wall blocking would affect the readings).
  - The iBeacon readings are classified into categories since they are easily influenced by RF interference and attempting to get an accurate reading will be less than helpful due to the severe fluctuations. (Trust me, I've tried.) 
- GPS data
  - The user's GPS location is collected, along with an accuracy. Within the academy, it's between 5m to 15m.
  - Using the ExploreAbility Console, the GPS data is switched from a global coordinate system (latitude and longitude) to the local coordinate system (x and y) to be consistent with the iBeacon positions.

## Processing Data
- Individually, each of these data points are not very accurate. However, by combining the data from the different sources, the app is able to start making inferences.
- Each data point, such as a GPS location or iBeacon information provides a maximum distance (iBeacon is based on the categories above, GPS is based on the accuracy) this distance can be coupled with the position of these data points within the academy to create circles.
- The intersection area of all/most of these circles indicate the exact position.
- This allows us to get a good idea of the user's position even while using imprecise data.
- You can check out the algorithm [here](ExploreAbility/View%20Model/ViewModel%2BPositionCalculation.swift).

## Visualizing Results
This is a visualization and test of the algorithm to calculate the user's position through the use of circles using sample data.

![Image of overlapping circles representing the ranges of iBeacons/GPS](https://user-images.githubusercontent.com/36725840/236239246-098068d3-ff0f-4669-97d4-5e10f61318fe.png)

- Red point: Predicted location
- Dotted-line: Accuracy
- Lines: Ranges of beacons/GPS

## Real-World Testing & Accuracy
TODO
