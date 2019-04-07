params ["_center", "_radius"];
	
private _pos1 = [_center select 0,_center select 1,0];

private _shells = missionNameSpace getVariable ["RydFFE_FiredShells",[]];

private _inRange = [];

{
	private _shell = _x;
	if (!isNil "_shell" || {not (isNull _x)}) then
	{
		private _pos2 = getPosASL _x;
		_pos2 = [_pos2 select 0,_pos2 select 1,0];
		
		if ((_pos1 distance _pos2) < _radius) then
		{
			_inRange set [(count _inRange),_x]
		}
	}
} foreach _shells;

_inRange