#region CAMERA

// Target Follow
setup.xCam = lerp(setup.xCam, (target.x - (setup.width / 2)), 0.1);
setup.yCam = lerp(setup.yCam, (target.y - (setup.height / 2)), 0.1);

// Borders
setup.xCam = clamp(setup.xCam, 0, (room_width - setup.width))
setup.yCam = clamp(setup.yCam, 0, (room_height - setup.height))

// Shake
shake = Approach(shake, 0, .5);

// Zoom
if (zoom_Timer >= 0)
zoom_Timer--;
else
max_Zoom = 1;

// Flash
if (flash >= 0)
flash -= 0.02;

setup.zoom = lerp(setup.zoom, max_Zoom, 0.065);
setup.width = (global.camWidth * setup.zoom);
setup.height = (global.camHeight * setup.zoom);

// Camera Setup
camera_set_view_pos(view_camera[0], (setup.xCam + irandom_range(-shake, shake)), (setup.yCam + irandom_range(-shake, shake)))
camera_set_view_size(view_camera[0], setup.width, setup.height);
surface_resize(application_surface, setup.width, setup.height);

#endregion CAMERA