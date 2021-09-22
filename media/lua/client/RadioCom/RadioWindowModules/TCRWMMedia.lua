--***********************************************************
--**                    THE INDIE STONE                    **
--**				  Author: turbotutone				   **
--***********************************************************
require "RadioCom/RadioWindowModules/RWMPanel"
require "TCMusicDefenitions"

TCRWMMedia = RWMPanel:derive("TCRWMMedia");

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)

function TCRWMMedia:initialise()
    ISPanel.initialise(self)
end

function TCRWMMedia:createChildren()
    --self:setHeight(32);

    local y = 4;
    local ww = math.floor((self:getWidth()-20)/ISLcdBar.charW);
    local charWidth = ww;
    local lcdw = ww*ISLcdBar.charW;
    local x = ((self:getWidth()/2)-(lcdw/2))-2;

    self.lcd = ISLcdBar:new(x,y,charWidth);
    self.lcd:initialise();
    self.lcd:setTextMode(false);
    self:addChild(self.lcd);

    y = self.lcd:getY() + self.lcd:getHeight() + 5;

    x = (self:getWidth()/2)-(24/2);
    self.itemDropBox = ISItemDropBox:new (x, y, 24, 24, false, self, TCRWMMedia.addMedia, TCRWMMedia.removeMedia, TCRWMMedia.verifyItem, nil );
    self.itemDropBox:initialise();
    self.itemDropBox:setBackDropTex( getTexture("Item_Battery"), 0.4, 1,1,1 );
    self.itemDropBox:setDoBackDropTex( true );
    self.itemDropBox:setToolTip( true, getText("IGUI_RadioDragBattery") );
    self:addChild(self.itemDropBox);

    y = self.itemDropBox:getY() + self.itemDropBox:getHeight() + 5;

    local btnHgt = FONT_HGT_SMALL + 1 * 2

    self.toggleOnOffButton = ISButton:new(10, y, self:getWidth()-20, btnHgt, getText("ContextMenu_Turn_On"),self, TCRWMMedia.togglePlayMedia);
    self.toggleOnOffButton:initialise();
    self.toggleOnOffButton.backgroundColor = {r=0, g=0, b=0, a=0.0};
    self.toggleOnOffButton.backgroundColorMouseOver = {r=1.0, g=1.0, b=1.0, a=0.1};
    self.toggleOnOffButton.borderColor = {r=1.0, g=1.0, b=1.0, a=0.3};
    self:addChild(self.toggleOnOffButton);

    y = self.toggleOnOffButton:getY() + self.toggleOnOffButton:getHeight() + 10;

    self:setHeight(y);
end

function TCRWMMedia:togglePlayMedia()
    if self:doWalkTo() then
		-- print("TCRWMMedia.togglePlayMedia")
        ISTimedActionQueue.add(ISTCBoomboxAction:new("TogglePlayMedia",self.player, self.device ));
    end
end

function TCRWMMedia:removeMedia()
    if self:doWalkTo() then
		-- print("TCRWMMedia.removeMedia")
        ISTimedActionQueue.add(ISTCBoomboxAction:new("RemoveMedia",self.player, self.device ));
    end
end

function TCRWMMedia:addMedia( _items )
    local item;
    --local pbuff = 0;

    for _,i in ipairs(_items) do
        --if i:getDelta() > pbuff then
            item = i;
        break;
        --    pbuff = i:getDelta()
        --end
    end

    if item then
        if self:doWalkTo() then
			-- print("TCRWMMedia.addMedia")
            ISTimedActionQueue.add(ISTCBoomboxAction:new("AddMedia",self.player, self.device, item ));
        end
    end
end

function TCRWMMedia:verifyItem( _item )
-- print("TCRWMMedia:verifyItem")
	-- print(_item)
	-- print(_item:getType())
	-- print(self.deviceType)
    if GlobalMusic[_item:getType()] then
		if self.deviceType == "InventoryItem" then
			if ItemMusicPlayer[self.device:getFullType()] == GlobalMusic[_item:getType()] then
				return true;
			end
		elseif self.deviceType == "IsoObject" then
			if WorldMusicPlayer[self.device:getSprite():getName()] == GlobalMusic[_item:getType()] then
				return true;
			end
		elseif self.deviceType == "VehiclePart" then
			if self.device:getInventoryItem() and VehicleMusicPlayer[self.device:getInventoryItem():getFullType()] == GlobalMusic[_item:getType()] then
				return true;
			end
		end
	end
