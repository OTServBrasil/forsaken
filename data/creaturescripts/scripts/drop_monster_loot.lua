function onDeath(monster, corpse, killer, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
	if not monster:isMonster() or monster:getMaster() then
		return true
	end

	if not corpse:isContainer() then
		return true
	end

	local owner = mostdamagekiller
	if killer and killer:isPlayer() then
		owner = killer
	end

	local modifier = 1
	if owner and owner:isPlayer() then
		corpse:setAttribute(ITEM_ATTRIBUTE_OWNER, owner:getId())
	end

	monster:getType():createLoot(corpse, 1)

	return true
end
