#!/bin/bash
echo "You will have to change these paths for this to work properly"
sleep 5
cd /home/aaron/catkin_ws/src/humanoid/hatchery; ./gradlew runIde -Project='/home/aaron/catkin_ws' &
