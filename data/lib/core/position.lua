Position.directionOffset = {
	[DIRECTION_NORTH] = {x = 0, y = -1},
	[DIRECTION_EAST] = {x = 1, y = 0},
	[DIRECTION_SOUTH] = {x = 0, y = 1},
	[DIRECTION_WEST] = {x = -1, y = 0},
	[DIRECTION_SOUTHWEST] = {x = -1, y = 1},
	[DIRECTION_SOUTHEAST] = {x = 1, y = 1},
	[DIRECTION_NORTHWEST] = {x = -1, y = -1},
	[DIRECTION_NORTHEAST] = {x = 1, y = -1}
}

function Position:getNextPosition(direction, steps)
	local offset = Position.directionOffset[direction]
	if offset then
		steps = steps or 1
		self.x = self.x + offset.x * steps
		self.y = self.y + offset.y * steps
	end
end

local isWalkable = function (position)
	local tile = Tile(position)
	if not tile then
		return false
	end

	local ground = tile:getGround()
	if tile:hasFlag(TILESTATE_FLOORCHANGE) and not ground or ground:hasProperty(CONST_PROP_BLOCKSOLID) or ground:hasProperty(CONST_PROP_IMMOVABLEBLOCKPATH) then
		return false
	end

	local items = tile:getItems()
	for i = 1, tile:getItemCount() do
		local item = items[i]
		local itemType = item:getType()
		if itemType:getType() ~= ITEM_TYPE_MAGICFIELD and not itemType:isMovable() and item:hasProperty(CONST_PROP_BLOCKSOLID) then
			return false
		end
	end
	return true
end

local swap = function (lhs, rhs)
	lhs.x, rhs.x = rhs.x, lhs.x
	lhs.y, rhs.y = rhs.y, lhs.y
	lhs.z, rhs.z = rhs.z, lhs.z
end

function Position:moveUpstairs()
	local defaultPosition = self
	while (self.z ~= 0) do
		self.z = self.z - 1
		if isWalkable(self) then
			return self
		end

		defaultPosition = self + Position.directionOffset[DIRECTION_SOUTH]
		if not isWalkable(defaultPosition) then
			for direction = DIRECTION_NORTH, DIRECTION_NORTHEAST do
				if direction == DIRECTION_SOUTH then
					direction = DIRECTION_WEST
				end

				local position = self + Position.directionOffset[direction]
				if isWalkable(position) then
					swap(self, position)
					return self
				end
			end
		else
			break
		end
	end

	swap(self, defaultPosition)
	return self
end

function Position:moveDownstairs()
	local defaultPosition = self
	while (self.z ~= 15) do
		self.z = self.z + 1
		if isWalkable(self) then
			return self
		end

		defaultPosition = self + Position.directionOffset[DIRECTION_SOUTH]
		if not isWalkable(defaultPosition) then
			for direction = DIRECTION_NORTH, DIRECTION_NORTHEAST do
				if direction == DIRECTION_SOUTH then
					direction = DIRECTION_WEST
				end

				local position = self + Position.directionOffset[direction]
				if isWalkable(position) then
					swap(self, position)
					return self
				end
			end
		else
			break
		end
	end

	swap(self, defaultPosition)
	return self
end
