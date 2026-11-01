function sc_Player_Normal()
{
var _move_Speed = abs(x_Speed);
var _move = hold_right - hold_left;

var _objLR = (sign(x_Speed) ? ob_One_Way_Solid_L : ob_One_Way_Solid_R);
var _against_Wall = (place_meeting(x + sign(DirXscale), y, ob_Solid) || place_meeting(x + sign(DirXscale), y, _objLR));


switch(sprite_index) 
{
case(sp_Player_Idle):

if (_move != 0 && sprite_index != sp_Player_Walk && sprite_index != sp_Player_Land)
{
image_index = 0;
sprite_index = sp_Player_Walk;
}

x_Speed = 0;
image_speed = 0.2;

break;


case(sp_Player_Walk):

// Walk effects (dust clouds, ect)

if (_move == 0 && _move_Speed == 0 && sprite_index != sp_Player_Idle)
{
image_index = 0;
sprite_index = sp_Player_Idle;
}

image_speed = ((_move_Speed / 6) * 0.2);

break;



case(sp_Player_Land):

if (AnimEnd())
{
image_index = 0;
if (_move_Speed == 0)
sprite_index = sp_Player_Idle;
else
sprite_index = sp_Player_Walk;
}

image_speed = 0.25;

break;
}

if (_move != 0 && sprite_index != sp_Player_Idle)
{
DirXscale = _move;
if (!_against_Wall)
x_Speed = Approach(x_Speed, (currentSpd * _move), SpdAcc);
}
else
x_Speed = Approach(x_Speed, 0, SpdDec);

if (!coyoteTime)
{
image_index = 0;
sprite_index = sp_Player_Jump_Loop;
state = "jump";
}

if (jumpBuffer && coyoteTime)
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

if (press_down && ground)
{
image_index = 0;
sprite_index = sp_Player_CrouchStart;
state = "crouch";
}
}