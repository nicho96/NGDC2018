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
