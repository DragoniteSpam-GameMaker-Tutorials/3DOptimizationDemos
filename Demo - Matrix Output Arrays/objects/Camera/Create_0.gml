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
for (var i = 0; i < room_width; i += s) {
    for (var j = 0; j < room_height; j += s) {
        if ((i % (s * 2) == 0 && j % (s * 2) == 0) || (i % (s * 2) > 0 && j % (s * 2) > 0)) {
            var color = c_aqua;
        } else {
            var color = c_white;
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
#endregion

instance_create_depth(0, 0, 0, Player);

vb_player = load_model("player.d3d");
vb_tree = load_model("tree.d3d");
vb_tree_lod = load_model("tree_lod.d3d");

#macro TREE_COUNT 3_000
#macro RANGE 4000
tree_data = array_create(TREE_COUNT);

for (var i = 0; i < TREE_COUNT; i++) {
    tree_data[i] = {
        texture: sprite_get_texture(spr_tree, 0),
        x: random_range(-RANGE, RANGE),
        y: random_range(-RANGE, RANGE),
        scale: random_range(1, 1.5)
    };
}

frames = 0;
fps_total = 0;

#macro LIGHT_COUNT 16
light_positions = array_create(3 * LIGHT_COUNT);
light_colors = array_create(3 * LIGHT_COUNT);
light_ranges = array_create(LIGHT_COUNT);
for (var i = 0; i < LIGHT_COUNT; i++) {
    light_positions[i * 3 + 0] = random_range(-RANGE, RANGE);
    light_positions[i * 3 + 1] = random_range(-RANGE, RANGE);
    light_positions[i * 3 + 2] = random_range(100, 500);
    light_colors[i * 3 + 0] = 1;
    light_colors[i * 3 + 1] = 1;
    light_colors[i * 3 + 2] = 1;
    light_ranges[i] = random_range(800, 1600);
}

overhead_camera_surface = surface_create(480, 320);