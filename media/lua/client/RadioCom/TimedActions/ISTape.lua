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