# hw5-turtle-planner
ROS Introduction

## Tasks

You must create a ROS package that interacts with rviz and turtlesim to create a simple turtle path planner.

1. Your package should be called turtle_planner.
2. You should have a python node named turtle_goal.py that communicates with rviz and turtlesim:
  * subscribe to turtle1/pose: You must display the turtle position in rviz.
  * subscribe to move_base_simple/goal: When a user adds a 2D Nav goal in rviz, you must use it to command your turtle to drive there.
  * publish turtle1/pose_stamped: This is used to display the turtle pose in rviz.
  * publish turtle1/path: This is used to display your planned path in rviz. For now, you can make it a straight line from your start to your goal. I encourage you to try to make a path planner use the polynomial trajectories and differential flatness if you want a challenge.
  * publish turtle1/cmd_vel: This commands your turtle to drive. You should be able to use a simple proportional controller for velocity based on distance form the goal, and angular velocity based on the direction to the goal.
  * publish the turtle pose to the tf tree
3. You should have a launch script named planner.launch that starts:
  * rviz: For user interface and sending nav goals
  * turtlesim: Which actually simulate the turtle robot
  * your python node, turtle_goal.py: This is where all of you code lives.

## Deliverables

* ROS package in this git repository
* Include a screen capture video of your turtle being commanded by rviz.
