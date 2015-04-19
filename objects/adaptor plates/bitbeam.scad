// Description: "Lego-compatible grid beam"
// Project home: http://bitbeam.org

// Each bitbeam is 5/16 inches wide. It's length is determined by the number of holes.
// Each hole is 8mm apart from each other
// The center of holes are about 4mm (technically 5/32 inches) way from each side of the beam.
// The holes are 4.8 mm in diameter.

beam_width = 7.9375;   // 5/16 inches

module beam(number_of_holes) {
    beam_length = number_of_holes * 8;
        difference(){
            // Draw the beam
            translate([-4, -beam_width/2,0])
            cube(size=[beam_length, beam_width, beam_width]);
    
            // Cut the holes
            for (x=[4 : 8 : beam_length]) {
              translate([x-4, 0, 0]){
                translate([0, 0, -1]){
                  cylinder(r=2.4, h=beam_width+2, $fn=30);
                 }
                rotate(a=[90, 0, 0]) {
                  translate([0, beam_width/2, -beam_width/2-1]){
                    cylinder(r=2.4, h=beam_width+2, $fn=30); 
                  }
                }
              }
           }
        }
}


module beam_to(start=[0,0,0], length=5, direction=[0,0,0]){
  translate(start * beam_width){
    rotate(direction){
	 translate([0, 0, -beam_width/2]){ // rotate around middle of beam
       beam(length);
     }
	}
  }
}

module screw(start=[0,0,0], length=2, direction=[0,0,0]){
  color("lavender"){
  translate(start * beam_width){
    rotate(direction){
	 translate([0, 0, -beam_width/2]){ // rotate around middle of beam
       
      cylinder(r=2.2, h=length*beam_width + beam_width/2, $fn=30);
       
	   translate([0,0,-3]) //Screw head
		 difference(){
           cylinder(r1=3, r2=4, h=3, $fn=30);
		    translate([-4.5, -0.5, -0.1]){
              cube([9,1,2]);
            }
         }
	   translate([0,0, length*beam_width + 0.2]){
	     cylinder(r=5, h=2, $fn=6);
       }

     }
	}
  } 
  }
}


beam_to();
beam_to([0,1,0], direction=[0,90,0]);
screw(direction=[-90,0,0]);


