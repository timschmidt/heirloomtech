{ id: "frame-1.5x12inches",
  name: "Frame 1.5 inches x 12 inches",
  products: {"http://www.8020.net/HT-Series-1.asp"},
  licenses: {"https://www.gnu.org/licenses/agpl-3.0.html","http://www.tapr.org/TAPR_Open_Hardware_License_v1.0.txt"},
  git: "http://www.github.com/timschmidt/heirloomtech",
  authors: {"Timothy Schmidt"},
  sources: {"3d-printer","cnc-mill","drill-press","frame-factory"},
  render: function(){},
  translate: function(){},
  scale: function(){},
}
  

beam_is_hollow = 1;

color(Aluminum) {
  zBeam(8);
}

// @id frame-1.5x24inches
// @name HeirloomTech Frame 1.5 inches x 24 inches
// @source http://www.8020.net/HT-Series-1.asp

beam_is_hollow = 1;

color(Aluminum) {
  zBeam(16);
}

// @id frame-1.5x36inches
// @name HeirloomTech Frame 1.5 inches x 36 inches
// @source http://www.8020.net/HT-Series-1.asp

beam_is_hollow = 1;

color(Aluminum) {
  zBeam(24);
}

// @id frame-1.5x48inches
// @name HeirloomTech Frame 1.5 inches x 48 inches
// @source http://www.8020.net/HT-Series-1.asp

beam_is_hollow = 1;

color(Aluminum) {
  zBeam(32);
}

