/*
* @name Raspberry Pi Model
* @id raspberry-pi
* @license GPLv3+, TAPR OHL
* @author Timothy Schmidy, 2015
* @git http://www.github.com/timschmidt/heirloomtech
* @category Electronics
* @using 4 bolt-m4x10
* @using 4 hexnut-nylock-m4
* 
* @todo implement variable for choosing A, B, A+, B+, 2 B, etc.
*/

// All measurements derived from the diagram available here:
// http://www.raspberrypi.org/wp-content/uploads/2012/12/Raspberry-Pi-Mounting-Hole-Template.png

module MountingHoles()
{
	circle(r=1.5, $fn=25);

	translate([54.5,25.5,0])
	circle(r=1.5, $fn=25);
}