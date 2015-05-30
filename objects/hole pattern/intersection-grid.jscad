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
    { name: 'rotation', type: 'choice', caption: "Roation: ", values: [90, 180, 270, 360], captions: ["90", "180", "270", "360"], initial: 360 }
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
  var inch_lumber = [0.5 * 25.4, 0.75 * 25.4, 25.4, 1.5 * 25.4, 2 * 25.4, 3 * 25.4, 4 * 25.4];

  var offsets = origin.concat(metric_lumber,inch_lumber);

  var locations = [];

  offsets.forEach(function(l_offset){
    metric_lumber.forEach(function(l_pattern){
      if ( locations.indexOf({ x: l_offset, y: l_pattern, c: "blue" }) ){
        locations.push({ x: l_offset, y: l_pattern, c: "blue" });
      }
      if ( locations.indexOf({ x: l_pattern, y: l_offset, c: "blue" }) ){
        locations.push({ x: l_pattern, y: l_offset, c: "blue" });
      }
    });
    inch_lumber.forEach(function(l_pattern){
      if ( locations.indexOf({ x: l_offset, y: l_pattern, c: "red" }) ){
        locations.push({ x: l_offset, y: l_pattern, c: "red" });
      }
      if ( locations.indexOf({ x: l_pattern, y: l_offset, c: "red" }) ){
        locations.push({ x: l_pattern, y: l_offset, c: "red" });
      }
    });
  });

  // only add holes that fall within params.tolerance of each other
  var holes = [];
  locations.forEach(function(entry){
    locations.forEach(function(other_entry){
      x_distance = entry.x - other_entry.x;
      y_distance = entry.y - other_entry.y;
      if (Math.sqrt(x_distance * x_distance + y_distance * y_distance) < params.threshold){
        var slot = hull(
            circle({r: params.hole_size / 2, center: true}).translate([entry.x,entry.y,0]),
            circle({r: params.hole_size / 2, center: true}).translate([other_entry.x,other_entry.y,0])
        );
        holes.push(slot);
      }
    });
  });

  var result = [];
  for (var i = 0; i <= params.rotation; i = i + params.period){
    result.push(rotate([0,0,i], union(holes)));
  }

  return union(result);

}
