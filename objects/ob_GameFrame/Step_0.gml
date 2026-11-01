gameframe_update();
surface_resize(application_surface, global.camWidth, global.camHeight);

var _winWidth = window_get_width();
var _winHeight = window_get_height();

if (_winWidth == 1920 && _winHeight >= 1030)
window_set_size(1920, 1080);
else
gpu_set_tex_filter(true)