/!OpenSCAD
/*
* 254 AluTube, 25.4mm=1" 
*	- based on the Aluminium profile with plastic joiners used for simple furniture construction
*
*/
o=25.4;			// o=one. One inch, the base unit.
o16=o/16;		// 1/16th. 1.5875mm
i=o-2*o16;		// i=inside. The base unit for the inside size of the extrusion.
il=o+3*o16;		// il=inside length. ie length of joiner that is inserted in tube.
dob=[o,o,o];	// defualt outside block. The solid outside part of the joiners etc.
dib=[i,i,il];	// default inside block, the bit inserted in tube.

*sqDemo();  // un*star for demo


//translate([-o,-o,0]) %cube([o,o,o]);  // reference for designing

/******************************************************
* Modules
******************************************************
*/

module sqDemo() {
	translate([-(o+il*2+5),0,0])
	sqPrint() {  // star*-out ALL but one shape.
		*sqEnd();
		*sqJoin90();
		*sqJoin180();
		*sqJoinT();
		*sqJoinX();
		sqJoin3();
		*sqJoin5();
		*sqJoin6();
	}

	// un-*star any shape you want to see, or star*-out to remove
	step=o*1.5;
	*translate([0,-o*2.5,0])
		sqTube(2*o);
	*translate([0,step,0])
	sqEnd();

	*translate([step,step*2,0])
	sqJoin90();

	*translate([-step,step*3,0])
	sqJoin180();

	*translate([step,step*4,0])
	sqJoinT();

	*translate([-step,step*5,0])
	sqJoinX();

	*translate([step,step*6,0])
	sqJoin3();

	*translate([-step,step*7,0])
	sqJoin4();

	*translate([step,step*8,0])
	sqJoin5();

	*translate([-step,step*9.5,0])
	sqJoin6();

}

module sqPrint() { 
/*
	split FIRST child into two halves and place cut face down for 3D-printing
	usage:	sqPrint() sq<type>();
	eg:		sqPrint() sqJoin3();
*/
	for (i= [-1,1]) 
		intersection() {
			translate([0,i*(o+il+5),-1*i*o/2])
				rotate([i*90,0,0])
					child(0);
			translate([-o*4,-il*4,0])
				cube([o*8,il*8,o*2]);
		} // i
}

module sqTube(length=100,outside=o,cutout=i) {
	difference() {
		translate([outside/2,outside/2,length/2])
			cube([outside,outside,length], center=true);
		translate([outside/2,outside/2,length/2])
			cube([cutout,cutout,length+1], center=true);
	} // d
} // m

module sqEnd(outblock=dob, inblock=dib) {
	translate([outblock[0]/2,outblock[1]/2,outblock[2]*0.5])
		union() {
			cube(outblock, center=true);
			translate([0,0,-(outblock[2]/2+inblock[2]/2)])
				cube(inblock, center=true);
		} // u
} // m

module sqJoin90(ob=dob,ib=dib) {	// 2 way corner joiner
	union() {
		sqEnd(ob,ib);
			translate([0,0,ob[2]])
			rotate([0,90,0])
				sqEnd(ob,ib);
	} // u
} // m

module sqJoin180(ob=dob,ib=dib) {	// 2 way inline joiner
	union() {
		sqEnd(ob,ib);
			translate([ob[0],0,ob[2]])
			rotate([0,180,0])
				sqEnd(ob,ib);
	} // u
} // m

module sqJoinT(ob=dob,ib=dib) {		// 3 way T shape
	union() {
		sqJoin180(ob,ib);
		sqJoin90(ob,ib);
	} // u
}

module sqJoinX(ob=dob,ib=dib) {		// 4 way flat ie cross X
	union() {
		sqJoin180(ob,ib);
		translate([ob[0],0,0])
			rotate([0,-90,0])
				sqJoin180(ob,ib);
	} // u
} // m

module sqJoin3(ob=dob,ib=dib) {		// 3 way cube corner
	union() {
		sqJoin90(ob,ib);
		translate([0,ob[1],0])
			rotate([90,0,0])
				sqEnd(ob,ib);
	} // u
} // m

module sqJoin4(ob=dob,ib=dib) {		// 4 way, T plus one more 90 Deg from the middle of the T
	union() {
		sqJoinT(ob,ib);
		translate([0,ob[1],0])
			rotate([90,0,0])
				sqEnd(ob,ib);
	} // u
} // m


module sqJoin5(ob=dob,ib=dib) {		// 5 way, X plus one 90 Deg from the middle of the X
	union() {
		sqJoinX(ob,ib);
		translate([0,ob[1],0])
			rotate([90,0,0])
				sqEnd(ob,ib);
	} // u
} // m

module sqJoin6(ob=dob,ib=dib) {		// 6 way all sides of the cube
	union() {
		sqJoinX(ob,ib);
		translate([0,ob[1],0])
			rotate([90,0,0])
				sqJoin180(ob,ib);
	} // u
} 
