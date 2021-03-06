function vertex_buffer_add_buffer(destination, source, matrix) {
    var nmatrix = [
        matrix[00], matrix[01], matrix[02], matrix[03],
        matrix[04], matrix[05], matrix[06], matrix[07],
        matrix[08], matrix[09], matrix[10], matrix[11],
                 0,          0,          0, matrix[15]
    ];
    var data = buffer_create_from_vertex_buffer(source, buffer_fixed, 1);
    for (var i = 0; i < buffer_get_size(data); i += 36) {
        var xx = buffer_peek(data, i + 00, buffer_f32);
        var yy = buffer_peek(data, i + 04, buffer_f32);
        var zz = buffer_peek(data, i + 08, buffer_f32);
        var nx = buffer_peek(data, i + 12, buffer_f32);
        var ny = buffer_peek(data, i + 16, buffer_f32);
        var nz = buffer_peek(data, i + 20, buffer_f32);
        var xt = buffer_peek(data, i + 24, buffer_f32);
        var yt = buffer_peek(data, i + 28, buffer_f32);
        var cc = buffer_peek(data, i + 32, buffer_u32);
        
        var pos = matrix_transform_vertex(matrix, xx, yy, zz);
        var norm = matrix_transform_vertex(nmatrix, nx, ny, nz);
        var mag = point_distance_3d(0, 0, 0, norm[0], norm[1], norm[2]);
        norm[0] /= mag;
        norm[1] /= mag;
        norm[2] /= mag;
        
        vertex_add_point(destination, pos[0], pos[1], pos[2], norm[0], norm[1], norm[2], xt, yt, cc & 0xffffff, (cc >> 24) / 255);
    }
}