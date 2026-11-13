var _thickness = 32;
var _edge_offset = (1 - abs(DirXscale)) * _thickness;

if (_edge_offset > 0)
{
	var _x_offset = (DirXscale >= 0) ? _edge_offset : -_edge_offset;
	var _edge_color = make_color_rgb(77, 79, 105);
	
	gpu_set_fog(true, _edge_color, 0, 0);
	draw_sprite_ext(sprite_index, image_index, x + _x_offset, y, DirXscale, DirYscale, image_angle, image_blend, image_alpha);
	gpu_set_fog(false, c_white, 0, 0);
}

draw_sprite_ext(sprite_index, image_index, x, y, DirXscale, DirYscale, image_angle, image_blend, image_alpha);

if (Clean && DirXscale >= 0)
{
	draw_sprite_ext(sp_PaintingsTEMP, PaintIndex, x, y, DirXscale, DirYscale, image_angle, image_blend, image_alpha);
}

if (Cleaning)
{
	with(ob_Camera)
	{
		max_Zoom = other.cam_Zoom;
		zoom_Timer = 1000;
		target = other;
	}

	draw_sprite_ext(sp_Painting_FixMatch, meter.index1, meter.x, meter.y, 1, 1, 0, c_white, 1);
	draw_sprite_ext(sp_Painting_FixMatch, meter.index2, meter.x2, meter.y, 1, 1, 0, c_white, 1);
	draw_sprite_ext(sp_Painting_FixMatch, meter.index3, meter.x3, meter.y, 1, 1, 0, c_white, 1);
	draw_sprite_ext(sp_Painting_FixMatch, meter.arrowindex, meter.arrowselect, meter.y - 35, 1, 1, 0, c_white, 1);

	if (meter.arrowselect == meter.x)
	{
		if (ob_Player.press_up)
		meter.index1 += 1;
		if (ob_Player.press_down)
		meter.index1 -= 1;
		if (meter.index1 == meter.indexmax)
		meter.index1 = meter.indexmin + 1;
		if (meter.index1 == meter.indexmin)
		meter.index1 = meter.indexmax - 1;
		if (presstimer <= 0)
		{
		if (ob_Player.press_right)
		{
		meter.arrowselect = meter.x2;
		presstimer = 12;
		}
		if (ob_Player.press_left)
		{
		meter.arrowselect = meter.x3;
		presstimer = 12;
		}
		}
	}
	
	if (meter.arrowselect == meter.x2)
	{
		if (ob_Player.press_up)
		meter.index2 += 1;
		if (ob_Player.press_down)
		meter.index2 -= 1;
		if (meter.index2 == meter.indexmax)
		meter.index2 = meter.indexmin + 1;
		if (meter.index2 == meter.indexmin)
		meter.index2 = meter.indexmax - 1;
		if (presstimer <= 0)
		{
		if (ob_Player.press_right)
		{
		meter.arrowselect = meter.x3;
		presstimer = 12;
		}
		
		if (ob_Player.press_left)
		{
		meter.arrowselect = meter.x;
		presstimer = 12;
		}
		}
	}
	
	if (meter.arrowselect == meter.x3)
	{
		if (ob_Player.press_up)
		meter.index3 += 1;
		if (ob_Player.press_down)
		meter.index3 -= 1;
		if (meter.index3 == meter.indexmax)
		meter.index3 = meter.indexmin + 1;
		if (meter.index3 == meter.indexmin)
		meter.index3 = meter.indexmax - 1;
		if (presstimer <= 0)
		{
		if (ob_Player.press_right)
		{
		meter.arrowselect = meter.x;
		presstimer = 12;
		}
		
		if (ob_Player.press_left)
		{
		meter.arrowselect = meter.x2;
		presstimer = 12;
		}
		}
	}
	
	with(ob_Player)
	{
		sprite_index = sp_Player_Painting;
	}

	if (ob_Player.press_b)
	{
		var _cond3 = (meter.index1 == 0 && meter.index2 == 0 && meter.index3 == 0);
		var _cond2 = (meter.index1 == 1 && meter.index2 == 1 && meter.index3 == 1);
		var _cond1 = (meter.index1 == 2 && meter.index2 == 2 && meter.index3 == 2);

		if (_cond3 || _cond2 || _cond1)
		{
				Clean = true;
				Cleaning = false;
				with(ob_Camera)
				{
					max_Zoom = 1;
					zoom_Timer = 10;
					target = ob_Player;
				}

			with(ob_Player)
			{
				sprite_index = sp_Player_PaintingFinish;
				PaintingFinishTimer = 41;
			}
		}
		else
		{
			Cleaning = false;
			with(ob_Player)
			{
				state = states.normal;
				ResetAnim(sp_Player_Idle);
			}
			with(ob_Camera)
			{
				max_Zoom = 1;
				zoom_Timer = 10;
				target = ob_Player;
			}
		}
	}
}
