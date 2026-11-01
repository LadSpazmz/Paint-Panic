function sh_noclip(args)
{
	with ob_Player
	{
		state = states.noclip
	}
}

function meta_noclip()
{
    return 
    {
        description: "sets noclip",
        arguments: ["<bool>"],
        suggestions: [["true", "false"]],
        argumentDescriptions: ["fly through collisions"]
    };
}