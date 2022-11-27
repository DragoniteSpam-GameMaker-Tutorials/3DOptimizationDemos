/// @description Draw the 3D world
draw_clear(c_black);

shader_set(shd_basic_3d_stuff);

// 3D projections require a view and projection matrix
var camera = camera_get_active();
camera_set_view_mat(camera, self.view_mat);
camera_set_proj_mat(camera, self.proj_mat);
camera_apply(camera);

vertex_submit(self.vb_all_trees, pr_trianglelist, sprite_get_texture(spr_brokenvector, 0));

shader_reset();
matrix_set(matrix_world, matrix_build_identity());