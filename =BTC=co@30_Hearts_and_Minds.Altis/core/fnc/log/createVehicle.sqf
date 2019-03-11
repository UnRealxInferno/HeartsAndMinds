
/* ----------------------------------------------------------------------------
Function: btc_fnc_log_createVehicle

Description:
    Fill me when you edit me !

Parameters:
    _type - [String]
    _pos - [Array]
    _dir - [Number]
    _customization - [Array]

Returns:

Examples:
    (begin example)
        _result = [] call btc_fnc_log_createVehicle;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

params [
    ["_type", "", [""]],
    ["_pos", [0, 0, 0], [[]]],
    ["_dir", 0, [0]],
    ["_customization", [false, false], [[]]],
    ["_isMedicalVehicle", false, [true]],
    ["_isRepairVehicle", false, [true]],
    ["_fuelSource", [], [[]]],
    ["_pylons", [], [[]]]
];

private _veh  = createVehicle [_type, ASLToATL _pos, [], 0, "CAN_COLLIDE"];
_veh setDir _dir;
_veh setPosASL _pos;
[_veh, _customization select 0, _customization select 1] call BIS_fnc_initVehicle;
if (_isMedicalVehicle && {!([_veh] call ace_medical_fnc_isMedicalVehicle)}) then {
    _veh setVariable ["ACE_isMedicalVehicle", _isMedicalVehicle, true];
};
if (_isRepairVehicle && {!([_veh] call ace_repair_fnc_isRepairVehicle)}) then {
    _veh setVariable ["ACE_isRepairVehicle", _isRepairVehicle, true];
};
if !(_fuelSource isEqualTo []) then {
    _fuelSource params [
        ["_source", objNull, [objNull]],
        ["_fuelCargo", 0, [0]],
        ["_hooks", nil, [[]]]
    ];
    [_source, _fuelCargo, _hooks] call ace_refuel_fnc_makeSource;
};
if !(_pylons isEqualTo []) then {
    _fuelSource params [
        ["_source", objNull, [objNull]],
        ["_fuelCargo", 0, [0]],
        ["_hooks", nil, [[]]]
    ];
    private _pylonPaths = (configProperties [configFile >> "CfgVehicles" >> typeOf _veh >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"]) apply {getArray (_x >> "turret")};
    {
        _veh removeWeaponGlobal getText (configFile >> "CfgMagazines" >> _x >> "pylonWeapon")
    } forEach getPylonMagazines _veh;
    {
        _veh setPylonLoadOut [_forEachIndex + 1, _x, true, _pylonPaths select _forEachIndex]
    } forEach _pylons;
};

_veh setVariable ["btc_dont_delete", true];

if (getNumber(configFile >> "CfgVehicles" >> typeOf _veh >> "isUav") isEqualTo 1) then {
    createVehicleCrew _veh;
};

_veh call btc_fnc_db_add_veh;

_veh
