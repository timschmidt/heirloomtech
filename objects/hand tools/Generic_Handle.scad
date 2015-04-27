// By Makercubed.com

h_handle = 88; // Note, this does not include the "dome" part
r_handle = 16; // Top radius of handle

r_hole = 13.6/2; // Inside hole radius
h_hole = h_handle; // Depth of inside hole

grip_thickness = 3.5;
grip_elements = 12;
grip_angle = 1.5;
grip_offset = 2 ;
grip_smoothness = 8;

// General Smoothness
$fn = 50;

r_neck =12; // Base top radius
h_neck = 5; // Base Height
r_bot=22; // Base Radius
h_bot= 3; // Base Edge Height

module handle() {

	union() {
		translate([0,0,h_handle]) sphere(r=r_handle,center=true);
		cylinder(h=h_handle,r1=r_neck,r2=r_handle);
		translate([0,0,h_bot])cylinder(h=h_neck,r1=r_bot,r2=r_neck);
		cylinder(h=h_bot,r=r_bot);

	}
}

difference() {
	handle();
	union() {
		cylinder(r=r_hole,h=h_hole,$fn=10);
	// Edges
		grip();
	}
}

module grip() {
	for ( i = [0 : grip_elements] )
	{
	    rotate([-grip_angle, 0,  i * 360 / (grip_elements-1)])
	    translate([0, r_neck+grip_offset, h_neck+h_bot+.5])
	    cylinder(r=grip_thickness,h=h_hole*2,$fn=grip_smoothness);
	}
}