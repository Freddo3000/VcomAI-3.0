params ["_arty", "_amount"];

_amount = ceil _amount;
//if (_amount < 2) exitWith {};

{		
	{
		private _vh = vehicle _x;
		private _handled = _vh getVariable ["RydFFEArtyAmmoHandled",false];
		
		if not (_handled) then
		{
			_vh setVariable ["RydFFEArtyAmmoHandled",true];
			
			_vh addEventHandler ["Fired",
				{
					(_this select 0) setVariable ["RydFFE_ShotFired",true];
					(_this select 0) setVariable ["RydFFE_ShotFired2",((_this select 0) getVariable ["RydFFE_ShotFired2",0]) + 1];
				
					//if ((RydFFE_SVStart) and (RydFFE_Debug)) then
					//{
					_shells = missionNameSpace getVariable ["RydFFE_FiredShells",[]];
					_shells set [(count _shells),(_this select 6)];
					missionNameSpace setVariable ["RydFFE_FiredShells",_shells];
					//}
				}];
			
			private _magTypes = getArtilleryAmmo [_vh];
			private _mags = magazines _vh;
			
			{
				private _tp = _x;
				private _cnt = {_x in [_tp]} count _mags;
				_vh addMagazines [_tp, _cnt * (_amount - 1)];
			}
			foreach _magTypes
		}
	}
	foreach (units _x)
}
foreach _arty;