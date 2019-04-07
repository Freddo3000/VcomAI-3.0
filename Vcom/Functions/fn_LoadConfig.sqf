params [["_preInit", ""]];
if (!isServer && _preInit isEqualTo "preInit") exitWith {};

VCM_ACTIVE = 		["CfgVcomSettings", "VcomActive"] call BIS_fnc_getCfgDataBool;
VCM_DEBUG = 		["CfgVcomSettings", "Debug"] call BIS_fnc_getCfgDataBool;
VCM_SIDES = 		["CfgVcomSettings", "EnabledSides"] call BIS_fnc_getCfgDataArray;
VCM_SUPPRESS = 	["CfgVcomSettings", "SuppressionActive"] call BIS_fnc_getCfgDataBool;
VCM_HEALING = 		["CfgVcomSettings", "HealingActive"] call BIS_fnc_getCfgDataBool;
VCM_WPGEN = 		["CfgVcomSettings", "WaypointGeneration"] call BIS_fnc_getCfgDataBool;
VCM_FRMCHNG = 		["CfgVcomSettings", "FormationChange"] call BIS_fnc_getCfgDataBool;
VCM_FULLSPEED = 	["CfgVcomSettings", "FullSpeed"] call BIS_fnc_getCfgDataBool;
VCM_MAGLIMIT = 	["CfgVcomSettings", "MagLimit"] call BIS_fnc_getCfgData;
VCM_MINECHNC = 	["CfgVcomSettings", "MineChance"] call BIS_fnc_getCfgData;
VCM_LGARR = 		["CfgVcomSettings", "LightGarrisonChance"] call BIS_fnc_getCfgData;
VCM_RGDL = 			["CfgVcomSettings", "RagdollChance"] call BIS_fnc_getCfgData;
VCM_STEAL = 		["CfgVcomSettings", "VehicleStealing"] call BIS_fnc_getCfgDataBool;
VCM_STEALDIST = 	["CfgVcomSettings", "StealingDistance"] call BIS_fnc_getCfgData;
VCM_STEALCLASS = 	["CfgVcomSettings", "VehicleStealClassnames"] call BIS_fnc_getCfgDataBool;
VCM_HEARDIST = 	["CfgVcomSettings", "HearingDistance"] call BIS_fnc_getCfgData;
VCM_WARNDIST = 	["CfgVcomSettings", "WarnDistance"] call BIS_fnc_getCfgData;
VCM_WARNDELAY = 	["CfgVcomSettings", "WarnDelay"] call BIS_fnc_getCfgData;
VCM_STATICARMT = 	["CfgVcomSettings", "StaticArmTime"] call BIS_fnc_getCfgData;

VCM_DRIVING = 		["CfgVcomSettings", "DrivingActivate"] call BIS_fnc_getCfgDataBool;
VCM_DLIMIT = 		["CfgVcomSettings", "DriverLimit"] call BIS_fnc_getCfgData ;  
VCM_DDELAY = 		((["CfgVcomSettings", "DrivingDelay"] call BIS_fnc_getCfgData) / 1000); //Variable is in milliseconds due to absence of decimals 
VCM_DDIST = 		["CfgVcomSettings", "DrivingDist"] call BIS_fnc_getCfgData; 
 
