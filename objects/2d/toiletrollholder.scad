offset = 0.300; // for lasercutter beam width
materialThickness = 6;
totalWidth = 120;
totalHeight = 75;
totalDepth = 90;

wallConnectorWidth = 20;
wallConnectorHeight = 15;
wallConnectorInnerWidth = 10;
rodHeight = 8; //height of rod that goes from side to side
// rodStoppers (go trough the rod, preventing it to move to sides)
rodStopperHeight = 15;
rodStopperWidth = 3;
screwHoleWidth = 4;
percStraight = 0.20;
percRound = 1-percStraight;
holderGapDepth = totalHeight*0.53; //distance from top of sidePanel to bottom of gap
holderGapRightDis = 7.6; //distance from right side to with of sidePanel
disAboveWallConnector = materialThickness;

toiletRollRadius = 120/2;
toiletRollInnerRadius = 40/2;
toiletRollHeigth = 97;

f = 1; // fix for overlapping edges issue
c = 100; //cornerResolution ($fn)
s = 0.5;//2; //seperator dis. Makes sure that shapes inside shapes don't unite stay seperate

wallConnectorHoleWidth = wallConnectorWidth-offset*2+s;
wallConnectorHoleHeight = wallConnectorHeight-offset*2+s;
wallConnectorX = wallConnectorHoleWidth/2+materialThickness+1;
wallConnectorY = totalHeight/2-disAboveWallConnector-wallConnectorHeight/2;

include <./MCAD/regular_shapes.scad>

//assembly3D();
export();

module export()
{
	translate([totalDepth-totalWidth/2,0,0]) rod(offset);
	translate([totalDepth,totalHeight/2+rodHeight+offset+s,0])
	{
		mirrored(s)
		{
			difference()
			{
				sidePanel(offset,export=true);
				translate([totalDepth*0.525,0,0]) toiletRollCircle(offset);
			}
			translate([wallConnectorX,wallConnectorY,0]) wallConnector(offset,s);
			translate([wallConnectorX,0-wallConnectorY,0]) wallConnector(offset,s);
		}
	}
}

module assembly3D()
{
	s=0;
	rodX = totalDepth-holderGapRightDis-materialThickness+materialThickness/2;
	rodZ = totalHeight/2-holderGapDepth+rodHeight/2;
	sideY = totalWidth/2-materialThickness/2;
	wallConnectorZ = wallConnectorY;
	translate([0,sideY,0]) rotate([90,0,0]) wood() sidePanel();
	translate([0,0-sideY,0]) rotate([90,0,0]) wood() sidePanel();
	translate([rodX,0-totalWidth/2,rodZ-rodHeight/2]) rotate([90,0,90]) wood(0.5) rod();

	translate([rodX,totalWidth*0.25,rodZ]) rotate([90,0,0]) wood() toiletRollCircle();
	translate([rodX,0-totalWidth*0.25,rodZ]) rotate([90,0,0]) wood() toiletRollCircle();
	
	%translate([rodX,toiletRollHeigth/2,rodZ]) rotate([90,0,0]) toiletRoll();
	
	// wall connectors
	translate([materialThickness/2,sideY,wallConnectorZ]) rotate([0,90,0]) wood() wallConnector();
	translate([materialThickness/2,sideY,0-wallConnectorZ]) rotate([0,90,0]) wood() wallConnector();
	translate([materialThickness/2,0-sideY,wallConnectorZ]) rotate([0,90,0]) wood() wallConnector();
	translate([materialThickness/2,0-sideY,0-wallConnectorZ]) rotate([0,90,0]) wood() wallConnector();

	//rodStoppers
	rodStopperX = rodX-rodStopperHeight/2;
	translate([rodStopperX,sideY-materialThickness,rodZ-rodStopperWidth/2]) rotate([90,0,0]) wood() rodStopper();
	translate([rodStopperX,0-sideY+materialThickness,rodZ-rodStopperWidth/2]) rotate([90,0,0]) wood() rodStopper();
}


