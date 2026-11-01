if (global.hitStun == false)
{
sc_Entity_Collision_Basic();

switch (state) 
{
case "normal":
sc_Player_Normal();
break;

case "jump":
sc_Player_Jump();
break;

case "crouch":
sc_Player_Crouch();
break;
}
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
state = "normal";
sprite_index = sp_Player_Idle;
image_index = 0;
}