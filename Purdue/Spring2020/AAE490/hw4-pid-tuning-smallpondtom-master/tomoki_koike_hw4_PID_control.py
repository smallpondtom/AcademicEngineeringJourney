"""
HW4 TAKING OFF AND LANDING TO ADJUST THE PID GAINS FOR THE CRAZYFLIE WITH A RISE HEIGHT OF 1 METER
AND A RISE TIME OF 1 SEC.
AUTHOR: TOMOKI KOIKE
"""
import os
import logging
import sys
import time
import cflib.crtp
from cflib.crazyflie import Crazyflie
from cflib.crazyflie.syncCrazyflie import SyncCrazyflie
from cflib.positioning.motion_commander import MotionCommander
from cflib.crazyflie.log import LogConfig
from cflib.crazyflie.syncLogger import SyncLogger


URI = 'radio://0/100/250K/E7E7E7E709'
file_name = 'something.txt'

if len(sys.argv) > 1:
    URI = sys.argv[1]

# Only output errors from the logging framework
logging.basicConfig(level=logging.ERROR)


def position_callback_z(timestamp, data, logconfig):
    with open(file_name, "a") as f:
        z = data['stateEstimate.z']
        m1 = data['motor.m1']
        m2 = data['motor.m2']
        m3 = data['motor.m3']
        m4 = data['motor.m4']
        f.write(str(z)+' '+str(m1)+' '+str(m2)+' '+str(m3)+' '+str(m4)+'\n')


def find_file_and_del(file_name):
    if file_name in os.listdir(os.curdir):
        os.remove(file_name)


def main():
    global file_name
    opt = input('Would you like to change PID gains (y/n)? ')
    if opt == "y":
        Kp, Ki, Kd = [float(m) for m in input('Enter the Kp, Ki, and Kd gain values: ').split()]
    file_name = input("Enter the file name to use: ")
    find_file_and_del(file_name)
    # Initialize the low-level drivers (don't list the debug drivers)
    cflib.crtp.init_drivers(enable_debug_driver=True)
    log_config = LogConfig(name='Height', period_in_ms=100)
    log_config.add_variable('stateEstimate.z', 'float')
    log_config.add_variable('motor.m1', 'int32_t')
    log_config.add_variable('motor.m2', 'int32_t')
    log_config.add_variable('motor.m3', 'int32_t')
    log_config.add_variable('motor.m4', 'int32_t')
    cf = Crazyflie(rw_cache='./cache')
    with SyncCrazyflie(URI, cf=cf) as scf:
        with MotionCommander(scf) as mc:
            with SyncLogger(scf, log_config) as logger:
                if opt == "y":
                    scf.cf.param.set_value('velCtlPid.vzKp', Kp)
                    scf.cf.param.set_value('velCtlPid.vzKi', Ki)
                    scf.cf.param.set_value('velCtlPid.vzKd', Kd)
                scf.cf.log.add_config(log_config)
                log_config.data_received_cb.add_callback(position_callback_z)
                time.sleep(5)
                log_config.start()
                mc.up(1.0, 1.0)
                time.sleep(10.0)
                print('End flight')


if __name__ == '__main__':
    main()