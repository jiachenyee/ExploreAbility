# ExploreAbility
## a slightly overengineered way of teaching iOS Accessibility 

## frameworks & technologies
### client app
- **SwiftUI**: App interface.
- **UIKit**: Challenge validation (validating accessibility features with UIAccessibility).
- **CoreLocation**: Determine current location (using iBeacons, GPS, and compass).
- **AVFoundation/AVKit**: Video during one of the challenge.
- **AVFAudio**: Text to speech.
- **MultipeerConnectivity**: Connect to console app and receive commands.
- **UserNotifications**: Send notification if the user leaves the app for too long.
- **ActivityKit/WidgetKit**: Create Live Activity indicating challenge progress.
- **CoreHaptics**: Provide haptic feedback to locate beacons.
- **ARKit**: Game Over sequence
 
### console app 
- **SwiftUI**: App interface.
- **SceneKit**: Creating a 3D map view.
- **MultipeerConnectivity**: Connect to clients (iPhone).
- **CoreBluetooth**: Connect to iBeacons to monitor if any of them fall offline.
- **CoreLocation**: Calculate GPS origin point.
- **MapKit**: Draggable map to place map pin down.

### room scanner
- **UIKit**: For user interface, mostly using UIKit and Storyboards.
- **RoomPlan**: Room scanning using LiDAR.

### iBeacon (Mac/iPad)
- **SwiftUI**: App interface.
- **CoreBluetooth**: Emitting iBeacon advertisments.
- **CoreLocation**: Creating iBeacon advertisments.

## how does it work?
- [**📍 Indoor Positioning**](IndoorPositioning.md): How we know where on earth (or more specifically, in the academy) you are.
- [**💬 Communication**](Communication.md): How a connection is established, what data gets sent between the Console and Client apps.
- [**🏆 Challenges**](Challenges.md): Find the challenges, and solutions.
- [**🎉 Celebration**](Celebration.md): How the game over sequence works

> Designed by [Jia Chen](https://github.com/jiachenyee) and [Tafa](https://github.com/ratafani) for the Apple Developer Academy @ Infinite Learning.
