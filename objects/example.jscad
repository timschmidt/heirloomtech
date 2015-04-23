function getProperties(){
return { id: "example",
  name: "Example Object",
  products: {1: "https://www.heirloomtech.com"},
  licenses: {1: "https://www.gnu.org/licenses/agpl-3.0.html", 2: "http://www.tapr.org/TAPR_Open_Hardware_License_v1.0.txt"},
  git: "http://www.github.com/timschmidt/heirloomtech",
  authors: {1: "Timothy Schmidt"},
  sources: {1: "3d-printer",2: "cnc-mill",3: "drill-press",4: "frame-factory"},
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
