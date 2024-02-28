# Configuration
Make `.env` file with the following contents:
```
ROS_MASTER_URI=http://localhost:11311
PIONEER_DEVICE=/dev/ttyUSB0
FRONT_LIDAR_DEVICE=/dev/ttyACM0
REAR_LIDAR_DEVICE=/dev/ttyACM1
```
- Set `ROS_MASTER_URI` to whatever it should be on the robot
- Set the `*_DEVICE` variables to the USB devices the host will use for the pioneers and LIDARs. Set these to something even if they don't exist, or the container will not start.

By default the container will launch `src/pioneer_bringup/launch/pioneer_bringup_amazon.launch`. This can be changed on the last line of `Dockerfile`.

# Run
```
docker compose up --build
```