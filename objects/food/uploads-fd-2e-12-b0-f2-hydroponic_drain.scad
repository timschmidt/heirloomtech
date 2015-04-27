// A Hydroponic drain

flange_ht=5;
spigot_ht=55;
v_thread_len=1-((flange_ht+5)/25.4);

// Thread library Open Source by Dan Kirshner - dan_kirshner@yahoo.com
include <threads.scad>

module body() {
	union () {
		// Flange
		cylinder(h=5,r=21);
		// 3/4" BSPP thread
		translate ([0,0,flange_ht]) {
			english_thread(1.0,14,v_thread_len);
			// Dummy for quick compile
			//cylinder(h=v_thread_len*25.4,r=25.4/2);
		}
		// 13mm spigot
		cylinder(h=spigot_ht,r=12.4/2);
		// Base taper
		translate([0,0,v_thread_len*25.4+flange_ht]) cylinder(h=15,r1=11,r2=6);
		// Spigot barb
		translate([0,0,spigot_ht-10]) cylinder(h=8,r1=12.4/2+0.75,r2=12.4/2);
	}
}
module holes() {
	union () {
	// Central drainage hole
	translate([0,0,-1])
		cylinder(h=100+spigot_ht,r=4.2);
	// Tapered outlet
	translate ([0,0,-0.1])
		cylinder(h=10,r=9);
	translate([0,0,9.8])
		cylinder(h=5,r1=9,r2=3.9);
	}
}

difference () {
	body();
	holes();
}

