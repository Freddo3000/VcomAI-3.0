//[_battery,_tgt,_batlead,"SADARM",RydFFE_Friends,RydFFE_Debug] spawn RYD_fnc_CFF_FFE
params ["_battery", "_target", "_batlead", "_Ammo", "_friends", "_Debug", "_ammoG", "_amount"];

private _myFO = _target getVariable ["RydFFE_MyFO",objNull];
private _assumedPos = (getPosATL _target);
if (!isNull _myFO) then
{
	_assumedPos = _myFO getHideFrom _target;
};
		
private _markers = [];
	
private _battery1 = _battery select 0;

private _batLead1 = leader _battery1;

private _batname = str _battery1;

//private _first = _battery getVariable [("FIRST" + _batname),1];

//private _artyGp = group _batlead;

private _isTaken = (group _target) getVariable ["CFF_Taken",false];
if ((_isTaken) && (RydFFE_Monogamy)) exitWith 
{
	{
		if (!isNull _x) then
		{
			_x setVariable ["RydFFE_BatteryBusy",false]
		}
	}
	foreach _battery
};

(group _target) setVariable ["CFF_Taken",true];

private _phaseF = [1,2];
if ((RydFFE_OnePhase) || ((count RydFFE_FO) isEqualTo 0) && !RydFFE_2PhWithoutFO) then {_phaseF = [1]};

private _targlead = vehicle (leader _target);

private _waitFor = true;
	
private _amount1 = ceil (_amount/6);
private _amount2 = _amount - _amount1;

