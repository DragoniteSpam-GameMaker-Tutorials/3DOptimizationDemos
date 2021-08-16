function draw_all_the_stuff_in_the_world() {
    var camera_distance = 1000;
    var xto = Player.x;
    var yto = Player.y;
    var zto = Player.z + 64;
    var xfrom = xto + camera_distance * dcos(Player.look_dir) * dcos(Player.look_pitch);
    var yfrom = yto - camera_distance * dsin(Player.look_dir) * dcos(Player.look_pitch);
    var zfrom = zto - camera_distance * dsin(Player.look_pitch);
    
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
    
    // Everything must be drawn after the 3D projection has been set
    vertex_submit(vbuffer, pr_trianglelist, sprite_get_texture(spr_grass, 0));
    
    // The player
    matrix_set(matrix_world, matrix_build(Player.x, Player.y, Player.z, 0, 0, 0, 1, 1, 1));
    vertex_submit(vb_player, pr_trianglelist, -1);
    matrix_set(matrix_world, matrix_build_identity());
    
    for (var i = 0; i < TREE_COUNT; i++) {
        var data = tree_data[i];
        var dist_to_tree = point_distance_3d(xfrom, yfrom, zfrom, data.x, data.y, 0);
        
        matrix_set(matrix_world, matrix_build(data.x, data.y, 0, 0, 0, 0, 1, 1, 1));
        if (dist_to_tree < 5000) {
            vertex_submit(vb_tree, pr_trianglelist, data.texture);
        } else {
            vertex_submit(vb_tree_lod, pr_trianglelist, data.texture);
        }
    }
    
    //vertex_submit(vb_combine, pr_trianglelist, sprite_get_texture(spr_tree, 0));
    shader_reset();
    matrix_set(matrix_world, matrix_build_identity());
}