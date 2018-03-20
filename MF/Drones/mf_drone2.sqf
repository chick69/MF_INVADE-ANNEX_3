_unit = _this select 1;
_typeOf = typeOf _unit;
_okOk = 0;
_reserved_slots = ["B_recon_JTAC_F","B_CTRG_soldier_engineer_exp_F","B_Pilot_F","B_recon_medic_F","B_recon_F","B_recon_TL_F","B_recon_LAT_F","B_recon_M_F","B_recon_LAT_F","B_recon_exp_F","B_soldier_UAV_F"]; // List des users autorisés

if (_typeOf in _reserved_slots) then {
	if (isNil "VDRONE2") then {
		_okOk = 1;
	} else {
		if (!alive VDRONE2) then {_okOk = 1;};
	};

	if (_okOk==1)  then {
		VDRONE2 = createVehicle ["B_UAV_02_CAS_F", getMarkerPos "DRONE2", [], 0,""];  
		createVehicleCrew VDRONE2;
		VDRONE2 setDir 90; 
		{
			_x addCuratorEditableObjects [units VDRONE2, false];
		} foreach adminCurators;
		hint "Sentinel livré";
	} else {
		hint "Le véhicule est déjà en cours d'utilisation";
	};
} else {
	hint "Vous n'etes pas autorisé à utiliser ce véhicule";
};
