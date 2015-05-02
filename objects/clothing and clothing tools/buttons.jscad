/*
makes a  button  - PCM

parameters for the buttons  -  four  - set below
see comments at end for some working values

db    =  diameter of the button in mm
thick = basic thickness of the button in mm
tr    = thickness of the rim - adds to button thickness
dr    =  width of rim - goes from outside of button towards center
*/

function getProperties(){
return { id: "buttons",
  name: "Buttons for fabric",
  description: "HeirloomTech buttons library.",
  products: ["https://www.heirloomtech.com"],
  licenses: ["https://creativecommons.org/licenses/by/3.0/"],
  git: "http://www.github.com/timschmidt/heirloomtech",
  authors: ["https://www.thingiverse.com/pmoews/about"],
  sources: ["3d-printer", "cnc-mill", "drill-press", "frame-factory"],
  render: function(){},
  translate: function(){},
  scale: function(){}
};

}

function getParameterDefinitions() {
  return [
    { name: 'dh', type: 'float', initial: 10, caption: "Width of the cube:" },
    { name: 'tx', type: 'float', initial: 14, caption: "Height of the cube:" },
    { name: 'depth', type: 'float', initial: 7, caption: "Depth of the cube:" },
    { name: 'rounded', type: 'choice', caption: 'Round the corners?', values: [0, 1], captions: ["No thanks", "Yes please"], initial: 1 }
  ];
}

function main(params) {
  var result;
  if(params.rounded == 1) {
    result = CSG.roundedCube({radius: [params.width, params.height, params.depth], roundradius: 2, resolution: 32});
  } else {
    result = CSG.cube({radius: [params.width, params.height, params.depth]});
  }
  return result;
}


db = 20;
thick =2.5;
tr =1.5;
dr =2.0;


/*
parameters for the holes -  two - set below

dh = diameter of holes in mm

tx = distances hole is from center in x and y (mm)

*/


 dh = 2.0;
 tx = 2.0;



/*  derived parameters
   based on input values no
   checks for impossible values
*/

hthick = thick/2;
l1=(db - thick)/2.;

r1 = dh/2.;
h2 = 2*thick;
ty = tx;
tz = 0;


// code follows

difference()
{
button();
translate([-tx,ty,tz])
cylinder(r=r1,h=h2,center=true,$fn=10);
translate([tx,ty,tz])
cylinder(r=r1,h=h2,center=true,$fn=10);
translate([-tx,-ty,tz])
cylinder(r=r1,h=h2,center=true,$fn=10);
translate([tx,-ty,tz])
cylinder(r=r1,h=h2,center=true,$fn=10);
}


// end of code


module button()
{

 n1 = 5;

/*
hthick is half the thickness of button
l1 is length of straight portion
tr = thickness of the rim
dr = size of rim - goes from
     outside of button towards inside
*/

rotate_extrude (convexity = 10,$fn=100)
translate([0,hthick,0])
polygon
       (points = [

        [ 0,0 ],[0,-hthick],
        [ hthick*cos(-18*n1) + l1, hthick*sin(-18*n1)],
        [ hthick*cos(-17*n1) + l1, hthick*sin(-17*n1)],
        [ hthick*cos(-16*n1) + l1, hthick*sin(-16*n1)],
        [ hthick*cos(-15*n1) + l1, hthick*sin(-15*n1)],
        [ hthick*cos(-14*n1) + l1, hthick*sin(-14*n1)],
        [ hthick*cos(-13*n1) + l1, hthick*sin(-13*n1)],
        [ hthick*cos(-12*n1) + l1, hthick*sin(-12*n1)],
        [ hthick*cos(-11*n1) + l1, hthick*sin(-11*n1)],
        [ hthick*cos(-10*n1) + l1, hthick*sin(-10*n1)],
        [ hthick*cos(-9*n1) + l1, hthick*sin(-9*n1)],
        [ hthick*cos(-8*n1) + l1, hthick*sin(-8*n1)],
        [ hthick*cos(-7*n1) + l1, hthick*sin(-7*n1)],
        [ hthick*cos(-6*n1) + l1, hthick*sin(-6*n1)],
        [ hthick*cos(-5*n1) + l1, hthick*sin(-5*n1)],
        [ hthick*cos(-4*n1) + l1, hthick*sin(-4*n1)],
        [ hthick*cos(-3*n1) + l1, hthick*sin(-3*n1)],
        [ hthick*cos(-2*n1) + l1, hthick*sin(-2*n1)],
        [ hthick*cos(-1*n1) + l1, hthick*sin(-1*n1)],
        [ hthick*cos(-0*n1) + l1, hthick*sin(0*n1)],

        [ hthick*cos(-0*n1) + l1,tr],

        [ hthick*cos(0*n1) + l1,tr + hthick*sin(0*n1)],
        [ hthick*cos(1*n1) + l1,tr + hthick*sin(1*n1)],
        [ hthick*cos(2*n1) + l1,tr + hthick*sin(2*n1)],
        [ hthick*cos(3*n1) + l1,tr + hthick*sin(3*n1)],
        [ hthick*cos(4*n1) + l1,tr + hthick*sin(4*n1)],
        [ hthick*cos(5*n1) + l1,tr + hthick*sin(5*n1)],
        [ hthick*cos(6*n1) + l1,tr + hthick*sin(6*n1)],
        [ hthick*cos(7*n1) + l1,tr + hthick*sin(7*n1)],
        [ hthick*cos(8*n1) + l1,tr + hthick*sin(8*n1)],
        [ hthick*cos(9*n1) + l1,tr + hthick*sin(9*n1)],
        [ hthick*cos(10*n1) + l1,tr + hthick*sin(10*n1)],
        [ hthick*cos(11*n1) + l1,tr + hthick*sin(11*n1)],
        [ hthick*cos(12*n1) + l1,tr + hthick*sin(12*n1)],
        [ hthick*cos(13*n1) + l1,tr + hthick*sin(13*n1)],
        [ hthick*cos(14*n1) + l1,tr + hthick*sin(14*n1)],
        [ hthick*cos(15*n1) + l1,tr + hthick*sin(15*n1)],
        [ hthick*cos(16*n1) + l1,tr + hthick*sin(16*n1)],
        [ hthick*cos(17*n1) + l1,tr + hthick*sin(17*n1)],
        [ hthick*cos(18*n1) + l1,tr + hthick*sin(18*n1)],
        [ hthick*cos(18*n1) + l1-dr,tr + hthick*sin(18*n1)],
        [ hthick*cos(18*n1) + l1-dr, hthick*sin(18*n1)],

        [0,hthick],[0,0],

              ]
              );
}



/*  start comments

for a 10 mm diameter button - print with no shells
to ensure spaces between holes are filled
parameters are:

db = 10;
thick =1.5;
tr = 1.0;
dr =1.0;

 dh = 1.2;
 tx = 1.3;



for a 20 mm jacket button - 100 % infill for a
strong button

db = 20;
thick =2.5;
tr =1.5;
dr =2.0;

 dh = 2.0;
 tx = 2.0;



for a 25 mm coat button - can print with 1 shell
parameters are:

db = 25;
thick =2;
tr =1.5;
dr =3.0;

 dh = 2;
 tx = 2.5;



for a large button - 40 mm - parameters are:

db = 40;
thick =3;
tr =2;
dr =5.0;

 dh = 2.5;
 tx = 3.5;




 end comments
*/


