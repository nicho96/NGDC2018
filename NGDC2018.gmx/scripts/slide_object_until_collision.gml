/* 0 -> No Slide
 * 1 -> Up Slide
 * 2 -> Down Slide
 * 3 -> Left Slide
 * 4 -> Right Slide 
 */
 
hspd = 0
vspd = 0 

if(slide_direction == 1){
    vspd = -global.slide_speed
}

if(slide_direction == 2){
    vspd = global.slide_speed
}

if(slide_direction == 3){
    hspd = -global.slide_speed
}

if(slide_direction == 4){
    hspd = global.slide_speed
}


if(hspd != 0 || vspd != 0){
    //If wall is sliding and collides with player, kill the player
    player = instance_place(x + hspd, y + vspd, o_player)
    if(player && slide_direction != 0){
        player.is_falling = true
    }else{
        handle_collisions()
    }
}

redirect_slide_object()
