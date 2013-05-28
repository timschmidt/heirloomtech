/*********************************
* Gridbeam Logo                  *
* (c) Timothy Schmidt 2013       *
* http://www.github.com/gridbeam *
* License: GPLv3+ / TAPR OHL     *
*********************************/

include <../MCAD/gridbeam.scad>
include <../MCAD/materials.scad>

beam_is_hollow = 0;

color(Pine) {

// lines
translateBeam([0,1,8]) xBeam(24);
translateBeam([2,0,0]) zBeam(16);

// g
translateBeam([6,0,8]) zBeam(8);
translateBeam([6,1,15]) xBeam(6);
translateBeam([11,0,14]) zBeam(2);
translateBeam([11,0,8]) zBeam(4);
translateBeam([10,1,11]) xBeam(2);
translateBeam([7,0,9]) yBeam(2);
translateBeam([7,0,14]) yBeam(2);

// r
translateBeam([14,0,8]) zBeam(5);
translateBeam([14,1,11]) xBeam(3);

// i
translateBeam([17,0,8]) zBeam(5);

// d
translateBeam([20,0,8]) zBeam(5);
translateBeam([20,1,12]) xBeam(4);
translateBeam([23,0,0]) zBeam(24);

// b
translateBeam([2,1,0]) xBeam(5);
translateBeam([6,0,0]) zBeam(5);
translateBeam([2,1,4]) xBeam(24);
translateBeam([3,0,1]) yBeam(2);
translateBeam([5,0,3]) yBeam(2);

// e
translateBeam([8,0,0]) zBeam(5);
translateBeam([11,0,2]) zBeam(3);
translateBeam([8,1,2]) xBeam(4);
translateBeam([8,1,0]) xBeam(4);

// a
translateBeam([16,0,0]) zBeam(5);
translateBeam([13,0,0]) zBeam(3);
translateBeam([13,1,0]) xBeam(4);
translateBeam([13,1,2]) xBeam(4);

// m
translateBeam([19,0,0]) zBeam(5);
translateBeam([21,0,0]) zBeam(5);
translateBeam([19,1,0]) zBeam(2);
translateBeam([21,1,0]) zBeam(2);

}