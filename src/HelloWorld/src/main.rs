extern crate ev3dev_lang_rust;

use ev3dev_lang_rust::Ev3Result;
use ev3dev_lang_rust::motors::{LargeMotor, MotorPort};
// use ev3dev_lang_rust::sensors::UltrasonicSensor;

fn main() -> Ev3Result<()> {

    let large_motor_1 = LargeMotor::get(MotorPort::OutB)?;
    let large_motor_2 = LargeMotor::get(MotorPort::OutC)?;

    large_motor_1.run_direct()?;
    large_motor_2.run_direct()?;

    large_motor_1.set_duty_cycle_sp(50)?;
    large_motor_2.set_duty_cycle_sp(50)?;

//    let ultrasonic_sensor: UltrasonicSensor = UltrasonicSensor::find()?;

    Ok(())
}