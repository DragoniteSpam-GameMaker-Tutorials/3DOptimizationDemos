/// @description draw the user interface

var i = 1;
draw_set_font(fnt_game);
draw_text(32, i++ * 20, "FPS: " + string(fps));
draw_text(32, i++ * 20, "Tree count: " + string(TREE_COUNT));
draw_text(32, i++ * 20, "Triangles: " + string(TREE_COUNT * 381));
draw_text(32, i++ * 20, "Vertices: " + string(TREE_COUNT * 381 * 3));