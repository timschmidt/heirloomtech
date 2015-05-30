// call from the command line like this:
// openjscad example.jscad --width 10 --height 14 --depth 7 --rounded 1 -o example.stl

function getProperties(){
  return { id: "example",
    label: "Example Object",
    description: "The HeirloomTech example object.  Use this as a template for creating your own.",
    products: ["https://www.heirloomtech.com"],
    licenses: ["https://www.gnu.org/licenses/agpl-3.0.html", "http://www.ohwr.org/projects/cernohl/wiki"],
    git: "http://www.github.com/timschmidt/heirloomtech",
    authors: ["Timothy Schmidt"],
    sources: ["3d-printer", "cnc-mill", "drill-press", "frame-factory"],
    keywords: ["example", "demonstration", "template"],
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
