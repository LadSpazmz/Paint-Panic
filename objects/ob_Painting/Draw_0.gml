draw_sprite_ext(sprite_index, image_index, x, y, DirXscale, DirYscale, image_angle, image_blend, image_alpha);
if (Clean == true && DirXscale >= 0)
draw_sprite_ext(sp_PaintingsTEMP, PaintIndex, x, y, DirXscale, DirYscale, image_angle, image_blend, image_alpha);

if (Cleaning == true)
{
draw_sprite_ext(sp_Painting_FixMeter, 0, MeterX, MeterY, 1, 1, 0, c_white, 1);
draw_sprite_ext(sp_Painting_FixMeter_LineUp, 0, x+MeterLineUpX, MeterLineUpY, 1, 1, 0, c_white, 1);
draw_sprite_ext(sp_Painting_FixMeterMarker, 0, x+MeterLineUpMarkerX, MeterLineUpMarkerY, 1, 1, 0, c_white, 1);
draw_text(x,y+85,MeterLineUpX);

if (MeterLineUp >= 0)
MeterLineUp--;
else
{
if (MeterLineUpMarkerPlace == 3 || MeterLineUpMarkerPlace == 1)
MeterLineUpX += 2.2;
if (MeterLineUpMarkerPlace == 2)
MeterLineUpX -= 2.2;
}


with(ob_Player)
sprite_index = sp_Player_Painting;

if (MeterLineUpX >= 125)
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
sprite_index = sp_Player_Idle;
image_index = 0;
}
}
if (ob_Player.press_b)
{
if (MeterLineUpX >= 35 && MeterLineUpX <= 55 && MeterLineUpMarkerPlace == 3 || MeterLineUpX >= -95 && MeterLineUpX <= 135 && MeterLineUpMarkerPlace == 2 || MeterLineUpX >= -15 && MeterLineUpX <= 05 && MeterLineUpMarkerPlace == 1)
{
if (MeterLineUpMarkerPlace == 1)
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

MeterLineUp = 21;

MeterLineUpMarkerPlace -= 1;

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
sprite_index = sp_Player_Idle;
image_index = 0;
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

if (MeterLineUpMarkerPlace == 2)
MeterLineUpMarkerX = lerp(MeterLineUpMarkerX,-232,.1);
if (MeterLineUpMarkerPlace == 1)
MeterLineUpMarkerX = lerp(MeterLineUpMarkerX,-172,.1);