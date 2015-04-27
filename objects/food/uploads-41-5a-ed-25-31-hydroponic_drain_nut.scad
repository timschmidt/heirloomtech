// A nut for a hydroponic drain

head_ht=0;
v_thread_len=(15/25.4);

// Thread library Open Source by Dan Kirshner - dan_kirshner@yahoo.com
include <threads.scad>

module body() {
	union () {
		// Flange
		cylinder(h=5,r=21);
		// Hexaonal bit
		cylinder(h=14,r=36/2,$fn=6);
	}
}
module holes() {
	union () {
		// 3/4" BSPP thread
		translate ([0,0,-0.1]) english_thread(1.06,14,v_thread_len);
	}
}

difference () {
	body();
	holes();
}

