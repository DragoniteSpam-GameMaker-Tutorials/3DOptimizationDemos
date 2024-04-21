var dx = 0, dy = 0;

running = false;

if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
    dx = -1;
}
if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
    dx = 1;
}
if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
    dy = -1;
}
if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
    dy = 1;
}

if (dx != 0 || dy != 0) {
    var mag = point_distance(0, 0, dx, dy);
    if (keyboard_check(vk_shift)) {
        running = true;
        mag /= 1.5;
    }
    dx /= mag;
    dy /= mag;
    anim_frame = (anim_frame + 0.125) % 4;
    anim_dir = point_direction(0, 0, dx, dy) / 90;
} else {
    anim_frame = 0;
}

x += dx * 2;
y += dy * 2;