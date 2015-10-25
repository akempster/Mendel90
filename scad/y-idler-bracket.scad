//
// Mendel90
//
// GNU GPL v2
// nop.head@gmail.com
// hydraraptor.blogspot.com
//
// Holds the idler pulley
//
// Edited by Alex Kempster
// Improved design to allow for more consistent
// belt tensioner allignment and reduces possibility of 
// detensioning over time

include <conf/config.scad>
use <y-motor-bracket.scad>

slot_length  = 10;

slot            = base_nut_traps ? 0 : slot_length;
axle_height     = y_motor_height() + pulley_inner_radius - ball_bearing_diameter(Y_idler_bearing) / 2;
base_thickness  = part_base_thickness + (base_nut_traps ? nut_trap_depth(base_nut) : 0);
wall            = default_wall;
backplate_offset = 40;

clearance   = 1;
dia         = washer_diameter(M5_penny_washer) + 2 * clearance;
tab_length  = washer_diameter(base_washer) + 2 * clearance + slot;
length      = dia + wall + tab_length;

wing_width = 20;

function y_idler_travel()       = slot_length;
function y_idler_clearance()    = dia / 2 + slot_length / 2;
function y_idler_offset()       = dia / 2 + wall + tab_length;

width = (wall + washer_thickness(M5_penny_washer) + washer_thickness(M4_washer) + ball_bearing_width(Y_idler_bearing)) * 2;
back_width = washer_diameter(base_washer) + 2 * clearance + 2 * wall;

height = axle_height + dia / 2;

module y_idler_backplate_stl()
{   
    color(y_idler_bracket_color) 
    translate([0, backplate_offset, 0])
    {      
        union()
        {
            // central join
            translate([-dia/2, 0, 0])
            {
                cube([dia, wall+5, axle_height]);
            }
            
            // bottom section
            translate([-(dia + 2*wing_width)/2, -20, -3-6])
            {
                cube([dia + 2*wing_width, wall+5+20, 6]);
            }
            
            // bottom to top join
            translate([-(dia + 2*wing_width)/2, 0, -3])
            {
                cube([dia+2*wing_width, wall+5, 3]);
            }
            
            // securing tab
            translate([-(dia + 2*wing_width)/2, -5, 0])
            {
                cube([dia+2*wing_width, wall+5+5, 5]);
            }
            
            // left side wing
            translate([-wing_width-width/2+wall, 0, 0])
            {
                difference()
                {
                    cube([wing_width, wall+5, axle_height]);
                    
                    translate([wing_width/2, 20, axle_height/2])
                    {
                        rotate([90, 30, 0])
                        {
                            nut_trap(screw_clearance_radius(M4_cap_screw), nut_radius(screw_nut(M4_cap_screw)), 5);
                        }
                    }
                }
            }
        
            // right side wing
            translate([(width/2)-wall/2, 0, 0])
            {
                difference()
                {
                    cube([wing_width, wall+5, axle_height]);
                    
                    translate([wing_width/2, 20, axle_height/2])
                    {
                        rotate([90, 30, 0])
                        {
                            nut_trap(screw_clearance_radius(M4_cap_screw), nut_radius(screw_nut(M4_cap_screw)), 5);
                        }
                    }
                }
            }
        }
    }
}

module y_idler_bracket_stl() {
    stl("y_idler_bracket");

    color(y_idler_bracket_color) 
    union()
    {
    intersection() 
    {
        difference() 
        {
            rotate([90, 0, 90])
            {
                // side profile
                linear_extrude(height = width, center = true)
                {
                    hull() 
                    {
                        // top front edge curve
                        translate([0, axle_height])
                        {
                            circle(dia / 2);
                        }

                        // bottom plate
                        translate([-dia / 2 , 0])
                        {
                            square([length, base_thickness]);   // base
                        }
                    }
                }
            }
            
            // cavity for bearing
            translate([0, - dia / 2, height + part_base_thickness])
            {
                rotate([0, 90, 0])
                {
                    rounded_rectangle(size = [height * 2, dia * 2,  width - 2 * wall], r = dia / 2);
                }
            }

            // hole for axle
            translate([0, 0, axle_height])
            {
                rotate([90, 0, 90])
                {
                    teardrop_plus(r = M4_clearance_radius, h = width + 1, center = true);
                }
            }
        }
            
        // plan profile
        translate([0, (length - tab_length) / 2 - dia / 2, -1])
        {
            rounded_rectangle([width - eta, length - tab_length - eta, height + 2], r = 2, center = false);
        }
    }
    
