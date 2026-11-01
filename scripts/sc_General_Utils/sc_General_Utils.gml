function Approach(val1, val2, amount) 
{
    if (val1 < val2)
        return min(val1 + amount, val2);
	else
        return max(val1 - amount, val2);
}
function AnimEnd()
{
	return (image_index >= image_number - 1);
}
function ResetAnim(sprite)
{
	sprite_index = sprite
	image_index = 0
}
