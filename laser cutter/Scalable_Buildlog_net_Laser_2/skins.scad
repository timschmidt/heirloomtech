

//
// Use this to prerender a set of tube slots for the back panel, so you can load them as dxf. 
// Rendering these slots in combination with other geometry just kills opencsg, 
// though CGAL didn't have a problem with them.
// Save the CGAL-rendered slot set as "prerendered_tube_slots.dxf", since that's what the 
// code in skin_back() below expects.
// Just do this once any time you need to update just these slots, then comment out again.
 prerender_cable_notches_space=30;
 !for (i=[0:2]) {translate([i*prerender_cable_notches_space,0,0]) cable_slot();}



//skin_front();
//skin_back();
//skin_side();
//skin_top_back();
//skin_top_right();
//skin_top_left();
//skin_bottom();

module skin_front(S_L=998,S_H=308) { // based on c51004_1.dxf
	S_SL=S_L-248-18; //figure size of span under lid cutout, so we can set up vent slots there
	vent_strip_offset=[18+32,S_H - 20 - 86]; // lower left corner of vent area
	vent_width  = 4;           // each vent slot
	vent_height = 60;          //
	vent_space  = 30;          // space between slot centers
	vent_span   = S_SL-(32+40);// whole span to be filled with multiple slots
	interface_pocket_width=170;
	interface_pocket_height=65;
	interface_center=[S_L-129,S_H-63];
	interface_mount_holes=[
		[interface_center[0]-50,interface_center[1]+interface_pocket_height/2+5],
		[interface_center[0]+50,interface_center[1]+interface_pocket_height/2+5],
		[interface_center[0]+50,interface_center[1]-interface_pocket_height/2-5],
		[interface_center[0]-50,interface_center[1]-interface_pocket_height/2-5],
		];
	panel_mount_holes=[
		[99      , 9],
		[S_L/2   , 9],
		[S_L-99  , 9],
		[S_L-9   , S_H/2],
		[S_L-50  , S_H-9],
		[S_L-198 , S_H-9],
		[18 + S_SL - S_SL*(200/732) , S_H - 20 - 9],
		[18        + S_SL*(200/732) , S_H - 20 - 9],
		[9       , S_H-9],
		[9       , S_H/2]
		];
	
	// now, set up a panel area, and then difference out all the drill holes, slots and pockets
	difference() {
		// front panel area
		difference(){square([S_L,S_H]);translate([18,S_H-20]) square([S_SL,20]);}
		// drill
		drill(5,panel_mount_holes);
		drill(5,interface_mount_holes);
		// route pockets
		pocket([interface_center]) roundedSquare(interface_pocket_width,interface_pocket_height,10,center=true);
		pocket([vent_strip_offset]) roundedSlotSet( vent_span , vent_space , vent_width , vent_height);
		}
	}

module skin_back(S_L=998,S_H=308) { // based on c51004_2.dxf
	S_SL=S_L-248-18; // this time we'll use this to place the air vent hole
	pmsw=5.04;
	panel_mount_slots=[
		[120-pmsw/2         , 5 , 0],
		[S_L/2,5,0],
		[S_L - (120+pmsw/2) , 5 , 0],
		[S_L-5,S_H/2,90],
		[S_L - (120+pmsw/2) , S_H-5 , 180],
		[S_L/2,S_H-5,180],
		[120-pmsw/2         , S_H-5 , 180],
		[5,S_H/2,-90],
		];
	cable_notches_offset=260;
	cable_notches_space=30;
	airvent_center=[S_L - (18+S_SL/2),90,0];
	airvent_radius=2*25.4;
	back_interface_hole_width=187;
	back_interface_hole_height=115;
	back_interface_hole_center=[121.5,83.5,0];
	difference() {
		// back panel area
		square([S_L,S_H]);
		translate([(cable_notches_offset),0,0]) {import_dxf(file="prerendered_tube_slots.dxf", layer="0");}

		pocket([airvent_center]) circle(airvent_radius);
		pocket([airvent_center]) rotate(30) roundedSlotCircleSet(360,60,5.2,12,airvent_radius+8.7);
		pocket([back_interface_hole_center]) roundedSquare(back_interface_hole_width,back_interface_hole_height,12.5,center=true);

		pocket(panel_mount_slots) translate([-5.04/2,0,0]) roundedSlot(5.04,8);
		//drill
		drill(5,[[back_interface_hole_center[0]+6.5,back_interface_hole_center[1]+back_interface_hole_height/2+5]]);
		}
	}

module skin_side(S_W=598,S_H=308) {
	panel_mount_slots=[
		[100          , 5         ,  0],
		[S_W - 100    , 5         ,  0],
		[S_W - 5      , S_H/2     , 90],
		[S_W - 100    , S_H - 5   ,180],
		[100          , S_H - 5   ,  180],
		[5            , S_H/2     ,-90],
		];
	difference() {
		square([S_W,S_H]);
		pocket(panel_mount_slots) translate([-5.01/2,0,0]) roundedSlot(5.01,8);
		}
	}

module skin_top_back(S_L=998) {
	S_SL=S_L-248-18; //
	hinge_slot_pair_center_x_from_edge=round(10*S_SL*(144.5/730))/10;//or so

