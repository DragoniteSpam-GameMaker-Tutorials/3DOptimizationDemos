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
vb_merry = load_model("merry.d3d");

#macro TREE_COUNT 2500
#macro RANGE 3000
tree_positions = array_create(TREE_COUNT);

for (var i = 0; i < TREE_COUNT; i++) {
    tree_data[i] = {
        model: vb_tree,
        x: random_range(-RANGE, RANGE),
        y: random_range(-RANGE, RANGE),
        rotation: random(360),
        texture: sprite_get_texture(spr_tree, 0),
    };
}

vb_combine = vertex_create_buffer();
vertex_begin(vb_combine, vertex_format);

for (var i = 0; i < TREE_COUNT; i++) {
    var data = tree_data[i];
    
    var raw_data = buffer_create_from_vertex_buffer(data.model, buffer_fixed, 1);
    
    for (var j = 0; j < buffer_get_size(raw_data); j += 36) {
        var xx = buffer_peek(raw_data, j + 0, buffer_f32);
        var yy = buffer_peek(raw_data, j + 4, buffer_f32);
        var zz = buffer_peek(raw_data, j + 8, buffer_f32);
        var nx = buffer_peek(raw_data, j + 12, buffer_f32);
        var ny = buffer_peek(raw_data, j + 16, buffer_f32);
        var nz = buffer_peek(raw_data, j + 20, buffer_f32);
        var xtex = buffer_peek(raw_data, j + 24, buffer_f32);
        var ytex = buffer_peek(raw_data, j + 28, buffer_f32);
        var r = buffer_peek(raw_data, j + 32, buffer_u8);
        var g = buffer_peek(raw_data, j + 33, buffer_u8);
        var b = buffer_peek(raw_data, j + 34, buffer_u8);
        var a = buffer_peek(raw_data, j + 35, buffer_u8) / 255;
        
        var matrix = matrix_build(data.x, data.y, 0,        0, 0, data.rotation,    1, 1, 1);
        var matrix_normals = matrix_build(0, 0, 0,          0, 0, data.rotation,    1, 1, 1);
        
        var transformed_position = matrix_transform_vertex(matrix, xx, yy, zz);
        var transformed_normals = matrix_transform_vertex(matrix_normals, nx, ny, nz);
        
        var normal_magnitude = point_distance_3d(0, 0, 0, transformed_normals[0], transformed_normals[1], transformed_normals[2]);
        transformed_normals[0] /= normal_magnitude;
        transformed_normals[1] /= normal_magnitude;
        transformed_normals[2] /= normal_magnitude;
        
        vertex_position_3d(vb_combine, transformed_position[0], transformed_position[1], transformed_position[2]);
        vertex_normal(vb_combine, transformed_normals[0], transformed_normals[1], transformed_normals[2]);
        vertex_texcoord(vb_combine, xtex, ytex);
        vertex_colour(vb_combine, make_colour_rgb(r, g, b), a);
    }
    
    buffer_delete(raw_data);
}

vertex_end(vb_combine);
vertex_freeze(vb_combine);

frames = 0;
fps_total = 0;