    // left side wing
    translate([-wing_width-width/2+wall, (dia/2)-5, 0])
    {
        difference()
        {
            cube([wing_width, wall+5, axle_height]);
            
            translate([wing_width/2, 0, axle_height/2])
            {
                rotate([90, 30, 0])
                {
                    nut_trap(screw_clearance_radius(M4_cap_screw), nut_radius(screw_nut(M4_cap_screw)), 5);
                }
            }
        }
    }
    
    // right side wing
    translate([(width/2)-wall/2, (dia/2)-5, 0])
    {
        difference()
        {
            cube([wing_width, wall+5, axle_height]);
            
            translate([wing_width/2, 0, axle_height/2])
            {
                rotate([90, 30, 0])
                {
                    nut_trap(screw_clearance_radius(M4_cap_screw), nut_radius(screw_nut(M4_cap_screw)), 5);
                }
            }
        }
    }
    }
}

nut_offset = base_nut_traps ? -tab_length / 2 + nut_radius(base_nut) + 0.5 : 0;

module y_idler_screw_hole_position()
{
    translate([0, dia / 2 + wall + tab_length / 2 + nut_offset,0])
    {
        children(0);
    }
}

module y_idler_screw_hole()
{
    y_idler_screw_hole_position()
        if(base_nut_traps)
        {
            //translate([0, -slot_length / 2, 0])
                rotate([0, 0, 90])
                {
                    slot(h = 100, l = slot_length, 
                            r = screw_clearance_radius(base_screw), center = true);
                }
        }
        else
        {
            base_screw_hole();
        }
}

module y_idler_assembly() 
{
    assembly("y_idler_assembly");

    color(y_idler_bracket_color) render() y_idler_bracket_stl();

    y_idler_backplate_stl();
    
    translate([0, 0, axle_height]) rotate([0, -90, 0]) 
    {
        explode([20, -20, 0])
        {
            for(side = [-1, 1]) 
            {
                // ball bearing
                translate([0, 0, 
                    (ball_bearing_width(Y_idler_bearing) / 2 + exploded) * side])
                {
                    ball_bearing(BB624);
                }
                
                translate([0, 0, (ball_bearing_width(Y_idler_bearing) + exploded * 4) * side])
                {
                    rotate([0, side * 90 - 90, 0])
                    {
                        washer(M4_washer);
                    }
                }
                
                translate([0, 0, (ball_bearing_width(Y_idler_bearing) + washer_thickness(M4_washer) + exploded * 6) * side])
                {
                    rotate([0, side * 90 - 90, 0])
                    {
                        washer(M5_penny_washer);
                    }
                }
            }
        }
 
        // the axle screw
        translate([0, 0, width / 2])
        {
            screw_and_washer(M4_cap_screw, 30);
        }

        // nut and washer for the axle
        translate([0, 0, -width / 2])
        {
            rotate([180, 0, 0])
            {
                nut_and_washer(M4_nut, true);
            }
        }
    }

    end("y_idler_assembly");
    
    // backplate bracket vitamins
    translate([2.75-wing_width, backplate_offset + wall + 5, axle_height/2])
    {
        rotate([270, 30, 0])
        {
            screw_and_washer(M4_cap_screw, 60);
            
            translate([0, 0, -(backplate_offset+2.5)])
            {
                nut(M4_nut);
            }
        }
    }
    
    translate([wing_width-1.75, backplate_offset + wall + 5, axle_height/2])
    {
        rotate([270, 30, 0])
        {
            screw_and_washer(M4_cap_screw, 60);
            
            translate([0, 0, -(backplate_offset+2.5)])
            {
                nut(M4_nut);
            }
        }
    }
}


if(1)
{
    y_idler_assembly();
} else
{
    y_idler_bracket_stl();
    y_idler_backplate_stl();
}