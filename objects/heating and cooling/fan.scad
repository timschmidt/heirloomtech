bladeThickness=1.2;
fanRadius=40;
hubRadius=8;
hubHeight=5;
shaftRadius=1;
bladeAngle=45;
blades=5;
flatten=true; //true for printable object; false for assembly preview
bladeWidth=10;


module blade()
{
  translate([tabLength+bladeLength/2,0,0])
  union()
  {
    scale([bladeLength,bladeWidth,1])cylinder(bladeThickness,0.5,0.5,$fn=20,center=true);
    translate([-bladeLength/2,0,0]) cube([tabLength*2,tabWidth,bladeThickness],center=true);
  }
}

module hub()
{
  difference()
  {
    cylinder(hubHeight,hubRadius,hubRadius,center=true,$fn=20);
    cylinder(hubHeight*2,shaftRadius,shaftRadius,center=true,$fn=20);
    for ( i = [0:blades-1] ) 
    {
      rotate( i*360/blades, [0, 0, 1])
      rotate( bladeAngle, [1, 0, 0])
      translate([tabLength+shaftRadius+1,0,0])
      cube([tabLength*2,tabWidth,bladeThickness],center=true);
    }

  }
}

bladeLength=fanRadius-hubRadius;
tabLength=hubRadius-shaftRadius-1;
tabWidth=bladeWidth/3;

if(!flatten)
{
  hub();
  
  for ( i = [0:blades-1] ) {
    rotate( i*360/blades, [0, 0, 1])
    rotate( bladeAngle, [1, 0, 0])
    translate([shaftRadius+1,0,0])blade();
  }
}

if(flatten)
{
  translate([-bladeLength/2-2,0,hubHeight/2])hub();
  
  for ( i = [0:blades-1] ) {
    translate([hubRadius-bladeLength/2,i*(bladeWidth+2)-((blades-1)*(bladeWidth+2)/2),bladeThickness/2])blade();
  }
}
