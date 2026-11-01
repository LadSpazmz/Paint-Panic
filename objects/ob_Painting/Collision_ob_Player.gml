if (ob_Player.press_up && Cleaning == false && Clean == false && ob_Player.state == states.normal)
{
Cleaning = true;
MeterLineUpX = -115;
MeterLineUpMarkerX = -115;
MeterLineUpMarkerPlace = 3;

with(ob_Camera)
{
max_Zoom = other.cam_Zoom;
zoom_Timer = 1000;
target = other;
}

with(ob_Player)
{
state = states.blank;
x_Speed = 0;
y_Speed = 0;
}
}