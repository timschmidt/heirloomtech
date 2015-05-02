//$fs=0.4; $fa=10; //corner fix

// Some useful Constants
overlap = 0.001;
//phi = 1.61803399;
phi = 1.9;


// Change these to suit your needs
numConnectors = 3;
//ODs = [12.5,11,7]; // outer diameters
//ODs = [11,11,7]; // outer diameters
//ODs = [11,9.5,7]; // outer diameters
//ODs = [10.5]; // outer diameters (9.5->10.5)
ODs = [11,10,7]; // outer diameters
centerH = 14;
//centerR = centerH/2;
centerR = 11/2;


length = 15;	// Overall length of flanged section
sections = 4;	// How many flange sections
section_length = length/(sections);

// Standoff is the smooth sleeve that goes from 
// the flanged section to the central hub
standoff=15;
standoffOR = OR;

//===================================
// Printing various parts
//===================================
translate([0,0,centerH/2]) rotate([0,90,0]) print_connectors(numConnectors, $fn=24);

// single connector test
// difference(){
//	translate([0,0,centerH/2]) rotate([0,90,45]) print_connectors(numConnectors, $fn=24);
//	translate([0,0,centerH/2]) #cylinder(r=centerR*0.5, h=centerH+overlap*2, center=true);
// }
//=========================================
//		MODULES
//=========================================

module print_cone_section(IR,OR)
{
	conetop = IR+((OR-IR)/2);
	conebottom = OR;

	difference()
	{
		cylinder(r1=conebottom, r2=conetop, h=section_length+overlap);
	
		translate([0,0,-overlap])
		cylinder(r=IR, h=section_length+overlap*3);
	}
}

module print_cone_sections(IR,OR)
{
	for (section = [0:sections-1])
	{
		translate([0,0,section*section_length])
		print_cone_section(IR,OR);
	}
}

module connector_blank(OD)
{
	ID = OD/phi;
	IR = ID/2;
	cylinder(r=IR, h=standoff+overlap*3);
	sphere(r=IR);
}


module print_single_connector(OD)
{
	OR = OD/2;
	ID = OD/phi;
	IR = ID/2;
	standoffOR = OR;

	translate([0,0,standoff-overlap])
	print_cone_sections(IR,OR);

	difference()
	{
		cylinder(r=standoffOR, h=standoff);

		translate([0,0,-overlap])
		connector_blank(OD);
	}
}

module print_connectors(num)
{
	angle = 360/num;

	difference()
	{
		union()
		{
			//sphere(r=OR);
			rotate([0,90,0])
				//cylinder(r=standoffOR, h=standoffOR*2, center=true);
				cylinder(r=centerR, h=centerH, center=true);

			for(connector = [1:num])
			{
				rotate([(connector-1)*angle, 0, 0])
				print_single_connector(ODs[connector-1]);
			}
		}

		for(connector = [1:num])
		{
			rotate([(connector-1)*angle, 0, 0])
			connector_blank(ODs[connector-1]);
		}
	}
}

/*
	Print an elbow

	Parameter:
		angle - defaults to 90 degrees, set to whatever you want
*/
module print_elbow(angle=90)
{	
	difference()
	{
		union()
		{
			//sphere(r=standoffOR);
			
			rotate([0,90,0])
			cylinder(r=standoffOR, h=standoffOR*2, center=true);

			print_single_connector();
			rotate([angle, 0, 0])
			print_single_connector();
		}

		// subtract out the rounded bottom
		// for each connector
		connector_blank();

		rotate([angle, 0, 0])
		connector_blank();
	}
}
