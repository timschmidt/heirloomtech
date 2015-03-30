use <vwheel_single_bearing_b17001_rev_2.scad>;
use <makerslide.scad>;
use <carriage_plate_standard_c14005_rev_2.scad>;
use <misumi_2020.scad>;
use <misumi_2040.scad>;
use <skins.scad>;
PI=3.14159265358979323846;



// Specify the dimensions of the usable cutting envelope you need:

xtravel = 26.5 * 25.4; // The dims I need.
ytravel = 13.5 * 25.4; // Over-spec'd a bit.
ztravel =  2.5 * 25.4; // Millimeters.

// That's it. Configured. Hit F5.
// Check the console window for parts list with scaled dimensions.
// Check the display to see if everything really does line up.

// Set the folowing items to 1 or 0 to display or hide different 
// sections of the assembly. Probaly the first thing you want to
// turn off is the skins, to get a better look at everything
// else inside.

xy_gantry   = 1 ;
xbelt       = 1 ;
ybelts      = 1 ;
driveshafts = 1 ;
zsystem     = 1 ;
frame       = 1 ;
cover       = 1 ; cover_is_open = 1 ;
skins       = 1 ;
skins_flat  = 0 ; // hi-res 2D layout, for DXF export
                  //(disables rendering of everything else)
                  // press F6 for this one, then "Design"
                  // menu --> "Export as DXF".


///////////
// INTRO //
///////////

// This is a parametric three axis motion system
// based on Barton Dring's Buildlog.net Laser 2.0 design
// and MakerSlide V rail system.
// (www.buildlog.net) (www.makerslide.com)

// I've tried to identify all the parts that need to scale
// to adjust the cutting envelope. This script calculates
// the new dimensions required just for the parts that need
// to change, and lists those results in the console window. 
// Combine these results with the Laser 2.0 BOM at Buildlog.net
// to work up your parts orders for your own custom-sized machine.

// (To copy the text in the console, you might have to 
// right click --> Select All --> Copy.)

// The scaled skin panels can be rendered flat and exported as
// 2D DXF files, suitable for generating cut files for a CNC
// router, or patterns to print and cut by hand.

// Is it all correct? Will this really give a workable set of 
// scaled parts? Explore the model and consider it. I'm not
// making any claims - I can only attest to my intent. I'll
// be using it though, if I come up with money for a build soon.

// This work is Copyright 2011 by Michael Sheldrake
// and licensed under a Creative Commons Attribute-Share Alike 3.0 License
// http://creativecommons.org/licenses/by-sa/3.0/
// Thanks go to Barton Dring for releasing his designs under
// that same license.


////////////////////////////////
// SPECIFYING AXIS DIMENSIONS //
////////////////////////////////

// The Buildlog 2.0 Laser claims "just under" a 20"x12"x4" 
// working envelope (508mm x 304.8mm x 101.6mm).
// If you specify those dimensions here (in millimeters), the parts
// generated should match the dimensions in bdring's Laser 2.0
// drawings.

//xtravel = 508.0; // everything in millimeters
//ytravel = 304.8; // These are the Buildlog.net
//ztravel = 101.6; // Laser 2.0 standard dimensions.

////  DON'T GO TOO BIG  ///
// You want a 2'x2' system? 4'x4'? You can model that here.
// But don't count on that design to actually work.
// Maybe, though? Every extra inch makes it that much more 
// difficult to align and maintain rigity of the system.
// Surely the Laser 2.0 design can add a half inch here or
// there and work about as well. But 12"? Yards?
// Probably not, but it's fun to look and dream:

//xtravel = 1500; // Way too big,
//ytravel = 1500; // probably.
//ztravel = 2500; // Or is it?

////  DON'T GO TOO SMALL  ///
// ... because a laser tube and electronics won't fit in there.
// But if you're adapting the Laser 2.0 design to work as a
// plotter, or something else, here's a pretty small system:

//xtravel = 1; // We call this
//ytravel = 1; // "tugging the
//ztravel = 1; //    envelope".

// OpenSCAD FUN  //
// Animate the envelope - grow from 1x1x1 to standard Laser 2.0 size.
// Use OpenSCAD's Animate option in the View menu.
// (Normally animate just makes the x and y axes move.)
// (Make sure all other lines above that set
// xtravel, ytravel and ztravel are commented
// out before trying this animated version.)

//ztarg=101.6;
//xfact=508.0/ztarg;
//yfact=304.8/ztarg;
//xtravel = $t*ztarg * xfact;
//ytravel = $t*ztarg * yfact;
//ztravel = $t*ztarg;




/////////////////////////
// Constant Dimensions //
/////////////////////////
// Some frame dimensions don't change as we scale 
// the cutting envelope. These are candidates for
// becoming parameters too, but I didn't do all the 
// math with changing these in mind. So inspect
// results closely if you alter them.

