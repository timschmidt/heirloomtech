/**
 * @id bitbeam-arduino-plate
 * @name Bitbeam Arduino Plate
 * @category Printed
 * @using 4 m3nut
 * @using 4 m3x10
 */

use <arduino.scad>

beam_width = 7.9375;   // 5/16 inches

difference(){

        // Base plate
        square([8*9, beam_width * 9]);
	
        // Bottom row
        for (x=[8 : 8 : beam_width * 10]) {
            translate([x-4, beam_width/2, 0])
            circle(r=2.4, $fn=25);
        }
	
        // Top row
        for (x=[8 : 8 : beam_width * 10]) {
            translate([x-4, (beam_width/2) + beam_width * 8, 0])
            circle(r=2.4, $fn=25);
	   }

        translate([17,60,0])
			projection(cut=true) {
				MountingHoles();
			}
}

// Render the Arduino board
if(render_board){
  translate([17,60,2]) Arduino();
}
