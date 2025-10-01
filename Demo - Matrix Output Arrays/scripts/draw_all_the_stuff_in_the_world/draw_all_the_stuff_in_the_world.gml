function draw_all_the_stuff_in_the_world() {
    var camera_distance = 1000;
    var xto = Player.x;
    var yto = Player.y;
    var zto = Player.z + 64;
    var xfrom = xto + camera_distance * dcos(Player.look_dir) * dcos(Player.look_pitch);
    var yfrom = yto - camera_distance * dsin(Player.look_dir) * dcos(Player.look_pitch);
    var zfrom = zto - camera_distance * dsin(Player.look_pitch);
    
    shader_set(shd_point_lights_fragment);
    
    // Everything must be drawn after the 3D projection has been set
    vertex_submit(vbuffer, pr_trianglelist, sprite_get_texture(spr_grass, 0));
    
    // The player
    matrix_set(matrix_world, matrix_build(Player.x, Player.y, Player.z, 0, 0, 0, 1, 1, 1));
    vertex_submit(vb_player, pr_trianglelist, -1);
    matrix_set(matrix_world, matrix_build_identity());
    
    var t = current_time / 100;
    
    for (var i = 0; i < TREE_COUNT; i++) {
        var data = tree_data[i];
        var dist_to_tree = point_distance_3d(xfrom, yfrom, zfrom, data.x, data.y, 0);
        
        var dir_to_tree = point_direction(xfrom, yfrom, data.x, data.y);
        
        var translation = matrix_build(data.x, data.y, 0, 0, 0, 0, 1, 1, 1);
        var rotation = matrix_build(0, 0, 0, t, t, t, 1, 1, 1);
        var scale = matrix_build(0, 0, 0, 0, 0, 0, data.scale, data.scale, data.scale)
        
        var transform_rs = matrix_multiply(scale, rotation);
        var transform = matrix_multiply(transform_rs, translation);
        
        matrix_set(matrix_world, transform);
        if (dist_to_tree < 5000) {
            vertex_submit(vb_tree, pr_trianglelist, data.texture);
        } else {
            vertex_submit(vb_tree_lod, pr_trianglelist, data.texture);
        }
    }
    
    shader_reset();
    matrix_set(matrix_world, matrix_build_identity());
}