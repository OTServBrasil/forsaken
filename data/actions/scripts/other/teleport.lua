local upFloorIds = {1386, 3678, 5543, 22845, 22846, 22949, 23668}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if isInArray(upFloorIds, item.itemid) then
		fromPosition:moveUpstairs()
	else
		fromPosition:moveDownstairs()
	end
	if player:isPzLocked() and Tile(fromPosition):hasFlag(TILESTATE_PROTECTIONZONE) then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, Game.getReturnMessage(RETURNVALUE_PLAYERISPZLOCKED))
		return true
	end
	player:teleportTo(fromPosition, false)
	return true
end
