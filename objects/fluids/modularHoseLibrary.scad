// ==========================================
//
//	Title:			Modular Hose Library
//	Version:		0.2
//	Last Updated:	21 June 2011
//	Author: 		Damian Axford
//	License: 		Attribution - Share Alike - Creative Commons
//	License URL: 	http://creativecommons.org/licenses/by-sa/3.0/
//	Thingiverse URL:	http://www.thingiverse.com/thing:9457
//
// ==========================================


// -----------------------------------------------------------------------------------
// Includes
// -----------------------------------------------------------------------------------

// boxes.scad required for roundedBox module
include <boxes.scad>

// -----------------------------------------------------------------------------------
// global variables
// -----------------------------------------------------------------------------------

definition = 32;   // used for $fn parameter when generating curved surfaces
tolerance = 0.2;  // distance between ball and socket surfaces

// fractions of an inch
i1 = 25.4;
i4 = 25.4/4;
i8 = 25.4/8;
i16 = 25.4/16;

// -----------------------------------------------------------------------------------
// Discrete elements, non-chainable
// -----------------------------------------------------------------------------------

module modularHoseBall(mhBore) {
	mhBallOD = mhBore*2;
	mhOffsetToBallCenter=0.61 * mhBore;
	mhOffsetToTopOfBall=1.07 * mhBore;
	mhWideBore=mhBore * 1.6;  // started at 1.32
	mhBallID = mhBore * 1.6;
	mhOffsetToInnerBallCenter = 0.75 * mhBore;

	difference() {
		union() {
			translate([0,0,mhOffsetToBallCenter]) sphere(r = mhBallOD/2, $fn = definition);
		}

		// Remove top of ball
		translate([0,0,mhOffsetToTopOfBall + mhBallOD/2]) cube(size = [mhBallOD,mhBallOD,mhBallOD], center=true);
	
		// Remove bottom of ball
		translate([0,0,-mhBallOD/2]) cube(size = [mhBallOD,mhBallOD,mhBallOD], center=true);

		// hollow out the ball
		translate([0,0,-0.01]) cylinder(h=mhOffsetToTopOfBall+0.02, r1=mhBore/2 ,r2=mhWideBore/2, $fn=definition);

		// hollow out some more with a stretched sphere
		translate([0,0,mhOffsetToInnerBallCenter]) scale([1,1,1.2]) sphere(r = mhBallID/2, $fn = definition);
	}
}

// -----------------------------------------------------------------------------------
// Discrete elements, chainable
// -----------------------------------------------------------------------------------

mhSocketHeightScaleFactor = 1.26 + 0.39;

module modularHoseSocket(mhBore) {
	mhOffsetToSocketCenter=0.31 * mhBore;
	mhOffsetToBaseOfSkirt = 0.39 * mhBore;
	mhSocketID = tolerance + mhBore * 2;
	mhSkirtOD = 2.40 * mhBore;    // started at 2.52
	mhSkirtHeight = 1.26*mhBore;   
	mhWaistOD = 1.58 * mhBore;
	mhRimRadius = 0.18 * mhBore;
	mhSocketChamferOffset = 0.79 * mhBore;
	mhSocketChamferHeight = 0.86 * mhBore;
	mhSocketChamferID = mhBore*1.77;

	union() {
		translate([0,0,mhSkirtHeight + mhOffsetToBaseOfSkirt]) child(0);
		difference() {
			union() {		
	
				// Skirt
				translate([0,0,mhOffsetToBaseOfSkirt]) cylinder(h=mhSkirtHeight, r1=mhSkirtOD/2, r2=mhWaistOD/2, $fn = definition);
		
				// Rim
				// Rim - collar
				translate([0,0,mhRimRadius]) cylinder(h = mhOffsetToBaseOfSkirt-mhRimRadius, r = mhSkirtOD/2, $fn = definition);
		
				// Rim - radius
				rotate_extrude(convexity = 10, $fn = definition) translate([(mhSkirtOD/2) - mhRimRadius, mhRimRadius, 0]) circle(r = mhRimRadius, $fn = definition/2);
			
				// Rim - cap
				cylinder(h= mhRimRadius, r=(mhSkirtOD/2) - mhRimRadius, $fn = definition);
			}
		
			// removeBore
			translate([0,0,-1]) cylinder(h=mhSkirtHeight + mhOffsetToBaseOfSkirt + 2,r=mhBore/2, $fn=definition);
		
			// straighten socket sides
			translate([0,0,mhSocketChamferOffset]) cylinder(h=mhSocketChamferHeight,r1=mhSocketChamferID/2,r2=mhBore/2, $fn=definition);
		
			// remove socket		
			translate([0,0,mhOffsetToSocketCenter]) sphere(r = mhSocketID/2, $fn = definition);
		}
	}
}

module modularHoseWaist(mhBore, mhWaistHeight) {

	mhWaistOD = 1.58 * mhBore;

	union() {
		translate([0,0,mhWaistHeight]) child(0);
		difference() {
			translate([0,0,-0.01]) cylinder(h= mhWaistHeight + 0.02, r=mhWaistOD/2, $fn = definition);
				
			// removeBore
			translate([0,0,-1]) cylinder(h=mhWaistHeight+2,r=mhBore/2, $fn=definition);
		}
	}
}

module modularHoseRoundNozzleTip(mhBore, mhNozzleID) {

	mhWaistOD = 1.58 * mhBore;
	mhNozzleHeight = 2 * mhBore;
	mhNozzleOD = mhNozzleID + 1.2;

