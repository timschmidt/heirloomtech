module sprocket(teeth=20, roller=3, pitch=17, thickness=3, tolerance=0.2){
	//$fs=0.5;
	roller=roller/2; //We need radius in our calculations, not diameter
	distance_from_center=pitch/(2*sin(180/teeth));
	echo(distance_from_center);
	angle=(360/teeth);
	pitch_circle=sqrt((distance_from_center*distance_from_center) - (pitch*(roller+tolerance))+((roller+tolerance)*(roller+tolerance)));
	echo(pitch_circle);
	difference(){
		union(){
			cylinder(r=pitch_circle,h=thickness);
			for(tooth=[1:teeth]){
				intersection(){
					rotate(a=[0,0,angle*(tooth+0.5)]){
						translate([distance_from_center,0,0]){
							cylinder(r=pitch-roller-tolerance,h=thickness);
						}
					}
					rotate(a=[0,0,angle*(tooth-0.5)]){
						translate([distance_from_center,0,0]){
							cylinder(r=pitch-roller-tolerance,h=thickness);
						}
					}
				}
			}
		}
		for(tooth=[1:teeth]){
			rotate(a=[0,0,angle*(tooth+0.5)]){
				translate([distance_from_center,0,-1]){
					cylinder(r=roller+tolerance,h=thickness+2);
				}
			}
		}
	}
}
//sprocket(34,6,9,3,0.2);