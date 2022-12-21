"""
PROJECT 1
TEAM 1
SYNCHORNIZED FIGURE 8 FLIGHT OF CRAZYFLIE
"""

# Import modules
import time
import json
from queue import Queue
import numpy as np
import cflib.crtp
from cflib.crazyflie.log import LogConfig
from cflib.crazyflie.swarm import CachedCfFactory
from cflib.crazyflie.swarm import Swarm
from cflib.crazyflie.syncLogger import SyncLogger

import cflib.crtp
from cflib.crazyflie import Crazyflie
from cflib.crazyflie.mem import MemoryElement
from cflib.crazyflie.mem import Poly4D
from cflib.crazyflie.syncCrazyflie import SyncCrazyflie

# Calling the json with all the stored data
#should be data_dict.json
with open('data_dict.json', 'r') as f:
    data = json.load(f)

# URI to the Crazyflie to connect to
uris = [k for k in data.keys()]

class Uploader:
    def __init__(self):
        self._is_done = False

    def upload(self, trajectory_mem):
        print('Uploading data')
        trajectory_mem.write_data(self._upload_done)

        while not self._is_done:
            time.sleep(0.2)

    def _upload_done(self, mem, addr):
        print('Data uploaded')
        self._is_done = True
        
        
        
def check_battery(scf: SyncCrazyflie, min_voltage=3.7):
    print('Checking battery...')
    log_config = LogConfig(name='Battery', period_in_ms=500)
    log_config.add_variable('pm.vbat', 'float')

    with SyncLogger(scf, log_config) as logger:
        for log_entry in logger:
            log_data = log_entry[1]
            vbat = log_data['pm.vbat']
            if log_data['pm.vbat'] < min_voltage:
                msg = "battery too low: {:10.4f} V, for {:s}".format(
                    vbat, scf.cf.link_uri)
                raise Exception(msg)
            else:
                print(log_data['pm.vbat'])
                return


def check_state(scf: SyncCrazyflie, min_voltage=3.7):
    print('Checking state.')
    log_config = LogConfig(name='State', period_in_ms=500)
    log_config.add_variable('stabilizer.roll', 'float')
    log_config.add_variable('stabilizer.pitch', 'float')
    log_config.add_variable('stabilizer.yaw', 'float')
    print('Log configured.')

    with SyncLogger(scf, log_config) as logger:
        for log_entry in logger:
            log_data = log_entry[1]
            roll = log_data['stabilizer.roll']
            pitch = log_data['stabilizer.pitch']
            yaw = log_data['stabilizer.yaw']
            print('Checking roll/pitch/yaw.')

            for name, val in [('roll', roll), ('pitch', pitch), ('yaw', yaw)]:

                if np.abs(val) > 20:
                    print('exceeded')
                    msg = "too much {:s}, {:10.4f} deg, for {:s}".format(
                        name, val, scf.cf.link_uri)
                    print(msg)
                    raise Exception(msg)
            return
            
            
            
def preflight_sequence(scf: Crazyflie):
    """
    This is the preflight sequence. It calls all other subroutines before takeoff.
    """
    cf = scf.cf  # type: Crazyflie

    try:
        # enable high level commander
        cf.param.set_value('commander.enHighLevel', '1')

        # ensure params are downloaded
        wait_for_param_download(scf)

        # make sure not already flying
        land_sequence(scf)

        # disable LED to save battery
        cf.param.set_value('ring.effect', '0')

        # set pid gains, tune down Kp to deal with UWB noise
        cf.param.set_value('posCtlPid.xKp', '1')
        cf.param.set_value('posCtlPid.yKp', '1')
        cf.param.set_value('posCtlPid.zKp', '1')

        # check battery level
        check_battery(scf, 3.7)

        # reset the estimator
        reset_estimator(scf)

        # check state
        check_state(scf)

    except Exception as e:
        print(e)
        land_sequence(scf)
        raise(e)

