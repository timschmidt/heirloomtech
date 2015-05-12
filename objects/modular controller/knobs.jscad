"use strict";

function getParameterDefinitions() {
  return [
    // Object Properties
    { id: 'knob' },
    { label: 'Customizeable Knob' },
    { description: 'Knobs suitable for electronics or appliances' },
    { products: ['https://www.heirloomtech.com'] },
    { licenses: ['http://creativecommons.org/licenses/by/3.0/'] },
    { git: 'http://www.github.com/timschmidt/heirloomtech' },
    { authors: ['http://www.thingiverse.com/charliearmorycom/about', 'Timothy Schmidt'] },
    { source: 'additive', tool: '3d-printer-fdm', materials: ['filament-plastic'] },
    { source: 'additive', tool: '3d-printer-sls', materials: ['powder'] },
    { source: 'subtractive', tool: 'cnc-mill', materials: ['plastic-sheet', 'lumber'] },
    { keywords: ["knob", "dial", "potentiometer", "timer", "volume", "indicator"] },
    
    // Configurable Parameters
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
    { name: 'RingWidth',         type: 'float', initial: 4, caption: "Width of dial ring (in mm).  Set to zero if you don't want the ring." },
    { name: 'RingMarkings',      type: 'float', initial: 11, caption: "The number of markings on the dial.  Set to zero if you don't want markings.  (RingWidth must be non-zero.)" },
    { name: 'ScrewHoleDiameter', type: 'float', initial: 3, caption: "diameter of the hole for the setscrew (in mm).  If you don't need a hole, set this to zero." },
    { name: 'ShaftLength',       type: 'float', initial: 0, caption: "Length of the shaft on the bottom of the knob (in mm).  If you don't want a shaft, set this value to zero." },
    { name: 'ShaftDiameter',     type: 'float', initial: 10, caption: "Diameter of the shaft on the bottom of the knob (in mm).  (ShaftLength must be non-zero.)" },
    { name: 'NotchedShaft',      type: 'choice', initial: 0, caption: "Would you like a notch in the shaft?  It can be used for a press-on type knob (rather than using a setscrew).  (ShaftLength must be non-zero.)", values: [0,1], captions: ["No", "Yes"] },
    { name: 'RingThickness',     type: 'float', initial: 5, caption: "" },
    { name: 'DivotDepth',        type: 'float', initial: 1.5, caption: "" },
    { name: 'MarkingWidth',      type: 'float', initial: 1.5, caption: "" },
    { name: 'DistanceBetweenKnurls', type: 'float', initial: 1, caption: "" },
    { name: 'TimerKnobConst',    type: 'float', initial: 1.8, caption: "" }
  ];
}

