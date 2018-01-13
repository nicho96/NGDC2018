key_left = keyboard_check(ord("A")) || gamepad_button_check(0, gp_padl)
key_right = keyboard_check(ord("D")) || gamepad_button_check(0, gp_padr)
key_up = keyboard_check(ord("W")) || gamepad_button_check(0, gp_padu)
key_down = keyboard_check(ord("S")) || gamepad_button_check(0, gp_padd)

gamepad_set_axis_deadzone(0, 0.325)
gamepad_hor = gamepad_axis_value (0, gp_axislh)
gamepad_ver = gamepad_axis_value (0, gp_axislv)

key_interact = keyboard_check(ord("E")) || gamepad_button_check(0, gp_face1) 

hspd = gamepad_hor * move_speed
vspd = gamepad_ver * move_speed

if(key_left){
    hspd = -move_speed
}

if(key_right){
    hspd = move_speed
}

if(key_up){
    vspd = -move_speed
}

if(key_down){
    vspd = move_speed
}

xpos = x + hspd
ypos = y + vspd

//Collision checking
hor_wall = instance_place(x + hspd, y, o_wall)
if(hor_wall){
    if(hspd > 0){
        xpos = hor_wall.x - sprite_width / 2
    }else{
        xpos = hor_wall.x + hor_wall.sprite_width + sprite_width / 2
    }
}

x = xpos

ver_wall = instance_place(x, y + vspd, o_wall)
if(ver_wall){
    if(vspd > 0){
        ypos = ver_wall.y - sprite_height / 2
    }else{
        ypos = ver_wall.y + ver_wall.sprite_height + sprite_height / 2
    }
}

y = ypos
