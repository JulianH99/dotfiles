---------------------------------------------------------------------------
--- Additional hotkeys for awful.hotkeys_widget
--
-- @author Yauheni Kirylau &lt;yawghen@gmail.com&gt;
-- @copyright 2014-2015 Yauheni Kirylau
-- @submodule awful.hotkeys_popup
---------------------------------------------------------------------------

local keys = {
	vim = require("awful.hotkeys_popup.keys.vim"),
	firefox = require("awful.hotkeys_popup.keys.firefox"),
}
return keys