beam_width      = 20;           // width of square aluminum extrusions
half_beam_width = beam_width/2; // handy
shaftmotorspan  = 82;           // stepper motor between two drive shafts
skinThickness   = 3;            // Alupanel, 3mm thick
control_space_X = 210;          // width of where electroncs go
tube_space_Y    = 80;           // space for laser tube behind cutting area
top_space_Z     = 140;          // parts above z=0 don't scale
wheel_plate_thk = 0.125*25.4;   // MakerSlide wheel plates / brackets, 1/8" Al
wheel_standoff  = 0.25 *25.4;   // 
wheel_center_off= 3;            // for single-bearing delrin vwheel
imperialFudge   = 1.95; // Gantry assembly v wheel center to v wheel center comes
                        // out to 728.05mm on ref design. Frame bars that seem to
					    // match that length don't - they're  730mm.
					    // So this little extra gets us even frame dims that match 
						// reference, based on a metric span of MakerSlide, and then 
						// plates and vwheels that have some imperial dimensions mixed in.


///////////////////////////
///  THE SCALING MATH   ///
///////////////////////////
// Here's the math to make the the Buildlog 2.0 reference dimensions adjustable,
//  xyz reference frame parts      -   travel you get from that  = base xyz vals to add your own desired travel dimensions to
// (x rail,y rail,frame height)    -   ( 12" ,  20"  ,  4"  )
// ( 703  , 560  ,   310      )    -   ( 508 , 304.8 , 101.6)    = ( 195 , 255.2 , 208.4 )

// Note that we snap up to next whole mm:

MakerSlideXLength = ceil( 195.0 + xtravel ); // Note that we snap
MakerSlideYLength = ceil( 255.2 + ytravel ); // up to next whole
FrameHeight       = ceil( 208.4 + ztravel ); // millimeter.

// similar for belts, except relative to roughly 1/2 belt length, since they loop
// original x,y = 60",40" (1524mm,1016mm); half: (762 , 508)
//(762 , 508) - ( 508 , 304.8 ) = ( 254 , 203.2)
BeltXLength = 2 * (254   + xtravel);
BeltYLength = 2 * (203.2 + ytravel);

// similar for Y drive shafts
// recently updated to 14" and 12"
// just split the difference of requested and reference ytravel between the shafts,
// but note that these shafts at McMaster mostly come in 2" increments (and 9 and 15, and not 22)
// original shaft sum - original xtravel
//     26"             -       20"          =  6"
shaftsum=ceil(6+(xtravel/25.4));               // inches here 
ShaftOneLength=25.4 * floor(shaftsum/2 + 1);   // longer shaft, back to mm
ShaftTwoLength=25.4 * ceil(shaftsum/2 - 1);    // short shaft - there's more space 
                                               // in assy to make this one longer

///////////////////////////////////
// Derived and Scaled Dimensions //
///////////////////////////////////

to_vwheel_center= wheel_plate_thk + wheel_standoff + wheel_center_off;
scaledX         = MakerSlideXLength + 2 * to_vwheel_center + imperialFudge;
halfScaledX     = scaledX/2;
halfScaledXPlus = halfScaledX + half_beam_width;
scaledY         = MakerSlideYLength;
halfScaledY     = scaledY/2;
halfScaledYPlus = halfScaledY + half_beam_width;
shortHalfScaledY= halfScaledY - tube_space_Y - beam_width; // not really a half of anything
scaledZDown     = FrameHeight - top_space_Z;
activeMakerSlideYLength = MakerSlideYLength - // this is just the portion that
	                      tube_space_Y -      // you would use if the beam didn't
                          beam_width;         // reach back in to the tube space
                                              // to the back of the machine
// and now ...






///////////////////////////////////
// RENDER THE SCALED SUBSECTIONS //
///////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
//                                                            ///
                                                              ///
if (skins_flat==1) {skins_flat();}
else {
if (xy_gantry==1)   xy_gantry();
if (xbelt==1)       xbelt(BeltXLength);
if (ybelts==1)      ybelts(BeltYLength);
if (driveshafts==1) driveshafts(ShaftOneLength,ShaftTwoLength);
if (zsystem==1)     zsystem();
if (frame==1)       frame();
if (cover==1)       cover(open=(cover_is_open==1));
if (skins==1)       skins();
}
                                                              ///
                                                              ///
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////







///////////////////////////
// MakerSlide components //
///////////////////////////
makerslide_color=[0.6,0.6,0.7];

// These two modules are not used
// for the laser design, but might 
// be useful for visualizing other
// non-laser concepts that use the
// standard MakerSlide wheel plates.

module wheel_plate_assy(flip=false) {
	wheelelevation= (flip ? -1 : 1) * to_vwheel_center;
	color([0.6,0.2,0.2]) rotate(a=180) translate([-55,-80,0])
		import_stl("standard_wheel_carriage_plate.stl", convexity = 5);
	translate([42.3, -70, wheelelevation]) vwheel();
	translate([42.3,  70, wheelelevation]) vwheel();
	translate([-22.3,  0, wheelelevation]) vwheel();
	}
