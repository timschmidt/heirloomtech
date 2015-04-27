id = 8;
od = 22;
width = 7;
balld = 4.5;
angle = 30;

track_radius = id / 2 + balld / 2 + 1;

$fs = .5;
$fa = 2;


%rotate_extrude(convexity = 5) translate([track_radius, width / 2, 0]) circle(balld / 2);


difference() {
	linear_extrude(height = width, convexity = 5) difference() {
		circle(od / 2);
		circle(track_radius + .5);
	}
	rotate_extrude(convexity = 5) translate([track_radius, width / 2, 0]) scale([sin(45) / -cos(angle), sin(45) / sin(angle)]) rotate(45) square(balld, center = true);
}
for(side = [1, -1]) translate([side * (track_radius + 1), od / 2 + track_radius, 0]) difference() {
	%rotate_extrude(convexity = 5) translate([track_radius, width / 2, 0]) circle(balld / 2);
	linear_extrude(height = width / 2 - .5, convexity = 5) difference() {
		circle(track_radius - .5);
		circle(id / 2);
	}
	rotate_extrude(convexity = 5) translate([track_radius, width / 2, 0]) scale([sin(45) / -cos(angle), sin(45) / sin(angle)]) rotate(45) square(balld, center = true);
}