function main(params){
  // Calculations
  PI = 3.14159265;
  KnobMajorRadius = params.KnobDiameter / 2;
  KnobMinorRadius = params.KnobDiameter / 2 * (1 - params.TaperPercentage / 100);
  KnobRadius = KnobMinorRadius + (KnobMajorRadius - KnobMinorRadius) / 2;
  KnobCircumference = PI * params.KnobDiameter;
  Knurls = round(KnobCircumference / params.DistanceBetweenKnurls);
  Divot = params.CapType;
  TaperAngle = asin(params.KnobHeight / (sqrt(pow(params.KnobHeight, 2) + pow(KnobMajorRadius - KnobMinorRadius,2)))) - 90;
  DivotRadius = KnobMinorRadius * 0.4;

  // Geometry
  
  knob_parts = [];

  union(
    translate([0, 0, (params.ShaftLength === 0) ? 0 : params.ShaftLength - 0.001])
    // Primary knob cylinder
    knob_cylinder[] = cylinder(h = params.KnobHeight, r1 = KnobMajorRadius, r2 = KnobMinorRadius, $fn = 50);

    if (params.Knurled === 1) {
        for (i=0; i < Knurls - 1; i += 1) {
            knob_cylinder[] = cube([2, 2, params.KnobHeight + 0.001], center=true).rotate([0, 0, 45]).rotate([0, TaperAngle, 0]).translate([KnobRadius, 0, params.KnobHeight / 2]).rotate([0, 0, i * (360 / Knurls)]);
        }
    }

    if (params.RingMarkings > 0) {
        for (i=[0 : params.RingMarkings-1]) {
            knob_cylinder[] = cube([params.RingWidth * 0.5, params.MarkingWidth, 2], center=true).translate([KnobMajorRadius + params.RingWidth / 2, 0, 1]).rotate([0, 0, i * (360/params.RingMarkings)]);
        }
    }
    
    if (params.Pointer2 === 1) {
        knob_cylinder[] = cube([8, 3, params.KnobHeight], center=true).rotate([0, TaperAngle, 0]).translate([KnobRadius, 0, params.KnobHeight / 2 - 2]);
    }

    if (params.RingWidth > 0) {
        knob_cylinder[] = cylinder(r1 = KnobMajorRadius + params.RingWidth, r2 = KnobMinorRadius, h = params.RingThickness, $fn = 50, center=true).translate([0, 0, params.RingThickness / 2]);
    }

    if (Divot === 2) {
        difference() {
            sphere(r=KnobMinorRadius, $fn = 50, center=true).scale([1, 1, 0.5]);
            cube([KnobMinorRadius * 2.5, KnobMinorRadius * 2.5, KnobMinorRadius * 2], center=true).translate([0, 0, 0 - (KnobMinorRadius + 0.001)]);
        }.translate([0, 0, params.KnobHeight])
    }

    if (params.TimerKnob === 1) intersection() {
        knob_cylinder[] = sphere(r = params.KnobDiameter * params.TimerKnobConst, $fn = 50, center = true).translate([0, 0, 0 - (params.KnobDiameter * params.TimerKnobConst) + params.KnobHeight]);      
        knob_cylinder[] = cylinder(h=params.KnobHeight, r = (params.KnobDiameter * params.TimerKnobConst) * 0.8, $fn = 3, center = true).scale([1, 0.5, 1]).translate([0 - (params.KnobDiameter * params.TimerKnobConst) * 0.1, 0, params.KnobHeight / 2]);
    }
        
    knob_cylinder_result = union(knob_cylinder);
        

    knob_temp = [];
    // Pointer1: Offset hemispherical divot
    if (params.Pointer1 === 1) {
        knob_temp[] = sphere(r = DivotRadius, $fn = 40).translate([KnobMinorRadius * 0.55, 0, params.KnobHeight + DivotRadius * 0.6]);
    }

    // Divot1: Centered cylynrical divot
    if (Divot === 1) {
        knob_temp[] = cylinder(h = params.DivotDepth * 2, r = KnobMinorRadius - 1.5, $fn = 50, center = true).translate([0, 0, params.KnobHeight])
    }

    if (params.ShaftLength === 0) {
        // Hole for shaft
        knob_temp[] = difference() {
            cylinder(r = params.HoleDiameter/2, h = params.HoleDepth, $fn = 20, center = true);
    
            // Flat for D-shaped hole
            cube([params.HoleDiameter, params.HoleDiameter, params.HoleDepth + 0.001], center=true).translate([(0 - params.HoleDiameter) + params.HoleFlatThickness, 0, 0]);
        }.translate([0, 0, params.HoleDepth / 2 - 0.001])
    
    // Hole for setscrew
    if (params.ScrewHoleDiameter>0) {
        knob_temp[] = cylinder(h = (KnobMajorRadius + params.RingWidth + 1), r = params.ScrewHoleDiameter / 2, $fn = 20, center = true).rotate([0, 90, 0]).translate([0 - (KnobMajorRadius + params.RingWidth+1) / 2, 0, params.HoleDepth / 2]);
    }

    // Make sure bottom ends at z=0
    knob_temp[] = cube([(KnobMajorRadius+params.RingWidth) * 3, (KnobMajorRadius+params.RingWidth) * 3, 20], center=true).translate([0, 0, -10]);
    
    
    
    knob_temp = difference(knob_cylinder_result, knob_holes);
    
    
    
    
    
    

    if (params.ShaftLength > 0) {
        difference() {
            cylinder(h = params.ShaftLength, r = params.ShaftDiameter / 2, $fn = 20, center = true).translate([0, 0, params.ShaftLength / 2]);

            if (params.NotchedShaft === 1) {
                cube([params.HoleDiameter / 2, params.ShaftDiameter * 2, params.ShaftLength], center = true);
            }

            // Hole for shaft
            difference(
                cylinder(r = params.HoleDiameter / 2, h = params.HoleDepth, $fn = 20, center = true),
        
                // Flat for D-shaped hole
                cube([params.HoleDiameter, params.HoleDiameter, params.HoleDepth + 0.001], center=true).translate([(0 - params.HoleDiameter) + params.HoleFlatThickness, 0, 0])
            ).translate([0, 0, params.HoleDepth / 2 - 0.001]);
        
            // Hole for setscrew
            if (params.ScrewHoleDiameter > 0) {
                cylinder(h=(KnobMajorRadius+params.RingWidth + 1), r = params.ScrewHoleDiameter / 2, $fn = 20, center = true).rotate([0, 90, 0]).translate([0 - (KnobMajorRadius+params.RingWidth+1)/2, 0, params.HoleDepth / 2]);
            }
        }
    }
  );

  return result;
}

