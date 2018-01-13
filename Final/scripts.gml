#define lightmap_init
//DOES: Uses this object as a lightmap

//USAGE: lightmap_init(<width>,<height>);

//Defines a few variables
lightmap_width = argument0;
lightmap_height = argument1;

//Create a surface for lights to draw on
lightmap_surface_id = surface_create(lightmap_width,lightmap_height);

//Lightmap settings
lightmap_set_ambient(0.3);                      //sets the default lightmap ambient
lightmap_set_shadows_enabled(true);             //sets the default shadowing
lightmap_set_light_parent_object(-1);           //sets the light parent object
lightmap_set_caster_parent_object(-1);          //sets the light parent object
lightmap_move_with_view(false);                 //sets wether this should move with the view

lightmap_shadow_surface_width = 256;
lightmap_shadow_surface_height = 256;
lightmap_shadow_surface_id = surface_create(lightmap_shadow_surface_width, lightmap_shadow_surface_height);

#define lightmap_draw
//DOES: draws the lightmap to the screen

//USAGE: lightmap_draw();

//set the blend mode to multiply
draw_set_blend_mode_ext(bm_dest_color,bm_zero);

//draw the surface to the screen
if(lightmap_move){
    draw_surface(lightmap_surface_id,view_xview,view_yview);
}else{
    draw_surface(lightmap_surface_id,x,y);
}

//reset blend mode to normal (this CAN cause bugs, further explination below)
draw_set_blend_mode(bm_normal);

//EXPLAINATION:
/*
It is possible that if you where drawing with a certain blend mode (e.a. bm_add)
and you use this function half way through, it will set the blend mode to normal 
again. You will have to reset it to bm_add. 

*/

#define lightmap_update
//DOES: updates the lightmap and redraws the light.

//USAGE: lightmap_update();

//check if the lightmap surface exists
if(!surface_exists(lightmap_surface_id)){
    //if it does not exist, recreate it
    lightmap_surface_id = surface_create(lightmap_width,lightmap_height);
}
//bind the lightmap surface
surface_set_target(lightmap_surface_id);

//clear with the ambient color
draw_clear(lightmap_ambient_color);

var temp_x_offset = -view_xview;
var temp_y_offset = -view_yview;

if(!lightmap_move){
    temp_x_offset = -x;
    temp_y_offset = -y;
}

//if lightmap has shadows
//this algorithm in big o notation
//O(n^2)
if(lightmap_shadows && lightmap_parent_object_light != -1){
    //create thee surface again if it does not exist anymore    
    if(!surface_exists(lightmap_shadow_surface_id)){
        lightmap_shadow_surface_id = surface_create(lightmap_shadow_surface_width,lightmap_shadow_surface_height);
    }    

    //create some temp vairables
    var w = lightmap_shadow_surface_width/2;
    var h = lightmap_shadow_surface_height/2;
    
    //lsfi and lpoc are abbreviations
    var lsfi = lightmap_shadow_surface_id;
    var lpoc = lightmap_parent_object_caster;
    
    
    
    //with each light
    with(lightmap_parent_object_light){
        
        //lr is an abbreviation;
        var lr = light_radius;
        var lx = x;
        var ly = y;
        var lid = id;
    
        //set the light surface
        surface_set_target(lsfi);
        
        //with normal blending
        draw_set_blend_mode(bm_normal);
        
        //clear the buffer with black (so it is empty)
        draw_clear(c_black);
        
        //if it is a point light
        if(light_type == 0){
            draw_circle_colour(w,h,light_radius,light_color,c_black,false);
        }
        //if it is a sprite light
        if(light_type == 1){
            draw_sprite_ext(light_sprite,light_sprite_index, w,h,1,1,light_rotation,light_color,1);         
        }
        
        //draw the shadows
        if(lpoc != -1){
            with(lpoc){
                var i;
                
                draw_primitive_begin(pr_trianglelist);
                
                draw_set_color(c_black);
                
                for(i = 0; i < caster_point_count-1; i++){
                    //from this index to the next draw a shadow
                    lightmap_draw_shadow(
                            caster_point_x[i] + x - lx + w, caster_point_y[i] + y - ly + h, 
                            caster_point_x[i+1] + x - lx + w, caster_point_y[i+1] + y - ly + h, 
                            w, h, lr,
                            lid, id);
                }
                
                //from first to last draw a shadow
                lightmap_draw_shadow(
                        caster_point_x[0] + x - lx + w, caster_point_y[0] + y - ly + h, 
                        caster_point_x[caster_point_count-1] + x - lx + w, caster_point_y[caster_point_count-1] + y - ly + h, 
                        w, h, lr,
                        lid, id);
                
                draw_primitive_end();
                
                draw_sprite_ext(sprite_index,image_index,x - lx + w,y - ly + h,image_xscale,image_yscale,image_angle,c_black,1);
            }
        }
        
        //reset this light surface
        surface_reset_target();
        
        //addicitive blending
        draw_set_blend_mode(bm_add);
        
        //draw the surface to the lightmap
        draw_surface(lsfi,x - w + temp_x_offset, y - h + temp_y_offset);
    }
}

