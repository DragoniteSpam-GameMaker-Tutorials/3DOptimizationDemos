function vertex_buffer_add_buffer_atlased(destination, source, matrix, sprite_texture, atlas_metadata) {
    var pos = array_create(4);
    var norm = array_create(4);
	
	var sprite_metadata = undefined;
	for (var i = 0; i < array_length(atlas_metadata); i++) {
		if (atlas_metadata[i].sprite == sprite_texture) {
			sprite_metadata = atlas_metadata[i];
			break;
		}
	}
	
    for (var i = 0; i < buffer_get_size(source); i += 36) {
        var xx = buffer_peek(source, i + 00, buffer_f32);
        var yy = buffer_peek(source, i + 04, buffer_f32);
        var zz = buffer_peek(source, i + 08, buffer_f32);
        var nx = buffer_peek(source, i + 12, buffer_f32);
        var ny = buffer_peek(source, i + 16, buffer_f32);
        var nz = buffer_peek(source, i + 20, buffer_f32);
        var xt = buffer_peek(source, i + 24, buffer_f32);
        var yt = buffer_peek(source, i + 28, buffer_f32);
        var cc = buffer_peek(source, i + 32, buffer_u32);
		
		xt = lerp(sprite_metadata.u1, sprite_metadata.u2, xt);
		yt = lerp(sprite_metadata.v1, sprite_metadata.v2, yt);
        
        matrix_transform_vertex(matrix, xx, yy, zz, 1, pos);
        matrix_transform_vertex(matrix, nx, ny, nz, 0, norm);
        
        var mag = point_distance_3d(0, 0, 0, norm[0], norm[1], norm[2]);
        norm[0] /= mag;
        norm[1] /= mag;
        norm[2] /= mag;
        
        vertex_add_point(destination, pos[0], pos[1], pos[2], norm[0], norm[1], norm[2], xt, yt, cc & 0xffffff, (cc >> 24) / 255);
    }
}