# Automation Game
# Copyright (C) 2024 Severi Vidnäs
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

## 
class_name GameBoard extends GraphEdit

func _ready() -> void:
	connection_request.connect(_on_connection_request)
	pass


func _on_connection_request(from: StringName, from_port: int, to: StringName, to_port: int) -> void:
	print("Connection request from %s:%d to %s:%d" % [from, from_port, to, to_port])
	var from_processor := find_child(from) as Processor
	var to_processor := find_child(to) as Processor
	from_processor.output_connected(from_port)
	to_processor.input_connected(to_port)
	pass
