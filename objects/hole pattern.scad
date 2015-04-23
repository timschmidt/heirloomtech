// @name Hole Pattern
// @id hole-pattern
// @author Timothy Schmidt, 2015
// @git http://www.github.com/timschmidt/heirloomtech
// @license GPLv3+
// @license TAPR OHL
//
// @todo rotate around vertical axis to produce 2D pattern

include <MCAD/units.scad>

length = 12*inch;
radius = 1.5*mm;
threshold = 20*mm;
            
union(){
  // start iterating through the space
  for(x = [0 : length]){
    // check to see if the current position is part of a repeating pattern
    for(i = [round(1.5*inch),round(1*inch),40*mm,50*mm,20*mm]){
      if (x % i == 0){
        // find the next point on a repeating pattern
        for(y = [x : length]){
          if (y % i == 0){
            if (y - x < threshold){
              hull(){
                translate([x,0,0]) circle(r=radius, $fn=16);
                translate([y,0,0]) circle(r=radius, $fn=16);
              }
            } else {
              translate([x,0,0]) circle(r=radius, $fn=16);
            }
         }
      }
   }
}
}
}