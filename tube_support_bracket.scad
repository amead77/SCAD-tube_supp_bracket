run = 1;
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

c_tubetype = "round"; //[round, square]

c_lip = false; //[true, false]
c_lipsize = 0; //[20]
c_lipdepth = 0; //[20]

c_half_bracket = "none"; //[none, left, right]

module create_base() {
    cube([c_width, c_width, c_thickness]);
}


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


module create_mask() {
    if (c_tubetype == "round") {
        //put in here the cyl or cube shape, then diff it later. instead of creating the mess that is remove_tube()

    }
    if (c_tubetype == "square") {


    }
}


module remove_screws() {
    translate([c_mounting_screw_offset, c_mounting_screw_offset, -1]) {
        cylinder(h = c_thickness + 2, r = c_mounting_screw_size / 2);
    }
    translate([c_mounting_screw_offset, c_width - c_mounting_screw_offset, -1]) {
        cylinder(h = c_thickness + 2, r = c_mounting_screw_size / 2);
    }
    translate([c_width - c_mounting_screw_offset, c_mounting_screw_offset, -1]) {
        cylinder(h = c_thickness + 2, r = c_mounting_screw_size / 2);
    }
    translate([c_width - c_mounting_screw_offset, c_width - c_mounting_screw_offset, -1]) {
        cylinder(h = c_thickness + 2, r = c_mounting_screw_size / 2);
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
    } else {
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



}