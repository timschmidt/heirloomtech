// Parametric RAM ball compatible mounting arm
// defaults for 1" Ram 'B' ball using RAM standard hardware
// Nick Lucent
// Nick@allobaby.net

// user editable parameters: 
function getParameterDefinitions() {
  return [
    { name: 'stlwarning', caption: 'Does not produce watertight STLs!', type: 'text', initial: 'Run through netfabb' },
    { name: 'armLength', caption: 'Length of mounting arm', type: 'float', initial: 55 },
    { name: 'armRadius', caption: 'Radius of mounting arm', type: 'float', initial: 14 },
    { name: 'ballRadius', caption: 'Radius of ball mount', type: 'float', initial: 12.7 },
    { name: 'slotWidth', caption: 'Width of adjustment slot', type: 'float', initial: 12 },
    { name: 'boltRadius', caption: 'Radius of bolt hole', type: 'float', initial: 4 },
    { name: 'nutTrapRadius', caption: 'Radius of nut trap', type: 'float', initial: 7 },
    { name: 'nutTrapDepth', caption: 'Depth of nut trap', type: 'float', initial: 4 },
    {
      name: 'slotDir', 
      type: 'choice',
      caption: 'Orientation of adjustment slot',
      values: [0, 1],
      captions: ["Horizontal", "Vertical"], 
      initial: 0
    },
    {
      name: 'endType', 
      type: 'choice',
      caption: 'End Type',
      values: [0, 1],
      captions: ["Flat - requires support", "Full ball end - no support required"], 
      initial: 0
    },
    {
      name: 'recessCenter', 
      type: 'choice',
      caption: 'Recess Center (Saves plastic, easier to remove raft)',
      values: [0, 1],
      captions: ["Flat", "Recessed - requires support"], 
      initial: 1
    },
    { name: 'recessDepth', caption: 'Depth of center recess', type: 'float', initial: 2 },
    {
      name: 'includeBall', 
      type: 'choice',
      caption: 'Render mounting ball',
      values: [0, 1],
      captions: ["No", "Yes"], 
      initial: 0
    },
    { name: 'ballPostHeight', caption: 'Height of ball post', type: 'float', initial: 10 },
    { name: 'ballPostHoleRadius', caption: 'Radius of ball post bolt', type: 'float', initial: 4 },
    {
      name: 'includeHandle', 
      type: 'choice',
      caption: 'Render Handle',
      values: [0, 1],
      captions: ["No", "Yes"], 
      initial: 0
    },
    {
      name: 'embedHandleTrap', 
      type: 'choice',
      caption: 'Handle nut trap',
      values: [0, 1],
      captions: ["Open", "Embedded (Requires manually pausing printer to embed nut)"], 
      initial: 0
    }
    
  ];
}

function GetEndChopDistance(armLength, ballRadius) {
    // returns half of total arm length + 2 ball Radius + % of ball radius
    return (armLength + (ballRadius * 3)) / 2;
}

function GetBallEndpoints(armLength, ballRadius) {
    return (armLength / 2) + ballRadius;
}