	hinge_slots=[
		[(19+hinge_slot_pair_center_x_from_edge) - 25/2          , 0         ,  0],
		[(19+hinge_slot_pair_center_x_from_edge) + 25/2          , 0         ,  0],
		[(19+S_SL) - hinge_slot_pair_center_x_from_edge - 25/2   , 0         ,  0],
		[(19+S_SL) - hinge_slot_pair_center_x_from_edge + 25/2   , 0         ,  0],
		];
	panel_mount_holes=[
		[(19+hinge_slot_pair_center_x_from_edge)             , 118 - 9 ],
		[(19+S_SL) - hinge_slot_pair_center_x_from_edge + 9  , 118 - 9 ],
		];
	difference() {
		square([19+S_SL,118]);
		drill(5,panel_mount_holes);
		pocket(hinge_slots) translate([-6/2,-4,0]) roundedSlot(6,12+4);
		}
	}

module skin_top_right(S_W=598) {
	panel_mount_holes=[
		[100      , 248 - 9 ],
		[100      , 9       ],
		[S_W-100  , 9       ],
		[S_W-100  , 248 - 9 ],
		];
	difference() {
		square([S_W,248]);
		drill(5,panel_mount_holes);
		}
	}
module skin_top_left(S_W=598) {
	L=S_W-(598-479);
	panel_mount_holes=[
		[9     , 9 ],
		[L/2,  , 9 ],
		[L - 9 , 9 ],
		];
	difference() {
		square([L,18]);
		drill(5,panel_mount_holes);
		}
	}

module skin_bottom(S_L=998,S_W=598) {
	L=S_W-(598-479);
	S_SL=S_L-248-18;
	S_SL_reference=998-248-18;
	cab_guide_ystart =L*(180/479);
	cab_guide_ystart2=L*(318/479);
	foot_holes=[
		[      9,       9 ],
		[S_L - 9,       9 ],
		[S_L - 9, S_W - 9 ],
		[      9, S_W - 9 ],
		];
	cable_guide_holes=[
		[S_L - 286 , cab_guide_ystart      ],
		[S_L - 286 , cab_guide_ystart  - 8 ],
		[S_L - 286 , cab_guide_ystart2     ],
		[S_L - 286 , cab_guide_ystart2 - 8 ],
		];
	panel_mount_slots=[
		[120,5,0],
		[S_L/2,5,0],
		[S_L-120,5,0],
		[S_L-5,80,90],
		[S_L-5,S_W/2,90],
		[S_L-5,S_W-80,90],
		[S_L-120,S_W-5,180],
		[S_L/2,S_W-5,180],
		[120,S_W-5,180],
		[5,S_W-80,-90],
		[5,S_W/2,-90],
		[5,80,-90],
		[S_L-235,S_W/2,90],
		[18 + S_SL*((400-18)/S_SL_reference),S_W-105,180], // hopefully

		];
	difference() {
		square([S_L,S_W]);
		drill(7,foot_holes);
		drill(3.1749492,cable_guide_holes);
		pocket(panel_mount_slots) translate([-5.1/2,0,0]) roundedSlot(5.1,8);
		}
	}




module drill(d,dl) {for(i=dl) {
	//echo(str("drill ",(d)," ",i));
	translate(i) circle(d/2);}
	}
module pocket(o=[[0,0,0]]) {
	for ( i = [ 0 : $children-1 ] ) {
		//echo(str("pocket",(($children>1)?str(" ",(j+1)," of ",$children," "):str(" ")), "at ",o));
		for (j=o) {
			translate([j[0],j[1]]) rotate (j[2]) child(i);
			}
		}
	}


module cable_slot() { // nice, but for some reason really hard on OpenCSG (no problem in CGAL render)
	                  // so use it to pre-render sets of these slots, then save as DXF, and import 
                      // those for integration with models
	blendnudge=0.06;
	union() {
		//translate([0,blendnudge]) 
		difference() {
			translate([-25/2,-2,0]) square([25,blendnudge+2+30-5.3666898]);
			translate([    7,0,0])  roundedSquare(16,blendnudge+16.8161462+10,5,$fn=43);
			translate([-16-7,0,0])  roundedSquare(16,blendnudge+16.8161462+10,5,$fn=43);
			}
		translate([0,30]) circle(9.525,$fn=48);
		}
	}
module roundedSlot(w=4,h=30) {
	$fn=20;
	union() {
		translate([w/2,w/2])   circle(r=w/2);
		translate([0,w/2])     square([w,h-w]);
		translate([w/2,h-w/2]) circle(r=w/2);
		}
	}
module roundedSlotSet(span,slot_spacing_base=30,slotwidth,slotheight) {
	number_of_slots = span/slot_spacing_base;
	rem = number_of_slots - floor(number_of_slots);
	slot_spacing=slot_spacing_base + slot_spacing_base * (rem/number_of_slots);
	for(i=[0:floor(number_of_slots)]) {translate([i*slot_spacing,0,0]) roundedSlot(slotwidth,slotheight);}
	}
module roundedSlotCircleSet(span,slot_spacing_base=30,slotwidth,slotheight,slotoffset) {
	number_of_slots = span/slot_spacing_base;
	rem = number_of_slots - floor(number_of_slots);
	slot_spacing=slot_spacing_base + slot_spacing_base * (rem/number_of_slots);
	for(i=[0:floor(number_of_slots)]) {rotate([0,0,i*slot_spacing]) translate([0,slotoffset,0]) roundedSlot(slotwidth,slotheight);}
	}
module roundedSquare(w,h,r,center=false) {
	coffx=(center)?-w/2:0;
	coffy=(center)?-h/2:0;
	union() {
		translate([coffx + 0  ,coffy + r]) square([w,h-2*r]);
		translate([coffx + r  ,coffy + 0]) square([w-2*r,h]);
		translate([coffx + r  ,coffy + r]) circle(r);
		translate([coffx + r  ,coffy + h-r]) circle(r);
		translate([coffx + w-r,coffy + h-r]) circle(r);
		translate([coffx + w-r,coffy + r]) circle(r);
		}
	}
