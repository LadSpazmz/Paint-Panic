var _targetDir = Clean ? 1 : -1;
DirXscale = Approach(DirXscale, _targetDir, 0.1);

if ((Clean && DirXscale >= 0) || (!Clean && DirXscale <= 0))
{
	image_index = Clean ? 0 : 1;
}

