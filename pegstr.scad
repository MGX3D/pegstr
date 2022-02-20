// PEGSTR - Pegboard Wizard
// Design by Marius Gheorghescu, November 2014
// Update log:
// November 9th 2014
//		- first coomplete version. Angled holders are often odd/incorrect.
// November 15th 2014
//		- minor tweaks to increase rendering speed. added logo. 
// November 28th 2014
//		- bug fixes
// Updated by Nick Talavera, February 2022
//      - Set peg hole size to be a consistent size
//      - Simplified holder logic
//      - Corrected calculations for the rotation of the upper curved peg
//      - Added Peg_Length_Ratio_to_Board_Thickness to allow users to set peg length
//      - Added Peg_Diameter_as_Percent_of_Hole_Size multiplier to calculate peg size
//      - Added Hook_Rotation to allow user to set the upper curved peg curvature
//      - Added Peg_Diameter_as_Percent_of_Hole_Size
//      - Fixed holder body overlapping with cutout
//      - Added user input of curved peg angle
//      - Reorganized user inputs
//      - Added GUI options for various user inputs
//      - Added "Is Circle" option to simplify circular objects
//      - Renamed "holder_y_count" to "holder_rows"
//      - Renamed "fn" to "Circle_Resolution"
//      - Renamed "taper_ratio" to "Holder_Taper_Scaling"
//      - Renamed "wall_thickness" to "Space_Between_Holders"
//      - Renamed "strength_factor" to "Support_Percent"
//      - Renamed "holder_offset" to "Holder_Distance_From_Board"
//      - Changed Closed_Bottom, Strength Factor, Holder_Cutout_Percent, and Holder_Taper_Scaling to a 0-100 scale for improving consistency and ease of use
//      - Removed red color due to z-fighting
//      - Removed difficult to print emblem
//      - Moved Board_Thickness, Hole Size, and Hole Spacing to user inputs

/* [Holders] */
// Width of the orifice in mm
holder_x_size = 10.2;

// Depth of the orifice in mm
holder_y_size = 10.2;

// Height of the holder in mm
holder_height = 15;

// Distance from the peg board in mm. Typically 0 unless you have an object that needs clearance
Holder_Distance_From_Board = 0.0;

// Space between items as well as the outside wall thickness
Space_Between_Holders = 1.85;

// Number of holders in the left/right direction
holder_x_count = 1;

// Number of rows of holders
holder_rows = 2;

// Use values less than 100 to make the bottom of the holder narrow
Holder_Taper_Scaling = 100;// [0:5:100]

// what ratio of the holders bottom is reinforced to the plate
Support_Percent = 100; //[0:1:100]

// for bins: what ratio of wall thickness to use for closing the bottom. 100 is full
closed_bottom = 0.0; //[0:1:100]

// what percentage cu cut in the front (example to slip in a cable or make the tool snap from the side)
Holder_Cutout_Percent = 0.0; //[0:1:100]

// set an angle for the holder to prevent object from sliding or to view it better from the top
holder_angle = 0.1; //[-90:0.1:45]

/* [Corners] */

// Sets the corner radius properly for circles. Only words if holder_x_size equals holder_y_size.
Is_Circle=false;
// Holder corner radius (roundness). Needs to be less than min(x,y)/2. If "Is Circle" is selected, this option is ignored.
corner_radius_holder = 5.1;


/* [Pegs] */
//The amount of vertical rotation for the upper hook in degrees.
Hook_Rotation=97;
//The diameter is X percent of the pegboard's hole size.
Peg_Diameter_as_Percent_of_Hole_Size=95;
//How long the straight part of the peg as a multiplier of the board thickness.
Peg_Length_Ratio_to_Board_Thickness=1.5;
        
/* [Pegboard Details] */
Hole_Spacing = 25.4;
Hole_Size = 6.0035;
Board_Thickness = 4.9;

/* [Advanced] */

// 1-100 what is the $fn parameter for holders
Circle_Resolution = 60; //[0:100]

/* [Hidden] */

// what is the $fn parameter
holder_cutout_side = Holder_Cutout_Percent/100;
holder_sides = max(Circle_Resolution, min(20, holder_x_size*2));
corner_radius = Is_Circle && holder_x_size == holder_y_size ? holder_x_size/2 : corner_radius_holder;

