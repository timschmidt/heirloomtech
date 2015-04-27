shaftDiameter = 3.30;
wheelDiameter = 28;
shaftMargin = 2.5;
shaftHeight = 5;
shaftBevel = 0.3;
wheelHeigh = 2;
wheelGrooveDepth = 0.3;

encoderInnerRadius = 9.5;
encoderOuterRadius = 13;
encoderSlitWidth = 0.8;
encoderSlitMargin = 0.8;
encoderSlitCount = 35;

shaftR = shaftDiameter/2;
wheelR = wheelDiameter/2;

encoderSlitLength = encoderOuterRadius-encoderInnerRadius;

difference () {

	rotate_extrude($fn=200) polygon( points=[[shaftR,0],[wheelR,0],[wheelR-wheelGrooveDepth,wheelHeigh/2],[wheelR,wheelHeigh],[shaftR+shaftMargin,wheelHeigh],[shaftR+shaftMargin,shaftHeight],[shaftR+shaftBevel,shaftHeight],[shaftR,shaftHeight-shaftBevel]] );
	
	union() {
		for(i=[0:encoderSlitCount-1]) {
			rotate(a = [0,0,(360/encoderSlitCount)*i]) {
				translate(v=[0,encoderInnerRadius+(encoderSlitLength/2),wheelHeigh/2]) {
					cube(size = [encoderSlitWidth,encoderSlitLength,wheelHeigh+1],center = true);
				}
			}
		}
	}
}
