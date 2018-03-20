
private ["_damage","_percentage","_veh"];

_damage = damage player;

player globalchat format ["Healing %1. Stand by...", "In Progress"];

while {_damage > 0} do
{
	sleep 0.5;
	_percentage = 100 - (_damage * 100);
	player globalchat format ["Healing (%1%)...", floor _percentage];
	if ((_damage - 0.01) <= 0) then
	{
		player setDamage 0;
		_damage = 0;
	} else {
		player setDamage (_damage - 0.01);
		_damage = _damage - 0.1;
	};
};

player globalchat "Healed (100%).";

player globalchat format ["%1 successfully Healed", "You are"];
