#!/usr/bin/env/python
"""
CRAZYFLIE SQUARE FLIGHT
AAE 490
DR. GOPPERT
AUTHOR: TOMOKI KOIKE
THIS PYTHON PROGRAM ALLOWS THE CRAZYFLIE MANEUVER IN A SQUARE FLIGHT WHILE
HALTING WHEN APPROACHING A OBSTACLE IN FRONT OF THE AERIAL VEHICLE.
"""
import logging
import sys
import time

import cflib.crtp
from cflib.crazyflie import Crazyflie
from cflib.crazyflie.syncCrazyflie import SyncCrazyflie
from cflib.positioning.motion_commander import MotionCommander
from cflib.utils.multiranger import Multiranger

URI = 'radio://0/100/250K/E7E7E7E709'

if len(sys.argv) > 1:
    URI = sys.argv[1]

# Only output errors from the logging framework
logging.basicConfig(level=logging.ERROR)


def is_close(range, dist):
    """
	:param range: Indicates which face the obstacle is (for the multi-ranger)
	:param dist:  Distance from the obstacle to the Crazyflie
	:return: Boolean determining whether there is a obstacle in the vicinity
	"""
    MIN_DISTANCE = dist  # m
    if range is None:
        return False
    else:
        return range < MIN_DISTANCE

if __name__ == '__main__':
    # Initialize the low-level drivers (don't list the debug drivers)
    cflib.crtp.init_drivers(enable_debug_driver=True)
    cf = Crazyflie(rw_cache='./cache')
    with SyncCrazyflie(URI, cf=cf) as scf:
        with MotionCommander(scf) as mc:
            with Multiranger(scf) as mr:
                keep_flying = True  # Boolean indicator to maintain flight
                time.sleep(1)  # Short interval for next action
                moved_dist = 0  # The total moved distance
                obstacle_flag = 0  # The obstacle flag to indicate existence of obstacle
                turn_flag = 0  # Distance counter
                ct = 0  # Counter to keep track of how many times it turned
                step_size = 0.01  # Each forward movement step-size
                while keep_flying:
                    if ct != 4:  # Condition to end the flight for completing mission
                        if is_close(mr.front, 0.2):  # Condition to check obstacle
                            obstacle_flag = 1  # Flip the flag to indicate existence of obstacle
                            time.sleep(0.2)  # Short interval
                            print('Obstacle approaching')  # Printing action
                            print('Halt to avoid collision')
                        elif obstacle_flag == 1 and not is_close(mr.front, 0.2):
                            obstacle_flag = 0  # Flip the flag to indicate obstacle clearance
                            print('All green, proceed forward')

                        # Condition to move forward
                        if obstacle_flag == 0 and not int(moved_dist) == 1:
                            mc.forward(step_size)  # Moving forward
                            moved_dist += 0.01  # Incrementing the total distance by step size
                            print('Distance moved: {0:f} m'.format(moved_dist))  # Print the distance moved
                        elif obstacle_flag == 0 and int(moved_dist) == 1:
                            time.sleep(1)  # Short interval before turning right
                            mc.turn_right(90)  # Turning right by 90 deg
                            print('Turning right')  # Printing movement
                            time.sleep(0.5)  # Short interval before resuming forward motion sequence
                            moved_dist = 0  # resetting the total distance
                            ct += 1  # Increment the counter by one
                        else:
                            mc.start_linear_motion(0, 0, 0)  # Stopping to avoid obstacle
                    else:
                        print('Square flight completed.')
                        print('Proceed to landing sequence')
                        time.sleep(0.5)  # Short interval for transition
                        keep_flying = False  # Change the indicator to false
                print('Terminate flight.\n')
