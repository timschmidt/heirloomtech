/******************************************
* Single spindle Gridbeam CNC drill press *
* (c) Timothy Schmidt 2013                *
* http://www.github.com/gridbeam          *
* License: GPLv3 / TAPR OHL               *
******************************************/

/* Todo:
 - centered crosses on drill locations
 - move module variables into their respective modules
*/

include <../MCAD/units.scad>

/************
* Constants *
************/

dc_geared_motor=1;
dc_windshield_wiper_motor=2;

sensor1=1;
sensor2=2;

bearing1=1;
bearing2=2;

/****************
* Configuration *
****************/

idler_wheel_diameter	= 3 * inch;
idler_axle_diameter	= 5/16 * inch;
drive_wheel_diameter	= 4 * inch;
drive_axle_diameter	= 5/16 * inch;
axle_mounting_safety_margin = 5/16 * inch;
mounting_hole_spacing = 5 * inch;
beam_width				= 1.5 * inch;
motor_model				= dc_geared_motor;
rotational_sensor_model = sensor1;
bearing_model			= bearing1;
drill_size				= 5/16 * inch;

if (motor_model == dc_geared_motor) {
  include <"dc_geared_motor.scad">
}

if (rotational_sensor_model == sensor1) {
  include <"sensor1.scad">
}

mounting_plate_width = max(mounting_hole_spacing, idler_wheel_diameter) +
							idler_wheel_diameter / 2 +
							idler_axle_diameter +
							axle_mounting_safety_margin;
mounting_plate_height=	idler_wheel_diameter / 2 +
								idler_axle_diameter / 2 +
            				drive_wheel_diameter / 2 +
								drive_axle_diameter / 2 +
								axle_mounting_safety_margin * 2 +
				            beam_width;

/********
* Model *
********/

// Drill bit is at [mounting_plate_width/2, mounting_plate_height/2]

module mounting_plate() {
	square([	mounting_plate_width, mounting_plate_height]);
}


module indexed_idler(){ // centered behind drill bit
	translate([mounting_plate_width/2, axle_mounting_safety_margin, 0])
	circle(r=idler_axle_diameter / 2);
}


module drive_wheel() { //centered in front of drill bit */
	translate([mounting_plate_width/2, mounting_plate_height - drive_axle_diameter - axle_mounting_safety_margin, 0])
	circle(r=drive_axle_diameter / 2);
}


module dummy_idler_a() { // offset toward the input from the insrumented idler */
	translate([axle_mounting_safety_margin + idler_axle_diameter/2, mounting_plate_height - drive_axle_diameter - axle_mounting_safety_margin, 0])
	circle(r=idler_axle_diameter/2);
}

module dummy_idler_b() { // offset toward the input from the drive wheel */
	translate([axle_mounting_safety_margin + idler_axle_diameter/2, axle_mounting_safety_margin, 0])
	circle(r=idler_axle_diameter/2);
}

module drill_clearance_hole() {
	translate([mounting_plate_width/2, mounting_plate_height/2,0])
	circle(r=drill_size/2);
}

difference() {
	mounting_plate();
	indexed_idler();
	drive_wheel();
	dummy_idler_a();
	dummy_idler_b();
	drill_clearance_hole();
}