module sidePanel(offset=0,export=false)
{
	difference()
	{
		union()
		{
			translate([0,-totalHeight/2-offset,0]) square([totalDepth*percStraight+f+offset,totalHeight+offset*2]);
			translate([totalDepth*percStraight,0,0])
			{
				intersection()
				{
					ellipse(totalDepth*percRound*2+offset,totalHeight+offset*2,$fn=c);
					translate([totalDepth*percRound/2,0,0]) square([totalDepth*percRound+offset,totalHeight+offset*2],center=true);
				}
			}
		}
		// Holder gap
		translate(	[totalDepth-holderGapRightDis-materialThickness+offset,
					totalHeight/2-holderGapDepth+offset,
					0]) square([materialThickness-offset*2,holderGapDepth]);
		if(!export)
		{		
			// Toilet roll circle
			translate([totalDepth*0.525,0,0]) circle(r=toiletRollInnerRadius-offset,$fn=c);
		}
		
		// Wall connector holes
		//totalDepth*0.2
		//0-totalHeight/2+disAboveWallConnector+wallConnectorHeight/2
		translate([wallConnectorX,wallConnectorY,0]) 
			ellipse(wallConnectorHoleWidth,wallConnectorHoleHeight,$fn=c);
		translate([wallConnectorX,0-wallConnectorY,0]) 
			ellipse(wallConnectorHoleWidth,wallConnectorHoleHeight,$fn=c);
		// Wall connector gaps
		translate([0,wallConnectorY-wallConnectorInnerWidth/2,0]) wallConnectorGap(offset);
		translate([0,wallConnectorY*-1-wallConnectorInnerWidth/2,0]) wallConnectorGap(offset);
	}
}
module toiletRollCircle(offset=0)
{
	difference()
	{
		circle(r=toiletRollInnerRadius+offset-s,$fn=c);
		//rod
		square([materialThickness-offset,rodHeight-offset],center=true);

		translate([0-rodStopperHeight/2,toiletRollInnerRadius*0.45,0])
			rodStopper(offset);
	}
}

module wallConnector(offset=0)
{
	width = wallConnectorWidth+offset-s;
	height = wallConnectorHeight+offset-s;
	innerWidth = wallConnectorInnerWidth+offset;
	gapWidth = (width-innerWidth)/2+f;
	difference()
	{
		ellipse(width,height,$fn=c);
		circle(r=screwHoleWidth/2-offset/2,$fn=c);

		translate([0-width/2-f,0-materialThickness/2,0]) 
			square([gapWidth,materialThickness],center=false);
		translate([width/2-gapWidth+f,0-materialThickness/2,0]) 
			square([gapWidth,materialThickness],center=false);
	}
}
module wallConnectorGap(offset=0)
{
	part2X = 0;
	part2Y = wallConnectorInnerWidth/2-screwHoleWidth/2+offset;
	union()
	{
		translate([-f,offset,0]) 
			square([materialThickness+f-offset,wallConnectorInnerWidth-offset*2]);
		//translate([part2X,part2Y,0]) 
			//square([materialThickness+f-offset,screwHoleWidth-offset*2]);
		translate([part2X,part2Y,0]) 
			square([wallConnectorX+f,screwHoleWidth-offset*2]);

	}
}
module rod(offset=0)
{
	width = totalWidth+offset;
	height = rodHeight+offset;
	stopperHoleWidth = materialThickness-offset;
	stopperHoleHeight = rodStopperWidth-offset;

	// because it's about the rodStopper is inside the following hole, we add the offset. 
	//stopperWidth = rodStopperWidth+offset;
	//stopperHeight = rodStopperHeight+offset;
	
	difference()
	{
		square([width,height]);
		// Holes are mirrored. 
		// The right part is designed, mirrored to the left 
		// and then moved to center of rod
		translate([width/2,0,0])
		{
			mirrored()
			{	
				//translate([width*0.1, height/2-stopperWidth/2]) 
				//	square([stopperHeight,stopperWidth]); 
				translate([width/2-materialThickness-stopperHoleWidth,height/2-stopperHoleHeight/2]) 
					square([stopperHoleWidth,stopperHoleHeight]);
			}
		}
	}
}
module rodStopper(offset=0)
{
	// because it's about the rodStopper is inside the following hole, we add the offset. 
	square([rodStopperHeight+offset,rodStopperWidth+offset]);
}

/////////////// utils ///////////////
module wood(alpha=1)
{
	h = materialThickness;
	color("BurlyWood",alpha) linear_extrude(height=h,convexity=c,center=true) for (i = [0 : $children-1]) child(i);
}
module mirrored(offset=0)
{
	translate([ offset/2, 0, 0]) for (i = [0 : $children-1]) child(i);
	translate([-offset/2, 0, 0]) scale([-1,1,1]) for (i = [0 : $children-1]) child(i);
}
module toiletRoll() {
	color("White")
	{
		difference() {
			cylinder(h = toiletRollHeigth, r=toiletRollRadius,$fn=c);
			translate([0,0,-f]) cylinder(h = toiletRollHeigth+f*2, r=toiletRollInnerRadius,$fn=c);
		}
	}	
}