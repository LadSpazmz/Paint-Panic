ini_open(working_directory + "options.ini");
global.windowSize = ini_read_real("General", "Windowsize", 1);

var res = [[480, 270], [960, 540], [1024, 576], [1280, 720], [1600, 900], [1920, 1080]];
window_set_size(res[global.windowSize][0], res[global.windowSize][1]);
window_center();
window_set_fullscreen(false);


depth = -999;
gameframe_init();

global.gameframe_caption_text = "Paint Panic!";
global.gameframe_caption_font = fnt_caption;
global.gameframe_caption_icon = sp_Icon;