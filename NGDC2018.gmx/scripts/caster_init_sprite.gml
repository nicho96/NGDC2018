caster_init_polygon();

caster_add_point(-sprite_xoffset,-sprite_yoffset);
caster_add_point(-sprite_xoffset + sprite_width,-sprite_yoffset);
caster_add_point(-sprite_xoffset + sprite_width,-sprite_yoffset + sprite_height);
caster_add_point(-sprite_xoffset,-sprite_yoffset + sprite_height);
