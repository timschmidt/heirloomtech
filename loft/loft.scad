/***********************************
* Gridbeam Loft                    *
* (c) Timothy Schmidt 2013         *
* http://www.github.com/gridbeam   *
* License: GPLv3+ / TAPR OHL       *
***********************************/

include <../MCAD/units.scad>
include <../MCAD/materials.scad>
include <../MCAD/gridbeam.scad>

beam_is_hollow = 0;

color(Pine) {

// top

translateBeam([0,0,48]) xBeam(48);

}