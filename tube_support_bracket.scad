run = 3;
$fn = 64;

//how wide and tall the mount is (is square)
c_width = 65;

//how thick it is
c_thickness = 18;

//diameter of what is going into it
c_tube_dia = 37.5;

//how deep it will go in, anything greater than c_thickness will be all the way through
c_tube_depth = 19;

//cutout to the top
c_drop_in = true; //[true, false]

//put 4x screw holes
c_mounting_screws = true; //[true, false]

//size of screws
c_mounting_screw_size = 6.4;
c_mounting_screw_offset = 7;
c_mounting_screw_countersunk = true; //[true, false]
c_mounting_screw_cs_depth = 2;
c_mounting_screw_cs_width = 8;

c_tubetype = "round"; //[round, square]

c_lip = true; //[true, false]
c_lipsize = 2; //[20]
c_lipdepth = 1; //[20]

c_half_bracket = "none"; //[none, left, right]

c_rounded = "no"; //[no, yes]



module create_base() {
    cube([c_width, c_width, c_thickness]);
}

module halfRoundCornerBox(size, r=2, center=false) {
    x = size[0];
	y = size[1];
	z = size[2];
    
    xx =  (center==true) ? -x/2 : 0;
    xy =  (center==true) ? -y/2 : 0;
    xz =  (center==true) ? -z/2 : 0;
    translate([xx,xy,xz])
    hull() {
        union() {
            translate([r,r,0]) cylinder(r=r,h=z);
            translate([x-r,r,0]) cylinder(r=r,h=z);
            translate([0,y-r,0]) cube([r,r,z]);
            translate([x-r,y-r,0]) cube([r,r,z]);
        }
    }
}

//========================================
module roundCornerBox(size ,r=2, center=false) {
    x = size[0];
	y = size[1];
	z = size[2];
    
    xx =  (center==true) ? -x/2 : 0;
    xy =  (center==true) ? -y/2 : 0;
    xz =  (center==true) ? -z/2 : 0;
    translate([xx,xy,xz])
    hull() {
        union() {
            translate([r,r,0]) cylinder(r=r,h=z);
            translate([x-r,r,0]) cylinder(r=r,h=z);
            translate([r,y-r,0]) cylinder(r=r,h=z);
            translate([x-r,y-r,0]) cylinder(r=r,h=z);
        }
    }
}

//========================================
module ChamferBottomRoundBox(size,r=2, center=false) {
    
    x = size[0];
    y = size[1];
    z = size[2];
     
    xx =  (center==true) ? -x/2 : 0;
    xy =  (center==true) ? -y/2 : 0;
    xz =  (center==true) ? -z/2 : 0;  
    translate([xx,xy,xz]) { 
    difference() {
        roundCornerBox(size=size, r=r, center=false);
    
        translate([x,y/2,0]) rotate([0,45,0]) cube([r,y,r], center=true);
        translate([0,y/2,0]) rotate([0,45,0]) cube([r,y,r], center=true);
        
        translate([x/2,y,0]) rotate([45,0,0]) cube([x,r,r], center=true);
        translate([x/2,0,0]) rotate([45,0,0]) cube([x,r,r], center=true);
    }
    }
}

//========================================


module remove_tube() {
    if (c_drop_in == true) {
        if (c_tubetype == "round") {
            
            
            translate([c_width / 2, c_width / 2, c_thickness - c_tube_depth])
            hull() {
                cylinder(h=c_tube_depth+1, r=c_tube_dia / 2);
                translate([c_width / 2, 0, 0]) {
                    cylinder(h=c_tube_depth+1, r=c_tube_dia / 2);
                }
            }
        }
        if (c_tubetype == "square") {
            translate([(c_width / 2) - (c_tube_dia / 2), (c_width / 2) - (c_tube_dia / 2), c_thickness - c_tube_depth])
                cube([c_tube_dia+c_width, c_tube_dia, (c_tube_depth * 2) + 1], center = false);
        }
    } else {
        if (c_tubetype == "round") {
            translate([c_width / 2, c_width / 2, c_thickness - c_tube_depth])
                cylinder(h=c_tube_depth+1, r=c_tube_dia / 2);
        }
        if (c_tubetype == "square") {
            translate([c_width / 2, c_width / 2, c_thickness - c_tube_depth])
                cube([c_tube_dia, c_tube_dia, (c_tube_depth * 2) + 1], center = true);
        }
    }
}

module ring(outerR, innerR, thickness) {
/*
creates a ring with outer radius outerR, inner radius innerR
*/
    difference() {
        cylinder(h=thickness, r=outerR);
        cylinder(h=thickness, r=innerR);
    }

}

module create_sq_edge(outer, inner, thickness) {
    difference() {
        cube([outer, outer, thickness], center=true);
        cube([inner, inner, thickness], center=true);
    }
}

