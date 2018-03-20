/*
Author: BACONMOP

Last modified: Stanhope, AW community member
    
modified: admin/zeus tools + general tweaks

Description: Client scripts that should execute after respawn.
	*/

player disableConversation true;
[player ,"NoVoice"] remoteExec ["setSpeaker",-2,false];

//=========================== Fatigue setting
if (PARAMS_Fatigue == 1) then {player enableFatigue FALSE;};

//========================== Pilot stuff
if (typeOf player == "B_pilot_F" || typeOf player == "B_helipilot_F") then {
	//===== UH-80 TURRETS
	if (PARAMS_UH80TurretControl != 0) then {
		inturretloop = false;
		UH80TurretAction = player addAction ["Turret Control",AW_fnc_uh80TurretControl,[],-95,false,false,'','[] call AW_fnc_conditionUH80TurretControl'];
	};
	//===== despawn damaged helis in base
	player addAction ["<t color='#99ffc6'>Despawn damaged heli</t>",{
			_accepted = false;
			{
			_NearBaseLoc = (getPos player) distance (getMarkerPos _x);
			if (_NearBaseLoc < 500) then {_accepted = true;};
			} forEach BaseArray;
			
			if (_accepted) then {
				_vehicle = vehicle player;
				moveOut player;
				deleteVehicle _vehicle;
				[parseText format ["<br /><br /><t align='center' font='PuristaBold' ><t size='1.2'>Heli successfully despawned.</t></t>"], true, nil, 4, 0.5, 0.3] spawn BIS_fnc_textTiles;
			} else {
				[parseText format ["<br /><t align='center' font='PuristaBold' ><t size='1.2'>This action is not allowed outside of base.</t><t size='1.0'><br /> Heli not despawned</t></t>"], true, nil, 6, 0.5, 0.3] spawn BIS_fnc_textTiles;
			};	
		},[],-100,false,true,"","
		(player == driver (vehicle player)) && 
		((vehicle player) isKindOf 'Helicopter') && 
		((speed (vehicle player)) < 1) && 
		{count (crew (vehicle player))==1} &&
		( 
			(((vehicle player) getHitPointDamage 'hitEngine') > 0.4) ||
			(((vehicle player) getHitPointDamage 'HitHRotor') > 0.4 )||
			((damage (vehicle player)) > 0.5) ||
			((fuel (vehicle player)) <= 0)
		)
		",4];	
};

//======================= Add players to Zeus
{_x addCuratorEditableObjects [[player], true];} foreach allCurators;

//======================clear vehicle inventory
player addAction ["<t color='#ff0000'>Clear vehicle inventory</t>",{[] call AW_fnc_clearVehicleInventory},[],-100,false,true,"","(player == driver vehicle player) && !((vehicle player) == player)"];

//======================= Assign zeus
[] spawn {
    sleep 5;
    [player] remoteExecCall ["initiateZeusByUID", 2];
	if !(player getVariable "isAdmin") then {execVM "MF\mf_pilotCheck.sqf";};				    // pilots only
	sleep 2;
	if (player getVariable "isAdmin") then {execVM "scripts\adminScripts.sqf";};
	if ((player getVariable "isZeus") && !(player getVariable "isAdmin")) then {execVM "scripts\zeusScripts.sqf";};
};
