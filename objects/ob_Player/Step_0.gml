if (!global.hitStun)
{
	sc_Entity_Collision_Basic();

	if state != undefined
		player_states[state]()
}

// Coyote time
if (ground)
coyoteTime = 7.5;
else if (y_Speed <= 0)
coyoteTime = 0;

coyoteTime--;

// Painting end timer
if (PaintingFinishTimer >= 0)
	PaintingFinishTimer--;
else if (sprite_index = sp_Player_PaintingFinish)
{
	state = states.normal;
	sprite_index = sp_Player_Idle;
	image_index = 0;
}