--***********************************************************
--**             PLAY MUSIC IN YOUR POCKETS                **
--***********************************************************

	-- START
ISTapePockets = ISBaseTimedAction:derive("ISTapePockets")

function ISTapePockets:isValid()
	return true;
end

function ISTapePockets:start()
	self.sound = self.character:playSound(self.service_sound)
	radius = 15
	addSound(self.character, self.character:getX(), self.character:getY(), self.character:getZ(), radius, 1) -- Звук приманивает зомби
end

function ISTapePockets:stop()
	ISBaseTimedAction.stop(self)
end

function ISTapePockets:perform()
	radius = 8
	addSound(self.character, self.character:getX(), self.character:getY(), self.character:getZ(), radius * self.volume, 1) -- Звук приманивает зомби
	print(self.songID)
	now_play[self.songID] = {self.character:playSound(self.music);self.volume;self._itemMusPlayerID}
	print(self.character:getEmitter())
	print(now_play[self.songID])
	self.character:getEmitter():setVolume(now_play[self.songID][1], 0.2 * self.volume)
	ISBaseTimedAction.perform(self)
end

function ISTapePockets:new(character, _itemMusPlayerID, music, service_sound, songID, time, volume)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.service_sound = service_sound
	o._itemMusPlayerID = _itemMusPlayerID
	o.music = music
	o.volume = volume
	o.songID = songID
	o.stopOnWalk = false
	o.stopOnRun = false
	o.maxTime = time
	return o;
end

	-- STOP
ISTapePocketsStop = ISBaseTimedAction:derive("ISTapePocketsStop")

function ISTapePocketsStop:isValid()
	return true;
end

function ISTapePocketsStop:start()
end

function ISTapePocketsStop:stop()
	ISBaseTimedAction.stop(self)
end

function ISTapePocketsStop:perform()
	stopSound(now_play[self.songID][1])
	self.character:playSound(self.service_sound)
	ISBaseTimedAction.perform(self)
end

function ISTapePocketsStop:new(character, songID, service_sound, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.service_sound = service_sound
	o.songID = songID
	o.stopOnWalk = false
	o.stopOnRun = false
	o.maxTime = time
	return o;
end