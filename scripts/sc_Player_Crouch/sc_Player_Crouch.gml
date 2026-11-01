function sc_Player_Crouch()
{
var _move_Speed = abs(x_Speed);
var _move = hold_right - hold_left;

switch(sprite_index) 
{
case(sp_Player_CrouchStart):

// Setup for idle anims

if (AnimEnd())
{
image_index = 0;
sprite_index = sp_Player_Crouch;
}

image_speed = 0.2;

break;

case(sp_Player_Crouch):

// Setup for idle anims

if (_move != 0 && sprite_index != sp_Player_Crawl)
{
image_index = 0;
sprite_index = sp_Player_Crawl;
}

image_speed = 0.2;

break;


case(sp_Player_Crawl):

// Walk effects (dust clouds, ect)

if (_move == 0 && _move_Speed == 0 && sprite_index != sp_Player_Crouch)
{
image_index = 0;
sprite_index = sp_Player_Crouch;
}

image_speed = ((_move_Speed / 6) * 0.2);

break;
}

if (_move != 0)
{
DirXscale = _move;
x_Speed = Approach(x_Speed, (4 * _move), SpdAcc);
}
else
x_Speed = 0;

if (!coyoteTime)
{
image_index = 0;
sprite_index = sp_Player_Fall;
state = "jump";
}

if (!place_meeting(x, y - 15, ob_Par_Solid) && !place_meeting(x, y - 10, ob_Par_Solid) && !place_meeting(x, y - 5, ob_Par_Solid) && !place_meeting(x, y - 2, ob_Par_Solid))
{
if (jumpBuffer && coyoteTime && ground)
{
image_index = 0;
sprite_index = sp_Player_Jump;
y_Speed = jumpStrength;
jumpBuffer = false;
jumpStop = false;
state = "jump";
// Create partacle
// Create sound
}

if (!hold_down && ground)
{
image_index = 0;
if (_move_Speed != 0)
sprite_index = sp_Player_Walk;
else
sprite_index = sp_Player_Idle;
state = "normal";
}
}
}