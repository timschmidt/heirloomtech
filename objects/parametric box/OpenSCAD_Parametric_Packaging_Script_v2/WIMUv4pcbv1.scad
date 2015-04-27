external_max = [42,28];
cutout=[9.4,4.4];
corner_r=2;
PCB_t=1.2;
no_of_sides=5;


wimuv4_2013_pcb();
/*
difference(){
	square(size=external_max);
	square(size=cutout);
}
*/

module wimuv4_2013_pcb(external_max = [42,28],
cutout=[9.4,4.4],
corner_r=2,
PCB_t=1.2,
no_of_sides=5){
	linear_extrude(height=PCB_t){
		translate(v=external_max)rotate(a=180)minkowski(){
			difference(){
				translate(v=[corner_r,corner_r])square(size=external_max-[2*corner_r,2*corner_r]);
				//square(size=cutout+[corner_r,corner_r]);
				hull(){
					circle(r=2*corner_r);
					translate(v=cutout-[corner_r,corner_r]) circle(r=2*corner_r, $fn=no_of_sides*4);
					translate(v=[0,cutout[1]-corner_r]) circle(r=2*corner_r);
					translate(v=[cutout[0]-corner_r,0]) circle(r=2*corner_r);
	
				}
			}
			circle(r=corner_r, $fn=no_of_sides*4);
		}
	}
}