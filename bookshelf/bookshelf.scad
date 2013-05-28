/*********************************
* Gridbeam Bookshelf             *
* (c) Timothy Schmidt 2013       *
* http://www.github.com/gridbeam *
* License: GPLv3 / TAPR OHL      *
*********************************/

include <../MCAD/gridbeam.scad>
include <../MCAD/materials.scad>

beam_is_hollow = 0;

color(Pine){

// uprights
zBeam(56);
translateBeam([31,0,0]) zBeam(56);
translateBeam([0,7,0]) zBeam(56);
translateBeam([31,7,0]) zBeam(56);

// cross braces
translateBeam([1,0,0]) yBeam(8);
translateBeam([30,0,0]) yBeam(8);

//translateBeam([1,0,10]) yBeam(8);
//translateBeam([30,0,10]) yBeam(8);

//translateBeam([1,0,20]) yBeam(8);
//translateBeam([30,0,20]) yBeam(8);

//translateBeam([1,0,30]) yBeam(8);
//translateBeam([30,0,30]) yBeam(8);

//translateBeam([1,0,40]) yBeam(8);
//translateBeam([30,0,40]) yBeam(8);

translateBeam([1,0,54]) yBeam(8);
translateBeam([30,0,54]) yBeam(8);

// shelf supports
translateBeam([0,1,1]) xBeam(32);
translateBeam([0,6,1]) xBeam(32);

translateBeam([0,1,10]) xBeam(32);
translateBeam([0,6,10]) xBeam(32);

translateBeam([0,1,19]) xBeam(32);
translateBeam([0,6,19]) xBeam(32);

translateBeam([0,1,28]) xBeam(32);
translateBeam([0,6,28]) xBeam(32);

translateBeam([0,1,37]) xBeam(32);
translateBeam([0,6,37]) xBeam(32);

translateBeam([0,1,46]) xBeam(32);
translateBeam([0,6,46]) xBeam(32);

translateBeam([0,1,55]) xBeam(32);
translateBeam([0,6,55]) xBeam(32);

}
