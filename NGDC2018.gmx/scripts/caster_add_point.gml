//DOES: Adds a point to this polygon caster

//USAGE: caster_add_point(<x>, <y>);
// - <x> is relative to the objects x
// - <y> is relative to the objects y

//set the caster_point_x and y array to the right values.
caster_point_x[caster_point_count] = argument0;
caster_point_y[caster_point_count] = argument1;

//increase the total point count
caster_point_count += 1;
