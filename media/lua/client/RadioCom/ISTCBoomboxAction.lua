--***********************************************************
--**                    THE INDIE STONE                    **
--**				  Author: turbotutone				   **
--***********************************************************

require "TimedActions/ISBaseTimedAction"
require "TCMusicDefenitions"

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
		if self.device:getModData().tcmusic and (self.device:getModData().tcmusic.deviceType == "VehiclePart") then
			if self.deviceData:getIsTurnedOn() then
				self.device:getVehicle():getEmitter():stopAll()
				self.device:getModData().tcmusic.playNow = nil
				self.device:getModData().tcmusic.playNowId = nil
			end
		end
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

-- -- SetChannel
-- function ISTCBoomboxAction:isValidSetChannel()
	-- -- print("ISTCBoomboxAction:isValidSetChannel()")
    -- if (not self.secondaryItem) and type(self.secondaryItem)~="number" then return false; end
    -- return self.deviceData:getIsTurnedOn() and self.deviceData:getPower()>0;
-- end

-- function ISTCBoomboxAction:performSetChannel()
    -- if self:isValidSetChannel() then
        -- self.deviceData:setChannel(self.secondaryItem);
    -- end
-- end

-- SetVolume
function ISTCBoomboxAction:isValidSetVolume()
    if (not self.secondaryItem) and type(self.secondaryItem)~="number" then return false; end
    return self.deviceData:getIsTurnedOn() and self.deviceData:getPower()>0;
end

function ISTCBoomboxAction:performSetVolume()
-- print("ISTCBoomboxAction:performSetVolume()")
    if self:isValidSetVolume() then
        self.deviceData:setDeviceVolume(self.secondaryItem);
		if self.device:getModData().tcmusic and self.device:getModData().tcmusic.playNowId then
			if self.device:getModData().tcmusic.deviceType == "VehiclePart" then
				self.device:getVehicle():getEmitter():setVolume(self.device:getModData().tcmusic.playNowId, self.secondaryItem / 2)
			else
				self.deviceData:getEmitter():setVolume(self.device:getModData().tcmusic.playNowId, self.secondaryItem)
			end
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
	if self.deviceData:getIsTurnedOn() and self.device:getModData().tcmusic.mediaItem then
		if not self.device:getModData().tcmusic.needSpeaker or self.device:getModData().tcmusic.connectTo then
			return true
		else
			return false
		end
	end
end

function ISTCBoomboxAction:performTogglePlayMedia()
	-- print("ISTCBoomboxAction:performTogglePlayMedia()")

    if self:isValidTogglePlayMedia() then
		if self.device:getModData().tcmusic.deviceType == "VehiclePart" then
			-- print("VehiclePart")
			if self.device:getModData().tcmusic.playNow and self.device:getVehicle():getEmitter() and self.device:getVehicle():getEmitter():isPlaying(self.device:getModData().tcmusic.playNow) then
				self.device:getVehicle():getEmitter():stopAll()
				self.device:getModData().tcmusic.playNow = nil
				self.device:getModData().tcmusic.playNowId = nil
				ISBaseTimedAction.perform(self)
			elseif self.device:getVehicle():getEmitter() then
				self.device:getModData().tcmusic.playNow = self.device:getModData().tcmusic.mediaItem
				self.device:getModData().tcmusic.playNowId = self.device:getVehicle():getEmitter():playSoundImpl(self.device:getModData().tcmusic.mediaItem, IsoObject.new())
				self.device:getVehicle():getEmitter():setVolume(self.device:getModData().tcmusic.playNowId, self.deviceData:getDeviceVolume() / 2)
				-- self.device:getVehicle():getEmitter():set3D(self.device:getModData().tcmusic.playNowId, false)
			end	
		else
			-- print("NOT VehiclePart")
			if self.device:getModData().tcmusic.playNow and self.device:getDeviceData():getEmitter() and self.device:getDeviceData():getEmitter():isPlaying(self.device:getModData().tcmusic.playNow) then -- self.deviceData:isPlayingMedia()
				self.deviceData:getEmitter():stopAll()
				self.device:getModData().tcmusic.playNow = nil
				self.device:getModData().tcmusic.playNowId = nil
				ISBaseTimedAction.perform(self)
			elseif self.deviceData:getEmitter() then
				-- print("self.deviceData:getEmitter()")
				self.device:getModData().tcmusic.playNow = self.device:getModData().tcmusic.mediaItem
				self.device:getModData().tcmusic.playNowId = self.deviceData:getEmitter():playSound(self.device:getModData().tcmusic.mediaItem)
				self.deviceData:getEmitter():setVolume(self.device:getModData().tcmusic.playNowId, self.deviceData:getDeviceVolume())
			end	
		end
    end
