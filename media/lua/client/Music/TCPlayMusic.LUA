--***********************************************************
--**                    TSAR VYACHESLAV                    **
--***********************************************************


require "TimedActions/ISBaseTimedAction"
require "Music/TCMusicDefenitions"

ISPlayMusic = ISBaseTimedAction:derive("ISPlayMusic")

function ISPlayMusic:isValid()
	return true;
end

function ISPlayMusic:start()
	self.sound = self.character:playSound(self.music)
	radius = 15
	addSound(self.instrument, self.character:getX(), self.character:getY(), self.character:getZ(), radius, 1) -- Звук приманивает зомби
end

function ISPlayMusic:stop()
	self.character:getEmitter():stopSound(self.sound)
	ISBaseTimedAction.stop(self)
end

function ISPlayMusic:update()
	addSound(self.instrument, self.character:getX(), self.character:getY(), self.character:getZ(), radius, 1) -- Звук приманивает зомби
end

function ISPlayMusic:perform()
	self.character:getEmitter():stopSound(self.sound)
	ISBaseTimedAction.perform(self)
end

function ISPlayMusic:new(character, instrument, music, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.instrument = instrument
	o.music = music
	o.stopOnWalk = true
	o.stopOnRun = true
	o.maxTime = time
	return o;
end


--***********************************************************
--**               PLAY MUSIC IN THE WORLD                 **
--***********************************************************

	-- START
ISTape = ISBaseTimedAction:derive("ISTape")

function ISTape:isValid()
	return true;
end

function ISTape:start()
	self.sound = self.character:playSound(self.service_sound)
	radius = 15
	addSound(self.character, self.character:getX(), self.character:getY(), self.character:getZ(), radius, 1) -- Звук приманивает зомби
end

function ISTape:stop()
	ISBaseTimedAction.stop(self)
end

function ISTape:perform()
	radius = 40
	addSound(self.character, self.character:getX(), self.character:getY(), self.character:getZ(), radius, 1) -- Звук приманивает зомби
	local songID = string.format("%05d", self.instrument:getX()) .. string.format("%05d", self.instrument:getY()) .. string.format("%02d", self.instrument:getZ())
	now_play[songID] = {self.instrument:getSquare():playSound(self.music);nil}
    -- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end

function ISTape:new(character, instrument, service_sound, song, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.instrument = instrument
	o.service_sound = service_sound
	o.music = song
	o.stopOnWalk = true
	o.stopOnRun = true
	o.maxTime = time
	return o;
end

	-- STOP
ISTapeMusicStop = ISBaseTimedAction:derive("ISTapeMusicStop")

function ISTapeMusicStop:isValid()
	return true;
end

function ISTapeMusicStop:start()
end

function ISTapeMusicStop:stop()
	ISBaseTimedAction.stop(self)
end

function ISTapeMusicStop:perform()
	local songID = string.format("%05d", self.instrument:getX()) .. string.format("%05d", self.instrument:getY()) .. string.format("%02d", self.instrument:getZ())
	stopSound(now_play[songID][1])
	self.character:playSound(self.service_sound)
	ISBaseTimedAction.perform(self)
end

function ISTapeMusicStop:new(character, instrument, service_sound, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.service_sound = service_sound
	o.instrument = instrument
	o.stopOnWalk = false
	o.stopOnRun = false
	o.maxTime = time
	return o;
end

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
	radius = 40
	addSound(self.character, self.character:getX(), self.character:getY(), self.character:getZ(), radius, 1) -- Звук приманивает зомби
	now_play[self.songID] = {self.character:playSound(self.music);self._itemMusPlayerID}
	ISBaseTimedAction.perform(self)
end

function ISTapePockets:new(character, _itemMusPlayerID, music, service_sound, songID, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.service_sound = service_sound
	o._itemMusPlayerID = _itemMusPlayerID
	o.music = music
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