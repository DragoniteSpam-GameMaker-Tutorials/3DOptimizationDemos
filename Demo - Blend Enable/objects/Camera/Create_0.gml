/// @description Set up 3D things

#macro TREE_COUNT 2000
#macro RANGE 4000

// Bad things happen if you turn off the depth buffer in 3D
gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);

var camera_distance = 640;

var xto = RANGE / 2;
var yto = RANGE / 2;
var zto =  -1000;
var xfrom = -256;
var yfrom = -256;
var zfrom = 1000;

self.view_mat = matrix_build_lookat(xfrom, yfrom, zfrom, xto, yto, zto, 0, 0, 1);
self.proj_mat = matrix_build_projection_perspective_fov(-60, -window_get_width() / window_get_height(), 1, 32000);

#region vertex format setup
// Vertex format: data must go into vertex buffers in the order defined by this
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_texcoord();
vertex_format_add_color();
self.vertex_format = vertex_format_end();
#endregion

var b = buffer_load("all_trees.vb");
self.vb_all_trees = vertex_create_buffer_from_buffer(b, self.vertex_format);
vertex_freeze(self.vb_all_trees);
buffer_delete(b);