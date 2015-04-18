// Copyright 2010 D1plo1d
// Copyright 2013 Timothy Schmidt - timschmidt@gmail.com

// This library is dual licensed under the GPL 3.0 and the GNU Lesser General Public License as per http://creativecommons.org/licenses/LGPL/2.1/ .

include <math.scad>
include <units.scad>


//generates a motor mount for the specified nema standard #.
module stepper_motor_mount(nema_standard,slide_distance=0, mochup=true, tolerance=0) {
	//dimensions from:
	// http://www.numberfactory.com/NEMA%20Motor%20Dimensions.htm
	if (nema_standard == 17)
	{
		_stepper_motor_mount(
			motor_shaft_diameter = 0.1968*mm_per_inch,
			motor_shaft_length = 0.945*mm_per_inch,
			pilot_diameter = 0.866*mm_per_inch,
			pilot_length = 0.80*mm_per_inch,
			mounting_bolt_circle = 1.725*mm_per_inch,
			bolt_hole_size = 3.5,
			bolt_hole_distance = 1.220*mm_per_inch,
			slide_distance = slide_distance,
			mochup = mochup,
			tolerance=tolerance);
	}
	if (nema_standard == 23)
	{
		_stepper_motor_mount(
			motor_shaft_diameter = 0.250*mm_per_inch,
			motor_shaft_length = 0.81*mm_per_inch,
			pilot_diameter = 1.500*mm_per_inch,
			pilot_length = 0.062*mm_per_inch,
			mounting_bolt_circle = 2.625*mm_per_inch,
			bolt_hole_size = 0.195*mm_per_inch,
			bolt_hole_distance = 1.856*mm_per_inch,
			slide_distance = slide_distance,
			mochup = mochup,
			tolerance=tolerance);
	}
	
}


//generates a motor mount for the 28BYJ-48 geared stepper motor
module byj_motor_mount(slide_distance=0, mochup=true, tolerance=0){

	motor_shaft_diameter = 5*mm;
	motor_shaft_length = 10*mm;
	motor_shaft_key = 6*mm;
	pilot_diameter = 9*mm;
	pilot_length = 1.5*mm;
	bolt_hole_size = 4.2*mm;
	bolt_hole_distance = 35*mm;
	pilot_offset = 8*mm;
	motor_diameter = 28*mm;
	motor_length = 19*mm;
	wire_harness_width = 14.5*mm;
	wire_harness_offset = 17*mm;
	wire_harness_length = motor_length - 2.7*mm;
	mounting_tab_width = 7*mm;
	$fn = 30;

	union(){
	// pilot
	translate([0, pilot_offset]) circle(r=pilot_diameter / 2 + tolerance);

	// bolt holes
	translate([- bolt_hole_distance / 2, 0]) circle(r = bolt_hole_size / 2);
	translate([bolt_hole_distance / 2, 0]) circle(r = bolt_hole_size / 2);
	}

	// == motor mock-up ==
	//motor box
	if (mochup == true)
	{
		union(){

		// motor body
		%translate([0, 0, -motor_length]) cylinder(r = motor_diameter / 2, h = motor_length);

		// pilot
		%translate([0, pilot_offset, 0]) cylinder(r=pilot_diameter / 2, h = pilot_length);

		// shaft
		%difference(){
		translate([0, pilot_offset, pilot_length]) cylinder(r = motor_shaft_diameter / 2, h = motor_shaft_length);
		translate([- motor_shaft_diameter / 2, pilot_offset + motor_shaft_diameter / 2 - 1, pilot_length + motor_shaft_length - motor_shaft_key]) cube([motor_shaft_diameter, 2, motor_shaft_key + 1]);
		translate([- motor_shaft_diameter / 2, pilot_offset - motor_shaft_diameter / 2 - 1, pilot_length + motor_shaft_length - motor_shaft_key]) cube([motor_shaft_diameter, 2, motor_shaft_key + 1]);
		}

		// mounting tabs
		difference(){
		%union(){
		translate([- bolt_hole_distance / 2, 0, -1]) cylinder(r = mounting_tab_width / 2, h = 1);
		translate([- bolt_hole_distance / 2, -mounting_tab_width / 2, -1]) cube([mounting_tab_width, mounting_tab_width, 1]);

		translate([bolt_hole_distance / 2, 0, -1]) cylinder(r = mounting_tab_width / 2, h = 1);
		translate([bolt_hole_distance / 2 - mounting_tab_width, -mounting_tab_width / 2, -1]) cube([mounting_tab_width, mounting_tab_width, 1]);
		}
		translate([- bolt_hole_distance / 2, 0, -2]) cylinder(r = bolt_hole_size / 2, h = 3);
		translate([bolt_hole_distance / 2, 0, -2]) cylinder(r = bolt_hole_size / 2, h = 3);
		}

		// wire harness
		%translate([- wire_harness_width / 2, - wire_harness_offset, - wire_harness_length]) cube([wire_harness_width, motor_diameter / 2, wire_harness_length]);
		}
	}
}

//inner mehod for creating a stepper motor mount of any dimensions
module _stepper_motor_mount(
	motor_shaft_diameter,
	motor_shaft_length,
	pilot_diameter,
	pilot_length,
	mounting_bolt_circle,
	bolt_hole_size,
	bolt_hole_distance,
	slide_distance = 0,
	motor_length = 40, //arbitray - not standardized
	mochup,
	tolerance = 0
)
{
	union()
	{
	// == centered mount points ==
	//mounting circle inset
	translate([0,slide_distance/2,0]) circle(r = pilot_diameter/2 + tolerance);
	square([pilot_diameter,slide_distance],center=true);
	translate([0,-slide_distance/2,0]) circle(r = pilot_diameter/2 + tolerance);

	//todo: motor shaft hole
	
	//mounting screw holes
	for (x = [-1,1])
	{
		for (y = [-1,1])
		{
			translate([x*bolt_hole_distance/2,y*bolt_hole_distance/2,0])
			{
				translate([0,slide_distance/2,0]) circle(bolt_hole_size/2 + tolerance);
				translate([0,-slide_distance/2,0]) circle(bolt_hole_size/2 + tolerance);
				square([bolt_hole_size+2*tolerance,slide_distance],center=true);
			}
		}
	}
	// == motor mock-up ==
	//motor box
	if (mochup == true)
	{
		%translate([0,0,-5]) cylinder(h = 5, r = pilot_diameter/2);
		%translate(v=[0,0,-motor_length/2])
		{
			cube(size=[bolt_hole_distance+bolt_hole_size+5,bolt_hole_distance+bolt_hole_size+5,motor_length], center = true);
		}
		//shaft
		%translate(v=[0,0,-(motor_length-motor_shaft_length-2)/2])
		{
			%cylinder(r=motor_shaft_diameter/2,h=motor_length+motor_shaft_length--1, center = true);
		}
	}
	}
}
