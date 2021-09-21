require "TimedActions/ISBaseTimedAction"
require "TCMusicDefenitions"

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