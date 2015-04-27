/*
@brief Generic Electronic Device Packaging for Tyndall version 2
@details This OpenSCAD script will generate a 2 part fit together packaging.

This starts with the user entering some basic values:
	1. Dimensions of the object to be packaged in XYZ (device_xyz, [x,y,z])
	2. Size of the gap between each side of the object and the internal wall of the packaging (clearance_xyz, [x,y,z])
	3. How thick the material of the packaging is (wall_t)
	4. The external radius of the rounded corners of the packaging (corner_radius)
	5. How many sides do these rounded corners have? (corner_sides, 3 to 10 are good for most items, 1 will give you chamfered edges)
	6. How high is the lip that connects the 2 halves? (lip_h, 1.5 to 3 are good for most applications)
	7. How tall is the top relative to the bottom? (top_bottom_ratio, 0.1 to 0.9, 0.5 will give you 2 halves of equal height)
	8. Does the part have mouse ears or not? (has_mouseears, true or false)
	9. How thick the flat discs that make the mosue ears should be (mouse_ear_thickness, twice print layer thickness is a good idea)
	10. How large the flat discs that make the mouse ears are (mouse_ear_radius, 5 to 15 generally work well)
	11. What parts you want and how they are laid out (layout, [beside, stacked, top, bottom])
	12. How far apart the 2 halves are in the "beside" layout (separation, 2 is good)
	13. How much of an overlap (-ve) or gap (+ve) is there between the inner and outer lip surfaces (lip_fit, a value of 0 implies they meet perfectly in the middle, this will depend on your material printer etc. so you will likely need to play around with this variable)

Next the user can modify the data structures that create holes, posts and text on each face of the packaging. These are complicated and may require you te play around with values or read some of the comments further down in the code
	1. The cutouts and depressions used on the packaging (holes=[[]])
		format for each hole [face_name, shape_name, shape_position[x_pos,y_pos,x_offs,y_offs,rotate,align], shape_size[depth,,,]]
	2. The internal supporting structures used on the packaging (posts=[[]])
		format for each post [face_name, shape_name shape_position[x_pos,y_pos,x_offs,y_offs,rotate,align], shape_size[depth,,,]]
	3. The engraved text used on the packaging (text=[[]])
		format for each piece of text [face_name, text_to_write, shape_position[x_pos,y_pos,x_offs,y_offs,rotate,align], shape_size[depth,font_height,font_spacing,mirror]] Note: for silly reasons mirror must be 0 or 1 corresponding to false and true in this version
	
	Which of the 6 sides of the packaging do you want this feature on? (face_name, T,B,N,E,W,S)
		"T", The Top or Z+ face
		"B", The Bottom or Z- face
		"N", the North or Y+ face
		"E", the East or X+ face
		"W", the West or X- face
		"S", the South or Y- Face
	Where on the face do you want this feature (shape_position [x_pos,y_pos,x_offs,y_offs,rotate,align] )
		x_pos, how far along the face do you move in X
		y_pos, how far along the face do you move in Y
		x_offs, where along the face do you take measurements from in X
		y_offs, where along the face do you take measurements from in Y
		rotate, how much do you want the object rotated in degrees
			if you do not use any of the above please set them to 0! do not just leave them empty!
		align, do you want the object aligned with the "inside" or the "outside" of the packaging face
		
	What shape do you want? (shape_name, Cone/Ellipse/Cylinder/Round_Rect/Square/Rectangle/Nub_Post/Dip_Post/Hollow_Cylinder)
	What are the shape's dimensions (shape_size[depth,,,])...you will need to read the section below as they are different for each shape
		"Square" shape_size[depth, length_breadth]
		"Rectangle" shape_size[depth, length, breadth]
		"Round_Rect" shape_size[depth, length, breadth, corner_radius, corner_sides]
		"Cylinder" shape_size[depth, radius ,sides]
		"Ellipse" shape_size[depth, radius_length, radius_breadth, sides]
		"Cone" shape_size[depth, radius_bottom, radius_top ,sides]
		"Nub_Post" shape_size[depth, radius_bottom, radius_top, depth_nub, sides]
		"Dip_Post" shape_size[depth, radius_bottom, radius_top, depth_dip, sides]
		"Hollow_Cylinder" shape_size[depth, radius_outside, radius_inside ,sides]
	A string of text you want to have carved into a face (text_to_write)
		for text shape_size[depth,font_height,font_spacing,mirror]

Once the user has provided this data the shape is made as follows:
	1. Calculate external size of packaging based on "device_xyz", "clearance_xyz" & "wall_t"
	2. Create Hollow cuboidal shape by differencing a slightly smaller one from a slightly larger one
	3. From "posts" create internal support structures and union that with the previous shape
	4. From "holes" create shapes on each face and difference that from the previous shape
	5. From "text" create letters on each face and difference that from the previous shape
	6. Using the packaging height, "lip_h", "top_bottom_ratio" & "lip_fit" split teh previous shape into a top and bottom half
	7. Using layout & separation arrange the parts as specified by the user
	8. Using layout, mouse_ears, mouse_ear_thickness & mouse_ear_radius union the mouse ears to the previous shapes correctly
	9. Done!



Author Mark Gaffney
Version 2.6e
Date 2013-04-08

@ToDo:
fix internal radii no-of-sides when using chamfered package to maintain wall thickness

Warning:
	Some combinations of values, shapes and locations etc. may lead to an invalid or non-manifold shape beign created, preventing you from exporting a .stl
	If this happens try to remove or change some of the features or values until you get a valid shape and then add them back gradually until you find the offending item, then change it so it doesn't cause a problem
	
	Note: This thing uses  HarlanDMii's"write.scad" module http://www.thingiverse.com/thing:16193
	which you will need to have downloaded and located in the directory if you want to run this on your PC
	
	Generating text can be very slow!
	
	When generating a stacked layout it may look like the top is taller than it should be, this seems to be a visualisation bug in OpenSCAD, if you create a .STL it will be perfect

@note
WIMUv3a variant 1
	This variant is use to make a production packaging for WIMUv3a

Changes from previous versions:
v2.6f
 - 	modified tolerances from 0.2-0.35 on advice from i.materialise as minimum tolerance is 0.3mm
 - 	added simple interlocking feature on centre of lips
 - 	made corners more rounded (moved from 3 facets to 9)
v2.6e
 - 	modified text especially size and depth for i.materialise order 0.4-0.5mm wide and deep
 - 	ensure model is output as 2 separate stl files with 1 part each!
v2.6d
 - 	Implemented flanges on bottom half based on belt_holder_v3.1.scad
v2.6c
 - 	Implemented ability to choose box shape i.e. "cuboid","rounded4sides", "rounded6sides", "chamfered6sides"
 - 	Ensured "box_type" module is used in generation of each box_half
v2.6b
 - 	investigated and fixed some top lip mis alignment
 - 	added wimuv3 stack as imported .stl
v2.6
 - 	implements loading external objects (such as .stl files) to place on faces
 - 	implemented overlooked translation of text on faces from previous version
 - 	fixed box_t in make_cutouts
 - 	Note: Top lip seems to be malformed lip_h is 0.5 less than it should be
v2.5 (AKA cutouts_on_faces_for_loop-v0_2.scad)
 - 	Implement tolerancing of connection between 2 halves using lip_fit
 - 	implement text on faces
 - 	Complete documentation
v2.4 (AKA cutouts_on_faces_for_loop-v0_4.scad)
 - 	user provides device dimensions and internal clearance(s), packaging dimensions are calculated based on this
 - 	preparations to allow for different wall_t in x,y,z
 - 	implement posts
 - 	mouse ears work properly
 - 	2 halves in "beside" layout joined by union

v2.3 2013-03-23 (AKA cutouts_on_faces_for_loop-v0_3.scad)
 - 	fixed calls to make_box and half_box modules
 - 	added ability to handle "holes" array for making cutouts to make_box and half_box modules
 - 	added module for rounded cuboid
 - 	fixed errors on rounded cuboid cutouts's use of a_bit
 - 	fixed translate errors for making lips on box
 - 	ensured all parts generate on z=0
 - 	gave top (greenish) and bottom (reddish) different colours for ease of identification
 - 	rotated top in "beside" layout to more intuitive orientation
 - 	added box cross module and included in hull calculations to ensure box sizes are exact even with low side count
 - 	added box_type module to allow choice of different shaped boxes or automatically swap them based on the current variables
 - 	added mouse_ears module
 Note: In stacked mode you may notice the red half looks like it is the full length, this appears to be a visualisation bug in openscad, the part is generated correctly

v2.2 2013-03-22 (AKA cutouts_on_faces_for_loop-v0_2.scad)
based on My own structure
 - 	New format [face_name, shape_name, shape_position[x_pos,y_pos,x_offs,y_offs,rotate,align], shape_size[depth,,,]]
 - 	 - 	face_name ("N", "S", "E", "W", "T", "B")
 - 	 - 	shape_name ("Square", "Rectangle" , "Round_Rect", "Cylinder", "Ellipse" , "Cone")
 - 	 - 	shape_position[x_pos,y_pos,x_offs,y_offs,rotate,align=("inside" or "outside")]
 - 	 - 	 - 	"Square" shape_size[depth, length_breadth]
 - 	 - 	 - 	"Rectangle" shape_size[depth, length, breadth]
 - 	 - 	 - 	"Round_Rect" shape_size[depth, length, breadth, corner_radius, corner_sides]
 - 	 - 	 - 	"Cylinder" shape_size[depth, radius ,sides]
 - 	 - 	 - 	"Ellipse" shape_size[depth, radius_length, radius_breadth, sides]
 - 	 - 	 - 	"Cone" shape_size[[depth, radius_bottom, radius_top ,sides]

 - 	pos_x and pos_y are chosen to align with views taken from the North, Top or East faces towards the origin so that they are aligned with [-x,+z], [+x,+y] & [+y,+z] respectively
 - 	rotation is clockwise about the plane of the North, Top or East faces as lookign towards the origin this means they are anticlockwise for the opposite faces(i.e. same convention as above)
 - 	these 2 conventiosn are chosen to make it easier to position cutouts that align with oppsite sides. e.g. a box that fits around a rotated ellipse pipe
	
v2.1 2013-03-22 (AKA cutouts_on_faces_for_loop-v0_1.scad)
 - based on kitlaan's array structure, supporting cones and rectangles
 - from kitlaan's Customisable Electronic Device Packaging http://www.thingiverse.com/thing:8607
 - 	 - 	rect [ x-offset, y-offset, x-width, y-width, corner-radius, corner-sides, depth, rotate ]
 - 	 - 	cylinder [ x-offset, y-offset, inner-radius, outer-radius, sides, depth, rotate ]

 @attention
Copyright (c) 2013 Tyndall National Institute.
All rights reserved.
Permission to use, copy, modify, and distribute this software and its documentation for any purpose, without fee, and without written agreement is hereby granted, provided that the above copyright notice and the following two paragraphs appear in all copies of this software. 

IN NO EVENT SHALL TYNDALL NATIONAL INSTITUTE BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF TYNDALL NATIONAL INSTITUTE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

TYNDALL NATIONAL INSTITUTE SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND TYNDALL NATIONAL INSTITUTE HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

*/

