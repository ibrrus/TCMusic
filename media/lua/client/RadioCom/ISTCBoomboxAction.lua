--***********************************************************
--**                    THE INDIE STONE                    **
--**				  Author: turbotutone				   **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

ISTCBoomboxAction = ISBaseTimedAction:derive("ISTCBoomboxAction")

function ISTCBoomboxAction:isValid()
	-- print("ISTCBoomboxAction:isValid()")
    if self.character and self.device and self.deviceData and self.mode then
        if self["isValid"..self.mode] then
            return self["isValid"..self.mode](self);
        end
    end
end

function ISTCBoomboxAction:update()
    if self.character and self.deviceData and self.deviceData:isIsoDevice() then
        self.character:faceThisObject(self.deviceData:getParent())
    end
end

function ISTCBoomboxAction:perform()
	-- print("ISTCBoomboxAction:perform()")
    if self.character and self.device and self.deviceData and self.mode then
        if self["perform"..self.mode] then
            self["perform"..self.mode](self);
        end
    end

    ISBaseTimedAction.perform(self)
end

-- ToggleOnOff
function ISTCBoomboxAction:isValidToggleOnOff()
    return self.deviceData:getIsBatteryPowered() and self.deviceData:getPower()>0 or self.deviceData:canBePoweredHere();
end

function ISTCBoomboxAction:performToggleOnOff()
    if self:isValidToggleOnOff() then
        self.deviceData:setIsTurnedOn( not self.deviceData:getIsTurnedOn() );
    end
end

-- RemoveBattery
function ISTCBoomboxAction:isValidRemoveBattery()
    return self.deviceData:getIsBatteryPowered() and self.deviceData:getHasBattery();
end

function ISTCBoomboxAction:performRemoveBattery()
    if self:isValidRemoveBattery() and self.character:getInventory() then
        self.deviceData:getBattery(self.character:getInventory());
    end
end

-- AddBattery
function ISTCBoomboxAction:isValidAddBattery()
    return self.deviceData:getIsBatteryPowered() and self.deviceData:getHasBattery() == false;
end

function ISTCBoomboxAction:performAddBattery()
    if self:isValidAddBattery() and self.secondaryItem then
        self.deviceData:addBattery(self.secondaryItem);
    end
end

-- SetChannel
function ISTCBoomboxAction:isValidSetChannel()
	-- print("ISTCBoomboxAction:isValidSetChannel()")
    if (not self.secondaryItem) and type(self.secondaryItem)~="number" then return false; end
    return self.deviceData:getIsTurnedOn() and self.deviceData:getPower()>0;
end

function ISTCBoomboxAction:performSetChannel()
    if self:isValidSetChannel() then
        self.deviceData:setChannel(self.secondaryItem);
    end
end

-- SetVolume
function ISTCBoomboxAction:isValidSetVolume()
    if (not self.secondaryItem) and type(self.secondaryItem)~="number" then return false; end
    return self.deviceData:getIsTurnedOn() and self.deviceData:getPower()>0;
end

function ISTCBoomboxAction:performSetVolume()
print("ISTCBoomboxAction:performSetVolume()")
    if self:isValidSetVolume() then
        self.deviceData:setDeviceVolume(self.secondaryItem);
		if self.deviceData:getParent():getModData().tcmusic and self.deviceData:getParent():getModData().tcmusic.playNowId then
			print("getEmitter():setVolume ", self.secondaryItem)
			self.deviceData:getEmitter():setVolume(self.deviceData:getParent():getModData().tcmusic.playNowId, self.secondaryItem)
		end
    end
end

-- MuteMicrophone
function ISTCBoomboxAction:isValidMuteMicrophone()
    if (not self.secondaryItem) and type(self.secondaryItem)~="boolean" then return false; end
    return self.deviceData:getIsTurnedOn() and self.deviceData:getPower()>0;
end

function ISTCBoomboxAction:performMuteMicrophone()
    if self:isValidMuteMicrophone() then
        self.deviceData:setMicIsMuted(self.secondaryItem);
    end
end

-- RemoveHeadphones
function ISTCBoomboxAction:isValidRemoveHeadphones()
    return self.deviceData:getHeadphoneType() >= 0;
end

function ISTCBoomboxAction:performRemoveHeadphones()
    if self:isValidRemoveHeadphones() and self.character:getInventory() then
        self.deviceData:getHeadphones(self.character:getInventory());
    end
end

-- AddHeadphones
function ISTCBoomboxAction:isValidAddHeadphones()
    return self.deviceData:getHeadphoneType() < 0;
end

function ISTCBoomboxAction:performAddHeadphones()
    if self:isValidAddHeadphones() and self.secondaryItem then
        self.deviceData:addHeadphones(self.secondaryItem);
    end
end

-- TogglePlayMedia
function ISTCBoomboxAction:isValidTogglePlayMedia()
    return self.deviceData:getIsTurnedOn() and self.deviceData:hasMedia();
end

function ISTCBoomboxAction:performTogglePlayMedia()
    if self:isValidTogglePlayMedia() then
		print(self.deviceData:getEmitter())
		print(self.deviceData:getEmitter():isEmpty())
        if self.deviceData:isPlayingMedia() then
            self.deviceData:StopPlayMedia();
        else
            self.deviceData:StartPlayMedia();
			self.deviceData:getEmitter():stopAll()
			print(self.secondaryItem)
			-- self.deviceData:getEmitter():playSound(self.secondaryItem:getType())
        end
		
    end
end

-- AddMedia
function ISTCBoomboxAction:isValidAddMedia()
	-- print("ISTCBoomboxAction:isValidAddMedia()")
	print((not self.deviceData:hasMedia()) and self.deviceData:getMediaType() == TCMusicData[self.secondaryItem:getType()])
    return (not self.deviceData:hasMedia()) and self.deviceData:getMediaType() == TCMusicData[self.secondaryItem:getType()];
end

function ISTCBoomboxAction:performAddMedia()
-- print("ISTCBoomboxAction:performAddMedia()")
    if self:isValidAddMedia() and self.secondaryItem then
        self.deviceData:addMediaItem(self.secondaryItem);
    end
end

-- RemoveMedia
function ISTCBoomboxAction:isValidRemoveMedia()
	-- print("ISTCBoomboxAction:isValidRemoveMedia()")
    return self.deviceData:hasMedia();
end

function ISTCBoomboxAction:performRemoveMedia()
-- print("ISTCBoomboxAction:performRemoveMedia()")
    if self:isValidRemoveMedia() and self.character:getInventory() then
        self.deviceData:removeMediaItem(self.character:getInventory());
    end
end

function ISTCBoomboxAction:new(mode, character, device, secondaryItem)
    local o             = {};
    setmetatable(o, self);
    self.__index        = self;
    o.mode              = mode;
    o.character         = character;
    o.device            = device;
    o.deviceData        = device and device:getDeviceData();
    o.secondaryItem     = secondaryItem;

    o.stopOnWalk        = false;
    o.stopOnRun         = true;
    o.maxTime           = 30;

    return o;
end
