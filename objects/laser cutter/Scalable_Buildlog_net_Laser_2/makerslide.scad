module makerslide(h=100) {
	linear_extrude(file="makerslide_extrusion_profile.dxf", layer="makerslide",height=h, center=true, convexity=10);
	}

makerslide(100);
