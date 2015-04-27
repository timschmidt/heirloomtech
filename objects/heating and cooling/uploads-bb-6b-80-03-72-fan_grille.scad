// Parametric fan grille
// Revision history:
// Original version: John Ridley Sept 25 2011

// these numbers are good for a 60mm fan
// measurements are in millimeters
hole_spacing = 50;
hole_size = 4.5;	// screw hole size
outer_size = 62;	// size of outer square
corner_cut_radius = 40;	// radius of circle drawn around square to round off the corners
outer_circle_diameter = 60;	// diameter of actual fan
inner_circle_diameter = 10;	// diameter of center support circle
outer_thickness = 4;		// Thickness of square outer frame
inner_thickness = 3;		// Vane thickness - should be less than outer_thickness so the fan blades will not hit

vane_count = 4;			// whatever you like here.
vane_width = 2;
ring_count = 2;
ring_width = 2;


// some calculated values
vane_angle = 360 / vane_count;
// ring_spacing defines the CENTER of each ring (radius)
ring_spacing = (outer_circle_diameter - inner_circle_diameter+ring_width)/(ring_count+1)/2;
//ring_spacing = outer_circle_diameter;
cpu_fan_grille();

module cpu_fan_grille()
{
	union()
	{
	// outer mounting ring is a cube minus the cutouts
	difference()
	{
		intersection()
		{
			translate(v=[-outer_size/2, -outer_size/2,0])
				cube(size=[outer_size, outer_size, outer_thickness]);
			cylinder(r=corner_cut_radius, h=outer_thickness);
		}
		// cut the screw holes
		translate(v=[hole_spacing/2, hole_spacing/2, 0])
			cylinder(h=outer_thickness, r=hole_size/2);
		translate(v=[-hole_spacing/2,- hole_spacing/2, 0])
			cylinder(h=outer_thickness, r=hole_size/2);
		translate(v=[hole_spacing/2,- hole_spacing/2, 0])
			cylinder(h=outer_thickness, r=hole_size/2);
		translate(v=[-hole_spacing/2, hole_spacing/2, 0])
			cylinder(h=outer_thickness, r=hole_size/2);

		// cut the main center hole
		cylinder(h=outer_thickness, r=outer_circle_diameter/2);
	}
	// the inner circle
	cylinder(h=inner_thickness, r=inner_circle_diameter/2);
	// rotate for aesthetics
	rotate([0,0,vane_angle/2])
	for (angle = [0 : vane_angle : 360] )
	{
		rotate([0,0,angle])
		translate(v=[0,-vane_width/2,0])
		cube(size=[outer_circle_diameter/2, vane_width, inner_thickness]);
	}
	// circles
	for (x = [1 : ring_count ])
	{
		difference()
		{
			cylinder(h=inner_thickness, r=inner_circle_diameter/2 + (ring_spacing * x) + (ring_width/2));
			cylinder(h=inner_thickness, r=inner_circle_diameter/2 + (ring_spacing * x) - (ring_width/2));
		}
	}
	}
}