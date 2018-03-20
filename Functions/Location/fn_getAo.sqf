/*
 * Author: Pfc.Christiansen
 * [Get near locations from .hhp entry of current AO]
 * Edited by: BACONMOP
 * for redundancy checks
 *
 * Arguments:
 * 0: current AO
 *
 * Return Value:
 * STRING
 *
 * Example [_currentAO] call AW_fnc_nextAO;
 *
 * Public: NO
 */
 
_AO_Entry = _this select 0;
_controlled = true;
 
_near_locations =  allMapMarkers select {_x select [0,3] == "AO_"};
_nextAO = _near_locations call BIS_fnc_selectRandom;

//manually assign a AO
if (manualAO!="") then {
	_arrayAO = allMapMarkers select {_x select [0,3] == "AO_"};
	_manualAOexists = count _arrayAO;
	if (_manualAOexists >=0) then{
		_nextAO = manualAO;
	};
};

if (_nextAO in controlledZones) then {
        while {_controlled} do {
                _zonesLeft = count _near_locations;
                if (_zonesLeft >= 1) then {
                        _nextAO = _near_locations call BIS_fnc_selectRandom;
                        _near_locations = _near_locations - [_nextAO];
                        if !(_nextAO in controlledZones) then {
                                _controlled = false;
                        };
                } else {
                        _AO_Entry = controlledZones call BIS_fnc_selectRandom;
                        _near_locations =  allMapMarkers select {_x select [0,3] == "AO_"};
                        _nextAO = _near_locations call BIS_fnc_selectRandom;
                         if !(_nextAO in controlledZones) then {
                                _controlled = false;
                        };
                };
        };
};
 
_nextAO