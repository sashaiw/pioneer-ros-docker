# Configuration
Make `.env` file with the following contents (make sure to set `UGID` to your actual UID and GID (you can check this with the `id` command) and also set `ROS_MASTER_URI`):
```
UGID=1000:1000
ROS_MASTER_URI=http://localhost:11311
```

# Run
```
docker compose up --build
```