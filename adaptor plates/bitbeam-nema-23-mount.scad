include <../MCAD/motors.scad>

beam_width = 7.9375;   // 5/16 inches

difference(){

        // Base plate
        square([8*7, beam_width * 9]);
	
        // Bottom row
        for (x=[8 : 8 : beam_width * 8]) {
            translate([x-4, beam_width/2, 0])
            circle(r=2.4, $fn=25);
        }
	
        // Top row
        for (x=[8 : 8 : beam_width * 8]) {
            translate([x-4, (beam_width/2) + beam_width * 8, 0])
            circle(r=2.4, $fn=25);
	   }

        translate([28, 36, 0]) stepper_motor_mount(23);
}
