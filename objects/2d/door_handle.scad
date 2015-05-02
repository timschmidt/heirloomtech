width = 91; 
depth = 35;
thickness = 6;
percStraight = 0.4;
nutHoleDistance = 72; //distance between center points of nuts
spaceAroundBolt = 10;
offset = 0; // for lasercutter beam width

boltWidth = 5;
boltLength = 16;
nutWidth = 8;
nutHeight = 4;
spaceAroundBolt = 10;
plugWidth = 20;
plugHeight = thickness;

wallConnectorWidth = 20; //18;
wallConnectorHeight = 15;//12.5;
wallConnectorInnerWidth = spaceAroundBolt;
holeWidth = boltWidth;

bigHoleWidth = width*0.6;
bigHoleHeight = depth*0.7;

$fs=0.4;$fa=5;
f = 1; // fix for overlapping edges issue
s = 1;//seperator dis.

width2 = width+offset*2;
depth2 = depth+offset*2;
plugWidth2 = plugWidth+offset*2;
plugHeight2 = plugHeight+offset;
holeWidth2 = holeWidth-offset*2;
holeHeight2 = plugHeight-offset*2;
boltWidth2 = boltWidth-offset*2;
boltLength2 = boltLength-offset;
nutWidth2 = nutWidth-offset*2;
nutHeight2 = nutHeight-offset*2;
spaceAroundBolt2 = spaceAroundBolt-offset*2;

bigHoleWidth2 = bigHoleWidth-offset*2;
bigHoleHeight2 = bigHoleHeight-offset*2;

export();
//assembly3D();
//testOverlap();

module export()
{
	body();
	//translate([0-wallConnectorWidth*0.6,0-depth2*0.5,0]) wallConnector();
	//translate([wallConnectorWidth*0.6,0-depth2*0.5,0]) wallConnector();
}
module assembly3D()
{
	wood() body();
	translate([0-nutHoleDistance/2,-thickness/2,0]) rotate([90,0,0]) wood() wallConnector();
	translate([nutHoleDistance/2,-thickness/2,0]) rotate([90,0,0]) wood() wallConnector();
}
module testOverlap()
{
	intersection()
	{
		wood() body();
		union() 
		{
			translate([0-nutHoleDistance/2,-thickness/2,0]) rotate([90,0,0]) wood() wallConnector();
			translate([nutHoleDistance/2,-thickness/2,0]) rotate([90,0,0]) wood() wallConnector();
		}
	}
}

module body()
{
	difference()
	{
		// main body part
		translate([0,-depth2*percStraight,0])
		{
			union()
			{
				translate([-width2/2,0,0]) square([width2,depth2*percStraight]);
				difference()
				{
					ellipse(width2, depth2*(1-percStraight)*2);
					translate([-width2/2,0,0]) square([width2,depth2*(1-percStraight)]);
				}
			}
		}
		// bolt cut outs
		translate([0-nutHoleDistance/2,0,0]) rotate([0,0,180]) boltCutOutSide();
		translate([nutHoleDistance/2,0,0]) rotate([0,0,180]) boltCutOutSide();

		translate([0,0-depth*0.5]) complexRoundSquare([bigHoleWidth2,bigHoleHeight2],[28,12],[28,12],[10,6],[10,6]);

	}
	//square([width,depth]);
	//ellipse(width, depth);
}
module wallConnector(offset=0)
{
	width = wallConnectorWidth+offset;
	height = wallConnectorHeight+offset;
	difference()
	{
		ellipse(width,height);
		boltCutOutFront(width);
	}
}

module boltCutOutSide() //origin: top center
{
	union()
	{
		translate([-spaceAroundBolt2/2,-f,0]) 
			square([spaceAroundBolt2,plugHeight2+f]);
		translate([-nutWidth2/2,plugHeight2+thickness,0]) //plugHeight2+thickness
			square([nutWidth2,nutHeight2]);
		translate([-boltWidth2/2,0,0]) 
			square([boltWidth2,boltLength2]);
	}
}
module boltCutOutFront(width) //origin: center
{
	difference()
	{
		square([width,thickness-offset*2],center=true);
		translate(0,-f,0) square([spaceAroundBolt+offset*2,thickness+f*2],center=true);
	}
	circle(r=boltWidth2/2);
}
/////////////// utils ///////////////
module wood(alpha=1)
{
	h = thickness;
	color("BurlyWood",alpha) linear_extrude(height=h,center=true) 
		for (i = [0 : $children-1]) child(i);
}
module complexRoundSquare(size,rads1, rads2, rads3, rads4)
{
	width = size[0];
	height = size[1];
	//square(size=[width, height],center=true);
	x1 = 0-width/2+rads1[0];
	y1 = 0-height/2+rads1[1];
	x2 = width/2-rads2[0];
	y2 = 0-height/2+rads2[1];
	x3 = width/2-rads3[0];
	y3 = height/2-rads3[1];
	x4 = 0-width/2+rads4[0];
	y4 = height/2-rads4[1];

	hull() {
		translate([x1,y1]) mirror([1,0]) 		ellipsePart(rads1[0]*2,rads1[1]*2,1);
		translate([x2,y2]) 						ellipsePart(rads2[0]*2,rads2[1]*2,1);	
		translate([x3,y3]) mirror([0,1]) 		ellipsePart(rads3[0]*2,rads3[1]*2,1);
		translate([x4,y4]) rotate([0,0,-180]) 	ellipsePart(rads4[0]*2,rads4[1]*2,1);
	}
}
// a part (amount of quarters) of a ellipsis) 
module ellipsePart(width,height,numQuarters)
{
	difference()
	{
		ellipse(width,height);
		if(numQuarters <= 3)
			translate([0-width/2-f,0-height/2-f,0]) square([width/2+f,height/2+f]);
		if(numQuarters <= 2)
			translate([0-width/2-f,-f,0]) square([width/2+f,height/2+f*2]);
		if(numQuarters < 2)
			translate([-f,0,0]) square([width/2+f*2,height/2+f]);
	}
}
module ellipse(width, height) {
  scale([1, height/width, 1]) circle(r=width/2);
}