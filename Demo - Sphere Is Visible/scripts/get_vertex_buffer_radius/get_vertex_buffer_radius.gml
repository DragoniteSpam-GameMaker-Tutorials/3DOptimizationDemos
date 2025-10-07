function get_vertex_buffer_radius(vbuff) {
    var data = buffer_create_from_vertex_buffer(vbuff, buffer_fixed, 1);
    
    var largest_dist = 0;
    
    for (var i = 0; i < buffer_get_size(data); i += 36) {
        var xx = buffer_peek(data, i, buffer_f32);
        var yy = buffer_peek(data, i + 4, buffer_f32);
        var zz = buffer_peek(data, i + 8, buffer_f32);
        
        var dist = point_distance_3d(0, 0, 0, xx, yy, zz);
        
        largest_dist = max(largest_dist, dist);
    }
    
    buffer_delete(data);
    
    return largest_dist;
}