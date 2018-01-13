//DOES: set the lightmap ambient value

//USAGE: lightmap_set_ambient(<ambient>);
// - <abient> between 0 and 1, where 1 is completely lit, and 0 is completely dark

//Set the ambient to the new ambient given in the parameter
lightmap_ambient = argument0;

//check if it is in the range of 0 - 1, if not, change it
if(lightmap_ambient > 1){
    lightmap_ambient = 1;
}
else if(lightmap_ambient < 0){
    lightmap_ambient = 0;
}

lightmap_ambient_color = make_colour_rgb(lightmap_ambient*255,lightmap_ambient*255,lightmap_ambient*255);