module tool_carriage_assy() {
	wheelelevation= -(wheel_standoff + wheel_center_off);
	translate([0.6,0,beam_width + -wheelelevation]) {
	color([0.6,0.2,0.2]) translate([-80,45,0]) rotate([0,0,-90])
		import_stl("standard_wheel_carriage_plate.stl",convexity=5);
	translate([-32.663,0,wheelelevation]) rotate([180,0,0]) vwheel();
	translate([32.3,-32.3,wheelelevation]) rotate([180,0,0]) vwheel();
	translate([32.3, 32.3,wheelelevation]) rotate([180,0,0]) vwheel();
	}
	}

// These three modules bring in the laser-specific
// MakerSlide plates for the gantry assembly.

module left_bracket_assy() {
	color([0.6,0.2,0.2]) import_stl("gantry_end_bracket_left_rev4_mm.stl", convexity = 10);
	// Warning:
	// The bracket plus the first wheel alone, cause OpenSCAD to crash on CGAL render.
	// That region of the bracket is like a Bermuda Triangle for CGAL.
	// There should be no need to CGAL-render this assembly, but if you do,
	// comment out this first wheel.
	translate([10 + 0.315 * 25.4        , -10 - 0.719 * 25.4 ,  to_vwheel_center]) vwheel();
	translate([10 + 0.315 * 25.4        ,  10 + 1.574 * 25.4 ,  to_vwheel_center]) vwheel();
	translate([10 - 2.221 * 25.4 - 0.94 ,  10 - 0.01  * 25.4 ,  to_vwheel_center]) vwheel();
	}
module right_bracket_assy() {
	color([0.6,0.2,0.2]) import_stl("gantry_end_bracket_right_rev_3_mm.stl", convexity = 5);
	translate([10 + 0.315 * 25.4        , -10 - 0.719 * 25.4 , -to_vwheel_center]) rotate([180,0,0]) vwheel();
	translate([10 + 0.315 * 25.4        ,  10 + 1.574 * 25.4 , -to_vwheel_center]) rotate([180,0,0]) vwheel();
	translate([10 - 2.221 * 25.4 - 0.94 ,  10 + 0.236 * 25.4 , -to_vwheel_center]) rotate([180,0,0]) vwheel();
	}
module laser_carriage_assy() {
	wheelelevation= -(wheel_standoff + wheel_center_off);
	translate([0.6,0,20 + -wheelelevation]) {
	color([0.2,0.2,0.2]) rotate([0,0,-90]) import_stl("laser_carriage_plate_rev_4_mm.stl",convexity=5);
	translate([ 32.163        , -34.925 , wheelelevation]) rotate([180,0,0]) vwheel();
	translate([ 32.163        ,  34.925 , wheelelevation]) rotate([180,0,0]) vwheel();
	translate([-32.663 - 0.94 ,  0      , wheelelevation]) rotate([180,0,0]) vwheel();
	}
	}

// Gantry assembly from wheel plates above and a piece of MakerSlide V rail extrusion.
module gantry(xref=400) {
	echo(str("GANTRY"));
	echo(str("    MakerSlide:  1 x ",MakerSlideXLength,"mm  (",(MakerSlideXLength/25.4),"in)"));
	translate([0,0,25])
	rotate([0,0,-90])
	rotate([-90,-90,0]) {
		color(makerslide_color) makerslide(xref - 0.02); // minus 0.02 to avoid co-planar display glitches with end plates
		translate([0,0, xref/2]) left_bracket_assy();
		translate([0,0,-xref/2]) right_bracket_assy();
		// you might use these standard plates instead, for a non-laser assembly
		//translate([0,0, xref/2]) wheel_plate_assy();
		//translate([0,0,-xref/2]) wheel_plate_assy(flip=true);
		}
	rotate([0,0,-90])
	translate([0,sin(2*$t*360) * (xref/2 - 85),25]) { // for optional animation
		//tool_carriage_assy(); // standard plate option
		laser_carriage_assy();
		}
	}

// Gantry, with two pieces of MakerSlide to ride on.
// Note the belt model thrown in, so it can ride with the gantry when animated.
module xy_gantry() {
	animlowy     = -MakerSlideYLength/2 + 80;
	animhalfspan = (MakerSlideYLength - (tube_space_Y+beam_width) - 160)/2;
	translate([-imperialFudge/2,0,0]) { // to align the whole thing with the frame assembly
		translate([0,(animlowy+animhalfspan)+sin(180+$t*360)*animhalfspan,0]) { // for animation
			gantry(MakerSlideXLength);
			}
		echo(str("    MakerSlide:  2 x ",MakerSlideYLength,"mm  (",(MakerSlideYLength/25.4),"in)"));
		translate([-(MakerSlideXLength/2 + beam_width + to_vwheel_center),0,half_beam_width]) rotate([-90,0,0])   color(makerslide_color) makerslide(MakerSlideYLength);
		translate([ (MakerSlideXLength/2 + beam_width + to_vwheel_center),0,half_beam_width]) rotate([-90,0,180]) color(makerslide_color) makerslide(MakerSlideYLength);
		}
	}


///////////////////////////
//   Misumi components   //
///////////////////////////
module frame(xref=MakerSlideXLength,yref=MakerSlideYLength,zref=FrameHeight) {

