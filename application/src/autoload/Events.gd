# Automation Game
# Copyright (C) 2024 Severi Vidnäs
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

## Global event broker.
extends Node

#region Simulation signals

## Simulation ticked event. Called by [Simulation] when ticks are processed.
signal simulation_ticked(ticks: int, ticks_per_second: float)

## Simulation paused event. Called by [Simulation] when the simulation is paused or unpaused.
signal simulation_paused(paused: bool)

#endregion Simulation signals
