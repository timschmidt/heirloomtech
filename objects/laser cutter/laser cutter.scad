/*
* @name Laser Cutter
* @id laser-cutter
* @author Timothy Schmidt, 2015
* @git http://www.github.com/timschmidt/heirloomtech
* @license GPLv3+
* @license TAPR OHL
* @category Printed
* @using 21 frame-1.5x48
* @using 2 frame-1.5x36
*
* @todo Y rails
* @todo X gantry / rail
* @todo X carriage
* @todo tool changer brackets
* @todo laser module
* @todo side panels w/ hinges + latches
* @todo tool holder bracket
* @todo tool holder
* @todo fiber laser tool
* @todo rotary tool
* @todo hot wire foam cutter tool
* @todo FDM 3D printing tool
* @todo direct metal laser sintering tool
* @todo plasma cutter tool?
* @todo vinyl cutter tool?
* @todo pen plotter tool?
* @todo inkjet tool (inkshield, continuous ink)
* 
*/

include <../MCAD/gridbeam.scad>
include <../MCAD/materials.scad>

beam_is_hollow = 1;

color(Aluminum) {

// Legs / Corners 
translateBeam([0,0,0]) zBeam(32);
translateBeam([31,0,0]) zBeam(32);
translateBeam([0,30,0]) zBeam(32);
translateBeam([31,30,0]) zBeam(32);

// Base
translateBeam([1,0,1]) yBeam(32);
translateBeam([30,0,1]) yBeam(32);
translateBeam([0,1,2]) xBeam(32);
translateBeam([0,31,2]) xBeam(32);

// Top
translateBeam([1,0,31]) yBeam(32);
translateBeam([30,0,31]) yBeam(32);
translateBeam([0,1,30]) xBeam(32);
translateBeam([0,31,25]) xBeam(32);

// Lid
translateBeam([0,7,31]) yBeam(24);
translateBeam([31,7,31]) yBeam(24);
translateBeam([0,31,30]) xBeam(32);
#translateBeam([0,8,32]) topShelf(32, 24, 0);

// Top wall panel
translateBeam([0,0,32]) topShelf(32, 8, 0);

// Y Rails
translateBeam([1,0,24]) yBeam(32);
translateBeam([30,0,24]) yBeam(32);


}
