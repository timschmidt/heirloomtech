/*
* @name Hole Pattern
* @id hole-pattern
* @author Timothy Schmidt, 2013
* @git http://www.github.com/timschmidt/heirloomtech
* @license GPLv3+, TAPR OHL
*
* @todo 
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