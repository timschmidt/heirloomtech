// Here we define the user editable parameters:
function getParameterDefinitions() {
  return [
    //{ type: "id", name: "frame" },
    //{ name: "Frame",
    //{ description: "HeirloomTech frame member library" },
    //{ products: ["https://www.heirloomtech.com", "http://www.8020.net/HT-Series-1.asp"] },
    //{ licenses: ["https://www.gnu.org/licenses/agpl-3.0.html", "http://www.ohwr.org/projects/cernohl/wiki"] },
    //{ git: "http://www.github.com/timschmidt/heirloomtech" },
    //{ authors: ["Timothy Schmidt", "Michael Williams"] },
    //{ sources: ["3d-printer", "cnc-mill", "drill-press", "frame-factory"] },
    //{ keywords: ["frame", "gridbeam", "holey tube", "matrix"] },
    { type: 'choice', name: 'quality', caption: 'Quality', values: [0, 1], captions: ["Draft","High"], default: 0 },
    { type: 'float', name: 'beam_width', caption: 'Spacing between holes', default: 10 },
    { type: 'float', name: 'hole_radius', caption: 'Radius of holes', default: 2.4 },
    { type: 'int', name: 'length', caption: 'Beam length', default: 10 }
  ];
}

// zBeam(length) - create a vertical bitbeam strut 'length' long
// xBeam(length) - create a horizontal bitbeam strug along the X axis
// yBeam(length) - create a horizontal bitbeam strut along the Y axis
// translateBeam(beam, [x, y, z]) - translate bitbeam struts in X, Y, or Z axes in units 'beam_width'

var cylresolution=16;
var beam_width=8;
var hole_radius=2.4;

function main(params) {

    cylresolution=(params.quality == "1")? 64:16;
    beam_width=params.beam_width;
    hole_radius=params.hole_radius;
    return xBeam(params.length);
}

function xHole(i) {
    return CSG.cylinder( {
        start: [-1, beam_width/2, i*beam_width + beam_width/2],
        end: [beam_width+1, beam_width/2, i*beam_width + beam_width/2],
        radius: hole_radius,
        resolution: cylresolution
    } );
}

function yHole(i) {
    return CSG.cylinder( {
        start: [beam_width/2, -1, i*beam_width + beam_width/2],
        end: [beam_width/2, beam_width+1, i*beam_width + beam_width/2],
        radius: hole_radius,
        resolution: cylresolution
    } );
}

function zBeam(length) {
    var cube = CSG.cube({
        center: [beam_width/2, beam_width/2, (length*beam_width)/2],
        radius: [beam_width/2, beam_width/2, (length*beam_width)/2]
        });
    var holes = [];
    for (var i = 0; i < length; i++)
    {
        holes.push(xHole(i));
        holes.push(yHole(i));
    }
    var beam = cube.subtract(holes);
    beam.properties.myConnector = new CSG.Connector([10, 0, 0], [1, 0, 0], [0, 0, 1]);
    return beam;
}

function yBeam(length) {
    return translateBeam(zBeam(length).rotateX(-90), [0,0,1]);
}

function xBeam(length) {
    return translateBeam(zBeam(length).rotateY(90), [0,0,1]);
}

function translateBeam(beam, t_vector) {
    return beam.translate(t_vector.map(function(n) { return beam_width*n; }));
}
