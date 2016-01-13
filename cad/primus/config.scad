// Axis conventions:
//   X ("length"): longest dimension of a key.
//     0 at the intersection of bow and blade,
//     increasing towards the end of the blade.
//   Y ("height"): dimension that lifts the pins.
//     0 at bottom of key,
//     increasing towards the bitting.
//   Z ("thickness"): shortest dimension of a key.
//     0 at the right (sidebar) side of the key,
//     *decreasing* towards the left side.
//   All measurements are in inches.

// *************************
// * General configuration *
// *************************

// Length at which the blade of the key will be truncated.
blade_length = 1.242;  // measured from key

// Thickness of the key at the widest point.
key_thickness = 0.090;  // measured from key

// Height of the blade of the key.  All cut depths are indexed from here.
blade_height = 0.335;  // from schlage spec

// Size of the bow.  This property is purely cosmetic.
bow_size = 0.500;

// Radius of a lock cylinder (used to round the bottom of the key).
cylinder_radius = 0.250;  // from schlage spec

// *********
// * Wards *
// *********

// Height between the bottom of the lowest ward and the bottom of the key.
bottom_ward_offset = 0.025;  // measured from lock

// Height of the lowest ward.
bottom_ward_height = 0.050;  // measured from lock

// Thickness of the lowest ward.
bottom_ward_thickness = 0.025;  // measured from lock

// Thickness of the ward above the sidebar.
// (This is a bit larger than sidebar_thickness.)
sidebar_ward_thickness = 0.050;  // measured from key

// Height above the bottom of the key where the sidebar ward begins to taper
// outwards towards the top half of the blade.
sidebar_ward_chamfer_height = 0.150;  // measured from lock

// Height above the bottom of the key where the non-sidebar side begins to
// taper inwards towards the top half of the blade.
top_chamfer_height = 0.150;  // measured from lock

// Thickness between the top half of the blade and the sidebar side of the key.
top_offset = 0.022;  // measured from lock

// Thickness of the top half of the blade.
top_thickness = 0.035;  // measured from lock

// ***************
// * Top bitting *
// ***************

// Length between the bow and the center of the first cut.
bitting_start = 0.231;  // from schlage spec

// Length between neighboring cuts.
bitting_step = 0.1562;  // from schlage spec

// Height increment used to define cut depths.
cut_step = 0.015;  // from schlage spec

// Size of the flat spot at the center of each cut.
cut_length = 0.050;  // from schlage spec, with some extra margin

// Height of the control cut for LFIC cylinders.
control_height = 0.244;  // measured from key

// ***********
// * Sidebar *
// ***********

// Thickness of the sidebar cuts from the right side of the key.
sidebar_thickness = 0.050;  // measured from key

// Height of the top of the sidebar cuts from the bottom of the key.
sidebar_top_height = 0.085;  // measured from key

// Effective radius of the bottom of a finger pin.
sidebar_radius = 0.029;  // measured from lock

// Heights of the bottoms of sidebar cuts.  lr = left/right, ctr = center.
sidebar_deep_lr_height = 0.024;  // measured from key
sidebar_deep_ctr_height = 0.036;  // measured from key
sidebar_shallow_lr_height = 0.048;  // measured from key
sidebar_shallow_ctr_height = 0.060;  // measured from key

// Length offset of a left or right cut from the nominal center position.
sidebar_lr_offset = 0.032;  // measured from key

// Maximum length that a finger pin is able to move from the nominal center.
// Used to determine how far ramps must extend to the side of each cut.
sidebar_max_offset = 0.065;  // deduced from cutaway lock

// Minimum slope of a cut such that a finger pin will still fall to the center.
sidebar_min_slope = 0.6;  // deduced from cutaway lock
