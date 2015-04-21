include <../lib/MCAD/materials.scad>
include <../lib/MCAD/colors.scad>

// @id lumber-2x4inch-7ft
// @name 2x4inch 7ft Dimensional Lumber
// @madeby tablesaw,bandsaw

color(Pine) {
  cube([1.5*inch,3.5*inch,7*feet]);
}

// @id lumber-2x4inch-8ft
// @name 2x4inch 8ft Dimensional Lumber
// @madeby tablesaw,bandsaw 

color(Pine) {
  cube([1.5*inch,3.5*inch,8*feet]);
}