	echo(str("FRAME"));
	echo(str("    Misumi 2040:"));

	d30027r3_9_length = scaledX + control_space_X + beam_width;
	d30027r3_9_partno = str("HFS5-2040-",d30027r3_9_length);
	d30027r3_9_count  = 2;
	echo(str("        ",d30027r3_9_count," x ",d30027r3_9_partno,"    ",d30027r3_9_length,"mm  (",(d30027r3_9_length/25.4),"in)"));
	for(i=[
		[-halfScaledX           , halfScaledYPlus     ,   0],
		[-halfScaledX           ,-halfScaledYPlus     ,   0],
	]) {
		translate(i) translate([0,0,half_beam_width]) rotate([0,90,0]) misumi_2040( d30027r3_9_length );
		}

	echo(str("    Misumi 2020:"));

	d30027r3_4_length = zref;
	d30027r3_4_partno = str("HFS5-2020-",d30027r3_4_length);
	d30027r3_4_count  = 4;
	echo(str("        ",d30027r3_4_count," x ",d30027r3_4_partno,"    ",d30027r3_4_length,"mm  (",(d30027r3_4_length/25.4),"in)"));
	for(i=[
		[-halfScaledXPlus                                , halfScaledYPlus     ,-scaledZDown],
		[-halfScaledXPlus                                ,-halfScaledYPlus     ,-scaledZDown],
		[ halfScaledXPlus + control_space_X + beam_width , halfScaledYPlus     ,-scaledZDown],
		[ halfScaledXPlus + control_space_X + beam_width ,-halfScaledYPlus     ,-scaledZDown]
	]) {
		translate(i)                                                   misumi_2020(d30027r3_4_length);
		}

	d30027r3_8_length = scaledX + control_space_X + beam_width;
	d30027r3_8_partno = str("HFS5-2020-",d30027r3_8_length);
	d30027r3_8_count  = 3;
	echo(str("        ",d30027r3_8_count," x ",d30027r3_8_partno,"    ",d30027r3_8_length,"mm  (",(d30027r3_8_length/25.4),"in)"));
	for(i=[
		[-halfScaledX          ,-halfScaledYPlus      ,-scaledZDown],
		[-halfScaledX          , halfScaledYPlus      ,-scaledZDown],
		[-halfScaledX          , halfScaledYPlus      , top_space_Z - beam_width],
	]) {
		translate(i) translate([0,0,half_beam_width]) rotate([0,90,0]) misumi_2020( d30027r3_8_length );
		}

	d30027r3_6_length = scaledX;
	d30027r3_6_partno = str("HFS5-2020-",d30027r3_6_length);
	d30027r3_6_count  = 3;
	echo(str("        ",d30027r3_6_count," x ",d30027r3_6_partno,"    ",d30027r3_6_length,"mm  (",(d30027r3_6_length/25.4),"in)"));
	for(i=[
		[-halfScaledX           ,-halfScaledYPlus                            , top_space_Z - 2*beam_width],
		[-halfScaledX           , halfScaledYPlus - (tube_space_Y+beam_width),-scaledZDown],
		[-halfScaledX           , halfScaledYPlus - (tube_space_Y+beam_width), top_space_Z - beam_width],
	]) {
		translate(i) translate([0,0,half_beam_width]) rotate([0,90,0]) misumi_2020( d30027r3_6_length );
		}

	d30027r3_notshown_length = scaledX - 5;
	d30027r3_notshown_partno = str("HFS5-2020-",d30027r3_notshown_length);
	d30027r3_notshown_count  = 1;
	echo(str("        ",d30027r3_notshown_count," x ",d30027r3_notshown_partno,"    ",d30027r3_notshown_length,"mm  (",(d30027r3_notshown_length/25.4),"in)"));
	for(i=[
		[-halfScaledX           ,halfScaledYPlus - (tube_space_Y+beam_width), half_beam_width],
	]) {
		translate(i) translate([0,0,half_beam_width]) rotate([0,90,0]) misumi_2020( d30027r3_notshown_length );
		}

	d30027r3_5_length = yref;
	d30027r3_5_partno = str("HFS5-2020-",d30027r3_5_length);
	d30027r3_5_count  = 7; // drawing shows 6, coming revision has one more
	echo(str("        ",d30027r3_5_count," x ",d30027r3_5_partno,"    ",d30027r3_5_length,"mm  (",(d30027r3_5_length/25.4),"in)"));
	for(i=[
		[-halfScaledXPlus                                , halfScaledY         ,-scaledZDown],
		[-halfScaledXPlus                                , halfScaledY         , top_space_Z-beam_width],
		[ halfScaledXPlus                                , halfScaledY         ,-scaledZDown],
		[ halfScaledXPlus                                , halfScaledY         , top_space_Z-beam_width],
		[ halfScaledXPlus + control_space_X + beam_width , halfScaledY         ,-scaledZDown],
		[ halfScaledXPlus + control_space_X + beam_width , halfScaledY         , half_beam_width],
		[ halfScaledXPlus + control_space_X + beam_width , halfScaledY         , top_space_Z-beam_width]
	]) {
		translate(i) translate([0,0,half_beam_width]) rotate([90,0,0]) misumi_2020(d30027r3_5_length);
		}