	difference() {
		union() {
			translate([0,0,mhNozzleHeight]) child(0);

			cylinder(h= mhNozzleHeight, r1=mhWaistOD/2, r2=mhNozzleOD/2, $fn = definition);
		}
	
		// removeBore
		translate([0,0,-0.01]) cylinder(h=mhNozzleHeight+0.02,r1=mhBore/2, r2=mhNozzleID/2, $fn=definition);
	}

}

module modularHoseFlareNozzleTip(mhBore, mhNozzleWidth,mhNozzleThickness) {

	mhWaistOD = 1.58 * mhBore;
	mhNozzleHeight = 2 * mhBore;

	difference() {
		union() {
			translate([0,0,mhNozzleHeight]) child(0);

			cylinder(h= mhNozzleHeight, r1=mhWaistOD/2, r2=mhNozzleWidth/2, $fn = definition);
		}
	
		// removeBore
		translate([0,0,-0.01]) cylinder(h=mhNozzleHeight+0.02,r1=mhBore/2, r2=mhNozzleThickness/2, $fn=definition);
	}

}

// -----------------------------------------------------------------------------------
// Composite elements, non-chainable
// -----------------------------------------------------------------------------------

module modularHoseSegment(mhBore) {
	modularHoseSocket(mhBore) modularHoseWaist(mhBore, 0.24 *mhBore) modularHoseBall(mhBore);
}

module modularHoseExtendedSegment(mhBore, mhWaistHeight) {
	modularHoseSocket(mhBore) modularHoseWaist(mhBore, mhWaistHeight) modularHoseBall(mhBore);
}

module modularHoseRoundNozzle(mhBore,mhNozzleID) {
	modularHoseSocket(mhBore) modularHoseRoundNozzleTip(mhBore, mhNozzleID);
}

module modularHoseFlareNozzle(mhBore,mhNozzleWidth,mhNozzleThickness) {
	modularHoseSocket(mhBore) modularHoseFlareNozzleTip(mhBore, mhNozzleWidth, mhNozzleThickness);
}

module modularHoseBasePlate(mhBore, mhThreadDia=3) {
	mhWaistOD = 1.58 * mhBore;
	mhPlateHeight = 0.5 * mhBore;
	mhPlateWidth = mhWaistOD + 4*mhThreadDia;
	mhScrewOffset=mhWaistOD/2 + mhThreadDia/2;

	union() {
		translate([0,0,1 + mhPlateHeight*2]) modularHoseBall(mhBore);
		translate([0,0,1]) modularHoseWaist(mhBore, mhPlateHeight*2);
		difference() {
			translate([0,0,mhPlateHeight/2]) roundedBox([mhPlateWidth,mhPlateWidth,mhPlateHeight], radius=2*mhThreadDia, sidesonly=true, $fn=definition);
			
			// remove central bore (perhaps to feed cables through?)
			translate([0,0,-0.01]) cylinder(h=mhPlateHeight+0.02,r=mhBore/2, $fn=definition);
			
	
			// remove screw holes
			for ( x = [-1, 1]) {
				for ( y = [-1, 1]) {
					translate([x * mhScrewOffset,y * mhScrewOffset,-1]) 
      						cylinder(h=mhPlateHeight+2,r=mhThreadDia/2, $fn=12);
				}
			}
		}
	}
}

module modularHoseDoubleSocket(mhBore) {
	union() {
		modularHoseSocket(mhBore);
		translate([0,0,mhSocketHeightScaleFactor * mhBore]) translate([0,0,mhSocketHeightScaleFactor * mhBore]) mirror([0,0,1]) modularHoseSocket(mhBore);
	}
}

// -----------------------------------------------------------------------------------
//   Debug code - shows a cross section through two "joined" hose segments with a 1mm "ruler" overlay
// -----------------------------------------------------------------------------------

if (false) {
	// top segment
	difference() {	
		translate([0,0,13.9]) modularHoseSegment(i4);
		translate([-10,0,-1]) cube(size=[20,20,100]);
	}	
	
	// bottom segment
	difference() {	
		modularHoseSegment(i4);	
		translate([-10,0,-1]) cube(size=[20,20,20]);
	}
	
	
	// Show a ruler
	for (i= [-10 : 10]) {
		translate([i - 0.05,0,0]) rotate([90,0,0]) color([0.9,0.9,0.9,1]) square(size=[0.1,20]);
	}
}


// -----------------------------------------------------------------------------------
//   Example usage of Composite elements
// -----------------------------------------------------------------------------------

module evenlySpaceX(spacing) {
  
	for (i = [0 : $children-1])
    		translate([i * spacing , 0, 0 ]) child(i);
}

// pass "false" to if statement to hide example elements
if (true) {
	translate([0,0,0]) evenlySpaceX(25) {
		modularHoseRoundNozzle(i4, i4);
		modularHoseRoundNozzle(i4, i8);
		modularHoseRoundNozzle(i4, i16);
	}
	
	translate([0,25,0]) evenlySpaceX(25) {
		modularHoseSegment(i4);
		modularHoseExtendedSegment(i4,20);
		
		modularHoseBasePlate(i4);

		modularHoseDoubleSocket(i4);
	}
} else {
	// uncomment the following lines and use to quickly generate STL

	//modularHoseRoundNozzle(i4, i8);
	modularHoseSegment(i4);
	//modularHoseBasePlate(i4);
	//modularHoseDoubleSocket(i4);

	//modularHoseFlareNozzle(i4, i1, i16);
}