{
	if (
		isNil "_myFO" ||
		{isNull _myFO} ||
		{!alive _myFO} ||
		{isNil "_target"} ||
		{isNull _target} ||
		{!alive _target} ||
		{(_batlead findIf {!isNull _x}) isEqualTo -1} ||
		{isNull _battery1} ||
		{(_batlead findIf {alive _x}) isEqualTo -1} ||
		{(abs (speed _target)) > 50} ||
		{(_assumedPos select 2) > 20}
	) exitWith {_waitFor = false};
	
	private _againF = 0.85;

	private _againcheck = _battery1 getVariable [("CFF_Trg" + _batname),objNull];
	if !((str _againcheck) isEqualTo (str _target)) then {_againF = 1};

	private _RydAccF = 1;

	//if (isNil ("RydFFE_Amount")) then {_amount = _this select 7} else {_amount = RydFFE_Amount};

	//if (_ammoG in ["SPECIAL","SECONDARY"]) then {_amount = ceil (_amount/3)};

	if ((count _phaseF) isEqualTo 2) then
	{
		if (_x isEqualTo 1) then
		{
			_amount = _amount1
		}
		else
		{
			_amount = _amount2
		}
	};

	if (_amount isEqualTo 0) exitwith {_waitFor = false};

	if (!isNull _myFO) then
	{
		_assumedPos = _myFO getHideFrom _target;
	};
	
	if (_assumedPos isEqualTo [0,0,0]) exitWith {_waitFor = false};

	private _targetPosATL = _assumedPos;
	private _targetPos = ATLtoASL _assumedPos;
	
	private _eta = -1;
	
	{
		{
			_vh = vehicle _x;
			_vhMags = magazines _vh; 
			if (!(_vh isEqualTo _x) && {(count _vhMags) > 0}) then
			{
				_ammoC = _vhMags select 0;
				
				{
					if (_x in _ammo) exitWith
					{
						_ammoC = _x
					}
				}
				foreach _vhMags;
				
				_newEta = _vh getArtilleryETA [_targetPosATL,_ammoC];
				
				if (!isNil "_newEta" && {((_newEta < _eta) || (_eta < 0))}) then
				{
					_eta = _newEta
				}
			}
		}
		foreach (units _x)
	}
	foreach _battery;
		
	if (_eta isEqualTo -1) exitWith {_waitFor = false};

	private _X0 = (_targetpos select 0);
	private _Y0 = (_targetpos select 1);
	
	sleep 10;
	
	if (
		isNil "_myFO" ||
		{isNull _myFO} ||
		{!alive _myFO} ||
		{isNull _target} ||
		{!alive _target} ||
		{(_batlead findIf {!isNull _x}) isEqualTo -1} ||
		{isNull _battery1} ||
		{(_batlead findIf {alive _x}) isEqualTo -1} ||
		{(abs (speed _target)) > 50} ||
		{(_assumedPos select 2) > 20}
	) exitWith {_waitFor = false};

	if (!isNull _myFO) then
	{
		_assumedPos = _myFO getHideFrom _target;
	};
	
	if (_assumedPos isEqualTo [0,0,0]) exitWith {_waitFor = false};

	_targetPos = ATLtoASL _assumedPos;
	
	private _X1 = (_targetpos select 0);
	private _Y1 = (_targetpos select 1);
	
	sleep 10;
	
	if (
		isNil "_myFO" ||
		{isNull _myFO} ||
		{!alive _myFO} ||
		{isNull _target} ||
		{!alive _target} ||
		{(_batlead findIf {!isNull _x}) isEqualTo -1} ||
		{isNull _battery1} ||
		{(_batlead findIf {alive _x}) isEqualTo -1} ||
		{(abs (speed _target)) > 50} ||
		{(_assumedPos select 2) > 20}
	) exitWith {_waitFor = false};

	if (!isNull _myFO) then
	{
		_assumedPos = _myFO getHideFrom _target;
	};
	
	if (_assumedPos isEqualTo [0,0,0]) exitWith {_waitFor = false};

	_targetPos = ATLtoASL _assumedPos;
		
	private _X2 = (_targetpos select 0);
	private _Y2 = (_targetpos select 1);

	private _onRoad = isOnRoad _targlead;

	private _Xav = (_X1+_X2)/2;
	private _Yav = (_Y1+_Y2)/2;

	private _transspeed = ([_X0,_Y0] distance [_Xav,_Yav])/15;
	private _transdir = (_Xav - _X0) atan2 (_Yav - _Y0);
		
	private _add = 16/(1 + (_transspeed));

	private _Xhd = _transspeed * (sin _transdir) * (_eta + _add);
	private _Yhd = _transspeed * (cos _transdir) * (_eta + _add);
	private _impactpos = _targetpos;
	private _safebase = 100;

	private _exPX = (_targetPos select 0) + _Xhd;
	private _exPY = (_targetPos select 1) + _Yhd;

	private _exPos = [_exPX,_exPY,getTerrainHeightASL [_exPX,_exPY]];
	_exTargetPosATL = ASLtoATL _exPos;
		
	_eta = -1;
		
	{
		{
			_vh = vehicle _x;
			_vhMags = magazines _vh; 
			if (!(_vh isEqualTo _x) && {(count _vhMags) > 0}) then
			{
				private _ammoC = _vhMags select 0;
				
				{
					if (_x in _ammo) exitWith
					{
						_ammoC = _x
					}
				}
				foreach _vhMags;
				
				_newEta = _vh getArtilleryETA [_exTargetPosATL,_ammoC];
				
				if (!isNil "_newEta" && {((_newEta < _eta) || (_eta < 0))}) then
				{
					_eta = _newEta
				}
			}
		}
		foreach (units _x)
	}
	foreach _battery;
	
	if (_eta == -1) exitWith {_waitFor = false};
	
	_Xhd = _transspeed * (sin _transdir) * (_eta + _add);
	_Yhd = _transspeed * (cos _transdir) * (_eta + _add);

	_exPX = (_targetPos select 0) + _Xhd;
	_exPY = (_targetPos select 1) + _Yhd;

	_exPos = [_exPX,_exPY,getTerrainHeightASL [_exPX,_exPY]];

	private _exDst = _targetPos distance _exPos;

	if (isNil ("RydFFE_Safe")) then {_safebase = 100} else {_safebase = RydFFE_Safe};

	private _safe = _safebase * _RydAccf * (1 + overcast);

	private _safecheck = true;

	if !_onRoad then
	{
		{
			if (([(_impactpos select 0) + _Xhd, (_impactpos select 1) + _Yhd] distance (vehicle (leader _x))) < _safe) exitwith 
			{
				_Xhd = _Xhd/2;
				_Yhd = _Yhd/2
			}
		}
		foreach _friends;
		
		{
			if ([(_impactpos select 0) + _Xhd, (_impactpos select 1) + _Yhd] distance (vehicle (leader _x)) < _safe) exitwith {_safecheck = false};
		}
		foreach _friends;

		if !_safecheck then 
		{
			_Xhd = _Xhd/2;
			_Yhd = _Yhd/2;
			_safecheck = true;
			{
				if ([(_impactpos select 0) + _Xhd, (_impactpos select 1) + _Yhd] distance (vehicle (leader _x)) < _safe) exitwith {_safecheck = false};
			}
			foreach _friends;
			if !_safecheck then 
			{
				_Xhd = _Xhd/5;
				_Yhd = _Yhd/5;
				_safecheck = true;
				{
					if ([(_impactpos select 0) + _Xhd, (_impactpos select 1) + _Yhd] distance (vehicle (leader _x)) < _safe) exitwith {_safecheck = false};
				}
				foreach _friends
			}
		};

		_impactpos = [(_targetpos select 0) + _Xhd, (_targetpos select 1) + _Yhd];
	}
	else
	{
		private _nR = _targlead nearRoads 30;

		private _stRS = _nR select 0;
		private _dMin = _stRS distance _exPos;

		{
			private _dAct = _x distance _exPos;
			if (_dAct < _dMin) then {_dMin = _dAct;_stRS = _x}
		}
		foreach _nR;

		private _dSum = _assumedPos distance _stRS;
		private _checkedRS = [_stRS];
		private _actRS = _stRS;

		while {_dSum < _exDst} do
		{
			private _RSArr = (roadsConnectedTo _actRS) - _checkedRS;
			if ((count _RSArr) == 0) exitWith {};
			_stRS = _RSArr select 0;
			_dMin = _stRS distance _exPos;

			{
				private _dAct = _x distance _exPos;
				if (_dAct < _dMin) then {_dMin = _dAct;_stRS = _x}
			}
			foreach _RSArr;

			_dSum = _dSum + (_stRS distance _actRS);

			_actRS = _stRS;

			_checkedRS set [(count _checkedRS),_stRS];
		};

		if (_dSum < _exDst) then
		{
			//if (_transdir < 0) then {_transdir = _transdir + 360};
			private _angle = [_targetPos,(getPosASL _stRS),1] call RYD_fnc_AngTowards;
			_impactPos = [(getPosASL _stRS),_angle,(_exDst - _dSum)] call RYD_fnc_PosTowards2D
		}
		else
		{
			private _rPos = getPosASL _stRS;
			_impactPos = [_rPos select 0,_rPos select 1]
		};
			
		{
			if ((_impactpos distance (vehicle (leader _x))) < _safe) exitwith 
			{
				_safeCheck = false;
				_impactpos = [((_impactpos select 0) + (_targetPos select 0))/2,((_impactpos select 1) + (_targetPos select 1))/2]
			}
		}
	foreach _friends
	};

	if !_safeCheck then
	{
		_safeCheck = true;

		{
			if ((_impactpos distance (vehicle (leader _x))) < _safe) exitwith 
			{
				_safeCheck = false
			}
		}
	foreach _friends
	};

	if !(_safecheck) exitwith {(group _target) setVariable ["CFF_Taken",false];_waitFor = false};

	private _distance2 = _impactPos distance (getPosATL (vehicle _batlead1));
	private _DweatherF = 1 + overcast;
	private _gauss09 = (random 0.09) + (random 0.09) + (random 0.09) + (random 0.09) + (random 0.09) + (random 0.09) + (random 0.09) + (random 0.09) +  (random 0.09) + (random 0.09);

	//private _gauss1 = (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) +  (random 0.1) + (random 0.1);
	//private _gauss04 = (random 0.04) + (random 0.04) + (random 0.04) + (random 0.04) + (random 0.04) + (random 0.04) + (random 0.04) + (random 0.04) +  (random 0.04) + (random 0.04);
	//private _gauss2 = (random 0.2) + (random 0.2) + (random 0.2) + (random 0.2) + (random 0.2) + (random 0.2) + (random 0.2) + (random 0.2) +  (random 0.2) + (random 0.2);
	//private _DdistF = (_distance2/10) * (0.1 + _gauss04);
	//private _DdamageF = 1 + 0.5 * (damage _batlead1);
	//private _DskillF = 2 * (skill _batlead1);
	//private _anotherD = 1 + _gauss1;
	//private _Dreduct = (1 + _gauss2) + _DskillF;
		 
	//private _spawndisp = _dispF * ((_RydAccf * _DdistF * _DdamageF) + (50 * _DweatherF * _anotherD)) / _Dreduct;
	//private _dispersion = 10000 * (_spawndisp atan2 _distance2) / 57.3;

	//private _disp = _dispersion;
	//if (isNil ("RydFFE_SpawnM")) then {_disp = _dispersion} else {_disp = _spawndisp};

	//[_battery,_disp] call BIS_ARTY_F_SetDispersion;
		
	_RydAccF = 1;

	private _gauss1b = (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) +  (random 0.1) + (random 0.1);
	private _gauss2b = (random 0.2) + (random 0.2) + (random 0.2) + (random 0.2) + (random 0.2) + (random 0.2) + (random 0.2) + (random 0.2) +  (random 0.2) + (random 0.2);
	private _AdistF = (_distance2/10) * (0.1 + _gauss09);
	private _AweatherF = _DweatherF;
	private _AdamageF = 1 + 0.1 * (damage (vehicle _batlead1));
	private _AskillF = 5 * (_batlead1 skill "aimingAccuracy");
	private _Areduct = (1 + _gauss2b) + _AskillF;
	private _spotterF = 0.2 + (random 0.2);
	private _anotherA = 1 + _gauss1b;
	if (!isNil ("RydFFE_FOAccGain")) then {_spotterF = RydFFE_FOAccGain + (random 0.2)};
	if (((count _phaseF) isEqualTo 2) && (_x isEqualTo 1) || ((count _phaseF) isEqualTo 1)) then {_spotterF = 1};

	private _acc = _spotterF * _againF * RydFFE_Acc * ((_AdistF * _AdamageF) + (50 * _AweatherF * _anotherA)) / _Areduct;

	private _finalimpact = [(_impactpos select 0) + (random (2 * _acc)) - _acc,(_impactpos select 1) + (random (2 * _acc)) - _acc];

	if !isNull _myFO then
	{
		_assumedPos = _myFO getHideFrom _target;
	};

	if (
		isNull _target ||
		{!alive _target} ||
		{_batlead findIf {!isNull _x} isEqualTo -1} ||
		{_batlead findIf {alive _x} isEqualTo -1} ||
		{isNull _battery1} ||
		{(abs (speed _target)) > 50} ||
		{(_assumedPos select 2) > 20}
	) exitwith {_waitFor = false};

	//private _dstAct = _impactpos vectorDistance _batlead;
		
	{
		if (!isNull _x) then
		{
			{
				(vehicle _x) setVariable ["RydFFE_ShotFired",false]
			}
			foreach (units _x)
		};
	}
	foreach _battery;

	sleep 0.2;
	private _posX = 0;
	private _posY = 0;
	
	private _distance = _impactPos distance _finalimpact;
	
	(_battery select 0) setVariable ["RydFFE_Break",false];
	
	if (_Debug) then 
	{
		_posM1 = getposATL (vehicle _batlead1);
		_posM1 set [2,0];
		_impactPosM = +_impactPos;
		_impactPosM set [2,0];
		_finalimpactM = +_finalimpact;
		_finalimpactM set [2,0];
		
		_text = getText (configFile >> "CfgVehicles" >> (typeOf (vehicle _batlead1)) >> "displayName");
		private _i = "markBat" + str (_battery1);
		_i = createMarker [_i,_posM1];
		_i setMarkerColor "ColorBlack";
		_i setMarkerShape "ICON";
		_i setMarkerType "mil_circle";
		_i setMarkerSize [0.4,0.4];
		_i setMarkerText ("Firing battery - " + _text);
		
		_markers pushBack _i;
		
		_distance = _impactPosM vectorDistance _finalimpactM;
		_distance2 = _impactPosM vectorDistance _posM1;
		_i = "mark0" + str (_battery1);
		_i = createMarker [_i,_impactPos];
		_i setMarkerColor "ColorBlue";
		_i setMarkerShape "ELLIPSE";
		_i setMarkerSize [_distance, _distance];
		_i setMarkerBrush "Border";
		
		_markers pushBack _i;

		private _dX = (_impactPosM select 0) - (_posM1 select 0);
		private _dY = (_impactPosM select 1) - (_posM1 select 1);
		private _angle = _dX atan2 _dY;
		if (_angle >= 180) then {_angle = _angle - 180};
		private _dXb = (_distance2/2) * (sin _angle);
		private _dYb = (_distance2/2) * (cos _angle);
		_posX = (_posM1 select 0) + _dXb;
		_posY = (_posM1 select 1) + _dYb;

		_i = "mark1" + str (_battery1);
		_i = createMarker [_i,[_posX,_posY]];
		_i setMarkerColor "ColorBlack";
		_i setMarkerShape "RECTANGLE";
		_i setMarkerSize [0.5,_distance2/2];
		_i setMarkerBrush "Solid";
		_i setMarkerdir _angle;
		
		_markers pushBack _i;

		_dX = (_finalimpactM select 0) - (_impactPosM select 0);
		_dY = (_finalimpactM select 1) - (_impactPosM select 1);
		_angle = _dX atan2 _dY;
		if (_angle >= 180) then {_angle = _angle - 180};
		_dXb = (_distance/2) * (sin _angle);
		_dYb = (_distance/2) * (cos _angle);
		private _posX2 = (_impactPosM select 0) + _dXb;
		private _posY2 = (_impactPosM select 1) + _dYb;

		_i = "mark2" + str (_battery1);
		_i = createMarker [_i,[_posX2,_posY2]];
		_i setMarkerColor "ColorBlack";
		_i setMarkerShape "RECTANGLE";
		_i setMarkerSize [0.5,_distance/2];
		_i setMarkerBrush "Solid";
		_i setMarkerdir _angle;
		
		_markers pushBack _i;

		_i = "mark3" + str (_battery1);
		_i = createMarker [_i,_impactPosM];
		_i setMarkerColor "ColorBlack";
		_i setMarkerShape "ICON";
		_i setMarkerType "mil_dot";
		
		_markers pushBack _i;

		_i = "mark4" + str (_battery1);
		_i = createMarker [_i,_finalimpactM];
		_i setMarkerColor "ColorRed";
		_i setMarkerShape "ICON";
		_i setMarkerType "mil_dot";
		_i setMarkerText (str (round _distance) + "m" + " - ETA: " + str (round _eta) + " - " + _ammoG);
			
		_markers pushBack _i;
			
		/*_i = "mark5" + str (_battery);
		_i = createMarker [_i,_finalimpactM];
		_i setMarkerColor "ColorRedAlpha";
		_i setMarkerShape "ELLIPSE";
		_i setMarkerSize [_spawndisp,_spawndisp];*/
	};
	
	[_battery,_distance,_eta,_ammoG,_batlead,_target,_markers] spawn
	{
		params ["_battery", "_distance", "_eta", "_ammoG", "_batlead", "_target", "_markers"];
		
		_battery1 = _battery select 0;

		private _alive = true;
		private _shot = false;

		waitUntil 
		{
			sleep 0.1;
			if (
				{!isNull _x} count _batlead < 1 ||
				{isNull _battery1} ||
				{({alive _x} count _batlead) < 1}	||
				{_battery1 getVariable ["RydFFE_Break",false]}
			) then {_alive = false};
				
			{
				if (!isNull _x) then
				{
					{
						if ((vehicle _x) getVariable ["RydFFE_ShotFired",false]) exitWith {_shot = true}
					}
					foreach (units _x)
				};
					
				if (_shot) exitWith {}
			}
			foreach _battery;
			
			(_shot || !_alive)
		};
		
		{
			if (!isNull _x) then
			{
				{
					(vehicle _x) setVariable ["RydFFE_ShotFired",false]
				}
				foreach (units _x)
			};
		}
		foreach _battery;

		private _stoper = time;
		private _TOF = 0;
		private _rEta = _eta;
		private _mark = "";
			
		if ((count _markers) > 0) then
		{
			_mark = _markers select ((count _markers) -1);
		};

		while {_rEta >= 5 && _TOF <= 200 && _alive} do
		{
			if 
			(
				(_batlead findIf {!isNull _x}) isEqualTo -1 ||
				{isNull _battery1} ||
				{(_batlead findIf {alive _x}) isEqualTo -1} ||
				{_battery1 getVariable ["RydFFE_Break",false]}
			) exitWith {_alive = false};

				_TOF = (round (10 * (time - _stoper)))/10;
				_rEta = _eta - _TOF;
				
				if ((count _markers) > 0) then
				{
					_mark setMarkerText (str (round _distance) + "m" + " - ETA: " + str (round _rEta) + " - TOF: " + (str _TOF) + " - " + _ammoG);
				};
				
				sleep 0.1
			};

			if !_alive exitWith 
			{
				(group _target) setvariable ["CFF_Taken",false];
				
				{
				deleteMarker _x;
				}
				foreach _markers;
			};
				
			_battery1 setVariable ["RydFFE_SPLASH",true];

			if ((count _markers) > 0) then
				{
				_mark setMarkerText (str (round _distance) + "m"  + " - SPLASH!" + " - " + _ammoG);
				};
			};

		_eta = [_battery,_finalimpact,_ammo,_amount] call RYD_fnc_CFF_Fire;

		_alive = (_eta > 0);
		
		if !_alive then {(_battery select 0) setVariable ["RydFFE_Break",true]};

		waituntil 
		{
			sleep 1;

			_available = true;
			if (
				(_batlead findIf {!isNull _x}) isEqualTo -1 ||
				{isNull _battery1} ||
				{(_batlead findIf {alive _x}) isEqualTo -1}
			) then {_alive = false};
						
			{
				if (!isNull _x) then
				{
					{
						if !((vehicle _x) getVariable ["RydFFE_GunFree",true]) exitWith {_available = false}
					}
					foreach (units _x)
				};
				
				if !_available exitWith {}
			}
			foreach _battery;
			
			(_available || !_alive)
		};

		if !_alive exitWith {_waitFor = false};

		if (((count _phaseF) isEqualTo 2) && (_x isEqualTo 1)) then 
		{
			_alive = true;
			_splash = false;

			waitUntil 
			{
				sleep 1;

				if 
				(
					(_batlead findIf {!isNull _x}) isEqualTo -1 ||
					{isNull _battery1} ||
					{(_batlead findIf {alive _x}) isEqualTo -1}
				) then {_alive = false};
				if (!isNull _battery1) then {_splash = _battery1 getVariable ["RydFFE_SPLASH",false]};
				
				(_splash || !_alive)
			};
				
			if (!isNull _battery1) then {_battery1 setVariable ["RydFFE_SPLASH",false]};

			sleep 10;
			
			{
				deleteMarker _x;
			}
			foreach _markers
		};

	if !_alive exitWith {_waitFor = false};
}
foreach _phaseF;