/* [User Controls] */
//dimensions of the object to be packaged
device_xyz=[27,40,9.23];//
//size of the gap between each side of the object and the internal wall of the packaging
clearance_xyz=[0.5,0.5,0.5];//
//how thick the material of the packaging in each direction//recommend keeping X&Y value the same
//wall_thickness_xyz=[2,2,1];//not yet implemented!!!

//how thick the material of the packaging
wall_t=3;//thickness//actual most recent version has a base thickness of 2 but that is not yet fully implemented in this code

//The external radius of the rounded corners of the packaging
corner_radius=2;

//How many sides do these rounded corners have?
corner_sides=9;

//How high is the lip that connects the 2 halves?
lip_h=2;

//How tall is the top relative to the bottom
top_bottom_ratio=0.5;

//Does the part have mouse ears or not?
has_mouseears=false;//[true, false]

//how thick the flat discs that make the mosue ears should be (twice print layer thickness is a good idea)
mouse_ear_thickness=0.32*2;

//how large the flat discs that make the mouse ears are (5 to 15 generally work well)
mouse_ear_radius=10;

//the layout of the parts
layout="bottom";//[beside, stacked, top, bottom]

//how far apart the 2 halves are in the "beside" layout
separation=7;//2;

//how much of an overlap (-ve) or gap (+ve) is there between the inner and outer lip surfaces, a value of 0 implies they meet perfectly in the middle
lip_fit=0.35;

//does it have an imported representaion of the actual device to be packaged?
has_device=false;//true/false

//what style of box is it
box_type="rounded6sides";//"rounded4sides";//"cuboid","rounded4sides", "rounded6sides", "chamfered6sides"

//data structure defining all the cutouts and depressions used on the packaging
holes = [ //format [face_name, shape_name, shape_position[x_pos,y_pos,x_offs,y_offs,rotate,align], shape_size[depth,,,]]
//	["N", "Cone",		[8,10,0,0,0,"inside"],					[4,5,4,8]		],
	// ["N", "Ellipse",	[10,14,-box_l/2,-box_h/2,10,"outside"],	[1,8,12,20]		],//aligned to bottom left corner
	// ["S", "Ellipse",	[10,14,-box_l/2,-box_h/2,10,"inside"],	[1,8,12,20]		],
	// ["E", "Cylinder",	[-1,-8,0,0,0,"inside"],					[4,2,10]		],
//	["E", "Round_Rect",	[-8,4,8,-4,10,"outside"],				[4,10,8,2,4]	],
	// ["W", "Round_Rect",	[-8,4,8,-4,10,"outside"],				[4,10,8,2,4]	],
//	["T", "Square",		[-5,-8,0,0,40,"inside"],				[5,10]			],
	// ["T", "Rectangle",	[2,-10,0,+box_b/2,10,"outside"],		[2,4,15]		],//aligned to top centre
//	["B", "Rectangle",	[2,-2,0,+box_b/2,10,"outside"],		[2,4,5]		]//aligned to top centre
	// ["N", "Rectangle",		[0.2, -5.25,0,0,0,"inside"],				[wall_t, 11.6, 8]			],//uUSB port
	// ["W", "Rectangle",		[6.75, -5.25+(8-5.3+4.7-1.4)/2,0,0,0,"inside"],				[wall_t/2, 10.5, 10-1.4]			],//internal cutout for inserting switch
	// ["W", "Rectangle",		[6.75, -5.25+(8-5.3)/2,0,0,0,"outside"],				[wall_t/2, 10.5, 5.3]			],//switch cutout
	// //["W", "Rectangle",		[6.75, -4,0,0,0,"inside"],				[wall_t/2, 9, 8]			]
	// ["W", "Cylinder",		[-1.2, -4-2,0,0,90,"inside"],				[wall_t, 1.5, 5]			],//Battery Charging Amber LED
	// ["W", "Cylinder",		[-5.2, -4-2,0,0,90,"inside"],				[wall_t, 1.5, 5]			],//Battery Charged Green LED
	// ["E", "Cylinder",		[-3, -4,0,0,90,"inside"],				[wall_t, 1.5, 5]			],//Battery Warning Red LED
	// ["E", "Cylinder",		[-3, 6,0,0,-90,"inside"],				[wall_t, 1.5, 5]			]//TxRx Red LED
	
	
	["W", "Rectangle",		[-13.5, 0.5,0,-device_xyz[2]/2,0,"inside"],				[wall_t, 14, 2]			],//cutout for uSD card
	["W", "Ellipse",	[-13.5, 1+0.5,0,-device_xyz[2]/2,0,"outside"],	[wall_t/2,14/2,2,16]		],//cutout to aid inserting/removing uSD card////(depth, radius_length, radius_breadth, sides)
	//["E", "Rectangle",		[0.5, +0.75,0,0,0,"inside"],				[wall_t, 9, 5]			],//cutout for switch
	["E", "Round_Rect",		[0.5, +0.75,0,0,0,"inside"],				[wall_t, 10, 4.5,1,3]			],//cutout for switch
	//old ["E", "Rectangle",		[15, +1,0,0,0,"inside"],				[wall_t/2, 10, 6]			],//cutout for uUSB metal plug#uUSB spec is 6.85*1.8, 
	["E", "Rectangle",		[15.25, -0.15,0,0,0,"inside"],				[wall_t/2, 7.6, 2.7]			],//cutout for uUSB metal plug#uUSB spec is 6.85*1.8, measured at ~7*2.1, seems to be roughly centred on plugs I measured
	//["E", "Rectangle",		[15, -1.1,0,0,0,"outside"],				[wall_t/2, 11.5, 7.7]			],//cutout for uUSB plastic overmold plug#uUSBspec maximum overmold size of 10.6 by 8.5 mm measured at ~10.8x7mm
	["E", "Round_Rect",		[15.25, -0.15,0,0,0,"outside"],				[wall_t/2, 11.5, 7.7,1,3]			],//cutout for uUSB plastic overmold plug#uUSBspec maximum overmold size of 10.6 by 8.5 mm measured at ~10.8x7mm
	//[depth, length, breadth, corner_radius, corner_sides]


	];


	post_tolerance=0.2;
//data structure defining all the internal supporting structures used on the packaging
posts = [ //format [face_name, shape_name shape_position[x_pos,y_pos,x_offs,y_offs,rotate,align], shape_size[depth,,,]]
	
	["T", "Cylinder",	[24,31.5+7.5/2,-27/2,-40/2,30,"inside"],					[3.55+clearance_xyz[2]-post_tolerance,3,6]		],//Post above uUSB
	["T", "Cylinder",	[7.2+6.7/2,28+6.7/2,-27/2,-40/2,30,"inside"],				[4.85+clearance_xyz[2]-post_tolerance,3,6]		],//post above zigbee
	["T", "Cylinder",	[22+4/2,1.14+4/2,-27/2,-40/2,30,"inside"],					[4.33+clearance_xyz[2]-post_tolerance,3,6]		],//post above mag
	["T", "Rectangle",	[-3,28,0,-40/2,90,"inside"],					[3,2,6]		],//battery retainers across leads
	["T", "Rectangle",	[-5,13,+27/2,-40/2,0,"inside"],					[3,2,10]		],//batter retainer along side
	
	["B", "Cylinder",	[0,+6,0,-40/2,30,"inside"],				[clearance_xyz[2]-post_tolerance,3,6]		],//post beneath uSD cage
	["B", "Cylinder",	[-(1.88+4/2),+4,27/2,-40/2,30,"inside"],				[clearance_xyz[2]+1.88-post_tolerance,3,6]		],//post beneath mag
	["B", "Cylinder",	[0,-5,0,40/2,30,"inside"],			[clearance_xyz[2]+1.88-post_tolerance,3,6]		],//post beneath space between uUSB and ant
	
	//structures to hold pcb in place laterally
	["S", "Rectangle",	[0,0,0,0,0,"inside"],					[clearance_xyz[1]-post_tolerance,2,7]		],//PCB lateral retainer
	["N", "Rectangle",	[0,0,0,0,0,"inside"],					[clearance_xyz[1]-post_tolerance,2,7]		],//PCB lateral retainer
	["W", "Rectangle",	[0,0,0,0,0,"inside"],					[clearance_xyz[0]-post_tolerance,2,7]		],//PCB lateral retainer
	["E", "Rectangle",	[-7,0,0,0,0,"inside"],					[clearance_xyz[0]-post_tolerance,2,7]		],//PCB lateral retainer
	["E", "Rectangle",	[+7,0,0,0,0,"inside"],					[clearance_xyz[0]-post_tolerance,2,7]		],//PCB lateral retainer
	
	];
