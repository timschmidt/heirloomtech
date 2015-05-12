// @todo rotation isn't quite the same as layout on a grid - rejigger this to do grid-based evaluation of slot tolerances and hole layout

function getParameterDefinitions() {
  return [
    // Object Properties
    //{ id: "hole-pattern" },
    //{ label: "Hole Pattern" },
    //{ description: "A modular mounting hole pattern that provides broad compatability with worldwide standards." },
    //{ products: [] },
    //{ licenses: ["https://www.gnu.org/licenses/agpl-3.0.html", "http://www.tapr.org/TAPR_Open_Hardware_License_v1.0.txt"] },
    //{ git: "http://www.github.com/timschmidt/heirloomtech" },
    //{ authors: ["Timothy Schmidt"] },
    //{ sources: [] },
    
    // Configurable Parameters
    { name: 'threshold', type: 'float', initial: 7, caption: "Threshold for slots (mm): " },
    { name: 'hole_size', type: 'float', initial: 8, caption: "Hole size (mm): " },
    { name: 'period', type: 'float', initial: 45, caption: "Period (degrees): " },
    { name: 'rotation', type: 'choice', caption: "Roation: ", values: [90, 180, 360], captions: ["90", "180", "360"], initial: 90 }
  ];
}

function comparePatterns(a, b){
  if (Number(a) < Number(b))  { return -1; }
  if (Number(a) > Number(b))  { return 1;  }
  if (Number(a) === Number(b)){ return 0;  }
}

function main(params) {
  var origin = [0];
  var metric_lumber = [25, 40, 50, 100];
  var inch_lumber = [0.5 * 25.4, 0.75 * 25.4, 25.4, 1.5 * 25.4];
  
  var patterns = origin.concat(metric_lumber,inch_lumber);
  patterns.sort(comparePatterns);
  
  var holes = [];
  patterns.forEach(function(entry){
    patterns.forEach(function(other_entry){
      if (Math.abs(Number(entry) - Number(other_entry)) < params.threshold){
        holes.push(
          hull(
            circle({r: params.hole_size / 2, center: true}).translate([entry,0,0]),
            circle({r: params.hole_size / 2, center: true}).translate([other_entry,0,0])
          )
        );
      }
    });
  });
  
  var result = [];
  for (var i = 0; i <= params.rotation; i = i + params.period){
    result.push(rotate([0,0,i], union(holes)));
  }

  return union(result);

}
