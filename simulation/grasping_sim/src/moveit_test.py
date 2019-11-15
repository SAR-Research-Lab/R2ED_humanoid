import rospy
import sys
import tf
import moveit_commander
import moveit_msgs.msg
import geometry_msgs.msg
from std_msgs.msg import String
from moveit_commander.conversions import pose_to_list

#pub = rospy.Publisher('/arm/joint_trajectory_controller/command', JointTrajectory, queue_size=1)

def main():
    moveit_commander.roscpp_initialize(sys.argv)
    rospy.init_node('moveit_test', anonymous=True)
    robot = moveit_commander.RobotCommander()
    scene = moveit_commander.PlanningSceneInterface()
    group_name = "arm"
    group = moveit_commander.MoveGroupCommander(group_name)
    display_trajectory_publisher = rospy.Publisher('/move_group/display_planned_path',
                                                   moveit_msgs.msg.DisplayTrajectory,
                                                   queue_size=20)
    planning_frame = group.get_planning_frame()
    print "============ Reference frame: %s" % planning_frame

    # We can also print the name of the end-effector link for this group:
    eef_link = group.get_end_effector_link()
    print "============ End effector: %s" % eef_link

    # We can get a list of all the groups in the robot:
    group_names = robot.get_group_names()
    print "============ Robot Groups:", robot.get_group_names()

    t = tf.TransformListener()
    t.waitForTransform("/arm_6_link", "/world", rospy.Time(0), rospy.Duration(5.0));
    trans, rot = t.lookupTransform("/arm_6_link", "/world", rospy.Time(0))
    print(trans)
    print(rot)
    orientation = geometry_msgs.msg.Quaternion()
    orientation.x = .5
    orientation.y = -.5
    orientation.z = .5
    orientation.w = -.5
    pose_goal = geometry_msgs.msg.Pose()
    pose_goal.orientation.w = 0.73916
    pose_goal.orientation.x = -0.3765
    pose_goal.orientation.y = -.5390
    pose_goal.orientation.z = -0.1457
    pose_goal.position.x = -.493
    # pose_goal.position.y = -1.025
    pose_goal.position.y = -.29
    pose_goal.position.z = .182
    print(pose_goal)
    group.set_pose_target(pose_goal)
    # group.set_named_target("home")
    print("Current Pose")
    print(group.get_current_pose())
    print("Computing plan...")
    plan = group.go(wait=True)
    display_trajectory = moveit_msgs.msg.DisplayTrajectory()
    display_trajectory.trajectory_start = robot.get_current_state()
    display_trajectory.trajectory.append(plan)
    # Publish
    display_trajectory_publisher.publish(display_trajectory);
    # Calling `stop()` ensures that there is no residual movement
    group.stop()
    # It is always good to clear your targets after planning with poses.
    # Note: there is no equivalent function for clear_joint_value_targets()
    group.clear_pose_targets()

if __name__ == '__main__':
    try:
        main()
    except rospy.ROSInterruptException:
        pass