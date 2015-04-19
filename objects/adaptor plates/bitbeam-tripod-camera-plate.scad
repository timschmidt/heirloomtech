beam_width = 7.9375;   // 5/16 inches
// professional tripod mounting screws are 3/8-16
// mounting_hole = 3/8 * 25.4;

// consumer tripod mounting screws are 1/4-20
mounting_hole = 1/4 * 25.4;

clearance = 0.15;

difference(){

        // Base plate
        square([8*3, beam_width * 4]);
	
        // Bottom row
        for (x=[8 : 8 : beam_width * 4]) {
            translate([x-4, beam_width/2, 0])
            circle(r=2.4, $fn=25);
        }
	
        // Top row
        for (x=[8 : 8 : beam_width * 4]) {
            translate([x-4, (beam_width/2) + beam_width * 3, 0])
            circle(r=2.4, $fn=25);
	   }

        translate([12, beam_width * 4 / 2, 0]) circle(r=(mounting_hole / 2) + clearance, $fn=25);
}
