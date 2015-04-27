/*WIRE / PIPE CLIPS by the doommeister 
v0.9 - first release
v0.95 - simple tidy up to use makerbot customizer

//Released under the terms of the GNU GPL v3.0
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

*/
//************************************************************************************************************
//Change these settings to suit
//************************************************************************************************************

//parameters
//Diameter of wire being clamped
wire_dia = 5; 
//Screw or nail size
screw_dia = 3;
//Zip tie width
tie_width = 5; 

//tunable setting - do not change unless you know what your doing
//Printed Layer Height (set to match your slicing settings)
layer_height = 0.2;
//Extrusion Ratio (set to match your slicing settings)
extrusion_ratio = 1.5;
//Clearance
clearance = 0.3;
tie_height = 0.5 * tie_width;

//************************************************************************************************************
//calculated parameters
//************************************************************************************************************

outer_thickness = extrusion_ratio * layer_height;
min_thickness = 6 * outer_thickness;
thickness = min_thickness;
clamp_rad = (wire_dia + clearance) / 2;
outer_rad = clamp_rad + thickness;
height = 3 * screw_dia;
screw_rad = (screw_dia + clearance) /2;
//test
echo(min_thickness);


//************************************************************************************************************
//draw
//************************************************************************************************************
//Comment out to draw chosen styles or show all

draw_all(); //comment out to draw single 


//************************************************************************************************************
//translate([0,0,0])cable_clamp_band();
//translate([0,outer_rad*2.5,0])color("green")cable_clamp_band(smooth=true);

//translate([(outer_rad *2)+(4*screw_dia),0,0])color("red")cable_clip_nail();
//translate([(outer_rad *2)+(4*screw_dia),outer_rad*2.5,0])color("blue")cable_clip_nail(smooth=true);

//translate([-((outer_rad *2)+(4*screw_dia)),0,0])rotate([90,0,0])color("orange")cable_clip_zip_tie(double=true,smooth=false);
//translate([-((outer_rad *2)+(4*screw_dia)),outer_rad*2.5,0])rotate([90,0,0])color("pink")cable_clip_zip_tie(double=true,smooth=true);

//************************************************************************************************************
//Draw for Display
//************************************************************************************************************

module draw_all(){
translate([0,0,0])cable_clamp_band();
translate([0,outer_rad*2.5,0])color("green")cable_clamp_band(smooth=true);

translate([(outer_rad *2)+(4*screw_dia),0,0])color("red")cable_clip_nail();
translate([(outer_rad *2)+(4*screw_dia),outer_rad*2.5,0])color("blue")cable_clip_nail(smooth=true);

translate([-((outer_rad *2)+(4*screw_dia)),0,0])rotate([90,0,0])color("orange")cable_clip_zip_tie(double=true,smooth=false);
translate([-((outer_rad *2)+(4*screw_dia)),outer_rad*2.5,0])rotate([90,0,0])color("pink")cable_clip_zip_tie(double=true,smooth=true);

}


//************************************************************************************************************
//Library Module --- code need refactoring to pass main three vars before this can work
//************************************************************************************************************
module wire_clip(profile = "clamp", smooth = true, wire_dia = 20)
{

			if ( profile == "clamp" ) 
				{ 
					cable_clamp_band(smooth);
				}
}

//************************************************************************************************************
//Modules
//************************************************************************************************************


