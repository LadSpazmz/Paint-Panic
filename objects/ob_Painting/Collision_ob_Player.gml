if (!Cleaning && !Clean && ob_Player.press_up && ob_Player.state == states.normal)
{
	Cleaning = true;
	meter.line_x = -115;
	meter.marker_x = -115;
	meter.place = 3;

	with(ob_Camera)
	{
		max_Zoom = other.cam_Zoom;
		zoom_Timer = 1000;
		target = other;
	}

	with(ob_Player)
	{
		state = states.blank;
		hsp = 0;
		vsp = 0;
	}
}