//data structure defining all the engraved text used on the packaging
text_engrave_emboss_depth=1;
text_height_big=7;
text_height_small=5;
text_spacing=1.1;
text = [//recessed text on faces [face_name, text_to_write, shape_position[x_pos,y_pos,x_offs,y_offs,rotate,align], shape_size[depth,font_height,font_spacing,mirror]] Note: for silly reasons mirror must be 0 or 1 corresponding to false and true in this version
	["T", "WIMU 3A",	[6,0,0,0,90,"outside"], 					[text_engrave_emboss_depth,text_height_big,text_spacing,0]],
	["T", "+Z",			[-6,0,0,0,90,"outside"], 					[text_engrave_emboss_depth,text_height_big,text_spacing,0]],
	["S", "+X",			[0,lip_h/2,0,5,0,"outside"], 				[text_engrave_emboss_depth,text_height_big,text_spacing,0]],
	["N", "-X",			[8,lip_h/2,0,0,0,"outside"], 				[text_engrave_emboss_depth,text_height_big,text_spacing,0]],
	["W", "-Y",			[-15,lip_h/2,0,0,0,"outside"], 				[text_engrave_emboss_depth,text_height_big,text_spacing,0]],
	["E", "+Y",			[-15,lip_h/2,0,0,0,"outside"], 				[text_engrave_emboss_depth,text_height_big,text_spacing,0]],
	//["E", "ON OFF",		[0,-5,0,0,0,"outside"], 					[text_engrave_emboss_depth,4,text_spacing,0]],
	//["E", "ON",		[-8,lip_h/2,0,0,90,"outside"], 					[text_engrave_emboss_depth,5,text_spacing*1.5,0]],
	["E", "I",		[-3.5,5,0,0,-90,"outside"], 					[text_engrave_emboss_depth,4,text_spacing,0]],
	["E", "O",		[3.5,5,0,0,-90,"outside"], 					[text_engrave_emboss_depth,4,text_spacing,0]],
	["N", "uUSB",		[-7,lip_h/2,0,0,0,"outside"], 					[text_engrave_emboss_depth,text_height_small,text_spacing,0]],
	["W", "uSD",		[0,lip_h/2,0,0,0,"outside"], 					[text_engrave_emboss_depth,text_height_small,text_spacing,0]],
	];


//data structure defining external items such as .stl files to import
items =[//external items on faces [face_name, external_file, shape_position[x_pos,y_pos,x_offs,y_offs,rotate,align], shape_size[depth, scale_x,scale_y, scale_z, mirror]] Note: for silly reasons mirror must be 0 or 1 corresponding to false and true in this version
	["B", "tyndall_logo_v0_2.stl",			[0,0,0,0,90,"outside"], 					[0.5,10/21.9,10/21.9,1.1/1.62,0]]
	];

//data structure defining external slotted flanges on 4 sides
has_flanges=true;
flange_t=wall_t;
slot_t=3;
slot_w=27;
flanges=[
//flange_sides, flange_type, position[x_pos, y_pos], shape_size[flange_t, flange_case_gap, flange_wall_t,slot_b,slot_l,flange_sides]
	//["N","rounded_slot",[4,0],	[flange_t,0,wall_t,slot_t,slot_w,corner_sides]],
	//["S","rounded_slot",[4,0],	[flange_t,0,wall_t,slot_t,slot_w,corner_sides]],
	["E","rounded_slot",[0,0],	[flange_t,0,wall_t,slot_t,slot_w,corner_sides]],
	["W","rounded_slot",[0,0],	[flange_t,0,wall_t,slot_t,slot_w,corner_sides]],
	
	//["S","2_holes",		[0,0], 	[flange_t,0,wall_t,hole_center_sep,hole_r,box_s]],//[]
];
/* [Hidden] */
//a small number used for manifoldness
a_bit=0.01;
//x dimension of packaging
box_l=device_xyz[0]+2*(clearance_xyz[0]+wall_t); //box_l=device_xyz[0]+2*(clearance_xyz[0]+wall_thickness_xyz[0]);
//y dimension of packaging
box_b=device_xyz[1]+2*(clearance_xyz[1]+wall_t); //box_b=device_xyz[1]+2*(clearance_xyz[1]+wall_thickness_xyz[1]);
//z dimension of packaging
box_h=device_xyz[2]+2*(clearance_xyz[2]+wall_t);//box_h=device_xyz[2]+2*(clearance_xyz[2]+wall_thickness_xyz[2]);

mouse_ears=[has_mouseears, mouse_ear_thickness, mouse_ear_radius];

box=[box_l,box_b,box_h,corner_radius,corner_sides,wall_t];//


has_locking_feature=true;
//locking_feature_r=0.5
//locking_feature_h=[10,20]

//********************************includes******************//
use<write.scad>;


//******************************calls**********************//
	make_box(box,corner_radius, corner_sides, lip_h, lip_fit, top_bottom_ratio, mouse_ears, layout, separation, holes, posts, text, items, has_device, box_type, has_flanges, flanges);



//***************************modules***********************//
module make_box(box, corner_radius=3, corner_sides=5, lip_h=2, lip_fit=0, top_bottom_ratio=0.5,mouse_ears=[false],layout="beside", separation=2, holes=[], posts=[], text=[], items=[],has_device=false, box_type="rounded4sides",has_flanges=false, flanges=[]){
	echo("layout", layout);
	
	//echo("holes",holes);
	//echo ("variables",corner_radius, corner_sides, lip_h, top_bottom_ratio,has_mouseears,layout, separation);
	translate(v=[0,0,box[2]/2]){
		if (layout=="beside"){
			echo("beside");
			union(){
				translate(v=[(separation+box[0])/2,0,0]){
					half_box(box, corner_radius, corner_sides, lip_h, lip_fit, top_bottom_ratio, which_half="bottom", holes=holes, posts=posts, mouse_ears=mouse_ears, text=text, items=items, box_type=box_type,has_flanges=has_flanges, flanges=flanges);
					//cube(size=[25.5,31.5,23.5],center=true);
					//rotate(a=[0,0,90])translate(v=[-30/2,-15/2,0])import("wimuv3_stack_v0.1.stl");
//					rotate(a=[0,0,-90])translate(v=[-27/2,-40/2,1.88])import("2013_04_04-WIMUv3a_PCB-V0-2_logo.stl");
				}translate(v=[-(separation+box[0])/2,0,0]) rotate(a=[0,180,0]){
					half_box(box, corner_radius, corner_sides, lip_h, lip_fit, top_bottom_ratio, which_half="top", holes=holes, posts=posts, mouse_ears=mouse_ears, text=text, items=items, box_type=box_type);//cube(size=[box[0],box[1],box[2]],center=true);
					//cube(size=[25.5,31.5,23.5],center=true);
				}
			}
		}else if (layout=="stacked"){
			echo("stacked");
			half_box(box, corner_radius, corner_sides, lip_h, lip_fit, top_bottom_ratio, which_half="bottom", holes=holes, posts=posts, mouse_ears=mouse_ears, text=text, items=items,has_device=has_device, box_type=box_type, has_flanges=has_flanges, flanges=flanges);
			translate(v=[0,0,0])half_box(box, corner_radius, corner_sides, lip_h, lip_fit, top_bottom_ratio, which_half="top", holes=holes, posts=posts, mouse_ears=[false], text=text, items=items, box_type=box_type);
			//rotate(a=[0,0,90])translate(v=[-30/2,-15/2,0])import("wimuv3_stack_v0.1.stl");
		}else if (layout=="top"){
			echo("top");
			rotate(a=[180,0,0]) half_box(box, corner_radius, corner_sides, lip_h, lip_fit, top_bottom_ratio, which_half="top", holes=holes, posts=posts, mouse_ears=mouse_ears, text=text, items=items, box_type=box_type);
		}else if (layout=="bottom"){
			echo("bottom");
			half_box(box, corner_radius, corner_sides, lip_h, lip_fit, top_bottom_ratio, which_half="bottom", holes=holes, posts=posts, mouse_ears=mouse_ears, text=text, items=items, has_device=has_device, box_type=box_type,has_flanges=has_flanges, flanges=flanges);
		}else{
			echo("unknown layout requested", layout);
		}
	}
}

module half_box(box, corner_radius=3, corner_sides=5, lip_h=2, lip_fit=0, top_bottom_ratio=0.5, which_half="bottom", holes=[], posts=[], mouse_ears=[false], text=[], , items=[],has_device=false, box_type="rounded4sides",has_flanges=false, flanges=[]){
	a_bit=0.01;
	echo("holes",holes);
	has_mouse_ears=mouse_ears[0];
	mouse_ear_thickness=mouse_ears[1];
	mouse_ear_radius=mouse_ears[2];

