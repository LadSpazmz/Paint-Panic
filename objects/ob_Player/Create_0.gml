scr_collision_init()


#region MOVEMENT

SpdAcc = .62;
SpdDec = .75;
WalkCap = 5.5;
currentSpd = WalkCap;
jumpStrength = -12;
grav = .5;
grounded = false;
jumpBuffer = 0;
jumpStop = false;
coyoteTime = 0;

#endregion MOVEMENT

#region IMAGE

image_speed = .25;

depth = -11;

DirXscale = image_xscale;
DirYscale = image_yscale;

#endregion IMAGE

#region INPUT

input_disable = false;
player_get_input();

#endregion INPUT

#region PALETTE

pal_swap_init_system(shd_pal_swapper);
PaletteSelect = 0;
PaletteTransition = 0;

#endregion PALETTE

#region COMBAT

Attacking = false;

#endregion COMBAT

#region STATES

enum states
{
	normal,
	jump,
	crouch,
	actor,
	noclip
}

state = states.normal;
player_states = []
player_states[states.normal] = sc_Player_Normal
player_states[states.jump] = sc_Player_Jump
player_states[states.crouch] = sc_Player_Crouch
player_states[states.actor] = sc_Player_Actor
player_states[states.noclip] = sc_Player_Noclip

PaintingFinishTimer = 0;

#endregion STATES