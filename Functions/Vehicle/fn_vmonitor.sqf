/*
@filename: fn_vMonitor.sqf
Credit: Tophe for earlier monitor script
Author:

	Quiksilver
	
Last modified:

	18/05/2017 by stanhope
	
modified:

	repleced getposASLs with getPosWorld, same for setPos.
	Enables respawn on top of the carrier.
	
Description:

	Vehicle monitor. This code must be spawned, not called. Ex. 

______________________________________________________*/

if (!isServer) exitWith { /* GO AWAY PLAYER */ };

//======================================== CONFIG

private ["_v","_t","_d","_s","_i","_sd","_sp","_ti","_u"];

#define DIST_FROM_SPAWN 150

_v = _this select 0;												// vehicle
_d = _this select 1;												// spawn delay
_s = _this select 2;												// setup
_i = _this select 3;												// init

_t = typeOf _v;														// type
_sd = getDir _v;													// spawn direction
_sp = getPosWorld _v;													// spawn position

sleep (5 + (random 5));

[_v] call _i;

//======================================== MONITOR LOOP

while {true} do {
	
	
	//======================================== IF DESTROYED
	
	if (!alive _v) then {
		if (({((_sp distance _x) < 1.5)} count (entities "AllVehicles")) < 1) then {
			_ti = time + _d;
			waitUntil {sleep 5; (_ti < time)};
			if (!isNull _v) then {deleteVehicle _v;}; sleep 0.1;
			_v = createVehicle [_t,[(random 1000),(random 1000),(10000 + (random 20000))],[],0,"NONE"]; sleep 0.1;
			waitUntil {!isNull _v}; sleep 0.1;
			_v setDir _sd; sleep 0.1;
			_v setPosWorld [(_sp select 0),(_sp select 1),((_sp select 2)+0.1)]; sleep 0.1;
			[_v] call _i;
		};
	};
	
	sleep (120 + (random 5));
	
};