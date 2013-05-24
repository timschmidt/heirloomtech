/***********************************
* Gridbeam Geodesic Dome Connector *
* (c) Timothy Schmidt 2013         *
* http://www.github.com/gridbeam   *
* License: GPLv3 / TAPR OHL        *
***********************************/

/* Todo:
 - impement "model" mode
*/

include <../MCAD/units.scad>

// To render the DXF file from the command line:
// openscad -x connector.dxf -D'mode="dxf"' connector.scad
//mode = "model";
mode = "dxf";

struts = 6;

module dxf() {
	circle(r=5/16*inch/2, center=true);
	
	for (z=[1 : struts ]) {
		rotate([0,0,z*(360/struts)])
		translate([2.25*inch,0,0])
		circle(r=5/16*inch/2, center=true);
	}
}

module model() {

}

if (mode == "dxf") {
	dxf();
}

if (mode == "model") {
	model();
}