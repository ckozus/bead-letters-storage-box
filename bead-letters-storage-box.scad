// params

bead_width = 6;
bead_height = 6;
bead_depth = 6;
letters = 14;
number_of_beads = 20;
letters_list = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N"];
cutout = false;

storage_margin = 0.25;
walls_width = 2;

labels_margin = bead_height + (storage_margin * 2) + 1;
label_engraving_depth = 0.75;

// calculations
back_width = (letters * (bead_width + (storage_margin * 2) + walls_width)) + walls_width;

// sample bead
%translate([walls_width + storage_margin, walls_width + storage_margin,  walls_width + storage_margin]) color("blue") cube([bead_width, bead_height, bead_depth]);

function separatorPosX(i) = i * (walls_width + (bead_width + (storage_margin * 2)));

// backtop
separator_height = number_of_beads * bead_height;

difference() {
    cube([back_width, number_of_beads * bead_height + labels_margin + walls_width, walls_width]);
    // substract letters label
    for(i = [0:letters]) {
        translate([separatorPosX(i) + walls_width, separator_height + walls_width, walls_width - label_engraving_depth]) color("purple") linear_extrude(label_engraving_depth + 0.1) text(letters_list[i], size = bead_height, font = "Ubuntu Mono:style=Bold");
        if (cutout) {
            hole_width = bead_width * .60;
            translate([separatorPosX(i) + walls_width + storage_margin + (bead_width * .33), walls_width * 2, -0.1]) cube([hole_width, separator_height - (walls_width * 2), walls_width + 0.2]);
        }
    }
    for(i = [0:letters]) {
    }
}

// separators and separator cover
separator_depth = bead_depth + (storage_margin * 2);
for(i = [0:letters]) {
    // separator
    posx = separatorPosX(i);
    #translate([posx, walls_width, walls_width]) cube([walls_width, separator_height, separator_depth]);
    // separator cover
    if(i < letters) {
      #translate([posx, 0, walls_width + separator_depth]) cube([walls_width + storage_margin + (bead_width * .33), separator_height, walls_width]);
    }
}

// separators base
#translate([0, 0, walls_width]) cube([back_width, walls_width, separator_depth]);
