# Indoor Positioning
## Determing the user's approximate position through a series of iBeacons.

## Using Relative Positions
> Determining an exact position using RSSI is a fruitless endeavour.

<img width="1090" alt="image" src="https://github.com/jiachenyee/ExploreAbility/assets/36725840/8ea1ef22-0204-4379-ab6c-7f0882882e57">

- Since RSSI is inheretly unreliable and relative, the app uses the RSSI value (the signal strength), to determine it's relative distance to a device.
- This does mean that the location preview is much like a progress bar. It detects how far along to the user is to the final location.

## Other Considerations
Originally, I intended to use a method involving trilateration, however, the lack of accuracy with the values literally jumping by 20m made it completely unworkable. 

Determining an exact value is near impossible unless the environment is absolutely perfect with little to no interference and with perfect line-of-sight to every single beacon. In reality, this is not possible, as even a human body blocking it can affect the signal strength and calculating the exact position using this method would be incredibly challenging.