module cable_clamp_band(smooth=false, $fn=100)

	
{
	translate([0,0,-height])%cylinder(r= wire_dia/2, h = height*3);
		difference()
		{
			if(smooth)
			{
				hull()
				{
					cylinder(r = outer_rad, h = height);
					translate([0,-outer_rad,0])cube([outer_rad+(height/2),thickness,height]);
					translate([0,-thickness,0])cube([outer_rad+(height/2),thickness,height]);
					translate([outer_rad+(height/2),-outer_rad,height/2])rotate([270,0,0])cylinder(r = height/2, h = outer_rad);
				}
			}
			if(!smooth)
			{
				union()
				{
					cylinder(r = outer_rad, h = height);
					translate([0,-outer_rad,0])cube([outer_rad+(height/2),thickness,height]);
					translate([0,thickness-clamp_rad,0])cube([outer_rad+(height/2),thickness,height]);
					translate([outer_rad+(height/2),-outer_rad,height/2])rotate([270,0,0])cylinder(r = height/2, h = thickness*3);
					translate([clamp_rad,-outer_rad,0])cube([thickness,outer_rad,height]);
				}
			}
			translate([0,0,-1])cylinder(r = clamp_rad, h = height+2);	
			translate([0,-clamp_rad,-1])cube([outer_rad+height,thickness,height+2]);
			translate([0,-clamp_rad,-1])cube([clamp_rad,clamp_rad,height+2]);
			translate([outer_rad+(height/2),-outer_rad-1,height/2])rotate([270,0,0])cylinder(r = screw_rad, h = (outer_rad*2)+2);
			
		}

}
//************************************************************************************************************
module cable_clip_nail(smooth=false, $fn=100)

	
{
	translate([0,0,-height])%cylinder(r= wire_dia/2, h = height*3);
		difference()
		{
			if(smooth)
			{
				hull()
				{
					cylinder(r = outer_rad, h = height);
					translate([0,-outer_rad,0])cube([outer_rad+(height/2),thickness,height]);
					translate([0,-thickness,0])cube([outer_rad+(height/2),thickness,height]);
					translate([outer_rad+(height/2),thickness-clamp_rad,height/2])rotate([270,0,0])cylinder(r = height/2, h = outer_rad);
					translate([-outer_rad,-outer_rad,0])cube([thickness,outer_rad,height]);
				}
			}
			if(!smooth)
			{
				union()
				{
					cylinder(r = outer_rad, h = height);
					translate([0,-outer_rad,0])cube([outer_rad+(height/2),thickness,height]);
					translate([0,0.5-clamp_rad,0])cube([outer_rad+(height/2),outer_rad+thickness,height]);
					translate([outer_rad+(height/2),0.5-clamp_rad,height/2])rotate([270,0,0])
						cylinder(r = height/2, h = outer_rad+thickness);
					translate([clamp_rad,-outer_rad,0])cube([thickness,outer_rad,height]);
					translate([-outer_rad,-outer_rad,0])cube([thickness,outer_rad,height]);
				}
			}
			translate([0,0,-1])cylinder(r = clamp_rad, h = height+2);	
			translate([-clamp_rad,-outer_rad-1,-1])cube([(2*outer_rad)+height+2,(thickness+0.5)+1,height+2]);
			translate([-outer_rad-1,-outer_rad-1,-1])cube([(2*outer_rad)+height+2,(thickness)+1,height+2]);
			translate([-clamp_rad,-clamp_rad,-1])cube([clamp_rad*2,clamp_rad,height+2]);
			translate([outer_rad+(height/2),-outer_rad-1,height/2])rotate([270,0,0])cylinder(r = screw_rad, h = (outer_rad*2)+2);
			
		}

}
//************************************************************************************************************
module cable_clip_zip_tie(smooth=false,double=true, $fn=100)

	
{
	translate([0,0,-height])%cylinder(r= wire_dia/2, h = height*3);
		difference()
		{
			if(smooth)
			{
				hull()
				{
					cylinder(r = outer_rad, h = height);
					translate([-outer_rad,-outer_rad,0])cube([(outer_rad*2)+(height/2),thickness,height]);
					
					translate([outer_rad+(height/2),-outer_rad,height/2])rotate([270,0,0])cylinder(r = height/2, h = thickness);
					translate([clamp_rad,-outer_rad,0])cube([thickness,outer_rad,height]);
					translate([-outer_rad,-outer_rad,0])cube([thickness,outer_rad,height]);
					translate([-clamp_rad,-clamp_rad,0])cube([clamp_rad*2,clamp_rad,height]);
					
					if(double)
					{
						translate([-outer_rad-(height/2),-outer_rad,height/2])rotate([270,0,0])cylinder(r = height/2, h = thickness);
						translate([-outer_rad-(height/2),-outer_rad,0])cube([(outer_rad*2)+(height/2),thickness,height]);
					}
				}
			}
			if(!smooth)
			{
				union()
				{
					cylinder(r = outer_rad, h = height);
					translate([-outer_rad,-outer_rad,0])cube([(outer_rad*2)+(height/2),thickness,height]);
					
					translate([outer_rad+(height/2),-outer_rad,height/2])rotate([270,0,0])cylinder(r = height/2, h = thickness);
					translate([clamp_rad,-outer_rad,0])cube([thickness,outer_rad,height]);
					translate([-outer_rad,-outer_rad,0])cube([thickness,outer_rad,height]);
					translate([-clamp_rad,-clamp_rad,0])cube([clamp_rad*2,clamp_rad,height]);
					
					if(double)
					{
						translate([-outer_rad-(height/2),-outer_rad,height/2])rotate([270,0,0])cylinder(r = height/2, h = thickness);
						translate([-outer_rad-(height/2),-outer_rad,0])cube([(outer_rad*2)+(height/2),thickness,height]);
					}
				}
			}
			translate([0,0,-1])cylinder(r = clamp_rad, h = height+2);	
			translate([-outer_rad,-outer_rad-1,(height -tie_width)/2])cube([outer_rad*2,thickness+1.5,tie_width]);
			translate([-outer_rad-(height/2),0,-1])cube([(outer_rad*2)+height,outer_rad+1,height+2]);
			translate([outer_rad+(height/2),-outer_rad-1,height/2])rotate([270,0,0])cylinder(r = screw_rad, h = (outer_rad*2)+2);
			if(double)
			{
				translate([-outer_rad-(height/2),-outer_rad-1,height/2])rotate([270,0,0])cylinder(r = screw_rad, h = (outer_rad*2)+2);
			}

			translate([0,0,(height -tie_width)/2])difference()
			{
			cylinder(r = outer_rad+tie_height, h = tie_width);
		    cylinder(r = outer_rad, h = tie_width);
			}	
		}

}

//************************************************************************************************************
//************************************************************************************************************