RydFFE_Active = 	["CfgVcomSettings", "FFESettings", "Active"] call BIS_fnc_getCfgDataBool; 
RydFFE_Manual = 	["CfgVcomSettings", "FFESettings", "Manual"] call BIS_fnc_getCfgDataBool; 
RydFFE_NoControl = []; 
{ 
	RydFFE_NoControl pushBack (missionNamespace getVariable _x); 
} forEach ["CfgVcomSettings", "FFESettings", "NoControl"] call BIS_fnc_getCfgDataArray; 
RydFFE_ArtyShells = ["CfgVcomSettings", "FFESettings", "ArtyShells"] call BIS_fnc_getCfgData; 
RydFFE_Interval = 	["CfgVcomSettings", "FFESettings", "Interval"] call BIS_fnc_getCfgData; 
RydFFE_Debug =		["CfgVcomSettings", "FFESettings", "Debug"] call BIS_fnc_getCfgDataBool; 
RydFFE_FO = []; 
{ 
	RydFFE_FO pushBack (missionNamespace getVariable _x); 
} forEach (["CfgVcomSettings", "FFESettings", "FO"] call BIS_fnc_getCfgDataArray); 
RydFFE_2PhWithoutFO = 	["CfgVcomSettings", "FFESettings", "2PhWithoutFO"] call BIS_fnc_getCfgDataBool; 
RydFFE_OnePhase = 	["CfgVcomSettings", "FFESettings", "OnePhase"] call BIS_fnc_getCfgDataBool; 
RydFFE_Amount = 	["CfgVcomSettings", "FFESettings", "Amount"] call BIS_fnc_getCfgData; 
RydFFE_Acc = 		["CfgVcomSettings", "FFESettings", "Acc"] call BIS_fnc_getCfgData; 
RydFFE_Safe = 		["CfgVcomSettings", "FFESettings", "Safe"] call BIS_fnc_getCfgData; 
RydFFE_Monogamy = 	["CfgVcomSettings", "FFESettings", "Monogamy"] call BIS_fnc_getCfgDataBool; 
RydFFE_ShellView = 	["CfgVcomSettings", "FFESettings", "ShellView"] call BIS_fnc_getCfgDataBool; 
RydFFE_SVRange = 	["CfgVcomSettings", "FFESettings", "ShellViewRange"] call BIS_fnc_getCfgData; 
RydFFE_FOAccGain = 	["CfgVcomSettings", "FFESettings", "FOAccGain"] call BIS_fnc_getCfgData; 
RydFFE_FOClass = 	["CfgVcomSettings", "FFESettings", "FOClass"] call BIS_fnc_getCfgDataArray; 
RydFFE_SPMortar = []; 
{ 
	private _variants = ["CfgVcomSettings", "FFESettings", "FFE_SPMortars", _x, "Variants"] call BIS_fnc_getCfgDataArray; 
	private _magazines = ["CfgVcomSettings", "FFESettings", "FFE_SPMortars", _x, "Magazines"] call BIS_fnc_getCfgDataArray; 
	RydFFE_SPMortar pushBack [_variants, _magazines]; 
} forEach (["CfgVcomSettings", "FFESettings", "FFE_SPMortars"] call BIS_fnc_getCfgSubClasses); 
RydFFE_Mortar = []; 
{ 
	private _variants = ["CfgVcomSettings", "FFESettings", "FFE_Mortars", _x, "Variants"] call BIS_fnc_getCfgDataArray; 
	private _magazines = ["CfgVcomSettings", "FFESettings", "FFE_Mortars", _x, "Magazines"] call BIS_fnc_getCfgDataArray; 
	RydFFE_Mortar pushBack [_variants, _magazines]; 
} forEach (["CfgVcomSettings", "FFESettings", "FFE_Mortars"] call BIS_fnc_getCfgSubClasses); 
RydFFE_Rocket = []; 
{ 
	private _variants = ["CfgVcomSettings", "FFESettings", "FFE_Rockets", _x, "Variants"] call BIS_fnc_getCfgDataArray; 
	private _magazines = ["CfgVcomSettings", "FFESettings", "FFE_Rockets", _x, "Magazines"] call BIS_fnc_getCfgDataArray; 
	RydFFE_Rocket pushBack [_variants, _magazines]; 
} forEach (["CfgVcomSettings", "FFESettings", "FFE_Rockets"] call BIS_fnc_getCfgSubClasses); 
RydFFE_Other = []; 
{ 
	private _variants = ["CfgVcomSettings", "FFESettings", "FFE_Other", _x, "Variants"] call BIS_fnc_getCfgDataArray; 
	private _magazines = ["CfgVcomSettings", "FFESettings", "FFE_Other", _x, "Magazines"] call BIS_fnc_getCfgDataArray; 
	RydFFE_Other pushBack [_variants, _magazines]; 
} forEach (["CfgVcomSettings", "FFESettings", "FFE_Other"] call BIS_fnc_getCfgSubClasses); 
RydFFE_IowaMode = ["CfgVcomSettings", "FFESettings", "IowaMode"] call BIS_fnc_getCfgDataBool; 


VCM_SKILLCHNG = 	["CfgVcomSettings", "SkillPresets", "Active"] call BIS_fnc_getCfgDataBool;
VCM_SKILL = [];
if VCM_SKILLCHNG then
{
	VCM_SPRESET = ["CfgVcomSettings", "SkillPresets", "SkillPreset"] call BIS_fnc_getCfgData;
	{
		VCM_SKILL pushBack (0.01 * (["CfgVcomSettings", "SkillPresets", VCM_SPRESET, _x] call BIS_fnc_getCfgData));
	} forEach ["aimingAccuracy", "aimingShake", "aimingSpeed", "commanding", "courage", "endurance", "general", "reloadSpeed", "spotDistance", "spotTime"];
};

VCM_SIDESKILL = ["CfgVcomSettings", "SkillPresets", "SideSkill", "Active"] call BIS_fnc_getCfgDataBool;
VCM_WESTSKILL = [];
VCM_EASTSKILL = [];
VCM_INDSKILL = [];
if VCM_SIDESKILL then
{
	{
		VCM_WESTSKILL pushBack (0.01 * (["CfgVcomSettings", "SkillPresets", "SideSkill", "west", _x] call BIS_fnc_getCfgData));
	} forEach ["aimingAccuracy", "aimingShake", "aimingSpeed", "commanding", "courage", "endurance", "general", "reloadSpeed", "spotDistance", "spotTime"];
	{
		VCM_EASTSKILL pushBack (0.01 * (["CfgVcomSettings", "SkillPresets", "SideSkill", "east", _x] call BIS_fnc_getCfgData));
	} forEach ["aimingAccuracy", "aimingShake", "aimingSpeed", "commanding", "courage", "endurance", "general", "reloadSpeed", "spotDistance", "spotTime"];
	{
		VCM_INDSKILL pushBack (0.01 * (["CfgVcomSettings", "SkillPresets", "SideSkill", "resistance", _x] call BIS_fnc_getCfgData));
	} forEach ["aimingAccuracy", "aimingShake", "aimingSpeed", "commanding", "courage", "endurance", "general", "reloadSpeed", "spotDistance", "spotTime"];
};

