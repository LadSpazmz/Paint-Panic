#region STARTUP

#region SETUP

global.camWidth = 1366;
global.camHeight = 768;

global.hitStun = false;

global.MyCollisionList = ds_list_create()

window_center();
window_set_size(960, 540);
game_set_speed(64, gamespeed_fps);

room_goto(rm_TestFeild);

#endregion STARTUP