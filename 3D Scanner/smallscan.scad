// Todo
// v0.5:
// - determine correct camera lens size
// - widen tolerance of motor mount central hole

// v0.6:
// - switch to 3 screws for turntable mount, triangle supports
// - name and centralize derived values - re-derive from fabscan data
// - construct asselmbly, cut projections
// - artwork?

include <MCAD/units.scad>
include <MCAD/motors.scad>
use <arduino.scad>

// fundamental geometry - derived from FabScan
camera_to_laser = 140*mm;
camera_to_table_center = 232*mm;
camera_to_table_height = 35.7*mm;
laser_to_table_height = 64*mm;
laser_to_table_center = 210*mm;
table_radius = 70*mm;

foot_height = 8*mm;
motor_depth = 40*mm;
laser_width = 11*mm;
kerf = 0.4*mm;
thickness = 1/8*inch;
arduino_padding = 2;
tab_inset = 3;
tab_length = 10*mm;
bolt_length = 10*mm;
bolt_diameter = 3*mm;
nut_width = 5.8*mm;
nut_depth = 3*mm;
material_width =12*inch;
camera_lens = 22*mm;
arduino_mount_length = 80*mm;
motor_mount_height = 47*mm;
$fn=50;

// Derived values
width = 53+thickness*2+arduino_padding+tab_inset*2;
camera_mount_height = 3*inch+motor_depth+camera_lens / 2+foot_height+thickness+tab_inset;
scanner_length = motor_mount_height / 2 + camera_to_table_center - thickness;


module foot(){
 square([thickness, tab_length]);
}

module tab(){
 square([thickness, tab_length]);
}

module bolt_slot(){
 union(){
  translate([0, -bolt_diameter/2])
   square([bolt_length, bolt_diameter]);
  translate([2, -nut_width/2])
   square([nut_depth, nut_width]);
 }
}

module rotated_bolt_slot(){
 rotate([0,0,90])
  bolt_slot();
}

module tieslot(){
 square([1, 4]);
 translate([3,0])
  square([1, 4]);
}

module left_side(){
 difference(){
  union(){
   translate([thickness, thickness])
   square([motor_depth, scanner_length]);

   // motor mount tabs
   translate([motor_depth+thickness, 5+thickness])
    tab();
   translate([motor_depth+thickness, motor_mount_height - tab_length - 5 + thickness])
    tab();

   // face plate tabs
   translate([thickness, thickness])
    rotate([0,0,-90])
    tab();

   translate([thickness+motor_depth - tab_length, thickness])
    rotate([0,0,-90])
    tab();

   // arduino mounting tabs
   translate([0, thickness+scanner_length - tab_length - tab_inset])
    tab();
   translate([0, thickness+scanner_length - arduino_mount_length + 5 + thickness])
    tab();

   // camera mount tab
   translate([motor_depth + thickness, thickness+scanner_length])
    rotate([0,0,90])
    tab();
  }

// bolt slots
  translate([motor_depth+thickness-bolt_length, motor_mount_height / 2 + thickness])
   bolt_slot();

  translate([motor_depth / 2 + thickness, thickness+scanner_length - bolt_length])
   rotated_bolt_slot();

  translate([bolt_length + thickness, thickness+scanner_length - arduino_mount_length / 2 + 2.5,0])
   mirror()
    bolt_slot();

  translate([motor_depth / 2 + thickness, thickness+bolt_length])
   rotate([0,0,180])
   rotated_bolt_slot();
 }
}

module right_side(){
 mirror()
 difference(){
  left_side();

  // motor wire zip tie holes
  translate([motor_depth / 2 + thickness, scanner_length / 2])
   tieslot();
 }
}

module camera_mount(){
 difference(){
  union(){
   square([width, camera_mount_height]);
	square([width + 10, 14]);
  }
 translate([width / 2, camera_lens / 2+thickness+tab_inset])
  circle(r=camera_lens / 2);

// c270 mounts
 translate([width/2 - 13.5, camera_lens / 2+thickness+tab_inset])
  circle(r=1);

 translate([width / 2 + 37.5, camera_lens / 2+thickness+tab_inset - 10.7])
  #circle(r=1);

// tab slots
  translate([width / 2 + tab_length / 2, camera_mount_height - thickness*2-foot_height])
   rotate([0,0,90])
   tab();

  translate([tab_inset, camera_mount_height - motor_depth - thickness*2 - foot_height])
   tab();

  translate([width - thickness - tab_inset, camera_mount_height - motor_depth - thickness*2 - foot_height])
   tab();

  translate([tab_length, 0])
   square([width - tab_length*2, thickness]);

// bolt holes
  translate([thickness / 2 + tab_inset, camera_mount_height - motor_depth / 2 - thickness*2 - foot_height])
   circle(r=bolt_diameter / 2);

  translate([width - thickness / 2 - tab_inset, camera_mount_height - motor_depth / 2 - thickness*2 - foot_height])
   circle(r=bolt_diameter / 2);

  translate([tab_length + bolt_diameter, thickness+bolt_length])
   rotate([0,0,180])
   rotated_bolt_slot();

  translate([width - tab_length - bolt_diameter, thickness+bolt_length])
   rotate([0,0,180])
   rotated_bolt_slot();

// zip tie holes
  translate([width / 2 - 2.5, camera_mount_height / 2])
   tieslot();

// arduino ports
projection(cut=true) {
  translate([10,camera_mount_height - thickness*2-foot_height - 3,16]){
   rotate([0, -90, 90]){
	
  USB(1);
  PowerPlug(1);
    }
   }
  }
 }
}

