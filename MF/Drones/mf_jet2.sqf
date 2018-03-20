_unit = _this select 1;
_typeOf = typeOf _unit;
_okOk = 0;
_reserved_slots = ["B_recon_JTAC_F","B_Pilot_F"]; // List des users autorisés

if (_typeOf in _reserved_slots) then {
	if (isNil "JET2") then {
		_okOk = 1;
	} else {
		if (!alive JET2) then {_okOk = 1;};
	};

	if (_okOk==1)  then {
    JET2 = createVehicle ["B_Plane_Fighter_01_F",[721.779,14905.533,27.109],[],0,"NONE"];
	[JET2,["CamoGrey",1],true] call BIS_fnc_initVehicle;
    JET2 setPosWorld [721.779,14905.533,27.109]; // [x,y,z] or positionWorld
    JET2 setDir 178.759; // North
   
   private _pylons = ["PylonMissile_Missile_BIM9X_x1","PylonMissile_Missile_BIM9X_x1","PylonRack_Missile_AMRAAM_C_x1","PylonRack_Missile_AMRAAM_C_x1"];
private _pylonPaths = (configProperties [configFile >> "CfgVehicles" >> typeOf JET2 >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"]) apply {getArray (_x >> "turret")};
{ JET2 removeWeaponGlobal getText (configFile >> "CfgMagazines" >> _x >> "pylonWeapon") } forEach getPylonMagazines JET2;
{ JET2 setPylonLoadOut [_forEachIndex + 1, _x, true, _pylonPaths select _forEachIndex] } forEach _pylons;
   
   
   [JET2] call BIS_fnc_Carrier01PosUpdate;
		hint "Jet livré";
	} else {
		hint "Le Jet est déjà en cours d'utilisation";
	};
} else {
	hint "Vous n'etes pas autorisé à utiliser ce véhicule";
};
