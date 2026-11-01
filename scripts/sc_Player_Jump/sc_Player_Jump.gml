function sc_Player_Jump()
{
image_speed = 0.225;

var _move_Speed = abs(x_Speed);
var _move = hold_right - hold_left;

var _objLR = (sign(x_Speed) ? ob_One_Way_Solid_L : ob_One_Way_Solid_R);
var _against_Wall = (place_meeting(x + sign(DirXscale), y, ob_Solid) || place_meeting(x + sign(DirXscale), y, _objLR));


if (ground == false)
{
switch(sprite_index) 
{
case(sp_Player_Jump):

if (jumpStop == false && !hold_a && y_Speed <= 0.5)
{
image_index = 0;
sprite_index = sp_Player_Fall;
y_Speed /= 10;
jumpStop = true;
}

if (AnimEnd())
{
image_index = 0;
sprite_index = sp_Player_Jump_Loop;
}

break;


case(sp_Player_Jump_Loop):

if (y_Speed >= 0)
{
image_index = 0;
sprite_index = sp_Player_Fall;
}

break;


case(sp_Player_Fall):

if (AnimEnd())
{
image_index = 0;
sprite_index = sp_Player_Fall_Loop;
}

break;
}
}

if (_move != 0)
{
DirXscale = _move;
x_Speed = Approach(x_Speed, (currentSpd * _move), SpdAcc);
}
else
x_Speed = Approach(x_Speed, 0, SpdDec);

if (ground && y_Speed >= 0)
{
image_index = 0;
sprite_index = sp_Player_Land;
if (_move != 0)
DirXscale = _move;
state = states.normal;
}
}