	wall_t=box[5];
	cutaway_extra=0.01;
	if (which_half=="bottom") color("springgreen") {
		echo("bottom half");
		union(){//combine hollow cutout box with posts
			difference(){
				union(){
					difference(){//make the hollow box
						// if(box_type="4_sides_round"){
							// rounded_rectangle_cylinder_hull(box[0],box[1],box[2],corner_radius,corner_sides);//main body
							// rounded_rectangle_cylinder_hull(box[0]-2*box[5],box[1]-2*box[5],box[2]-2*box[5],corner_radius-box[5],corner_sides);//hollow for insides
						// }else if(box_type="6_sides_round"){
							// rounded_rectangle_cylinder_hull(box[0],box[1],box[2],corner_radius,corner_sides);//main body
							// rounded_rectangle_cylinder_hull(box[0]-2*box[5],box[1]-2*box[5],box[2]-2*box[5],corner_radius-box[5],corner_sides);//hollow for insides
						// }
						//
						box_type(box, box_type); //rounded_rectangle_cylinder_hull(box[0],box[1],box[2],corner_radius,corner_sides);
						box_type([box[0]-2*box[5],box[1]-2*box[5],box[2]-2*box[5],corner_radius-box[5],corner_sides], box_type);//rounded_rectangle_cylinder_hull(box[0]-2*box[5],box[1]-2*box[5],box[2]-2*box[5],corner_radius-box[5],corner_sides);
						//
						//rounded_rectangle_cylinder_hull(box[0]-2*box[5][0],box[1]-2*box[5][1],box[2]-2*box[5][2],corner_radius-0.5*(box[5][0]+box[5][1]),corner_sides);//hollow for insides
					}
					make_posts(box, posts);//add the posts
				}
				translate(v=[0,0,box[2]*(1-top_bottom_ratio)-lip_h/2]){//cutting away other half and lip cutout
					//translate(v=[0,0,lip_h/2 - box[2]/2 ])rounded_rectangle_cylinder_hull(box[0]-box[5],box[1]-box[5],lip_h+0.01,corner_radius-box[5]/2,corner_sides);//cutout for lips
					translate(v=[0,0,lip_h/2 - box[2]/2 ])rounded_rectangle_cylinder_hull(box[0]-(box[5]-lip_fit),box[1]-(box[5]-lip_fit),lip_h+0.01,corner_radius-(box[5]-lip_fit)/2,corner_sides);//cutout for lips
					//translate(v=[0,0,lip_h/2 - box[2]/2 ])rounded_rectangle_cylinder_hull(box[0]-box[5][0],box[1]-box[5][1],lip_h+0.01,corner_radius-(box[5][0]+box[5][1])/4,corner_sides);
					translate(v=[0,0,lip_h+cutaway_extra/2]) cube(size=[box[0]+2*cutaway_extra,box[1]+2*cutaway_extra,box[2]+cutaway_extra], center=true);//need to oversize this using cutaway_extra so it gets any extra material on the side the be removed on the outside (from posts)
					
				}
				#make_cutouts(box, holes);//remove the material for the cutouts// because this happens at the end you can make a hole in the centre of a post! perhaps a cone for a countersink screw through hole
				make_text(box, text);//text
				make_items(box, items);//items
			}
			//make_posts(box, posts);
			//locking features
			if (has_locking_feature){
				echo("making locking feature");
				//#translate(v=[box_l/2-(wall_t/2-lip_fit/2),0,0])rotate(a=[90,0,0])cylinder(r=lip_h/5, h=20,center=true);
				#mirror(v=[1,0,0])translate(v=[box_l/2-(wall_t/2-lip_fit/2),0,0])rotate(a=[90,0,0])cylinder(r=lip_h/5, h=20,center=true);
				# translate(v=[0,box_b/2-(wall_t/2-lip_fit/2),0])rotate(a=[90,0,90])cylinder(r=lip_h/5, h=10,center=true);
				#mirror(v=[0,1,0]) translate(v=[0,box_b/2-(wall_t/2-lip_fit/2),0])rotate(a=[90,0,90])cylinder(r=lip_h/5, h=10,center=true);
			}
			
			mouse_ears(box,mouse_ear_thickness,mouse_ear_radius, has_mouse_ears);
			if(has_device==true){
				echo("has device");
				//rotate(a=[0,0,90])translate(v=[-31/2,-25/2,-box[2]/2+3.5])import("wimuv3_stack_v0.1.stl");
				rotate(a=[0,0,90])translate(v=[-40/2,-27/2,1.88-9.23/2])import("2013_04_04-WIMUv3a_PCB-V0-2_logo.stl");
			}
			if (has_flanges==true){
				make_flanges(box,wall_t,-(box[2]-wall_t)/2,flanges);
			}
		}
		
	}else if (which_half=="top") color("crimson") {
		echo("top half");
		union(){
			intersection(){
				difference(){
					//echo("box",box);
					union(){
						difference(){//make hollow box
							box_type(box, box_type); //rounded_rectangle_cylinder_hull(box[0],box[1],box[2],corner_radius,corner_sides);
							//box_type([box[0]-2*box[5][0],box[1]-2*box[5][1],box[2]-2*box[5][2],corner_radius-0.5*(box[5][0]+box[5][1]),corner_sides], box_type="rounded4sides");//rounded_rectangle_cylinder_hull(box[0]-2*box[5],box[1]-2*box[5],box[2]-2*box[5],corner_radius-box[5],corner_sides);
							box_type([box[0]-2*box[5],box[1]-2*box[5],box[2]-2*box[5],corner_radius-box[5],corner_sides], box_type);//rounded_rectangle_cylinder_hull(box[0]-2*box[5],box[1]-2*box[5],box[2]-2*box[5],corner_radius-box[5],corner_sides);
						}
						make_posts(box,posts);//add the posts
					}
					#make_cutouts(box, holes);//remove material for cutouts
					make_text(box, text);//text
					make_items(box, items);//items
					//locking features
					if (has_locking_feature){
						echo("making locking feature");
						//#translate(v=[box_l/2-(wall_t/2+lip_fit/2),0,0])rotate(a=[90,0,0])cylinder(r=lip_h/5, h=21,center=true);
						#mirror(v=[1,0,0])translate(v=[box_l/2-(wall_t/2+lip_fit/2),0,0])rotate(a=[90,0,0])cylinder(r=lip_h/5, h=21,center=true);
						# translate(v=[0,box_b/2-(wall_t/2+lip_fit/2),0])rotate(a=[90,0,90])cylinder(r=lip_h/5, h=11,center=true);
						#mirror(v=[0,1,0]) translate(v=[0,box_b/2-(wall_t/2+lip_fit/2),0])rotate(a=[90,0,90])cylinder(r=lip_h/5, h=11,center=true);
					}
				}
				translate(v=[0,0,(box[2]*(1-top_bottom_ratio))-lip_h/2]){//removed -lip_h/2 from z translate/re-added
					//translate(v=[0,0,lip_h/2 - box[2]/2]) rounded_rectangle_cylinder_hull(box[0]-box[5],box[1]-box[5],lip_h+0.01,corner_radius-box[5]/2,corner_sides);//lips
					translate(v=[0,0,lip_h/2 - box[2]/2]) rounded_rectangle_cylinder_hull(box[0]-(box[5]+lip_fit),box[1]-(box[5]+lip_fit),lip_h+0.01,corner_radius-(box[5]+lip_fit)/2,corner_sides);//lips
					// translate(v=[0,0,lip_h/2 - box[2]/2]) rounded_rectangle_cylinder_hull(box[0]-box[5][0],box[1]-box[5][1],lip_h+0.01,corner_radius-(box[5][0]+box[5][1])/4,corner_sides);
					translate(v=[0,0,lip_h-a_bit]) cube(size=[box[0]+2*cutaway_extra,box[1]+2*cutaway_extra,box[2]], center=true);
				}
			}
			//make_posts(box,posts);
			rotate(a=[180,0,0])mouse_ears(box,mouse_ear_thickness,mouse_ear_radius, has_mouse_ears);
		}
		
	}else{
		echo("invalid half requested",which_half);
	}
}

module rounded_rectangle_cylinder_hull(x,y,z,r,s){
	//cube(size=[x,y,z],center=true);
	//echo("number of sides",s);
	hull(){
		cross_box(x,y,z,r);//this is to ensure the overall dimensions stay true to those requested even for low-poly cylinders
		translate(v=[   x/2 -r ,   y/2 -r , 0])cylinder(h=z, r=r, center=true, $fn=4*s);
		translate(v=[   x/2 -r , -(y/2 -r), 0])cylinder(h=z, r=r, center=true, $fn=4*s);
		translate(v=[ -(x/2 -r), -(y/2 -r), 0])cylinder(h=z, r=r, center=true, $fn=4*s);
		translate(v=[ -(x/2 -r),   y/2 -r , 0])cylinder(h=z, r=r, center=true, $fn=4*s);
	}
}

module cross_box(x,y,z,r){
	cube(size=[x-2*r,y-2*r,z],center=true);
	cube(size=[x-2*r,y,z-2*r],center=true);
	cube(size=[x,y-2*r,z-2*r],center=true);
}

module make_cutouts(box, holes){
	box_l=box[0];//x
	box_b=box[1];//y
	box_h=box[2];//z
	box_t=[box[5],box[5],box[5]];//wall_t

//%	cube(size=[box_l,box_b,box_h],center=true);

