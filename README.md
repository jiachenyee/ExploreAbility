# ExploreAbility
## a slightly overengineered way of teaching iOS Accessibility 

## frameworks & technologies
### client app
- **SwiftUI**: App interface.
- **UIKit**: Challenge validation (validating accessibility features with UIAccessibility).
- **CoreLocation**: Determine current location (using iBeacons, GPS, and compass).
- **AVFoundation/AVKit**: Video during one of the challenge.
- **MultipeerConnectivity**: Connect to console app and receive commands.
- **UserNotifications**: Send notification if the user leaves the app for too long.
- **ActivityKit/WidgetKit**: Create Live Activity indicating challenge progress.
- **CoreHaptics**: Provide haptic feedback to locate beacons.
 
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

> Designed for the Apple Developer Academy @ Infinite Learning.