end

function TCRWMMedia:clear()
    RWMPanel.clear(self);
end

function TCRWMMedia:readFromObject( _player, _deviceObject, _deviceData, _deviceType )
	-- print("TCRWMMedia:readFromObject")
    if _deviceData:getMediaType() < 0 then
		-- print("_deviceData false")
		if _deviceType == "VehiclePart" then
			_deviceData:setMediaType(0)
		else
			return false;
		end
    end
    self.mediaIndex = -9999;

    if _deviceData:getMediaType()==1 then
        self.itemDropBox:setBackDropTex( self.cdTex, 0.4, 1,1,1 );
        self.itemDropBox:setToolTip( true, getText("IGUI_media_dragVinyl") );
        self.lcd.ledColor = self.lcdBlue.back;
        self.lcd.ledTextColor = self.lcdBlue.text;
    end
    if _deviceData:getMediaType()==0 then
		-- print("MediaType 0")
        self.itemDropBox:setBackDropTex( self.tapeTex, 0.4, 1,1,1 );
        self.itemDropBox:setToolTip( true, getText("IGUI_media_dragCassette") );
        self.lcd.ledColor = self.lcdGreen.back;
        self.lcd.ledTextColor = self.lcdGreen.text;
    end

    local read =  RWMPanel.readFromObject(self, _player, _deviceObject, _deviceData, _deviceType );

    if self.player then
        self.itemDropBox.mouseEnabled = true;
        if JoypadState.players[self.player:getPlayerNum()+1] then
            self.itemDropBox.mouseEnabled = false;
        end
    end

    return read;
end

function TCRWMMedia:getMediaText()
    local text = "";
    local addedSegment = false;
    if self.device:getModData().tcmusic.mediaItem then
        local itemTape = InventoryItemFactory.CreateItem("Tsarcraft." .. self.device:getModData().tcmusic.mediaItem)
		if itemTape then
			addedSegment = true;
			text = itemTape:getDisplayName()
		end
    end
    if addedSegment then
        return text.." *** ";
    end
    return self.deviceData:getMediaType()==0 and self.textNoTape or self.textNoCD;
end

function TCRWMMedia:update()
    ISPanel.update(self);

    if self.player and self.device and self.deviceData and self.device:getModData().tcmusic then
		-- print("TCRWMMedia:update()")
        local isOn = self.deviceData:getIsTurnedOn();

        self.lcd:toggleOn(isOn);

        if (not isOn) and self.device:getModData().tcmusic.playNow and self.device:getDeviceData():getEmitter() and self.device:getDeviceData():getEmitter():isPlaying(self.device:getModData().tcmusic.playNow) then
			self.deviceData:getEmitter():stopAll()
			self.device:getModData().tcmusic.playNow = nil
			self.device:getModData().tcmusic.playNowId = nil
			ISBaseTimedAction.perform(self)
        end
		
		
		if self.device:getModData().tcmusic.deviceType == "VehiclePart" then
			if self.device:getModData().tcmusic.playNow and self.device:getVehicle():getEmitter() and self.device:getVehicle():getEmitter():isPlaying(self.device:getModData().tcmusic.playNow) then
				self.toggleOnOffButton:setTitle(self.textStop);
			else
				self.toggleOnOffButton:setTitle(self.textPlay);
			end
		else
			if self.device:getModData().tcmusic.playNow and self.device:getDeviceData():getEmitter() and self.device:getDeviceData():getEmitter():isPlaying(self.device:getModData().tcmusic.playNow) then
				self.toggleOnOffButton:setTitle(self.textStop);
			else
				self.toggleOnOffButton:setTitle(self.textPlay);
			end
		end

        if self.device:getModData().tcmusic.mediaItem then
            if self.deviceData:getMediaType()==1 then
                self.itemDropBox:setStoredItemFake( self.cdTex );
            end
            if self.deviceData:getMediaType()==0 then
                self.itemDropBox:setStoredItemFake( self.tapeTex );
            end

            if self.device:getModData().tcmusic.playNow and ((self.device:getDeviceData():getEmitter() and self.device:getDeviceData():getEmitter():isPlaying(self.device:getModData().tcmusic.playNow)) or (self.device:getModData().tcmusic.deviceType == "VehiclePart" and self.device:getVehicle():getEmitter() and self.device:getVehicle():getEmitter():isPlaying(self.device:getModData().tcmusic.playNow))) then
                self.lcd:setText(self:getMediaText());
                self.lcd:setDoScroll(true);
            else
                self.lcd:setText(self.idleText);
                self.lcd:setDoScroll(false);
            end
        else
            self.itemDropBox:setStoredItemFake( nil );
            self.lcd:setText(self.mediaText);
            self.lcd:setDoScroll(false);
        end
    end