module create_mask(xx, yy) {
    echo("--> create_mask()");
    if (c_tubetype == "round") {
        echo("# round");
        //put in here the cyl or cube shape, then diff it later. instead of creating the mess that is remove_tube()
        
        if (c_lip == true) {
            difference() {
                cylinder(h=c_tube_depth, r=c_tube_dia / 2);            
                translate([xx,yy,c_tube_depth-c_lipdepth]) 
                    ring((c_tube_dia+1)/2, (c_tube_dia-c_lipsize)/2, c_lipdepth+1);
            }
        } else {
            cylinder(h=c_tube_depth, r=c_tube_dia / 2);            
        }
    }
    if (c_tubetype == "square") {
        echo("# square");
        if (c_lip == true) {
            difference() {
                translate([xx,yy, c_tube_depth/2])
                    cube([c_tube_dia, c_tube_dia, c_tube_depth], center=true);
                translate([xx,yy, c_tube_depth-(c_lipdepth/2)])
                    difference() {
                        create_sq_edge(outer = c_tube_dia, inner = c_tube_dia-c_lipsize, thickness = c_lipdepth);
                        //cube([c_tube_dia, c_tube_dia, c_lipdepth], center=true);
                        //cube([c_tube_dia-c_lipsize,c_tube_dia-c_lipsize, c_lipdepth], center=true);
                    }
            }
        } else {
            translate([xx,yy,c_tube_depth/2]) 
                cube([c_tube_dia, c_tube_dia, c_tube_depth], center=true);
        }
    }
}


module create_screwhole(screwLen, screwWidth, counterSunkLen, counterSunkWidth) {
    cylinder(h = screwLen, d = screwWidth);
    if (counterSunkLen != 0) {
        translate([0,0,screwLen-counterSunkLen])
            cylinder(h=counterSunkLen, d2=counterSunkWidth, d1=screwWidth);

    }
}


module remove_screws() {
    translate([c_mounting_screw_offset, c_mounting_screw_offset, -1]) {
        create_screwhole(screwLen = c_thickness+1, screwWidth = c_mounting_screw_size, counterSunkLen = c_mounting_screw_cs_depth, counterSunkWidth = c_mounting_screw_cs_width);
        //cylinder(h = c_thickness + 2, r = c_mounting_screw_size / 2);
    }
    translate([c_mounting_screw_offset, c_width - c_mounting_screw_offset, -1]) {
        create_screwhole(screwLen = c_thickness+1, screwWidth = c_mounting_screw_size, counterSunkLen = c_mounting_screw_cs_depth, counterSunkWidth = c_mounting_screw_cs_width);
        //cylinder(h = c_thickness + 2, r = c_mounting_screw_size / 2);
    }
    translate([c_width - c_mounting_screw_offset, c_mounting_screw_offset, -1]) {
        create_screwhole(screwLen = c_thickness+1, screwWidth = c_mounting_screw_size, counterSunkLen = c_mounting_screw_cs_depth, counterSunkWidth = c_mounting_screw_cs_width);
        //cylinder(h = c_thickness + 2, r = c_mounting_screw_size / 2);
    }
    translate([c_width - c_mounting_screw_offset, c_width - c_mounting_screw_offset, -1]) {
        create_screwhole(screwLen = c_thickness+1, screwWidth = c_mounting_screw_size, counterSunkLen = c_mounting_screw_cs_depth, counterSunkWidth = c_mounting_screw_cs_width);
        //cylinder(h = c_thickness + 2, r = c_mounting_screw_size / 2);
    }
}

if (run == 1) {
    if (c_half_bracket == "none") {
        difference() {
            create_base();
            remove_tube();
            if (c_mounting_screws == true) {
                remove_screws();
            }
        }
    } 
}
if (run == 2) {
    difference() {
        difference() {
            create_base();
            remove_tube();
            if (c_mounting_screws == true) {
                remove_screws();
            }
        }
        if (c_half_bracket == "left") {
            cube([c_width + 1, c_width / 2, c_tube_depth + 1]);
        }
        if (c_half_bracket == "right") {
            translate([0, c_width / 2, 0]) {
                cube([c_width + 1, (c_width / 2) + 1, c_tube_depth + 2]);
            }
        }

    }
}
if (run == 3) {
    color("gold")
    render() {
        difference() {
            create_base();
            if (c_drop_in == false) {
                translate([c_width / 2, c_width / 2, 0]) 
                    create_mask(0,0);
            } else {
                translate([c_width / 2, c_width / 2, 0]) 
                    hull() {
                        create_mask(0,0);
                        create_mask(-100,0);
                    }
            }
            if (c_mounting_screws == true) {
                remove_screws();
            }
        }
    }
}

if (run == 4) {
    create_base();
    
    color("gold")
    if (c_mounting_screw_countersunk == true) 
        create_screwhole(c_thickness, c_mounting_screw_size, c_mounting_screw_cs_depth, c_mounting_screw_cs_width);
    else
        create_screwhole(c_thickness, c_mounting_screw_size, 0, 0);
}
