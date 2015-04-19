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

// bed rails
translateBeam([0,0,47]) xBeam(48);
translateBeam([0,33,47]) xBeam(48);

// cornerposts
translateBeam([0,1,0]) zBeam(48);
translateBeam([2,1,0]) zBeam(40);
translateBeam([0,3,0]) zBeam(40);

translateBeam([0,32,0]) zBeam(48);
translateBeam([47,1,0]) zBeam(48);
translateBeam([47,32,0]) zBeam(48);

// bottom rails
translateBeam([1,1,0]) yBeam(32);
translateBeam([0,2,1]) xBeam(3);

translateBeam([1,1,10]) yBeam(32);
translateBeam([0,2,11]) xBeam(3);

translateBeam([0,31,1]) xBeam(48);
translateBeam([0,31,11]) xBeam(48);

// ladder support
translateBeam([0,17,0]) zBeam(40);
translateBeam([16,32,0]) zBeam(40);

// bed slats
translateBeam([0,31,39]) xBeam(48);
translateBeam([0,16,39]) xBeam(48);
translateBeam([0,2,39]) xBeam(48);
translateBeam([0,2,37]) xBeam(48);

translateBeam([1,1,38]) yBeam(32);
translateBeam([16,1,38]) yBeam(32);
translateBeam([32,1,38]) yBeam(32);
translateBeam([46,1,38]) yBeam(32);

translateBeam([15,1,37]) zBeam(3);
translateBeam([31,1,37]) zBeam(3);

// lower bed
translateBeam([17,-15,10]) yBeam(48);
translateBeam([46,-15,10]) yBeam(48);

translateBeam([16,-14,1]) xBeam(32);
translateBeam([16,-14,11]) xBeam(32);
translateBeam([16,2,11]) xBeam(32);
translateBeam([16,16,11]) xBeam(32);

translateBeam([16,-15,0]) zBeam(12);
translateBeam([47,-15,0]) zBeam(12);
translateBeam([16,1,0]) zBeam(12);

}