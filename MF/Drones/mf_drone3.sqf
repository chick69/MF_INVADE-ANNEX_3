_unit = _this select 1;
_typeOf = typeOf _unit;
_okOk = 0;
_reserved_slots = ["B_recon_JTAC_F","B_CTRG_soldier_engineer_exp_F","B_Pilot_F","B_recon_medic_F","B_recon_F","B_recon_TL_F","B_recon_LAT_F","B_recon_M_F","B_recon_LAT_F","B_recon_exp_F","B_soldier_UAV_F"]; // List des users autorisés

if (_typeOf in _reserved_slots) then {
	if (isNil "VDRONE3") then {
		_okOk = 1;
	} else {
		if (!alive VDRONE3) then {_okOk = 1;};
	};

	if (_okOk==1)  then {
		VDRONE3 = createVehicle ["B_T_UAV_03_F", getMarkerPos "DRONE3", [], 0,""];  
		createVehicleCrew VDRONE3;
		VDRONE3 setDir 90; 
		{
			_x addCuratorEditableObjects [units VDRONE3, false];
		} foreach adminCurators;
		hint "Le véhicule livré";
	} else {
		hint "Le véhicule est déjà en cours d'utilisation";
	};
} else {
	hint "Vous n'etes pas autorisé à utiliser ce véhicule";
};
