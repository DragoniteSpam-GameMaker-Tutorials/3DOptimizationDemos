//shader_set(shd_diorama);
sprite_index_count = 0;
with (obj_grass) {
	event_perform(ev_draw, 0);
}
matrix_set(matrix_world, matrix_build_identity());
shader_reset();