end

function TCRWMMedia:prerender()
    ISPanel.prerender(self);
end


function TCRWMMedia:render()
    ISPanel.render(self);
end

function TCRWMMedia:onJoypadDown(button)
    if button == Joypad.AButton then
        self:toggleOnOff()
    elseif button == Joypad.BButton then
        if self.device:getModData().tcmusic.mediaItem then
            self:removeMedia();
        else
            local inv = self.player:getInventory();
            local type = self.deviceData:getMediaType();
            local medias = {};
            if type==1 then
                local list = inv:FindAll("Base.Disc_Retail");
                for i=0,list:size()-1 do
                    table.insert(medias, list:get(i));
                end
            end
            if type==0 then
                local list = inv:FindAll("Base.VHS_Retail");
                for i=0,list:size()-1 do
                    table.insert(medias, list:get(i));
                end
                local list = inv:FindAll("Base.VHS_Home");
                for i=0,list:size()-1 do
                    table.insert(medias, list:get(i));
                end
            end

            if #medias>0 then
                self:addMedia( medias );
            end
        end
    end
end

function TCRWMMedia:getAPrompt()
    if self.device:getModData().tcmusic.playNow and self.device:getDeviceData():getEmitter():isPlaying(self.device:getModData().tcmusic.playNow) then
        return self.textStop;
    else
        return self.textPlay;
    end
end
function TCRWMMedia:getBPrompt()
    if self.device:getModData().tcmusic.mediaItem then
        return getText("IGUI_media_removeMedia");
    else
        local inv = self.player:getInventory();
        local type = self.deviceData:getMediaType();
        local medias = {};
        if type==1 then
            local list = inv:FindAll("Base.Disc_Retail");
            for i=0,list:size()-1 do
                table.insert(medias, list:get(i));
            end
        end
        if type==0 then
            local list = inv:FindAll("Base.VHS_Retail");
            for i=0,list:size()-1 do
                table.insert(medias, list:get(i));
            end
            local list = inv:FindAll("Base.VHS_Home");
            for i=0,list:size()-1 do
                table.insert(medias, list:get(i));
            end
        end

        if #medias>0 then
            return getText("IGUI_media_addMedia");
        end
    end
    return nil;
end
function TCRWMMedia:getXPrompt()
    return nil;
end
function TCRWMMedia:getYPrompt()
    return nil;
end


function TCRWMMedia:new (x, y, width, height)
    local o = RWMPanel:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self
    o.x = x;
    o.y = y;
    o.background = true;
    o.backgroundColor = {r=0, g=0, b=0, a=0.0};
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
    o.width = width;
    o.height = height;
    o.anchorLeft = true;
    o.anchorRight = false;
    o.anchorTop = true;
    o.anchorBottom = false;
    o.fontheight = getTextManager():MeasureStringY(UIFont.Small, "AbdfghijklpqtyZ")+2;
    o.cdTex = getTexture("media/textures/TCRWMMedia/TCVinylrecord.png");
    o.tapeTex = getTexture("media/textures/TCRWMMedia/TCTape.png");
    o.mediaIndex = -9999;
    o.mediaText = "";
    o.idleText = getText("IGUI_media_idle");
    o.lcdBlue = {
        text = { r=0.039, g=0.180, b=0.2, a=1.0 },
        back = { r=0.172, g=0.686, b=0.764, a=1.0 }
    };
    o.lcdGreen = {
        text = { r=0.180, g=0.2, b=0.039, a=1.0 },
        back = { r=0.686, g=0.764, b=0.172, a=1.0 },
    };
    o.textPlay = getText("IGUI_media_play");
    o.textStop = getText("IGUI_media_stop");
    o.textNoCD = getText("IGUI_media_nocd");
    o.textNoTape = getText("IGUI_media_notape");
    return o
end

