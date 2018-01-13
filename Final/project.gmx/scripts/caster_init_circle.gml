caster_init_polygon();

var radius = argument0;
var fractions = argument1;

var i;
var m;

m = 2 * 3.141592654 / fractions;

for(i = 0; i < fractions; i++){
    caster_add_point(cos(m * i) * radius, sin(m * i) * radius);
}
