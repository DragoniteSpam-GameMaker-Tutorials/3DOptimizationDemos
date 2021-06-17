/// @description draw the user interface

var i = 1;
draw_set_font(fnt_game);
draw_text(32, i++ * 20, "FPS: " + string(fps));
draw_text(32, i++ * 20, "Real: " + string(fps_real));
draw_text(32, i++ * 20, "Average: " + string(fps_total / frames));
draw_text(32, i++ * 20, "Tree count: " + string(TREE_COUNT));
draw_text(32, i++ * 20, "Triangles: " + string(vertex_get_number(vb_combine) / 3));
draw_text(32, i++ * 20, "Vertices: " + string(vertex_get_number(vb_combine)));
draw_text(32, i++ * 20, "Shader: " + shader_get_name(current_shader));