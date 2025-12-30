-- ====================================================================
-- Entry point
-- ====================================================================
-- Keep init.lua tiny. Bootstrapping + plugin spec lives in lua/config/lazy.lua.
-- Everything else goes in lua/config/* and lua/plugins/*.
require("config.lazy")
