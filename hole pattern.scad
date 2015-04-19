/*
* @name Hole Pattern
* @id hole-pattern
* @author Timothy Schmidt, 2015
* @git http://www.github.com/timschmidt/heirloomtech
* @license GPLv3+
* @license TAPR OHL
*
* @todo rotate around vertical axis to produce 2D pattern
*/

include <../MCAD/units.scad>

length = 12*inch;
patterns = [round(1.5*inch),
            round(1*inch),
            40*mm,
            50*mm,
            20*mm
           ];
            
union(){
  for(x = [0 : length]) {
    for(y = [0 : length]) {
      // pseudocode follows
      for(patterns){
        if(x == pattern & y == pattern){
          hull(){
            circle1;
            circle2;
          }
        }
      }
    }
  }
}