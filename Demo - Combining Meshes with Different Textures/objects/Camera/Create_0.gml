/// @description Set up 3D things

show_debug_overlay(true);

// Bad things happen if you turn off the depth buffer in 3D
gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);

view_mat = undefined;
proj_mat = undefined;

#region vertex format setup
// Vertex format: data must go into vertex buffers in the order defined by this
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_texcoord();
vertex_format_add_color();
vertex_format = vertex_format_end();
#endregion

#region create the grid
vbuffer = vertex_create_buffer();
vertex_begin(vbuffer, vertex_format);

// Create a checkerboard pattern on the floor
var s = 128;
var n = 64;
for (var i = -s * n; i < s * n; i += s) {
    for (var j = -s * n; j < s * n; j += s) {
        var color = c_white;
        if (((i + s * n) % (s * 2) == 0 && (j + s * n) % (s * 2) == 0) || ((i + s * n) % (s * 2) > 0 && (j + s * n) % (s * 2) > 0)) {
            color = c_aqua;
        }
        
        #region add data to the vertex buffer
        vertex_add_point(vbuffer, i, j, 0,                  0, 0, 1,        0, 0,       color, 1);
        vertex_add_point(vbuffer, i + s, j, 0,              0, 0, 1,        1, 0,       color, 1);
        vertex_add_point(vbuffer, i + s, j + s, 0,          0, 0, 1,        1, 1,       color, 1);

        vertex_add_point(vbuffer, i + s, j + s, 0,          0, 0, 1,        1, 1,       color, 1);
        vertex_add_point(vbuffer, i, j + s, 0,              0, 0, 1,        0, 1,       color, 1);
        vertex_add_point(vbuffer, i, j, 0,                  0, 0, 1,        0, 0,       color, 1);
        #endregion
    }
}

vertex_end(vbuffer);
vertex_freeze(vbuffer);
#endregion

instance_create_depth(0, 0, 0, Player);

b_trunk = buffer_load("oak_trunk.vbuff");
vb_trunk = vertex_create_buffer_from_buffer(b_trunk, vertex_format);
vertex_freeze(vb_trunk);

b_leaves = buffer_load("oak_leaves.vbuff");
vb_leaves = vertex_create_buffer_from_buffer(b_leaves, vertex_format);
vertex_freeze(vb_leaves);

#macro TREE_COUNT 30_000
#macro RANGE 30_000
tree_data = array_create(TREE_COUNT);
for (var i = 0; i < TREE_COUNT; i++) {
    var xx = random_range(-RANGE, RANGE);
    var yy = random_range(-RANGE, RANGE);
    var scale = random_range(0.8, 2);
    var rot = random(360);
    tree_data[i] = {
		x: xx,
		y: yy,
        matrix: matrix_build(xx, yy, 0,
            0, 0, rot,
            scale, scale, scale
        ),
        bark: choose(spr_oakbark, spr_oakbark_burnt),
        leaves: choose(spr_oakleaf_dark, spr_oakleaf_fall, spr_oakleaf_light),
    };
}
/*
vb_combine = vertex_create_buffer();
vertex_begin(vb_combine, vertex_format);

var t = get_timer();

for (var i = 0; i < TREE_COUNT; i++) {
	var tree = tree_data[i];
    vertex_buffer_add_buffer(vb_combine, b_trunk, tree.matrix);
	vertex_buffer_add_buffer(vb_combine, b_leaves, tree.matrix);
}

show_debug_message($"Time to merge meshes: {(get_timer() - t) / 1000_000}");

vertex_end(vb_combine);
vertex_freeze(vb_combine);
*/
frames = 0;
fps_total = 0;
vertex_total = 0;