	x_pos = 0;
	y_pos = 0;
	face = "X";
	
	echo("len(holes)",len(holes));
	for (j=[0:len(holes)-1]){
		// assign (angle = i*360/20, distance = i*10, r = i*2)
		assign (x_pos = holes[j][2][0], y_pos = holes[j][2][1], x_offs= holes[j][2][2], y_offs= holes[j][2][3], face = holes[j][0], shape_type=holes[j][1], shape_data=holes[j][3], rotation=holes[j][2][4], align=holes[j][2][5], depth=holes[j][3][0]){
			//echo("face",face);
			if (face=="N"){
				translate(v=[0,box_b/2,0])rotate(a=[-90,0,0])translate(v=[-(x_pos+x_offs),-(y_pos+y_offs),0]){
					//echo("alignment", align);
					if (align=="inside"){
						//echo("translate by",+depth/2-box_t);
						translate(v=[0,0,+depth/2-box_t[1]]) rotate(a=[0,0,-rotation]) make_shape(shape_type, shape_data);
					}else if (align=="outside"){
						//echo("translate by",-depth/2);
						translate(v=[0,0,-depth/2]) rotate(a=[0,0,-rotation]) make_shape(shape_type, shape_data);
					}else{
						echo("invalid alignment", align);
					}
				}
			}else if (face=="E"){
				translate(v=[box_l/2,0,0])rotate(a=[0,90,0])rotate(a=[0,0,-90])translate(v=[-(x_pos+x_offs),-(y_pos+y_offs),0]){
					//make_shape(shape_type, shape_data);
					if (align=="inside") translate(v=[0,0,+depth/2-box_t[0]]) rotate(a=[0,0,-rotation]) make_shape(shape_type, shape_data);
					else if (align=="outside") translate(v=[0,0,-depth/2]) rotate(a=[0,0,-rotation]) make_shape(shape_type, shape_data);
					else echo("invalid alignment", align);
				}
			}else if (face=="T"){
				translate(v=[0,0,box_h/2])rotate(a=[0,0,0])translate(v=[(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") translate(v=[0,0,+depth/2-box_t[2]]) rotate(a=[0,0,-rotation]) make_shape(shape_type, shape_data);
					else if (align=="outside") translate(v=[0,0,-depth/2]) rotate(a=[0,0,-rotation]) make_shape(shape_type, shape_data);
					else echo("invalid alignment", align);
				}
			}else if (face=="S"){
				translate(v=[0,-box_b/2,0])rotate(a=[+90,0,0])translate(v=[-(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") translate(v=[0,0,+depth/2-box_t[1]]) rotate(a=[0,0,rotation]) make_shape(shape_type, shape_data);
					else if (align=="outside") translate(v=[0,0,-depth/2]) rotate(a=[0,0,rotation]) make_shape(shape_type, shape_data);
					else echo("invalid alignment", align);
				}
			}else if (face=="W"){
				translate(v=[-box_l/2,0,0])rotate(a=[0,-90,0])rotate(a=[0,0,-90])translate(v=[-(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") translate(v=[0,0,+depth/2-box_t[0]]) rotate(a=[0,0,rotation]) make_shape(shape_type, shape_data);
					else if (align=="outside") translate(v=[0,0,-depth/2]) rotate(a=[0,0,rotation]) make_shape(shape_type, shape_data);
					else echo("invalid alignment", align);
				}
			}else if (face=="B"){
				//echo("bottom");
				translate(v=[0,0,-box_h/2])rotate(a=[0,180,0])translate(v=[-(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") translate(v=[0,0,+depth/2-box_t[2]]) rotate(a=[0,0,rotation]) make_shape(shape_type, shape_data);
					else if (align=="outside") translate(v=[0,0,-depth/2]) rotate(a=[0,0,rotation]) make_shape(shape_type, shape_data);
					else echo("invalid alignment", align);
				}
			}else{
				echo("Unknown Face",face);
			}
		}
	}
}

module mouse_ears(box,thickness,radius, has_mouse_ears){
	if (has_mouse_ears) union(){
		translate(v=[box[0]/2,box[1]/2,-box[2]/2])cylinder(r=radius, center=false);
		translate(v=[box[0]/2,-box[1]/2,-box[2]/2])cylinder(r=radius, center=false);
		translate(v=[-box[0]/2,box[1]/2,-box[2]/2])cylinder(r=radius, center=false);
		translate(v=[-box[0]/2,-box[1]/2,-box[2]/2])cylinder(r=radius, center=false);
	}
}

module make_posts(box, posts){//this will be based on make_cutouts
	echo ("make_posts");
	a_bit=0.01;
	box_l=box[0];//x
	box_b=box[1];//y
	box_h=box[2];//z
	box_t=[box[5],box[5],box[5]];//wall_t [x,y,z]

//%	cube(size=[box_l,box_b,box_h],center=true);

	x_pos = 0;
	y_pos = 0;
	face = "X";
	echo("len(posts)",len(posts));
	for (j=[0:len(posts)-1]){
		// assign (angle = i*360/20, distance = i*10, r = i*2)
		assign (x_pos = posts[j][2][0], y_pos = posts[j][2][1], x_offs= posts[j][2][2], y_offs= posts[j][2][3], face = posts[j][0], shape_type=posts[j][1], shape_data=posts[j][3], rotation=posts[j][2][4], align=posts[j][2][5], depth=posts[j][3][0]-a_bit){
			//echo("face",face);
			if (face=="N"){
				translate(v=[0,box_b/2,0])rotate(a=[-90,0,0])translate(v=[-(x_pos+x_offs),-(y_pos+y_offs),0]){
					//echo("alignment", align);
					if (align=="inside"){
						//echo("translate by",+depth/2-box_t);
						translate(v=[0,0,-depth/2-box_t[1]]) rotate(a=[0,0,-rotation]) make_shape(shape_type, shape_data);
					}else if (align=="outside"){
						//echo("translate by",-depth/2);
						translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,-rotation]) make_shape(shape_type, shape_data);
					}else{
						echo("invalid alignment", align);
					}
				}
			}else if (face=="E"){
				translate(v=[box_l/2,0,0])rotate(a=[0,90,0])rotate(a=[0,0,-90])translate(v=[-(x_pos+x_offs),-(y_pos+y_offs),0]){
					//make_shape(shape_type, shape_data);
					if (align=="inside") translate(v=[0,0,-depth/2-box_t[0]]) rotate(a=[0,0,-rotation]) make_shape(shape_type, shape_data);
					else if (align=="outside") translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,-rotation]) make_shape(shape_type, shape_data);
					else echo("invalid alignment", align);
				}
			}else if (face=="T"){
				echo(face,align);
				translate(v=[0,0,box_h/2])rotate(a=[0,0,0])translate(v=[(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") translate(v=[0,0,-depth/2-box_t[2]]) rotate(a=[0,0,-rotation]) make_shape(shape_type, shape_data);
					else if (align=="outside") translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,-rotation]) make_shape(shape_type, shape_data);
					else echo("invalid alignment", align);
				}
			}else if (face=="S"){
				translate(v=[0,-box_b/2,0])rotate(a=[+90,0,0])translate(v=[-(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") translate(v=[0,0,-depth/2-box_t[1]]) rotate(a=[0,0,rotation]) make_shape(shape_type, shape_data);
					else if (align=="outside") translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,rotation]) make_shape(shape_type, shape_data);
					else echo("invalid alignment", align);
				}
			}else if (face=="W"){
				translate(v=[-box_l/2,0,0])rotate(a=[0,-90,0])rotate(a=[0,0,-90])translate(v=[-(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") translate(v=[0,0,-depth/2-box_t[0]]) rotate(a=[0,0,rotation]) make_shape(shape_type, shape_data);
					else if (align=="outside") translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,rotation]) make_shape(shape_type, shape_data);
					else echo("invalid alignment", align);
				}
			}else if (face=="B"){
				//echo("bottom");
				translate(v=[0,0,-box_h/2])rotate(a=[0,180,0])translate(v=[-(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") translate(v=[0,0,-depth/2-box_t[2]]) rotate(a=[0,0,rotation]) make_shape(shape_type, shape_data);
					else if (align=="outside") translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,rotation]) make_shape(shape_type, shape_data);
					else echo("invalid alignment", align);
				}
			}else{
				echo("Unknown Face",face);
			}
		}
	}
}

module make_shape(shape, shape_data){
	a_bit=0.01;//for ensuring manifoldness
	//shape="Cone";//"Ellipse";//"Cylinder";//"Round_Rect";//"Square";//"Rectangle";Nub_Post, Dip_Post, Hollow_Cylinder
	//shape_data=[4,5,4,8];//[4,8,12,20];//[4,2,10];//[4,10,8,2,4];//[5,10];//[2,4,15];
	if(shape=="Square"){//[depth, length_breadth]
		cube(size=[shape_data[1],shape_data[1],shape_data[0]+a_bit],center=true);//do thing for square
		
	}else if(shape=="Rectangle"){//[depth, length, breadth]
		cube(size=[shape_data[1],shape_data[2],shape_data[0]+a_bit],center=true);//do thing for rectangle
		
	}else if(shape=="Round_Rect"){//[depth, length, breadth, corner_radius, corner_sides]
		rounded_rectangle_cylinder_hull(shape_data[1],shape_data[2],shape_data[0]+a_bit, shape_data[3], shape_data[4]);
		/*hull(){
			translate(v=[   shape_data[1]/2 -shape_data[3] ,   shape_data[2]/2 -shape_data[3] , 0])cylinder(h=shape_data[0]+a_bit, r=shape_data[3], center=true, $fn=4*shape_data[4]);
			translate(v=[   shape_data[1]/2 -shape_data[3] , -(shape_data[2]/2 -shape_data[3]), 0])cylinder(h=shape_data[0]+a_bit, r=shape_data[3], center=true, $fn=4*shape_data[4]);
			translate(v=[ -(shape_data[1]/2 -shape_data[3]), -(shape_data[2]/2 -shape_data[3]), 0])cylinder(h=shape_data[0]+a_bit, r=shape_data[3], center=true, $fn=4*shape_data[4]);
			translate(v=[ -(shape_data[1]/2 -shape_data[3]),   shape_data[2]/2 -shape_data[3] , 0])cylinder(h=shape_data[0]+a_bit, r=shape_data[3], center=true, $fn=4*shape_data[4]);
		}*/
	}else if(shape=="Cylinder"){ //(depth, radius ,sides)
		cylinder(r=shape_data[1],h=shape_data[0]+a_bit,center=true, $fn=shape_data[2]);//do thing for cylinder
		
	}else if(shape=="Ellipse"){ //(depth, radius_length, radius_breadth, sides)
		scale (v=[shape_data[1],shape_data[2],1])cylinder(r=1,h=shape_data[0]+a_bit,center=true, $fn=shape_data[3]);//do thing for ellipse
		
	}else if(shape=="Cone"){ //(depth, radius_bottom, radius_top ,sides)
		cylinder(r1=shape_data[1],r2=shape_data[2],h=shape_data[0]+a_bit,center=true, $fn=shape_data[3]);//do thing for cone
		
	}else if(shape=="Nub_Post"){ //(depth, radius_bottom, radius_top , depth_nub, sides)
		union(){
			echo ("make nub",shape_data);
			cylinder(r=shape_data[1], h=shape_data[0]+a_bit,center=true, $fn=shape_data[4]);//do thing for cylinder outside
			//cylinder(r=max(shape_data[2],shape_data[1]), h=shape_data[0]+a_bit,center=true, $fn=shape_data[3]);//do thing for cylinder outside
			//translate(v=[0,0,(shape_data[0]-shape_data[3])/2]) cylinder(r=min(shape_data[2],shape_data[1]), h=shape_data[0]+a_bit,center=true, $fn=shape_data[3]);//do thing for cylinder inside
			translate(v=[0,0,(-shape_data[0]+shape_data[3])/2]) cylinder(r=shape_data[2], h=shape_data[0]+a_bit,center=true, $fn=shape_data[4]);//do thing for cylinder inside
		}
		
	}else if(shape=="Dip_Post"){ //(depth, radius_bottom, radius_top ,depth_dip, sides)
		difference(){
			echo("dip_post",shape_data);
			cylinder(r=shape_data[1],h=shape_data[0]+a_bit, center=true,$fn=shape_data[4]);//do thing for cylinder outside
			//cylinder(r=max(shape_data[2],shape_data[1]), h=shape_data[0]+a_bit,center=true, $fn=shape_data[3]);//do thing for cylinder outside
			//translate(v=[0,0,(shape_data[0]+shape_data[3])/2]) cylinder(r=min(shape_data[2],shape_data[1]), h=shape_data[0]+2*a_bit,center=true, $fn=shape_data[3]);//do thing for cylinder inside
			translate(v=[0,0,(-shape_data[0]+shape_data[3])/2]) cylinder(r=shape_data[2], h=shape_data[3]+2*a_bit,center=true, $fn=shape_data[4]);//do thing for cylinder inside
		}
	}else if(shape=="Hollow_Cylinder"){ //(depth, radius_outside, radius_inside ,sides)
		difference(){
			cylinder(r=max(shape_data[2],shape_data[1]), h=shape_data[0]+a_bit,center=true, $fn=shape_data[3]);//do thing for cylinder outside
			cylinder(r=min(shape_data[2],shape_data[1]), h=shape_data[0]+2*a_bit,center=true, $fn=shape_data[3]);//do thing for cylinder inside
		}
	}else{
		echo("Unsupported Shape",shape);
	}
}

module box_type(box, box_type="rounded4sides"){
//basic initial if clause checker will identify if r or s are <=0 or 1 are reverts to a different shape otherwise (simple cuboid)
//this will aid in situations such as r<=wall_t so calculated internal r is now 0 or negative which could cause unexpected geometry or crashes
	if(box_type=="cuboid" || (box[3]<=0 || box[4]<=0)){//|| box[3]<=0 || box[4]=0
		cube(size=[box[0],box[1],box[2]],center=true);
	}else if(box_type=="rounded4sides"){
		rounded_rectangle_cylinder_hull(box[0],box[1],box[2],box[3],box[4]);
	}else if(box_type=="rounded6sides"){
		rounded_rectangle_sphere_hull(box[0],box[1],box[2],box[3],box[4]);
	}else if(box_type=="chamfered6sides"){
		chamfered_rectangle_hull(box[0],box[1],box[2],box[3]);
	}else{
		echo ("unknown box type requested",box_type);
	}
}

module chamfered_rectangle_hull(x,y,z,r){
	hull(){
		cross_box(x,y,z,r);//this is to ensure the overall dimensions stay true to those requested even for low-poly cylinders
	}
}

module rounded_rectangle_sphere_hull(x,y,z,r,s){
	hull(){
		cross_box(x,y,z,r);//this is to ensure the overall dimensions stay true to those requested even for low-poly cylinders
		translate(v=[   x/2 -r ,   y/2 -r ,   z/2 -r ])sphere(r=r, $fn=4*s);
		translate(v=[   x/2 -r , -(y/2 -r),   z/2 -r ])sphere(r=r,$fn=4*s);
		translate(v=[ -(x/2 -r), -(y/2 -r),   z/2 -r ])sphere(r=r,$fn=4*s);
		translate(v=[ -(x/2 -r),   y/2 -r ,   z/2 -r ])sphere(r=r,$fn=4*s);
		translate(v=[   x/2 -r ,   y/2 -r , -(z/2 -r)])sphere(r=r, $fn=4*s);
		translate(v=[   x/2 -r , -(y/2 -r), -(z/2 -r)])sphere(r=r, $fn=4*s);
		translate(v=[ -(x/2 -r), -(y/2 -r), -(z/2 -r)])sphere(r=r, $fn=4*s);
		translate(v=[ -(x/2 -r),   y/2 -r , -(z/2 -r)])sphere(r=r, $fn=4*s);
	}
}

module make_text(box, text){//this will be based on make_cutouts
	//[face_name, text_to_write, shape_position[x_pos,y_pos,x_offs,y_offs,rotate,align], shape_size[depth,font_height,font_spacing,mirror]]
	//["N", "Y+",			[0,0,0,0,0,"outside"], 					[1,4,1,true]]
//	echo ("make_text");
	a_bit=0.01;
	box_l=box[0];//x
	box_b=box[1];//y
	box_h=box[2];//z
	box_t=[box[5],box[5],box[5]];//wall_t [x,y,z]

//%	cube(size=[box_l,box_b,box_h],center=true);

	x_pos = 0;
	y_pos = 0;
	face = "X";
	//echo("len(text)",len(text));
	for (j=[0:len(text)-1]){
		// assign (angle = i*360/20, distance = i*10, r = i*2)
		assign (face = text[j][0], text_to_type=text[j][1], x_pos = text[j][2][0], y_pos = text[j][2][1], x_offs= text[j][2][2], y_offs= text[j][2][3], rotation=text[j][2][4], align=text[j][2][5], depth=text[j][3][0], text_height=text[j][3][1], text_spacing=text[j][3][2], text_mirror=text[j][3][3]){
			//echo("text face",face);
			if (face=="N")mirror(v=[text_mirror,0,0]){
				//translate(v=[0,box_b/2,0])rotate(a=[-90,0,0])translate(v=[-(x_pos+x_offs),-(y_pos+y_offs),0]){
					//echo("alignment", align);
					if (align=="inside") 		writecube(text_to_type,[-x_pos,0,y_pos],box_b-2*box_t[1],face="back", t=depth,h=text_height,space=text_spacing, rotate=rotation, font="orbitron.dxf");// translate(v=[0,0,-depth/2-box_t[1]]) rotate(a=[0,0,-rotation]) make_shape(text_to_type, shape_data);
					else if (align=="outside") 	writecube(text_to_type,[-x_pos,0,y_pos],box_b,face="back", t=depth,h=text_height,space=text_spacing, rotate=rotation, font="orbitron.dxf");// translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,-rotation]) make_shape(text_to_type, shape_data);
					else echo("invalid alignment", align);
				//}
			}else if (face=="E")mirror(v=[0,text_mirror,0]){
				//translate(v=[box_l/2,0,0])rotate(a=[0,90,0])rotate(a=[0,0,-90])translate(v=[-(x_pos+x_offs),-(y_pos+y_offs),0]){
					//make_shape(text_to_type, shape_data);
					if (align=="inside") 		writecube(text_to_type,[0,x_pos,y_pos],box_l-2*box_t[0],face="right", t=depth,h=text_height,space=text_spacing, rotate=rotation, font="orbitron.dxf"); //translate(v=[0,0,-depth/2-box_t[0]]) rotate(a=[0,0,-rotation]) make_shape(text_to_type, shape_data);
					else if (align=="outside") 	writecube(text_to_type,[0,x_pos,y_pos],box_l,face="right", t=depth,h=text_height,space=text_spacing, rotate=rotation, font="orbitron.dxf");//translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,-rotation]) make_shape(text_to_type, shape_data);
					else echo("invalid alignment", align);
				//}
			}else if (face=="T")mirror(v=[text_mirror,0,0]){
				//echo(face,align);
				//translate(v=[0,0,box_h/2])rotate(a=[0,0,0])translate(v=[(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") 		writecube(text_to_type,[x_pos,y_pos,0],box_h-2*box_t[2],face="top", t=depth,h=text_height,space=text_spacing, rotate=rotation, font="orbitron.dxf");//translate(v=[0,0,-depth/2-box_t[2]]) rotate(a=[0,0,-rotation]) make_shape(text_to_type, shape_data);
					else if (align=="outside") 	writecube(text_to_type,[x_pos,y_pos,0],box_h,face="top", t=depth,h=text_height,space=text_spacing, rotate=rotation, font="orbitron.dxf");// translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,-rotation]) make_shape(text_to_type, shape_data);
					else echo("invalid alignment", align);
				//}
			}else if (face=="S")mirror(v=[text_mirror,0,0]){
				//translate(v=[0,-box_b/2,0])rotate(a=[+90,0,0])translate(v=[-(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") 		writecube(text_to_type,[x_pos,0,y_pos,0],box_b-2*box_t[1],face="front", t=depth,h=text_height,space=text_spacing, rotate=rotation, font="orbitron.dxf");//translate(v=[0,0,-depth/2-box_t[1]]) rotate(a=[0,0,rotation]) make_shape(text_to_type, shape_data);
					else if (align=="outside") 	writecube(text_to_type,[x_pos,0,y_pos,0],box_b,face="front", t=depth,h=text_height,space=text_spacing, rotate=rotation, font="orbitron.dxf");//translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,rotation]) make_shape(text_to_type, shape_data);
					else echo("invalid alignment", align);
				//}
			}else if (face=="W")mirror(v=[0,text_mirror,0]){
				//translate(v=[-box_l/2,0,0])rotate(a=[0,-90,0])rotate(a=[0,0,-90])translate(v=[-(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") 		writecube(text_to_type,[0,-x_pos,y_pos],box_l-2*box_t[0],face="left", t=depth,h=text_height,space=text_spacing, rotate=rotation, font="orbitron.dxf");//translate(v=[0,0,-depth/2-box_t[0]]) rotate(a=[0,0,rotation]) make_shape(text_to_type, shape_data);
					else if (align=="outside") 	writecube(text_to_type,[0,-x_pos,y_pos],box_l,face="left", t=depth,h=text_height,space=text_spacing, rotate=rotation, font="orbitron.dxf");//translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,rotation]) make_shape(text_to_type, shape_data);
					else echo("invalid alignment", align);
				//}
			}else if (face=="B")mirror(v=[text_mirror,0,0]){
				//echo("bottom");
				//translate(v=[0,0,-box_h/2])rotate(a=[0,180,0])translate(v=[-(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") 		writecube(text_to_type,[x_pos,y_pos,0],box_h-2*box_t[2],face="bottom", t=depth,h=text_height,space=text_spacing, rotate=rotation, font="orbitron.dxf");//translate(v=[0,0,-depth/2-box_t[2]]) rotate(a=[0,0,rotation]) make_shape(text_to_type, shape_data);
					else if (align=="outside") 	writecube(text_to_type,[x_pos,y_pos,0],box_h,face="bottom", t=depth,h=text_height,space=text_spacing, rotate=rotation, font="orbitron.dxf");// translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,rotation]) make_shape(text_to_type, shape_data);
					else echo("invalid alignment", align);
				//}
			}else{
				echo("Unknown Face",face);
			}
		}
	}
}

module make_items(box, items){//this will be based on make_cutouts
	//external items on faces [face_name, external_file, shape_position[x_pos,y_pos,x_offs,y_offs,rotate,align], shape_size[scale_z,scale_x,scale_y,mirror]] Note: for silly reasons mirror must be 0 or 1 corresponding to false and true in this version
	//["N", "tyndall_logo_v0_2.stl",			[0,0,0,0,0,"outside"], 					[1,1,1,0]]
	echo ("make_items");
	a_bit=0.01;
	box_l=box[0];//x
	box_b=box[1];//y
	box_h=box[2];//z
	box_t=[box[5],box[5],box[5]];//wall_t [x,y,z]

//%	cube(size=[box_l,box_b,box_h],center=true);

	x_pos = 0;
	y_pos = 0;
	face = "X";
	echo("len(items)",len(items));
	for (j=[0:len(items)-1]){
		assign (face = items[j][0], items_to_use=items[j][1], x_pos = items[j][2][0], y_pos = items[j][2][1], x_offs= items[j][2][2], y_offs= items[j][2][3], rotation=items[j][2][4], align=items[j][2][5], scale_z=items[j][3][3], scale_x=items[j][3][1], scale_y=items[j][3][2], items_mirror=items[j][3][4], depth=items[j][3][0]){
			//echo("items face",face);
			if (face=="N")mirror(v=[items_mirror,0,0]){
				translate(v=[0,box_b/2,0])rotate(a=[-90,0,0])translate(v=[-(x_pos+x_offs),-(y_pos+y_offs),0]){
					//echo("alignment", align);
					if (align=="inside") 		translate(v=[0,0,-box_t[1]]) rotate(a=[0,0,-rotation]) scale(v=[scale_x,scale_y,scale_z]) import(items_to_use);//
					else if (align=="outside") 	 translate(v=[0,0,-depth])   rotate(a=[0,0,-rotation]) scale(v=[scale_x,scale_y,scale_z]) import(items_to_use);//make_shape(item_to_use, shape_data);
					else echo("invalid alignment", align);
				}
			}else if (face=="E")mirror(v=[0,items_mirror,0]){
				translate(v=[box_l/2,0,0])rotate(a=[0,90,0])rotate(a=[0,0,-90])translate(v=[-(x_pos+x_offs),-(y_pos+y_offs),0]){
					//make_shape(item_to_use, shape_data);
					if (align=="inside") 		translate(v=[0,0,-box_t[0]]) rotate(a=[0,0,-rotation]) scale(v=[scale_x,scale_y,scale_z]) import(items_to_use);//writecube(item_to_use,[0,0,0],box_l-2*box_t[0],face="right", t=depth,h=items_height,space=items_spacing, rotate=rotation, font="orbitron.dxf"); //translate(v=[0,0,-depth/2-box_t[0]]) rotate(a=[0,0,-rotation]) make_shape(item_to_use, shape_data);
					else if (align=="outside") 	translate(v=[0,0,-depth]) rotate(a=[0,0,-rotation]) scale(v=[scale_x,scale_y,scale_z]) import(items_to_use);//writecube(item_to_use,[0,0,0],box_l,face="right", t=depth,h=items_height,space=items_spacing, rotate=rotation, font="orbitron.dxf");//translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,-rotation]) make_shape(item_to_use, shape_data);
					else echo("invalid alignment", align);
				}
			}else if (face=="T")mirror(v=[items_mirror,0,0]){
				//echo(face,align);
				translate(v=[0,0,box_h/2])rotate(a=[0,0,0])translate(v=[(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") 		translate(v=[0,0,-box_t[2]]) rotate(a=[0,0,-rotation]) scale(v=[scale_x,scale_y,scale_z]) import(items_to_use);//writecube(item_to_use,[0,0,0],box_h-2*box_t[2],face="top", t=depth,h=items_height,space=items_spacing, rotate=rotation, font="orbitron.dxf");//translate(v=[0,0,-depth/2-box_t[2]]) rotate(a=[0,0,-rotation]) make_shape(item_to_use, shape_data);
					else if (align=="outside") 	translate(v=[0,0,-depth]) rotate(a=[0,0,-rotation]) scale(v=[scale_x,scale_y,scale_z]) import(items_to_use);//writecube(item_to_use,[0,0,0],box_h,face="top", t=depth,h=items_height,space=items_spacing, rotate=rotation, font="orbitron.dxf");// translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,-rotation]) make_shape(item_to_use, shape_data);
					else echo("invalid alignment", align);
				}
			}else if (face=="S")mirror(v=[items_mirror,0,0]){
				translate(v=[0,-box_b/2,0])rotate(a=[+90,0,0])translate(v=[-(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") 		translate(v=[0,0,-box_t[1]]) rotate(a=[0,0,-rotation]) scale(v=[scale_x,scale_y,scale_z]) import(items_to_use);//writecube(item_to_use,[0,0,0],box_b-2*box_t[1],face="front", t=depth,h=items_height,space=items_spacing, rotate=rotation, font="orbitron.dxf");//translate(v=[0,0,-depth/2-box_t[1]]) rotate(a=[0,0,rotation]) make_shape(item_to_use, shape_data);
					else if (align=="outside") 	translate(v=[0,0,-depth]) rotate(a=[0,0,-rotation]) scale(v=[scale_x,scale_y,scale_z]) import(items_to_use);//writecube(item_to_use,[0,0,0],box_b,face="front", t=depth,h=items_height,space=items_spacing, rotate=rotation, font="orbitron.dxf");//translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,rotation]) make_shape(item_to_use, shape_data);
					else echo("invalid alignment", align);
				}
			}else if (face=="W")mirror(v=[0,items_mirror,0]){
				translate(v=[-box_l/2,0,0])rotate(a=[0,-90,0])rotate(a=[0,0,-90])translate(v=[-(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") 		translate(v=[0,0,-box_t[0]]) rotate(a=[0,0,-rotation]) scale(v=[scale_x,scale_y,scale_z]) import(items_to_use);//writecube(item_to_use,[0,0,0],box_l-2*box_t[0],face="left", t=depth,h=items_height,space=items_spacing, rotate=rotation, font="orbitron.dxf");//translate(v=[0,0,-depth/2-box_t[0]]) rotate(a=[0,0,rotation]) make_shape(item_to_use, shape_data);
					else if (align=="outside") 	translate(v=[0,0,-depth]) rotate(a=[0,0,-rotation]) scale(v=[scale_x,scale_y,scale_z]) import(items_to_use);//writecube(item_to_use,[0,0,0],box_l,face="left", t=depth,h=items_height,space=items_spacing, rotate=rotation, font="orbitron.dxf");//translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,rotation]) make_shape(item_to_use, shape_data);
					else echo("invalid alignment", align);
				}
			}else if (face=="B")mirror(v=[items_mirror,0,0]){
				//echo("bottom");
				translate(v=[0,0,-box_h/2])rotate(a=[0,180,0])translate(v=[-(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") 		translate(v=[0,0,-box_t[2]]) rotate(a=[0,0,-rotation]) scale(v=[scale_x,scale_y,scale_z]) import(items_to_use);//writecube(item_to_use,[0,0,0],box_h-2*box_t[2],face="bottom", t=depth,h=items_height,space=items_spacing, rotate=rotation, font="orbitron.dxf");//translate(v=[0,0,-depth/2-box_t[2]]) rotate(a=[0,0,rotation]) make_shape(item_to_use, shape_data);
					else if (align=="outside") 	translate(v=[0,0,-depth]) rotate(a=[0,0,-rotation]) scale(v=[scale_x,scale_y,scale_z]) import(items_to_use);//writecube(item_to_use,[0,0,0],box_h,face="bottom", t=depth,h=items_height,space=items_spacing, rotate=rotation, font="orbitron.dxf");// translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,rotation]) make_shape(text_to_type, shape_data);
					else echo("invalid alignment", align);
				}
			}else{
				echo("Unknown Face",face);
			}
		}
	}
}

module make_flanges(box,flange_t=2,pos_z=0,flange=[]){//box_x,box_y,box_z,box_r,box_s,wall_t, flange_t, slot_t,slot_w,flange_sides){
	//box_x,box_y,box_z,box_r,box_s,wall_t=box;
	a_bit=0.1;
	face=0;
	type="";
	pos_x=0;
	pos_y=0;
	flange_shape="";
	assign(x=box[0], y=box[1], box_z=box[2], z=flange_t, r=box[3], s=box[4], wall_t=box[5]){
		translate(v=[0,0,pos_z])difference(){
			hull(){
				//cross_box(x,y,z,r);//this is to ensure the overall dimensions stay true to those requested even for low-poly cylinders
				translate(v=[   x/2 -r ,   y/2 -r , 0])cylinder(h=z, r=r, center=true, $fn=4*s);
				translate(v=[   x/2 -r , -(y/2 -r), 0])cylinder(h=z, r=r, center=true, $fn=4*s);
				translate(v=[ -(x/2 -r), -(y/2 -r), 0])cylinder(h=z, r=r, center=true, $fn=4*s);
				translate(v=[ -(x/2 -r),   y/2 -r , 0])cylinder(h=z, r=r, center=true, $fn=4*s);//for 4 box corners
		
				for (j=[0:len(flange)-1]){
					assign(face=flange[j][0], type=flange[j][1], pos_x=flange[j][2][0], pos_y=flange[j][2][1], flange_shape=flange[j][3], flange_t=flange[j][3][0], flange_case_gap=flange[j][3][1], flange_wall_t=flange[j][3][2], slot_b=flange[j][3][3], slot_l=flange[j][3][4], flange_sides=flange[j][3][5]){
						// echo("face",face);
						// echo("type",type);
						// echo("flange_shape",flange_shape);
						// echo("xyzrs",x,y,z,r,s);
						// echo(x/2,slot_b/2,flange_case_gap, slot_l, slot_b , z, wall_t);
						if(type=="rounded_slot"){
							if(face=="N"){//North
								translate(v=[ -pos_x-(slot_l -slot_b)/2, y/2 +slot_b/2+flange_case_gap, 0])cylinder(h=z, r=(slot_b/2)+wall_t, center=true, $fn=4*flange_sides);
								translate(v=[ -pos_x+(slot_l -slot_b)/2,   y/2 +slot_b/2+flange_case_gap , 0])cylinder(h=z, r=(slot_b/2)+wall_t, center=true, $fn=4*flange_sides);
							}
							else if(face=="S") mirror(v=[0,1,0]){//south, mirror of above
								translate(v=[ -pos_x-(slot_l -slot_b)/2, y/2 +slot_b/2+flange_case_gap, 0])cylinder(h=z, r=(slot_b/2)+wall_t, center=true, $fn=4*flange_sides);
								translate(v=[ -pos_x+(slot_l -slot_b)/2,  y/2 +slot_b/2+flange_case_gap , 0])cylinder(h=z, r=(slot_b/2)+wall_t, center=true, $fn=4*flange_sides);
							}
							else if(face=="E"){//East
								//echo("East side",x/2 +slot_b/2+flange_case_gap,-(slot_l -slot_b)/2, z, (slot_b/2)+wall_t);
								translate(v=[ -(x/2 +slot_b/2+flange_case_gap), pos_x-(slot_l -slot_b)/2, 0])cylinder(h=z, r=(slot_b/2)+wall_t, center=true, $fn=4*flange_sides);
								translate(v=[ -(x/2 +slot_b/2+flange_case_gap), pos_x+(slot_l -slot_b)/2 , 0])cylinder(h=z, r=(slot_b/2)+wall_t, center=true, $fn=4*flange_sides);
							}
							else if(face=="W") mirror(v=[1,0,0]){//West
								translate(v=[ -(x/2 +slot_b/2+flange_case_gap), pos_x-(slot_l -slot_b)/2, 0])cylinder(h=z, r=(slot_b/2)+wall_t, center=true, $fn=4*flange_sides);
								translate(v=[ -(x/2 +slot_b/2+flange_case_gap),  pos_x+(slot_l -slot_b)/2 , 0])cylinder(h=z, r=(slot_b/2)+wall_t, center=true, $fn=4*flange_sides);
							}else{
								echo("unknown face",face);
							}
						}else{
							echo("unsupported type",type);
						}
					}
				}
			}
			//remove material for box hollow
			rounded_rectangle_cylinder_hull(x-2*wall_t,y-2*wall_t,box_z-2*wall_t,max(0,r-wall_t),s);
			//remove material for slots
				for (k=[0:len(flange)-1]){
					assign(face=flange[k][0], type=flange[k][1], pos_x=flange[k][2][0], pos_y=flange[k][2][1], flange_shape=flange[k][3], flange_t=flange[k][3][0], flange_case_gap=flange[k][3][1], flange_wall_t=flange[k][3][2], slot_b=flange[k][3][3], slot_l=flange[k][3][4], flange_sides=flange[k][3][5]){
					if(type=="rounded_slot"){
						if(face=="N")hull(){//East
							translate(v=[ -pos_x-(slot_l -slot_b)/2, y/2 +slot_b/2+flange_case_gap, 0])cylinder(h=z+a_bit, r=slot_b/2, center=true, $fn=4*s);
							translate(v=[ -pos_x+(slot_l -slot_b)/2, y/2 +slot_b/2+flange_case_gap, 0])cylinder(h=z+a_bit, r=slot_b/2, center=true, $fn=4*s);
						}
						else if(face=="S") hull(){
							mirror(v=[0,1,0]){
								translate(v=[ -pos_x-(slot_l -slot_b)/2, y/2 +slot_b/2+flange_case_gap, 0])cylinder(h=z+a_bit, r=slot_b/2, center=true, $fn=4*s);
								translate(v=[ -pos_x+(slot_l -slot_b)/2, y/2 +slot_b/2+flange_case_gap, 0])cylinder(h=z+a_bit, r=slot_b/2, center=true, $fn=4*s);
							}
						}else if(face=="E")hull(){//East
							translate(v=[ -(x/2 +slot_b/2+flange_case_gap), pos_x-(slot_l -slot_b)/2, 0])cylinder(h=z+a_bit, r=slot_b/2, center=true, $fn=4*s);
							translate(v=[ -(x/2 +slot_b/2+flange_case_gap), pos_x+(slot_l -slot_b)/2, 0])cylinder(h=z+a_bit, r=slot_b/2, center=true, $fn=4*s);
						}
						else if(face=="W") hull(){
							mirror(v=[1,0,0]){
								translate(v=[ -(x/2 +slot_b/2+flange_case_gap), pos_x-(slot_l -slot_b)/2, 0])cylinder(h=z+a_bit, r=slot_b/2, center=true, $fn=4*s);
								translate(v=[ -(x/2 +slot_b/2+flange_case_gap), pos_x+(slot_l -slot_b)/2, 0])cylinder(h=z+a_bit, r=slot_b/2, center=true, $fn=4*s);
							}
						}else{
							echo("unknown face",face);
						}
					}else{
						echo("unsupported type",type);
					}
				}
			}
		}
	}
}