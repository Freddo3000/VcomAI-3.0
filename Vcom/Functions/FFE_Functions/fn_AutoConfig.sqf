params ["_allArty"];
	
{
	private _vh = _x;
	
	if !(_vh getVariable ["RydFFE_CheckedOut",false]) then
	{
		_vh setVariable ["RydFFE_CheckedOut",true];
		private _typeVh = toLower (typeOf _vh);
		
		if (_allArty findIf {_typeVh in (_x select 0)} != -1) then	
		{
			private _mags = getArtilleryAmmo [_vh];
			
			if ((count _mags) > 0) then 
			{
				private _prim = "";
				private _rare = "";
				private _sec = "";
				private _smoke = "";
				private _illum = "";
				
				private _maxHit = 10;
				
				{
					private _ammo = getText (configfile >> "CfgMagazines" >> _x >> "ammo");
					private _ammoC = configfile >> "CfgAmmo" >> _ammo;
					
					private _actHit = getNumber (_ammoC >> "indirectHitRange");
					private _subM = toLower (getText (_ammoC >> "submunitionAmmo"));
					
					if (_actHit <= 10) then
					{
						if !(_subM isEqualTo "") then
						{
							_ammoC = configfile >> "CfgAmmo" >> _subM;
							_actHit = getNumber (_ammoC >> "indirectHitRange")
						}
					};
					
					if ((_actHit > _maxHit) && {_actHit < 100}) then
					{
						_maxHit = _actHit;
						_prim = _x
					}
				}
				foreach _mags;
				
				_mags = _mags - [_prim];
				private _mags0 = +_mags;
				private _illumChosen = false;
				private _smokeChosen = false;
				private _rareChosen = false;
				private _secChosen = false;
				
				{
					_ammo = getText (configfile >> "CfgMagazines" >> _x >> "ammo");
					_ammoC = configfile >> "CfgAmmo" >> _ammo;
					
					private _hit = getNumber (_ammoC >> "indirectHit");
					private _lc = _ammoC >> "lightColor";
					private _sim = toLower (getText (_ammoC >> "simulation"));
					private _subM = toLower (getText (_ammoC >> "submunitionAmmo"));
					
					if (_hit <= 10) then
					{
						if !(_subM isEqualTo "") then
						{
							_ammoC = configfile >> "CfgAmmo" >> _subM;
							_hit = getNumber (_ammoC >> "indirectHit")
						}
					};

					switch (true) do
					{
						case ((isArray _lc) && {!_illumChosen}) : 
						{
							_illum = _x;
							_mags = _mags - [_x];
							_illumChosen = true
						};
					
					case ((_hit <= 10) && {(_subM isEqualTo "smokeshellarty") && {!_smokeChosen}}) : 
						{
							_smoke = _x;
							_mags = _mags - [_x];
							_smokeChosen = true
						};
					
					case ((_sim isEqualTo "shotsubmunitions") && {!_rareChosen}) : 
						{
							_rare = _x;
							_mags = _mags - [_x];
							_rareChosen = true
						};
					
					case ((_hit > 10) && {!((_secChosen) or {(_rare == _x)})})  : 
						{
							_sec = _x;
							_mags = _mags - [_x];
							_secChosen = true
						}
					}
				}
				foreach _mags0;
				
				if (_sec isEqualTo "") then
				{
					_maxHit = 10;
					
					{
						_ammo = getText (configfile >> "CfgMagazines" >> _x >> "ammo");
						_ammoC = configfile >> "CfgAmmo" >> _ammo;
						_subAmmoC = _ammoC >> "subMunitionAmmo";
						
						
						if ((isText _subAmmoC) and {not ((getArray _subAmmoC) isEqualTo [])}) then
						{
							private _submunition = (getArray _subAmmoC) select 0;
							_ammoC = configfile >> "CfgAmmo" >> _submunition;
						};
					
						_actHit = getNumber (_ammoC >> "indirectHit");
					
						if (_actHit > _maxHit) then
						{
							_maxHit = _actHit;
							_sec = _x
						}
					}
					foreach _mags;
				};
				
				private _arr = [_prim,_rare,_sec,_smoke,_illum];
				
				if (({_x isEqualTo ""} count _arr) < 5) then
				{
					_allArty pushBack [[_typeVh],_arr]
				}
			}
		}
	}
} foreach vehicles;

RydFFE_AllArty = _allArty;

_allArty