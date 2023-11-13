// params

bead_width = 6;
bead_height = 6;
bead_depth = 6;
letters = 14;
number_of_beads = 20;
letters_list = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N"];
base_cutout = false;
double_separator_cover = false;

storage_margin = 0.25;
walls_width = 2;

labels_margin = bead_height + (storage_margin * 2) + 1;
label_engraving_depth = 0.75;

function separatorPosX(slot) = slot * (walls_width + (bead_width + (storage_margin * 2)));

// sample beads
for(i = [0:number_of_beads-1]) {
    posy = (bead_height + 0.01) * i;
    difference() {
        %translate([walls_width + storage_margin, (walls_width + storage_margin) + posy,  walls_width + storage_margin]) 
            color(i % 2 == 0 ? "green" : "pink")
            cube([bead_width, bead_height, bead_depth]);
        %translate([walls_width + storage_margin, (walls_width + storage_margin) + posy + (bead_height * 0.2), walls_width + storage_margin + bead_depth - label_engraving_depth])
            color("purple")
            linear_extrude(label_engraving_depth + 0.1) 
            text(letters_list[0], size = bead_height * .8, font = "Ubuntu Mono:style=Bold");
        
    }
}


// backtop
back_width = (letters * (bead_width + (storage_margin * 2) + walls_width)) + walls_width;
separator_height = number_of_beads * bead_height;

module backplate() {
    difference() {
        cube([back_width, number_of_beads * bead_height + labels_margin + walls_width, walls_width]);
        // substract letters label
        for(i = [0:letters]) {
            translate([separatorPosX(i) + walls_width, separator_height + walls_width, walls_width - label_engraving_depth])
                color("purple")
                linear_extrude(label_engraving_depth + 0.1)
                text(letters_list[i], size = bead_height, font = "Ubuntu Mono:style=Bold");
            if (base_cutout) {
                hole_width = bead_width * .60;
                translate([separatorPosX(i) + walls_width + storage_margin + (bead_width * .33), walls_width * 2, -0.1]) cube([hole_width, separator_height - (walls_width * 2), walls_width + 0.2]);
            }
        }
    }
}

separator_depth = bead_depth + (storage_margin * 2);
// separators and separator cover
module separators() {
    for(i = [0:letters]) {
        // each separator bar
        posx = separatorPosX(i);
        next_posx = separatorPosX(i + 1);
        translate([posx, walls_width, walls_width])
            cube([walls_width, separator_height, separator_depth]);
        // separator cover
        if(i < letters) {
            separator_width_over = bead_width * .33;
            #translate([posx, 0, walls_width + separator_depth]) 
                cube([walls_width + storage_margin + separator_width_over, separator_height, walls_width]);
            // Add separator cover to also cover the end of the slot. Some beads with low depth tend to escape if not covered from both places.
            if(double_separator_cover) {
                extra_width = (i == letters - 1 ? walls_width : 0); // the last one needs to have extra width to cover the missing space
                #translate([next_posx - separator_width_over, 0, walls_width + separator_depth]) 
                    color("purple") 
                    cube([separator_width_over + extra_width, separator_height, walls_width]);
            }
        }
    }
}

backplate();
separators();

// separators base
#translate([0, 0, walls_width]) cube([back_width, walls_width, separator_depth]);
