include <config.scad>;

// Extend 2D shapes to span the thickness of the key in the X-Y plane.
module extrude() {
  for (i = [0 : $children - 1])
      translate([0, 0, -key_thickness])
            linear_extrude(height = key_thickness)
	            child(i);
		    }

// Handle of the key.
module bow() {
  extrude()
      translate([-bow_size / 2, blade_height / 2])
            square(bow_size, center = true);
	    }

// All material that should be subtracted to make a working top bitting.
module bitting(code, control, minimal) {
  // Function that gives the height of cut i
    function height(i) = (i == 6 ? control_height - blade_height :
    	     	       	 -1 * code[i] * cut_step);
			   last_cut = control ? 6 : 5;
			     translate([bitting_start - cut_length / 2, blade_height]) {
			         extrude() {
				       // The cuts themselves.
				             for(i = [0 : last_cut])
					             translate([i * bitting_step, height(i)])
						               minkowski() {
							                   rotate([0, 0, 45]) square(blade_height);
									               square([cut_length, blade_height]);
										                 }
												       // Ramps between the cuts.
												             if(minimal)
													             for(i = [0 : last_cut - 1])
														               translate([i * bitting_step, 0])
															                   polygon([[cut_length, 0], [cut_length, height(i)],
																	                        [bitting_step, height(i + 1)], [bitting_step, 0]]);
																				      // Chamfer down from the last cut, with a bump iff minimal = false.
																				            translate([last_cut * bitting_step + cut_length,
																					    			   (minimal || control) ? height(last_cut) : 0])
																								           polygon([[-1, 1], [2, 1], [2, -2]] * blade_height);
																									       }
																									         }
																										 }

// 2D area that shall be subtracted to make the ramps for one finger pin.
module sidebar_ramp(offset, height) {
  max_offset = (sidebar_top_height - height) / sidebar_min_slope;
    left_offset = bitting_step - sidebar_max_offset + offset;
      right_offset = bitting_step - sidebar_max_offset - offset;
        intersection() {
	    minkowski() {
	          // Cutting tool
		        circle(sidebar_radius, $fn = 360);
			      // Tool path
			            translate([offset, sidebar_radius])
				            polygon([[0, height],
					                     [-min(left_offset, max_offset), sidebar_top_height],
							                      [min(right_offset, max_offset), sidebar_top_height]]);
									          }
										      // Ignore the extra tool path above the sidebar.
										          square([blade_length, 2 * sidebar_top_height], center = true);
											    }
											    }

// Material that shall be subtracted to make a complete working sidebar.
module sidebar(code) {
  // Lists indexed by sidebar codes: 0 = no cut, 1-6 are according to the spec.
    offsets = [0, -sidebar_lr_offset, -sidebar_lr_offset,
                 0, 0, sidebar_lr_offset, sidebar_lr_offset];
		   heights = [blade_height, sidebar_shallow_lr_height,
		                sidebar_deep_lr_height, sidebar_shallow_ctr_height,
				             sidebar_deep_ctr_height, sidebar_shallow_lr_height,
					                  sidebar_deep_lr_height];
							    // Length coordinate of the end of the final sidebar ramp.
							      end = bitting_start + 4.5 * bitting_step + sidebar_max_offset +
							            sidebar_top_height;
								      // Paths to be removed from the side of the key:
								        translate([0, 0, -sidebar_thickness]) {
									    // Sidebar bitting.
									        for(i = [0 : 4])
										      linear_extrude(height = key_thickness)
										              translate([bitting_start + (i + .5) * bitting_step, 0])
											                sidebar_ramp(offsets[code[i]], heights[code[i]]);
													    // Final ramp down.
													        linear_extrude(height = key_thickness)
														      polygon([[blade_length, 0], [blade_length, sidebar_top_height],
														                     [end - sidebar_top_height, sidebar_top_height], [end, 0]]);
																       }
																         // Chamfer up from the end of the sidebar.
																	   extrude()
																	       translate([end, 0])
																	             polygon([[0, 0], [2, 2], [2, 0]] * blade_height);
																		     }

// 2D cross section of keyway wards, in the Z-Y plane.
module wards() {
  difference() {
      // Top half of blade and ward above sidebar.
          polygon([[0, 0],
	               [-key_thickness, 0],
		                    [-key_thickness, top_chamfer_height],
				                 [-top_offset - top_thickness, top_chamfer_height +
						               key_thickness - top_offset - top_thickness],
							                    [-top_offset - top_thickness, blade_height],
									                 [-top_offset, blade_height],
											              [-top_offset, sidebar_ward_chamfer_height +
												                    sidebar_ward_thickness - top_offset],
														                 [-sidebar_ward_thickness, sidebar_ward_chamfer_height],
																              [-sidebar_ward_thickness, sidebar_top_height],
																	                   [0, sidebar_top_height]]);
																			       // Bottom ward.
																			           translate([-key_thickness, bottom_ward_offset])
																				         square([bottom_ward_thickness, bottom_ward_height]);
																					   }
																					   }

// Constraints of the lock cylinder: wards, maximum key length, and rounding.
module envelope() {
  eps = .001; // extra overlap to join the blade with the bow
    intersection() {
        // Cylinder, to round off the bottom of the key.
	    translate([-eps, cylinder_radius, -key_thickness / 2])
	          rotate([0, 90, 0])
		          cylinder(blade_length + eps, r = cylinder_radius, $fn = 360);
			      // Box to trim the sides.  Without it we get 0-thickness artifacts.
			          extrude()
				        translate([-eps, 0])
					        square([blade_length + eps, blade_height]);
						    // Extrude the cross section of the wards.
						        translate([blade_length, 0])
							      rotate([0, -90, 0])
							              linear_extrude(height = blade_length + eps)
								                wards();
										  }
										  }

// top_code is a list of 6 integers describing the top bitting.
// side_code is a list of 5 integers describing the sidebar bitting.
// If control = true, a LFIC removal key will be created.
// If minimal = true, there will be flat ramps between the cuts.
// If minimal = false, the usual bumps will be placed between the cuts.
module key(top_code, side_code, control = false, minimal = true) {
  bow();
    difference() {
        envelope();
	    bitting(top_code, control, minimal);
	        sidebar(side_code);
		  }
		  }

key([3,5,2,4,2,3],[2,1,3,1,4],false,true);