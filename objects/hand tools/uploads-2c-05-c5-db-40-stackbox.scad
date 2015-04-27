//global
$fn=90;
width=50;
depth=80;
height=40;
wall=2;
tolerance=0.5;

//polygons as modules
module p_box_out(){
 polygon(points=[[0,-height/4],[height/2,0],[height/2,depth-height/4],[0,depth-height/4]]);
}

module p_box_in(){
 polygon(points=[[0,-(height/4-wall)],[height/2-wall,0],[height/2-wall,depth-height/4-wall],[0,depth-height/4-wall]]);
}

module p_mount_out(){
 polygon(points=[[0,0],[-10,0],[-10,tolerance],[-11,tolerance],[-11,tolerance+wall],[-10,tolerance+wall]]);
}

module p_mount_in(){
 polygon(points=[[0,-wall],[-10,-wall],[-10,-(tolerance+2*wall)]]);
}

//other modules
module mount_corner(){
 difference(){
  intersection(){
   rotate_extrude()
    rotate([0,0,-90])
     p_mount_out();
   rotate([0,0,90])
    cube(size=[tolerance+5,tolerance+5,15]);
  }
  translate([0,0,11])
   cube(size=[tolerance*2,tolerance*2,2],center=true);
 }
}

module cut_sphere(){
 difference(){ 
  translate([-15/2,-15,0])
   cube(size=15);
  sphere(r=10);
 }
}

//main
difference(){
 rotate([0,90,0])
  difference(){
   union(){
    difference(){
     linear_extrude(height=width,center=true){
      p_box_out();
      mirror([1,0])
       p_box_out();
     } 
     linear_extrude(height=width-2*wall,center=true){
      p_box_in();
      translate([-(height/2+5),-(height/4-wall)])
       square(size=[height/2+5,depth-2*wall]);
     }
    }
    translate([-(height/2-10),0,-width/2])
     rotate([-90,0,0])
      linear_extrude(height=depth-height/4){
       p_mount_out();
       p_mount_in();
    }
    mirror([0,0,1])
     translate([-(height/2-10),0,-width/2])
      rotate([-90,0,0])
       linear_extrude(height=depth-height/4){
        p_mount_out();
        p_mount_in();
     }
    translate([-(height/2-10),depth-height/4])
     linear_extrude(height=width, center=true){
      p_mount_out();
      p_mount_in();
    }
   }
   translate([-height/2,-height/4])
    cylinder(r=height/2,h=width+10,center=true);
  }
 translate([-(width/2-wall/2),height/4+8,height/2-8])
  cut_sphere();
 mirror([1,0,0])
  translate([-(width/2-wall/2),height/4+8,height/2-8])
   cut_sphere();
}

translate([-width/2,depth-height/4,height/2-10])
 mount_corner();
mirror([1,0,0])
 translate([-width/2,depth-height/4,height/2-10])
  mount_corner();

