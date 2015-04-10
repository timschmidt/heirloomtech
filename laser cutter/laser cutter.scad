/*************************************
* HeirloomTech Laser Cutter          *
* (c) Timothy Schmidt 2013           *
* http://www.github.com/heirloomtech *
* License: GPLv3+ / TAPR OHL         *
*************************************/

include <../MCAD/gridbeam.scad>
include <../MCAD/materials.scad>

beam_is_hollow = 1;

color(Aluminum) {

// Legs / Corners 
translateBeam([0,0,0]) zBeam(32);
translateBeam([31,0,0]) zBeam(32);
translateBeam([0,31,0]) zBeam(32);
translateBeam([31,31,0]) zBeam(32);

// Base
translateBeam([1,0,1]) yBeam(32);
translateBeam([30,0,1]) yBeam(32);
translateBeam([0,1,2]) xBeam(32);
translateBeam([0,30,2]) xBeam(32);

// Top
translateBeam([1,0,31]) yBeam(32);
translateBeam([30,0,31]) yBeam(32);
translateBeam([0,1,30]) xBeam(32);
translateBeam([0,30,30]) xBeam(32);

// Lid
translateBeam([0,7,31]) yBeam(24);
translateBeam([31,7,31]) yBeam(24);
#translateBeam([0,8,32]) topShelf(32, 24, 0);

// Top wall panel
translateBeam([0,0,32]) topShelf(32, 8, 0);

// Y Rails
translateBeam([1,0,24]) yBeam(32);
translateBeam([30,0,24]) yBeam(32);


}
