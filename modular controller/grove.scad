/*
* @name GROVE 1x1 Model
* @id grove-1x1
* @license GPLv3+, TAPR OHL
* @author Timothy Schmidt, 2015
* @git http://www.github.com/timschmidt/heirloomtech
* @category Electronics
* @using 2 bolt-m3x10
* @using 2 hexnut-nylock-m4
*
* @todo implement variable to choose 1x1, 1x2, 2x2
*/

include <../MCAD/gridbeam.scad>
include <../MCAD/materials.scad>

groves_wide = 1;
groves_tall = 2;
grove_width = 20;
bezel = 20;

// calculated values
plate_width = groves_wide * grove_width + bezel * 2;
plate_height = groves_tall * grove_width + bezel * 2;

color(Aluminum) {

  difference(){
    square([plate_width, plate_height]);
    union(){
      for(x = [0 : groves_wide]){
        for(y = [0 : groves_tall]){
          translate([x * grove_width + bezel,y*grove_width + bezel,0]) circle(r=1.5,$fn=20);
        }
      }
    }
  }
}
