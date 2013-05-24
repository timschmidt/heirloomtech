/*********************************
* Gridbeam Lathe                 *
* (c) Timothy Schmidt 2013       *
* http://www.github.com/gridbeam *
* License: GPLv3 / TAPR OHL      *
*********************************/

include <../MCAD/gridbeam.scad>
include <../MCAD/materials.scad>

color(Steel) {

// ways
translateBeam([0,0,2]) xBeam(10);
translateBeam([0,2,2]) xBeam(10);

// way supports
translateBeam([1,0,0]) yBeam(3);
translateBeam([9,0,0]) yBeam(3);
translateBeam([1,0,1]) yBeam(3);
translateBeam([9,0,1]) yBeam(3);

// tailstock
translateBeam([6,0,1]) yBeam(3);
translateBeam([6,0,3]) yBeam(3);
translateBeam([7,1,1]) zBeam(6);
translateBeam([6,0,4]) xBeam(2);
translateBeam([6,2,4]) xBeam(2);

// headstock
translateBeam([0,1,0]) zBeam(7);

}