module laser_mount(){
 difference(){
  square([20, width / 2 + 5.5*inch + laser_width / 2]);

// laser mount
  translate([camera_lens / 2, width / 2 + 5.5*inch])
   circle(r=1.5);

  translate([8, (width + 5.5*inch) / 2])
   tieslot();

// tab slots
  translate([tab_inset, tab_inset])
   tab();
  translate([tab_inset, width - tab_length + tab_inset])
   tab();

// bolt holes
  translate([tab_inset + bolt_diameter / 2, tab_inset + tab_length + bolt_diameter])
   circle(r=bolt_diameter / 2);
  translate([tab_inset + bolt_diameter / 2, width - tab_length + tab_inset - bolt_diameter])
   circle(r = bolt_diameter / 2);
 }
}

module motor_mount(){
union(){
 difference(){
  square([width, motor_mount_height]);
  translate([width / 2, motor_mount_height / 2])
   stepper_motor_mount(17);
  translate([tab_inset, 5, 0])
   tab();
  translate([tab_inset, motor_mount_height - tab_length - 5])
   tab();
  translate([width - thickness - tab_inset, 5])
   tab();
  translate([width - thickness - tab_inset, motor_mount_height - tab_length - 5])
   tab();
  translate([thickness / 2 + tab_inset, motor_mount_height / 2])
   circle(r=bolt_diameter / 2);
  translate([width - thickness / 2 - tab_inset, motor_mount_height / 2])
   circle(r=bolt_diameter / 2);
 }
}
translate([width / 2+tab_length / 2, motor_mount_height])
 rotate([0,0,90])
 tab();
}

module arduino_mount(){
 difference(){
  square([arduino_mount_length, width]);
  translate([17,52+thickness+tab_inset,0])
    projection(cut=true) {
     MountingHoles();
    }

// tab slots
  translate([tab_length+thickness+tab_inset,tab_inset])
   rotate([0,0,90])
    tab();
  translate([arduino_mount_length - 5, tab_inset])
   rotate([0,0,90])
    tab();
  translate([tab_length+thickness+tab_inset, width - thickness - tab_inset])
   rotate([0,0,90])
    tab();
  translate([arduino_mount_length - 5,  width - thickness - tab_inset])
   rotate([0,0,90])
    tab();

// bolt holes
translate([arduino_mount_length / 2, thickness / 2 + tab_inset])
   circle(r=bolt_diameter / 2);
translate([arduino_mount_length / 2, width - thickness / 2 - tab_inset])
   circle(r=bolt_diameter / 2);

// end tab
  square([thickness, width / 2 - tab_length / 2]);
  translate([0, width / 2 + tab_length / 2])
   square([thickness, width / 2 - tab_length / 2]);
 }
}

module laser_swivle(){
 difference(){
  square([40, laser_width + thickness*2]);
  translate([5, laser_width / 2 + thickness])
   circle(r=1.5);
  translate([20, thickness])
   square([4, 1]);
  translate([20, thickness+laser_width-1])
   square([4, 1]);
  translate([30, thickness])
   square([4, 1]);
  translate([30, thickness+laser_width-1])
   square([4, 1]);
}
}

module faceplate(){
 difference(){
  square([width, motor_depth + foot_height+ thickness+tab_inset]);
  translate([tab_inset, thickness])
   tab();
  translate([width - tab_inset - thickness, thickness])
   tab();
  translate([tab_inset, motor_depth - tab_length + thickness])
   tab();
  translate([width - tab_inset - thickness, motor_depth - tab_length + thickness])
   tab();
  translate([width / 2+ tab_length / 2, 0])
   rotate([0,0,90])
   tab();

  translate([tab_inset+bolt_diameter / 2, motor_depth / 2+ thickness])
   circle(r=bolt_diameter / 2);
  translate([width - tab_inset - bolt_diameter / 2, motor_depth / 2 + thickness])
   circle(r=bolt_diameter / 2);
 }
}

module turntable(){
 difference(){
  circle(r=3*inch, $fn=50);
  translate([10, 10])
   circle(r=1.5*mm);
  translate([10, -10])
   circle(r=1.5*mm);
  translate([-10, 10])
   circle(r=1.5*mm);
  translate([-10,-10])
   circle(r=1.5*mm);
 }
}

module turntable_support(){
 difference(){
	square([36, 6]);
	translate([14, 3])
	 circle(r = 1.5);
	translate([22, 3])
	 circle(r = 1.5);
 }
}


// sizing gauge
//difference(){
//square(12*inch);
//translate([0.1,0.1])
//square(12*inch - 0.2);
//}

translate([motor_depth+kerf+thickness, tab_length + kerf])
left_side();
translate([motor_depth+thickness*2, 0])
right_side();

translate([motor_depth*2+thickness*3+kerf*3+width, 0])
 camera_mount();
translate([motor_depth*2+thickness*4+kerf*4+motor_mount_height+width*2, 14 + kerf])
 rotate([0,0,90])
 motor_mount();
translate([motor_depth*2+thickness*3+kerf*2+width, kerf])
 rotate([0,0,90])
 arduino_mount();
translate([motor_depth*2+thickness*4+kerf*5+width*2+motor_mount_height, 0])
 laser_mount();

translate([motor_depth*2+thickness*3+kerf*2, kerf*2+arduino_mount_length])
 faceplate();

translate([motor_depth*2+thickness*2+kerf*2, kerf*3+arduino_mount_length+motor_depth+tab_inset*2+foot_height])
 laser_swivle();

translate([motor_depth*2+thickness*3+kerf*5+width*2+10, width+kerf*4+114])
turntable_support();
translate([motor_depth*2+thickness*3+kerf*5+width*2+10, width+kerf*3+74])
turntable_support();
translate([motor_depth*2+thickness*3+kerf*5+width*2+10, width+kerf*2+34])
turntable_support();

translate([164, 8.7*inch])
turntable();
