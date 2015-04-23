// @todo rotate around vertical axis to produce 2D pattern

function getProperties(){
return { id: "hole-pattern",
  name: "Hole Pattern",
  products: {1: ""},
  licenses: {1: "https://www.gnu.org/licenses/agpl-3.0.html", 2: "http://www.tapr.org/TAPR_Open_Hardware_License_v1.0.txt"},
  git: "http://www.github.com/timschmidt/heirloomtech",
  authors: {1: "Timothy Schmidt"},
  sources: {1: ""},
  render: function(){},
  translate: function(){},
  scale: function(){}
};

}

function getParameterDefinitions() {
  return [
    { name: 'width', type: 'float', initial: 10, caption: "Width of the cube:" },
    { name: 'height', type: 'float', initial: 14, caption: "Height of the cube:" },
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


include <MCAD/units.scad>

length = 12*inch;
radius = 1.5*mm;
threshold = 20*mm;
            
union(){
  // start iterating through the space
  for(x = [0 : length]){
    // check to see if the current position is part of a repeating pattern
    for(i = [round(1.5*inch),round(1*inch),40*mm,50*mm,20*mm]){
      if (x % i == 0){
        // find the next point on a repeating pattern
        for(y = [x : length]){
          if (y % i == 0){
            if (y - x < threshold){
              hull(){
                translate([x,0,0]) circle(r=radius, $fn=16);
                translate([y,0,0]) circle(r=radius, $fn=16);
              }
            } else {
              translate([x,0,0]) circle(r=radius, $fn=16);
            }
         }
      }
   }
}
}
}