SPACER=0.03;
peg_diameter=Hole_Size*Peg_Diameter_as_Percent_of_Hole_Size/100;

holder_total_x = Space_Between_Holders + holder_x_count*(Space_Between_Holders+holder_x_size);
holder_total_y = Space_Between_Holders + holder_rows*(Space_Between_Holders+holder_y_size);
holder_total_z = round(holder_height/Hole_Spacing)*Hole_Spacing;
holder_roundness = min(corner_radius, holder_x_size/2, holder_y_size/2); 



epsilon = 0.1;
clip_height = 2*Hole_Size;
$fn = Circle_Resolution;

module round_rect_ex(x1, y1, x2, y2, z, r1, r2)
{
	$fn=holder_sides;
	brim = z/10;

	//rotate([0,0,(holder_sides==6)?30:((holder_sides==4)?45:0)])
	hull() {
        translate([-x1/2 + r1, y1/2 - r1, z/2-brim/2])
            cylinder(r=r1, h=brim,center=true);
        translate([x1/2 - r1, y1/2 - r1, z/2-brim/2])
            cylinder(r=r1, h=brim,center=true);
        translate([-x1/2 + r1, -y1/2 + r1, z/2-brim/2])
            cylinder(r=r1, h=brim,center=true);
        translate([x1/2 - r1, -y1/2 + r1, z/2-brim/2])
            cylinder(r=r1, h=brim,center=true);

        translate([-x2/2 + r2, y2/2 - r2, -z/2+brim/2])
            cylinder(r=r2, h=brim,center=true);
        translate([x2/2 - r2, y2/2 - r2, -z/2+brim/2])
            cylinder(r=r2, h=brim,center=true);
        translate([-x2/2 + r2, -y2/2 + r2, -z/2+brim/2])
            cylinder(r=r2, h=brim,center=true);
        translate([x2/2 - r2, -y2/2 + r2, -z/2+brim/2])
            cylinder(r=r2, h=brim,center=true);

    }
}

module peg(clip)
{
	cylinder(d=peg_diameter, h=Board_Thickness*Peg_Length_Ratio_to_Board_Thickness+epsilon, center=true, $fn=Circle_Resolution);
	if (clip) {
			translate([-peg_diameter, 0, peg_diameter/2]) 
        				rotate([90, 180-Hook_Rotation, 0])
		rotate_extrude(angle=-Hook_Rotation,convexity=10) 
        translate([-peg_diameter,0,0]) 
        circle(d = peg_diameter);
	}
}

module pegboard_clips() 
{
	rotate([0,90,0])
	for(i=[0:round(holder_total_x/Hole_Spacing)]) {
		for(j=[0:max((Support_Percent/100), round(holder_height/Hole_Spacing))]) {

			translate([
				j*Hole_Spacing, 
				-Hole_Spacing*(round(holder_total_x/Hole_Spacing)/2) + i*Hole_Spacing, 
				0])
					peg(j==0);
		}
	}
}

module pegboard(clips)
{
	rotate([0,90,0])
	translate([-epsilon, 0, -Space_Between_Holders - Board_Thickness/2 + epsilon])
	hull() {
		translate([-clip_height/2 + Hole_Size/2, 
			-Hole_Spacing*(round(holder_total_x/Hole_Spacing)/2),0])
			cylinder(r=Hole_Size/2, h=Space_Between_Holders);

		translate([-clip_height/2 + Hole_Size/2, 
			Hole_Spacing*(round(holder_total_x/Hole_Spacing)/2),0])
			cylinder(r=Hole_Size/2,  h=Space_Between_Holders);

		translate([max((Support_Percent/100), round(holder_height/Hole_Spacing))*Hole_Spacing,
			-Hole_Spacing*(round(holder_total_x/Hole_Spacing)/2),0])
			cylinder(r=Hole_Size/2, h=Space_Between_Holders);

		translate([max((Support_Percent/100), round(holder_height/Hole_Spacing))*Hole_Spacing,
			Hole_Spacing*(round(holder_total_x/Hole_Spacing)/2),0])
			cylinder(r=Hole_Size/2,  h=Space_Between_Holders);

	}
}

