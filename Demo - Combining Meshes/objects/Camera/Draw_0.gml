/// @description Draw the 3D world
draw_clear(c_black);

shader_set(shd_basic_3d_stuff);
var uniform_light_pos = shader_get_uniform(shd_basic_3d_stuff, "lightPosition");
var uniform_light_color = shader_get_uniform(shd_basic_3d_stuff, "lightColor");
var uniform_light_range = shader_get_uniform(shd_basic_3d_stuff, "lightRange");
var uniform_light_dir = shader_get_uniform(shd_basic_3d_stuff, "lightDirection");
var uniform_light_cutoff = shader_get_uniform(shd_basic_3d_stuff, "lightCutoffAngle");
shader_set_uniform_f(uniform_light_pos, 250, 250, 64);
shader_set_uniform_f(uniform_light_color, 1, 1, 1, 1);
shader_set_uniform_f(uniform_light_range, 500);
shader_set_uniform_f(uniform_light_dir, -1, -1, -1);
shader_set_uniform_f(uniform_light_cutoff, dcos(45));

// 3D projections require a view and projection matrix
var camera = camera_get_active();
var camera_distance = 160;

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