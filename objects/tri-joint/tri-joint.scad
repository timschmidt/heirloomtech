/*************************************
* HeirloomTech Tri-joint             *
* (c) Timothy Schmidt 2013           *
* http://www.github.com/heirloomtech *
* License: GPLv3+ / TAPR OHL         *
*************************************/

include <../MCAD/gridbeam.scad>
include <../MCAD/materials.scad>

beam_is_hollow = 0;

color(Pine) {

translateBeam([0,1,1]) xBeam(8);
translateBeam([1,0,0]) yBeam(8);
zBeam(8);

}