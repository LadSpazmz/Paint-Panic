if (Clean == false)
{
DirXscale = Approach(DirXscale, -1, .1);
if (DirXscale <= 0)
image_index = 1;
}
else
{
DirXscale = Approach(DirXscale, 1, .1);
if (DirXscale >= 0)
image_index = 0;
}