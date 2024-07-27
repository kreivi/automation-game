# Automation Game
# Copyright (C) 2024 Severi Vidnäs
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

# Base data type for all data sentities.
class_name EntityData extends Resource

# The unique identifier of the entity.
@export var id := "":
	set(value):
		if value == id: return
		id = value
		resource_name = AutomationGameDataImporterUtils.id_to_resource_name(id)
		pass