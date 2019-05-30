
/* ----------------------------------------------------------------------------
Function: btc_fnc_task_setState

Description:
    Set state to task and subtasks (children).

Parameters:
    _task - Main task to change state of the main task and children. [Array]
    _state - State to apply. [String]

Returns:
    IsSet - if the state has changed array. [Boolean]

Examples:
    (begin example)
        ["btc_dft", "CANCELED"] call btc_fnc_task_setState;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

params [
    ["_task", "", [""]],
    ["_state", "CANCELED", [""]]
];

private _subTasks = _task call BIS_fnc_taskChildren;
if (_subTasks isEqualTo []) then {
    private _taskParent = _task call BIS_fnc_taskParent;
    if !(_taskParent isEqualTo "") then {
        _task = _taskParent;
        _subTasks = _task call BIS_fnc_taskChildren;
    };
};

(_subTasks + [_task]) apply {
    if !(_x call BIS_fnc_taskCompleted) then {
        [_x, _state] call BIS_fnc_taskSetState
    } else {
        false
    };
}
