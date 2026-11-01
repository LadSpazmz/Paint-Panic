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
	draw_sprite_ext(sp_Painting_FixMeter, 0, meter.x, meter.y, 1, 1, 0, c_white, 1);
	draw_sprite_ext(sp_Painting_FixMeter_LineUp, 0, x + meter.line_x, meter.line_y, 1, 1, 0, c_white, 1);
	draw_sprite_ext(sp_Painting_FixMeterMarker, 0, x + meter.marker_x, meter.marker_y, 1, 1, 0, c_white, 1);
	draw_text(x, y + 85, meter.line_x);

	if (meter.timer >= 0)
	{
		meter.timer--;
	}
	else
	{
		if (meter.place == 3 || meter.place == 1)
			meter.line_x += 2.2;
		else if (meter.place == 2)
			meter.line_x -= 2.2;
	}

	with(ob_Player)
	{
		sprite_index = sp_Player_Painting;
	}

	if (meter.line_x >= 125)
	{
		Cleaning = false;
		with(ob_Camera)
		{
			max_Zoom = other.cam_Zoom;
			target = ob_Player;
		}
		with(ob_Player)
		{
			state = states.normal;
			ResetAnim(sp_Player_Idle);
		}
	}

	if (ob_Player.press_b)
	{
		var _cond3 = (meter.place == 3 && meter.line_x >= 35 && meter.line_x <= 55);
		var _cond2 = (meter.place == 2 && meter.line_x >= -95 && meter.line_x <= 135);
		var _cond1 = (meter.place == 1 && meter.line_x >= -15 && meter.line_x <= 5);

		if (_cond3 || _cond2 || _cond1)
		{
			if (meter.place == 1)
			{
				Clean = true;
				Cleaning = false;
				with(ob_Camera)
				{
					max_Zoom = 1;
					zoom_Timer = 10;
					target = ob_Player;
				}
			}

			meter.timer = 21;
			meter.place -= 1;

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

if (meter.place == 2)
	meter.marker_x = lerp(meter.marker_x, -232, 0.1);
else if (meter.place == 1)
	meter.marker_x = lerp(meter.marker_x, -172, 0.1);
