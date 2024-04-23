# Configuration
Initialize submodules:
```
git submodule update --init --recursive
```

Make `.env` file with the following contents:
```
ROS_MASTER_URI=http://localhost:11311
PIONEER_DEVICE=/dev/ttyUSB0
FRONT_LIDAR_DEVICE=/dev/ttyACM0
REAR_LIDAR_DEVICE=/dev/ttyACM1
```
- Set `ROS_MASTER_URI` to whatever it should be on the robot
- Set the `*_DEVICE` variables to the USB devices the host will use for the pioneers and LIDARs. Set these to something even if they don't exist, or the container will not start.

If you are using the image viewer for the projector, run the following on the host to ensure that the node inside the image can use the X session on the host:
```
xhost +local:root
```

If you are running this over SSH, you may have to set the `DISPLAY` environment variable as well:
```
export DISPLAY=":0"
```

By default the container will launch `src/pioneer_bringup/launch/pioneer_bringup_amazon.launch`. This can be changed on the last line of `Dockerfile`.

# Run
```
docker compose up --build
```
