include <MCAD/units.scad>

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



	// == motor mock-up ==
	//motor box
	if (mochup == true)
	{
		union(){

		// motor body
		translate([0, 0, -motor_length]) cylinder(r = motor_diameter / 2, h = motor_length);

		// pilot
		translate([0, pilot_offset, 0]) cylinder(r=pilot_diameter / 2, h = pilot_length);

		// shaft
		difference(){
		translate([0, pilot_offset, pilot_length]) cylinder(r = motor_shaft_diameter / 2, h = motor_shaft_length);
		translate([- motor_shaft_diameter / 2, pilot_offset + motor_shaft_diameter / 2 - 1, pilot_length + motor_shaft_length - motor_shaft_key]) cube([motor_shaft_diameter, 2, motor_shaft_key + 1]);
		translate([- motor_shaft_diameter / 2, pilot_offset - motor_shaft_diameter / 2 - 1, pilot_length + motor_shaft_length - motor_shaft_key]) cube([motor_shaft_diameter, 2, motor_shaft_key + 1]);
		}

		// mounting tabs
		difference(){
		union(){
		translate([- bolt_hole_distance / 2, 0, -1]) cylinder(r = mounting_tab_width / 2, h = 1);
		translate([- bolt_hole_distance / 2, -mounting_tab_width / 2, -1]) cube([mounting_tab_width, mounting_tab_width, 1]);

		translate([bolt_hole_distance / 2, 0, -1]) cylinder(r = mounting_tab_width / 2, h = 1);
		translate([bolt_hole_distance / 2 - mounting_tab_width, -mounting_tab_width / 2, -1]) cube([mounting_tab_width, mounting_tab_width, 1]);
		}
		translate([- bolt_hole_distance / 2, 0, -2]) cylinder(r = bolt_hole_size / 2, h = 3);
		translate([bolt_hole_distance / 2, 0, -2]) cylinder(r = bolt_hole_size / 2, h = 3);
		}

		// wire harness
		translate([- wire_harness_width / 2, - wire_harness_offset, - wire_harness_length]) cube([wire_harness_width, motor_diameter / 2, wire_harness_length]);
		}
	}
}

byj_motor_mount();