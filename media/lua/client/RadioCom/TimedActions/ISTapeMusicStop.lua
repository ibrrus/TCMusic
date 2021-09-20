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

