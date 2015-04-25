// @todo rotate around vertical axis to produce 2D pattern

function getProperties(){
return { id: "hole-pattern",
  name: "Hole Pattern",
  description: "A modular mounting hole pattern that provides broad compatability with worldwide standards.",
  products: [],
  licenses: ["https://www.gnu.org/licenses/agpl-3.0.html", "http://www.tapr.org/TAPR_Open_Hardware_License_v1.0.txt"],
  git: "http://www.github.com/timschmidt/heirloomtech",
  authors: ["Timothy Schmidt"],
  sources: [],
  render: function(){},
  translate: function(){},
  scale: function(){}
};

}

function getParameterDefinitions() {
  return [
    { name: 'threshold', type: 'float', initial: 10, caption: "Threshold for slots (mm): " },
    { name: 'hole_size', type: 'float', initial: 14, caption: "Hole size (mm): " },
    { name: 'threedee', type: 'choice', caption: '3D?', values: [0, 1], captions: ["No thanks", "Yes please"], initial: 0 }
  ];
}

// @todo I think this only works when there's one parameter - figure out how to do that
function intersects(point_one, point_two){
  if ( abs(point_one - point_two) > params.threshold ){
    return point_two;
  }
}

function main(params) {
  var patterns = [
    // common metric sizes
    [25, 40, 50, 100],
    // common legacy sizes
    [0.5 * 25.4, 0.75 * 25.4, 25.4, 1.5 * 25.4],
  ];
  
  var holes = [];
  patterns.forEach(function(pattern){
    var filtered = pattern.filter(intersects());
    pattern.forEach(function(entry){
      holes.forEach(function(){
        if ( true ) {
          holes.push(circle({center: true}).scale(params.hole_size).translate([entry,0,0]));
        }
      });
    });
  });
    
  // foreach pattern, iterate through the pattern, checking the
  //  holes array for nearby entries, combining them when they
  //  fall within the threshold. 

  var result;
  if(params.threedee == 1) {
    result = CSG.roundedCube({radius: [params.threshold, params.hole_size, params.threedee], roundradius: 2, resolution: 32});
  } else {
    result = CSG.cube({radius: [params.threshold, params.hole_size, params.threedee]});
  }
  return holes;
}
