//
// PARAMETRIC CURTAIN ROD HOLDER, V1.0
// FMMT666(ASkr) 05/2014
//

//
// A purely functional, angled holder for a curtain rod.
//
// Can be mounted to a wall with two screws.
// The curtain rod can either be fixed with a zip-tie or a screw (or both).
//


//
// All units in [mm].
//

// ===============================================================================
// holder parameters
hdWidth =               15.0;  // width of the holder
hdThick =                7.0;  // thickness of the holder
hdLengthBot =           50.0;  // length of the bottom part with holes
hdLengthTop =           70.0;  // length of the top part (from bend to center of rod)
hdAngleTop =            30.0;  // angle of top part in degree
hdChamfLen =             2.0;  // chamfer the edges this long; 0 means off

// ===============================================================================
// clamp parameters
clDiaIn =               11.5;  // inner diameter of the clamp (rod diameter + spacing)
clOffset =               0.0;  // cut less (>0) or more (<0) away from the top of the clamp (*1*)
clDia =  clDiaIn + 2*hdThick;  // adjust outer diameter to match thickness (*2*)

// ===============================================================================
// screw hole parameters (wall mount)
scDia =                  4.0;  // diameter of the holes for the two screws
scDist =                22.0;  // distance of the two holes
scExtraZ =               0.0;  // extra height offset of screw holes (>0 means up)
scDiaHead =              7.3;  // diameter of the screw's head + ~0.5
scAngleCSink =          90.0;  // screw countersink angle in degree (usually 90°)

// ===============================================================================
// zip-tie parameters
ztUseZip =               1;    // turn zip-tie cutout on/off (1/0)
ztWidth =                4.0;  // length of the slot for the zip-tie (zip-tie's width)
ztThick =                2.5;  // width of the slot for the zip-tie (zip-tie's thickness)

// ===============================================================================
// rod clamp screw hole
shUseScrew =             1;    // turn ros clamp screw hole on/off (1/0)
shDia =                  3.0;  // diameter of the hole
shAngle =               10.0;  // angle of hole in degrees; 0° = bottom, 90° = front

//
// (*1*)
//   Usually 0.
//   A positive value will move the invisible part, the one that cuts off the top
//   of the clamp, up. Hence, the clamp will be a little more "closed".
//   A value larger than the radius of the clamp will leave the clamp as a ring.
//   A negative value will do the opposite, but this does probably not make sense.
//
//  (*2*)
//    As is, the outer diameter is automatically calculated to match the given
//    thickness (hdThick) of the holder:
//      clDia =  clDiaIn + 2 * hdThick;
//    If you like a different diameter, just put it in there:
//      clDia =  30.5;
//

// ===============================================================================
// PRINT/EDIT PART
//
//   1 = EDIT       -> use this to edit/tune the holder
//   2 = TEST PRINT -> very small print to check clamp diameter
//   3 = REAL PRINT -> use this to export the STL model
//

PRINTPART = 1;




// ===============================================================================
// ===============================================================================
// ===============================================================================
// NO CHANGES BELOW HERE (HOPEFULLY =)
CP = 100;  // "CYLINDER PRECISION" (resolution) for other cylinders

// ===============================================================================


if( PRINTPART == 1 )
{
  Holder( 1 );
}
else if( PRINTPART == 2)
{
  difference()
  {
    translate([ -cos(hdAngleTop) * hdLengthTop, sin(hdAngleTop) * hdLengthTop, -hdWidth/2 ])
    rotate([90,0,0])
    Holder( 0 );
    
    translate([0,0,-clDia*3/2])
    cube( clDia*3, center = true );
  }
}
else
{
  rotate([90,0,0])
  Holder( 1 );
}


 
// ===============================================================================
// === PART
module Holder( doAll )
{
  difference()
  {
    union()
    {
      rotate([ 0, -hdAngleTop, 0 ])
      {
        // the clamp
        translate([ hdLengthTop,0,0 ])
        Clamp();

        if( doAll )
        {
          // top part
          cube([ hdLengthTop, hdWidth, hdThick ]);
        }
      }// END rotate
      
      if( doAll )
      {
        // bottom part
        translate([-hdLengthBot,0,0])
        cube([ hdLengthBot, hdWidth, hdThick ]);
      }
      
    }//END union

    // inner clamp cut-out for rod
    rotate([ 0, -hdAngleTop, 0 ])
    translate([ hdLengthTop,0,0 ])
    ClampCutRound();
    
    // cut top of clamp off
    ClampCutTop();
    
    // holes for the screws
    translate([ scExtraZ, 0, 0 ])
    ScrewHoles();
    
    if( ztUseZip )
    {
      // zip-tie slot
      rotate([ 0, -hdAngleTop, 0 ])
      translate([ hdLengthTop - clDia/2,0,0 ])
      ZipSlot();
     }
    
     if( shUseScrew )
     {
       translate([ cos(hdAngleTop) * hdLengthTop - sin(hdAngleTop)*hdThick/2,
                   0,
                   sin(hdAngleTop) * hdLengthTop + cos(hdAngleTop)*hdThick/2])
       RodScrewHole();
     }
    
  }//END difference

}


// ===============================================================================
// ===
module RodScrewHole()
{
  translate([ 0, hdWidth/2, 0 ])
  rotate([0,-90 + shAngle,0])
  cylinder( r = shDia/2, h = 2*clDia, $fn = CP );
}


// ===============================================================================
// ===
module ZipSlot()
{
  translate([ -ztThick, hdWidth/2 - ztWidth/2, -1 ])
  cube([ ztThick, ztWidth, hdThick + 2]);
}



// ===============================================================================
// ===
module ScrewHoles()
{
  height = scDiaHead/(2*tan(scAngleCSink/2));
  
  for( x = [ -scDist/2, scDist/2 ] )
  {
    translate([ -hdLengthBot/2 + x, hdWidth/2, -height + hdThick + 0.01 ])
    cylinder( r1 = 0.1, r2 = scDiaHead/2, h = height, $fn = CP );
    
    translate([ -hdLengthBot/2 + x, hdWidth/2, -1 ])
    cylinder( r = scDia/2, h = hdThick+2, $fn = CP  );
  }
}


// ===============================================================================
// ===
module Clamp()
{
  translate([ 0, 0, hdThick/2 ])
  rotate([ -90,0,0 ])
  cylinder( r = clDia/2, h = hdWidth, $fn = CP );
}


// ===============================================================================
// ===
module ClampCutRound()
{
  // clamp cut-out
  translate([ 0, 0, hdThick/2 ])
  rotate([ -90,0,0 ])
  translate([0,0,-1])
  cylinder( r = clDiaIn/2, h = hdWidth+2, $fn = CP );
}


// ===============================================================================
// ===
module ClampCutTop()
{
  translate([ cos(hdAngleTop)*hdLengthTop - sin(hdAngleTop)*hdThick/2 + clOffset,
              -1, 0 ])
  cube([ clDia, hdWidth+2, hdLengthTop + clDia ]);

}


// ===============================================================================
// === 
module Chamfer()
{
}




