image_xscale -= 0.02
image_yscale -= 0.02
image_alpha -= 0.05
falling_tick -= 1
if(falling_tick < 0){
    instance_destroy()
}
