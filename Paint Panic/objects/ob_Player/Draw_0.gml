pal_swap_set(sp_Player_Palette, PaletteTransition, false);
draw_sprite_ext(sprite_index, image_index, x, y, DirXscale, DirYscale, image_angle, image_blend, image_alpha);
pal_swap_reset();

PaletteTransition = lerp(PaletteTransition, PaletteSelect, .065);

draw_text(x,y,state);