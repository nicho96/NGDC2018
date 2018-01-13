if(is_activated){
    light_radius = 32
    image_index = 3 // 1 + (image_index + 1) % 4
    player = instance_place(x, y, o_player)
    if(player){
        player.is_falling = true
    }
}else{
    light_radius = 0
    image_index = 4
}
