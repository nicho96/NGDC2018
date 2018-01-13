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
