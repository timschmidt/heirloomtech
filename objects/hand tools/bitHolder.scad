// Parameters you can change

hexWidth = 6.8;
bitLenght = 25;
xSpacing = hexWidth+1;
ySpacing = hexWidth+5;
fillet = 5; // Radius of the corners
lidThickness=2;
lidTol = 0.1; //Tolerance between the lid and the holder

//Number of hexagons
columns = 10;
rows = 7;


height = 10;
holeHeight = 8; //Deepness of the hex holes
border = 3; // Distance between the side of the hexagon hole and the side of the holder
rowShift = true; //Change this to false if you want all hexagon rows to be on the same axis

//Calculated data you could change too, but then you'll have to tweak the other data to make it right.
shift = xSpacing/2;
width = rowShift ? (columns-1)*xSpacing+hexWidth+border*2+shift : (columns-1)*xSpacing+hexWidth+border*2;
lenght = (rows-1)*ySpacing+hexWidth+border*2;

//Uncomment what you wish to draw, comment the other

//lid();
holder();

//Hexagon shape
module nut(w,h)
{
	side = w/(2*cos(30));
   for(i = [0:2])
	{
		translate([0,0,h/2]) rotate([0,0,60*i]) cube([w,side,h], center=true);
   }
}

//Rounded corners cube shape
module roundBox(x,y,z,r=5)
{
	translate([r,r,0])
	{
	minkowski()
		{
		cube([x-2*r,y-2*r,z/2]);
		cylinder(r=r, h=z/2);
		}
	}
}

//Solid part of the holder
module base()
{
	roundBox(width,lenght,height,fillet);
	translate([-lidThickness-lidTol,-lidThickness-lidTol,0]) roundBox(width+2*(lidThickness+lidTol),lenght+2*(lidThickness+lidTol),height/2,fillet);
}

//Substracted part of the holder
module baseHoles()
{
	for(i=[0: columns-1],j=[0:rows-1])
	{
		if (rowShift && (j%2!=0))
		{
		translate([shift+border+hexWidth/2+i*xSpacing,border+hexWidth/2+j*ySpacing, height-holeHeight])
		nut(hexWidth,holeHeight+0.1);
		translate([shift+border+hexWidth/2+i*xSpacing,border+hexWidth/2+j*ySpacing, -0.1])
		cylinder(r=hexWidth/4,h=height-holeHeight+0.2,$fn=10);
		} else {
		translate([border+hexWidth/2+i*xSpacing,border+hexWidth/2+j*ySpacing, height-holeHeight])
		nut(hexWidth,holeHeight+0.1);
		translate([border+hexWidth/2+i*xSpacing,border+hexWidth/2+j*ySpacing, -0.1])
		cylinder(r=hexWidth/4,h=height-holeHeight+0.2,$fn=10);
		}
	}
}

//holder
module holder()
{
	difference()
	{
		base();
		baseHoles();
	}
}

//Lid
module lid()
{
	difference()
	{
		translate([-lidThickness-lidTol,-lidThickness-lidTol,0]) roundBox(width+2*(lidThickness+lidTol),lenght+2*(lidThickness+lidTol),height/2-holeHeight+bitLenght+1+lidThickness,fillet);
		translate([-lidTol,-lidTol,lidThickness]) roundBox(width+2*lidTol,lenght+2*lidTol,height/2-holeHeight+bitLenght+1+1,fillet);
		translate([width/2,lenght/2,height/2-holeHeight+bitLenght+1+lidThickness+5])
		rotate([90,0,0])
		union()
		{
			for(i=[0,2])
			{
				rotate([0,90*i,0])
				cylinder(r=15,h=width+lenght);
			}
		}
	}
}