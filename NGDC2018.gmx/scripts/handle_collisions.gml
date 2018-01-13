xpos = x + hspd
ypos = y + vspd

//Horizontal wall collision check
hor_wall = instance_place(xpos, y, o_wall)
if(hor_wall){
    if(hspd > 0){
        xpos = hor_wall.x - hor_wall.sprite_width / 2 - hitbox_width / 2
    }else{
        xpos = hor_wall.x + hor_wall.sprite_width / 2 + hitbox_width / 2
    }
    slide_direction = 0
}

//Horizontal laser wall collision check
hor_laser_wall = instance_place(xpos, y, o_laser_wall)
if(hor_laser_wall && hor_laser_wall.is_activated){
    if(hspd > 0){
        xpos = hor_laser_wall.x - hor_laser_wall.sprite_width / 2 - hitbox_width / 2
    }else{
        xpos = hor_laser_wall.x + hor_laser_wall.sprite_width / 2 + hitbox_width / 2
    }
    slide_direction = 0
}

//Horizontal laser tile check
hor_laser_tile = instance_place(xpos, y, o_laser_tile)
if(hor_laser_tile && !hor_laser_tile.is_activated){
    is_falling = true
    xpos = hor_laser_tile.x
}

x = xpos

//Vertical wall collision check
ver_wall = instance_place(x, ypos, o_wall)
if(ver_wall){
    if(vspd > 0){
        ypos = ver_wall.y - ver_wall.sprite_height / 2 - hitbox_height / 2
    }else{
        ypos = ver_wall.y + ver_wall.sprite_height / 2 + hitbox_height / 2
    }
    slide_direction = 0
}

//Vertical laser wall collision check
ver_laser_wall = instance_place(x, ypos, o_laser_wall)
if(ver_laser_wall && ver_laser_wall.is_activated){
    if(vspd > 0){
        ypos = ver_laser_wall.y - ver_laser_wall.sprite_height / 2 - hitbox_height / 2
    }else{
        ypos = ver_laser_wall.y + ver_laser_wall.sprite_height / 2 + hitbox_height / 2 
    }
    slide_direction = 0
}

//Horizontal laser tile check
ver_laser_tile = instance_place(x, ypos, o_laser_tile)
if(ver_laser_tile && !ver_laser_tile.is_activated){
    is_falling = true
    ypos = ver_laser_tile.y
}

y = ypos
