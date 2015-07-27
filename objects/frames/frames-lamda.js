"//ASYNCvar me = "web-offline";
var _csg_baseurl="file:///home/tim/workspace/heirloomtech/OpenJSCAD.org/index.html";
var _includePath="./";
var gMemFs = [];
//
frames.jscad:gMemFs["frames.jscad"] = "
// Here we define the user editable parameters:
function getParameterDefinitions() {
  return [
    { type: \"id\", name: \"frame\" },
  //{ name: \"Frame\",
  //{ description: \"HeirloomTech frame member library\" },
  //{ products: [\"https://www.heirloomtech.com\","http://www.8020.net/HT-Series-1.asp\"] },
  //{ licenses: [\"https://www.gnu.org/licenses/agpl-3.0.html\","http://www.ohwr.org/projects/cernohl/wiki\"] },
  //{ git: "http://www.github.com/timschmidt/heirloomtech\" },
  //{ authors: [\"Timothy Schmidt\", \"Michael Williams\"] },
  //{ sources: [\"3d-printer\","cnc-mill\","drill-press\","frame-factory\"] },
  //{ keywords: [\"frame\", \"gridbeam\", \"holey tube\",\"matrix\"] },
    { type: 'choice', name: 'quality', caption: 'Quality', values: [0, 1], captions: [\"Draft\",\"High\"], default: 0},
    { type: 'float', name: 'beam_width', caption: 'Spacing between
 holes', default: 10 },\n    { type: 'float', name: 'hole_radius',
 caption: 'Radius of holes', default: 2.4 },\n    { type: 'int', name:
 'length', caption: 'Beam length', default: 10 }\n  ];\n}\n\n//
 zBeam(length) - create a vertical bitbeam strut 'length' long\n//
 xBeam(length) - create a horizontal bitbeam strug along the X axis\n//
 yBeam(length) - create a horizontal bitbeam strut along the Y axis\n//
 translateBeam(beam, [x, y, z]) - translate bitbeam struts in X, Y, or
 Z axes in units 'beam_width'\n\nvar cylresolution=16;\nvar
 beam_width=8;\nvar hole_radius=2.4;\n\nfunction main(params) {\n\n
 cylresolution=(params.quality == \"1\")? 64:16;\n
 beam_width=params.beam_width;\n    hole_radius=params.hole_radius;\n
  return xBeam(params.length);\n}\n\nfunction xHole(i) {\n    return
  CSG.cylinder( {\n        start: [-1, beam_width/2, i*beam_width +
  beam_width/2],\n        end: [beam_width+1, beam_width/2,
  i*beam_width + beam_width/2],\n        radius: hole_radius,\n
  resolution: cylresolution\n    } );\n}\n\nfunction yHole(i) {\n
  return CSG.cylinder( {\n        start: [beam_width/2, -1,
  i*beam_width + beam_width/2],\n        end: [beam_width/2,
  beam_width+1, i*beam_width + beam_width/2],\n        radius:
  hole_radius,\n        resolution: cylresolution\n    }
  );\n}\n\nfunction zBeam(length) {\n    var cube = CSG.cube({\n
  center: [beam_width/2, beam_width/2, (length*beam_width)/2],\n
  radius: [beam_width/2, beam_width/2, (length*beam_width)/2]\n
  });\n    var holes = [];\n    for (var i = 0; i < length; i++)\n
  {\n        holes.push(xHole(i));\n        holes.push(yHole(i));\n
  }\n    var beam = cube.subtract(holes);\n
  beam.properties.myConnector = new CSG.Connector([10, 0, 0], [1, 0,
  0], [0, 0, 1]);\n    return beam;\n}\n\nfunction yBeam(length) {\n
  return translateBeam(zBeam(length).rotateX(-90),
  [0,0,1]);\n}\n\nfunction xBeam(length) {\n    return
  translateBeam(zBeam(length).rotateY(90), [0,0,1]);\n}\n\nfunction
  translateBeam(beam, t_vector) {\n    return
  beam.translate(t_vector.map(function(n) { return beam_width*n;
  }));\n}\n";eval(gMemFs['frames.jscad']);//// The following code is
  added by OpenJsCad + OpenJSCAD.org:var
  _csg_baselibraries=["csg.js","openjscad.js","openscad.js"];var
  _csg_libraries=[];var _csg_openjscadurl="file:///home/tim/workspace/heirloomtech/OpenJSCAD.org/index.html";
  var _csg_makeAbsoluteURL=function (url, baseurl) {  if(!url.match(/^[a-z]+\:/i)) {    var basecomps = baseurl.split("/");
  if(basecomps.length > 0) {      basecomps.splice(basecomps.length - 1, 1);    }
  var urlcomps = url.split("/");
  var comps = basecomps.concat(urlcomps);
  var comps2 = [];
  comps.map(function(c) {      if(c == "..") {        if(comps2.length > 0) {          comps2.splice(comps2.length - 1, 1);        }      } else {        comps2.push(c);      }    });
  url = "";
  for(var i = 0; i < comps2.length; i++) {      if(i > 0) url += "/";      url += comps2[i];    }  }  return url;};
  _csg_baselibraries = _csg_baselibraries.map(function(l){return _csg_makeAbsoluteURL(l,_csg_openjscadurl);});_csg_libraries = _csg_libraries.map(function(l){return _csg_makeAbsoluteURL(l,_csg_baseurl);});_csg_baselibraries.map(function(l){importScripts(l)});_csg_libraries.map(function(l){importScripts(l)});self.addEventListener('message', function(e) {if(e.data && e.data.cmd == 'render'){  OpenJsCad.runMainInWorker({});}},false);"
