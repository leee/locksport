// Physical Keygen - by Nirav Patel <http://eclecti.cc>
//
// Generate a duplicate of a Kryptonite Evolution bike lock key by editing 
// the last line of the file and entering in the key code of the lock.  If you
// don't know the key code, you're going to need to get creative.  The first
// digit of the code is on the side closest to the shoulder. 6 is the minimum
// cut, which is uncut. 1 (0?) is the maximum cut.
//
// This work is licensed under a Creative Commons Attribution 3.0 Unported License.

module rounded(size, r) {
    union() {
        translate([r, 0, 0]) cube([size[0]-2*r, size[1], size[2]]);
        translate([0, r, 0]) cube([size[0], size[1]-2*r, size[2]]);
        translate([r, r, 0]) cylinder(h=size[2], r=r);
        translate([size[0]-r, r, 0]) cylinder(h=size[2], r=r);
        translate([r, size[1]-r, 0]) cylinder(h=size[2], r=r);
        translate([size[0]-r, size[1]-r, 0]) cylinder(h=size[2], r=r);
    }
}

module fillet(h, r) {
    difference() {
        cube([r, r, h]);
        translate([r, r, 0]) cylinder(h=h, r=r, $fn=32);
    }
}

module disc(thickness, angle) {
    rotate([angle, 0, 0]) cube([thickness, 10, 10]);
}

// Kryptonite U-Lock key.  Reverse engineered with guesses from one key.
module kryptonite(bits) {
    // You may need to adjust these to fit your specific printer settings
    thickness = 2.75;
    length = 25.0;
    width = 6.5;
    
    shoulder = 3.0; // from tip
    depth_inc = 18; // degrees
    num_discs = 5;
    
    spacing = 1.6; // distance from the center of one disc to the next
    disc = 1.11; // thickness of the discs that will turn
    spacer = 0.51; // thickness of the spacers between the discs
    
    // Handle size
    h_l = 25;
    h_w = 25;
    
    difference() {
        union() {
            difference() {
                // blade and key handle
                union() {
                    translate([-h_l, -h_w/2 + width/2, 0]) rounded([h_l, h_w, thickness], 5.5);
                    
                    translate([0, width-0.5, 0]) fillet(thickness, 3);
                    translate([0, 0.5, 0]) mirror([0, 1, 0]) fillet(thickness, 3);
                    
                    intersection() {
                        translate([-1,0,0]) cube([length+1, width, thickness]);
                        
                        translate([-1, width/2, thickness/2]) rotate([0, 90, 0]) cylinder(h=length+1, r=width/2, $fn=64); 
                    }
                }
                
                // chamfer the tip
               translate([length, width*(3/4), 0]) rotate([0, 0, 45]) cube([10, 10, thickness]);
               translate([length, width*(1/4), 0]) rotate([0, 0, 225]) cube([10, 10, thickness]);
                
                // put in a hole for keychain use
                translate([-h_l + 5, width/2, 0]) cylinder(h=thickness, r=3);
         
                // cut the actual bitting
                for (d = [0:(num_discs-1)]) {
                    translate([length-shoulder-((num_discs-1)-d)*spacing-spacer, 4.0, thickness]) disc(spacer, -(6-bits[d])*depth_inc);
                    translate([length-shoulder-((num_discs-1)-d)*spacing-spacing, 4.0, thickness]) disc(disc, -(6-bits[d])*depth_inc);
                    translate([length-shoulder-((num_discs-1)-d)*spacing-(spacing+spacer), 4.0, thickness]) disc(spacer, -(6-bits[d])*depth_inc);
                }
                
                
                // cut some opposing bitting for added strength
                translate([0, width, thickness]) rotate([180, 0, 0])
                for (d = [0:(num_discs-1)]) {
                    if ((bits[d] == 4) || (bits[d] == 5)) {
                        translate([length-shoulder-((num_discs-1)-d)*spacing-spacer, 4.0, thickness]) disc(spacer, -(3)*depth_inc);
                        translate([length-shoulder-((num_discs-1)-d)*spacing-spacing, 4.0, thickness]) disc(disc, -(3)*depth_inc);
                        translate([length-shoulder-((num_discs-1)-d)*spacing-(spacing+spacer), 4.0, thickness]) disc(spacer, -(3)*depth_inc);
                    } else {
                        translate([length-shoulder-((num_discs-1)-d)*spacing-spacer, 4.0, thickness]) disc(spacer, -(6-bits[d])*depth_inc);
                        translate([length-shoulder-((num_discs-1)-d)*spacing-spacing, 4.0, thickness]) disc(disc, -(6-bits[d])*depth_inc);
                        translate([length-shoulder-((num_discs-1)-d)*spacing-(spacing+spacer), 4.0, thickness]) disc(spacer, -(6-bits[d])*depth_inc);
                    }
                }
                
/*
                // cut an open channel into the other side.  one interfacing surface is enough
                translate([length-shoulder-(num_discs*spacing+spacer), 0, 0]) {
                    cube([num_discs*spacing+spacer, 2, thickness]);
                    translate([0, 2, thickness/3]) rotate([220, 0, 0]) cube([num_discs*spacing+spacer, 2, thickness]);
                }
*/
            }
            
            // adds back in some thickness for the low value bits
            union() {
                translate([length-shoulder-(num_discs*spacing+spacer), 4.0, 0]) {
                    cube([num_discs*spacing+spacer, 0.5, thickness-1.25]);
                    translate([0, 0, thickness-1.25]) scale([1, 1, 2.5]) rotate([0, 90, 0]) cylinder(h=num_discs*spacing+spacer, r=0.5, $fn=32);
                }
            }
        }
        
        // cut the channels for the warded disc at the front
        translate([length-shoulder-((num_discs+2)*spacing+spacer), width/2, 0]) rotate([30, 0, 0]) rotate([0, 90, 0]) cylinder(h=length, r=1.1, $fn=6);
        translate([length-shoulder-((num_discs+2)*spacing+spacer), width/2, thickness+0.25]) rotate([0, 90, 0]) cylinder(h=length, r=1.0, $fn=16);
    }
}

// This sample key goes to a lock that is on my desk
kryptonite([3,4,5,6,3]);