	d30027r3_3_length = control_space_X + beam_width;
	d30027r3_3_partno = str("HFS5-2020-",d30027r3_3_length);;
	d30027r3_3_count  = 1;
	echo(str("        ",d30027r3_3_count," x ",d30027r3_3_partno,"    ",d30027r3_3_length,"mm  (",(d30027r3_3_length/25.4),"in)"));
	translate([halfScaledX,-halfScaledYPlus, top_space_Z-half_beam_width]) rotate([0,90,0]) misumi_2020( d30027r3_3_length );

	d30027r3_7_length = top_space_Z - beam_width - beam_width - half_beam_width;
	d30027r3_7_partno = str("HFS5-2020-",d30027r3_7_length);
	d30027r3_7_count  = 1;
	echo(str("        ",d30027r3_7_count," x ",d30027r3_7_partno,"    ",d30027r3_7_length,"mm  (",(d30027r3_7_length/25.4),"in)"));
	translate([halfScaledXPlus,-halfScaledYPlus,3*half_beam_width]) misumi_2020( d30027r3_7_length );

	d30027r3_2_length = scaledZDown - half_beam_width;
	d30027r3_2_partno = str("HFS5-2020-",d30027r3_2_length);
	d30027r3_2_count  = 1;
	echo(str("        ",d30027r3_2_count," x ",d30027r3_2_partno,"    ",d30027r3_2_length,"mm  (",(d30027r3_2_length/25.4),"in)"));
	translate([half_beam_width,halfScaledYPlus - (tube_space_Y+beam_width),-scaledZDown + 2*half_beam_width]) misumi_2020( d30027r3_2_length );


	}


/////////////////////
//  cover, or lid  //
/////////////////////

module cover(open=false) {
	lidSideGap  = 2.5; //mm
	lidHingeGap = 0;   //mm, maybe up to 1mm , based on Misumi hinge drawing
	lidYPartLength=scaledY - tube_space_Y -  2*beam_width;
	echo(str("COVER"));

	d30013r3_8_length = scaledX - 2 * lidSideGap;
	d30013r3_8_partno = str("HFS5-2020-",d30013r3_8_length);
	d30013r3_8_count  = 2;
	echo(str("        ",d30013r3_8_count," x ",d30013r3_8_partno,"    ",d30013r3_8_length,"mm  (",(d30013r3_8_length/25.4),"in)"));

	d30013r3_7_length = lidYPartLength;
	d30013r3_7_partno = str("HFS5-2020-",d30013r3_7_length);
	d30013r3_7_count  = 2;
	echo(str("        ",d30013r3_7_count," x ",d30013r3_7_partno,"    ",d30013r3_7_length,"mm  (",(d30013r3_7_length/25.4),"in)"));

	// cover window panel 
	echo(str("COVER WINDOW PANEL"));
	echo(str("        ",(2 * (halfScaledX - lidSideGap)),"mm x ",(lidYPartLength+2*beam_width),"mm  (",((2 * (halfScaledX - lidSideGap))/25.4),"in x ",((lidYPartLength+2*beam_width)/25.4),"in)"));

	ot=[0,-shortHalfScaledY,-top_space_Z-5];
	or=[-92*(open?1:0),0,0];
	translate(-1*ot) rotate(or) translate(ot) {
	for(i=[
		[-halfScaledX + lidSideGap           , shortHalfScaledY - half_beam_width - lidHingeGap - beam_width - lidYPartLength, top_space_Z-beam_width],
		[-halfScaledX + lidSideGap           , shortHalfScaledY - half_beam_width - lidHingeGap, top_space_Z-beam_width],
	]) {
		translate(i) translate([0,0,half_beam_width]) rotate([0,90,0]) misumi_2020( d30013r3_8_length );
		}
	for(i=[
		[-(halfScaledXPlus - 2*half_beam_width - lidSideGap) , shortHalfScaledY - beam_width - lidHingeGap , top_space_Z-beam_width],
		[ (halfScaledXPlus - 2*half_beam_width - lidSideGap) , shortHalfScaledY - beam_width - lidHingeGap , top_space_Z-beam_width],
	]) {
		translate(i) translate([0,0,half_beam_width]) rotate([90,0,0]) misumi_2020( d30013r3_7_length );
		}
	color([0.7,0.7,1.0,0.5]) translate([-halfScaledX + lidSideGap,-halfScaledY - beam_width - lidHingeGap ,top_space_Z]) cube([(2 * (halfScaledX - lidSideGap)),(lidYPartLength+2*beam_width),skinThickness]);
	}
	}


