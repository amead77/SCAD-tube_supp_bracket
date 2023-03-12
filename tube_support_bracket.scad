run = 1;
$fn = 64;
//how wide and tall the mount is (is square)
c_width = 65;
//how thick it is
c_thickness = 18;
//diameter of what is going into it
c_tube_dia = 37.5; //37.5;
//how deep it will go in
c_tube_depth = 15;

//cutout to the top
c_drop_in = true;
//put 4x screw holes
c_mounting_screws = true;
//size of screws
c_mounting_screw_size = 6;
c_mounting_screw_offset = 7;

module create_base() {
    cube([c_width, c_width, c_thickness]);
}


module remove_tube() {
    if (c_drop_in == true) {
        translate([c_width / 2, c_width / 2, c_thickness - c_tube_depth])
        hull() {
            cylinder(h=c_tube_depth+1, r=c_tube_dia / 2);
            translate([c_width / 2, 0, 0]) {
                cylinder(h=c_tube_depth+1, r=c_tube_dia / 2);
            }
        }

    } else {
        translate([c_width / 2, c_width / 2, c_thickness - c_tube_depth])
            cylinder(h=c_tube_depth+1, r=c_tube_dia / 2);
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
    difference() {
        create_base();
        remove_tube();
        if (c_mounting_screws == true) {
            remove_screws();
        }
    }
}