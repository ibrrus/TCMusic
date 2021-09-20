--***********************************************************
--**             PLAY MUSIC IN YOUR POCKETS                **
--***********************************************************

ISTapePockets = ISBaseTimedAction:derive("ISTapePockets")

function ISTapePockets:isValid()
	return true;
end

function ISTapePockets:start()
	self._itemMusPlayer:getDeviceData():getEmitter():playSound(self.service_sound)
	addSound(self.character, self.character:getX(), self.character:getY(), self.character:getZ(), 15, 1)
end

function ISTapePockets:stop()
	ISBaseTimedAction.stop(self)
end

function ISTapePockets:perform()
	self._itemMusPlayer:getModData().tcmusic.playNow = self.music
	self._itemMusPlayer:getModData().tcmusic.playNowId = self._itemMusPlayer:getDeviceData():getEmitter():playSound(self.music)
	self._itemMusPlayer:getDeviceData():getEmitter():setVolume(self._itemMusPlayer:getModData().tcmusic.playNowId, self._itemMusPlayer:getDeviceData():getDeviceVolume())
	ISBaseTimedAction.perform(self)
end

function ISTapePockets:new(character, _itemMusPlayer, music, service_sound, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.service_sound = service_sound
	o._itemMusPlayer = _itemMusPlayer
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
	self.character:playSound(self.service_sound)
	self._itemMusPlayer:getDeviceData():getEmitter():stopAll()
	self._itemMusPlayer:getModData().tcmusic.playNow = nil
	self._itemMusPlayer:getModData().tcmusic.playNowId = nil
	ISBaseTimedAction.perform(self)
end

function ISTapePocketsStop:new(character, _itemMusPlayer, service_sound, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.service_sound = service_sound
	o._itemMusPlayer = _itemMusPlayer
	o.stopOnWalk = false
	o.stopOnRun = false
	o.maxTime = time
	return o;
end