///////////////////////////
//  gantry timing belts  //
///////////////////////////
module xbelt(beltlength=20) {
	echo(str("    EconoBelt:   1 x ",beltlength,"mm (cut)  (",ceil(beltlength/25.4),"in, rounded up)"));
	animlowy     = -MakerSlideYLength/2 + 80;
	animhalfspan = (MakerSlideYLength - (tube_space_Y+beam_width) - 160)/2;
	translate([-imperialFudge/2,(animlowy+animhalfspan)+sin(180+$t*360)*animhalfspan,0]) { // animation - should correspond to gantry motion
		translate([-MakerSlideXLength/2 + 4,35,65]) rotate([90,0,0]) belt(beltlength);
		}
	}
module ybelts(beltlength=20) {
	echo(str("    EconoBelt:   2 x ",beltlength,"mm (cut) (",ceil(beltlength/25.4),"in, rounded up)"));
	translate([-MakerSlideXLength/2 + 5                ,(MakerSlideYLength)/2-55,-34]) rotate([90,0,-90]) belt(beltlength);
	translate([ MakerSlideXLength/2 - 5 - imperialFudge,(MakerSlideYLength)/2-55,-34]) rotate([90,0,-90]) belt(beltlength);
	}
module belt(ref) {
	geardiam=25.4 * 0.489; //0.489" OD, but that might be for flange?
	beltwidth=25.4/4;
	beltthick=25.4/16;
	halflength=ref/2;
	gearcenter=(ref - (PI * geardiam)) / 2;
	color([0.2,0.2,0.2])
	difference() {
		intersection() {
			union() {
				cylinder(r=geardiam/2,h=beltwidth*1.1,center=true);
				translate([gearcenter,0,0]) cylinder(r=geardiam/2,h=beltwidth*1.1,center=true);
				translate([0,-geardiam/2,-beltwidth*1.11/2]) cube([gearcenter,geardiam,beltwidth*1.11],center=false);
				}
			translate([(gearcenter + geardiam*2.2)/2 - geardiam,0,0]) cube([gearcenter + geardiam*2.2,geardiam*2.2,beltwidth],center=true);
			}
		union() {
			translate([0,0,0]) cylinder(r=geardiam/2 - beltthick,h=beltwidth*1.2,center=true);
			translate([gearcenter,0,0]) cylinder(r=geardiam/2-beltthick,h=beltwidth*1.2,center=true);
			translate([0,-(geardiam-2*beltthick)/2,-beltwidth*1.12/2]) cube([gearcenter,geardiam-2*beltthick,beltwidth*1.21],center=false);
			}

		}
	}


///////////////////////
//  y drive shafts  //
//////////////////////

module driveshafts(shaftlengthone=14*25.4,shaftlengthtwo=12*25.4) {
	echo(str("   (shaft src):   1 x ",ShaftOneLength,"mm  (",(ShaftOneLength/25.4),"in)"));
	echo(str("   (shaft src):   1 x ",ShaftTwoLength,"mm  (",(ShaftTwoLength/25.4),"in)"));
	translate([-12.525,MakerSlideYLength/2 - (tube_space_Y+beam_width) + half_beam_width + 32.766,-34]) {
		translate([-MakerSlideXLength/2,0,0]) driveshaft(shaftlengthone);
		translate([-MakerSlideXLength/2+shaftlengthone+shaftmotorspan,0,0]) driveshaft(shaftlengthtwo);
		}
	}
module driveshaft(length=254) {
	color([0.35,0.35,0.4]) rotate([0,90,0]) cylinder(r=25.4*0.125,h=length,center=false);
	}


///////////////////////////////////////
//  z table, leadscrews, drive belt  //
///////////////////////////////////////
module zsystem() {

	// z table frame - ref is 580 wide, with 370s butting
	halfZsX = halfScaledX - 100;
	halfZsOtherX = halfScaledX - 50; // from original specs, where 730 - (580 + 100) = right side spacing of z table = 50
	zXSpan=halfZsOtherX + halfZsX;
	zYGap=25;//from original specs, where[ (halfScaledY + (halfScaledYPlus - 100 - half_beam_width)) - (370+2*20) ] * 0.5 = gap 
			//[ (280 + (290 - 100 - 10)) - (370+2*20)  ] * 0.5 = gap = (460 - 410)  *0.5 = 25 = nice.
	zYSpan=(halfScaledY + (halfScaledYPlus - (tube_space_Y+beam_width) - half_beam_width)) - 2*zYGap;
	echo(str("Z TABLE"));

	d30014r2_4_length = zXSpan;
	d30014r2_4_partno = str("HFS5-2020-",d30014r2_4_length);
	d30014r2_4_count  = 2;
	echo(str("        ",d30014r2_4_count," x ",d30014r2_4_partno,"    ",d30014r2_4_length,"mm  (",(d30014r2_4_length/25.4),"in)"));
	for(i=[
		[-halfZsX           , -halfScaledY + half_beam_width + zYGap                          , -scaledZDown/6],
		[-halfZsX           ,-(halfScaledY-half_beam_width - zYGap) + zYSpan - 2*half_beam_width , -scaledZDown/6],
	]) {
		translate(i) translate([0,0,half_beam_width]) rotate([0,90,0]) misumi_2020( d30014r2_4_length );
		}