end

-- AddMedia
function ISTCBoomboxAction:isValidAddMedia()
	-- print("ISTCBoomboxAction:isValidAddMedia()")
	-- print((not self.deviceData:getParent():getModData().tcmusic.mediaItem) and self.deviceData:getMediaType() == TCMusicData[self.secondaryItem:getType()])
	local musicPlayer = nil
	if self.device:getModData().tcmusic.deviceType == "InventoryItem" then
		musicPlayer = ItemMusicPlayer[self.device:getFullType()]
	elseif self.device:getModData().tcmusic.deviceType == "IsoObject" then
		musicPlayer = WorldMusicPlayer[self.device:getSprite():getName()]
	elseif self.device:getModData().tcmusic.deviceType == "VehiclePart" then
		musicPlayer = VehicleMusicPlayer[self.device:getInventoryItem():getFullType()]
	end
	if self.secondaryItem then
		local music = self.secondaryItem:getType()
		return (not self.device:getModData().tcmusic.mediaItem) and GlobalMusic[music] and musicPlayer == GlobalMusic[music];
	end
end

function ISTCBoomboxAction:performAddMedia()
-- print("ISTCBoomboxAction:performAddMedia()")
    if self:isValidAddMedia() and self.secondaryItem then
		local inventoryItem = self.secondaryItem
		local container = self.secondaryItem:getContainer()
		if container then
			if (container:getType() == "floor" and inventoryItem:getWorldItem() and inventoryItem:getWorldItem():getSquare()) then
				inventoryItem:getWorldItem():getSquare():transmitRemoveItemFromSquare(inventoryItem:getWorldItem());
				inventoryItem:getWorldItem():getSquare():getWorldObjects():remove(inventoryItem:getWorldItem());
				inventoryItem:getWorldItem():getSquare():getChunk():recalcHashCodeObjects();
				inventoryItem:getWorldItem():getSquare():getObjects():remove(inventoryItem:getWorldItem());
				inventoryItem:setWorldItem(nil);
			end
			self.device:getModData().tcmusic.mediaItem = inventoryItem:getType();
			container:DoRemoveItem(inventoryItem);
		end
    end
end

-- RemoveMedia
function ISTCBoomboxAction:isValidRemoveMedia()
	-- print("ISTCBoomboxAction:isValidRemoveMedia()")
	if self.device:getModData().tcmusic.mediaItem then
		return true
	else
		return false
	end
end

function ISTCBoomboxAction:performRemoveMedia()
-- print("ISTCBoomboxAction:performRemoveMedia()")
    if self:isValidRemoveMedia() and self.character:getInventory() then
		local itemTape = InventoryItemFactory.CreateItem("Tsarcraft." .. self.device:getModData().tcmusic.mediaItem)
		if itemTape then
			self.character:getInventory():AddItem(itemTape)
			if self.deviceData:getEmitter() then
				self.deviceData:getEmitter():stopAll()
			end
			self.device:getModData().tcmusic.playNow = nil
			self.device:getModData().tcmusic.playNowId = nil
			self.device:getModData().tcmusic.mediaItem = nil
		end
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
