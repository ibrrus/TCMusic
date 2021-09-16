require "ISUI/ISInventoryPage"

function ISInventoryPage:initialise()
	self.musictape = getTexture("media/ui/Container_Musictape.png")
	self.containerIconMaps["tcmusic"] = self.musictape
	ISPanel.initialise(self);
	-- print ("[TSARCRAFT] - INVENTORY UPDATE")
end

