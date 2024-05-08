# Configuration
Initialize submodules:
```
git submodule update --init --recursive
```

## Environment
Make `.env` file with the following contents:
```
ROS_MASTER_URI=http://localhost:11311
PIONEER_DEVICE=/dev/ttyUSB0
FRONT_LIDAR_DEVICE=/dev/ttyACM0
REAR_LIDAR_DEVICE=/dev/ttyACM1
```
- Set `ROS_MASTER_URI` to whatever it should be on the robot
- Set the `*_DEVICE` variables to the USB devices the host will use for the pioneers and LIDARs. Set these to something even if they don't exist, or the container will not start.

## X11
If you are using the image viewer for the projector, run the following on the host to ensure that the node inside the image can use the X session on the host:
```
xhost +local:root
```

If you are running this over SSH, you may have to set the `DISPLAY` environment variable as well:
```
export DISPLAY=":0"
```

## Docker Compose
Create a file named `docker_compose.yml` in the root of the repository with approximately the following contents:

```yaml
version: "3.9"

services:
  pioneer:
    build: .
    container_name: pioneer
    restart: no
    network_mode: "host"
    env_file: .env

    # enable NVIDIA runtime
    # you can remove this section if you're not using this
    # installation:
    # https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
    runtime: nvidia
    
    # X11 config
    # ensure your $DISPLAY environment variable is set with `export DISPLAY=:0`
    # disable access controls with `xhost +local:root`
    environment:
      - "DISPLAY"
      - "QT_X11_NO_MITSHM=1"
    volumes:
      - /tmp/.X11-unix:/tmp/.X11-unix:rw
    
    # devices for Pioneer/LIDAR serial
    # usually these defaults are correct, but if they aren't they can be changed here
    # (or better yet, made static with a udev rule)
    devices:
      - ${PIONEER_DEVICE}:/dev/ttyUSB0
      - ${FRONT_LIDAR_DEVICE}:/dev/ttyACM0
      # - ${REAR_LIDAR_DEVICE}:/dev/ttyACM1
```

By default the container will launch `src/pioneer_bringup/launch/pioneer_bringup_amazon.launch`. This can be changed on the last line of `Dockerfile`.

# Run
```
docker compose up --build
```