	d30014r2_3_length = zYSpan-2*beam_width;
	d30014r2_3_partno = str("HFS5-2020-",d30014r2_3_length);
	d30014r2_3_count  = 2;
	echo(str("        ",d30014r2_3_count," x ",d30014r2_3_partno,"    ",d30014r2_3_length,"mm  (",(d30014r2_3_length/25.4),"in)"));
	for(i=[
		[-(halfZsX - half_beam_width)      , -(halfScaledY - zYGap) + zYSpan - 2*half_beam_width       , -scaledZDown/6],
		[(halfZsOtherX - half_beam_width)      , -(halfScaledY - zYGap) + zYSpan - 2*half_beam_width       ,  -scaledZDown/6],
	]) {
		translate(i) translate([0,0,half_beam_width]) rotate([90,0,0]) misumi_2020( d30014r2_3_length );
		}


	// z table panel 
	echo(str("Z TABLE PANEL"));
	echo(str("        1 x C19010 ",zXSpan,"mm x ",zYSpan,"mm  (",(zXSpan/25.4),"in x ",(zYSpan/25.4),"in)"));
	// (not shown)

	// z lead screws
	zLeadScrewHeight=scaledZDown - 2*half_beam_width + (11/16)*25.4 +  3*half_beam_width + 5.7375;
	echo(str("Z LEADSCREWS"));

	B18009_0800_length = zLeadScrewHeight;
	B18009_0800_partno = str("B18009-xxxx (0.25in,20tpi threaded rod)");
	B18009_0800_count  = 3;
	echo(str("        ",B18009_0800_count," x ",B18009_0800_partno,"    ",B18009_0800_length,"mm  (",(B18009_0800_length/25.4),"in)"));
	for(i=[
		[-halfZsX + zXSpan*(85/580) , -halfScaledY + half_beam_width       ,0],
		[-halfZsX + zXSpan*(435/580), -halfScaledY + half_beam_width       ,0],
		[-halfZsX + zXSpan*(435/580), (halfScaledY - half_beam_width) - (tube_space_Y+beam_width),0],
	]) {
		translate(i) translate([0,0,-scaledZDown+(2*half_beam_width - (11/16)*25.4)]) color([0.3,0.3,0.5]) cylinder(r=25.4/8,h=B18009_0800_length,center=false);
		}

	B18009_1000_length = zLeadScrewHeight+(2*25.4);
	B18009_1000_partno = str("B18009-xxxx (0.25in,20tpi threaded rod)");
	B18009_1000_count  = 1;
	echo(str("        ",B18009_1000_count," x ",B18009_1000_partno,"    ",B18009_1000_length,"mm  (",(B18009_1000_length/25.4),"in)"));
	for(i=[
		[-halfZsX + zXSpan*(85/580) , (halfScaledY - half_beam_width) - (tube_space_Y+beam_width),0],
	]) {
		translate(i) translate([0,0,-scaledZDown+(2*half_beam_width - (11/16)*25.4)]) color([0.3,0.3,0.5]) cylinder(r=25.4/8,h=B18009_1000_length,center=false);
		}
		
	//z belt - belt display is more approximate than actual length calculation
	beltthick=1.14;//mm
	pd=0.48*25.4 + beltthick;
	pext=PI*pd;
	zby1=(((halfScaledY - half_beam_width) - (tube_space_Y+beam_width)) + (halfScaledY - half_beam_width)); //yspans
	zby2=zby1;
	zbx1=(zXSpan*(435/580) - zXSpan*(85/580)); // straight xspan
	zbx2=sqrt(pow(30,2)+pow(pd,2)) + sqrt( pow( (zXSpan*(435/580) - zXSpan*(85/580)) - 30 , 2 ) + pow(pd,2)); // xspan with slack for tensioner
	zbl = zby1 + 
	          zby2 +
              zbx1 + 
              zbx2 +
              pext // extra around corners of pulleys
              ;

	echo(str("Z CLOSED BELT"));
	B28035_length = zbl;
	B28035_partno = str("B28035 (loop timing belt)");
	B28035_count  = 1;
	echo(str("    EconoBelt:   ",B28035_count," x ",B28035_partno," : close to ",B28035_length,"mm  (~",(round(10*B28035_length/25.4)/10),"in, rounded)"));
	color([0.2,0.2,0.2])
	translate([(zbx1+pd)/2 + (-halfZsX + zXSpan*(85/580))  - pd/2,- ((zby1+pd)/2 + (-(halfScaledY - half_beam_width)+ (tube_space_Y+beam_width)) - pd/2),-scaledZDown+5.5/16*25.4]) {
		difference() {
			difference() {
				cube([zbx1+pd,zby1+pd,25.4/4],center=true);
				translate([-(zbx1+pd)/2 + 30+pd,(zby1+pd)/2 - pd,-25.4/4.5]) 
				 rotate([0,0,90 - atan2(0.48*25.4,30)]) 
				  cube([zbx1+pd,zby1+pd,25.4/2]);
				translate([-(zbx1+pd)/2 + 30+pd,(zby1+pd)/2 - pd,-25.4/4.5]) 
				 rotate([0,0,90 - atan2( (zXSpan*(435/580) - zXSpan*(85/580)) - 30 ,0.48*25.4)]) 
				  cube([zbx1+pd,zby1+pd,25.4/2]);
				}
			difference() {
				cube([zbx1+pd-4,zby1+pd-4,25.4/2],center=true);
				translate([-(zbx1+pd+4)/2 + 30+pd,(zby1+pd-4)/2 - pd,-25.4/4.5]) 
				 rotate([0,0,90 - atan2(0.48*25.4,30)]) 
				  cube([zbx1+pd,zby1+pd,25.4/2]);
				translate([-(zbx1+pd+4)/2 + 30+pd,(zby1+pd-4)/2 - pd,-25.4/4.5]) 
				 rotate([0,0,90 - atan2((zXSpan*(435/580) - zXSpan*(85/580)) - 30,0.48*25.4)]) 
				  cube([zbx1+pd,zby1+pd,25.4/2]);
				}
			}
		}
	}

