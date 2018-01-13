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