function NewArm(params) {
    // create base arm - assumes sane values
    var arm = difference(
        // create base shape
        union(
            cylinder({r:params.armRadius, h:params.armLength, center:true}).rotateX(90),
            sphere({r:params.armRadius, center:true}).translate([0,-(params.armLength/2),0]),
            sphere({r:params.armRadius, center:true}).translate([0,(params.armLength/2),0]),
            cylinder({r:params.armRadius * '.75', h:params.armRadius * 2.1, center:true})
            ),
        // balls
        sphere({r:params.ballRadius, center:true}).translate([0,-(params.armLength/2),0]),
        sphere({r:params.ballRadius, center:true}).translate([0,(params.armLength/2),0]),
        // bolt hole
        cylinder({r:params.boltRadius, h:params.armRadius * 3, center:true}),
        // nut trap
        cylinder({r:params.nutTrapRadius, h:params.nutTrapDepth, fn:6, center:true}).translate([0,0,params.armRadius]),
        // shape sides
        sphere({r:params.armLength - params.armRadius, h:params.armLength, center:true, fn:100}).translate([(params.armLength - (params.armRadius / 2)+2),0,0]).scale(1.2,1,1),
        sphere({r:params.armLength - params.armRadius, h:params.armLength, center:true, fn:100}).translate([-(params.armLength - (params.armRadius / 2)+2),0,0]).scale(1.2,1,1),
        // remove bottom half + .5 so we are slightly short
        cube({size:[params.armLength * 2, params.armLength * 2, params.armRadius * 2],center:[1,1,1]}).translate([0,0,-(params.armRadius - '.5')])
        //  translate down to be flat on build plate
    ).translate([0,0,-'.5']);
    
    // recess center
    if (params.recessCenter > 0) {
        arm = difference(arm, cube({size:[params.armRadius, params.armLength * '.5', params.recessDepth * 2], center:[1,1,1]}));
    }
    
    // chop ends if necessary
    if (params.endType < 1) {
        arm = difference(arm, cube({size:params.armRadius * 2,center:true}).translate([0,GetEndChopDistance(params.armLength, params.ballRadius),0]),cube({size:params.armRadius * 2,center:true}).translate([0,-GetEndChopDistance(params.armLength, params.ballRadius),0]));
    }
    
    // add vertical slot
    if (params.slotDir > 0) {
        return difference(arm,
                cube({size: [params.slotWidth, params.ballRadius * 1.5,60], round: true, center:[1,1,1]}).translate([0,GetBallEndpoints(params.armLength, params.ballRadius) - 5,0]),
                cube({size: [params.slotWidth, params.ballRadius * 1.5,60], round: true, center:[1,1,1]}).translate([0,-(GetBallEndpoints(params.armLength, params.ballRadius) - 5),0])
        );
    }
    // add horizontal slot
    else {
       return difference(arm,
                cube({size: [60, params.ballRadius * 1.5,params.slotWidth], round: true, center:true}).translate([0,GetBallEndpoints(params.armLength, params.ballRadius) - 5,0]),
                cube({size: [60, params.ballRadius * 1.5,params.slotWidth], round: true, center:true}).translate([0,-(GetBallEndpoints(params.armLength, params.ballRadius) - 5),0])
        );
    }
}

function NewBall(params) {
    return difference(
        union(
            cylinder({r:1.5 * params.boltRadius, h:params.ballPostHeight, center:[1,1,0]}),
            sphere({r:params.ballRadius, center:[1,1,0]}).translate([0,0,params.ballPostHeight - (params.ballRadius * '.2')])
        ),
        cylinder({r:params.ballPostHoleRadius, h:params.ballPostHeight, center:[1,1,0]})
    );
}

function NewHandle(params) {
    var handle = difference(
            union(
                cube({size:[38.5,11,15.5], center:[1,1,0], round:true}),
                cylinder({r:params.boltRadius * 2, h:20, center:[1,1,0]})
            ),
            cylinder({r:params.boltRadius, h:20, center:[1,1,0]})
    );
    
    if (params.embedHandleTrap < 1) {
        return difference(handle, cylinder({r:params.nutTrapRadius, h:params.nutTrapDepth, fn:6, center:[1,1,0]}));
    }
    else {
        return difference(handle, cylinder({r:params.nutTrapRadius, h:params.nutTrapDepth, fn:6, center:[1,1,0]}).translate([0,0,5]));
    }
}


function main(params) {
    var objs = [];
    var arm = NewArm(params);
    objs.push(arm);
    objs.push(arm.translate([3 * params.armRadius,0,0]));

    
    if (params.includeHandle > 0) {
        objs.push(NewHandle(params).translate([3 * params.armRadius,-(1.5 * params.armLength),0]));
    }
    
    if (params.includeBall > 0) {
        objs.push(NewBall(params).translate([0,-(1.5 * params.armLength),0]));
    }
    
    
    return objs;
    
}
