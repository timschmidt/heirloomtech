// ==============================================
// V-block for centering round things
// J.Beale 5-FEB-2015
// ==============================================

w = 60	;  // overall width
len = 40;  // overall length
w1 =  2;  // width of top edge
w2 = 2;   // width of top side edge
w3 = 5*w1; // width of base section
h1 = ((w/2)-w1);  // depth of V groove
h2 = 6;  // height of base section
h3 = 4;  // height of base flange
brad = 2; // radius of bottom groove
swidth = 4;  // width of center mounting slot
mhd = 3.2;   // diameter of corner mounting holes

// ==============================================

fn=50;  // facets on cylinder
eps=0.03; // small number

// ---------------------------------
// points of polygon to extrude
AX=0; AY=0;
BX=(w/2)-w1; BY=h1;
CX=w/2; CY=h1;
DX=w/2; DY=h1-w2;
EX=w3; EY=0;
FX=w3; FY=-(h2-h3);
GX=w/2; GY=-(h2-h3);
HX=w/2; HY=-(h2);
IX=-HX; IY=HY;
JX=-GX; JY=GY;
KX=-FX; KY=FY;
LX=-EX; LY=EY;
MX=-DX; MY=DY;
NX=-CX; NY=CY;
OX=-BX; OY=CY;
// ---------------------------------


module vb1() {
// rotate([90,0,0]) 
  linear_extrude(height = len, center = true, convexity = 10, twist = 0)
  v_sect();
}

module v_sect() {  // 2-D cross section of V-block shape
  polygon( points=[ 
  [AX,AY],[BX,BY],[CX,CY],[DX,DY],
  [EX,EY],[FX,FY],[GX,GY],[HX,HY],
  [IX,IY],[JX,JY],[KX,KY],[LX,LY],
  [MX,MY],[NX,NY],[OX,OY] ]);
}


module rod1() {  // rounded groove at bottom of V shape
  hull() {
    cylinder(r=brad, h=len+2*eps, center=true, $fn=fn);
    translate([0,brad,0]) cylinder(r=brad, h=len+2*eps, center=true, $fn=fn);
  }
}

module vblock1() {
 difference() {
  vb1();
  translate([0,brad*0.8,0]) rod1();
 }
}

module slot1() {  // slot in base
 hull() {
  translate([w/2-2*swidth,0,-h3]) 
    cylinder(d=swidth, h=h3*3, center=true, $fn=fn);
  translate([w/2+swidth,0,-h3]) 
    cylinder(d=swidth*1.5, h=h3*3, center=true, $fn=fn);
 }
}

module vblock() {  // v-block with mounting holes in base
 difference() {
  rotate([90,0,0]) vblock1();
  slot1();
  rotate([0,0,180]) slot1();
  translate([w/2 - mhd*2,len/2 - mhd*2,-h3]) 
    cylinder(d=mhd, h=h3*2, center=true, $fn=fn);
  translate([w/2 - mhd*2,-(len/2 - mhd*2),-h3]) 
    cylinder(d=mhd, h=h3*2, center=true, $fn=fn);
  translate([-(w/2 - mhd*2),len/2 - mhd*2,-h3]) 
    cylinder(d=mhd, h=h3*2, center=true, $fn=fn);
  translate([-(w/2 - mhd*2),-(len/2 - mhd*2),-h3]) 
    cylinder(d=mhd, h=h3*2, center=true, $fn=fn);
 }
}

// rotate ([90,0,0]) 
vblock();
