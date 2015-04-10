/*************************************
* HeirloomTech GROVE mounting plate  *
* (c) Timothy Schmidt 2013           *
* http://www.github.com/heirloomtech *
* License: GPLv3+ / TAPR OHL         *
*************************************/

include <../MCAD/gridbeam.scad>
include <../MCAD/materials.scad>

groves_wide = 2;
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
