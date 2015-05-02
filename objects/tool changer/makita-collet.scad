drill_hole=25.4*1/4;

difference() {
	union() {
		color("red") cylinder(d=8.87, h=16.03, $fn=100);
		translate([0,0,16.03-1.95]) cylinder(d=9.56, h=1.95, $fn=100);
		translate([0,0,16.03-1.95-1]) cylinder(d=8.87, d2=9.56, h=1, $fn=100);
		cylinder(d=13.94,h=2.11, $fn=100);
		translate([0,0,2.11]) cylinder(d=13.94, d2=11.98, h=6.01-2.11, $fn=100);
		
	}

	cylinder(d=drill_hole,h=16.03+0.01, $fn=100);
}


translate([20,0,0]) {
difference() {
	union() {
		color("red") cylinder(d=8.87, h=16.03, $fn=100);
		translate([0,0,16.03-1.95]) cylinder(d=9.56, h=1.95, $fn=100);
		cylinder(d=13.94,h=2.11, $fn=100);
		translate([0,0,2.11]) cylinder(d=13.94, d2=11.98, h=6.01-2.11, $fn=100);
	}

	cylinder(d=drill_hole,h=16.03+0.01, $fn=100);
}
}


translate([20,20,0]) {
difference() {
	union() {
		color("red") cylinder(d=9.56, h=16.03, $fn=100);
		translate([0,0,16.03-1.95]) cylinder(d=9.56, h=1.95, $fn=100);
		cylinder(d=13.94,h=2.11, $fn=100);
		translate([0,0,2.11]) cylinder(d=13.94, d2=11.98, h=6.01-2.11, $fn=100);
	}

	cylinder(d=drill_hole,h=16.03+0.01, $fn=100);
}
}

translate([0,20,0]) {
	difference() {
		difference() {
			union() {
				color("red") cylinder(d=9.56, h=16.03, $fn=100);
				translate([0,0,16.03-1.95]) cylinder(d=9.56, h=1.95, $fn=100);
				cylinder(d=13.94,h=2.11, $fn=100);
				translate([0,0,2.11]) cylinder(d=13.94, d2=11.98, h=6.01-2.11, $fn=100);
			}
			cylinder(d=drill_hole,h=16.03+0.01, $fn=100);
		}
		union(){
			translate([0,0, 10/2]) cube([13.94,0.98,10], center=true);
			translate([0,0, 10/2]) cube([0.98,13.94,10], center=true);
		}
	}
}

translate([0,40,0]) {
	difference() {
		difference() {
			union() {
				color("red") cylinder(d=9.56, h=16.03, $fn=100);
				translate([0,0,16.03-1.95]) cylinder(d=9.56, h=1.95, $fn=100);
				cylinder(d=13.94,h=2.11, $fn=100);
				translate([0,0,2.11]) cylinder(d=13.94, d2=11.98, h=6.01-2.11, $fn=100);
			}
			cylinder(d=25.4*1/8,h=16.03+0.01, $fn=100);
		}
		union(){
			translate([0,0, 10/2]) cube([13.94,0.98,10], center=true);
			translate([0,0, 10/2]) cube([0.98,13.94,10], center=true);
		}
	}
}

translate([20,40,0]) {
	difference() {
		difference() {
			union() {
				color("red") cylinder(d=9.56, h=16.03, $fn=100);
				translate([0,0,16.03-1.95]) cylinder(d=9.56, h=1.95, $fn=100);
				cylinder(d=13.94,h=2.11, $fn=100);
				translate([0,0,2.11]) cylinder(d=13.94, d2=11.98, h=6.01-2.11, $fn=100);
			}
			cylinder(d=8,h=16.03+0.01, $fn=100);
		}
		union(){
			translate([0,0, 10/2]) cube([13.94,0.98,10], center=true);
			translate([0,0, 10/2]) cube([0.98,13.94,10], center=true);
		}
	}
}

