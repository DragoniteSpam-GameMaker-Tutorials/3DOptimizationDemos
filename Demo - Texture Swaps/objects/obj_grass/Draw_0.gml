/*
var c_bottom = make_color_rgb(0, 0, 0);
var c_top = make_color_rgb(32, 0, 0);
draw_sprite_general(spr_grass, obj_camera.sprite_index_count, 0, 0, 32, 32, x, y, 1, 1, 0, c_top, c_top, c_bottom, c_bottom, 1);
*/

matrix_set(matrix_world, my_transform_matrix);
draw_sprite(spr_grass, obj_camera.sprite_index_count, 0, 0);
obj_camera.sprite_index_count = (obj_camera.sprite_index_count + 1) % 8;