// Box size
boxwidth = 50;
boxlength = 111;
boxheight = 45;
boxwall = 2;
facewall = 3;

// Plug outlet hole

plugwidth= 28.5;
pluglength = 47;
plugheight = 6;
plugbevel = 6;

offsetx = boxwall+3;
offsety = 12;
offsetz = 1.6;
clearance = 1.5;

// Clip ridges

clipdiameter = 3;
clipspacing = 4;
clipfirst = 3;
cliptop = 12.5;
clipbottom = 36.5;

// Cable exit 
cutoutoffsetx = 18;
cutoutoffsety = 8;
cableoutwidth = 12;
cableoutheight = 8;
cableoffsety = 4;

module clip(height,diameter,spacing)
{
rotate ([0,90,0]) cylinder (r=diameter/2, h=height);
translate ([0,0,spacing]) rotate ([0,90,0]) cylinder (r=diameter/2, h=height);
}

module bevelbox(width,length,height,bevel)
{
linear_extrude (height = height) polygon([[0,bevel],[bevel,0],[length,0],[length,width],[bevel,width],[0,width-bevel]], convexity=1);

translate ([0,0,offsetz]) linear_extrude (height = height) polygon([[0-clearance,bevel-clearance],[bevel-clearance,0-clearance],[length+clearance,0-clearance],[length+clearance,width+clearance],[bevel-clearance,width+clearance],[0-clearance,width-bevel+clearance]], convexity=1);

}

module casing(w,l,h,t)
{
walls = t*2;
difference () {
	cube ([w,l,h]);
	translate ([t,t,facewall]) cube ([w-walls,l-walls,h]);
	}
}


module clearance(w,l,h,o)
{
translate ([0,0,o]) cube([w,l,h]);
}

difference () {
casing (boxwidth,boxlength,boxheight,boxwall);

union () {
translate ([boxwidth-offsetx,offsety,0]) rotate ([0,0,90]) bevelbox(plugwidth,pluglength,plugheight,plugbevel);
translate ([cableoffsety,boxlength/2-(cableoutheight/2),0]) cube([cableoutheight,cableoutwidth,boxwall+2]);
clearance (cutoutoffsety,boxlength,boxheight,boxheight-cutoutoffsetx);
}
}

translate ([boxwidth-clipbottom,0,clipdiameter/2+boxheight-clipfirst-(clipdiameter*2)-clipspacing]) clip (clipbottom-cliptop,clipdiameter,clipspacing+clipdiameter);

translate ([boxwidth-clipbottom,boxlength,clipdiameter/2+boxheight-clipfirst-(clipdiameter*2)-clipspacing]) clip (clipbottom-cliptop,clipdiameter,clipspacing+clipdiameter);

