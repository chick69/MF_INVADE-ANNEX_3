/*
Author:

	BACONMOP

Description:

	Things that may run on both server.
	Deprecated initialization file.
*/

enableSaving false;

//player TK counter
amountOfTKs = 0;
TKLimit = 3;

player setVariable ['timeTKd', time, false];
playerTKed = {
    if ( (player getVariable 'timeTKd' == time) || (player isKindOf "B_Helipilot_F") || (player getVariable "isZeus") ) exitWith {};
	
    amountOfTKs = amountOfTKs + 1;
    player setVariable ['timeTKd', time, false];
	
    if (amountOfTKs == (TKLimit -1)) exitWith {
        player enableSimulation false;
		titleText ["<t align='center'><t size='1.6' font='PuristaBold'>Simulation has been disabled as a result of excessive teamkilling. </t><br /> <t size='1.2' font='PuristaBold'>This is a final warning.  Respawn to re-enable simulation and make this message disappear.</t><br /><br /><t size='0.9' font='PuristaBold'>If you continue to teamkill AhoyWorld cannot be held responsible for the consequences.</t></t>", "BLACK", 2, true, true];
		[]spawn{ 
			waitUntil{!alive player};
			titleFadeOut 0;
			sleep 6000;
			amountOfTKs = amountOfTKs - 1;
		};
	};
    if (amountOfTKs >= TKLimit) exitWith {
		_arrayMessage = format ["User input of %1 got disabled.  UID: %2", name player, getPlayerUID player];
		TKArray pushBack _arrayMessage;
		publicVariable "TKArray";
		[player, "Automated server message: All my user input has been disabled."] remoteExecCall ["sideChat", 0, false];
		titleText ["<t align='center'><t size='1.8' font='PuristaBold'>You have exceeded the server limit for teamkills. <br /> All user input has been disabled.</t><br /> <t size='1.2' font='PuristaBold'>Your unique ID has been logged along with with your name.</t><br/><br /><t size='1.0' font='PuristaBold'>This message will not go away and your input will not be re-enabled. You will have to shut down ArmA. <br/>The easiest way is to press alt + f4.</t><br/><br/><t size='0.8' font='PuristaBold'>We, AhoyWorld, reserve the right to ban you for these teamkills.  this may happen without any further notice</t></t>", "BLACK", 2, true, true];
		disableUserInput true;
	};
	
	[]spawn {
        sleep 6000;
        amountOfTKs = amountOfTKs - 1;
	};
};

//------------------- client executions
//
_uid = getPlayerUID player;
_name = str player;
_playername = name player;
//
//
if( _uid != "_SP_PLAYER_" ) then {
	player globalchat "Bienvenu/Welcome : "+ _playername;
	if ( ( _name in MF_reserved_slots) && !(player getVariable "isAdmin") ) then {
		player globalchat "Detection...ID : "+_uid ;  
		cutText ['YOU ARE IN RESERVED SLOT\nVOUS ETES DANS UN SLOT RESERVE','BLACK OUT'];
		sleep 3;			
		_txt="Error : Vous êtes dans un slot réservé/You are in reserved slot";
		_task = player createSimpleTask [_txt];
		_task setTaskState "Failed";
		_task setSimpleTaskDescription [_txt,_txt,_txt];
		["epicFail",false,2] call BIS_fnc_endMission;
	}; 
};


ghst_halo = compile preprocessfilelinenumbers "MF\ghst_halo.sqf";                 //halo jump


//------------------- client executions
[] execVm "scripts\vehicle\crew\crew.sqf"; 			// vehicle HUD
[] execVM "scripts\misc\QS_icons.sqf";				// Icons
[] execVM "scripts\misc\diary.sqf";					// diary
//[] execVM "MF\mf_pilotCheck.sqf";				    // pilots only
[] execVM "scripts\misc\earplugs.sqf";				//Earplugs from the start
[] execVM "Functions\IgiLoad\IgiLoadInit.sqf";

//------------------- Restrictions and arsenal

#include "defines\arsenalDefines.hpp"
if ("ArsenalFilter" call BIS_fnc_getParamValue == 1) then {
        player addEventHandler ["Take", {
            params ["_unit", "_container", "_item"];

            [_unit, 1, _item, _container] call derp_fnc_gearLimitations;
        }];

        player addEventHandler ["InventoryClosed", {
            params ["_unit"];

            [_unit, 0] call derp_fnc_gearLimitations;
        }];
    };
[{[_this select 0, ("ArsenalFilter" call BIS_fnc_getParamValue)] call derp_fnc_VA_filter}, [ArsenalBoxes], 3] call derp_fnc_waitAndExecute; // Init arsenal boxes.
    {
    _x addAction [
        "<t color='#006bb3'>Save gear</t>",
        {
            player setVariable ["derp_savedGear", (getUnitLoadout player)];
            systemChat "gear saved";
        }
    ];
    } foreach ArsenalBoxes;
//------------------- Disable Arty Computer for all but FSG
enableEngineArtillery false;
if (player isKindOf "B_support_Mort_f") then {
	enableEngineArtillery true;
};
	
//------------------ BIS groups
["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;

//------------------- PLAYER protection
player addRating 10000000;
//------------------ Player SafeZone
sleep 2; //to make sure the base array is defined
player setPos (getMarkerPos "BASE");
sleep 2;

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
	sleep 2;
	if (player getVariable "isAdmin") then {execVM "scripts\adminScripts.sqf";};
	if ((player getVariable "isZeus") && !(player getVariable "isAdmin")) then {execVM "scripts\zeusScripts.sqf";};
	if !(player getVariable "isAdmin") then {execVM "MF\mf_pilotCheck.sqf";};				    // pilots only
};

player addEventHandler ["FiredMan", {
    params ["_unit", "_weapon", "", "", "", "", "_projectile",""];
	
    private _deleteprojectile = false;
    {   _distance = _unit distance2D (getMarkerPos _x);
        if (_distance < 300) then {_deleteprojectile = true;};
    } forEach BaseArray;       
    if (!_deleteprojectile) exitWith {};
	
    if ( (_weapon == "CMFlareLauncher") || ((typeOf _unit == "B_soldier_UAV_F") && (vehicle _unit != _unit)) ) exitWith {};
	if (player getVariable "isZeus") exitWith {
        hint "You are standing in base and shooting.  Be vary carefull when doing this and don't abuse it!";
    };
	
    deleteVehicle _projectile;
	_unitName = name _unit;
    hintC format ["%1, don't goof at base.  Hold your horses soldier, don't throw, fire or place anything inside the base.", _unitName];
}];