//if the lightmap has no shadows
else{
    if(lightmap_parent_object_light != -1){
        //set the blend mode to add, so the colors will blend nicely like light does
        draw_set_blend_mode(bm_add);
        
        //with each object that participates in the light engine
        with(lightmap_parent_object_light){
            //if it is a light
            if(light_type == 0){
                draw_circle_colour(x + temp_x_offset,y + temp_y_offset,light_radius,light_color,c_black,false);
            }
            //if it is a sprite light
            if(light_type == 1){
                draw_sprite_ext(light_sprite,light_sprite_index, x + temp_x_offset,y + temp_y_offset,1,1,light_rotation,light_color,1);         
            }
        }
    }
}

//reset the lightmap surface
surface_reset_target();

#define lightmap_resize
//DOES: resizes the lightmap

//USAGE: lightmap_resize(<new_width>,<new_height>);

//set the width and height variables
lightmap_width = argument0;
lightmap_height = argument1;
//resize the lightmap surface to draw on
if(!surface_exists(lightmap_surface_id)){
    lightmap_surface_id = surface_create(lightmap_width,lightmap_height);
}else{
    surface_resize(lightmap_surface_id,lightmap_width,lightmap_height);
}

#define lightmap_set_ambient
//DOES: set the lightmap ambient value

//USAGE: lightmap_set_ambient(<ambient>);
// - <abient> between 0 and 1, where 1 is completely lit, and 0 is completely dark

//Set the ambient to the new ambient given in the parameter
lightmap_ambient = argument0;

//check if it is in the range of 0 - 1, if not, change it
if(lightmap_ambient > 1){
    lightmap_ambient = 1;
}
else if(lightmap_ambient < 0){
    lightmap_ambient = 0;
}

lightmap_ambient_color = make_colour_rgb(lightmap_ambient*255,lightmap_ambient*255,lightmap_ambient*255);

#define lightmap_set_light_parent_object
lightmap_parent_object_light = argument0;

#define lightmap_set_caster_parent_object
lightmap_parent_object_caster = argument0;

#define lightmap_set_shadows_enabled
lightmap_shadows = argument0;

#define lightmap_move_with_view
//DOES: Sets whether this lightmap should move with the view or not. Else it will start from this lightmaps x and y position

//USAGE: lightmap_move_with_view(<shoud_move>);

lightmap_move = argument0;

#define lightmap_set_shadow_size
lightmap_shadow_surface_width = argument0*2;
lightmap_shadow_surface_height = argument0*2;
if(!surface_exists(lightmap_shadow_surface_id)){
    lightmap_shadow_surface_id = surface_create(lightmap_shadow_surface_width, lightmap_shadow_surface_height);
}else{
    surface_resize(lightmap_shadow_surface_id,lightmap_shadow_surface_width,lightmap_shadow_surface_height);
}

#define lightmap_draw_shadow
var x_1 = argument0;
var y_1 = argument1;
var x_2 = argument2;
var y_2 = argument3;

var center_x = argument4;
var center_y = argument5;

var radius = argument6;

var light = argument7;
var caster = argument8;

var dx_1 = x_1 - center_x;
var dy_1 = y_1 - center_y;

var dx_2 = x_2 - center_x;
var dy_2 = y_2 - center_y;

var t_1 = dx_1*dx_1 + dy_1*dy_1;
var t_2 = dx_2*dx_2 + dy_2*dy_2;

if(t_1 == 0 || t_2 == 0)
    return 0;

var l_1 = sqrt(t_1);
var l_2 = sqrt(t_2);

if(l_1 > radius && l_2 > radius)
    return 0;

var sm_1 = max((radius - abs(dx_1)), (radius - abs(dy_1)));
var sm_2 = max((radius - abs(dx_2)), (radius - abs(dy_2)));

var length_factor = caster.caster_height / light.light_height;
if(length_factor < 1){
    sm_1 *= length_factor * (l_1 / radius);
    sm_2 *= length_factor * (l_2 / radius);
}

var x_1_a = x_1 + dx_1 / l_1 * sm_1;
var y_1_a = y_1 + dy_1 / l_1 * sm_1;

var x_2_a = x_2 + dx_2 / l_2 * sm_2;
var y_2_a = y_2 + dy_2 / l_2 * sm_2;