VCM_CLASSSKILL = ["CfgVcomSettings", "SkillPresets", "classnameSkill", "Active"] call BIS_fnc_getCfgDataBool;
VCM_SKILLCLASSES = [];
if VCM_CLASSSKILL then
{
	{
		private _arr = [_x];
		private _class = _x;
		{
			_arr pushBack (0.01 * (["CfgVcomSettings", "SkillPresets", "classnameSkill", "_class", _x] call BIS_fnc_getCfgData));
		} forEach ["aimingAccuracy", "aimingShake", "aimingSpeed", "commanding", "courage", "endurance", "general", "reloadSpeed", "spotDistance", "spotTime"];
		VCM_SKILLCLASSES pushBack _arr;
	} forEach (["CfgVcomSettings", "SkillPresets", "classnameSkill"] call BIS_fnc_getCfgSubClasses);
};

diag_log "VCOM: Loaded config";

if (isFilePatchingEnabled && {"" != loadFile "\userconfig\VCOM_AI\AISettingsV5.hpp"}) then
{
	[] call compile preprocessFileLineNumbers "\userconfig\VCOM_AI\AISettingsV5.hpp"; //Overwrite with userconfig
};

{
	if (_x isEqualType 0) then
	{
		VCM_SIDES set [_forEachIndex, _x call BIS_fnc_sideType];
	};
} forEach VCM_SIDES;

if (_preInit isEqualTo "preInit") then {
	publicVariable "VCM_ACTIVE";
	publicVariable "VCM_DEBUG";
	publicVariable "VCM_SIDES";
	publicVariable "VCM_SUPPRESS";
	publicVariable "VCM_HEALING";
	publicVariable "VCM_WPGEN";
	publicVariable "VCM_FRMCHNG";
	publicVariable "VCM_FFE";
	publicVariable "VCM_FULLSPEED";
	publicVariable "VCM_MAGLIMIT";
	publicVariable "VCM_MINECHNC";
	publicVariable "VCM_LGARR";
	publicVariable "VCM_RGDL";
	publicVariable "VCM_STEAL";
	publicVariable "VCM_STEALDIST";
	publicVariable "VCM_STEALCLASS";
	publicVariable "VCM_HEARDIST";
	publicVariable "VCM_WARNDIST";
	publicVariable "VCM_WARNDELAY";
	publicVariable "VCM_STATICARMT";
	publicVariable "VCM_SKILLCHNG";
	publicVariable "VCM_SPRESET";
	publicVariable "VCM_SKILL";
	publicVariable "VCM_SIDESKILL";
	publicVariable "VCM_WESTSKILL";
	publicVariable "VCM_EASTSKILL";
	publicVariable "VCM_INDSKILL";
	publicVariable "VCM_CLASSSKILL";
	publicVariable "VCM_SKILLCLASSES";
	publicVariable "VCM_DRIVING";
	publicVariable "VCM_DLIMIT";
	publicVariable "VCM_DDELAY";
	publicVariable "VCM_DDIST";
	
	publicVariable "RydFFE_Active"; 
	publicVariable "RydFFE_Manual"; 
	publicVariable "RydFFE_NoControl"; 
	publicVariable "RydFFE_ArtyShells"; 
	publicVariable "RydFFE_Interval"; 
	publicVariable "RydFFE_Debug"; 
	publicVariable "RydFFE_FO"; 
	publicVariable "RydFFE_FOClass"; 
	publicVariable "RydFFE_OnePhase"; 
	publicVariable "RydFFE_2PhWithoutFO"; 
	publicVariable "RydFFE_Amount"; 
	publicVariable "RydFFE_Acc"; 
	publicVariable "RydFFE_Safe"; 
	publicVariable "RydFFE_Monogamy"; 
	publicVariable "RydFFE_ShellView"; 
	publicVariable "RydFFE_SVRange"; 
	publicVariable "RydFFE_FOAccGain"; 
	publicVariable "RydFFE_IowaMode"; 
	publicVariable "RydFFE_Add_SPMortar"; 
	publicVariable "RydFFE_Add_Mortar"; 
	publicVariable "RydFFE_Add_Rocket"; 
	publicVariable "RydFFE_Add_Other"; 

	VCM_SETTINGS = true;
	publicVariable "VCM_SETTINGS";

	diag_log "VCOM: Pushed variables to clients";
};