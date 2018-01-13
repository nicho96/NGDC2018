redirect = instance_place(x + hspd, y + vspd, o_redirect)
if(redirect){
    if(!redirect.is_activated){
        redirect.is_activated = true
        slide_direction = redirect.slide_direction
        x = redirect.x
        y = redirect.y
    }
    
    //Reset the is_activated after a certain time
    with(redirect){
        alarm[0] = room_speed * 0.25
    }
}
