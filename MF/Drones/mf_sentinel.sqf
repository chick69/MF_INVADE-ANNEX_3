_unit = _this select 1;
_typeOf = typeOf _unit;
_okOk = 0;
_reserved_slots = ["B_recon_JTAC_F","B_CTRG_soldier_engineer_exp_F","B_Pilot_F","B_recon_medic_F","B_recon_F","B_recon_TL_F","B_recon_LAT_F","B_recon_M_F","B_recon_LAT_F","B_recon_exp_F","B_soldier_UAV_F"]; // List des users autorisés

if (_typeOf in _reserved_slots) then {
	if (isNil "VSENTINEL") then {
		_okOk = 1;
	} else {
		if (!alive VSENTINEL) then {_okOk = 1;};
	};

	if (_okOk==1)  then {
		VSENTINEL = createVehicle ["B_UAV_05_F",[723.257,15072.052,27.109],[],0,"NONE"];  
		VSENTINEL setPosWorld [723.257,15072.052,27.109]; // [x,y,z] or positionWorld
		createVehicleCrew VSENTINEL;
		VSENTINEL setDir 89.569; 
		{
			_x addCuratorEditableObjects [units VSENTINEL, false];
		} foreach adminCurators;
		hint "Sentinel livré";
	} else {
		hint "Le sentinel est déjà en cours d'utilisation";
	};
} else {
	hint "Vous n'etes pas autorisé à utiliser le sentinel";
};