///////////////////////
//  skins           //
//////////////////////
module skins(xref=MakerSlideXLength,yref=MakerSlideYLength,zref=FrameHeight,skinThickness=skinThickness) {

	S_L = -2 + beam_width + scaledX + beam_width + control_space_X + beam_width;
	S_W = -2 + yref + beam_width + beam_width;
	S_H = -2 + zref;
	
	//echo(str("SKIN DIMS LxWxH: ",S_L," x ",S_W," x ",S_H)); // s/b 998 x 598 x 308 for reference design

	color([0.25,0.30,0.45]) {

	translate([1 + -halfScaledX-2*half_beam_width,-halfScaledY-2*half_beam_width,1 + -scaledZDown])
		rotate([90,0,0]) 
		linear_extrude(height=skinThickness) 
		skin_front(S_L,S_H);
	translate([1 + -halfScaledX-2*half_beam_width + S_L,halfScaledY+2*half_beam_width,1 + -scaledZDown])
		rotate([90,0,180]) 
		linear_extrude(height=skinThickness) 
		skin_back(S_L,S_H);
	translate([1 + -halfScaledX-2*half_beam_width + S_L-1,-halfScaledY-2*half_beam_width + 1,1 + -scaledZDown])
		rotate([90,0,90]) 
		linear_extrude(height=skinThickness) 
		skin_side(S_W,S_H);
	translate([1 + -halfScaledX-2*half_beam_width -1   , halfScaledY+2*half_beam_width - 1,1 + -scaledZDown])
		rotate([90,0,-90]) 
		linear_extrude(height=skinThickness) 
		skin_side(S_W,S_H);
	translate([1 + -halfScaledX-2*half_beam_width,1 + -halfScaledY-2*half_beam_width,-scaledZDown-skinThickness])
		linear_extrude(height=skinThickness) 
		skin_bottom(S_L,S_W);	
	translate([ -halfScaledX-2*half_beam_width , halfScaledY - 99,zref-scaledZDown])
		linear_extrude(height=skinThickness) 
		skin_top_back(S_L,S_W);	
	translate([1 + -halfScaledX-2*half_beam_width + S_L ,1 + -halfScaledY-2*half_beam_width,zref-scaledZDown])
		rotate([0,0,90])
		linear_extrude(height=skinThickness) 
		skin_top_right(S_W);	
	translate([1 + -halfScaledX-2*half_beam_width + 18,1 + -halfScaledY-2*half_beam_width,zref-scaledZDown])
		rotate([0,0,90])
		linear_extrude(height=skinThickness) 
		skin_top_left(S_W);
	}
	}

//////////////////////////////////
//  skins for DXF - 2D layout   //
//////////////////////////////////
module skins_flat(xref=MakerSlideXLength,yref=MakerSlideYLength,zref=FrameHeight) {

	// Turn up the resolution on this one
	$fa=2;
	$fs=0.2;
	echo("\nCGAL RENDER MIGHT TAKE A FEW MINUTES\n(resolution turned up to get smooth circles)\n");
	
//!linear_extrude(height=10) cable_slot();
	S_L = -2 + beam_width + scaledX + beam_width + control_space_X + beam_width;
	S_W = -2 + yref + beam_width + beam_width;
	S_H = -2 + zref;
	
	//echo(str("SKIN DIMS LxWxH: ",S_L," x ",S_W," x ",S_H)); // s/b 998 x 598 x 308 for reference design

	margin=25.4;

	color([0.25,0.30,0.45]) {
	

	skin_bottom(S_L,S_W);	
	translate([0,S_W + margin + 0 * (S_H + margin)]) 2D_stack_layout(S_H + margin) {
		skin_front(S_L,S_H);
		skin_back(S_L,S_H);
		skin_side(S_W,S_H);
		skin_side(S_W,S_H);
		skin_top_back(S_L,S_W);	
		skin_top_right(S_W);	
		skin_top_left(S_W);
		}
	}
	}

module 2D_stack_layout(step) {for (i=[0:$children-1]) {translate([0,i*step]) child(i);}}
