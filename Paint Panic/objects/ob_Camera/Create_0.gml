#region SETUP

// Target
target = ob_Player;

// Shake
shake = 0;

// Flash
flash = 0;

// Setup
setup = 
{
xCam: target.x,
yCam: target.y,
width: global.camWidth,
height: global.camHeight,
zoom: 1
};

// X & Y
setup.xCam = target.x - (setup.width / 2);
setup.yCam = target.y - (setup.height / 2);

// Zoom
max_Zoom = 1;
zoom_Timer = 0;

// Borders
camera_set_view_border(view_camera[0], (setup.width * .5) * 0.97, (setup.height * .5) * 0.97)

// Depth
depth = -999;

#endregion SETUP