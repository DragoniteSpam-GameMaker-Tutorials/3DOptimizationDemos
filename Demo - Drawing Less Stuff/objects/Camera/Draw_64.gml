/// @description draw the user interface

var i = 1;
draw_set_font(fnt_game);
draw_text(32, i++ * 20, "FPS: " + string(fps));
draw_text(32, i++ * 20, "Real: " + string(fps_real));
draw_text(32, i++ * 20, "Average: " + string(fps_total / frames));
draw_text(32, i++ * 20, "Tree count: " + string(TREE_COUNT));
//draw_text(32, i++ * 20, "Triangles: " + string(vertex_get_number(vb_combine) / 3));
//draw_text(32, i++ * 20, "Vertices: " + string(vertex_get_number(vb_combine)));
draw_text(32, i++ * 20, "Shader: " + shader_get_name(current_shader));

//////////////////////////////////////////////////

if (!surface_exists(overhead_camera_surface)) {
    overhead_camera_surface = surface_create(480, 320);
}

surface_set_target(overhead_camera_surface);
draw_clear(c_black);


// 3D projections require a view and projection matrix
var camera = camera_get_active();
var camera_distance = 1000;

var xto = RANGE / 2;
var yto = RANGE / 2;
var zto = 0;
var xfrom = 0;
var yfrom = 0;
var zfrom = 1000;

view_mat = matrix_build_lookat(xfrom, yfrom, zfrom, xto, yto, zto, 0, 0, 1);
proj_mat = matrix_build_projection_perspective_fov(-60, -window_get_width() / window_get_height(), 1, 32000);
camera_set_view_mat(camera, view_mat);
camera_set_proj_mat(camera, proj_mat);
camera_apply(camera);

draw_all_the_stuff_in_the_world();
surface_reset_target();

draw_surface(overhead_camera_surface, window_get_width() - 480, 0);