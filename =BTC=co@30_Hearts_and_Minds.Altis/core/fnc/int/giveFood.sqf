
/* ----------------------------------------------------------------------------
Function: btc_fnc_int_giveFood

Description:
    Give food to a unit.

Parameters:
    _player - Player. [Object]
    _target - Target. [Object]

Returns:

Examples:
    (begin example)
        [player, cursorObject] call btc_fnc_int_giveFood;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

params [
    ["_player", player, [objNull]],
    ["_target", objNull, [objNull]]
];

private _hadFood = "ACE_Banana" in items _target;
if (
    [player, "ACE_Banana"] call CBA_fnc_removeItem &&
    {[_target, "ACE_Banana", true] call CBA_fnc_addItem}
) then {
    _player switchMove "ainvpknlmstpslaywrfldnon_1";

    private _isInterpreter = player getVariable ["interpreter", false];
    if (_hadFood) then {
        [name _target, localize (["STR_BTC_HAM_CON_INFO_ASKREP_NOINTER", "STR_BTC_HAM_CON_INT_ALRGIVEFOOD"] select _isInterpreter)] call btc_fnc_showSubtitle;
    } else {
        [name _target, localize (["STR_BTC_HAM_CON_INFO_ASKREP_NOINTER", "str_a3_rscdisplaywelcome_kart_pard_footer2"] select _isInterpreter)] call btc_fnc_showSubtitle;
        [btc_rep_bonus_giveFood, _player] remoteExecCall ["btc_fnc_rep_change", 2];
    };
};
