# Automation Game
# Copyright (C) 2024 Severi Vidnäs
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

## Runs simulation ticks independently of the frame rate.
class_name Simulation extends Node

## Simulation processing callback. Determines whether the simulation is processed during the idle or physics phase.
@export var process_callback := Timer.TIMER_PROCESS_IDLE

## Simulation speed. Calculates ticks per second based on the set speed ([code]1.0/value[/code]).
@export var speed := 10:
	set(value):
		if value == speed: return
		speed = value
		_ticks_per_second = 1.0 / speed
		pass

## Whether the simulation is paused. Emits [code]Events.simulation_paused[/code] signal when changed.
@export var paused := true:
	set(value):
		if paused == value: return
		paused = value
		Events.simulation_paused.emit(paused)
		pass

## Simulation speed in ticks per second.
var _ticks_per_second := 1.0 / 10
## Time elapsed since the last tick.
var _time_elapsed := 0.0


#region Node

func _ready() -> void:
	set_process(process_callback == Timer.TIMER_PROCESS_IDLE)
	set_physics_process(process_callback == Timer.TIMER_PROCESS_PHYSICS)
	pass


func _process(delta: float) -> void:
	_process_simulation(delta)
	pass


func _physics_process(delta: float) -> void:
	_process_simulation(delta)
	pass

#endregion Node

#region private methods

## Processes the simulation. Automatically called by [member _process] or [member _physics_process] based on the
## [member process_callback].
func _process_simulation(delta: float) -> void:
	if paused: return
	_time_elapsed += delta
	if _time_elapsed < _ticks_per_second: return
	var ticks := 0
	while _time_elapsed >= _ticks_per_second:
		ticks += 1
		_time_elapsed -= _ticks_per_second
		pass
	Events.simulation_ticked.emit(ticks, _ticks_per_second)
	ticks = 0
	pass

#endregion private methods
