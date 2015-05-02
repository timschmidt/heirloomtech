function getProperties(){
  return { id: "knob",
    name: "Customizeable Knob",
    description: "Knobs suitable for electronics or appliances",
    products: ["https://www.heirloomtech.com"],
    licenses: ["http://creativecommons.org/licenses/by/3.0/"],
    git: "http://www.github.com/timschmidt/heirloomtech",
    authors: ["http://www.thingiverse.com/charliearmorycom/about"],
    sources: ["3d-printer", "cnc-mill"],
    keywords: ["knob", "dial", "potentiometer"],
    render: function(){},
    translate: function(){},
    scale: function(){}
  };
}

function getParameterDefinitions() {
  return [
    { name: 'HoleDiameter',      type: 'float', initial: 6,  caption: "Diameter of the hole on the bottom (in mm)" },
    { name: 'HoleDepth',         type: 'float', initial: 10, caption: "Depth of the hole in the bottom (in mm)" },
    { name: 'HoleFlatThickness', type: 'float', initial: 0,  caption: "If you want a D-shaped hole, set this to the thickness of the flat side (in mm)" },
    { name: 'KnobHeight',        type: 'float', initial: 20, caption: "Height (in mm).  If dome cap is selected, it is not included in height.  The shaft length is also not counted." },
    { name: 'KnobDiameter',      type: 'float', initial: 20, caption: "Diameter of base of round part of knob (in mm)" },
    { name: 'CapType',           type: 'choice', initial: 1, caption: "Shape of the knob.", values: [0,1,2], captions: ["Flat", "Recessed", "Dome"] },
    { name: 'TimerKnob',         type: 'choice', initial: 0, caption: "Do you want a large timer-knob style pointer?", values: [0,1], captions: ["No", "Yes"] },
    { name: 'Pointer1',          type: 'choice', initial: 0, caption: "Would you like a divot on the top to indicate direction?", values: [0,1], captions: ["No", "Yes"] },
    { name: 'Pointer2',          type: 'choice', initial: 0, caption: "Would you like a line (pointer) on the front to indicate direction?", values: [0,1], captions: ["No", "Yes"] },
    { name: 'Knurled',           type: 'choice', initial: 1, caption: "Do you want finger ridges around the knob?", values: [0,1], captions: ["No", "Yes"] },
    { name: 'TaperPercentage',   type: 'float', initial: 20, caption: "0 = A cylindrical knob, any other value will taper the knob." },
    { name: 'RingWidth',         type: 'float', initial: 4, caption: "Width of "dial" ring (in mm).  Set to zero if you don't want the ring." },
    { name: 'RingMarkings',      type: 'float', initial: 11, caption: "The number of markings on the dial.  Set to zero if you don't want markings.  (RingWidth must be non-zero.)" },
    { name: 'ScrewHoleDiameter', type: 'float', initial: 3, caption: "diameter of the hole for the setscrew (in mm).  If you don't need a hole, set this to zero." },
    { name: 'ShaftLength',       type: 'float', initial: 0, caption: "Length of the shaft on the bottom of the knob (in mm).  If you don't want a shaft, set this value to zero." },
    { name: 'ShaftDiameter',     type: 'float', initial: 10, caption: "Diameter of the shaft on the bottom of the knob (in mm).  (ShaftLength must be non-zero.)" },
    { name: 'NotchedShaft',      type: 'choice', initial: 0, caption: "Would you like a notch in the shaft?  It can be used for a press-on type knob (rather than using a setscrew).  (ShaftLength must be non-zero.)", values: [0,1], captions: ["No", "Yes"] },
    { name: 'RingThickness',     type: 'float', initial: 5, caption: "" },
    { name: 'DivotDepth',        type: 'float', initial: 1.5, caption: "" },
    { name: 'MarkingWidth',      type: 'float', initial: 1.5, caption: "" },
    { name: 'DistanceBetweenKnurls', type: 'float', initial: 1, caption: "" },
    { name: 'TimerKnobConst',    type: 'float', initial: 1.8, caption: "" },
  ];
}


