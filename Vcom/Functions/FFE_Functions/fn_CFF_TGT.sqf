//_tgt = [RydFFE_KnEnemies] call RYD_fnc_CFF_TGT;
params ["_enemies"];

private _targets = [];
private _target = objNull;
private _temptation = 0;
private _nothing = 0;

{
	private _potential = _x;
	
	private _potL = vehicle (leader _potential);
	private _taken = (group _potential) getVariable ["CFF_Taken",false];

	if 
	(
		!isNull _potential && 
		{alive _potential} && 
		{!_taken} && 
		{((getposATL _potL) select 2) < 20} &&
		{(abs(speed _potL)) < 50} &&
		{(count (weapons (leader _potential))) > 0} &&
		{!((leader _potential) isKindOf "civilian")} &&
		{!captive _potL} &&
		{!(_potential in _targets)} &&
		{!(_potential in _targets)} &&
		{(damage _potL) < 0.9}
	)
	then
	{
		_targets set [(count _targets),_potential];
	}
}
foreach _enemies;

{
	private _candidate = _x;
	private _CL = leader _candidate;

	_temptation = 0;
	private _vehFactor = 0;
	private _artFactor = 1;
	private _crowdFactor = 1;
	private _HQFactor = 1;
	private _veh = ObjNull;

	if !(isNull (assignedVehicle _CL)) then {_veh = assignedVehicle _CL};
	if !((vehicle _CL) isEqualTo _CL) then 
	{
		_veh = vehicle _CL;
		if (RydFFE_AllArty findIf {_typeVh in (_x select 0)} != -1) then {_artFactor = 10} else {_vehFactor = 500 + (rating _veh)};
	};

	private _nearImp = (getPosATL _CL) nearEntities [["CAManBase","AllVehicles","Strategic","WarfareBBaseStructure","Fortress"],100];
	private _nearCiv = false;

	{
		if (_x isKindOf "civilian") exitWith {_nearCiv = true};
		if (((side _x) getFriend (side _CL)) >= 0.6) then 
		{
			private _vh = vehicle _x;
			_crowdFactor = _crowdFactor + 0.2;
			if !(_x isEqualTo _vh) then 
			{
				_crowdFactor = _crowdFactor + 0.2;
				if (RydFFE_AllArty findIf {_typeVh in (_x select 0)} != -1) then 
				{
					_crowdFactor = _crowdFactor + 0.2
				}
			}
		};
	}
	foreach _nearImp;
		
	if (_nearCiv) then 
	{
		_targets set [_foreachIndex,0]
	}
	else
	{

		{
			_temptation = _temptation + (250 + (rating _x));
		}
		foreach (units _candidate);

		_temptation = (((_temptation + _vehFactor)*10)/(5 + (speed _CL))) * _artFactor * _crowdFactor * _HQFactor;
		_candidate setVariable ["CFF_Temptation",_temptation]
	}
}
foreach _targets;
	
_targets = _targets - [0];

private _ValMax = 0;

{
	private _trgValS = _x getVariable ["CFF_Temptation",0];
	if ((_ValMax < _trgValS) && (random 100 < 85)) then {_ValMax = _trgValS;_target = _x};
}
foreach _targets;

if (isNull _target) then 
{
	if !((count _targets) isEqualTo 0) then 
	{
		_target = _targets select (floor (random (count _targets)))
	} 
	else 
	{
		_nothing = 1
	};
};

_target