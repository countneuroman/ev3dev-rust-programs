extern crate ev3dev_lang_rust;

use ev3dev_lang_rust::Ev3Result;
use ev3dev_lang_rust::motors::{LargeMotor, MotorPort};
use ev3dev_lang_rust::sensors::UltrasonicSensor;
use std::time::Duration;
use std::thread;

fn main() -> Ev3Result<()> {

    let large_motor_1 = LargeMotor::get(MotorPort::OutB)?;
    let large_motor_2 = LargeMotor::get(MotorPort::OutC)?;

    let ultrasonic_sensor: UltrasonicSensor = UltrasonicSensor::find()?;

    large_motor_1.run_direct()?;
    large_motor_2.run_direct()?;

    let mut distance = ultrasonic_sensor.get_distance_centimeters()?;

    while distance > 10.0 {
        large_motor_1.set_duty_cycle_sp(50)?;
        large_motor_2.set_duty_cycle_sp(50)?;
        
        distance = ultrasonic_sensor.get_distance_centimeters()?;
    }

    large_motor_1.set_duty_cycle_sp(-50)?;
    large_motor_2.set_duty_cycle_sp(-50)?;

    //Otherwise, the motor doesn't have time to start and the program terminates; run_timed conflicts with run_direct.
    thread::sleep(Duration::from_secs(1));

    large_motor_1.set_duty_cycle_sp(0)?;
    large_motor_2.set_duty_cycle_sp(0)?;
    large_motor_1.stop()?;
    large_motor_2.stop()?;

    Ok(())
}
