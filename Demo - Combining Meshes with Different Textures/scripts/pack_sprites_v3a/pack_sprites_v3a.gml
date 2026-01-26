function pack_sprites_v3a(sprites) {
    var largest_w = 0;
    var largest_h = 0;
    var area = 0;
    
    var sprite_count = array_length(sprites);
    var sprite_rects = array_create(sprite_count);
    
    for (var i = 0; i < sprite_count; i++) {
        var sprite = sprites[i];
        largest_w = max(largest_w, sprite_get_width(sprite));
        largest_h = max(largest_h, sprite_get_height(sprite));
        sprite_rects[i] = {
            x: 0,
            y: 0,
            w: sprite_get_width(sprite),
            h: sprite_get_height(sprite),
            placed: false,
            sprite: sprite
        };
        area += sprite_get_width(sprite) * sprite_get_height(sprite);
    }
    
    array_sort(sprite_rects, function(a, b) {
        return sign(b.h - a.h);
    });
    
    var atlas_width = max(sqrt(area), largest_w);
    atlas_width = power(2, ceil(log2(atlas_width)));
    var atlas_height = 0;
    
    var stride = 32;
    
    for (var i = 0; i < sprite_count; i++) {
        var this_sprite = sprite_rects[i];
        
        var sprite_test_inst = instance_create_depth(0, 0, 0, obj_pack_sprite_3a_placeholder);
        sprite_test_inst.image_xscale = this_sprite.w;
        sprite_test_inst.image_yscale = this_sprite.h;
        
        var yy = 0;
        while (true) {
            for (var xx = 0; xx < atlas_width - this_sprite.w; xx += stride) {
                var overlap = false;
                
                with (sprite_test_inst) {
                    x = xx;
                    y = yy;
                    if (place_meeting(x, y, obj_pack_sprite_3a_placeholder)) {
                        overlap = true;
                    }
                }
                
                if (!overlap) {
                    this_sprite.x = xx;
                    this_sprite.y = yy;
                    this_sprite.placed = true;
                    atlas_height = max(atlas_height, this_sprite.y + this_sprite.h);
                    break;
                }
            }
            
            if (this_sprite.placed) {
                break;
            }
            
            yy += stride;
        }
    }
    
    atlas_height = power(2, ceil(log2(atlas_height)));
    
    instance_destroy(obj_pack_sprite_3a_placeholder);
    
    
    
    
    
    
    
    
    
    
    
    
    var atlas = surface_create(atlas_width, atlas_height);
    
    surface_set_target(atlas);
    draw_clear_alpha(c_black, 0);
    
    for (var i = 0; i < sprite_count; i++) {
        var sprite_info = sprite_rects[i];
		
		sprite_info.u1 = sprite_info.x / atlas_width;
		sprite_info.v1 = sprite_info.y / atlas_height;
		sprite_info.u2 = (sprite_info.x + sprite_info.w) / atlas_width;
		sprite_info.v2 = (sprite_info.y + sprite_info.h) / atlas_height;
        
        draw_sprite(sprite_info.sprite, 0, sprite_info.x + sprite_get_xoffset(sprite_info.sprite), sprite_info.y + sprite_get_yoffset(sprite_info.sprite));
    }
    
    surface_reset_target();
    
    var sprite = sprite_create_from_surface(atlas, 0, 0, atlas_width, atlas_height, false, false, 0, 0);
    surface_free(atlas);
    
    return {
        metadata: sprite_rects,
        atlas: sprite
    }
}