draw_vertex(x_1,y_1);
draw_vertex(x_1_a,y_1_a);
draw_vertex(x_2,y_2);

draw_vertex(x_2,y_2);
draw_vertex(x_1_a,y_1_a);
draw_vertex(x_2_a,y_2_a);

#define light_init_point
//DOES: Makes this object a point light

//USAGE: light_init_point(<radius>, <color>);

light_set_type(0);              //sets the type (0 = point light)
light_set_color(argument1);     //sets the color
light_set_radius(argument0);    //sets the radius
light_set_sprite(-1);           //set the sprite (point light, no sprite)
light_set_rotation(0);          //sets the lights rotation (0 for point lights of course)
light_set_sprite_index(0)       //sets the sprite index
light_set_height(8);           //sets the light height

#define light_init_sprite
//DOES: Makes this object a point light

//USAGE: light_init_sprite(<sprite>, <index>);

light_set_type(1);                                  //sets the type (1 = sprite light)
light_set_color(c_white);                           //sets the color
light_set_radius(sprite_get_width(argument0));      //sets the radius
light_set_sprite(argument0);                        //set the sprite
light_set_rotation(0);                              //sets the lights rotation (0 for point lights of course)
light_set_sprite_index(argument1)                   //sets the sprite index
light_set_height(8);                               //sets the light height

#define light_set_radius
//DOES: sets the radius for this light

//USAGE: light_set_radius(<color>);

light_radius = argument0;

#define light_set_color
//DOES: sets the color for this light (also works for sprite lights)

//USAGE: light_set_color(<color>);

light_color = argument0;

#define light_set_type
//DOES: sets the light type. It is not recommended to call this function yourself, use at your own risk (used by the system mostly)
//0 = point light
//1 = sprite light

//USAGE: light_set_type(<type>);

light_type = argument0;

#define light_set_sprite
//DOES: sets the sprite for this light (light mask if you may)

//USAGE: light_set_sprite(<sprite>);

light_sprite = argument0;

#define light_set_rotation
//DOES: Sets the lights rotation

//USAGE: light_set_rotation(<angle>);

light_rotation = argument0;

#define light_set_sprite_index
//DOES: Sets the lights sprite index

//USAGE: light_set_sprite_index(<sprite index>);

light_sprite_index = argument0;

#define light_set_height
light_height = argument0;

if(light_height == 0){
    light_height = 0.01;
}

#define caster_init_polygon
//DOES: Inits this object as a polygon caster (for shadows of course)

//USAGE: caster_init_polygon();

//sets the caster points to 0, there are currently no points for shadows
caster_point_count = 0;
caster_set_height(1024);

#define caster_init_sprite
caster_init_polygon();

caster_add_point(-sprite_xoffset,-sprite_yoffset);
caster_add_point(-sprite_xoffset + sprite_width,-sprite_yoffset);
caster_add_point(-sprite_xoffset + sprite_width,-sprite_yoffset + sprite_height);
caster_add_point(-sprite_xoffset,-sprite_yoffset + sprite_height);

#define caster_init_rectangle
var left = argument0;
var top = argument1;
var right = argument2;
var bottom = argument3;

caster_add_point(left,top);
caster_add_point(right,top);
caster_add_point(right,bottom);
caster_add_point(left,bottom);

#define caster_init_circle
caster_init_polygon();

var radius = argument0;
var fractions = argument1;

var i;
var m;

m = 2 * 3.141592654 / fractions;

for(i = 0; i < fractions; i++){
    caster_add_point(cos(m * i) * radius, sin(m * i) * radius);
}

#define caster_add_point
//DOES: Adds a point to this polygon caster

//USAGE: caster_add_point(<x>, <y>);
// - <x> is relative to the objects x
// - <y> is relative to the objects y

//set the caster_point_x and y array to the right values.
caster_point_x[caster_point_count] = argument0;
caster_point_y[caster_point_count] = argument1;

//increase the total point count
caster_point_count += 1;

#define caster_draw_debug
draw_set_color(c_green);

var i;

for(i = 0; i < caster_point_count; i++){
    draw_circle(caster_point_x[i] + x,caster_point_y[i] + y, 4, 1);
}

for(i = 0; i < caster_point_count-1; i++){
    draw_line_width(caster_point_x[i]+x,caster_point_y[i]+y,caster_point_x[i + 1]+x,caster_point_y[i + 1]+y, 1);
}

draw_line_width(caster_point_x[0]+x,caster_point_y[0]+y,caster_point_x[caster_point_count-1]+x,caster_point_y[caster_point_count-1]+y, 1);

draw_set_color(c_white);

#define caster_set_height
caster_height = argument0;

