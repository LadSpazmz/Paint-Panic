function sc_Entity_Collision_Basic()
{
ground = (place_meeting(x, y + sign(y_Speed), ob_Par_Solid) && !place_meeting(x, y - 1, ob_Par_Solid) || y_Speed >= 0 && !place_meeting(x, y - 1, ob_One_Way_Solid_D) && place_meeting(x, y + 1, ob_One_Way_Solid_D))

repeat (abs(x_Speed))
{
var _objLR = sign(x_Speed) ? ob_One_Way_Solid_L : ob_One_Way_Solid_R;
            
if (place_meeting(x + sign(x_Speed), y, _objLR) && x_Speed != 0) 
if (!place_meeting(x - sign(x_Speed), y, instance_place(x + sign(x_Speed), y, _objLR)))
x_Speed = 0;

if (place_meeting(x + sign(x_Speed), y, ob_Par_Solid) && !place_meeting(x + sign(x_Speed), y - 1, ob_Par_Solid))
y -= 1;
    
if (!place_meeting(x + sign(x_Speed), y, ob_Par_Solid) && !place_meeting(x + sign(x_Speed), y + 1, ob_Par_Solid) && place_meeting(x + sign(x_Speed), y + 2, ob_Par_Solid))
y += 1;

if (!place_meeting(x + sign(x_Speed), y, ob_Par_Solid))
x += sign(x_Speed);
else
x_Speed = 0;
}

repeat (abs(y_Speed))
{      
var _objUD = sign(y_Speed) ? ob_One_Way_Solid_D : ob_One_Way_Solid_U;

if (place_meeting(x, y + sign(y_Speed), _objUD) && y_Speed != 0)
if (!place_meeting(x, y - sign(y_Speed), instance_place(x, y + sign(y_Speed), _objUD)))
y_Speed = 0;

if (!place_meeting(x, y + sign(y_Speed), ob_Par_Solid))
y += sign(y_Speed);
else
y_Speed = 0;
}

if (ground == false && y_Speed <= max_Yspeed)
y_Speed += grav;

x = round(x);
y = round(y);
}