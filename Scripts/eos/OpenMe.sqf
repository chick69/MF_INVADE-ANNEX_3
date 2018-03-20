EOS_Spawn = compile preprocessfilelinenumbers "scripts\eos\core\eos_launch.sqf";Bastion_Spawn=compile preprocessfilelinenumbers "scripts\eos\core\b_launch.sqf";null=[] execVM "scripts\eos\core\spawn_fnc.sqf";onplayerConnected {[] execVM "scripts\eos\Functions\EOS_Markers.sqf";};
/* 
EOS 1.98 by BangaBob 

GROUP SIZES
 0 = 1
 1 = 2,4
 2 = 4,8
 3 = 8,12
 4 = 12,16
 5 = 16,20

EXAMPLE CALL - EOS
 null = [["MARKERNAME","MARKERNAME2"],[2,1,70],[0,1],[1,2,30],[2,60],[2],[1,0,10],[1,0,250,WEST]] call EOS_Spawn;
 null=[["M1","M2","M3"],[HOUSE GROUPS,SIZE OF GROUPS,PROBABILITY],[PATROL GROUPS,SIZE OF GROUPS,PROBABILITY],[LIGHT VEHICLES,SIZE OF CARGO,PROBABILITY],[ARMOURED VEHICLES,PROBABILITY], [STATIC VEHICLES,PROBABILITY],[HELICOPTERS,SIZE OF HELICOPTER CARGO,PROBABILITY],[FACTION,MARKERTYPE,DISTANCE,SIDE,HEIGHTLIMIT,DEBUG]] call EOS_Spawn;

EXAMPLE CALL - BASTION
 null = [["BAS_zone_1"],[3,1],[2,1],[2],[0,0],[0,0,EAST,false,false],[10,2,120,TRUE,TRUE]] call Bastion_Spawn;
 null=[["M1","M2","M3"],[PATROL GROUPS,SIZE OF GROUPS],[LIGHT VEHICLES,SIZE OF CARGO],[ARMOURED VEHICLES],[HELICOPTERS,SIZE OF HELICOPTER CARGO],[FACTION,MARKERTYPE,SIDE,HEIGHTLIMIT,DEBUG],[INITIAL PAUSE, NUMBER OF WAVES, DELAY BETWEEN WAVES, INTEGRATE EOS, SHOW HINTS]] call Bastion_Spawn;
*/

VictoryColor="colorGreen";	// Colour of marker after completion
hostileColor="colorRed";	// Default colour when enemies active
bastionColor="colorOrange";	// Colour for bastion marker
EOS_DAMAGE_MULTIPLIER=1;	// 1 is default
EOS_KILLCOUNTER=false;		// Counts killed units


null = [["inf_1","inf_2","inf_3","inf_4","inf_5","inf_6","inf_7","inf_8","inf_9","inf_10","inf_11","inf_12","inf_13","inf_14","inf_15","inf_16","inf_17","inf_18","inf_19","inf_20","inf_21","inf_22","inf_23","inf_24","inf_25","inf_26","inf_27","inf_28","inf_29","inf_30"],[1,4],[5,2],[2,0,50],[0],[5],[0,0],[7,1,1000,EAST,TRUE]] call EOS_Spawn;