def wait_for_position_estimator(scf):
    print('Waiting for estimator to find position...')

    log_config = LogConfig(name='Kalman Variance', period_in_ms=500)
    log_config.add_variable('kalman.varPX', 'float')
    log_config.add_variable('kalman.varPY', 'float')
    log_config.add_variable('kalman.varPZ', 'float')

    var_y_history = [1000] * 10
    var_x_history = [1000] * 10
    var_z_history = [1000] * 10
    threshold = 0.001

    with SyncLogger(scf, log_config) as logger:
        for log_entry in logger:
            data = log_entry[1]

            var_x_history.append(data['kalman.varPX'])
            var_x_history.pop(0)
            var_y_history.append(data['kalman.varPY'])
            var_y_history.pop(0)
            var_z_history.append(data['kalman.varPZ'])
            var_z_history.pop(0)

            min_x = min(var_x_history)
            max_x = max(var_x_history)
            min_y = min(var_y_history)
            max_y = max(var_y_history)
            min_z = min(var_z_history)
            max_z = max(var_z_history)

            # print("{} {} {}".
            #       format(max_x - min_x, max_y - min_y, max_z - min_z))

            if (max_x - min_x) < threshold and (
                    max_y - min_y) < threshold and (
                    max_z - min_z) < threshold:
                break


def land_sequence(scf: Crazyflie):
    try:
        cf = scf.cf  # type: Crazyflie
        commander = cf.high_level_commander  # type: cflib.HighLevelCOmmander
        commander.land(0.0, 3.0)
        print('Landing...')
        time.sleep(3)
        # disable led to save battery
        cf.param.set_value('ring.effect', '0')
        commander.stop()
    except Exception as e:
        print(e)
        land_sequence(scf)

def reset_estimator(scf):
    cf = scf.cf
    cf.param.set_value('kalman.resetEstimation', '1')
    time.sleep(0.1)
    cf.param.set_value('kalman.resetEstimation', '0')

    wait_for_position_estimator(cf)

def activate_high_level_commander(scf):
    cf = scf.cf
    cf.param.set_value('commander.enHighLevel', '1')

def activate_mellinger_controller(scf):
    cf = scf.cf
    cf.param.set_value('stabilizer.controller', '2')
    
def wait_for_param_download(scf: SyncCrazyflie):
    while not scf.cf.param.is_updated:
        time.sleep(1.0)
    print('Parameters downloaded for', scf.cf.link_uri)

def upload_trajectory(scf):
    cf = scf.cf
    trajectory = np.array(data[cf.link_uri]['trajectory'])
    trajectory_id = data[cf.link_uri]['trajectory_id']
    trajectory_mem = cf.mem.get_mems(MemoryElement.TYPE_TRAJ)[0]

    total_duration = 0
    for row in trajectory:
        #Make the duration scaled for larger figure 8
        duration = row[0]
        new_duration = duration * 1
        #Divide every element by a number: Success
        divider = [ i / 1 for i in row]
        x = Poly4D.Poly(divider[1:9])
        y = Poly4D.Poly(divider[9:17])
        #x = Poly4D.Poly(row[1:9])
        #y = Poly4D.Poly(row[9:17])
        z = Poly4D.Poly(row[17:25])
        yaw = Poly4D.Poly(row[25:33])
        trajectory_mem.poly4Ds.append(Poly4D(duration, x, y, z, yaw))
        #Make duration scaled
        total_duration += new_duration

    Uploader().upload(trajectory_mem)
    cf.high_level_commander.define_trajectory(trajectory_id, 0,
                                              len(trajectory_mem.poly4Ds))
    print(total_duration)
    return total_duration

def run_sequence(scf):
    cf = scf.cf
    trajectory_id = data[cf.link_uri]['trajectory_id']
    #duration = data[cf.link_uri]['duration']*8
    commander = cf.high_level_commander
    
    commander.takeoff(1, 2.5)
    time.sleep(2)
    relative = True
    commander.start_trajectory(trajectory_id, 2.0, relative)
    time.sleep(16)
    commander.land(0,3)
    time.sleep(2)
    commander.stop()


if __name__ == '__main__':
    cflib.crtp.init_drivers(enable_debug_driver=False)
    controlQueues = [Queue() for _ in range(len(uris))]
    factory = CachedCfFactory(rw_cache='./cache')
    with Swarm(uris, factory=factory) as swarm:
        swarm.parallel_safe(activate_mellinger_controller)
        swarm.parallel_safe(activate_high_level_commander)
        time.sleep(12)
        swarm.parallel_safe(reset_estimator)
        time.sleep(12)
        swarm.parallel_safe(preflight_sequence)
        swarm.parallel_safe(upload_trajectory)
        time.sleep(20)
        swarm.parallel_safe(run_sequence)
