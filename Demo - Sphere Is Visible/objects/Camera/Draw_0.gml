/// @description Draw the 3D world
draw_clear(c_black);

// 3D projections require a view and projection matrix
var camera = camera_get_active();
var camera_distance = 4000;

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

draw_all_the_stuff_in_the_world();

frames++;
fps_total += fps_real;