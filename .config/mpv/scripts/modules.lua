-- Script module loader.
-- Loads files from script_modules/ if present; missing modules are skipped silently.
local mpv_config_dir_path = require("mp").command_native({"expand-path", "~~/"})
function load(relative_path)
    local module_path = mpv_config_dir_path .. "/script_modules/" .. relative_path
    local file = io.open(module_path, "r")
    if file ~= nil then
        file:close()
        dofile(module_path)
    end
end
load("mpvSockets/mpvSockets.lua")