module holder(indicator)
{
	for(x=[1:holder_x_count]){
		for(y=[1:holder_rows]) 
/*		render(convexity=2)*/ {

        y_tapered = holder_y_size*Holder_Taper_Scaling/100;
        x_tapered = holder_x_size*Holder_Taper_Scaling/100;
        roundness_tapered = holder_roundness*Holder_Taper_Scaling/100 + epsilon;
        three_height = 3*max(holder_height, Hole_Spacing);
        y_side_space = holder_y_size + 2*Space_Between_Holders;
        x_side_space = holder_x_size + 2*Space_Between_Holders;
        height_w_epsilon = holder_height+2*epsilon;
        roundness_w_epsilon = holder_roundness + epsilon;

			translate([
				-holder_total_y /*- (holder_y_size+Space_Between_Holders)/2*/ + y*(holder_y_size+Space_Between_Holders) + Space_Between_Holders,

				-holder_total_x/2 + (holder_x_size+Space_Between_Holders)/2 + (x-1)*(holder_x_size+Space_Between_Holders) + Space_Between_Holders/2,
				 0])			
	{
		rotate([0, holder_angle, 0])
		translate([
			-Space_Between_Holders*abs(sin(holder_angle))-0*abs((holder_y_size/2)*sin(holder_angle))-Holder_Distance_From_Board-SPACER*2-(y_side_space)/2 - Board_Thickness/2,
			0,
			-(holder_height/2)*sin(holder_angle) - holder_height/2 + clip_height/2
		])
        
		difference() {
                
				translate([0,0,
                        !indicator ? 0: (closed_bottom/100)*Space_Between_Holders])
					round_rect_ex(
                        !indicator ? y_side_space:
                        indicator>1 ? y_tapered:
						holder_y_size, 
                        !indicator ? x_side_space:
                        indicator>1 ? x_tapered:
						holder_x_size, 
                        !indicator ? y_side_space * Holder_Taper_Scaling / 100:
						y_tapered, 
                        !indicator ? x_side_space * Holder_Taper_Scaling / 100:
						x_tapered, 
                        !indicator ? holder_height:
                        indicator>1 ? three_height:
						height_w_epsilon,
                        indicator>1 ? roundness_tapered:
						roundness_w_epsilon, 
						roundness_tapered);
                        
			if (!indicator && holder_cutout_side > 0)
					hull() 
                    {
						scale([1.0, holder_cutout_side, 1.0])
                            
					round_rect_ex(
                        indicator>1 ? y_tapered:
						holder_y_size, 
                        indicator>1 ? x_tapered:
						holder_x_size, 
						y_tapered, 
						x_tapered, 
                        indicator>1 ? three_height:
						height_w_epsilon,
                        indicator>1 ? roundness_tapered:
						roundness_w_epsilon, 
						roundness_tapered);
		
						translate([0-(y_side_space), 0,0])
						scale([1.0, holder_cutout_side, 1.0])
					round_rect_ex(
                        indicator>1 ? y_tapered:
						holder_y_size, 
                        indicator>1 ? x_tapered:
						holder_x_size, 
						y_tapered, 
						x_tapered, 
                        indicator>1 ? three_height:
						height_w_epsilon,
                        indicator>1 ? roundness_tapered:
						roundness_w_epsilon, 
						roundness_tapered);
                    }
			}
		} // positioning
	} // for y
	} // for X
}


module pegstr() 
{
	difference() {
		union() {

			pegboard();


			difference() 
            {
				hull() {
					pegboard();
	
					intersection() {
						translate([-Holder_Distance_From_Board - ((Support_Percent/100)-0.5)*holder_total_y - Space_Between_Holders/4,0,0])
						cube([
							holder_total_y + 2*Space_Between_Holders-(holder_y_size*Holder_Taper_Scaling/100*holder_cutout_side), 
							holder_total_x + Space_Between_Holders, 
							2*holder_height
						], center=true);
////	
						holder(0);
//	
					}	
				}

				if ((closed_bottom/100)*Space_Between_Holders < epsilon) {
						holder(2);
				}

			}

			difference() {
				holder(0);
				holder(2);
			}

			color([1,0,0])
				pegboard_clips();
		}
	
		holder(1);

	}
}


rotate([180,0,0]) pegstr();

