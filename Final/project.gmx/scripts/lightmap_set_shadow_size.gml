lightmap_shadow_surface_width = argument0*2;
lightmap_shadow_surface_height = argument0*2;
if(!surface_exists(lightmap_shadow_surface_id)){
    lightmap_shadow_surface_id = surface_create(lightmap_shadow_surface_width, lightmap_shadow_surface_height);
}else{
    surface_resize(lightmap_shadow_surface_id,lightmap_shadow_surface_width,lightmap_shadow_surface_height);
}
