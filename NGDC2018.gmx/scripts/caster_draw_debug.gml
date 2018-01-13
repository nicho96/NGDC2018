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
