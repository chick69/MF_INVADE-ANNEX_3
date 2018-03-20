// Original pilotcheck by Kamaradski [AW]. 
// Since then been tweaked by many hands!
// Notable contributors: chucky [allFPS], Quiksilver.

_pilots = ["B_Pilot_F"];
_pilots_transport = ["B_Helipilot_F"];
_CoPilots = ["B_Fighter_Pilot_F"];
_armed_aircraft = ["B_Heli_Attack_01_F","B_Plane_CAS_01_F","I_Heli_light_03_F","B_Heli_Light_01_armed_F"];
_aircraft_nocopilot = ["B_Heli_Light_01_F","B_Heli_Light_01_stripped_F","B_Heli_Transport_01_F","B_Heli_Transport_01_camo_F","B_Heli_Transport_03_F","B_Heli_Transport_03_unarmed_F","B_Heli_Transport_03_black_F","B_Heli_Transport_03_unarmed_green_F","I_Heli_light_03_unarmed_F","I_Heli_Transport_02_F","B_T_VTOL_01_vehicule_P"];

waitUntil {player == player};

_iampilot = ({typeOf player == _x} count _pilots) > 0;
_iamtransport = ({typeOf player == _x} count _pilots_transport) > 0;
_iamCopilotArmed = ({typeOf player == _x} count _CoPilots) > 0;
_iamCopilot = ({typeOf player == _x} count _CoPilots) > 0;

if (player getVariable "isAdmin") exitWith {};

while { true } do {
	_oldvehicle = vehicle player;
	waitUntil {vehicle player != _oldvehicle};

	if(vehicle player != player) then {
		_veh = vehicle player;

		//------------------------------ pilot can be pilot seat only
		
		if((_veh isKindOf "Helicopter" || _veh isKindOf "Plane") && !(_veh isKindOf "ParachuteBase")) then 
		{
			// vehicule de transport
			if(({typeOf _veh == _x} count _aircraft_nocopilot) > 0) then 
			{
				_forbidden = [_veh turretUnit [0]];
				if(player in _forbidden) then {
					if !(_iamCopilot) then {
						vehicle player vehicleChat "vous devez etre un Copilote pour etre en copilote ";
						vehicle player vehicleChat "you need to be Copilot to get in Co-pilot";
						player action ["getOut",_veh];
					};
				};
			};
			if(({typeOf _veh == _x} count _aircraft_nocopilot) > 0) then 
			{
				_forbidden = [driver _veh];
				if(player in _forbidden) then {
					if (!(_iamtransport) && !(_iampilot)) then {
						vehicle player vehicleChat "vous devez etre un pilote de transport pour utiliser cette aeronef";
						vehicle player vehicleChat "You must be a transport pilot to fly this aircraft";
						player action ["getOut",_veh];
					};
				};
			};
			
			// vehicules armés
			if(({typeOf _veh == _x} count _armed_aircraft) > 0) then 
			{
				_forbidden = [_veh turretUnit [0]];
				if(player in _forbidden) then {
					if (!(_iampilot) && !(_iamCopilotArmed)) then {
						vehicle player vehicleChat "vous devez etre un Copilote pour etre en copilote ";
						vehicle player vehicleChat "you need to be pilot to get in Co-pilot";
						player action ["getOut",_veh];
					};
				};
			};
			if(({typeOf _veh == _x} count _armed_aircraft) > 0) then 
			{
				_forbidden = [driver _veh];
				if(player in _forbidden) then {
					if !(_iampilot) then {
						vehicle player vehicleChat "vous devez etre un pilote de combat pour utiliser cette aeronef";
						vehicle player vehicleChat "You must be a combat pilot to fly this aircraft";
						player action ["getOut",_veh];
					};
				};
			};
		};
	};
};

