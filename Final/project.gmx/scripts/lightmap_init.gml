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
