/***********************************
* Gridbeam Geodesic Dome Connector *
* (c) Timothy Schmidt 2013         *
* http://www.github.com/gridbeam   *
* License: GPLv3+ / TAPR OHL       *
***********************************/

// Todo: 
// - finish paramaterization - derive every value from beam width, struts, and thickness
// - replace connector_spacing with connector_pitch

include <../MCAD/units.scad>
include <../MCAD/constants.scad>

// To render the DXF file from the command line:
// openscad -x connector.dxf -D'mode="dxf"' connector.scad
//mode = "model";
mode = "dxf";

struts = 5;
thickness = 1/8 * inch;
connector_spacing = 360/struts;
connector_width=connector_spacing/2;
diameter = PI*2.25*inch / struts;

module dxf() {
	difference() {
	
		// body

		union() {
		hull() {
			for (z=[1 : struts ]) {
			rotate([0,0,z*connector_spacing])
			translate([2.25*inch,0,0])
			circle(r=epsilon, center=true);
			}
		}
		for (z=[1 : struts ]) {
			rotate([0,0,z*connector_spacing])
			translate([2.25*inch,0,0])
			circle(r=diameter/2, center=true);
			}
		}

		// edge cutout holes

		for (z=[1 : struts ]) {
			rotate([0,0,z*connector_spacing+connector_width])
			translate([2.25*inch,0,0])
			circle(r=diameter/2, center=true);
			}

		// center hole

		circle(r=5/16*inch/2, center=true);

		// strut mounting holes
	
		for (z=[1 : struts ]) {
			rotate([0,0,z*connector_spacing])
			translate([2.25*inch,0,0])
			circle(r=5/16*inch/2, center=true);
		}
	}
}

module model() {
	cylinder(r=5/16*inch/2, h=thickness, center=true);
	
	for (z=[1 : struts ]) {
		rotate([0,0,z*(360/struts)])
		translate([2.25*inch,0,0])
		cylinder(r=5/16*inch/2, h=thickness, center=true);
	}
}

if (mode == "dxf") {
	dxf();
}

if (mode == "model") {
	model();
}