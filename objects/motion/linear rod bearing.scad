// @author Siarhei Kuzmin, 2014
// Parametric linear bearing. With height=24, od=15, id=8 this is lm8uu
calc_threshold=0.0001;


module bearing1(height, id, od, od_thickness=0, claw_count=9) {
	od_thickness_p = od_thickness != 0 ? od_thickness : od*0.1;
	sector=360/claw_count;
	// polar coordinates
	function p(d, deg) = [cos(deg*sector)*(id+(od-id-od_thickness_p)*d)/2, sin(deg*sector)*(id+(od-id-od_thickness_p)*d)/2];
	linear_extrude(height=height)
	difference() {
		circle(d=od, $fn=60);
		for (s=[0:sector:360])
			rotate([0, 0, s])
			polygon(points=[p(1, 0), p(0.05, 0.44), p(0, 0.7), p(0.08, 0.75), p(1, 0.57),
				p(1, 0.75), p(1, 0.8), p(1, 0.85), p(1, 0.9), p(1, 0.95), p(1,1 + calc_threshold), [0,0]]);
	}
}

bearing1(height=24, od=15, id=8, od_thickness=1.4);
