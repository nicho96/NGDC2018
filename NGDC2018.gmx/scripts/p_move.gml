key_left = keyboard_check(ord("A")) || gamepad_button_check(0, gp_padl)
key_right = keyboard_check(ord("D")) || gamepad_button_check(0, gp_padr)
key_up = keyboard_check(ord("W")) || gamepad_button_check(0, gp_padu)
key_down = keyboard_check(ord("S")) || gamepad_button_check(0, gp_padd)
key_push = keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(0, gp_face3)

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

if(abs(vspd) > abs(hspd)){
    if(vspd < 0){
        facing_direction = 1
    }else{
        facing_direction = 2
    }
}else{
    if(hspd < 0){
        facing_direction = 3
    }else{
        facing_direction = 4
    }
}

//Push slide wall if near
if(key_push){
    if(facing_direction == 1 || facing_direction == 2){
        ver_sliding_wall = instance_place(x, y + sign(vspd) * 10, o_sliding_wall)
        if(ver_sliding_wall){
            ver_sliding_wall.slide_direction = facing_direction
        }
    }else if(facing_direction == 3 || facing_direction == 4){
        hor_sliding_wall = instance_place(x + sign(hspd) * 10, y, o_sliding_wall)
        if(hor_sliding_wall){
            hor_sliding_wall.slide_direction = facing_direction
        }
    }
}

handle_collisions()
