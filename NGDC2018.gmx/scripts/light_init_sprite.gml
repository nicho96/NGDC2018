//DOES: Makes this object a point light

//USAGE: light_init_sprite(<sprite>, <index>);

light_set_type(1);                                  //sets the type (1 = sprite light)
light_set_color(c_white);                           //sets the color
light_set_radius(sprite_get_width(argument0));      //sets the radius
light_set_sprite(argument0);                        //set the sprite
light_set_rotation(0);                              //sets the lights rotation (0 for point lights of course)
light_set_sprite_index(argument1)                   //sets the sprite index
light_set_height(8);                               //sets the light height
