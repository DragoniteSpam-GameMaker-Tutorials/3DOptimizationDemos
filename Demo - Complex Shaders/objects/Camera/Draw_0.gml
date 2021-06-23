/// @description Draw the 3D world
draw_clear(c_black);

if (keyboard_check(vk_space)) {
    current_shader = shd_point_lights_vertex;
} else {
    current_shader = shd_point_lights_fragment;
}

shader_set(current_shader);
var uniform_light_pos = shader_get_uniform(current_shader, "lightPosition");
var uniform_light_color = shader_get_uniform(current_shader, "lightColor");
var uniform_light_range = shader_get_uniform(current_shader, "lightRange");
shader_set_uniform_f_array(uniform_light_pos, light_positions);
shader_set_uniform_f_array(uniform_light_color, light_colors);
shader_set_uniform_f_array(uniform_light_range, light_ranges);

// 3D projections require a view and projection matrix
var camera = camera_get_active();
var camera_distance = 1000;

var xto = Player.x;
var yto = Player.y;
var zto = Player.z + 64;
var xfrom = xto + camera_distance * dcos(Player.look_dir) * dcos(Player.look_pitch);
var yfrom = yto - camera_distance * dsin(Player.look_dir) * dcos(Player.look_pitch);
var zfrom = zto - camera_distance * dsin(Player.look_pitch);

view_mat = matrix_build_lookat(xfrom, yfrom, zfrom, xto, yto, zto, 0, 0, 1);
proj_mat = matrix_build_projection_perspective_fov(-60, -window_get_width() / window_get_height(), 1, 32000);
camera_set_view_mat(camera, view_mat);
camera_set_proj_mat(camera, proj_mat);
camera_apply(camera);

// Everything must be drawn after the 3D projection has been set
vertex_submit(vbuffer, pr_trianglelist, sprite_get_texture(spr_grass, 0));

// The player
matrix_set(matrix_world, matrix_build(Player.x, Player.y, Player.z, 0, 0, 0, 1, 1, 1));
vertex_submit(vb_player, pr_trianglelist, -1);
matrix_set(matrix_world, matrix_build_identity());
/*
for (var i = 0; i < TREE_COUNT; i++) {
    var data = tree_data[i];
    
    matrix_set(matrix_world, data.matrix);
    vertex_submit(data.model, pr_trianglelist, data.texture);
}
*/
vertex_submit(vb_combine, pr_trianglelist, sprite_get_texture(spr_tree, 0));
shader_reset();
matrix_set(matrix_world, matrix_build_identity());

frames++;
fps_total += fps_real;