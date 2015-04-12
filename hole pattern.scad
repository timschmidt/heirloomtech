/************************************************
* HeirloomTech Hole Pattern                     *
* (c) Timothy Schmidt 2013                      *
* http://www.github.com/timschmidt/heirloomtech *
* License: GPLv3+ / TAPR OHL                    *
************************************************/

include <../MCAD/gridbeam.scad>
include <../MCAD/units.scad>
include <../MCAD/materials.scad>

color(Aluminum) {

for(x = [0 : 24*inch]) {
  for (y = [0 : 24*inch]) {
    translate([x,y,0]) circle(r=2);
  }
}

}