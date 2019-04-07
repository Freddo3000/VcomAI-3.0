
sleep 5;

missionNameSpace setVariable ["RydFFE_FiredShells",[]];

private _allArty = RydFFE_SPMortar + RydFFE_Mortar + RydFFE_Rocket + RydFFE_Other;

_allArty = [_allArty] call RYD_fnc_AutoConfig;

private _civF = [];
{
	if (getNumber (_x >> "side") isEqualTo 3) then
	{
		_civF pushBack (configName _x);
	};
} foreach ("true" configClasses (configfile >> "CfgFactionClasses"));
private _sides = [west,east,resistance];

private _enemies = [];
private _friends = [];
RydFFE_Fire = false;

if (isNil ("RydFFE_SVRange")) then {RydFFE_SVRange = 3000};

if (RydFFE_ShellView) then {[] spawn RYD_fnc_Shellview};

while {true} do
{
	waitUntil {RydFFE_Active};
	if (RydFFE_Manual) then {waitUntil {sleep 0.1;((RydFFE_Fire) || !(RydFFE_Manual))};RydFFE_Fire = false};

	{
		private _side = _x;

		private _eSides = [sideEnemy];
		private _fSides = [sideFriendly];

		{
			_getF = _side getFriend _x;
			if (_getF >= 0.6) then
			{
				_fSides set [(count _fSides),_x]
			}
			else
			{
				_eSides set [(count _eSides),_x]
			};
		} foreach _sides;

		if (({((side _x) == _side)} count AllGroups) > 0) then
		{
			
			private _artyGroups = [];
			_enemies = [];
			_friends = [];

			{
				
				private _gp = _x;

				if ((side _gp) == _side && {!(_gp in RydFFE_NoControl)}) then
				{
					
					{
						private _veh = vehicle _x;
						if (
							_allArty findIf {((toLower typeOf _veh) in (_x select 0))} != -1 &&
							{!(_gp in _artyGroups)}
						) 
						exitWith
						{
							_artyGroups pushBackUnique _gp
						}
						
					} foreach (units _gp)
					
				};

				private _isCiv = false;
				if ((toLower (faction (leader _gp))) in _civF) then {_isCiv = true};

				if (!_isCiv && {!(isNull _gp)} && {(alive (leader _gp))}) then
				{
					
					if ((side _gp) in _eSides && {!(_gp in _enemies)}) then
					{
						_enemies pushBack _gp;
					}
					else
					{
						if ((side _gp) in _fSides && {!(_gp in _friends)}) then
						{
							_friends pushBack _gp;
							if ((toLower (typeOf (leader _x))) in RydFFE_FOClass && {(count RydFFE_FO) > 0} && {!(_gp in RydFFE_FO)}) then
							{
								RydFFE_FO pushBack _gp;
							}
							
						}
						
					}
				
				}
				
			} foreach allGroups;

			private _knEnemies = [];

			{
				
				{
					
					private _eVeh = vehicle _x;

					{
						if 
						(
							!((toLower (faction (leader _x))) in _civF) && 
							{(count RydFFE_FO) == 0 || (_x in RydFFE_FO)} &&
							{(_x knowsAbout _eVeh) >= 0.05} &&
							{!(_eVeh in _knEnemies)}
						) 
						then
						{
							_eVeh setVariable ["RydFFE_MyFO",(leader _x)];
							_knEnemies pushBack _eVeh;
						};
						
					} foreach _friends;
					
				} foreach (units _x);
				
			} foreach _enemies;

			private _enArmor = [];

			{
				if ((_x isKindOf "Tank") || {_x isKindOf "Wheeled_APC"}) then
				{
					if !(_x in _enArmor) then
					{
						_enArmor pushBack _x
					};
					
				};
				
			} foreach _knEnemies;

			[_artyGroups,RydFFE_ArtyShells] call RYD_fnc_ArtyPrep;

			[_artyGroups,_knEnemies,_enArmor,_friends,RydFFE_Debug,RydFFE_Amount] call RYD_fnc_CFF;
		}
	}
	foreach _sides;

	sleep RydFFE_Interval;

	private _shells = missionNameSpace getVariable ["RydFFE_FiredShells",[]];

	{
		_shell = _x;
		if (isNil "_shell") then
		{
			_shells set [_foreachIndex,0]
		}
		else
		{
			if (isNull _x) then
			{
				_shells set [_foreachIndex,0]
			};
		};
	} foreach _shells;

	_shells = _shells - [0];
	missionNameSpace setVariable ["RydFFE_FiredShells",_shells];
	
	_allArty = [_allArty] call RYD_fnc_AutoConfig;
	
};