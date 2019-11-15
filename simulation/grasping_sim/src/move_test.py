#!/usr/bin/env python
import rospy
from trajectory_msgs.msg import JointTrajectory, JointTrajectoryPoint
import actionlib
from control_msgs.msg import FollowJointTrajectoryAction,FollowJointTrajectoryGoal

pub = rospy.Publisher('/arm/joint_trajectory_controller/command', JointTrajectory, queue_size=1)
rospy.init_node('move_test', anonymous=True)

def test_topic():
    test_goal = JointTrajectory()
    test_goal.header.stamp = rospy.Time.now()
    test_goal.header.seq = 1
    test_goal.header.frame_id = 'body'
    test_goal.joint_names = ["arm_1_joint", "arm_2_joint", "arm_3_joint", "arm_4_joint", "arm_5_joint", "arm_6_joint"]
    point = JointTrajectoryPoint()
    point.positions = [0, 0, 0, 0, 0, 0]
    point.velocities = [1, 1, 1, 1, 1, 1]
    # point.accelerations = [.1,.1,.1,.1,.1,.1]
    point.time_from_start = rospy.Duration.from_sec(1)

    test_goal.points = []
    test_goal.points.append(point)

    point2 = JointTrajectoryPoint()
    point2.positions = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5]
    point2.velocities = [1, 1, 1, 1, 1, 1]
    # point.accelerations = [.1,.1,.1,.1,.1,.1]
    point2.time_from_start = rospy.Duration.from_sec(1)

    test_goal.points = []
    test_goal.points.append(point2)

    pub.publish(test_goal)

def test_action():
    goal = FollowJointTrajectoryGoal()
    goal.goal_time_tolerance = rospy.Time(1)
    test_goal = JointTrajectory()
    test_goal.header.stamp = rospy.Time.now()
    test_goal.header.seq = 1
    # test_goal.header.frame_id = 'body'
    test_goal.joint_names = ["arm_1_joint", "arm_2_joint", "arm_3_joint", "arm_4_joint", "arm_5_joint", "arm_6_joint"]
    point = JointTrajectoryPoint()
    point.positions = [0, 0, 0, 0, 0, 0]
    point.velocities = [1, 1, 1, 1, 1, 1]
    # point.accelerations = [.1,.1,.1,.1,.1,.1]
    point.time_from_start = rospy.Duration.from_sec(1)

    test_goal.points = []
    test_goal.points.append(point)

    point2 = JointTrajectoryPoint()
    point2.positions = [10, 0.5, 0.5, 0.5, 0.5, 0.5]
    point2.velocities = [1, 1, 1, 1, 1, 1]
    # point.accelerations = [.1,.1,.1,.1,.1,.1]
    point2.time_from_start = rospy.Duration.from_sec(2)

    test_goal.points = []
    test_goal.points.append(point2)
    goal.trajectory = test_goal
    goal.goal_time_tolerance = rospy.Duration(10)
    return goal

def main():
    # test_topic()
    goal = test_action()
    client = actionlib.SimpleActionClient("/arm/joint_trajectory_controller/follow_joint_trajectory/", FollowJointTrajectoryAction)
    client.wait_for_server(timeout=rospy.Duration(5.0))
    print("Got server")
    client.send_goal(goal)
    print("Goal sent")
    f = client.wait_for_result(timeout=rospy.Duration(5.0))
    print("Got result: " + str(f))


if __name__ == '__main__':
    try:
        main()
    except rospy.ROSInterruptException:
        pass