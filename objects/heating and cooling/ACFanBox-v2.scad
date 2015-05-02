// mount for a Polar Wind 120vac desk fan into a 120mm sized box
// to mate with standard 120mm fixtures (such as large computer fans use)
// but deliver much more airflow
// John Ridley 2014-09-19

screwdist = 104;
screwdia = 5;
fanscrewdia = 2.7;
squaresides = 120;

insidedia = 105;

bodythickness = 70;

motorScrewDist = 38;
motorScrewOffset = 10;

$fn = 36;

wall = 2;

// frame body
body();
motormount();


module motormount()
{
	translate([motorScrewOffset, 0,0])
	{
		difference()
		{
			union()
			{
				translate([0,0,2.5])
					cube([10,squaresides-wall*2, 5], center=true);
				for (y=[-1,1])
					translate([0,(motorScrewDist/2) * y, 0])
						cylinder(d=10, h=18);
				for (y=[-1,1])
					translate([-motorScrewOffset,(motorScrewDist/2) * y, 2.5])
						cube([squaresides-wall*2,10, 5], center=true);
			}
			for (y=[-1,1])
				translate([0,(motorScrewDist/2) * y, 0])
					cylinder(d=fanscrewdia, h=18);
		}
	}
}

module body()
{
	difference()
	{
		union()
		{
			endplate();
			translate([0,0,bodythickness - 0.1])
			rotate([180,0,0])
				endplate();
			// main duct body
			duct(dia1=squaresides, dia2=insidedia+wall*2, h1=20, h3=5, h2=bodythickness-25);
			
		}
		// center hole
		duct(dia1=squaresides-wall*2, dia2=insidedia, h1=20, h3=5, h2=bodythickness-25);
	}

}

// dual tapered cylinder
module duct(dia1, dia2, h1, h2, h3)
{
	cylinder(d1=dia1, d2=dia2, h=h1);
	translate([0,0,h1])
		cylinder(d=dia2, h=h2);
	translate([0,0,h1+h2])
		cylinder(d1=dia2, d2=dia1, h=h3);
}

module endplate()
{
	difference()
	{
		hull()
		{
			corners(diameter=(squaresides-screwdist), height=wall*2, spacing=screwdist);
			cylinder(d=insidedia, h=15);
		}
		// flats for screws
//		translate([0,0,wall*2 + 0.5])
//		corners(diameter=(squaresides-screwdist), height=15, spacing=screwdist);

		// screw holes - leave a layer for clean printing
		corners(diameter=screwdia, height=wall*4, spacing=screwdist);
	}
}


// make cylinders of diameter and height at the screw locations
// used multiple times
module corners(diameter, height, spacing)
{
	for (x=[-1,1])
		for (y=[-1,1])
			translate([x*(spacing/2), y*(spacing/2), 0])
				cylinder(d=diameter, h=height);
}