_battery1 setVariable [("CFF_Trg" + _batname),_target];

_alive = true;
_splash = false;

if (_waitFor) then
{
	waitUntil 
	{
		sleep 1;

		if 
		(
			(_batlead findIf {!isNull _x}) isEqualTo -1 ||
			{isNull _battery1} ||
			{(_batlead findIf {alive _x}) isEqualTo -1}
		) then {_alive = false};
		
		if (!isNull _battery1) then {_splash = _battery1 getVariable ["RydFFE_SPLASH",false]};
			
		(_splash || !_alive)
	};
				
	if (!isNull _battery1) then {_battery1 setVariable ["RydFFE_SPLASH",false]};

	sleep 10
};

{
	deleteMarker _x;
}
foreach _markers;

(group _target) setVariable ["CFF_Taken",false];
	
_alive = true;

waitUntil 
{
	sleep 1;

	_available = true;
	//if (isNull _battery1) then {_alive = false};
	if ((_batlead findIf {!isNull _x}) isEqualTo -1 || {(_batlead findIf {alive _x}) isEqualTo -1}) then {_alive = false};
					
	{
		if (!isNull _x) then
		{
			{
				if !((vehicle _x) getVariable ["RydFFE_GunFree",true]) exitWith {_available = false}
			}
			foreach (units _x)
		};
	
		if !_available exitWith {}
	}
	foreach _battery;
		
	(_available || !_alive)
};

//if !_alive exitWith {};

{
	if (!isNull _x) then
	{
		_x setVariable ["RydFFE_BatteryBusy",false]
	}
} foreach _battery