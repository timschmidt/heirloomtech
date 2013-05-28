/*********************************
* Gridbeam Desk                  *
* (c) Timothy Schmidt 2013       *
* http://www.github.com/gridbeam *
* License: GPLv3 / TAPR OHL      *
*********************************/

include <../MCAD/gridbeam.scad>
include <../MCAD/materials.scad>

beam_is_hollow = 0;

color(Pine) {

// Vertical 
zBeam(40);
translateBeam([31,0,0]) zBeam(40);
translateBeam([0,6,0]) zBeam(40);
translateBeam([31,6,0]) zBeam(40);

// Feet
translateBeam([1,0,1]) yBeam(14);
translateBeam([30,0,1]) yBeam(14);

// Shelving
translateBeam([0,1,2]) xBeam(32);
translateBeam([0,5,2]) xBeam(32);
translateBeam([0,0,3]) topShelf(32, 7, 1);

translateBeam([0,1,10]) xBeam(32);
translateBeam([0,5,10]) xBeam(32);
translateBeam([0,0,11]) topShelf(32, 7, 1);

translateBeam([1,0,19]) yBeam(14);
translateBeam([30,0,19]) yBeam(14);
translateBeam([0,13,20]) xBeam(32);
translateBeam([0,1,20]) xBeam(32);
translateBeam([0,0,21]) topShelf(32, 14, 0);

translateBeam([0,1,35]) xBeam(32);
translateBeam([0,5,35]) xBeam(32);
translateBeam([0,0,36]) topShelf(32, 7, 1);

translateBeam([16,1,28]) xBeam(16);
translateBeam([16,5,28]) xBeam(16);
translateBeam([16,0,28]) zBeam(8);
translateBeam([16,6,28]) zBeam(8);
translateBeam([16,0,29]) topShelf(16,7,1);
}