function main(params){

// Calculations

PI=3.14159265*1;
KnobMajorRadius = params.KnobDiameter/2;
KnobMinorRadius = params.KnobDiameter/2 * (1 - params.TaperPercentage/100);
KnobRadius = params.KnobMinorRadius + (params.KnobMajorRadius-params.KnobMinorRadius)/2;
KnobCircumference = PI*params.KnobDiameter;
Knurls = round(params.KnobCircumference/params.DistanceBetweenKnurls);
Divot=params.CapType;

TaperAngle=asin(params.KnobHeight / (sqrt(pow(params.KnobHeight, 2) +
		pow(KnobMajorRadius-KnobMinorRadius,2)))) - 90;

DivotRadius = KnobMinorRadius*.4;

// Geometry

union()
{
translate([0, 0, (ShaftLength==0)? 0 : ShaftLength-0.001])
difference()
{
union()
{
	// Primary knob cylinder
	cylinder(h=KnobHeight, r1=KnobMajorRadius, r2=KnobMinorRadius, $fn=50);
	
	if (Knurled)
		for (i=[0 : Knurls-1])
			rotate([0, 0, i * (360/Knurls)])
				translate([KnobRadius, 0, KnobHeight/2])
					rotate([0, TaperAngle, 0]) rotate([0, 0, 45])
						cube([2, 2, KnobHeight+.001], center=true);

 	if (RingMarkings>0)
		for (i=[0 : RingMarkings-1])
			rotate([0, 0, i * (360/RingMarkings)])
				translate([KnobMajorRadius + RingWidth/2, 0, 1])
					cube([RingWidth*.5, MarkingWidth, 2], center=true);		
	
	if (Pointer2==1)
		translate([KnobRadius, 0, KnobHeight/2-2])
			rotate([0, TaperAngle, 0])
				cube([8, 3, KnobHeight], center=true);		

	if (RingWidth>0)
		translate([0, 0, RingThickness/2])
			cylinder(r1=KnobMajorRadius + RingWidth, r2=KnobMinorRadius,
					h=RingThickness, $fn=50, center=true);

	if (Divot==2)
		translate([0, 0, KnobHeight])
			difference()
			{
				scale([1, 1, 0.5])
					sphere(r=KnobMinorRadius, $fn=50, center=true);

				translate([0, 0, 0-(KnobMinorRadius+.001)])
					cube([KnobMinorRadius*2.5, KnobMinorRadius*2.5,
							KnobMinorRadius*2], center=true);
			}

	if (TimerKnob==1) intersection()
		{
			translate([0, 0, 0-(KnobDiameter*TimerKnobConst) + KnobHeight])
			sphere(r=KnobDiameter*TimerKnobConst, $fn=50, center=true);		
	
			translate([0-(KnobDiameter*TimerKnobConst)*0.1, 0,
					KnobHeight/2])
				scale([1, 0.5, 1])
					cylinder(h=KnobHeight, r=(KnobDiameter*TimerKnobConst) *
							0.8, $fn=3, center=true);
		}
}

// Pointer1: Offset hemispherical divot
if (Pointer1==1)
	translate([KnobMinorRadius*.55, 0, KnobHeight + DivotRadius*.6])
		sphere(r=DivotRadius, $fn=40);

// Divot1: Centered cylynrical divot
if (Divot==1)
	translate([0, 0, KnobHeight])
		cylinder(h=DivotDepth*2, r=KnobMinorRadius-1.5, $fn=50,
				center=true);

if (ShaftLength==0)
{
	// Hole for shaft
	translate([0, 0, HoleDepth/2 - 0.001])
		difference()
		{
			cylinder(r=HoleDiameter/2, h=HoleDepth, $fn=20,
					center=true);
	
			// Flat for D-shaped hole
			translate([(0-HoleDiameter)+HoleFlatThickness, 0, 0])
				cube([HoleDiameter, HoleDiameter, HoleDepth+.001],
						center=true);
		}
	
	// Hole for setscrew
	if (ScrewHoleDiameter>0)
		translate([0 - (KnobMajorRadius+RingWidth+1)/2, 0,
				HoleDepth/2])
			rotate([0, 90, 0])
			cylinder(h=(KnobMajorRadius+RingWidth+1),
					r=ScrewHoleDiameter/2, $fn=20, center=true);
}

// Make sure bottom ends at z=0
translate([0, 0, -10])
	cube([(KnobMajorRadius+RingWidth) * 3,
			(KnobMajorRadius+RingWidth) * 3, 20], center=true);
}

if (ShaftLength>0)
	difference()
	{
		translate([0, 0, ShaftLength/2])
			cylinder(h=ShaftLength, r=ShaftDiameter/2, $fn=20,
					center=true);

		if (NotchedShaft==1)
		{
			cube([HoleDiameter/2, ShaftDiameter*2, ShaftLength],
					center=true);
		}

		// Hole for shaft
		translate([0, 0, HoleDepth/2 - 0.001])
			difference()
			{
				cylinder(r=HoleDiameter/2, h=HoleDepth, $fn=20,
						center=true);
		
				// Flat for D-shaped hole
				translate([(0-HoleDiameter)+HoleFlatThickness, 0, 0])
					cube([HoleDiameter, HoleDiameter, HoleDepth+.001],
							center=true);
			}
		
		// Hole for setscrew
		if (ScrewHoleDiameter>0)
			translate([0 - (KnobMajorRadius+RingWidth+1)/2, 0,
					HoleDepth/2])
				rotate([0, 90, 0])
				cylinder(h=(KnobMajorRadius+RingWidth+1),
						r=ScrewHoleDiameter/2, $fn=20, center=true);
	}
}

  if(params.rounded == 1) {
    result = CSG.roundedCube({radius: [params.width, params.height, params.depth], roundradius: 2, resolution: 32});
  } else {
    result = CSG.cube({radius: [params.width, params.height, params.depth]});
  }
  return result;
}

